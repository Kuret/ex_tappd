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

  def list_menus(location_id) do
    "/locations/#{location_id}/menus" |> Client.get() |> handle_response()
  end

  def get_menu(id) do
    "/menus/#{id}" |> Client.get() |> handle_response()
  end

  def get_menu(id, source) do
    "/menus/#{id}?full=true&source_name=#{source}" |> Client.get() |> handle_response()
  end

  defp build_response(%{"menu" => menu}), do: to_struct(__MODULE__, menu)

  defp build_response(%{"menus" => [_ | _] = menus}) do
    Enum.map(menus, &to_struct(__MODULE__, &1))
  end

  defp build_response(body), do: {:error, body}
end
