defmodule ExTappd do
  @moduledoc """
  Documentation for ExTappd.
  """

  def rw_credentials, do: :base64.encode("#{api_user()}:#{rw_api_key()}")
  def ro_credentials, do: :base64.encode("#{api_user()}:#{ro_api_key()}")

  def base_url, do: Application.get_env(:ex_tappd, :base_url)
  def api_user, do: Application.get_env(:ex_tappd, :api_user)

  defp rw_api_key, do: Application.get_env(:ex_tappd, :rw_api_key)
  defp ro_api_key, do: Application.get_env(:ex_tappd, :ro_api_key)
end
