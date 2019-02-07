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
    created_at
    updated_at
  ]a

  def search_item(query) do
    "/items/search?q=#{query_string(query)}" |> Client.get() |> handle_response()
  end

  defp build_response(%{"item" => item}), do: to_struct(__MODULE__, item)

  defp build_response(%{"items" => [_ | _] = items}) do
    Enum.map(items, &to_struct(__MODULE__, &1))
  end

  defp build_response(body) do
    {:error, body}
  end
end
