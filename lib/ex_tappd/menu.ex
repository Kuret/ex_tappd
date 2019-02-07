defmodule ExTappd.Menu do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
   created_at
    description
    draft
    footer
    id
    location_id
    name
    position
    push_notification_frequency
    show_price_on_untappd
    unpublished
    updated_at
    uuid
  ]a

  def get_menu(id) when is_integer(id) do
    "/menus/#{id}" |> Client.get() |> handle_response()
  end

  def get_menu(_), do: {:error, "Invalid id"}

  def get_menu(id, source) when is_integer(id) and is_binary(source) do
    "/menus/#{id}?full=true&source_name=#{source}" |> Client.get() |> handle_response()
  end

  def get_menu(_, _), do: {:error, "Invalid id or source name"}

  defp build_response(body), do: to_struct(__MODULE__, body)
end
