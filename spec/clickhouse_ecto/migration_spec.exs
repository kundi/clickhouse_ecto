defmodule ClickhouseEcto.MigrationSpec do
    alias ClickhouseEcto.Migration
    alias Ecto.Migration.{Table}
    use ESpec

    describe "migration spec" do
        context("execute dll inner when command is type of Ecto.Adapter.Migration.command") do
            
            it "CREATE TABLE IF NOT EXISTS command and engne is nil" do
                command = {:create_if_not_exists,
                    %Ecto.Migration.Table{
                        comment: nil,
                        engine: nil,
                        name: :schema_migrations,
                        options: nil,
                        prefix: nil,
                        primary_key: true
                    },
                    [
                        {:add, :version, :bigint, [primary_key: true]},
                        {:add, :inserted_at, :naive_datetime, []}
                    ]}
                
                query = Migration.execute_ddl(command)
                query |> should(be "CREATE TABLE IF NOT EXISTS \"schema_migrations\" (\"version\" Int64, \"inserted_at\" DateTime) ENGINE = TinyLog ")
            end

            it "CREATE TABLE IF NOT EXISTS command and engine is MergeTree" do
                command = {:create_if_not_exists,
                    %Ecto.Migration.Table{
                        comment: nil,
                        engine: "MergeTree(date,(date, name, is_new), 8192)",
                        name: "books",
                        options: nil,
                        prefix: nil,
                        primary_key: true
                    },
                    [
                        {:add, :id, :bigserial, [primary_key: true]},
                        {:add, :name, :string, [default: "unknown book"]},
                        {:add, :is_new, :boolean, [default: true]},
                        {:add, :date, :date, [default: :today]},
                        {:add, :inserted_at, :naive_datetime, [null: false]}
                    ]}

                query = Migration.execute_ddl(command)
                query |> should(be "CREATE TABLE IF NOT EXISTS \"books\" (\"name\" String  DEFAULT 'unknown book', \"is_new\" UInt8 DEFAULT 1, \"date\" Date DEFAULT today(), \"inserted_at\" DateTime ) ENGINE = MergeTree(date,(date, name, is_new), 8192)  ")
            end

            it "CREATE TABLE IF NOT EXISTS command, engine is MergeTree, various types of data" do
                command = {:create_if_not_exists,
                    %Ecto.Migration.Table{
                        comment: nil,
                        engine: "MergeTree(date,(date, name, character_id, level, hp, is_visible, weight, start_day, server_loggin), 8192)",
                        name: "characters",
                        options: nil,
                        prefix: nil,
                        primary_key: true
                    },
                    [
                        {:add, :id, :bigserial, [primary_key: true]},
                        {:add, :name, :string, [default: 0]},
                        {:add, :character_id, :id, [default: 1]},
                        {:add, :level, :integer, [default: 1]},
                        {:add, :hp, :float, [default: 100.0]},
                        {:add, :is_visible, :integer, [default: 0]},
                        {:add, :weight, :decimal, [default: 10]},
                        {:add, :start_day, :date, [default: "2019-06-19"]},
                        {:add, :server_loggin, :utc_datetime, [default: "0000-00-00 00:00:00"]},
                        {:add, :date, :date, [default: :today]},
                        {:add, :inserted_at, :naive_datetime, [null: false]}
                    ]}
    
                query = Migration.execute_ddl(command)
                query |> should(be "CREATE TABLE IF NOT EXISTS \"characters\" (\"name\" String  DEFAULT 0, \"character_id\" UInt32 DEFAULT 1, \"level\" Int32 DEFAULT 1, \"hp\" Float32 DEFAULT 100.0, \"is_visible\" Int32 DEFAULT 0, \"weight\" Float64 DEFAULT 10, \"start_day\" Date DEFAULT '2019-06-19', \"server_loggin\" DateTime DEFAULT '0000-00-00 00:00:00', \"date\" Date DEFAULT today(), \"inserted_at\" DateTime ) ENGINE = MergeTree(date,(date, name, character_id, level, hp, is_visible, weight, start_day, server_loggin), 8192)  ")
            end

            it "ALTER TABLE: add column" do
                table = %Ecto.Migration.Table{
                    comment: nil,
                    engine: nil,
                    name: "books",
                    options: nil,
                    prefix: nil,
                    primary_key: true
                  }
                
                changes = [{:add, :publisher, :string, []}]
                [
                  [
                    [
                      "ALTER TABLE ",
                      [34, "books", 34],
                      " ADD COLUMN \"publisher\" String ",
                      "; "
                    ],
                    []
                  ]
                ]
                [
                  [
                    [
                      [
                        "ALTER TABLE ",
                        [34, "books", 34],
                        " ADD COLUMN \"publisher\" String ",
                        "; "
                      ],
                      []
                    ]
                  ]
                ]
                params = {:alter, %Table{} = table, changes}
                query = Migration.execute_ddl(params)
                query |> should(be "ALTER TABLE \"books\" ADD COLUMN \"publisher\" String ; ")
            end
        end
    end
end