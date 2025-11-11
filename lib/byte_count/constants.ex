defmodule ByteCount.Constants do
  @moduledoc false

  ## Multiple-byte units:

  ## Decimal

  ## Value        SI (Metric)
  ## 1000^1   kB  kilobyte
  ## 1000^2   MB  megabyte
  ## 1000^3   GB  gigabyte
  ## 1000^4   TB  terabyte
  ## 1000^5   PB  petabyte
  ## 1000^6   EB  exabyte
  ## 1000^7   ZB  zettabyte
  ## 1000^8   YB  yottabyte
  ## 1000^9   RB  ronnabyte
  ## 1000^10  QB  quettabyte

  ## Binary

  ## Value        IEC (International Electrotechnical Commission)
  ## 1024^1   KiB kibibyte
  ## 1024^2   MiB mebibyte
  ## 1024^3   GiB gibibyte
  ## 1024^4   TiB tebibyte
  ## 1024^5   PiB pebibyte
  ## 1024^6   EiB exbibyte
  ## 1024^7   ZiB zebibyte
  ## 1024^8   YiB yobibyte
  ## 1024^9   RiB robibyte
  ## 1024^10  QiB quebibyte

  ## Powers of 10, following the International System of Units (SI),
  ## which defines for example the prefix kilo as 1000 (10^3);

  @b 1
  @kb 1000
  @mb 1000 * 1000
  @gb 1000 * 1000 * 1000
  @tb 1000 * 1000 * 1000 * 1000
  @pb 1000 * 1000 * 1000 * 1000 * 1000
  @eb 1000 * 1000 * 1000 * 1000 * 1000 * 1000
  @zb 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000
  @yb 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000
  @rb 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000
  @qb 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000

  ## Systems based on powers of 2, use binary prefixes (kibi, mebi, gibi, ...)

  @kib 1024
  @mib 1024 * 1024
  @gib 1024 * 1024 * 1024
  @tib 1024 * 1024 * 1024 * 1024
  @pib 1024 * 1024 * 1024 * 1024 * 1024
  @eib 1024 * 1024 * 1024 * 1024 * 1024 * 1024
  @zib 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
  @yib 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
  @rib 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
  @qib 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024 * 1024

  @units %{
    "b" => @b,
    "kb" => @kb,
    "k" => @kb,
    "mb" => @mb,
    "m" => @mb,
    "gb" => @gb,
    "g" => @gb,
    "tb" => @tb,
    "t" => @tb,
    "pb" => @pb,
    "p" => @pb,
    "eb" => @eb,
    "e" => @eb,
    "zb" => @zb,
    "z" => @zb,
    "yb" => @yb,
    "y" => @yb,
    "rb" => @rb,
    "r" => @rb,
    "qb" => @qb,
    "q" => @qb,
    "kib" => @kib,
    "ki" => @kib,
    "mib" => @mib,
    "mi" => @mib,
    "gib" => @gib,
    "gi" => @gib,
    "tib" => @tib,
    "ti" => @tib,
    "pib" => @pib,
    "pi" => @pib,
    "eib" => @eib,
    "ei" => @eib,
    "zib" => @zib,
    "zi" => @zib,
    "yib" => @yib,
    "yi" => @yib,
    "rib" => @rib,
    "ri" => @rib,
    "qib" => @qib,
    "qi" => @qib
  }

  @unit_names ~w(b kb k mb m gb g tb t pb p eb e zb z yb y rb r qb q
                 kib ki mib mi gib gi tib ti pib pi eib ei zib zi yib yi rib ri qib qi
  )

  @doc """
  Return the scaling factor for given unit name.
  """
  @spec factor(unit_name :: String.t()) :: non_neg_integer() | :error
  def factor(unit_name) when unit_name in @unit_names, do: Map.fetch!(@units, unit_name)
  def factor(_), do: :error
end
