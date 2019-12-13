defmodule MateriaChat.RoomsTest do
  use MateriaChat.DataCase

  alias MateriaChat.Rooms

  describe "chat_rooms" do
    alias MateriaChat.Rooms.ChatRoom

    @valid_attrs %{access_poricy: "some access_poricy", lock_version: 42, status: 42, title: "some title"}
    @update_attrs %{
      access_poricy: "some updated access_poricy",
      lock_version: 43,
      status: 43,
      title: "some updated title"
    }
    @invalid_attrs %{access_poricy: nil, lock_version: nil, status: nil, title: nil}

    def chat_room_fixture(attrs \\ %{}) do
      {:ok, chat_room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_chat_room()

      chat_room
    end

    test "list_chat_rooms/0 returns all chat_rooms" do
      chat_room = chat_room_fixture()
      assert Rooms.list_chat_rooms() == [chat_room]
    end

    test "get_chat_room!/1 returns the chat_room with given id" do
      chat_room = chat_room_fixture()
      assert Rooms.get_chat_room!(chat_room.id) == chat_room
    end

    test "create_chat_room/1 with valid data creates a chat_room" do
      assert {:ok, %ChatRoom{} = chat_room} = Rooms.create_chat_room(@valid_attrs)
      assert chat_room.access_poricy == "some access_poricy"
      assert chat_room.lock_version == 42
      assert chat_room.status == 42
      assert chat_room.title == "some title"
    end

    test "create_chat_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_chat_room(@invalid_attrs)
    end

    test "update_chat_room/2 with valid data updates the chat_room" do
      chat_room = chat_room_fixture()
      assert {:ok, chat_room} = Rooms.update_chat_room(chat_room, @update_attrs)
      assert %ChatRoom{} = chat_room
      assert chat_room.access_poricy == "some updated access_poricy"
      assert chat_room.lock_version == 43
      assert chat_room.status == 43
      assert chat_room.title == "some updated title"
    end

    test "update_chat_room/2 with invalid data returns error changeset" do
      chat_room = chat_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_chat_room(chat_room, @invalid_attrs)
      assert chat_room == Rooms.get_chat_room!(chat_room.id)
    end

    test "delete_chat_room/1 deletes the chat_room" do
      chat_room = chat_room_fixture()
      assert {:ok, %ChatRoom{}} = Rooms.delete_chat_room(chat_room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_chat_room!(chat_room.id) end
    end

    test "change_chat_room/1 returns a chat_room changeset" do
      chat_room = chat_room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_chat_room(chat_room)
    end
  end

  describe "chat_room_members" do
    alias MateriaChat.Rooms.ChatRoomMember

    @valid_attrs %{chat_room_id: "some chat_room_id", is_admin: 42, lock_version: 42, user_id: "some user_id"}
    @update_attrs %{
      chat_room_id: "some updated chat_room_id",
      is_admin: 43,
      lock_version: 43,
      user_id: "some updated user_id"
    }
    @invalid_attrs %{chat_room_id: nil, is_admin: nil, lock_version: nil, user_id: nil}

    def chat_room_member_fixture(attrs \\ %{}) do
      {:ok, chat_room_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_chat_room_member()

      chat_room_member
    end

    test "list_chat_room_members/0 returns all chat_room_members" do
      chat_room_member = chat_room_member_fixture()
      assert Rooms.list_chat_room_members() == [chat_room_member]
    end

    test "get_chat_room_member!/1 returns the chat_room_member with given id" do
      chat_room_member = chat_room_member_fixture()
      assert Rooms.get_chat_room_member!(chat_room_member.id) == chat_room_member
    end

    test "create_chat_room_member/1 with valid data creates a chat_room_member" do
      assert {:ok, %ChatRoomMember{} = chat_room_member} = Rooms.create_chat_room_member(@valid_attrs)
      assert chat_room_member.chat_room_id == "some chat_room_id"
      assert chat_room_member.is_admin == 42
      assert chat_room_member.lock_version == 42
      assert chat_room_member.user_id == "some user_id"
    end

    test "create_chat_room_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_chat_room_member(@invalid_attrs)
    end

    test "update_chat_room_member/2 with valid data updates the chat_room_member" do
      chat_room_member = chat_room_member_fixture()
      assert {:ok, chat_room_member} = Rooms.update_chat_room_member(chat_room_member, @update_attrs)
      assert %ChatRoomMember{} = chat_room_member
      assert chat_room_member.chat_room_id == "some updated chat_room_id"
      assert chat_room_member.is_admin == 43
      assert chat_room_member.lock_version == 43
      assert chat_room_member.user_id == "some updated user_id"
    end

    test "update_chat_room_member/2 with invalid data returns error changeset" do
      chat_room_member = chat_room_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_chat_room_member(chat_room_member, @invalid_attrs)
      assert chat_room_member == Rooms.get_chat_room_member!(chat_room_member.id)
    end

    test "delete_chat_room_member/1 deletes the chat_room_member" do
      chat_room_member = chat_room_member_fixture()
      assert {:ok, %ChatRoomMember{}} = Rooms.delete_chat_room_member(chat_room_member)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_chat_room_member!(chat_room_member.id) end
    end

    test "change_chat_room_member/1 returns a chat_room_member changeset" do
      chat_room_member = chat_room_member_fixture()
      assert %Ecto.Changeset{} = Rooms.change_chat_room_member(chat_room_member)
    end
  end
end
