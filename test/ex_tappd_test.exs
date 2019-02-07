defmodule ExTappdTest do
  use ExUnit.Case
  doctest ExTappd

  test "greets the world" do
    assert ExTappd.hello() == :world
  end
end
