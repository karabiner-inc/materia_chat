defmodule MateriaChat.MessagesTest do
  use MateriaChat.DataCase
  doctest MateriaChat.Messages

#  alias MateriaChat.Messages
#
#  describe "chat_messages" do
#    alias MateriaChat.Messages.ChatMessage
#
#    @valid_attrs %{body: "some body", chat_room_id: 42, from_user_id: 42, lock_version: 42, status: 42}
#    @update_attrs %{body: "some updated body", chat_room_id: 43, from_user_id: 43, lock_version: 43, status: 43}
#    @invalid_attrs %{body: nil, chat_room_id: nil, from_user_id: nil, lock_version: nil, status: nil}
#
#    def chat_message_fixture(attrs \\ %{}) do
#      {:ok, chat_message} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Messages.create_chat_message()
#
#      chat_message
#    end
#
#    test "list_chat_messages/0 returns all chat_messages" do
#      chat_message = chat_message_fixture()
#      assert Messages.list_chat_messages() == [chat_message]
#    end
#
#    test "get_chat_message!/1 returns the chat_message with given id" do
#      chat_message = chat_message_fixture()
#      assert Messages.get_chat_message!(chat_message.id) == chat_message
#    end
#
#    test "create_chat_message/1 with valid data creates a chat_message" do
#      assert {:ok, %ChatMessage{} = chat_message} = Messages.create_chat_message(@valid_attrs)
#      assert chat_message.body == "some body"
#      assert chat_message.chat_room_id == 42
#      assert chat_message.from_user_id == 42
#      assert chat_message.lock_version == 42
#      assert chat_message.status == 42
#    end
#
#    test "create_chat_message/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Messages.create_chat_message(@invalid_attrs)
#    end
#
#    test "update_chat_message/2 with valid data updates the chat_message" do
#      chat_message = chat_message_fixture()
#      assert {:ok, chat_message} = Messages.update_chat_message(chat_message, @update_attrs)
#      assert %ChatMessage{} = chat_message
#      assert chat_message.body == "some updated body"
#      assert chat_message.chat_room_id == 43
#      assert chat_message.from_user_id == 43
#      assert chat_message.lock_version == 43
#      assert chat_message.status == 43
#    end
#
#    test "update_chat_message/2 with invalid data returns error changeset" do
#      chat_message = chat_message_fixture()
#      assert {:error, %Ecto.Changeset{}} = Messages.update_chat_message(chat_message, @invalid_attrs)
#      assert chat_message == Messages.get_chat_message!(chat_message.id)
#    end
#
#    test "delete_chat_message/1 deletes the chat_message" do
#      chat_message = chat_message_fixture()
#      assert {:ok, %ChatMessage{}} = Messages.delete_chat_message(chat_message)
#      assert_raise Ecto.NoResultsError, fn -> Messages.get_chat_message!(chat_message.id) end
#    end
#
#    test "change_chat_message/1 returns a chat_message changeset" do
#      chat_message = chat_message_fixture()
#      assert %Ecto.Changeset{} = Messages.change_chat_message(chat_message)
#    end
#  end
#
#  describe "chat_unreads" do
#    alias MateriaChat.Messages.ChatUnread
#
#    @valid_attrs %{chat_message_id: 42, is_unread: 42, lock_version: 42, user_id: 42}
#    @update_attrs %{chat_message_id: 43, is_unread: 43, lock_version: 43, user_id: 43}
#    @invalid_attrs %{chat_message_id: nil, is_unread: nil, lock_version: nil, user_id: nil}
#
#    def chat_unread_fixture(attrs \\ %{}) do
#      {:ok, chat_unread} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Messages.create_chat_unread()
#
#      chat_unread
#    end
#
#    test "list_chat_unreads/0 returns all chat_unreads" do
#      chat_unread = chat_unread_fixture()
#      assert Messages.list_chat_unreads() == [chat_unread]
#    end
#
#    test "get_chat_unread!/1 returns the chat_unread with given id" do
#      chat_unread = chat_unread_fixture()
#      assert Messages.get_chat_unread!(chat_unread.id) == chat_unread
#    end
#
#    test "create_chat_unread/1 with valid data creates a chat_unread" do
#      assert {:ok, %ChatUnread{} = chat_unread} = Messages.create_chat_unread(@valid_attrs)
#      assert chat_unread.chat_message_id == 42
#      assert chat_unread.is_unread == 42
#      assert chat_unread.lock_version == 42
#      assert chat_unread.user_id == 42
#    end
#
#    test "create_chat_unread/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Messages.create_chat_unread(@invalid_attrs)
#    end
#
#    test "update_chat_unread/2 with valid data updates the chat_unread" do
#      chat_unread = chat_unread_fixture()
#      assert {:ok, chat_unread} = Messages.update_chat_unread(chat_unread, @update_attrs)
#      assert %ChatUnread{} = chat_unread
#      assert chat_unread.chat_message_id == 43
#      assert chat_unread.is_unread == 43
#      assert chat_unread.lock_version == 43
#      assert chat_unread.user_id == 43
#    end
#
#    test "update_chat_unread/2 with invalid data returns error changeset" do
#      chat_unread = chat_unread_fixture()
#      assert {:error, %Ecto.Changeset{}} = Messages.update_chat_unread(chat_unread, @invalid_attrs)
#      assert chat_unread == Messages.get_chat_unread!(chat_unread.id)
#    end
#
#    test "delete_chat_unread/1 deletes the chat_unread" do
#      chat_unread = chat_unread_fixture()
#      assert {:ok, %ChatUnread{}} = Messages.delete_chat_unread(chat_unread)
#      assert_raise Ecto.NoResultsError, fn -> Messages.get_chat_unread!(chat_unread.id) end
#    end
#
#    test "change_chat_unread/1 returns a chat_unread changeset" do
#      chat_unread = chat_unread_fixture()
#      assert %Ecto.Changeset{} = Messages.change_chat_unread(chat_unread)
#    end
#  end
end
