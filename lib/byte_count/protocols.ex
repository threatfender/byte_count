defimpl String.Chars, for: ByteCount do
  def to_string(struct), do: ByteCount.format(struct)
end
