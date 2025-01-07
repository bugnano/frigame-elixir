defmodule FriGame.Rect do
  import FriGame.Utils, only: [clamp: 3]

  use TypedStruct

  @type rect_pos_x() :: :left | :right | :centerx
  @type rect_pos_y() :: :top | :bottom | :centery

  typedstruct do
    field(:left, number(), default: 0)
    field(:top, number(), default: 0)
    field(:width, number(), default: 0)
    field(:height, number(), default: 0)
    field(:last_x, rect_pos_x(), default: :left)
    field(:last_y, rect_pos_y(), default: :top)
  end

  def left(%__MODULE__{} = rect) do
    rect.left
  end

  def left(%__MODULE__{} = rect, value) when is_number(value) do
    %__MODULE__{rect | left: value, last_x: :left}
  end

  def right(%__MODULE__{} = rect) do
    rect.left + rect.width
  end

  def right(%__MODULE__{} = rect, value) when is_number(value) do
    %__MODULE__{rect | left: value - rect.width, last_x: :right}
  end

  def centerx(%__MODULE__{} = rect) do
    rect.left + rect.width / 2.0
  end

  def centerx(%__MODULE__{} = rect, value) when is_number(value) do
    %__MODULE__{rect | left: value - rect.width / 2.0, last_x: :centerx}
  end

  def top(%__MODULE__{} = rect) do
    rect.top
  end

  def top(%__MODULE__{} = rect, value) when is_number(value) do
    %__MODULE__{rect | top: value, last_y: :top}
  end

  def bottom(%__MODULE__{} = rect) do
    rect.top + rect.height
  end

  def bottom(%__MODULE__{} = rect, value) when is_number(value) do
    %__MODULE__{rect | top: value - rect.height, last_y: :bottom}
  end

  def centery(%__MODULE__{} = rect) do
    rect.top + rect.height / 2.0
  end

  def centery(%__MODULE__{} = rect, value) when is_number(value) do
    %__MODULE__{rect | top: value - rect.height / 2.0, last_y: :centery}
  end

  def width(%__MODULE__{} = rect) do
    rect.width
  end

  def width(%__MODULE__{} = rect, value) when is_number(value) do
    old_x = apply(__MODULE__, rect.last_x, [rect])

    %__MODULE__{rect | width: value}
    |> then(fn rect -> apply(__MODULE__, rect.last_x, [rect, old_x]) end)
  end

  def half_width(%__MODULE__{} = rect) do
    rect.width / 2.0
  end

  def half_width(%__MODULE__{} = rect, value) when is_number(value) do
    old_x = apply(__MODULE__, rect.last_x, [rect])

    %__MODULE__{rect | width: value * 2}
    |> then(fn rect -> apply(__MODULE__, rect.last_x, [rect, old_x]) end)
  end

  def height(%__MODULE__{} = rect) do
    rect.height
  end

  def height(%__MODULE__{} = rect, value) when is_number(value) do
    old_y = apply(__MODULE__, rect.last_y, [rect])

    %__MODULE__{rect | height: value}
    |> then(fn rect -> apply(__MODULE__, rect.last_y, [rect, old_y]) end)
  end

  def half_height(%__MODULE__{} = rect) do
    rect.height / 2.0
  end

  def half_height(%__MODULE__{} = rect, value) when is_number(value) do
    old_y = apply(__MODULE__, rect.last_y, [rect])

    %__MODULE__{rect | height: value * 2}
    |> then(fn rect -> apply(__MODULE__, rect.last_y, [rect, old_y]) end)
  end

  def radius(%__MODULE__{} = rect) do
    max(rect.width, rect.height) / 2.0
  end

  def radius(%__MODULE__{} = rect, value) when is_number(value) do
    old_x = apply(__MODULE__, rect.last_x, [rect])
    old_y = apply(__MODULE__, rect.last_y, [rect])

    new_value = value * 2

    %__MODULE__{rect | width: new_value, height: new_value}
    |> then(fn rect -> apply(__MODULE__, rect.last_x, [rect, old_x]) end)
    |> then(fn rect -> apply(__MODULE__, rect.last_y, [rect, old_y]) end)
  end

  # Collision detection

  def collide_rect(%__MODULE__{} = a, %__MODULE__{} = b) do
    not (bottom(a) <= top(b) or
           top(a) >= bottom(b) or
           left(a) >= right(b) or
           right(a) <= left(b))
  end

  def collide_rect_point(%__MODULE__{} = a, x, y) when is_number(x) and is_number(y) do
    x >= left(a) and x < right(a) and y >= top(a) and y < bottom(a)
  end

  def collide_rect_circle(%__MODULE__{} = a, %__MODULE__{} = b) do
    cx = centerx(b)
    cy = centery(b)
    r = radius(b)
    nearest_x = clamp(cx, left(a), right(a))
    nearest_y = clamp(cy, top(a), bottom(a))
    dx = cx - nearest_x
    dy = cy - nearest_y

    dx * dx + dy * dy < r * r
  end

  def collide_circle(%__MODULE__{} = a, %__MODULE__{} = b) do
    dx = centerx(b) - centerx(a)
    dy = centery(b) - centery(a)
    radii = radius(a) + radius(b)

    dx * dx + dy * dy < radii * radii
  end

  def collide_circle_point(%__MODULE__{} = a, x, y) when is_number(x) and is_number(y) do
    dx = x - centerx(a)
    dy = y - centery(a)
    radius = radius(a)

    dx * dx + dy * dy < radius * radius
  end

  def collide_circle_rect(%__MODULE__{} = a, %__MODULE__{} = b) do
    cx = centerx(a)
    cy = centery(a)
    r = radius(a)
    nearest_x = clamp(cx, left(b), right(b))
    nearest_y = clamp(cy, top(b), bottom(b))
    dx = cx - nearest_x
    dy = cy - nearest_y

    dx * dx + dy * dy < r * r
  end
end
