defmodule Scraper.AnalysisUtil do
  @moduledoc false

  def send_status(status, token) do
    headers = [{:"Authorization", "Bearer " <> token}, {:"Content-Type", "application/json"}]
    body =
      %{
        status: status
      }
    HTTPoison.patch("serverUrl", body, headers)
  end

  def send_result(url_content, google_search_result, token) do
    headers = [{:"Authorization", "Bearer " <> token}, {:"Content-Type", "application/json"}]
    body =
      %{
        url_content: url_content,
        google_search_result: google_search_result
      }
    HTTPoison.post("server_url", body, headers)
  end

end
