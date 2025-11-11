defmodule ByteCountTest do
  use ExUnit.Case
  doctest ByteCount

  test "construction" do
    assert ByteCount.new(1024).bytes == 1024

    # SI
    assert ByteCount.b(1).bytes == 1_000 ** 0
    assert ByteCount.kb(1).bytes == 1_000 ** 1
    assert ByteCount.mb(1).bytes == 1_000 ** 2
    assert ByteCount.gb(1).bytes == 1_000 ** 3
    assert ByteCount.tb(1).bytes == 1_000 ** 4
    assert ByteCount.pb(1).bytes == 1_000 ** 5
    assert ByteCount.eb(1).bytes == 1_000 ** 6
    assert ByteCount.zb(1).bytes == 1_000 ** 7
    assert ByteCount.yb(1).bytes == 1_000 ** 8
    assert ByteCount.rb(1).bytes == 1_000 ** 9
    assert ByteCount.qb(1).bytes == 1_000 ** 10

    # IEC
    assert ByteCount.b(2).bytes == 2 * 1_000 ** 0
    assert ByteCount.kib(2).bytes == 2 * 1_024 ** 1
    assert ByteCount.mib(2).bytes == 2 * 1_024 ** 2
    assert ByteCount.gib(2).bytes == 2 * 1_024 ** 3
    assert ByteCount.tib(2).bytes == 2 * 1_024 ** 4
    assert ByteCount.pib(2).bytes == 2 * 1_024 ** 5
    assert ByteCount.eib(2).bytes == 2 * 1_024 ** 6
    assert ByteCount.zib(2).bytes == 2 * 1_024 ** 7
    assert ByteCount.yib(2).bytes == 2 * 1_024 ** 8
    assert ByteCount.rib(2).bytes == 2 * 1_024 ** 9
    assert ByteCount.qib(2).bytes == 2 * 1_024 ** 10
  end

  test "construction failure" do
    assert_raise ArgumentError, fn -> ByteCount.b(-1) end
    assert_raise ArgumentError, fn -> ByteCount.b(nil) end
    assert_raise ArgumentError, fn -> ByteCount.b("") end
  end

  test "format" do
    assert ByteCount.gib(518) |> ByteCount.format() == "518.0 GiB"
    assert ByteCount.gib(518) |> ByteCount.format(style: :si) == "556.2 GB"
    assert ByteCount.kib(42) |> ByteCount.format(style: :si, short: true) == "43.0k"

    assert ByteCount.b(1023) |> ByteCount.format(style: :iec) == "1023 B"
    assert ByteCount.b(999) |> ByteCount.format(style: :si) == "999 B"

    assert ByteCount.b(0) |> ByteCount.format(style: :iec) == "0 B"
    assert ByteCount.b(0) |> ByteCount.format(style: :si) == "0 B"

    assert ByteCount.kb(1234) |> ByteCount.format(style: :si, precision: 1) == "1.2 MB"
    assert ByteCount.kb(1234) |> ByteCount.format(style: :si, precision: 2) == "1.23 MB"
    assert ByteCount.kb(1234) |> ByteCount.format(style: :si, precision: 3) == "1.234 MB"
    assert ByteCount.kb(1234) |> ByteCount.format(style: :si, precision: 4) == "1.234 MB"
  end

  test "arithmetic" do
    a = ByteCount.mb(1)
    b = ByteCount.kb(100)
    assert ByteCount.add(a, b).bytes == 1_100_000
    assert ByteCount.subtract(a, b).bytes == 900_000
    assert ByteCount.multiply(a, 2).bytes == 2_000_000
  end

  test "parsing" do
    assert {:ok, %ByteCount{bytes: 1536}} = ByteCount.parse("1.5 KiB")
    assert {:ok, %ByteCount{bytes: 1024}} = ByteCount.parse("1KiB")
    assert {:ok, %ByteCount{bytes: 500}} = ByteCount.parse("500")
    assert %ByteCount{bytes: 1536} = ByteCount.parse!("1.5KiB")

    ## parsing works with capital letters & spaces

    assert ByteCount.parse!("1KB").bytes == 1000
    assert ByteCount.parse!("1KIB").bytes == 1024

    assert ByteCount.parse!("1 KB").bytes == 1000
    assert ByteCount.parse!("1 KIB").bytes == 1024

    assert ByteCount.parse!("1  KB").bytes == 1000
    assert ByteCount.parse!("1  KIB").bytes == 1024

    # Trim spaces
    assert ByteCount.parse!("  42KB  ").bytes == 42_000
  end

  test "parsing!" do
    assert ByteCount.parse!("1b").bytes == 1

    assert ByteCount.parse!("1kb").bytes == 1_000 ** 1
    assert ByteCount.parse!("1mb").bytes == 1_000 ** 2
    assert ByteCount.parse!("1gb").bytes == 1_000 ** 3
    assert ByteCount.parse!("1tb").bytes == 1_000 ** 4
    assert ByteCount.parse!("1pb").bytes == 1_000 ** 5
    assert ByteCount.parse!("1eb").bytes == 1_000 ** 6
    assert ByteCount.parse!("1zb").bytes == 1_000 ** 7
    assert ByteCount.parse!("1yb").bytes == 1_000 ** 8
    assert ByteCount.parse!("1rb").bytes == 1_000 ** 9
    assert ByteCount.parse!("1qb").bytes == 1_000 ** 10

    assert ByteCount.parse!("1kib").bytes == 1024 ** 1
    assert ByteCount.parse!("1mib").bytes == 1024 ** 2
    assert ByteCount.parse!("1gib").bytes == 1024 ** 3
    assert ByteCount.parse!("1tib").bytes == 1024 ** 4
    assert ByteCount.parse!("1pib").bytes == 1024 ** 5
    assert ByteCount.parse!("1eib").bytes == 1024 ** 6
    assert ByteCount.parse!("1zib").bytes == 1024 ** 7
    assert ByteCount.parse!("1yib").bytes == 1024 ** 8
    assert ByteCount.parse!("1rib").bytes == 1024 ** 9
    assert ByteCount.parse!("1qib").bytes == 1024 ** 10
  end

  test "parsing errors" do
    assert_raise ArgumentError, fn -> ByteCount.parse!("x1") end

    {:error, :invalid_input} = ByteCount.Parser.parse_bytes_count(nil)
    {:error, :invalid_input} = ByteCount.Parser.parse_bytes_count("")
    {:error, :invalid_input} = ByteCount.Parser.parse_bytes_count("x")
    {:error, "Cannot parse number: .0"} = ByteCount.Parser.parse_number(".0")
  end

  test "parse rejects unknown unit" do
    {:error, :invalid_unit} = ByteCount.parse("10 xyz")

    assert_raise ArgumentError, fn ->
      ByteCount.parse!("10 xyz")
    end
  end

  test "multiply with float raises" do
    assert_raise FunctionClauseError, fn ->
      ByteCount.multiply(ByteCount.kb(1), 1.5)
    end
  end

  test "format exact power of 1024" do
    assert ByteCount.kib(1) |> ByteCount.format() == "1.0 KiB"
    assert ByteCount.new(1024) |> ByteCount.format() == "1.0 KiB"
  end

  test "String.Chars protocol" do
    struct = ByteCount.kib(4)
    assert to_string(struct) == "4.0 KiB"
  end
end
