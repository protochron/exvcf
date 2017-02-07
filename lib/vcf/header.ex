defmodule ExVcf.Vcf.Header do
  alias ExVcf.Vcf.Header
  alias ExVcf.Vcf.HeaderLine

  # The ending header string
  @end_header"#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO"

  defstruct meta: MapSet.new,
    info: MapSet.new,
    filter: MapSet.new,
    format: MapSet.new,
    samples: MapSet.new,
    version: ""

  def new() do
    %Header{
      meta: MapSet.new([HeaderLine.new_kv("fileDate", today_date()),
                        HeaderLine.new_kv("source", "ExVcf")]),
      version: HeaderLine.new_kv("fileformat", "VCFv#{ExVcf.Vcf.Vcf.version()}"),
    }
  end

  def add_meta(header, value) do
    %{header | meta: MapSet.put(header.meta, value)}
  end

  def add_info(header, value) do
    %{header | info: MapSet.put(header.info, value)}
  end

  def add_format(header, value) do
    %{header | format: MapSet.put(header.format, value)}
  end

  def add_filter(header, value) do
    %{header | filter: MapSet.put(header.filter, value)}
  end

  def add_sample(header, value) do
    %{header | samples: MapSet.put(header.samples, value)}
  end

  def stringify(header) do
    mapper = fn(x) -> HeaderLine.header_string(x) end
    lines = for n <- [header.meta, header.info, header.filter, header.format],
        MapSet.size(n) > 0, do: Enum.map(n, mapper)
    [header.version |> HeaderLine.header_string(), lines, end_header(header)]
  end

  def end_header(header) do
    hdr = @end_header
    hdr = case MapSet.size(header.format) > 0 do
      true -> "#{hdr}\tFORMAT"
      false -> hdr
    end

    hdr = case header.samples != [] do
      true -> "#{hdr}\t#{Enum.join(header.samples, "\t")}"
      false -> hdr
    end

    "#{hdr}\n"
  end

  @doc ~S"""
  Encode an assembly line into the header
  ## Example

      iex> ExVcf.Vcf.Header.assembly("http://example.com")
      %ExVcf.Vcf.HeaderLine{fields: [], key: "assembly", value: "http://example.com"}
  """
  def assembly(url) do
    HeaderLine.new_kv("assembly", url)
  end

  def contig(data) do
    HeaderLine.new("contig", data)
  end

  def add_line(key, value) do
    HeaderLine.new(key, value)
  end

  defp today_date do
    Date.utc_today
    |> Date.to_string
    |> String.replace("-", "")
  end

end
