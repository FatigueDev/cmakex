defmodule Cmakex.ETS.Template do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def create_table(opts), do: :ets.new(__MODULE__, opts)
      def delete_table, do: :ets.delete(__MODULE__)
      def clear_table, do: :ets.delete_all_objects(__MODULE__)

      def insert(value) when is_tuple(value) or is_list(value),
        do: :ets.insert(__MODULE__, value)

      def lookup(key) when is_atom(key), do: :ets.lookup(__MODULE__, key)

      def first, do: :ets.first(__MODULE__)
      def first(:lookup), do: :ets.first_lookup(__MODULE__)

      def delete(key) when is_atom(key), do: :ets.delete(__MODULE__, key)

      def count do
        case :ets.last(__MODULE__) do
          :"$end_of_table" -> :empty
          count -> count
        end
      end

      def update_counter(key, increment) do
        :ets.update_counter(__MODULE__, key, increment)
      end

      def walk do
        walk([:ets.first_lookup(__MODULE__)])
      end

      def walk([:"$end_of_table"]), do: []

      def walk([{current_key, _} = current | _rest] = result) do
        case :ets.next_lookup(__MODULE__, current_key) do
          :"$end_of_table" ->
            result

          next ->
            [next | result] |> walk()
        end
      end

      def to_list, do: :ets.tab2list(__MODULE__)

      defoverridable create_table: 1
      defoverridable clear_table: 0
      defoverridable insert: 1
    end
  end
end
