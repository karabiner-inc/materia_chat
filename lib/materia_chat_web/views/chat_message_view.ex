defmodule MateriaChatWeb.ChatMessageView do
  use MateriaChatWeb, :view
  alias MateriaChatWeb.ChatMessageView

  alias MateriaChatWeb.ChatUnreadView

  def render("index.json", %{chat_messages: chat_messages}) do
    render_many(chat_messages, ChatMessageView, "chat_message.json")
  end

  def render("show.json", %{chat_message: chat_message}) do
    render_one(chat_message, ChatMessageView, "chat_message.json")
  end

  def render("chat_message.json", %{chat_message: chat_message}) do
    result_map =
    %{
      id: chat_message.id,
      chat_room_id: chat_message.chat_room_id,
      from_user_id: chat_message.from_user_id,
      status: chat_message.status,
      body: chat_message.body,
      lock_version: chat_message.lock_version,
      send_datetime: chat_message.send_datetime,
    }
    result_map =
      if Map.has_key?(chat_message, :chat_unreads) == true and chat_message.chat_unreads != nil and Ecto.assoc_loaded?(chat_message.chat_unreads) do
        Map.put(result_map, :chat_unreads, ChatUnreadView.render("index.json", %{chat_unreads: chat_message.chat_unreads}))
      else
        Map.put(result_map, :chat_unreads, [])
      end
  end
end
