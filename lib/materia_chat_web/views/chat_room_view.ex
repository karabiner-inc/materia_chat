defmodule MateriaChatWeb.ChatRoomView do
  use MateriaChatWeb, :view
  alias MateriaChatWeb.ChatRoomView
  alias MateriaChatWeb.ChatRoomMemberView

  def render("index.json", %{chat_rooms: chat_rooms}) do
    render_many(chat_rooms, ChatRoomView, "chat_room.json")
  end

  def render("show.json", %{chat_room: chat_room}) do
    render_one(chat_room, ChatRoomView, "chat_room.json")
  end

  def render("chat_room.json", %{chat_room: chat_room}) do
    result_map = %{
      id: chat_room.id,
      title: chat_room.title,
      access_poricy: chat_room.access_poricy,
      status: chat_room.status,
      lock_version: chat_room.lock_version
    }

    result_map =
      if chat_room.members != nil and Ecto.assoc_loaded?(chat_room.members) do
        Map.put(result_map, :members, ChatRoomMemberView.render("index.json", %{chat_room_members: chat_room.members}))
      else
        Map.put(result_map, :members, [])
      end
  end
end
