defmodule Scraper.AnalysisUtil do
  @moduledoc false

  def send_status(status, job_id) do
    IO.puts "sending status"
    token = "XXXXX"
    #    headers = [{:"Authorization", "Bearer " <> token}, {:"Content-Type", "application/json"}]
    headers = [{:"Content-Type", "application/json"}]
    body = Jason.encode!(
      %{
        "job_status" => status
      }
    )
    HTTPoison.patch(Application.get_env(:scraper, ScraperWeb.Endpoint)[:analysis_server]<>"jobs/#{job_id}/", body, headers)
  end

  def send_partial_result(content, title, job_id, is_last_google_article, is_user_article) do
    IO.puts "sending partial result"
    token = "XXX"
    #    headers = [{:"Authorization", "Bearer " <> token}, {:"Content-Type", "application/json"}]
    headers = [{:"Content-Type", "application/json"}]
    body = Jason.encode!(
      %{
        "analysis_instance"=> job_id,
        "title"=> title,
        "content"=> content,
        "is_last_google_article"=> is_last_google_article,
        "is_user_article"=> is_user_article
      })
    HTTPoison.post(Application.get_env(:scraper, ScraperWeb.Endpoint)[:analysis_server] <> "scraping/", body, headers)
    IO.puts "partial result sent"
  end

end
