defmodule ExTappd.Response do
  @moduledoc """
  Handles api responses from the client
  """

  defmacro __using__(_) do
    quote do
      def handle_response({:ok, %HTTPoison.Response{status_code: code, body: ""}})
          when code in 200..299,
          do: :ok

      def handle_response(
            {message, %HTTPoison.Response{status_code: 429, body: body, headers: headers}}
          ) do
        {retry_after, ""} =
          headers
          |> Enum.find(&(Kernel.elem(&1, 0) == "Retry-After"))
          |> Kernel.elem(1)
          |> Integer.parse()

        {message, Map.put(Poison.decode!(body), "meta", %{"retry_after" => retry_after})}
      end

      def handle_response({message, %HTTPoison.Response{status_code: code, body: body}})
          when code in 400..499 do
        {message, Poison.decode!(body)}
      end

      def handle_response({:ok, %HTTPoison.Response{status_code: _code, body: body}}) do
        response = body |> Poison.decode!() |> build_response

        {:ok, response}
      end
    end
  end
end
