defmodule Poster.Categories do
  use Poster.Web, :model

  schema "categories" do
    field :parent_id, :string
    field :category_id, :string
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:parent_id, :category_id, :name, :description])
    |> validate_required([:parent_id, :category_id, :name, :description])
  end

  def alphabetical(query) do
    from c in query, where: c.parent_id == "null", order_by: c.name
  end

  def names_and_ids(query) do
    from c in query, where: c.parent_id == "null", select: {c.name, c.id}
  end
end
