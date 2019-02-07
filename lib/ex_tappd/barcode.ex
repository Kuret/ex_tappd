defmodule ExTappd.Barcode do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  def get_product(barcode) when is_binary(barcode) do
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
      IO.puts("Product found")
      IO.puts("Name: #{product_name}")
      IO.puts("Brand: #{brand}")
    else
      _ -> IO.puts("Product not found")
    end
  end
end
