defmodule ExVcf.Andme.Genome do
  alias ExVcf.Andme.Genome

  require ExVcf.Vcf.VcfBody
  alias ExVcf.Vcf.VcfBody

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

  def read_from_file(filename) do
    File.stream!(filename)
    |> Stream.filter_map(
      fn(x) ->
        case String.first(x) do
          "#" -> false
          _ -> true
        end end,
        fn(x) -> new(String.split(x, "\t")) end)
    |> Enum.to_list
  end

  #def convert_vcf(data) do
  #  Stream.filter_map(data, fn(x) ->
  #    case x.genotype do
  #      "DD" -> false
  #      "II" -> false
  #      _ -> true
  #    end
  #  end,
  #  fn(x) -> "" end) |> Enum.to_list
  #end

  #def genome_map(data) do
  #  Enum.reduce(%{}, fn(x, acc) ->
  #    case Map.get(acc, x.chr) do
  #      nil -> Map.put(acc, x.chr, %{rsid:  data.rsid, ref: })
  #      x -> Map.get(acc, x.chr) |> Map.put()
  #    end
  #    acc
  #  end
  #  )
  #end


  def vcf_line(%Genome{genotype: "DD"}), do: ""
  def vcf_line(%Genome{genotype: "II"}), do: ""
  def vcf_line(data) do
    body = %VcfBody{}
    chromosome = case data.chromosome do
      "MT" -> "chrM"
      x -> "chr#{x}"
    end
    body = %{body | chrom: chromosome}
  end
end
