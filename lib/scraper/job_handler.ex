defmodule JobHandler do
  @moduledoc false

  def handle_scraper_job(url, query, token) do
    # send RECEIVED status for analyzer
    Scraper.AnalysisUtil.send_status("RECEIVED", token)

    url_content = Scraper.PageScraper.scrape_page(url)
    # send URL_SCRAPING_COMPLETED, status for analyzer
    Scraper.AnalysisUtil.send_status("URL_SCRAPING_COMPLETED", token)

    google_search_result = Scraper.GoogleSearchScraper.get_urls_from_search(query)
    # send URL_SCRAPING_COMPLETED, status for analyzer
    Scraper.AnalysisUtil.send_status("GOOGLE_SCRAPING_COMPLETED", token)

    # send result
    Scraper.AnalysisUtil.send_result(url_content, google_search_result, token)
  end

end
