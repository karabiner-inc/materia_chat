defmodule MateriaChatWeb.ChatControllerScenarioTest do
  use MateriaChatWeb.ConnCase

  alias MateriaChat.Rooms
  alias MateriaChat.Rooms.ChatRoom
  alias MateriaChat.Rooms.ChatRoomMember
  alias MateriaChat.Messages
  alias MateriaChat.Messages.ChatMessage
  alias MateriaChat.Messages.ChatUnreads

  alias MateriaUtils.Calendar.CalendarUtil
  alias MateriaChat.Messages.ChatMessage

  import MateriaTest.Test.ControllerTest

  @url "http://127.0.0.1"
  @port "4000"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "senario test" do
    test "life cycle public chat room", %{conn: conn} do

      # sign-in user2 owner
      {status_code, auth} = sign_in("http://127.0.0.1:4000/api/sign-in", "fugafuga@example.com", "fugafuga")
      {status_code, auth_1} = sign_in("http://127.0.0.1:4000/api/sign-in", "hogehoge@example.com", "hogehoge")
      {status_code, auth_3} = sign_in("http://127.0.0.1:4000/api/sign-in", "higehige@example.com", "higehige")

      # get my chat rooms
      {status_code, rooms} = get!("http://127.0.0.1:4000/api/my-chat-rooms", auth["access_token"])
      assert status_code == 200

      assert List.first(rooms) |> Map.get("title") == "test chat room 001"


      # create new chat room with default user.
      params =
        %{
          title: "cycle test create chat room 001",
          access_poricy: "public"
        }

      {status_code, room} = post!("http://127.0.0.1:4000/api/create-my-chat-room", params, auth["access_token"])
      assert status_code == 201
      assert length(room["members"]) == 1
      assert List.first(room["members"])["user_id"] == auth["id"]
      assert List.first(room["members"])["is_admin"] == 1
      assert room["status"] == 1

      params = %{
        chat_room_id: room["id"],
        members: [
            %{ user_id: 1, is_admin: 1},
            %{ user_id: 3, is_admin: 0}
        ]
      }

      # add room member
      ### can add non member user
      {status_code, added_room} = post!("http://127.0.0.1:4000/api/add-my-chat-room-members", params, auth_3["access_token"])
      assert status_code == 201
      assert length(added_room["members"]) == 3


      # remove room member
      ### can remove non admin user
      params = %{
        chat_room_id: room["id"],
        members: [
            %{ user_id: 1},
            %{ user_id: 3}
        ]
      }

      {status_code, removed_room} = post!("http://127.0.0.1:4000/api/remove-my-chat-room-members", params, auth_1["access_token"])
      assert status_code == 201
      assert length(removed_room["members"]) == 1

      ### can add non admin user

      {status_code, added_rooms} = post!("http://127.0.0.1:4000/api/add-my-chat-room-members", params, auth_3["access_token"])
      assert status_code == 201
      assert length(removed_room["members"]) == 1

    end

  end

  test "life cycle private chat room", %{conn: conn} do

    # sign-in user2 owner
    {status_code, auth_2} = sign_in("http://127.0.0.1:4000/api/sign-in", "fugafuga@example.com", "fugafuga")
    {status_code, auth_1} = sign_in("http://127.0.0.1:4000/api/sign-in", "hogehoge@example.com", "hogehoge")
    {status_code, auth_3} = sign_in("http://127.0.0.1:4000/api/sign-in", "higehige@example.com", "higehige")

    # create new chat room with default user.
    params =
      %{
        title: "cycle test create chat room 002",
        access_poricy: "private"
      }

    {status_code, room} = post!("http://127.0.0.1:4000/api/create-my-chat-room", params, auth_2["access_token"])
    assert status_code == 201
    assert length(room["members"]) == 1
    assert List.first(room["members"])["user_id"] == auth_2["id"]
    assert List.first(room["members"])["is_admin"] == 1
    assert room["status"] == 1

    # add member
    params = %{
      chat_room_id: room["id"],
      members: [
          %{ user_id: 1, is_admin: 0}
      ]
    }

    ### can't add non member user
    {status_code, error_msg} = post!("http://127.0.0.1:4000/api/add-my-chat-room-members", params, auth_3["access_token"])
    assert status_code == 400
    assert error_msg == "user_id: 3 is not admin member."

    # add room member
    ### can add admin user
    {status_code, added_room} = post!("http://127.0.0.1:4000/api/add-my-chat-room-members", params, auth_2["access_token"])
      assert status_code == 201
      assert length(added_room["members"]) == 2

    ### can't add admin user
    {status_code, error_msg} = post!("http://127.0.0.1:4000/api/add-my-chat-room-members", params, auth_1["access_token"])
    assert status_code == 400
    assert error_msg == "user_id: 1 is not admin member."

    # update member
    params = %{
      chat_room_id: room["id"],
      members: [
          %{ user_id: 1, is_admin: 1}
      ]
    }

    ### can't update non admin user
    {status_code, error_msg} = post!("http://127.0.0.1:4000/api/update-my-chat-room-members", params, auth_1["access_token"])
    assert status_code == 400
    assert error_msg == "user_id: 1 is not admin member."

    ### can update admin user
    {status_code, updated_room} = post!("http://127.0.0.1:4000/api/update-my-chat-room-members", params, auth_2["access_token"])
    assert status_code == 201
    member_1 = updated_room["members"] |> Enum.filter(fn(member)-> member["user_id"] == 1 end) |> List.first
    assert member_1["is_admin"] == 1

    ### can update admin user self-update
    params = %{
      chat_room_id: room["id"],
      members: [
          %{ user_id: 1, is_admin: 0}
      ]
    }
    {status_code, updated_room} = post!("http://127.0.0.1:4000/api/update-my-chat-room-members", params, auth_1["access_token"])
    assert status_code == 201
    member_1 = updated_room["members"] |> Enum.filter(fn(member)-> member["user_id"] == 1 end) |> List.first
    assert member_1["is_admin"] == 0

    # remove room member
    ### can't remove non admin user
    params = %{
      chat_room_id: room["id"],
      members: [
          %{ user_id: 1},
          %{ user_id: 3}
      ]
    }

    {status_code, error_mgs} = post!("http://127.0.0.1:4000/api/remove-my-chat-room-members", params, auth_1["access_token"])
    assert status_code == 400
    assert error_mgs == "user_id: 1 is not admin member."

    ### can't add non admin user
    {status_code, error_mgs} = post!("http://127.0.0.1:4000/api/add-my-chat-room-members", params, auth_3["access_token"])
    assert status_code == 400
    assert error_mgs ==  "user_id: 3 is not admin member."

  end

end
