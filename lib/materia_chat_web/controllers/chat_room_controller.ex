defmodule MateriaChatWeb.ChatRoomController do
  use MateriaChatWeb, :controller

  alias MateriaChat.Rooms
  alias MateriaChat.Rooms.ChatRoom

  alias MateriaWeb.ControllerBase

  action_fallback(MateriaWeb.FallbackController)

  def index(conn, _params) do
    chat_rooms = Rooms.list_chat_rooms()
    render(conn, "index.json", chat_rooms: chat_rooms)
  end

  def create(conn, chat_room_params) do
    with {:ok, %ChatRoom{} = chat_room} <- Rooms.create_chat_room(chat_room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", chat_room_path(conn, :show, chat_room))
      |> render("show.json", chat_room: chat_room)
    end
  end

  def show(conn, %{"id" => id}) do
    chat_room = Rooms.get_chat_room!(id)
    render(conn, "show.json", chat_room: chat_room)
  end

  def update(conn, chat_room_params) do
    chat_room = Rooms.get_chat_room!(chat_room_params["id"])

    with {:ok, %ChatRoom{} = chat_room} <- Rooms.update_chat_room(chat_room, chat_room_params) do
      render(conn, "show.json", chat_room: chat_room)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat_room = Rooms.get_chat_room!(id)

    with {:ok, %ChatRoom{}} <- Rooms.delete_chat_room(chat_room) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_my_chat_rooms(conn, _params) do
    id = ControllerBase.get_user_id(conn)
    chat_rooms = Rooms.list_my_chat_rooms(id)
    render(conn, "index.json", chat_rooms: chat_rooms)
  end

  def create_my_chat_room(conn, params) do
    id = ControllerBase.get_user_id(conn)
    ControllerBase.transaction_flow(conn, :chat_room, Rooms, :create_my_chat_room, [id, params])
  end

  def add_my_chat_room_members(conn, %{"chat_room_id" => chat_room_id, "members" => members}) do
    id = ControllerBase.get_user_id(conn)
    ControllerBase.transaction_flow(conn, :chat_room, Rooms, :add_my_chat_room_members, [id, chat_room_id, members])
  end

  def remove_my_chat_room_members(conn, %{"chat_room_id" => chat_room_id, "members" => members}) do
    id = ControllerBase.get_user_id(conn)
    ControllerBase.transaction_flow(conn, :chat_room, Rooms, :remove_my_chat_room_members, [id, chat_room_id, members])
  end
end
