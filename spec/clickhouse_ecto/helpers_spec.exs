defmodule ClickhouseEcto.HelpersSpec do

  alias ClickhouseEcto.Helpers
  use ESpec

  it do: Helpers.ecto_to_db({:array, :id}) |> should(be "Array(UInt32)")
  
  it do: Helpers.ecto_to_db(:id)              |> should(be  "UInt32")
  it do: Helpers.ecto_to_db(:binary_id)       |> should(be  "FixedString(36)")
  it do: Helpers.ecto_to_db(:uuid)            |> should(be  "FixedString(36)")
  it do: Helpers.ecto_to_db(:string)          |> should(be  "String")
  it do: Helpers.ecto_to_db(:binary)          |> should(be  "FixedString(4000)")
  it do: Helpers.ecto_to_db(:integer)         |> should(be  "Int32")
  it do: Helpers.ecto_to_db(:bigint)          |> should(be  "Int64")
  it do: Helpers.ecto_to_db(:float)           |> should(be  "Float32")
  it do: Helpers.ecto_to_db(:decimal)         |> should(be  "Float64")
  it do: Helpers.ecto_to_db(:boolean)         |> should(be  "UInt8")
  it do: Helpers.ecto_to_db(:date)            |> should(be  "Date")
  it do: Helpers.ecto_to_db(:utc_datetime)    |> should(be  "DateTime")
  it do: Helpers.ecto_to_db(:naive_datetime)  |> should(be  "DateTime")
  it do: Helpers.ecto_to_db(:timestamp)       |> should(be  "DateTime")
  it do: Helpers.ecto_to_db(:UInt64)          |> should(be  "UInt64")

end
