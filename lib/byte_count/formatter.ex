defmodule ByteCount.Formatter do
  @moduledoc false

  # Decimal
  @si_units ~w(B k M G T P E Z Y R Q)

  # Binary
  @iec_units ~w(B K M G T P E Z Y R Q)

  def to_integer(%ByteCount{bytes: b}), do: b

  @doc """
  Human-readable string.

  Options:

    * `style: :iec` (default) or `:si`
    * `short: true` → `"43.0k"` instead of `"43.0 KiB"` (default is false)
    * `precision: 1` (default)

  """
  def format(struct, opts \\ []) do
    style = Keyword.get(opts, :style, :iec)
    short? = Keyword.get(opts, :short, false)
    precision = Keyword.get(opts, :precision, 1)
    bytes = struct.bytes
    threshold = Map.fetch!(%{iec: 1024, si: 1000}, style)

    cond do
      bytes == 0 -> "0 B"
      bytes < threshold -> "#{bytes} B"
      true -> formatted(bytes, style, short?, precision)
    end
  end

  def formatted(bytes, :iec, short?, precision) do
    {val, exp} = compute(bytes, 2, 10)
    rounded = rnd(val, precision)
    prefix = Enum.at(@iec_units, exp)
    suffix = if short?, do: "", else: "iB"

    "#{rounded}#{sep(short?)}#{prefix}#{suffix}"
  end

  def formatted(bytes, :si, short?, precision) do
    {val, exp} = compute(bytes, 10, 3)
    rounded = rnd(val, precision)
    prefix = Enum.at(@si_units, exp)
    suffix = if short?, do: "", else: "B"

    "#{rounded}#{sep(short?)}#{prefix}#{suffix}"
  end

  def compute(bytes, base, multiplier) do
    exp =
      base
      |> log(bytes)
      |> Kernel./(multiplier)
      |> trunc()

    value = bytes / :math.pow(base ** multiplier, exp)
    {value, exp}
  end

  defp sep(short?), do: if(short?, do: "", else: " ")
  defp log(base, value), do: :math.log(value) / :math.log(base)

  defp rnd(float, 0), do: Integer.to_string(trunc(float))

  defp rnd(float, prec) when prec > 0 do
    float
    # Convert to string
    |> :erlang.float_to_binary(decimals: prec)

    # Strip trailing zeros
    |> String.replace(~r/(\.\d*?)0+$/, "\\1")

    # But keep ".0"
    |> String.replace(~r/\.$/, ".0")
  end
end
