defmodule ExTappd.Item do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    section_id
    position
    untappd_id
    label_image
    brewery_location
    abv
    ibu
    cask
    nitro
    tap_number
    rating
    in_production
    untappd_beer_slug
    untappd_brewery_id
    name
    original_name
    custom_name
    description
    custom_description
    original_description
    style
    custom_style
    original_style
    brewery
    custom_brewery
    original_brewery
    created_ati
    updated_at
  ]a

  def list_section_items(section_id) do
    "/sections/#{section_id}/items" |> Client.get() |> handle_response()
  end

  def search_item(query) do
    "/items/search?q=#{query_string(query)}" |> Client.get() |> handle_response()
  end

  def add_item(item_id, section_id) do
    body = %{untappd_id: item_id} |> encode_body()

    "/sections/#{section_id}/items" |> Client.post(body) |> handle_response()
  end

  defp build_response(%{"item" => item}), do: to_struct(__MODULE__, item)

  defp build_response(%{"items" => [_ | _] = items}) do
    Enum.map(items, &to_struct(__MODULE__, &1))
  end

  defp build_response(body), do: {:error, body}

  def get_average_rating([%{rating: _} | _] = items) do
    items =
      items
      |> Enum.map(&parse_rating/1)
      |> Enum.reject(&is_nil(&1))

    if length(items) > 0 do
      Enum.sum(items) / length(items)
    else
      nil
    end
  end

  defp parse_rating(%{rating: rating}) do
    with {rating, _rest} <- Float.parse(rating),
         true <- rating > 0 do
      rating
    else
      _ -> nil
    end
  end
end
