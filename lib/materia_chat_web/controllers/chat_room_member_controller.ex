defmodule MateriaChatWeb.ChatRoomMemberController do
  use MateriaChatWeb, :controller

  alias MateriaChat.Rooms
  alias MateriaChat.Rooms.ChatRoomMember

  action_fallback(MateriaChatWeb.FallbackController)

  def index(conn, _params) do
    chat_room_members = Rooms.list_chat_room_members()
    render(conn, "index.json", chat_room_members: chat_room_members)
  end

  def create(conn, %{"chat_room_member" => chat_room_member_params}) do
    with {:ok, %ChatRoomMember{} = chat_room_member} <- Rooms.create_chat_room_member(chat_room_member_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", chat_room_member_path(conn, :show, chat_room_member))
      |> render("show.json", chat_room_member: chat_room_member)
    end
  end

  def show(conn, %{"id" => id}) do
    chat_room_member = Rooms.get_chat_room_member!(id)
    render(conn, "show.json", chat_room_member: chat_room_member)
  end

  def update(conn, %{"id" => id, "chat_room_member" => chat_room_member_params}) do
    chat_room_member = Rooms.get_chat_room_member!(id)

    with {:ok, %ChatRoomMember{} = chat_room_member} <-
           Rooms.update_chat_room_member(chat_room_member, chat_room_member_params) do
      render(conn, "show.json", chat_room_member: chat_room_member)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat_room_member = Rooms.get_chat_room_member!(id)

    with {:ok, %ChatRoomMember{}} <- Rooms.delete_chat_room_member(chat_room_member) do
      send_resp(conn, :no_content, "")
    end
  end
end
