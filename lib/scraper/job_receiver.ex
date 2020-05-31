defmodule Scraper.Consumer do
  use GenServer
  use AMQP

  def start_link(_otps) do
    GenServer.start_link(__MODULE__, [], [])
  end

  #@exchange    "gen_server_test_exchange"
  @queue       "hello2"
  #@queue_error "#{@queue}_error"

  def init(_opts) do
    {:ok, conn} = Connection.open("amqp://zdblkbpl:LdADoprUeh9MViM85YcwsuIKYRhU6DJs@eagle.rmq.cloudamqp.com/zdblkbpl")
    {:ok, chan} = Channel.open(conn)
    setup_queue(chan)

    # Limit unacknowledged messages to 10
    :ok = Basic.qos(chan, prefetch_count: 10)
    # Register the GenServer process as a consumer
    {:ok, _consumer_tag} = Basic.consume(chan, @queue)
    {:ok, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    # You might want to run payload consumption in separate Tasks in production
    consume(chan, tag, redelivered, payload)
    {:noreply, chan}
  end

  defp setup_queue(chan) do
    #{:ok, _} = Queue.declare(chan, @queue_error, durable: true)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    {:ok, _} = Queue.declare(
      chan,
      @queue,
      durable: true
    )
    #:ok = Exchange.fanout(chan, @exchange, durable: true)
    #:ok = Queue.bind(chan, @queue, @exchange)
  end

  defp consume(channel, tag, redelivered, payload) do
    # number = String.to_integer(payload)

    job = Jason.decode!(payload)
    #    if number <= 10 do
    :ok = Basic.ack channel, tag
    IO.puts "job id: #{job["job_id"]}"
    IO.puts "url: #{job["url"]}"
    IO.puts "query: #{job["query"]}"
#    :ok = Basic.ack channel, tag
#    :timer.sleep(:timer.seconds(20))
    result = Scraper.JobHandler.handle_scraper_job(job["url"], job["query"], job["job_id"], job["jwt_token"])
    IO.puts "job finished"
    #    else
    #      :ok = Basic.reject channel, tag, requeue: false
    #      IO.puts "#{number} is too big and was rejected."
    #    end

  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise consumer will stop
    # receiving messages.
    exception ->
      :ok = Basic.reject channel, tag, requeue: not redelivered
      IO.puts "Internal Error in scraping module"
  end

end
