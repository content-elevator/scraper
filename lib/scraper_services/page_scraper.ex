defmodule Scraper.PageScraper do
  @moduledoc false

  def scrape_page(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        content =
          body
          |> Floki.find("p")
          |> Floki.text()

        content
      {:ok, %HTTPoison.Response{status_code: 404}} -> IO.puts "Page not found URL:" <> url
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
      _ -> IO.puts "Can't scrape this page URL:" <> url
    end
  end
end
