defmodule Poster.PostsController do
  use Poster.Web, :controller

  alias Poster.Posts
  alias Poster.Categories
  alias Poster.QueryFilter

  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, params) do
    page = Posts
           |> QueryFilter.filter(params, [:categories_id])
           #|> Repo.all
           |> Repo.paginate(params)

    categories = Repo.all Categories

    render conn, "index.html", posts: page.entries, page: page, categories: categories
  end

  def new(conn, _params) do
    changeset = Posts.changeset(%Posts{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"posts" => post_params}) do
    changeset = Posts.changeset(%Posts{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: posts_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

    def show(conn, %{"id" => id}) do
      post = Posts.get_and_preload_category(id)
      render(conn, "show.html", post: post)
    end

    def edit(conn, %{"id" => id}) do
      post = Repo.get!(Posts, id)
      changeset = Posts.changeset(post)
      render(conn, "edit.html", post: post, changeset: changeset)
    end

    def update(conn, %{"id" => id, "posts" => post_params}) do
      post = Repo.get!(Posts, id)
      changeset = Posts.changeset(post, post_params)

      case Repo.update(changeset) do
        {:ok, post} ->
          conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: posts_path(conn, :show, post))
        {:error, changeset} ->
          render(conn, "edit.html", post: post, changeset: changeset)
      end
    end

    def delete(conn, %{"id" => id}) do
      post = Repo.get!(Posts, id)

      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise an error).
      Repo.delete!(post)

      conn
      |> put_flash(:info, "Post deleted successfully.")
      |> redirect(to: posts_path(conn, :index))
    end

    def filter(conn, %{"id" => id}) do
      posts = Posts.get_and_preload_category(id)
      render conn, "index.html", posts: posts
    end

    defp load_categories(conn, _) do
      query =
        Categories
        |> Categories.alphabetical
        |> Categories.names_and_ids

      categories = Repo.all query
      assign(conn, :categories, categories)
    end
end
