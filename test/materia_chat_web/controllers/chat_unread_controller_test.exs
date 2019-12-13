defmodule MateriaChatWeb.ChatUnreadControllerTest do
  use MateriaChatWeb.ConnCase

  alias MateriaChat.Messages
  alias MateriaChat.Messages.ChatUnread

  @create_attrs %{chat_message_id: 42, is_unread: 42, lock_version: 42, user_id: 42}
  @update_attrs %{chat_message_id: 43, is_unread: 43, lock_version: 43, user_id: 43}
  @invalid_attrs %{chat_message_id: nil, is_unread: nil, lock_version: nil, user_id: nil}

  def fixture(:chat_unread) do
    {:ok, chat_unread} = Messages.create_chat_unread(@create_attrs)
    chat_unread
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all chat_unreads", %{conn: conn} do
      conn = get(conn, chat_unread_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chat_unread" do
    test "renders chat_unread when data is valid", %{conn: conn} do
      conn = post(conn, chat_unread_path(conn, :create), chat_unread: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, chat_unread_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "chat_message_id" => 42,
               "is_unread" => 42,
               "lock_version" => 42,
               "user_id" => 42
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, chat_unread_path(conn, :create), chat_unread: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chat_unread" do
    setup [:create_chat_unread]

    test "renders chat_unread when data is valid", %{conn: conn, chat_unread: %ChatUnread{id: id} = chat_unread} do
      conn = put(conn, chat_unread_path(conn, :update, chat_unread), chat_unread: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, chat_unread_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "chat_message_id" => 43,
               "is_unread" => 43,
               "lock_version" => 43,
               "user_id" => 43
             }
    end

    test "renders errors when data is invalid", %{conn: conn, chat_unread: chat_unread} do
      conn = put(conn, chat_unread_path(conn, :update, chat_unread), chat_unread: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chat_unread" do
    setup [:create_chat_unread]

    test "deletes chosen chat_unread", %{conn: conn, chat_unread: chat_unread} do
      conn = delete(conn, chat_unread_path(conn, :delete, chat_unread))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, chat_unread_path(conn, :show, chat_unread))
      end)
    end
  end

  defp create_chat_unread(_) do
    chat_unread = fixture(:chat_unread)
    {:ok, chat_unread: chat_unread}
  end
end
