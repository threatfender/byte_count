defmodule ByteCount do
  @moduledoc """
  Human-friendly byte sizes – construct, parse, format, and do math.

  ## Examples

      iex> ByteCount.gib(523) |> to_string()
      "523.0 GiB"

      iex> ByteCount.kib(42) |> ByteCount.format(style: :si, short: true)
      "43.0k"
  """

  @type t :: %__MODULE__{bytes: non_neg_integer}

  defstruct bytes: 0

  import ByteCount.Constants, only: [factor: 1]
  import ByteCount.Parser, only: [parse_bytes_count: 1]

  ##
  ## Construction
  ##

  @doc """
  Construct a new struct from given byte count integer.

  ## Examples

      iex> ByteCount.new(1024)
      %ByteCount{bytes: 1024}

  """
  @spec new(non_neg_integer()) :: t()
  def new(bytes) when is_integer(bytes) and bytes >= 0,
    do: %__MODULE__{bytes: bytes}

  def new(bytes),
    do: raise(ArgumentError, message: "Invalid integer value: #{bytes}")

  ## SI Units (1000-based)

  @doc """
  Alias for `new/1`. Creates a `%ByteCount{}` from raw bytes.

  ## Examples

      iex> ByteCount.b(512)
      %ByteCount{bytes: 512}

  """
  @spec b(non_neg_integer()) :: t()
  def b(bytes), do: new(bytes)

  @doc """
  Creates a `%ByteCount{}` from kilobytes (1 KB = 10³ bytes).
  """
  @spec kb(non_neg_integer()) :: t()
  def kb(n), do: b(n * factor("kb"))

  @doc """
  Creates a `%ByteCount{}` from megabytes (1 MB = 10⁶ bytes).
  """
  @spec mb(non_neg_integer()) :: t()
  def mb(n), do: b(n * factor("mb"))

  @doc """
  Creates a `%ByteCount{}` from gigabytes (1 GB = 10⁹ bytes).
  """
  @spec gb(non_neg_integer()) :: t()
  def gb(n), do: b(n * factor("gb"))

  @doc """
  Creates a `%ByteCount{}` from terabytes (1 TB = 10¹² bytes).
  """
  @spec tb(non_neg_integer()) :: t()
  def tb(n), do: b(n * factor("tb"))

  @doc """
  Creates a `%ByteCount{}` from petabytes (1 PB = 10¹⁵ bytes).
  """
  @spec pb(non_neg_integer()) :: t()
  def pb(n), do: b(n * factor("pb"))

  @doc """
  Creates a `%ByteCount{}` from exabytes (1 EB = 10¹⁸ bytes).
  """
  @spec eb(non_neg_integer()) :: t()
  def eb(n), do: b(n * factor("eb"))

  @doc """
  Creates a `%ByteCount{}` from zettabytes (1 ZB = 10²¹ bytes).
  """
  @spec zb(non_neg_integer()) :: t()
  def zb(n), do: b(n * factor("zb"))

  @doc """
  Creates a `%ByteCount{}` from yottabytes (1 YB = 10²⁴ bytes).
  """
  @spec yb(non_neg_integer()) :: t()
  def yb(n), do: b(n * factor("yb"))

  @doc """
  Creates a `%ByteCount{}` from ronnabytes (1 RB = 10²⁷ bytes).
  """
  @spec rb(non_neg_integer()) :: t()
  def rb(n), do: b(n * factor("rb"))

  @doc """
  Creates a `%ByteCount{}` from quettabytes (1 QB = 10³⁰ bytes).
  """
  @spec qb(non_neg_integer()) :: t()
  def qb(n), do: b(n * factor("qb"))

  ## IEC Units (1024-based)

  @doc """
  Creates a `%ByteCount{}` from kibibytes (1 KiB = 2¹⁰ bytes).
  """
  @spec kib(non_neg_integer()) :: t()
  def kib(n), do: b(n * factor("kib"))

  @doc """
  Creates a `%ByteCount{}` from mebibytes (1 MiB = 2²⁰ bytes).
  """
  @spec mib(non_neg_integer()) :: t()
  def mib(n), do: b(n * factor("mib"))

  @doc """
  Creates a `%ByteCount{}` from gibibytes (1 GiB = 2³⁰ bytes).
  """
  @spec gib(non_neg_integer()) :: t()
  def gib(n), do: b(n * factor("gib"))

  @doc """
  Creates a `%ByteCount{}` from tebibytes (1 TiB = 2⁴⁰ bytes).
  """
  @spec tib(non_neg_integer()) :: t()
  def tib(n), do: b(n * factor("tib"))

  @doc """
  Creates a `%ByteCount{}` from pebibytes (1 PiB = 2⁵⁰ bytes).
  """
  @spec pib(non_neg_integer()) :: t()
  def pib(n), do: b(n * factor("pib"))

  @doc """
  Creates a `%ByteCount{}` from exbibytes (1 EiB = 2⁶⁰ bytes).
  """
  @spec eib(non_neg_integer()) :: t()
  def eib(n), do: b(n * factor("eib"))

  @doc """
  Creates a `%ByteCount{}` from zebibytes (1 ZiB = 2⁷⁰ bytes).
  """
  @spec zib(non_neg_integer()) :: t()
  def zib(n), do: b(n * factor("zib"))

  @doc """
  Creates a `%ByteCount{}` from yobibytes (1 YiB = 2⁸⁰ bytes).
  """
  @spec yib(non_neg_integer()) :: t()
  def yib(n), do: b(n * factor("yib"))

  @doc """
  Creates a `%ByteCount{}` from robibytes (1 RiB = 2⁹⁰ bytes).
  """
  @spec rib(non_neg_integer()) :: t()
  def rib(n), do: b(n * factor("rib"))

  @doc """
  Creates a `%ByteCount{}` from quebibytes (1 QiB = 2¹⁰⁰ bytes).
  """
  @spec qib(non_neg_integer()) :: t()
  def qib(n), do: b(n * factor("qib"))

  ##
  ## Parsing
  ##

  @doc """
  Parse byte count given as string.

  ## Examples

      iex> ByteCount.parse("10")
      {:ok, %ByteCount{bytes: 10}}

      iex> ByteCount.parse("10 kb")
      {:ok, %ByteCount{bytes: 10000}}

      iex> ByteCount.parse("10k")
      {:ok, %ByteCount{bytes: 10000}}

  """
  @spec parse(String.t()) :: {:ok, t()} | {:error, any()}
  def parse(string) do
    with {:ok, integer} <- parse_bytes_count(string) do
      {:ok, b(integer)}
    end
  end

  @doc """
  Parse byte count or raise on error.

  ## Examples

      iex> ByteCount.parse!("10")
      %ByteCount{bytes: 10}

  """
  @spec parse!(String.t()) :: t() | no_return()
  def parse!(string) do
    case parse(string) do
      {:ok, struct} -> struct
      {:error, reason} -> raise ArgumentError, message: "Cannot parse `#{string}`: #{reason}"
    end
  end

  ##
  ## Formatting
  ##

  @doc """
  Return a human-readable string using the IEC style and default options.

  To customize formating see `format/2`.
  """
  @spec format(ByteCount.t()) :: String.t()
  defdelegate format(struct), to: ByteCount.Formatter

  @type format_opts :: [
          style: :iec | :si,
          short: boolean(),
          precision: non_neg_integer()
        ]

  @doc """
  Return a human-readable string representing of the byte count customizable
  using the following options:

  Options:

    * `style: :iec | :si` (default is :iec)
    * `short: true | false` (default is false) → `"43.0k"` instead of `"43.0 KiB"`
    * `precision: 1 | 2 | ...` (default is 1)

  ## Examples

      iex> ByteCount.kib(4) |> ByteCount.format()
      "4.0 KiB"

      iex> ByteCount.kb(4) |> ByteCount.format(style: :si, short: true, precision: 0)
      "4k"

  """
  @spec format(ByteCount.t(), format_opts()) :: String.t()
  defdelegate format(struct, opts), to: ByteCount.Formatter

  @doc """
  Return byte count as an integer

  ## Examples

      iex> ByteCount.kb(1) |> ByteCount.to_integer()
      1000

  """
  @spec to_integer(ByteCount.t()) :: integer()
  defdelegate to_integer(struct), to: ByteCount.Formatter

  ##
  ## Arithmetic
  ##

  @doc """
  Add two ByteCount structs or byte count to an existing struct.

  ## Examples

      iex> ByteCount.add(ByteCount.kb(1), ByteCount.b(23))
      %ByteCount{bytes: 1023}

      iex> ByteCount.add(ByteCount.kb(1), 1)
      %ByteCount{bytes: 1001}

  """
  @spec add(ByteCount.t(), ByteCount.t() | integer()) :: ByteCount.t()
  defdelegate add(byte_count, byte_count_or_integer), to: ByteCount.Arithmetic

  @doc """
  Subtract two ByteCount structs or byte count to an existing struct.

  ## Examples

      iex> ByteCount.subtract(ByteCount.kb(3), ByteCount.kb(3))
      %ByteCount{bytes: 0}

      iex> ByteCount.subtract(ByteCount.kb(3), 3000)
      %ByteCount{bytes: 0}

  """
  @spec subtract(ByteCount.t(), ByteCount.t() | integer()) :: ByteCount.t()
  defdelegate subtract(byte_count, byte_count_or_integer), to: ByteCount.Arithmetic

  @doc """
  Multiply two ByteCount structs or byte count to an existing struct.

  ## Examples

      iex> ByteCount.multiply(ByteCount.kb(1), ByteCount.b(2))
      %ByteCount{bytes: 2000}

      iex> ByteCount.multiply(ByteCount.kb(1), 2)
      %ByteCount{bytes: 2000}

  """
  @spec multiply(ByteCount.t(), ByteCount.t() | integer()) :: ByteCount.t()
  defdelegate multiply(byte_count, byte_count_or_integer), to: ByteCount.Arithmetic

  @doc """
  Divide two ByteCount structs or byte count to an existing struct.

  ## Examples

      iex> ByteCount.divide(ByteCount.kb(1), ByteCount.kb(1))
      %ByteCount{bytes: 1}

      iex> ByteCount.divide(ByteCount.kb(1), 1000)
      %ByteCount{bytes: 1}

  """
  @spec divide(ByteCount.t(), ByteCount.t() | integer()) :: ByteCount.t()
  defdelegate divide(byte_count, byte_count_or_integer), to: ByteCount.Arithmetic
end
