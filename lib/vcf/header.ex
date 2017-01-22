defmodule ExVcf.Vcf.Header do
  def accumulate_fields(fields) do
    Enum.reduce(fields, [],
                fn(x, acc) ->
                  {k, v} = x
                  acc ++ ["#{k |> Atom.to_string |> String.capitalize}=\"#{v}\""] end)
  end
end
