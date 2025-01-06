defmodule FriGame.Vec2 do
  use TypedStruct

  typedstruct do
    field(:x, number(), enforce: true)
    field(:y, number(), enforce: true)
  end

  def assign(x, y) when is_number(x) and is_number(y) do
    %__MODULE__{x: x, y: y}
  end

  def from_mag_angle(mag, angle) when is_number(mag) and is_number(angle) do
    %__MODULE__{x: :math.cos(angle) * mag, y: :math.sin(angle) * mag}
  end

  def random_unit() do
    angle = :rand.uniform() * :math.pi() * 2

    %__MODULE__{x: :math.cos(angle), y: :math.sin(angle)}
  end

  def random(scale \\ 1) when is_number(scale) do
    mag = :rand.uniform() * scale
    angle = :rand.uniform() * :math.pi() * 2

    %__MODULE__{x: :math.cos(angle) * mag, y: :math.sin(angle) * mag}
  end

  def add(%__MODULE__{} = a, %__MODULE__{} = b) do
    %__MODULE__{x: a.x + b.x, y: a.y + b.y}
  end

  def subtract(%__MODULE__{} = a, %__MODULE__{} = b) do
    %__MODULE__{x: a.x - b.x, y: a.y - b.y}
  end

  def scale(%__MODULE__{} = a, s) when is_number(s) do
    %__MODULE__{x: a.x * s, y: a.y * s}
  end

  def scale(%__MODULE__{} = a, sx, sy) when is_number(sx) and is_number(sy) do
    %__MODULE__{x: a.x * sx, y: a.y * sy}
  end

  def invert(%__MODULE__{} = a) do
    %__MODULE__{x: -a.x, y: -a.y}
  end

  def normalize(%__MODULE__{} = a) do
    mag = :math.sqrt(a.x * a.x + a.y * a.y)

    mag = if mag == 0, do: mag, else: 1.0 / mag

    %__MODULE__{x: a.x * mag, y: a.y * mag}
  end

  def rotate(%__MODULE__{} = a, angle) when is_number(angle) do
    x = a.x
    y = a.y
    ct = :math.cos(angle)
    st = :math.sin(angle)

    %__MODULE__{x: x * ct - y * st, y: y * ct + x * st}
  end

  def rotate_around_point(%__MODULE__{} = a, %__MODULE__{} = axis_point, angle)
      when is_number(angle) do
    a
    |> subtract(axis_point)
    |> rotate(angle)
    |> add(axis_point)
  end

  def scale_and_rotate(%__MODULE__{} = a, %__MODULE__{} = axis_point, angle, s)
      when is_number(angle) and is_number(s) do
    a
    |> subtract(axis_point)
    |> scale(s)
    |> rotate(angle)
    |> add(axis_point)
  end

  def scale_and_rotate(%__MODULE__{} = a, %__MODULE__{} = axis_point, angle, sx, sy)
      when is_number(angle) and is_number(sx) and is_number(sy) do
    a
    |> subtract(axis_point)
    |> scale(sx, sy)
    |> rotate(angle)
    |> add(axis_point)
  end

  def lerp(%__MODULE__{} = a, %__MODULE__{} = b, t) when is_number(t) do
    ax = a.x
    ay = a.y

    x = ax + t * (b.x - ax)
    y = ay + t * (b.y - ay)

    %__MODULE__{x: x, y: y}
  end

  def perp(%__MODULE__{} = a) do
    %__MODULE__{x: -a.y, y: a.x}
  end

  def magnitude(%__MODULE__{} = a) do
    :math.sqrt(a.x * a.x + a.y * a.y)
  end

  def squared_magnitude(%__MODULE__{} = a) do
    a.x * a.x + a.y * a.y
  end

  def azimuth(%__MODULE__{} = a) do
    :math.atan2(a.y, a.x)
  end

  def dot(%__MODULE__{} = a, %__MODULE__{} = b) do
    a.x * b.x + a.y * b.y
  end

  def determinant(%__MODULE__{} = a, %__MODULE__{} = b) do
    a.x * b.y - a.y * b.x
  end

  def equals(%__MODULE__{} = a, %__MODULE__{} = b) do
    a.x == b.x and a.y == b.y
  end

  def distance(%__MODULE__{} = a, %__MODULE__{} = b) do
    dx = a.x - b.x
    dy = a.y - b.y

    :math.sqrt(dx * dx + dy * dy)
  end

  def squared_distance(%__MODULE__{} = a, %__MODULE__{} = b) do
    dx = a.x - b.x
    dy = a.y - b.y

    dx * dx + dy * dy
  end

  def ceil(%__MODULE__{} = a) do
    %__MODULE__{x: Kernel.ceil(a.x), y: Kernel.ceil(a.y)}
  end

  def floor(%__MODULE__{} = a) do
    %__MODULE__{x: Kernel.floor(a.x), y: Kernel.floor(a.y)}
  end

  def round(%__MODULE__{} = a) do
    %__MODULE__{x: Kernel.round(a.x), y: Kernel.round(a.y)}
  end

  def trunc(%__MODULE__{} = a) do
    %__MODULE__{x: Kernel.trunc(a.x), y: Kernel.trunc(a.y)}
  end
end
