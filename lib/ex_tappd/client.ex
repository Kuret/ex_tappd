defmodule ExTappd.Client do
  @moduledoc false

  def get(uri) do
    uri
    |> format_url()
    |> HTTPoison.get(ro_headers())
  end

  def post(uri, body) when is_binary(body) do
    uri
    |> format_url()
    |> HTTPoison.post(body, rw_headers())
  end

  def put(uri, body) when is_binary(body) do
    uri
    |> format_url()
    |> HTTPoison.put(body, rw_headers())
  end

  def patch(uri, body) when is_binary(body) do
    uri
    |> format_url()
    |> HTTPoison.patch(body, rw_headers())
  end

  def delete(uri) do
    uri
    |> format_url()
    |> HTTPoison.delete(rw_headers())
  end

  defp format_url(uri) do
    case String.starts_with?(uri, "http") do
      true -> uri
      false -> ExTappd.base_url() <> uri
    end
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
