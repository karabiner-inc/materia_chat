defmodule MateriaChat.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false

  alias MateriaChat.Messages.ChatMessage
  alias MateriaChat.Rooms

  alias MateriaUtils.Ecto.EctoUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of chat_messages.

  ## Examples

  iex(1)> message = MateriaChat.Messages.list_chat_messages() |> List.first()
  iex(2)> message.body
  "hello! everyone."

  """
  def list_chat_messages do
    @repo.all(ChatMessage)
  end

  @doc """
  Gets a single chat_message.

  Raises `Ecto.NoResultsError` if the Chat message does not exist.

  ## Examples

  iex(1)> message = MateriaChat.Messages.get_chat_message!(1)
  iex(2)> message.body
  "hello! everyone."

  """
  def get_chat_message!(id), do: @repo.get!(ChatMessage, id)

  @doc """
  Creates a chat_message.

  ## Examples

  iex(1)> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test_create_chat_message_001"})
  iex(2)> message.body
  "test_create_chat_message_001"
  iex(3)> message.status
  1

  """
  def create_chat_message(attrs \\ %{}) do
    %ChatMessage{}
    |> ChatMessage.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a chat_message.

  ## Examples

  iex(1)> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test_update_chat_message_001"})
  iex(2)> {:ok, updated_message} = MateriaChat.Messages.update_chat_message(message, %{status: 9, lock_version: message.lock_version})
  iex(3)> updated_message.status
  9

  """
  def update_chat_message(%ChatMessage{} = chat_message, attrs) do
    chat_message
    |> ChatMessage.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ChatMessage.

  ## Examples

  iex(1)> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test_delete_chat_message_001"})
  iex(2)> {:ok, message} = MateriaChat.Messages.delete_chat_message(message)
  iex(3)> MateriaChat.Messages.list_chat_messages() |> Enum.find(fn(msg)-> msg.id == message.id end)
  nil

  """
  def delete_chat_message(%ChatMessage{} = chat_message) do
    @repo.delete(chat_message)
  end

  alias MateriaChat.Messages.ChatUnread

  @doc """
  Returns the list of chat_unreads.

  ## Examples

    iex(1)> unread = MateriaChat.Messages.list_chat_unreads() |> List.first()
    iex(2)> unread.user_id
    1

  """
  def list_chat_unreads do
    @repo.all(ChatUnread)
  end

  @doc """
  Gets a single chat_unread.

  Raises `Ecto.NoResultsError` if the Chat unread does not exist.

  ## Examples

    iex(1)> unread = MateriaChat.Messages.get_chat_unread!(1)
    iex(2)> unread.user_id
    1

  """
  def get_chat_unread!(id), do: @repo.get!(ChatUnread, id)

  @doc """
  Creates a chat_unread.

  ## Examples

    iex> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test create_chat_unread 001"})
    iex> {:ok, unread} = MateriaChat.Messages.create_chat_unread(%{chat_message_id: message.id, user_id: 1})
    iex> unread.is_unread
    1

  """
  def create_chat_unread(attrs \\ %{}) do
    %ChatUnread{}
    |> ChatUnread.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a chat_unread.

  ## Examples

    iex> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test update_chat_unread 001"})
    iex> {:ok, unread} = MateriaChat.Messages.create_chat_unread(%{chat_message_id: message.id, user_id: 1})
    iex> {:ok, undated_unread} = MateriaChat.Messages.update_chat_unread(unread, %{is_unread: 0})
    iex> undated_unread.is_unread
    0

  """
  def update_chat_unread(%ChatUnread{} = chat_unread, attrs) do
    chat_unread
    |> ChatUnread.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ChatUnread.

  ## Examples

    iex> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test delete_chat_unread 001"})
    iex> {:ok, unread} = MateriaChat.Messages.create_chat_unread(%{chat_message_id: message.id, user_id: 2})
    iex> {:ok, deleted_unread} = MateriaChat.Messages.delete_chat_unread(unread)
    iex> MateriaChat.Messages.list_chat_unreads() |> Enum.find(fn(ur)-> ur.id == unread.id end)
    nil



  """
  def delete_chat_unread(%ChatUnread{} = chat_unread) do
    @repo.delete(chat_unread)
  end

  @doc """
  iex(1)> MateriaChat.Messages.list_my_chat_messages_recent(1, 1, 0)
  []
  iex(2)> [message] = MateriaChat.Messages.list_my_chat_messages_recent(1, 1, 1, 2)
  iex(3)> message.body
  "hello! everyone."
  iex(4)> length(message.chat_unreads) >= 2
  true

  """
  def list_my_chat_messages_recent(chat_room_id, user_id, limit_count, first_message_id \\ nil) do

    Rooms.check_and_get_chat_room_member!(chat_room_id, user_id)

    active_status = ChatMessage.status.active
    query = from m in ChatMessage,
       where: m.chat_room_id == ^chat_room_id and m.status == ^active_status,
       order_by: [desc: m.id],
       limit: ^limit_count,
       select: m
    query =
    if first_message_id != nil do
      where(query, [m], m.id < ^first_message_id)
    else
      query
    end

    # get unreads and merge
    messages = query
    |> @repo.all()
    message_id_list = messages
    |> Enum.map(fn(message) -> message.id end)

    unreads = message_id_list
    |> list_chat_unreads_by_chat_message_id()

    associate_key_list = [id: :chat_message_id]

    EctoUtil.dynamic_preload(:has_many, associate_key_list, messages, unreads, :chat_unreads)


  end

  @doc """

    iex(1)> MateriaChat.Messages.list_chat_unreads_by_chat_message_id([]) |> length()
    0
    iex(2)> MateriaChat.Messages.list_chat_unreads_by_chat_message_id([1,2]) |> length() >= 2
    true

  """
  def list_chat_unreads_by_chat_message_id(chat_message_id_list) when is_list(chat_message_id_list) do

    unreads = ChatUnread
    |> where([c], c.chat_message_id in ^chat_message_id_list)
    |> @repo.all()

  end


  @doc """

    iex(1)> {:ok, message} = MateriaChat.Messages.create_chat_message(%{chat_room_id: 1, from_user_id: 1, body: "test_create_chat_unreads_001"})
    iex(2)> {:ok, unreads} = MateriaChat.Messages.create_chat_unreads(1, message.id)
    iex(3)> length(unreads)
    2

  """
  def create_chat_unreads(chat_room_id, chat_message_id) do

    members = Rooms.list_chat_room_members_by_params(%{"and" => [%{"chat_room_id" => chat_room_id}]})

    unreads = members
    |> Enum.map(fn(member) ->
      {:ok, chat_unread} = create_chat_unread(
        %{
          chat_message_id: chat_message_id,
          user_id: member.user_id
        }
      )
      chat_unread
    end)

  {:ok, unreads}
  end

  @doc """

    iex(1)> messages = MateriaChat.Messages.list_my_unread_messages(1)
    iex(2)> messages |> Enum.map(fn(message)-> message.user_id end) |> Enum.uniq()
    [1]
    iex(3)> MateriaChat.Messages.list_my_unread_messages(0)
    []

  """
  def list_my_unread_messages(user_id) do

    ChatUnread
    |> where(user_id: ^user_id)
    |> where(is_unread: ^ChatUnread.is_unread.unread)
    |> order_by([desc: :updated_at])
    |> @repo.all()
    |> @repo.preload([:user, :chat_message])

  end

  @doc """

  """
  def update_chat_unreads_status(status) do

  end

end
