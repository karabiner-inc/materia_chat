defmodule MateriaChatWeb.ChatUnreadView do
  use MateriaChatWeb, :view
  alias MateriaChatWeb.ChatUnreadView

  def render("index.json", %{chat_unreads: chat_unreads}) do
    %{data: render_many(chat_unreads, ChatUnreadView, "chat_unread.json")}
  end

  def render("show.json", %{chat_unread: chat_unread}) do
    %{data: render_one(chat_unread, ChatUnreadView, "chat_unread.json")}
  end

  def render("chat_unread.json", %{chat_unread: chat_unread}) do
    %{
      id: chat_unread.id,
      chat_message_id: chat_unread.chat_message_id,
      user_id: chat_unread.user_id,
      is_unread: chat_unread.is_unread,
      lock_version: chat_unread.lock_version
    }
  end
end
