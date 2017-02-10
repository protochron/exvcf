defmodule ExVcf.Vcf.Body do
  alias ExVcf.Vcf.Body

  @info_regex ~r(/^[A-Za-z ][0-9A-Za-z .]*$/)

  defstruct chrom: "",
    pos: 1,
    id: [],
    ref: ".",
    alt: ".",
    qual: ".",
    filter: ".",
    info: [],
    format: [],
    misc: []

  @format_map [id: :stringify_id, format: :stringify_format, info: :stringify_info, misc: :stringify_misc]
  @optional_vals [:id, :ref, :alt, :qual, :filter, :info, :format, :misc]
  def str(line) do
    opts = Enum.map(@optional_vals, fn(x) ->
      case res = Map.get(line, x) do
        "." -> res
        [] -> "."
        _ -> case Keyword.get(@format_map, x) do
          nil -> res
          transform -> apply(__MODULE__, transform, [line])
        end
      end
    end)

    "#{line.chrom}\t#{line.pos}\t" <> Enum.join(opts, "\t") <> "\n"
  end

  def add_info(body, key, value) do
    %{body | info: [body.info, ["#{key}=#{value}"]]}
  end

  def add_id(body, value) do
    %{body | id: [body.id, [value]]}
  end

  def add_format(body, value) do
    %{body | format: [body.format, [value]]}
  end

  @doc false
  def stringify_info(body), do: Enum.join(body.info, ";")
  @doc false
  def stringify_format(body), do: Enum.join(body.format, ":")
  @doc false
  def stringify_id(body), do: Enum.join(body.id, ";")
  @doc false
  def stringify_misc(body), do: Enum.join(body.misc, ":")
end
