defmodule ClickhouseEcto.HelpersSpec do

  alias ClickhouseEcto.Helpers
  use ESpec

  it do: Helpers.ecto_to_db({:array, :id})                   |> should(be  "Array(UInt32)")
  it do: Helpers.ecto_to_db(:id)                             |> should(be  "UInt32")
  it do: Helpers.ecto_to_db(:binary_id)                      |> should(be  "FixedString(36)")
  it do: Helpers.ecto_to_db(:uuid)                           |> should(be  "FixedString(36)")
  it do: Helpers.ecto_to_db(:string)                         |> should(be  "String")
  it do: Helpers.ecto_to_db(:binary)                         |> should(be  "FixedString(4000)")
  it do: Helpers.ecto_to_db(:integer)                        |> should(be  "Int32")
  it do: Helpers.ecto_to_db(:bigint)                         |> should(be  "Int64")
  it do: Helpers.ecto_to_db(:float)                          |> should(be  "Float32")
  it do: Helpers.ecto_to_db(:decimal)                        |> should(be  "Float64")
  it do: Helpers.ecto_to_db(:boolean)                        |> should(be  "UInt8")
  it do: Helpers.ecto_to_db(:date)                           |> should(be  "Date")
  it do: Helpers.ecto_to_db(:utc_datetime)                   |> should(be  "DateTime")
  it do: Helpers.ecto_to_db(:naive_datetime)                 |> should(be  "DateTime")
  it do: Helpers.ecto_to_db(:timestamp)                      |> should(be  "DateTime")
  it do: Helpers.ecto_to_db(:UInt64)                         |> should(be  "UInt64")

  it do: Helpers.single_quote("xyz")                         |> should(be  [39, "xyz", 39])
  it do: Helpers.wrap_in("a", "b")                           |> should(be  ["b", "a", "b"]) 
  it do: Helpers.wrap_in("a", {"b", "c"})                    |> should(be  ["b", "a", "c"]) 

  it do: Helpers.intersperse_map([1, 2], 4, fn(x) -> [x, 0] end, 3) |> should(be [[3, [1, 0], 4], 2, 0])

  it do: Helpers.quote_name("xxx")                           |> should(be  [?", "xxx", ?"])
  it do: Helpers.quote_name("xxx", "xx")                     |> should(be  ["xx", "xxx", "xx"])

  it do: Helpers.quote_qualified_name("xx", {1, {0, 2, 0}}, 1)|> should(be  [2, ?., ?", "xx", ?"])
end
