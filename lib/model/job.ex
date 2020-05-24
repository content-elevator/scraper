defmodule Scraper.Job do
  @moduledoc false
  @derive Jason.Encoder

  defstruct  job_id: Integer,
             url: String,
             query: String
end
