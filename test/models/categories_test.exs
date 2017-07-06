defmodule Poster.CategoriesTest do
  use Poster.ModelCase

  alias Poster.Categories

  @valid_attrs %{description: "some content", n: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Categories.changeset(%Categories{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Categories.changeset(%Categories{}, @invalid_attrs)
    refute changeset.valid?
  end
end
