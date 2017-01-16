defmodule ElixirVcf.Vcf.Vcf do
  alias ElixirVcf.Vcf.Vcf

  # The vcf version that this module implements
  @version 4.2

  defstruct fileformat: @version,
    header: [],
    body: [],
    missing: []

  def new do
    %Vcf{
      header: [
        "##fileDate=#{today_date()}",
        "##source=ElixirVcf",
        # "##reference=filename",
        "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tGENOTYPE"
      ]
    }
  end

  defp today_date do
    Date.utc_today
    |> Date.to_string
    |> String.replace("-", "")
  end
end
