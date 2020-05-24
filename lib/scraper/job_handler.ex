defmodule Scraper.JobHandler do
  @moduledoc false

  def handle_scraper_job(url, query, job_id) do
    # send RECEIVED status for analyzer
    #Scraper.AnalysisUtil.send_status("RECEIVED", token, job_id)

    url_content = Scraper.PageScraper.scrape_page(url)
    # send URL_SCRAPING_COMPLETED, status for analyzer
    #Scraper.AnalysisUtil.send_status("URL_SCRAPING_COMPLETED", token, job_id)
    IO.puts url_content

    google_search_result = Scraper.GoogleSearchScraper.get_urls_from_search(query)
    # send URL_SCRAPING_COMPLETED, status for analyzer
    #Scraper.AnalysisUtil.send_status("GOOGLE_SCRAPING_COMPLETED", token, job_id)
    IO.puts google_search_result
    IO.puts "success"

    # send result
    #Scraper.AnalysisUtil.send_result(url_content, google_search_result, token, job_id)
  end

end
