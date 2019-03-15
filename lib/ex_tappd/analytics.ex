defmodule ExTappd.Analytics do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  def add_event(event_name, location_id \\ ExTappd.default_location()) do
    "/locations/#{location_id}/analytics?source_name=#{event_name}"
    |> Client.get()
    |> handle_response()
  end

  defp build_response(%{"status" => "OK"}), do: :event_added
  defp build_response(body), do: {:error, body}
end
