defmodule ExTappd.CustomSection do
  # use ExTappd.Response
  import ExTappd.Helpers

  alias ExTappd.Client

  defstruct ~w[
    id
    custom_menu_id
    position
    name
    description
    created_at
    updated_at
  ]a
end
