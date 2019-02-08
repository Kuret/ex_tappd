defmodule ExTappd.Barcode do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  def get_product(barcode) do
    "https://world.openfoodfacts.org/api/v0/product/#{barcode}.json"
    |> Client.get()
    |> handle_response()
  end

  defp build_response(body) do
    with %{
           "product" => %{
             "brands" => brand,
             "product_name_en" => product_name
           },
           "status" => 1
         } <- body do
      {:ok, %{product: product_name, brand: brand}}
    else
      _ -> {:error, :not_found}
    end
  end
end
