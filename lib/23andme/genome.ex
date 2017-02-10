defmodule ExVcf.Andme.Genome do
  alias ExVcf.Andme.Genome

  require ExVcf.Vcf.Body
  alias ExVcf.Vcf.Body
  alias ExVcf.Vcf.Vcf

  @bases ~r(/[A,C,G,T,N,a,c,g,t,n]/)

  defstruct rsid: "",
    chromosome: "",
    position: 0,
    genotype: ""

  def new(rsid, chromosome, position, genotype) do
    %Genome{rsid: rsid,
      chromosome: chromosome,
      position: String.to_integer(position),
      genotype: String.trim(genotype)}
  end

  def new(data) do
    apply(Genome, :new, data)
  end

  # This is a pre-compressed binary representation of a map
  def ref_path, do:  Path.join(~w(#{File.cwd!} data /23andme_v4_hg19_ref.erlang))
  def read_reference do
    ref_path() |> File.read! |> :erlang.binary_to_term
  end

  # TODO Add error handling somewhere in here
  def read_from_file(filename) do
    filename |>
    File.read!
    |> String.splitter("\n", trim: true)
    |> Enum.reduce([], fn(x, acc) ->
      case String.first(x) do
        "#" -> acc
        _ -> [new(String.split(x, "\t")) | acc]
      end
    end)
    |> Enum.reverse
  end

  # TODO clean up this mess
  def convert(file) do
    errors = []
    ref = read_reference()
    result = file |> Enum.reduce([], fn(x, acc) ->
      case Map.get(ref, String.to_atom(convert_chrom(x.chromosome))) do
        nil ->
          [x | errors]
          acc
        chrom ->
          case Map.get(chrom, x.position) do
            nil -> acc
            val -> case vcf_line(val, x) do
              nil -> acc
              res -> [res | acc]
            end

          end
      end
    end)
    |> Enum.reverse

    case errors do
      [] -> {:ok, result}
      _ -> {:error, result, errors}
    end
  end

  def vcf(file) do
    case file |> read_from_file |> convert do
      {:ok, result} ->
        vcf = Vcf.new
        header = vcf.header
                 |> ExVcf.Vcf.Header.add_format(ExVcf.Vcf.Format.new_string("GT", 1, "Genotype"))
                 |> ExVcf.Vcf.Header.add_sample("GENOTYPE")
        %{vcf | header: header, body: result} |> stringify
    end
  end

  def stringify(vcf) do
    [ExVcf.Vcf.Header.stringify(vcf.header), Enum.map(vcf.body, fn(x) -> Body.str(x) end)]
  end

  defp convert_chrom(chrom) do
    case chrom do
      "MT" -> "chrM"
      x -> "chr#{x}"
    end
  end

  def vcf_line(_, %Genome{genotype: "--"}), do: nil
  def vcf_line(_, %Genome{genotype: "DD"}), do: nil
  def vcf_line(_, %Genome{genotype: "II"}), do: nil
  def vcf_line(_, %Genome{genotype: "DI"}), do: nil
  def vcf_line(_, %Genome{genotype: "I"}), do: nil
  def vcf_line(_, %Genome{genotype: "D"}), do: nil
  def vcf_line(ref, data) do
    ref_base = ref |> Map.get(:ref) |> String.capitalize
    body = %Body{pos: data.position, id: [data.rsid], ref: ref_base}
    allele = data.genotype
             |> String.split("", parts: 2)
             |> Enum.map(fn(x) -> String.capitalize(x) end)
    proc_allele(%{body | chrom: convert_chrom(data.chromosome)}, allele)
  end

  defp proc_allele(vcf, [a, b]) when a == b do
    case a == vcf.ref do
      true -> %{vcf | alt: ".", format: ["GT"], misc: ["0#{ExVcf.Vcf.Constants.genotype_unphased}0"]}
      false -> %{vcf | alt: a, format: ["GT"], misc: ["1#{ExVcf.Vcf.Constants.genotype_unphased}1"]}
    end
  end
  defp proc_allele(vcf, [a, ""]) do
    case a == vcf.ref do
      true -> %{vcf | alt: ".", format: ["GT"], misc: ["0"]}
      false -> %{vcf | alt: a, format: ["GT"], misc: ["1"]}
    end
  end
  defp proc_allele(vcf, [a, b]) do
    cond do
      a == vcf.ref ->
        %{vcf | alt: b, format: ["GT"], misc: ["0#{ExVcf.Vcf.Constants.genotype_unphased}1"]}
      b == vcf.ref ->
        %{vcf | alt: a, format: ["GT"], misc: ["0#{ExVcf.Vcf.Constants.genotype_unphased}1"]}
      true ->
        %{vcf | alt: "#{a},#{b}", format: ["GT"], misc: ["1#{ExVcf.Vcf.Constants.genotype_unphased}2"]}
    end
  end
end
