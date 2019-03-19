defmodule MateriaChat.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false

  alias MateriaChat.Messages.ChatMessage
  alias MateriaChat.Rooms

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of chat_messages.

  ## Examples

      iex> list_chat_messages()
      [%ChatMessage{}, ...]

  """
  def list_chat_messages do
    @repo.all(ChatMessage)
  end

  @doc """
  Gets a single chat_message.

  Raises `Ecto.NoResultsError` if the Chat message does not exist.

  ## Examples

      iex> get_chat_message!(123)
      %ChatMessage{}

      iex> get_chat_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_message!(id), do: @repo.get!(ChatMessage, id)

  @doc """
  Creates a chat_message.

  ## Examples

      iex> create_chat_message(%{field: value})
      {:ok, %ChatUnread{}}

      iex> create_chat_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_message(attrs \\ %{}) do
    %ChatMessage{}
    |> ChatMessage.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a chat_message.

  ## Examples

      iex> update_chat_message(chat_message, %{field: new_value})
      {:ok, %ChatMessage{}}

      iex> update_chat_message(chat_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_message(%ChatMessage{} = chat_message, attrs) do
    chat_message
    |> ChatMessage.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ChatMessage.

  ## Examples

      iex> delete_chat_message(chat_message)
      {:ok, %ChatMessage{}}

      iex> delete_chat_message(chat_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_message(%ChatMessage{} = chat_message) do
    @repo.delete(chat_message)
  end

  alias MateriaChat.Messages.ChatUnread

  @doc """
  Returns the list of chat_unreads.

  ## Examples

      iex> list_chat_unreads()
      [%ChatUnread{}, ...]

  """
  def list_chat_unreads do
    @repo.all(ChatUnread)
  end

  @doc """
  Gets a single chat_unread.

  Raises `Ecto.NoResultsError` if the Chat unread does not exist.

  ## Examples

      iex> get_chat_unread!(123)
      %ChatUnread{}

      iex> get_chat_unread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_unread!(id), do: @repo.get!(ChatUnread, id)

  @doc """
  Creates a chat_unread.

  ## Examples

      iex> create_chat_unread(%{field: value})
      {:ok, %ChatUnread{}}

      iex> create_chat_unread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_unread(attrs \\ %{}) do
    %ChatUnread{}
    |> ChatUnread.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a chat_unread.

  ## Examples

      iex> update_chat_unread(chat_unread, %{field: new_value})
      {:ok, %ChatUnread{}}

      iex> update_chat_unread(chat_unread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_unread(%ChatUnread{} = chat_unread, attrs) do
    chat_unread
    |> ChatUnread.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ChatUnread.

  ## Examples

      iex> delete_chat_unread(chat_unread)
      {:ok, %ChatUnread{}}

      iex> delete_chat_unread(chat_unread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_unread(%ChatUnread{} = chat_unread) do
    @repo.delete(chat_unread)
  end

  @doc """
  iex> MateriaChat.Messages.list_my_chat_messages_recent(1, 1, 2, 100)
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
    @repo.all(query)

  end


end
