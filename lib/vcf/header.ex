defmodule ExVcf.Vcf.Header do
  alias ExVcf.Vcf.HeaderLine

  def accumulate_fields(fields) do
    Enum.reduce(fields, [],
                fn(x, acc) ->
                  {k, v} = x
                  acc ++ ["#{k |> Atom.to_string |> String.capitalize}=\"#{v}\""] end)
  end

  @doc ~S"""
  Encode an assembly line into the header
  ## Example

      iex> ExVcf.Vcf.Header.assembly("http://example.com")
      %ExVcf.Vcf.HeaderLine{fields: [], key: "assembly", value: "http://example.com"}
  """
  def assembly(url) do
    HeaderLine.new_kv("assembly", url)
  end

  def contig(data) do
    HeaderLine.new("contig", data)
  end

  def add_line(key, value) do
    HeaderLine.new(key, value)
  end
end
