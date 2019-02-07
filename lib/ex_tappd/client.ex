defmodule ExTappd.Client do
  @moduledoc false

  def get(uri) do
    uri
    |> format_url()
    |> HTTPoison.get(ro_headers())
  end

  defp format_url(uri) do
    ExTappd.base_url() <> uri
  end

  defp ro_headers do
    [{"Authorization", "Basic #{ExTappd.ro_credentials()}"}]
  end

  defp rw_headers do
    [
      {"Authorization", "Basic #{ExTappd.rw_credentials()}"},
      {"Content-Type", "application/json"}
    ]
  end
end
