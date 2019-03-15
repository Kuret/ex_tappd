defmodule ExTappd.Container do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    item_id
    container_size_id
    price
    position
    created_at
    updated_at
    container_size
  ]a

  defmodule Type do
    defstruct ~w[
      container_size_group_id
      created_at
      id
      name
      ounces
      position
      updated_at
    ]a
  end

  def list_container_types() do
    "/container_sizes" |> Client.get() |> handle_response()
  end

  def list_containers(item_id) do
    "/items/#{item_id}/containers" |> Client.get() |> handle_response()
  end

  def get_container(container_id) do
    "/containers/#{container_id}" |> Client.get() |> handle_response()
  end

  def create_container(item_id, container_type_id, price)
      when is_integer(container_type_id) and is_float(price) do
    body = %{container_size_id: container_type_id, price: price} |> encode_body()

    "/items/#{item_id}/containers" |> Client.post(body) |> handle_response()
  end

  @doc """
    Updates a container
    Valid attributes are:
      container_size_id: id of the container type
      price: price of the container
      position: position in the container list
  """
  def update_container(container_id, %{} = attrs) do
    body = encode_body(attrs)

    "/containers/#{container_id}" |> Client.put(body) |> handle_response()
  end

  def remove_container(container_id) do
    "/containers/#{container_id}" |> Client.delete() |> handle_response()
  end

  defp build_response(%{"container_sizes" => [_ | _] = container_sizes}) do
    Enum.map(container_sizes, &to_struct(__MODULE__.Type, &1))
  end

  defp build_response(%{"containers" => containers}) when is_list(containers) do
    Enum.map(containers, &to_struct(__MODULE__, &1))
  end

  defp build_response(%{"container" => container}),
    do: to_struct(__MODULE__, container) |> to_struct(__MODULE__.Type, :container_size)

  defp build_response(body), do: {:error, body}
end
