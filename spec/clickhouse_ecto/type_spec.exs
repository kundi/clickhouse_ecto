defmodule ClickhouseEcto.TypeSpec do
  
  alias ClickhouseEcto.Type
  use ESpec

  it do: Type.encode(123, :bigint)                          |> should(be {:ok, "123"})
  it do: Type.encode(12.22, :decimal)                       |> should(be {:ok, 12.22})
  it do: Type.encode(123, :xxxyyyzzz)                       |> should(be {:ok, 123})

  it do: Type.decode(123, :bigint)                          |> should(be {:ok, 123})
  it do: Type.decode("123", :bigint)                        |> should(be {:ok, 123})
  it do: Type.decode("12x", :bigint)                        |> should(be {:ok, 12})
  it do: Type.decode("xx12x", :bigint)                      |> should(be {:error, "Not an integer id"})
  it do: Type.decode("987", :decimal)                       |> should(be {:ok, Decimal.new(987)})
  it do: Type.decode("987", :numeric)                       |> should(be {:ok, Decimal.new(987)})
  it do: Type.decode("123.4", :float)                       |> should(be {:ok, 123.4})
  it do: Type.decode("123.4x", :float)                      |> should(be {:ok, 123.4})
  it do: Type.decode("x23.4x", :float)                      |> should(be {:error, "Not a float value"})
  it do: Type.decode({0, {1, 2, 3}}, :utc_datetime)         |> should(be {:ok, {0, {1, 2, 3, 0}}})
  it do: Type.decode({0, {1, 2, 3}}, :native_datetime)      |> should(be {:ok, {0, {1, 2, 3, 0}}})
  it do: Type.decode("1999-10-10", :date)                   |> should(be {:ok, ~D[1999-10-10]})
  it do: Type.decode("xxx", :xxxyyyzzz)                     |> should(be {:ok, "xxx"})

end
