defmodule AndmeRef do
  defp read_ref(opts) do
    {:ok, file} = File.read(opts[:file])
    String.split(file, "\n")
  end

  defp build_map(file) do
    result = Enum.reduce(file, %{}, fn data, acc ->
      case String.split(data) do
        [chr, pos, rsid, ref] ->
          res = case Map.has_key?(acc, String.to_atom(chr)) do
            true -> Map.get(acc, String.to_atom(chr)) |> Map.put(String.to_integer(pos), %{:ref => ref, :rsid => rsid})
            false -> %{String.to_integer(pos) => %{:ref => ref, :rsid => rsid}}
          end
          Map.put(acc, String.to_atom(chr), res)
        _ -> acc
      end
    end)

    {:ok, cwd} = File.cwd
    path = cwd |> Path.join("data") |> Path.join("23andme_v4_grch37_ref.erlang")
    IO.puts path
    File.write!(path, :erlang.term_to_binary(result))
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
                                         switches: [file: :string])
    options
  end

  def main(args) do
    args |> parse_args |> read_ref |> build_map
  end
end

AndmeRef.main(System.argv)
