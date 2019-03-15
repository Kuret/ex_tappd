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

      def handle_response({_, %HTTPoison.Response{status_code: 400}}), do: {:error, :bad_request}
      def handle_response({_, %HTTPoison.Response{status_code: 401}}), do: {:error, :unauthorized}
      def handle_response({_, %HTTPoison.Response{status_code: 403}}), do: {:error, :forbidden}
      def handle_response({_, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_found}

      def handle_response({_, %HTTPoison.Response{status_code: 405}}),
        do: {:error, :method_not_allowed}

      def handle_response({_, %HTTPoison.Response{status_code: 406}}),
        do: {:error, :format_not_acceptible}

      def handle_response({_, %HTTPoison.Response{status_code: 410}}),
        do: {:error, :resource_removed}

      def handle_response({_, %HTTPoison.Response{status_code: 418}}),
        do: {:error, :i_am_a_teapot}

      def handle_response({_, %HTTPoison.Response{status_code: 500}}),
        do: {:error, :internal_server_error}

      def handle_response({_, %HTTPoison.Response{status_code: 500}}),
        do: {:error, :service_unavailable}

      def handle_response({:ok, %HTTPoison.Response{status_code: _code, body: body} = resp}) do
        response = body |> Poison.decode!() |> build_response

        with {:error, _} <- response, do: response, else: (_ -> {:ok, response})
      end
    end
  end
end
