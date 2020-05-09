defmodule Scraper.PageScraper do
  @moduledoc false

  def scrape_page(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        content =
          body
          |> Floki.text()

        {:ok, content}
      {:ok, %HTTPoison.Response{status_code: 404}} -> IO.puts "Page not found"
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
    end
  end
end
