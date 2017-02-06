defmodule ExVcf.Andme.Genome do
  alias ExVcf.Andme.Genome

  require ExVcf.Vcf.Body
  alias ExVcf.Vcf.Body

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

  def read_from_file(filename) do
    filename |>
    File.read!
    |> String.splitter("\n", trim: true)
    |> Enum.filter(&filter_line/1)
    |> Enum.map(fn(x) -> new(String.split(x, "\t")) end)
  end

  def filter_line(line) do
    case String.first(line) do
      "#" -> false
      _ -> true
    end
  end

  def vcf_line(_, %Genome{genotype: "DD"}), do: ""
  def vcf_line(_, %Genome{genotype: "II"}), do: ""
  def vcf_line(ref, data) do
    body = %Body{pos: data.position, ref: data.rsid}
    chromosome = case data.chromosome do
      "MT" -> "chrM"
      x -> "chr#{x}"
    end
    allele = String.split(data.genotype, "", parts: 2)
    proc_allele(ref, %{body | chrom: chromosome}, allele)
  end

  defp proc_allele(ref, vcf, [a, ""]) do
    case a == Map.get(ref, :ref) do
      true -> %{vcf | alt: ".", format: ["GT"], misc: ["0"]}
      false -> %{vcf | alt: a, format: ["GT"], misc: ["1"]}
    end
  end
  defp proc_allele(ref, vcf, [a, b]) when a == b do
    case a == Map.get(ref, :ref) do
      true -> %{vcf | alt: ".", format: ["GT"], misc: ["0/0"]}
      false -> %{vcf | alt: a, format: ["GT"], misc: ["1/1"]}
    end
  end
  defp proc_allele(ref, vcf, [a, b]) do
    cond do
      a == Map.get(ref, :ref) ->
        %{vcf | alt: b, format: ["GT"], misc: ["0/1"]}
      b == Map.get(ref, :ref) ->
        %{vcf | alt: a, format: ["GT"], misc: ["0/1"]}
      true ->
        %{vcf | alt: "#{a},#{b}", format: ["GT"], misc: ["1/2"]}
    end
  end
end
