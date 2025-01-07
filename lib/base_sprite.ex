defmodule FriGame.BaseSprite do
  use TypedStruct

  alias FriGame.Rect

  typedstruct do
    field(:rect, Rect.t(), default: %Rect{})
    field(:transform_originx, Rect.rect_size_x() | number(), default: :half_width)
    field(:transform_originy, Rect.rect_size_y() | number(), default: :half_height)
    field(:angle, number(), default: 0)
    field(:scalex, number(), default: 1)
    field(:scaley, number(), default: 1)
    field(:fliph, number(), default: 1)
    field(:flipv, number(), default: 1)
    field(:scaleh, number(), default: 1)
    field(:scalev, number(), default: 1)
  end

  def transform_origin(%__MODULE__{} = sprite) do
    sprite.transform_originx
  end

  def transform_origin(%__MODULE__{} = sprite, value) when is_atom(value) or is_number(value) do
    %__MODULE__{sprite | transform_originx: value, transform_originy: value}
  end

  def transform_originx(%__MODULE__{} = sprite) do
    sprite.transform_originx
  end

  def transform_originx(%__MODULE__{} = sprite, value) when is_atom(value) or is_number(value) do
    %__MODULE__{sprite | transform_originx: value}
  end

  def transform_originy(%__MODULE__{} = sprite) do
    sprite.transform_originy
  end

  def transform_originy(%__MODULE__{} = sprite, value) when is_atom(value) or is_number(value) do
    %__MODULE__{sprite | transform_originy: value}
  end

  def angle(%__MODULE__{} = sprite) do
    sprite.angle
  end

  def angle(%__MODULE__{} = sprite, value) when is_number(value) do
    %__MODULE__{sprite | angle: value}
  end

  def scalex(%__MODULE__{} = sprite) do
    sprite.scalex
  end

  def scalex(%__MODULE__{} = sprite, value) when is_number(value) do
    %__MODULE__{sprite | scalex: value, scaleh: value * sprite.fliph}
  end

  def scaley(%__MODULE__{} = sprite) do
    sprite.scaley
  end

  def scaley(%__MODULE__{} = sprite, value) when is_number(value) do
    %__MODULE__{sprite | scaley: value, scalev: value * sprite.flipv}
  end

  def scale(%__MODULE__{} = sprite) do
    sprite.scalex
  end

  def scale(%__MODULE__{} = sprite, value) when is_number(value) do
    %__MODULE__{
      sprite
      | scalex: value,
        scaley: value,
        scaleh: value * sprite.fliph,
        scalev: value * sprite.flipv
    }
  end

  def fliph(%__MODULE__{} = sprite) do
    sprite.fliph < 0
  end

  def fliph(%__MODULE__{} = sprite, true) do
    %__MODULE__{sprite | fliph: -1, scaleh: -sprite.scalex}
  end

  def fliph(%__MODULE__{} = sprite, false) do
    %__MODULE__{sprite | fliph: 1, scaleh: sprite.scalex}
  end

  def flipv(%__MODULE__{} = sprite) do
    sprite.flipv < 0
  end

  def flipv(%__MODULE__{} = sprite, true) do
    %__MODULE__{sprite | flipv: -1, scalev: -sprite.scaley}
  end

  def flipv(%__MODULE__{} = sprite, false) do
    %__MODULE__{sprite | flipv: 1, scalev: sprite.scaley}
  end

  def flip(%__MODULE__{} = sprite) do
    sprite.fliph < 0
  end

  def flip(%__MODULE__{} = sprite, true) do
    %__MODULE__{sprite | fliph: -1, flipv: -1, scaleh: -sprite.scalex, scalev: -sprite.scaley}
  end

  def flip(%__MODULE__{} = sprite, false) do
    %__MODULE__{sprite | fliph: 1, flipv: 1, scaleh: sprite.scalex, scalev: sprite.scaley}
  end
end
