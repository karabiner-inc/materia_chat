defmodule MateriaChatWeb.ChatRoomMemberView do
  use MateriaChatWeb, :view
  alias MateriaChatWeb.ChatRoomMemberView
  alias MateriaWeb.UserView

  def render("index.json", %{chat_room_members: chat_room_members}) do
    render_many(chat_room_members, ChatRoomMemberView, "chat_room_member.json")
  end

  def render("show.json", %{chat_room_member: chat_room_member}) do
    render_one(chat_room_member, ChatRoomMemberView, "chat_room_member.json")
  end

  def render("chat_room_member.json", %{chat_room_member: chat_room_member}) do
    result_map =
    %{
      id: chat_room_member.id,
      chat_room_id: chat_room_member.chat_room_id,
      user_id: chat_room_member.user_id,
      is_admin: chat_room_member.is_admin,
      lock_version: chat_room_member.lock_version,
      status: chat_room_member.status,
    }
    result_map =
    if Ecto.assoc_loaded?(chat_room_member.user) do
      Map.put(result_map, :user, UserView.render("show.json", %{user: chat_room_member.user}))
    else
      Map.put(result_map, :user, nil)
    end
  end
end
