defmodule ExVcf.Vcf.Vcf do
  alias ExVcf.Vcf.Vcf

  # The vcf version that this module implements
  @version 4.3


  defstruct fileformat: @version,
    header: [],
    body: [],
    missing: []

  def new do
    %Vcf{header: ExVcf.Vcf.Header.new}
  end

  def version, do: @version

end
