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

  def add(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    %__MODULE__{
      x: ax + bx,
      y: ay + by
    }
  end

  def sub(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    %__MODULE__{
      x: ax - bx,
      y: ay - by
    }
  end

  def scale(%{x: ax, y: ay}, scalar) when is_number(ax) and is_number(ay) and is_number(scalar) do
    %__MODULE__{
      x: ax * scalar,
      y: ay * scalar
    }
  end

  def scale(%{x: ax, y: ay}, sx, sy)
      when is_number(ax) and is_number(ay) and is_number(sx) and is_number(sy) do
    %__MODULE__{
      x: ax * sx,
      y: ay * sy
    }
  end

  def invert(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: -ax,
      y: -ay
    }
  end

  def normalize(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    mag =
      case :math.sqrt(ax * ax + ay * ay) do
        mag when mag == 0 -> mag
        mag -> 1.0 / mag
      end

    %__MODULE__{
      x: ax * mag,
      y: ay * mag
    }
  end

  def rotate(%{x: ax, y: ay}, angle) when is_number(ax) and is_number(ay) and is_number(angle) do
    ct = :math.cos(angle)
    st = :math.sin(angle)

    %__MODULE__{
      x: ax * ct - ay * st,
      y: ax * st + ay * ct
    }
  end

  def rotate_around_point(%{x: ax, y: ay} = a, %{x: apx, y: apy} = axis_point, angle)
      when is_number(ax) and is_number(ay) and is_number(apx) and is_number(apy) and
             is_number(angle) do
    a
    |> sub(axis_point)
    |> rotate(angle)
    |> add(axis_point)
  end

  def scale_and_rotate(%{x: ax, y: ay} = a, %{x: apx, y: apy} = axis_point, angle, scalar)
      when is_number(ax) and is_number(ay) and is_number(apx) and is_number(apy) and
             is_number(angle) and is_number(scalar) do
    a
    |> sub(axis_point)
    |> scale(scalar)
    |> rotate(angle)
    |> add(axis_point)
  end

  def scale_and_rotate(%{x: ax, y: ay} = a, %{x: apx, y: apy} = axis_point, angle, sx, sy)
      when is_number(ax) and is_number(ay) and is_number(apx) and is_number(apy) and
             is_number(angle) and is_number(sx) and is_number(sy) do
    a
    |> sub(axis_point)
    |> scale(sx, sy)
    |> rotate(angle)
    |> add(axis_point)
  end

  def lerp(%{x: ax, y: ay}, %{x: bx, y: by}, t)
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) and is_number(t) do
    %__MODULE__{
      x: ax + t * (bx - ax),
      y: ay + t * (by - ay)
    }
  end

  def perp(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: -ay,
      y: ax
    }
  end

  def magnitude(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    :math.sqrt(ax * ax + ay * ay)
  end

  def squared_magnitude(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    ax * ax + ay * ay
  end

  def azimuth(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    :math.atan2(ay, ax)
  end

  def dot(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    ax * bx + ay * by
  end

  def cross(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    ax * by - ay * bx
  end

  def distance(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    dx = ax - bx
    dy = ay - by

    :math.sqrt(dx * dx + dy * dy)
  end

  def squared_distance(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    dx = ax - bx
    dy = ay - by

    dx * dx + dy * dy
  end

  def direction(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    dx = bx - ax
    dy = by - ay

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

  def project(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    dot_ab = ax * bx + ay * by

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

  def abs(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: Kernel.abs(ax),
      y: Kernel.abs(ay)
    }
  end

  def ceil(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: Kernel.ceil(ax),
      y: Kernel.ceil(ay)
    }
  end

  def floor(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: Kernel.floor(ax),
      y: Kernel.floor(ay)
    }
  end

  def round(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: Kernel.round(ax),
      y: Kernel.round(ay)
    }
  end

  def trunc(%{x: ax, y: ay}) when is_number(ax) and is_number(ay) do
    %__MODULE__{
      x: Kernel.trunc(ax),
      y: Kernel.trunc(ay)
    }
  end

  def equals(%{x: ax, y: ay}, %{x: bx, y: by})
      when is_number(ax) and is_number(ay) and is_number(bx) and is_number(by) do
    ax == bx and ay == by
  end
end
