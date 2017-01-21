defmodule ExVcf.Vcf.InfoTest do
  use ExUnit.Case
  alias ExVcf.Vcf.Info

  setup _context do
    {:ok, [test_info: %Info{id: 123, number: 1, type: :string, description: "Some text"}]}
  end

  test "using info string", context do
    info = Info.new_string(123, 1, "Some text")
    assert info.id == 123
    assert info == context[:test_info]

    info2 = Info.new_string(123,
                        1,
                        "Some text",
                        "source",
                        "version")
    assert info2 != info
  end
end
