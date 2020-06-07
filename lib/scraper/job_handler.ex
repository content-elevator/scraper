defmodule Scraper.JobHandler do
  require Phoenix.Logger
  @moduledoc false

  def handle_scraper_job(url, query, job_id, jwt_token) do
    Logger.info "started scraping"

    # send RECEIVED status for analyzer
    Scraper.AnalysisUtil.send_status("RECEIVED", job_id, jwt_token)
    Logger.info "status received sent"

    # send URL_SCRAPING_COMPLETED, status for analyzer
    Scraper.AnalysisUtil.send_status("URL_SCRAPING_STARTED", job_id, jwt_token)
    url_content = Scraper.PageScraper.scrape_page(url)
    Scraper.AnalysisUtil.send_partial_result(url_content, "title", job_id, jwt_token, false, true)
    # send GOOGLE_SCRAPING_STARTED, status for analyzer
    Scraper.AnalysisUtil.send_status("GOOGLE_SCRAPING_STARTED", job_id, jwt_token)
    Logger.info "status url scraping completed sent"
    Scraper.GoogleSearchScraper.get_urls_from_search(query, job_id, jwt_token)
    Scraper.AnalysisUtil.send_partial_result("empty", "empty", job_id, jwt_token, true, false)

    Logger.info "scraping completed"

  end

end
