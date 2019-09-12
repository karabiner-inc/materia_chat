defmodule MateriaChatWeb.ChatUnreadController do
  use MateriaChatWeb, :controller

  alias MateriaChat.Messages
  alias MateriaChat.Messages.ChatUnread

  alias MateriaWeb.ControllerBase

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    chat_unreads = Messages.list_chat_unreads()
    render(conn, "index.json", chat_unreads: chat_unreads)
  end

  def create(conn, %{"chat_unread" => chat_unread_params}) do
    with {:ok, %ChatUnread{} = chat_unread} <- Messages.create_chat_unread(chat_unread_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", chat_unread_path(conn, :show, chat_unread))
      |> render("show.json", chat_unread: chat_unread)
    end
  end

  def show(conn, %{"id" => id}) do
    chat_unread = Messages.get_chat_unread!(id)
    render(conn, "show.json", chat_unread: chat_unread)
  end

  def update(conn, %{"id" => id, "chat_unread" => chat_unread_params}) do
    chat_unread = Messages.get_chat_unread!(id)

    with {:ok, %ChatUnread{} = chat_unread} <- Messages.update_chat_unread(chat_unread, chat_unread_params) do
      render(conn, "show.json", chat_unread: chat_unread)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat_unread = Messages.get_chat_unread!(id)
    with {:ok, %ChatUnread{}} <- Messages.delete_chat_unread(chat_unread) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_my_unread_messages(conn, _params) do
    user_id = ControllerBase.get_user_id(conn)
    unread_messages = Messages.list_my_unread_messages(user_id)
    render(conn, "index.json", chat_unreads: unread_messages)
  end
end
