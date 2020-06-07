defmodule Scraper.AnalysisUtil do
  require Phoenix.Logger
  @moduledoc false

  def send_status(status, job_id, jwt_token) do
    Logger.info "sending status"
    headers = ["Authorization": "Bearer #{jwt_token}", "Content-Type": "Application/json"]
    # headers = [{:"Content-Type", "application/json"}]
    body = Jason.encode!(
      %{
        "job_status" => status
      }
    )
    HTTPoison.patch(
      Application.get_env(:scraper, ScraperWeb.Endpoint)[:analysis_server] <> "jobs/#{job_id}/",
      body,
      headers
    )
    Logger.info "Status sent."
  end

  def send_partial_result(content, title, job_id, jwt_token, is_last_google_article, is_user_article) do
    Logger.info "sending partial result"
    headers = ["Authorization": "Bearer #{jwt_token}", "Content-Type": "Application/json"]
    # headers = [{:"Content-Type", "application/json"}]
    body = Jason.encode!(
      %{
        "analysis_instance" => job_id,
        "title" => title,
        "content" => content,
        "is_last_google_article" => is_last_google_article,
        "is_user_article" => is_user_article
      }
    )
    HTTPoison.post(
      Application.get_env(:scraper, ScraperWeb.Endpoint)[:analysis_server] <> "scraping/",
      body,
      headers
    )
    Logger.info "partial result sent.";
  end
end

