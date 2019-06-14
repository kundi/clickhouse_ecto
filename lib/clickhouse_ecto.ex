defmodule ClickhouseEcto do
  require IEx

  @moduledoc false
  @behaviour Ecto.Adapter.Storage

  use Ecto.Adapters.SQL, [driver: :clickhousex, migration_lock: nil]

  alias ClickhouseEcto.Migration
  alias ClickhouseEcto.Storage
  alias ClickhouseEcto.Structure

  import ClickhouseEcto.Type, only: [encode: 2, decode: 2]

  def autogenerate(:binary_id),       do: Ecto.UUID.generate()
  def autogenerate(type),             do: super(type)

  def dumpers({:embed, _} = type, _), do: [&Ecto.Adapters.SQL.dump_embed(type, &1)]
  def dumpers(:binary_id, _type),     do: []
  def dumpers(:uuid, _type),          do: []
  def dumpers(ecto_type, type),       do: [type, &(encode(&1, ecto_type))]

  def loaders({:embed, _} = type, _), do: [&Ecto.Adapters.SQL.load_embed(type, &1)]
  def loaders(ecto_type, type),       do: [&(decode(&1, ecto_type)), type]

  ## Migration
  def supports_ddl_transaction?, do: Migration.supports_ddl_transaction?

  ## Storage
  @impl true
  def storage_up(options), do: Storage.storage_up(options)

  @impl true
  def storage_down(options), do: Storage.storage_down(options)

  ## Structure
  def structure_dump(default, config), do: Structure.structure_dump(default, config)
  def structure_load(default, config), do: Structure.structure_load(default, config)
end
