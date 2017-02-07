defmodule ExVcf.Vcf.HeaderLine do
  alias ExVcf.Vcf.HeaderLine

  # HeaderLine Types
  @character "Character"
  @flag "Flag"
  @float "Float"
  @integer "Integer"
  @string "String"

  # Special-case numeric values
  @one_per_alt_allele "A"
  @one_per_allele "R"
  @one_per_genotype "G"
  @unbounded "."

  @info_header "##INFO="
  @filter_header "##FILTER="
  @format_header "##FORMAT="

  @enforce_keys [:key]
  defstruct key: "",
    value: "",
    fields: []


  def string, do: @string
  def integer, do: @integer
  def float, do: @float
  def flag, do: @flag
  def character, do: @character

  def new_string(key, id, description, optional \\ []) do
    new(key, [ID: id, description: description, type: @string] ++ optional)
  end

  def new_integer(key, id, description, optional \\ []) do
    new(key, [ID: id, description: description, type: @integer] ++ optional)
  end

  def new_float(key, id, description, optional \\ []) do
    new(key, [ID: id, description: description, type: @float] ++ optional)
  end

  def new_character(key, id, description, optional \\ []) do
    new(key, [ID: id, description: description, type: @character] ++ optional)
  end

  def new_flag(key, id, description, optional \\ []) do
    new(key, [ID: id, description: description, type: @flag] ++ optional)
  end

  def new_kv(key, value), do: %HeaderLine{key: key, value: value}
  def new(key, fields), do: %HeaderLine{key: key, fields: fields}

  # Special-case numeric types
  def one_per_allele, do: @one_per_allele
  def one_per_alt_allele, do: @one_per_alt_allele
  def one_per_genotype, do: @one_per_genotype
  def unbounded, do: @unbounded

  def info_header(), do: @info_header
  def filter_header(), do: @filter_header
  def format_header(), do: @format_header


  def header_string(line) do
    case line.value do
      "" -> complex_header(line)
      _ -> simple_header(line)
    end
  end

  defp complex_header(line) do
    data = line.fields
           |> Enum.map(fn({k, v}) ->
             case k == :Type or k == :Number or k == :ID do
               true -> "#{Atom.to_string(k)}=#{v}"
               false -> "#{Atom.to_string(k)}=\"#{v}\""
             end
           end)
           |> Enum.join(",")
    "###{line.key}=<#{data}>\n"
  end

  defp simple_header(line) do
    "###{line.key}=#{line.value}\n"
  end
end
