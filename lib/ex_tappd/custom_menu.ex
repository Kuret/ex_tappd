defmodule ExTappd.CustomMenu do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    location_id
    name
    description
    unpublished
    created_at
    updated_at
    position
  ]a

  def list_custom_menus(location_id \\ ExTappd.default_location()) do
    "/locations/#{location_id}/custom_menus" |> Client.get() |> handle_response()
  end

  def get_custom_menu(custom_menu_id) do
    "/custom_menus/#{custom_menu_id}" |> Client.get() |> handle_response()
  end

  def get_custom_menu(custom_menu_id, :with_analytics, source \\ nil) do
    url = "/custom_menus/#{custom_menu_id}?full=true"
    if source, do: url = url <> "&source_name=#{source}"

    url |> Client.get() |> handle_response()
  end

  def create_custom_menu(%{} = attrs, location_id \\ ExTappd.default_location()) do
    body = encode_body(attrs)

    "/locations/#{location_id}/custom_menus" |> Client.post(body) |> handle_response()
  end

  def update_custom_menu(custom_menu_id, %{} = attrs) do
    body = encode_body(attrs)

    "/custom_menus/#{custom_menu_id}" |> Client.put(body) |> handle_response()
  end

  def remove_custom_menu(custom_menu_id) do
    "/custom_menus/#{custom_menu_id}" |> Client.delete() |> handle_response()
  end

  defp build_response(%{"custom_menu" => menu}), do: to_struct(__MODULE__, menu)

  defp build_response(%{"custom_menus" => menus}) when is_list(menus),
    do: Enum.map(menus, &to_struct(__MODULE__, &1))

  defp build_response(body), do: {:error, body}
end
