defmodule ExTappd.Helpers do
  @moduledoc false

  def query_string(nil), do: ""
  def query_string([]), do: ""
  def query_string(param) when is_binary(param), do: URI.encode(param)
  def query_string(params), do: "?" <> URI.encode_query(params)

  def encode_body(%{} = body), do: Poison.encode!(body)
  def encode_body(body) when is_binary(body) or is_list(body), do: Poison.encode!(body)

  @doc """
  Converts a map of string keys to a map of atoms and turns it into a struct
  """
  def to_struct(struct, kind, key), do: Map.update!(struct, key, &to_struct(kind, &1))

  def to_struct(kind, attrs) do
    struct = struct(kind)

    struct
    |> Map.to_list()
    |> Enum.reduce(struct, fn {key, _}, acc ->
      result = Map.fetch(attrs, Atom.to_string(key))

      case result do
        {:ok, value} -> %{acc | key => value}
        :error -> acc
      end
    end)
  end
end
