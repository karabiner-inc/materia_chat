defmodule MateriaChatWeb.ChatMessageController do
  use MateriaChatWeb, :controller

  alias MateriaChat.Messages
  alias MateriaChat.Messages.ChatMessage

  alias MateriaWeb.ControllerBase

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    chat_messages = Messages.list_chat_messages()
    render(conn, "index.json", chat_messages: chat_messages)
  end

  def create(conn, %{"chat_message" => chat_message_params}) do
    with {:ok, %ChatMessage{} = chat_message} <- Messages.create_chat_message(chat_message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", chat_message_path(conn, :show, chat_message))
      |> render("show.json", chat_message: chat_message)
    end
  end

  def show(conn, %{"id" => id}) do
    chat_message = Messages.get_chat_message!(id)
    render(conn, "show.json", chat_message: chat_message)
  end

  def update(conn, %{"id" => id, "chat_message" => chat_message_params}) do
    chat_message = Messages.get_chat_message!(id)

    with {:ok, %ChatMessage{} = chat_message} <- Messages.update_chat_message(chat_message, chat_message_params) do
      render(conn, "show.json", chat_message: chat_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat_message = Messages.get_chat_message!(id)
    with {:ok, %ChatMessage{}} <- Messages.delete_chat_message(chat_message) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_my_chat_messages_recent(conn, params) do
    id = ControllerBase.get_user_id(conn)
    chat_room_id = params["chat_room_id"]
    limit_count = params["limit_count"]
    first_message_id = params["first_message_id"]
    chat_messages = Messages.list_my_chat_messages_recent(chat_room_id, id, limit_count, first_message_id)
    render(conn, "index.json", chat_messages: chat_messages)
  end

  def list_my_unread_messages(conn) do
    user_id = ControllerBase.get_user_id(conn)
    unread_messages = Messages.list_my_unread_messages(user_id)
    render(conn, "unread_messages.json", unread_messages: unread_messages)
  end
end
