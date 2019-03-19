defmodule MateriaChatWeb.ChatMessageControllerTest do
  use MateriaChatWeb.ConnCase

  alias MateriaChat.Messages
  alias MateriaChat.Messages.ChatMessage

  @create_attrs %{body: "some body", chat_room_id: 42, from_user_id: 42, lock_version: 42, status: 42}
  @update_attrs %{body: "some updated body", chat_room_id: 43, from_user_id: 43, lock_version: 43, status: 43}
  @invalid_attrs %{body: nil, chat_room_id: nil, from_user_id: nil, lock_version: nil, status: nil}

  def fixture(:chat_message) do
    {:ok, chat_message} = Messages.create_chat_message(@create_attrs)
    chat_message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all chat_messages", %{conn: conn} do
      conn = get conn, chat_message_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chat_message" do
    test "renders chat_message when data is valid", %{conn: conn} do
      conn = post conn, chat_message_path(conn, :create), chat_message: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, chat_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some body",
        "chat_room_id" => 42,
        "from_user_id" => 42,
        "lock_version" => 42,
        "status" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, chat_message_path(conn, :create), chat_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chat_message" do
    setup [:create_chat_message]

    test "renders chat_message when data is valid", %{conn: conn, chat_message: %ChatMessage{id: id} = chat_message} do
      conn = put conn, chat_message_path(conn, :update, chat_message), chat_message: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, chat_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "body" => "some updated body",
        "chat_room_id" => 43,
        "from_user_id" => 43,
        "lock_version" => 43,
        "status" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, chat_message: chat_message} do
      conn = put conn, chat_message_path(conn, :update, chat_message), chat_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chat_message" do
    setup [:create_chat_message]

    test "deletes chosen chat_message", %{conn: conn, chat_message: chat_message} do
      conn = delete conn, chat_message_path(conn, :delete, chat_message)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, chat_message_path(conn, :show, chat_message)
      end
    end
  end

  defp create_chat_message(_) do
    chat_message = fixture(:chat_message)
    {:ok, chat_message: chat_message}
  end
end
