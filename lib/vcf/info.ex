defmodule ExVcf.Vcf.Info do
  alias ExVcf.Vcf.Info
  alias ExVcf.Vcf.HeaderLine

  @header_type "INFO"
  def type, do: @header_type

  @reserved_info_keys MapSet.new([
    "AA",
    "AC",
    "AF",
    "AN",
    "BQ",
    "CIGAR",
    "DB",
    "DP",
    "END",
    "H2",
    "H3",
    "MQ",
    "MQ0",
    "NS",
    "SB",
    "SOMATIC",
    "VALIDATED",
    "1000G"
  ])
  def reserved_info_keys, do: @reserved_info_keys

  @doc ~S"""
  ## Examples
      iex> ExVcf.Vcf.Info.new_string("NS", 1, "Number of Samples With Data")
      %ExVcf.Vcf.HeaderLine{fields: [ID: "NS", Number: 1, Type: "String", "Description": "Number of Samples With Data"], key: "INFO", value: ""}
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

  def new_flag(id, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: 0, Type: HeaderLine.flag, Description: description] ++ fields)
  end

  def new_character(id, number, description, fields \\ []) do
    HeaderLine.new(@header_type, [ID: id, Number: number, Type: HeaderLine.character, Description: description] ++ fields)
  end

  def imprecise(), do: new_flag("IMPRECISE", "Imprecise structural variation")
  def novel(), do: new_flag("NOVEL", "Indicates a novel structural variation")
  def end_pos(), do: new_integer("END", 1, "End position of the variant described in this record")
  def allele_depth(), do: new_integer("AD", "R", "Allele depth")
  def allele_depth_forward(), do: new_integer("ADF", "R", "Allele depth forward")
  def allele_depth_reverse(), do: new_integer("ADF", "R", "Allele depth reverse")
end
