defmodule ExTappd.User do
  use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    email
    created_at
    updated_at
    role
    admin
    business_id
    untappd_username
    name
  ]a

  def current_user() do
    "/current_user" |> Client.get() |> handle_response()
  end

  defp build_response(%{"current_user" => user}), do: to_struct(__MODULE__, user)
  defp build_response(body), do: {:error, body}
end
