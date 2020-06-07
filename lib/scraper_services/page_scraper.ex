defmodule Scraper.PageScraper do
  require Logger
  @moduledoc false

  def scrape_page(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        content =
          body
          |> Floki.find("p")
          |> Floki.text()
        IO.puts "returning scraped content"
        content
      {:ok, %HTTPoison.Response{status_code: 404}} -> Logger.error "Page not found URL:" <> url
      {:error, %HTTPoison.Error{reason: reason}} -> "empty"
      _ -> Logger.error "Can't scrape this page URL:" <> url
    end
  end
end
