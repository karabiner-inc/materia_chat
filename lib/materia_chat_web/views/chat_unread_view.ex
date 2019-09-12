defmodule MateriaChatWeb.ChatUnreadView do
  use MateriaChatWeb, :view
  alias MateriaChatWeb.ChatUnreadView

  alias MateriaChatWeb.ChatMessageView
  alias MateriaWeb.UserView

  def render("index.json", %{chat_unreads: chat_unreads}) do
    num_of_unreads = chat_unreads
    |> Enum.count()
    %{
      num_of_chat_unreads: num_of_unreads,
      chat_unreads: render_many(chat_unreads, ChatUnreadView, "chat_unread.json")
    }
  end

  def render("show.json", %{chat_unread: chat_unread}) do
    render_one(chat_unread, ChatUnreadView, "chat_unread.json")
  end

  def render("chat_unread.json", %{chat_unread: chat_unread}) do
    result_map =
    %{
      id: chat_unread.id,
      chat_message_id: chat_unread.chat_message_id,
      user_id: chat_unread.user_id,
      is_unread: chat_unread.is_unread,
      lock_version: chat_unread.lock_version
    }
    result_map =
    if Ecto.assoc_loaded?(chat_unread.user) do
      Map.put(result_map, :user, UserView.render("show.json", %{user: chat_unread.user}))
    else
      Map.put(result_map, :user, nil)
    end
    result_map =
    if Ecto.assoc_loaded?(chat_unread.chat_message) do
      Map.put(result_map, :chat_message, ChatMessageView.render("show.json", %{chat_message: chat_unread.chat_message}))
    else
      Map.put(result_map, :chat_message, nil)
    end
  end
end
