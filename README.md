# ByteCount

`✓ 100% test coverage` • `✓ IEC/SI Formatting`

ByteCount is a tiny, dependency-free Elixir library for working with byte counts across multiple unit systems:

  * **SI**: _kB -> kilobytes_, _MB -> megabytes_, _GB_, etc.
  * **IEC** _KiB -> kibibytes_, _MiB -> mebibytes_, _GiB_, etc.

## Features

  * Construction helpers: [`parse/1`](ByteCount.html#parse/1), [`kb/1`](ByteCount.html#kb/1), [`kib/1`](ByteCount.html#kib/1), ...
  * Formatting helpers: [`format/2`](ByteCount.html#format/2)
  * Arithmetic helpers: [`add/2`](ByteCount.html#add/2), [`subtract/2`](ByteCount.html#subtract/2), ...
  * No dependencies & 100% test coverage


## Installation

Update your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:byte_count, "~> 1.0"}
  ]
end
```

## Reference

| Area  | Function                              | Example                   |
|:-----:|---------------------------------------|---------------------------|
| `C`   | [`parse/1`](ByteCount.html#parse/1)   | `ByteCount.parse("10kb")` |
|       | [`parse!/1`](ByteCount.html#parse!/1) |                           |
| `C`   | [`b/1`](ByteCount.html#b/1), [`kb/1`](ByteCount.html#kb/1), [`mb/1`](ByteCount.html#mb/1), [`gb/1`](ByteCount.html#gb/1), [`tb/1`](ByteCount.html#tb/1), [`pb/1`](ByteCount.html#pb/1)  | `ByteCount.kb(1).bytes == 1000` |
|       | [`eb/1`](ByteCount.html#eb/1), [`zb/1`](ByteCount.html#zb/1), [`yb/1`](ByteCount.html#yb/1), [`rb/1`](ByteCount.html#rb/1), [`qb/1`](ByteCount.html#qb/1)  | |
| `C`   | [`kib/1`](ByteCount.html#kib/1), [`mib/1`](ByteCount.html#mib/1), [`gib/1`](ByteCount.html#gib/1), [`tib/1`](ByteCount.html#tib/1), [`pib/1`](ByteCount.html#pib/1)  | `ByteCount.kib(1).bytes == 1024` |
|       | [`eib/1`](ByteCount.html#eib/1), [`zib/1`](ByteCount.html#zib/1), [`yib/1`](ByteCount.html#yib/1), [`rib/1`](ByteCount.html#rib/1), [`qib/1`](ByteCount.html#qib/1)  | |
| `F`   | [`format/1`](ByteCount.html#format/1), [`format/2`](ByteCount.html#format/2), [`to_integer/1`](ByteCount.html#to_integer/1) | `ByteCount.format(byte_count)` |
| `A`   | [`add/2`](ByteCount.html#add/2), [`subtract/2`](ByteCount.html#subtract/2), [`multiply/2`](ByteCount.html#multiply/2), [`divide/2`](ByteCount.html#divide/2) | `ByteCount.add(bc1, bc2)` |

`C` = Construction, `F` = Formatting, `A` = Arithmethic.


## Examples

  1. **Construction** - Construct byte count structs using the SI and IEC helpers:

```elixir
# International System of Units (SI) -> powers of 10 (decimal).

iex> ByteCount.kb(4)
%ByteCount{bytes: 4000}

iex> ByteCount.parse!("4kb")
%ByteCount{bytes: 4000}
```

```elixir
# International Electrotechnical Commission (IEC) -> power of 2 (binary).

iex> ByteCount.kib(4)
%ByteCount{bytes: 4096}

iex> ByteCount.mib(4)
%ByteCount{bytes: 1048576}

iex> ByteCount.parse!("4kib")
%ByteCount{bytes: 4096}
```

  2. **Formatting** - Display human-friendly byte counts:

```elixir
iex(1)> ByteCount.kb(4) |> ByteCount.format()
"3.9 KiB"

iex(1)> ByteCount.kb(4) |> ByteCount.format(short: true)
"3.9K"

iex> ByteCount.kb(4) |> ByteCount.format(style: :si, short: true, precision: 2)
"4.0k"
```

  3. **Arithmetic** - Perform arithmetic operations:


```elixir
iex> ByteCount.add(ByteCount.kb(4), ByteCount.kb(6))
%ByteCount{bytes: 10000}
```

## License

ByteCount is open source software licensed under the Apache 2.0 License.

