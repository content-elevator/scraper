defmodule Scraper.GoogleSearchScraper do
  require Logger
  @moduledoc false

  def get_urls_from_search(query, job_id, jwt_token) do
    Logger.info "starting google search scraping"
    good_query = String.replace(query, " ", "+")
    case HTTPoison.get("https://www.google.com/search?q=" <> good_query) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.find("a")
        |> Floki.attribute("href")
        |> Enum.filter(fn (x) -> String.starts_with?(x, "/url?q=") end)
        |> Enum.filter(fn (x) -> String.contains?(x, ["google", "youtube"]) == false end)
        |> Enum.map(fn (x) -> String.slice(x, 7..-1) end)
        |> Enum.map(fn (x) -> String.split(x, "&") end)
        |> Enum.map(fn (x) -> Enum.at(x, 0) end)
        |> Enum.map(fn (x) -> URI.decode(x) end)
        |> Enum.map(fn (x) -> Scraper.PageScraper.scrape_page(x) end)
        |> Enum.map(
             fn (x) -> Scraper.AnalysisUtil.send_partial_result(x, "title", job_id, jwt_token, false, false) end
           )

      {:ok, %HTTPoison.Response{status_code: 404}} -> Logger.error "Page not found"
      {:error, %HTTPoison.Error{reason: reason}} -> Logger.error reason
    end
  end

end
