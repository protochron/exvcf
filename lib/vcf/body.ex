defmodule ExVcf.Vcf.Body do
  alias ExVcf.Vcf.Body

  defstruct chrom: "",
    pos: 1,
    id: "",
    ref: "",
    alt: "",
    qual: "",
    filter: "",
    info: %{},
    format: [],
    misc: []

  def str do
  end

end
