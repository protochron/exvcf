defmodule ElixirVcf.Vcf.VcfBody do
  alias ElixirVcf.Vcf.VcfBody

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
