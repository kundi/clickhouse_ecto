defmodule ClickhouseEcto.StorageSpec do
    alias ClickhouseEcto.Storage

    use ESpec

    describe("storage spec") do
        context("up storage") do
            it("status of running database chtry should be :ok") do
                opts = [{:database, :chtry}]
                Storage.storage_up(opts) |> should(be :ok)
            end
            
            it("status of running database new_database should be :ok") do
                opts = [{:database, :new_database}]
                Storage.storage_up(opts) |> should(be :ok)
            end
        end

        context("down storage") do
            before do
                Storage.storage_up([{:database, :chtry}])
                Storage.storage_up([{:database, :new_database}])
            end

            it("status of dropping database chrty should be :ok") do
                opts = [{:database, :chtry}]
                Storage.storage_down(opts) |> should(be :ok)
            end

            context("down already dropped database") do
                before do
                    Storage.storage_down([{:database, :chtry}])
                end

                it("status of dropping database chrty should be :already_down") do
                    opts = [{:database, :chtry}]
                    Storage.storage_down(opts) |> should(be {:error, :already_down})
                end
            end
        end

        after_all do
            Storage.storage_down([{:database, :chtry}])
            Storage.storage_down([{:database, :new_database}])
        end
    end
end