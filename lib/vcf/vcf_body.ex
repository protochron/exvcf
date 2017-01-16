defmodule ExVcf.Vcf.VcfBody do
  alias ExVcf.Vcf.VcfBody

  defstruct chrom: "",
    pos: 1,
    id: "",
    ref: "",
    alt: "",
    qual: "",
    filter: "",
    info: %{},
    format: [],
    samples: []

end
