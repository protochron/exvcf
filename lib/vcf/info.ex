defmodule ExVcf.Vcf.Info do
  alias ExVcf.Vcf.Info

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
    optional_fields: []

  def new_string(id, number, description, optional \\ []) do
    new(id, number, @string, description, optional)
  end

  def new_integer(id, number, description, optional \\ []) do
    new(id, number, @integer, description, optional)
  end

  def new_float(id, number, description, optional \\ []) do
    new(id, number, @float, description, optional)
  end

  def new_character(id, number, description, optional \\ []) do
    new(id, number, @character, description, optional)
  end

  def new_flag(id, number, description, optional \\ []) do
    new(id, number, @flag, description, optional)
  end

  # Special-case numeric types
  def one_per_allele, do: @one_per_allele
  def one_per_alt_allele, do: @one_per_alt_allele
  def one_per_genotype, do: @one_per_genotype
  def unbounded, do: @unbounded

  def header(), do: @header

  @doc """
  Write out the INFO field as a string to be used in the header
  """
  defimpl ExVcf.Vcf.HeaderLine, for: Info do
    def header_line(nil), do: Info.header
    def header_line(info) do
      Info.header_string(info)
    end
  end

  # TODO figure out if there's a more generic way to handle this across the protocol
  def header_string(info) do
    type_str = info.type |> Atom.to_string |> String.capitalize
    str = ["ID=#{info.id}","Number=#{info.number}","Type=#{type_str}","Description=\"#{info.description}\""]
    new_fields = ExVcf.Vcf.Header.accumulate_fields(info.optional_fields)

    fields = str ++ new_fields
    "#{header()}<#{Enum.join(fields, ",")}>"
  end

  defp new(id, number, type, description, optional) do
    %Info{
      id: id,
      number: number,
      type: type,
      description: description,
      optional_fields: optional
    }
  end
end
