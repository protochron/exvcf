defmodule ExVcf.Vcf.Constants do
  @genotype_unphased "/"
  @genotype_phased "|"

  def genotype_phased, do: @genotype_phased
  def genotype_unphased, do: @genotype_unphased
end
