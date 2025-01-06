defmodule FriGameTest do
  use ExUnit.Case
  doctest FriGame

  test "greets the world" do
    assert FriGame.hello() == :world
  end
end
