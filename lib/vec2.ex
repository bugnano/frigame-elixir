defmodule FriGame.Vec2 do
  use TypedStruct

  typedstruct do
    field(:x, number(), enforce: true)
    field(:y, number(), enforce: true)
  end

  def from_values(x, y) when is_number(x) and is_number(y) do
    %__MODULE__{
      x: x,
      y: y
    }
  end

  def from_polar(mag, angle) when is_number(mag) and is_number(angle) do
    %__MODULE__{
      x: :math.cos(angle) * mag,
      y: :math.sin(angle) * mag
    }
  end

  def random_unit() do
    angle = :rand.uniform() * :math.pi() * 2

    %__MODULE__{
      x: :math.cos(angle),
      y: :math.sin(angle)
    }
  end

  def random(scalar \\ 1) when is_number(scalar) do
    mag = :rand.uniform() * scalar
    angle = :rand.uniform() * :math.pi() * 2

    %__MODULE__{
      x: :math.cos(angle) * mag,
      y: :math.sin(angle) * mag
    }
  end

  def add(%__MODULE__{} = a, %__MODULE__{} = b) do
    %__MODULE__{
      x: a.x + b.x,
      y: a.y + b.y
    }
  end

  def sub(%__MODULE__{} = a, %__MODULE__{} = b) do
    %__MODULE__{
      x: a.x - b.x,
      y: a.y - b.y
    }
  end

  def scale(%__MODULE__{} = a, scalar) when is_number(scalar) do
    %__MODULE__{
      x: a.x * scalar,
      y: a.y * scalar
    }
  end

  def scale(%__MODULE__{} = a, sx, sy) when is_number(sx) and is_number(sy) do
    %__MODULE__{
      x: a.x * sx,
      y: a.y * sy
    }
  end

  def invert(%__MODULE__{} = a) do
    %__MODULE__{
      x: -a.x,
      y: -a.y
    }
  end

  def normalize(%__MODULE__{} = a) do
    mag =
      case :math.sqrt(a.x * a.x + a.y * a.y) do
        mag when mag == 0 -> mag
        mag -> 1.0 / mag
      end

    %__MODULE__{
      x: a.x * mag,
      y: a.y * mag
    }
  end

  def rotate(%__MODULE__{} = a, angle) when is_number(angle) do
    x = a.x
    y = a.y
    ct = :math.cos(angle)
    st = :math.sin(angle)

    %__MODULE__{
      x: x * ct - y * st,
      y: x * st + y * ct
    }
  end

  def rotate_around_point(%__MODULE__{} = a, %__MODULE__{} = axis_point, angle)
      when is_number(angle) do
    a
    |> sub(axis_point)
    |> rotate(angle)
    |> add(axis_point)
  end

  def scale_and_rotate(%__MODULE__{} = a, %__MODULE__{} = axis_point, angle, scalar)
      when is_number(angle) and is_number(scalar) do
    a
    |> sub(axis_point)
    |> scale(scalar)
    |> rotate(angle)
    |> add(axis_point)
  end

  def scale_and_rotate(%__MODULE__{} = a, %__MODULE__{} = axis_point, angle, sx, sy)
      when is_number(angle) and is_number(sx) and is_number(sy) do
    a
    |> sub(axis_point)
    |> scale(sx, sy)
    |> rotate(angle)
    |> add(axis_point)
  end

  def lerp(%__MODULE__{} = a, %__MODULE__{} = b, t) when is_number(t) do
    ax = a.x
    ay = a.y

    %__MODULE__{
      x: ax + t * (b.x - ax),
      y: ay + t * (b.y - ay)
    }
  end

  def perp(%__MODULE__{} = a) do
    %__MODULE__{
      x: -a.y,
      y: a.x
    }
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

  def cross(%__MODULE__{} = a, %__MODULE__{} = b) do
    a.x * b.y - a.y * b.x
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

  def direction(%__MODULE__{} = a, %__MODULE__{} = b) do
    dx = b.x - a.x
    dy = b.y - a.y

    mag =
      case :math.sqrt(dx * dx + dy * dy) do
        mag when mag == 0 -> mag
        mag -> 1.0 / mag
      end

    %__MODULE__{
      x: dx * mag,
      y: dy * mag
    }
  end

  def project(%__MODULE__{} = a, %__MODULE__{} = b) do
    bx = b.x
    by = b.y

    dot_ab = a.x * bx + a.y * by

    squared_mag_b =
      case bx * bx + by * by do
        squared_mag_b when squared_mag_b == 0 -> squared_mag_b
        squared_mag_b -> 1.0 / squared_mag_b
      end

    scalar = dot_ab * squared_mag_b

    %__MODULE__{
      x: bx * scalar,
      y: by * scalar
    }
  end

  def abs(%__MODULE__{} = a) do
    %__MODULE__{
      x: Kernel.abs(a.x),
      y: Kernel.abs(a.y)
    }
  end

  def ceil(%__MODULE__{} = a) do
    %__MODULE__{
      x: Kernel.ceil(a.x),
      y: Kernel.ceil(a.y)
    }
  end

  def floor(%__MODULE__{} = a) do
    %__MODULE__{
      x: Kernel.floor(a.x),
      y: Kernel.floor(a.y)
    }
  end

  def round(%__MODULE__{} = a) do
    %__MODULE__{
      x: Kernel.round(a.x),
      y: Kernel.round(a.y)
    }
  end

  def trunc(%__MODULE__{} = a) do
    %__MODULE__{
      x: Kernel.trunc(a.x),
      y: Kernel.trunc(a.y)
    }
  end

  def equals(%__MODULE__{} = a, %__MODULE__{} = b) do
    a.x == b.x and a.y == b.y
  end
end
