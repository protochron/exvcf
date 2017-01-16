defmodule ElixirVcf.Vcf.Constants do
  @genotype_unphased "/"
  @genotype_phased "|"

  @reserved_info_keys [
    "AA",
    "AC",
    "AF",
    "AN",
    "BQ",
    "CIGAR",
    "DB",
    "DP",
    "END",
    "H2",
    "H3",
    "MQ",
    "MQ0",
    "NS",
    "SB",
    "SOMATIC",
    "VALIDATED",
    "1000G"
  ]

  def genotype_phased, do: @genotype_phased

  def genotype_unphased, do: @genotype_unphased

  def reserved_info_keys, do: @reserved_info_keys

end
