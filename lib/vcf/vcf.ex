defmodule ExVcf.Vcf.Vcf do
  alias ExVcf.Vcf.Vcf

  # The vcf version that this module implements
  @version 4.2

  # The ending header string
  @end_header"#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tGENOTYPE"

  defstruct fileformat: @version,
    header: [],
    info: [],
    body: [],
    missing: []

  def new do
    %Vcf{
      header: [
        "##fileDate=#{today_date()}",
        "##source=ElixirVcf",
        # "##reference=filename",
      ]
    }
  end

  def add_info(vcf, info), do: %{vcf | info: vcf.info ++ info}

  defp today_date do
    Date.utc_today
    |> Date.to_string
    |> String.replace("-", "")
  end

end
