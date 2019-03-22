defmodule ExTappd.CustomItem do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    custom_section_id
    position
    name
    description
    type
    custom_item_type_id
    image_url_for_type
    created_at
    updated_at
  ]a

  defmodule Type do
    defstruct ~w[
      id
      name
      created_at
      updated_at
    ]a
  end

  def list_custom_item_types() do
    "/custom_item_types" |> Client.get() |> handle_response()
  end

  def list_custom_items(custom_section_id) do
    "/custom_sections/#{custom_section_id}/custom_items" |> Client.get() |> handle_response()
  end

  def get_custom_item(custom_item_id) do
    "/custom_items/#{custom_item_id}" |> Client.get() |> handle_response()
  end

  def create_custom_item(custom_section_id, name, description, custom_item_type_id)
      when is_bitstring(name) and is_bitstring(description) and is_integer(custom_item_type_id) do
    body =
      %{name: name, description: description, custom_item_type_id: custom_item_type_id}
      |> encode_body()

    "/custom_sections/#{custom_section_id}/custom_items" |> Client.post(body) |> handle_response()
  end

  @doc """
    Updates a custom item
    Valid attributes are:
      name: name of the custom item
      description: description of the custom item
      custom_item_type_id: id of the custom item type
  """
  def update_custom_item(custom_item_id, %{} = attrs) do
    body = encode_body(attrs)

    "/custom_items/#{custom_item_id}" |> Client.put(body) |> handle_response()
  end

  @doc """
    Updates the position of custom items
    Requires a list containing maps with id and position:
      [%{id: 1, position: 3}, %{id: 3, position: 2}]
  """
  def update_custom_item_positions(custom_section_id, positions) when is_list(positions) do
    body = encode_body(positions)

    "/custom_sections/#{custom_section_id}/custom_items/positions"
    |> Client.patch(body)
    |> handle_response()
  end

  def update_custom_item_section(custom_item_id, custom_section_id) do
    body = %{custom_section_id: custom_section_id} |> encode_body()

    "/custom_items/#{custom_item_id}/move" |> Client.patch(body) |> handle_response()
  end

  def remove_custom_item(custom_item_id) do
    "/custom_items/#{custom_item_id}" |> Client.delete() |> handle_response()
  end

  defp build_response(%{"custom_item_types" => item_types}) when is_list(item_types),
    do: Enum.map(item_types, &to_struct(__MODULE__.Type, &1))

  defp build_response(%{"custom_item" => item}), do: to_struct(__MODULE__, item)

  defp build_response(%{"custom_items" => items}) when is_list(items),
    do: Enum.map(items, &to_struct(__MODULE__, &1))

  defp build_response(body), do: {:error, body}
end
