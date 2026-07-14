defmodule FriGame.Utils do
  def clamp(n, min_val, max_val)
      when is_number(n) and is_number(min_val) and is_number(max_val),
      do: n |> max(min_val) |> min(max_val)

  # t = (x - x0) / (x1 - x0)
  def lerp(y0, y1, t) when is_number(y0) and is_number(y1) and is_number(t),
    do: y0 + t * (y1 - y0)
end
