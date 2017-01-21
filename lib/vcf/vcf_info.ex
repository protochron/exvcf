defmodule ExVcf.Vcf.VcfInfo do
  alias ExVcf.Vcf.VcfInfo

  # Info Types
  @character :character
  @flag :flag
  @float :float
  @integer :integer
  @string :string

  # Special-case numeric values
  @one_per_alt_allele "A"
  @one_per_allele "R"
  @one_per_genotype "G"
  @unbounded "."

  @header "##INFO="

  @enforce_keys [:id, :number, :type, :description]
  defstruct id: "",
    number: 0,
    type: "",
    description: "",
    source: nil,
    version: nil

  def new_string(id, number, description, source \\ "", version \\ "") do
    new(id, number, @string, description, source, version)
  end

  def new_integer(id, number, description, source \\ "", version \\ "") do
    new(id, number, @integer, description, source, version)
  end

  def new_float(id, number, description, source \\ "", version \\ "") do
    new(id, number, @float, description, source, version)
  end

  def new_character(id, number, description, source \\ "", version \\ "") do
    new(id, number, @character, description, source, version)
  end

  def new_flag(id, number, description, source \\ "", version \\ "") do
    new(id, number, @flag, description, source, version)
  end

  # Special-case numeric types
  def one_per_allele, do: @one_per_allele
  def one_per_alt_allele, do: @one_per_alt_allele
  def one_per_genotype, do: @one_per_genotype
  def unbounded, do: @unbounded


  @doc """
  Write out the INFO field as a string to be used in the header
  """
  def header_info(info) do
    @header <> "<#{header_string(info)}>"
  end

  defp header_string(info) do
    str = "ID=#{info.id},Number=#{info.number},Type=#{Atom.to_string(info.type) |> String.capitalize},Description=\"#{info.description}\""
    str = case info.source  do
      "" -> str
      _ -> str <> ",Source=\"#{info.source}\""
    end

    str = case info.version do
      "" -> str
      _ -> str <> ",Version=\"#{info.version}\""
    end
    str
  end

  defp new(id, number, type, description, source, version) do
    %VcfInfo{
      id: id,
      number: number,
      type: type,
      description: description,
      source: source,
      version: version
    }
  end
end
