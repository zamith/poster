defmodule Poster.QueryFilter do
  def filter(query, params, filters) do
    import Ecto.Query, only: [from: 2]

    filter_params = (Map.get(params, "filter") || %{})
    |> strip_empty_values()

    Enum.reduce(filters, query, fn (filter, queryable) ->
        if Map.has_key?(filter_params, to_string filter) do
          from(q in queryable, where: field(q, ^filter) == ^Map.get(filter_params, to_string filter))
        else
          queryable
        end
    end)
  end

  defp strip_empty_values(map) do
    Enum.reduce(map, map, fn ({k, v}, acc) ->
        if v == "", do: Map.drop(acc, [k]), else: acc
    end)
  end
end