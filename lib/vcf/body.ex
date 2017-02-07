defmodule ExVcf.Vcf.Body do
  alias ExVcf.Vcf.Body

  @info_regex ~r(/^[A-Za-z ][0-9A-Za-z .]*$/)

  defstruct chrom: "",
    pos: 1,
    id: "",
    ref: "",
    alt: "",
    qual: "",
    filter: "",
    info: [],
    format: [],
    misc: []

  def str(line) do
    [:id, :ref, :alt, :qual, :filter, :info, :format]
    "#{line.chrom}\t#{line.pos}"
  end

  def add_info(body, key, value) do
    %{body | info: body.info ++ ["#{key}=#{value}"]}
  end

  def add_format(body, value) do
    %{body | format: body.format ++ [value]}
  end

  defp stringify_info(body), do: Enum.join(body.info, ";")
  defp stringify_format(body), do: Enum.join(body.format, ":")
  defp stringify_id(body), do: Enum.join(body.id, ";")

  defp result_or_empty(""), do: "."
  #defp result_or_empty(%{}), do: "."
  defp result_or_empty([]), do: "."
  defp result_or_empty(val), do: proc_val(val)

  defp proc_val(val) when is_bitstring(val), do: val
end
