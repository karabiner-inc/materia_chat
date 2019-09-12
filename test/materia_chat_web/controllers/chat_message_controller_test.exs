defmodule MateriaChatWeb.ChatMessageControllerTest do
 # use MateriaChatWeb.ConnCase
#
 # alias MateriaChat.Messages
 # alias MateriaChat.Messages.ChatMessage
#
 # @create_attrs %{body: "some body", chat_room_id: 42, from_user_id: 42, lock_version: 42, status: 42}
 # @update_attrs %{body: "some updated body", chat_room_id: 43, from_user_id: 43, lock_version: 43, status: 43}
 # @invalid_attrs %{body: nil, chat_room_id: nil, from_user_id: nil, lock_version: nil, status: nil}
#
 # def fixture(:chat_message) do
 #   {:ok, chat_message} = Messages.create_chat_message(@create_attrs)
 #   chat_message
 # end
#
 # setup %{conn: conn} do
 #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
 # end
#
 # describe "senario test" do
 #   test "life cycle chat room", %{conn: conn} do
 #     conn = get conn, chat_message_path(conn, :index)
 #     result = json_response(conn, 200)
 #     assert length(result) >= 1
#
 #     conn = post conn, chat_message_path(conn, :create),  @create_attrs
 #     assert %{"id" => id} = json_response(conn, 201)
#
 #     conn = get conn, chat_message_path(conn, :show, id)
 #     result2 =  json_response(conn, 200)
 #     assert result2 == []
#
 #     conn = put conn, chat_message_path(conn, :update, chat_message), @update_attrs
 #     assert %{"id" => ^id} = json_response(conn, 200)
#
 #     conn = get conn, chat_message_path(conn, :show, id)
 #     result2 =  json_response(conn, 200)
 #     assert result2 == []
#
 #     conn = delete conn, chat_message_path(conn, :delete, chat_message)
 #     assert response(conn, 204)
 #     assert_error_sent 404, fn ->
 #       get conn, chat_message_path(conn, :show, chat_message)
 #     end
#
 #   end
 # end
#
 # defp create_chat_message(_) do
 #   chat_message = fixture(:chat_message)
 #   {:ok, chat_message: chat_message}
 # end
end
