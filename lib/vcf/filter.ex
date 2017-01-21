defmodule ExVcf.Vcf.Filter do
  alias ExVcf.Vcf.Filter
  @moduledoc """
  Filter is a module to handle adding filter lines to a VCF file

  ##FILTER=<ID=ID,Description="description">
  """

  @header "##FILTER="

  @enforce_keys [:id, :description]
  defstruct id: "",
    description: ""

  @doc ~S"""
  Create a new filter line

  ## Examples

      iex> ExVcf.Vcf.Filter.new("NB", "A description goes here")
      %ExVcf.Vcf.Filter{id: "NB", description: "A description goes here"}
  """
  def new(id, desc) do
    %Filter{id: id, description: desc}
  end


  @doc ~S"""
  Get a filter line as a string

  ## Examples
      iex> ExVcf.Vcf.Filter.new("NB", "A description goes here") |> ExVcf.Vcf.Filter.header_filter
      "##FILTER=<ID=NB,Description=\"A description goes here\">"
  """
  def header_filter(filter) do
    @header <> "<ID=#{filter.id},Description=\"#{filter.description}\">"
  end
end
