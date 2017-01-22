defmodule ExVcf.Vcf.Filter do
  alias ExVcf.Vcf.Filter
  @moduledoc """
  Filter is a module to handle adding filter lines to a VCF file

  The format looks something like: ##FILTER=<ID=ID,Description="description">
  """

  @header "##FILTER="

  @enforce_keys [:id, :description]
  defstruct id: "",
    description: "",
    optional_fields: []

  @doc ~S"""
  Create a new filter line

  ## Examples

      iex> ExVcf.Vcf.Filter.new("NB", "A description goes here")
      %ExVcf.Vcf.Filter{id: "NB", description: "A description goes here"}
  """
  def new(id, desc, optional_fields \\ []) do
    %Filter{id: id, description: desc, optional_fields: optional_fields}
  end

  def header, do: @header

  @doc ~S"""
  Get a filter line as a string

  ## Examples
      iex> ExVcf.Vcf.Filter.new("NB", "A description goes here") |> ExVcf.Vcf.Filter.header_string
      "##FILTER=<ID=NB,Description=\"A description goes here\">"
  """
  def header_string(filter) do
    fields = ["ID=#{filter.id}","Description=\"#{filter.description}\""]
    new_fields = filter.optional_fields |> ExVcf.Vcf.Header.accumulate_fields
     str_fields = fields ++ new_fields
     "#{@header}<#{Enum.join(str_fields, ",")}>"
  end

  defimpl ExVcf.Vcf.HeaderLine, for: Filter do
    @doc ~S"""
    Write out the INFO field as a string to be used in the header

    iex> ExVcf.Vcf.Filter.new("NB", "A description") |> ExVcf.Vcf.HeaderLine.header_string
    "##FILTER=<ID=NB,Description=\"A description goes here\",Source=\"Test\">"
    """
    def header_line(nil), do: Filter.header
    def header_line(info) do
      Filter.header_string(info)
    end
  end
end
