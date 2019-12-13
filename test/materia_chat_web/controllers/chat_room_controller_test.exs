defmodule MateriaChatWeb.ChatRoomControllerTest do
  use MateriaChatWeb.ConnCase

  alias MateriaChat.Rooms
  alias MateriaChat.Rooms.ChatRoom

  @create_attrs %{access_poricy: "some access_poricy", lock_version: 42, status: 42, title: "some title"}
  @update_attrs %{access_poricy: "some updated access_poricy", status: 43, title: "some updated title"}

  def fixture(:chat_room) do
    {:ok, chat_room} = Rooms.create_chat_room(@create_attrs)
    chat_room
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all chat_rooms", %{conn: conn} do
      conn = get(conn, chat_room_path(conn, :index))
      resp = json_response(conn, 200)
      assert length(resp) == 2
    end
  end

  describe "create chat_room" do
    test "renders chat_room when data is valid", %{conn: conn} do
      conn = post(conn, chat_room_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, chat_room_path(conn, :show, id))
      resp = json_response(conn, 200)

      assert resp == %{
               "id" => id,
               "access_poricy" => "some access_poricy",
               "lock_version" => resp["lock_version"],
               "status" => 42,
               "title" => "some title",
               "members" => []
             }
    end
  end

  describe "update chat_room" do
    setup [:create_chat_room]

    test "renders chat_room when data is valid", %{conn: conn, chat_room: %ChatRoom{id: id} = chat_room} do
      conn = put(conn, chat_room_path(conn, :update, chat_room), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, chat_room_path(conn, :show, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "access_poricy" => "some updated access_poricy",
               "lock_version" => 43,
               "status" => 43,
               "title" => "some updated title",
               "members" => []
             }
    end
  end

  describe "delete chat_room" do
    setup [:create_chat_room]

    test "deletes chosen chat_room", %{conn: conn, chat_room: chat_room} do
      conn = delete(conn, chat_room_path(conn, :delete, chat_room))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, chat_room_path(conn, :show, chat_room))
      end)
    end
  end

  defp create_chat_room(_) do
    chat_room = fixture(:chat_room)
    {:ok, chat_room: chat_room}
  end
end
