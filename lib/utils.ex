defmodule FriGame.Utils do
  def clamp(n, min_val, max_val)
      when is_number(n) and is_number(min_val) and is_number(max_val),
      do: n |> max(min_val) |> min(max_val)
end
