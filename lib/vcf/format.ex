defmodule ExVcf.Vcf.Format do
  alias ExVcf.Vcf.Format
  alias ExVcf.Vcf.HeaderLine

  @header_type "FORMAT"
  def type, do: @header_type

  @doc ~S"""
  ## Examples
  ### FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype"
      iex> ExVcf.Vcf.Format.new_string("GT", 1, "Genotype")
      ExVcf.Vcf.HeaderLine{fields: [ID: "GT", Number: 1, Type: "String", Description: "Genotype"], key: "FORMAT", value: "" }
  """
  def new_string(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Type: HeaderLine.string, Number: Number, Description: description] ++ fields)
  end

  def new_integer(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Type: HeaderLine.integer, Number: Number, Description: description] ++ fields)
  end

  def new_float(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Type: HeaderLine.float, Number: Number, Description: description] ++ fields)
  end

  def new_character(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Type: HeaderLine.character, Number: Number, Description: description] ++ fields)
  end
end
