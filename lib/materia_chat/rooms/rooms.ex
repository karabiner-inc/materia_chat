defmodule MateriaChat.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false

  alias MateriaChat.Rooms.ChatRoom
  alias MateriaChat.Rooms.ChatRoomMember
  alias Materia.Accounts
  alias Materia.Accounts.User

  alias MateriaUtils.Ecto.EctoUtil

  alias Materia.Errors.BusinessError

  require Logger

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of chat_rooms.

  ## Examples

  iex> rooms = MateriaChat.Rooms.list_chat_rooms()
  iex> length(rooms)
  2


  """
  def list_chat_rooms do
    @repo.all(ChatRoom)
  end

  @doc """

  iex> rooms = MateriaChat.Rooms.list_chat_rooms_by_params(%{"and" => [%{"title" => "test chat room 001"}]})
  iex> rooms |> Enum.at(0) |> Map.get(:title)
  "test chat room 001"

  """
  def list_chat_rooms_by_params(params) do

    @repo
    |> EctoUtil.select_by_param(ChatRoom, params)
    |> @repo.preload([members: :user])
  end

  @doc """
  Gets a single chat_room.

  Raises `Ecto.NoResultsError` if the Chat room does not exist.

  ## Examples

  iex(20)> room = MateriaChat.Rooms.get_chat_room!(1)
  iex(25)> room.title
  "test chat room 001"

  """
  def get_chat_room!(id) do
    ChatRoom
    |> @repo.get!(id)
    |> @repo.preload([members: :user])

  end

  @doc """
  Creates a chat_room.

  ## Examples

  iex> params = %{ title: "test_create_chat_room_001", access_poricy: "public", }
  iex> {:ok, room} = MateriaChat.Rooms.create_chat_room(params)
  iex(8)> room.title
  "test_create_chat_room_001"
  iex(9)> room.access_poricy
  "public"
  iex(10)> room.status
  1

  """
  def create_chat_room(attrs \\ %{}) do
    %ChatRoom{}
    |> ChatRoom.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a chat_room.

  ## Examples

      iex> update_chat_room(chat_room, %{field: new_value})
      {:ok, %ChatRoom{}}

      iex> update_chat_room(chat_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_room(%ChatRoom{} = chat_room, attrs) do
    chat_room
    |> ChatRoom.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ChatRoom.

  ## Examples

      iex> delete_chat_room(chat_room)
      {:ok, %ChatRoom{}}

      iex> delete_chat_room(chat_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_room(%ChatRoom{} = chat_room) do
    @repo.delete(chat_room)
  end

  @doc """
  Returns the list of chat_room_members.

  ## Examples

      iex> list_chat_room_members()
      [%ChatRoomMember{}, ...]

  """
  def list_chat_room_members do
    @repo.all(ChatRoomMember)
  end

  @doc """

  """
  def list_chat_room_members_by_params(params) do
    @repo
    |> EctoUtil.select_by_param(ChatRoomMember, params)
    |> @repo.preload(:user)
  end

  @doc """
  Gets a single chat_room_member.

  Raises `Ecto.NoResultsError` if the Chat room member does not exist.

  ## Examples

      iex> get_chat_room_member!(123)
      %ChatRoomMember{}

      iex> get_chat_room_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_room_member!(id), do: @repo.get!(ChatRoomMember, id)

  @doc """
  Creates a chat_room_member.

  ## Examples

      iex> create_chat_room_member(%{field: value})
      {:ok, %ChatRoomMember{}}

      iex> create_chat_room_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_room_member(attrs \\ %{}) do
    %ChatRoomMember{}
    |> ChatRoomMember.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a chat_room_member.

  ## Examples

      iex> update_chat_room_member(chat_room_member, %{field: new_value})
      {:ok, %ChatRoomMember{}}

      iex> update_chat_room_member(chat_room_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_room_member(%ChatRoomMember{} = chat_room_member, attrs) do
    chat_room_member
    |> ChatRoomMember.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ChatRoomMember.

  ## Examples

      iex> delete_chat_room_member(chat_room_member)
      {:ok, %ChatRoomMember{}}

      iex> delete_chat_room_member(chat_room_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_room_member(%ChatRoomMember{} = chat_room_member) do
    @repo.delete(chat_room_member)
  end

  @doc """
  iex> rooms = MateriaChat.Rooms.list_my_chat_rooms(1)
  iex> length(rooms)
  1
  """
  def list_my_chat_rooms(user_id) do

    active_status = ChatRoomMember.status.active
    query = from m in ChatRoomMember,
      where: m.user_id == ^user_id and m.status == ^active_status,
      join: r in ChatRoom,
      on: m.chat_room_id == r.id,
      select: r

    query
    |> @repo.all()
    |> @repo.preload([members: :user])

  end

  @doc """

  iex> params = %{ "title" => "test_create_my_chat_room_001", "access_poricy" => "private", "members" => [%{"user_id" => 2, "is_admin" => 2}]}
  iex> {:ok, room} = MateriaChat.Rooms.create_my_chat_room(%{}, 1, params)
  iex> room.title
  "test_create_my_chat_room_001"
  iex> length(room.members)
  2

  """
  def create_my_chat_room(_result, user_id, params) do

    title = params["title"]
    access_poricy = params["access_poricy"]
    members = params["members"]

    {:ok, room} = create_chat_room(%{"title" => title, "access_poricy" => access_poricy})
    {:ok, _room_member} = create_chat_room_member(%{chat_room_id: room.id, user_id: user_id, is_admin: 1})

    if members != nil do
      members
      |> Enum.reject(fn(member) -> member["user_id"] == user_id end)
      |> Enum.map(fn(member) ->
        {:ok, _room_member} = create_chat_room_member(%{chat_room_id: room.id, user_id: member["user_id"], is_admin: member["is_admin"]})
      end)
    end

    replaced_room = room
    |> @repo.preload([members: :user])
    {:ok, replaced_room}

  end

#  @doc """
#
#  iex> members = MateriaChat.Rooms.list_chat_room_members_by_chat_room_id(1)
#
#  """
#  def list_chat_room_members_by_chat_room_id(chat_room_id) do
#
#    #query = from c in ChatRoomMember
#    #  where: c.chat_room_id == ^chat_room_id
#    #  join: u in User on: u.id = c.user_id
#
#
#    query = from(c in ChatRoomMember)
#    |> where([c], c.chat_room_id == ^chat_room_id)
#    |> join(:inner, [c], u in User, c.user_id == u.id)
#    |> select([c, u], {u, c.is_admin})
#    |> order_by([c], :user_id)
#
#    @repo.all(query)
#
#  end

  @doc """

  add chat room members.

  iex> params = %{ "title" => "test add_my_chat_room_members_001", "access_poricy" => "private", "members" => [%{"user_id" => 2, "is_admin" => 2}]}
  iex> {:ok, room} = MateriaChat.Rooms.create_my_chat_room(%{}, 1, params)
  iex> length(room.members)
  2
  iex> params = [%{"user_id" => 2,}]
  iex> {:ok, room} = MateriaChat.Rooms.remove_my_chat_room_members(%{}, 1, room.id, params)
  iex> Enum.filter(room.members, fn(member) -> member.status == 1 end) |> length()
  1
  iex> params = [%{"user_id" => 2, "is_admin" => 2}, %{"user_id" => 3, "is_admin" => 2}]
  iex> {:ok, room} = MateriaChat.Rooms.add_my_chat_room_members(%{}, 1, room.id, params)
  iex> Enum.filter(room.members, fn(member) -> member.status == 1 end) |> length()
  3

  """
  def add_my_chat_room_members(_result, user_id, chat_room_id, params_list) do

    chat_room = check_and_get_chat_room!(user_id, chat_room_id)

    params_list
    |> Enum.map(fn(params) ->
      target_user_id = params["user_id"]
      if target_user_id == nil do
        raise BusinessError, message: "user_id is required"
      end

      target_users = Accounts.list_users_by_params(%{"and" => [%{"id" => target_user_id}, %{"status" => User.status.activated}]})

      if length(target_users) != 1 do
        raise BusinessError, message: "user_id:#{target_user_id} is not activated."
      end

      chat_room_members = list_chat_room_members_by_params(%{"and" => [%{"chat_room_id" => chat_room_id}, %{"user_id" => target_user_id}]})

      if length(chat_room_members) == 0 do
        puted_params = params
        |> Map.put("chat_room_id", chat_room_id)
        {:ok, _chat_room_member} = create_chat_room_member(puted_params)
      else
        [chat_room_member] = chat_room_members
        if chat_room_member.status == ChatRoomMember.status.active do
          Logger.debug("#{__MODULE__} add_my_chat_room_members. target_user_id:#{target_user_id} chat_room_id:#{chat_room_id} chat_room_member.status: #{chat_room_member.status} == #{ChatRoomMember.status.active}")
          raise BusinessError, message: "user_id:#{target_user_id} was member at chat_room_id:#{chat_room_id}."
        else
          puted_params = params
          |> Map.put("status", ChatRoomMember.status.active)
          {:ok, _chat_room_member} = update_chat_room_member(chat_room_member, puted_params)
        end
      end
    end)

    chat_room = get_chat_room!(chat_room.id)

    {:ok, chat_room}

  end

  @doc """

  delete chat room members.

  see add_my_chat_room_members examples.

  """

  def remove_my_chat_room_members(_result, user_id, chat_room_id, params_list) do

    _chat_room = check_and_get_chat_room!(user_id, chat_room_id)
    params_list
    |> Enum.map(fn(params) ->
      user_id = params["user_id"]
      if user_id == nil do
        raise BusinessError, message: "user_id is required"
      end
      chat_room_member = check_and_get_chat_room_member!(chat_room_id, user_id)
      {:ok, _chat_room_member} = update_chat_room_member(chat_room_member, %{status: ChatRoomMember.status.deleted})
    end)

    chat_room = get_chat_room!(chat_room_id)

    {:ok, chat_room}

  end

  @doc """

  check and get chat room.

  if user_id was not administrator in that chat room.
  raise error.

  iex> MateriaChat.Rooms.check_and_get_chat_room!(2, 1)
  * (Materia.Errors.BusinessError) user_id: 2 is not admin member

  """
  def check_and_get_chat_room!(user_id, chat_room_id) do

    #chat_room_id = params["chat_room_id"]
