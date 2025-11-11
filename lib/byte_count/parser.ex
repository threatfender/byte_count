defmodule ByteCount.Parser do
  @moduledoc false

  def parse_bytes_count(str) when is_binary(str) do
    str
    |> String.trim()
    |> then(&Regex.run(~r/^(\d+\.?\d*)\s{0,}([\w]*)/, &1))
    |> case do
      [_all, num, unit] ->
        with {:ok, num} <- parse_number(num) do
          unit = String.downcase(unit)

          case ByteCount.Constants.factor(if unit == "", do: "b", else: unit) do
            :error ->
              {:error, :invalid_unit}

            scale ->
              {:ok, trunc(num * scale)}
          end
        end

      _ ->
        {:error, :invalid_input}
    end
  end

  def parse_bytes_count(_), do: {:error, :invalid_input}

  @doc """
  Parse a string representing an integer or float.
  """
  def parse_number(str) do
    case Integer.parse(str) do
      {integer, ""} ->
        {:ok, integer}

      _ ->
        case Float.parse(str) do
          {float, _} -> {:ok, float}
          :error -> {:error, "Cannot parse number: #{str}"}
        end
    end
  end
end
