defmodule ExVcf.Vcf.Info do
  alias ExVcf.Vcf.Info
  alias ExVcf.Vcf.HeaderLine

  @header_type "INFO"
  def type, do: @header_type

  @doc ~S"""
  ## Examples
      iex> ExVcf.Vcf.Info.new_string("NS", 1, "Number of Samples With Data")
      %ExVcf.Vcf.HeaderLine{fields: {ID: "NS", Number: 1, Type: "String", "Description": "Number of Samples With Data"}
  """
  def new_string(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: number, Type: HeaderLine.string, Description: description] ++ fields)
  end

  def new_integer(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: number, Type: HeaderLine.integer, Description: description] ++ fields)
  end

  def new_float(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: number, Type: HeaderLine.float, Description: description] ++ fields)
  end

  def new_flag(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: number, Type: HeaderLine.flag, Description: description] ++ fields)
  end

  def new_character(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: number, Type: HeaderLine.character, Description: description] ++ fields)
  end
end