#
    #if chat_room_id == nil do
    #  raise BusinessError, message: "chat_room_id is required"
    #end

    chat_room = get_chat_room!(chat_room_id)

    admin_member =  list_chat_room_members_by_params(%{"and" => [%{"chat_room_id" => chat_room_id}, %{"user_id" => user_id}, %{"is_admin" => ChatRoomMember.is_admin.admin}, %{"status" => ChatRoomMember.status.active}]})

    if chat_room.access_poricy == ChatRoom.access_poricy.private and admin_member == [] do
      raise BusinessError, message: "user_id: #{user_id} is not admin member."
    end

    chat_room

  end

  @doc """

  check and get chat room members.

  if user_id was not member of that chat room.
  raise error

  iex> MateriaChat.Rooms.check_and_get_chat_room_member!(1, 9999)
  ** (Materia.Errors.BusinessError) user_id: 9999 is not member in chat_room_id: 1

  """
  def check_and_get_chat_room_member!(chat_room_id, user_id) do

    chat_room_members = list_chat_room_members_by_params(%{"and" => [%{"chat_room_id" => chat_room_id}, %{"user_id" => user_id}, %{"status" => ChatRoomMember.status.active}]})
    if length(chat_room_members) != 1 do
      raise BusinessError, message: "user_id: #{user_id} is not member in chat_room_id: #{chat_room_id}"
    end
    [chat_room_member] = chat_room_members
    chat_room_member

  end


end
