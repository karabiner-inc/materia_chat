defmodule MateriaChat.Rooms.ChatRoom do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chat_rooms" do
    field :access_poricy, :string, default: "private"
    field :lock_version, :integer, default: 0
    field :status, :integer, default: 1
    field :title, :string

    has_many :members, MateriaChat.Rooms.ChatRoomMember

    timestamps()
  end

  @doc false
  def create_changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:title, :access_poricy, :status, :lock_version])
  end

  @doc false
  def update_changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:title, :access_poricy, :status, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end

  def access_poricy() do
    %{
      private: "private",
      public: "public",
    }
  end

  def status() do
    %{
      active: 1,
      deleted: 9,
    }
  end
end


