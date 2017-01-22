defmodule ExVcf.Vcf.Filter do
  alias ExVcf.Vcf.Filter
  alias ExVcf.Vcf.HeaderLine
  @moduledoc """
  Filter is a module to handle adding filter lines to a VCF file

  The format looks something like: ##FILTER=<ID=ID,Description="description">
  """

  @header_type"FILTER"
  def type, do: @header_type

  @doc ~S"""
  Create a new filter line

  ## Examples

      iex> ExVcf.Vcf.Filter.new("NB", "A description goes here")
      %ExVcf.Vcf.HeaderLine{fields: [ID: "NB", Description: "A description goes here"], key: "FILTER", value: ""}
  """
  def new(id, desc, fields \\ []), do: HeaderLine.new(@header_type, [ID: id, Description: desc])

end
