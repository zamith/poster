defmodule Poster.CategoriesController do
  use Poster.Web, :controller

  alias Poster.Categories

  def index(conn, _params) do
    categories = Repo.all Categories
    render conn, "index.html", categories: categories
  end

  def new(conn, _params) do
    changeset = Categories.changeset(%Categories{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"categories" => category_params}) do
    changeset = Categories.changeset(%Categories{}, category_params)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: categories_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Categories, id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Categories, id)
    changeset = Categories.changeset(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "categories" => category_params}) do
    category = Repo.get!(Categories, id)
    changeset = Categories.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: categories_path(conn, :show, category))
      {:error, changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Categories, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise an error).
    Repo.delete!(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: categories_path(conn, :index))
  end
end
