defmodule ExTappd.CustomContainer do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    custom_item_id
    name
    price
    position
    created_at
    updated_at
  ]a

  def list_custom_containers(custom_item_id) do
    "/custom_items/#{custom_item_id}/custom_containers" |> Client.get() |> handle_response()
  end

  def get_custom_container(custom_container_id) do
    "/custom_containers/#{custom_container_id}" |> Client.get() |> handle_response()
  end

  def create_custom_container(custom_item_id, name, price)
      when is_bitstring(name) and is_float(price) do
    body = %{name: name, price: price} |> encode_body()

    "/custom_items/#{custom_item_id}/custom_containers" |> Client.post(body) |> handle_response()
  end

  @doc """
    Updates a custom container
    Valid attributes are:
      name: name of the container
      price: price of the container
      position: position in the container list
  """
  def update_custom_container(custom_container_id, %{} = attrs) do
    body = encode_body(attrs)

    "/custom_containers/#{custom_container_id}" |> Client.put(body) |> handle_response()
  end

  def remove_custom_container(custom_container_id) do
    "/custom_containers/#{custom_container_id}" |> Client.delete() |> handle_response()
  end

  defp build_response(%{"custom_container" => container}), do: to_struct(__MODULE__, container)

  defp build_response(%{"custom_containers" => containers}) when is_list(containers),
    do: Enum.map(containers, &to_struct(__MODULE__, &1))

  defp build_response(body), do: {:error, body}
end
