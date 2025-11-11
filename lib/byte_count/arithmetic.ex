defmodule ByteCount.Arithmetic do
  @moduledoc false

  @doc false
  @spec add(ByteCount.t(), integer() | ByteCount.t()) :: ByteCount.t()
  def add(%ByteCount{bytes: a}, %ByteCount{bytes: b}),
    do: ByteCount.b(a + b)

  def add(%ByteCount{bytes: a}, number) when is_integer(number),
    do: ByteCount.b(a + number)

  @doc false
  @spec subtract(ByteCount.t(), integer() | ByteCount.t()) :: ByteCount.t()
  def subtract(%ByteCount{bytes: a}, %ByteCount{bytes: b}),
    do: ByteCount.b(a - b)

  def subtract(%ByteCount{bytes: a}, number) when is_integer(number),
    do: ByteCount.b(a - number)

  @doc false
  @spec multiply(ByteCount.t(), integer() | ByteCount.t()) :: ByteCount.t()
  def multiply(%ByteCount{bytes: a}, %ByteCount{bytes: b}),
    do: ByteCount.b(trunc(a * b))

  def multiply(%ByteCount{bytes: a}, number) when is_integer(number),
    do: ByteCount.b(trunc(a * number))

  @doc false
  @spec divide(ByteCount.t(), integer() | ByteCount.t()) :: ByteCount.t()
  def divide(%ByteCount{bytes: a}, %ByteCount{bytes: b}),
    do: ByteCount.b(trunc(a / b))

  def divide(%ByteCount{bytes: a}, number) when is_integer(number) and number != 0,
    do: ByteCount.b(trunc(a / number))
end
