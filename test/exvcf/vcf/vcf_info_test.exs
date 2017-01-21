defmodule ExVcf.Vcf.VcfInfoTest do
  use ExUnit.Case
  alias ExVcf.Vcf.VcfInfo

  setup _context do
    {:ok, [test_info: %VcfInfo{id: 123, number: 1, type: :string, description: "Some text"}]}
  end

  test "using info", context do
    info = VcfInfo.new_string(123, 1, "Some text")
    assert info.id == 123
    assert info == context[:test_info]


    info2 = VcfInfo.new_string(123,
                        1,
                        "Some text",
                        "source",
                        "version")
    assert info2 != info
  end
end
