defmodule MateriaChat.Rooms.ChatRoomMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_room_members" do
    # field :chat_room_id, :integer
    field(:is_admin, :integer, default: 0)
    field(:lock_version, :integer, default: 0)
    field(:status, :integer, default: 1)

    belongs_to(:chat_room, MateriaChat.Rooms.ChatRoom)

    belongs_to(:user, Materia.Accounts.User)

    timestamps()
  end

  @doc false
  def create_changeset(chat_room_member, attrs) do
    chat_room_member
    |> cast(attrs, [:chat_room_id, :user_id, :is_admin, :status, :lock_version])
    |> validate_required([:chat_room_id, :user_id])
  end

  @doc false
  def update_changeset(chat_room_member, attrs) do
    chat_room_member
    |> cast(attrs, [:chat_room_id, :user_id, :is_admin, :status, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end

  def is_admin() do
    %{
      not_admin: 0,
      admin: 1
    }
  end

  def status() do
    %{
      active: 1,
      deleted: 9
    }
  end
end
