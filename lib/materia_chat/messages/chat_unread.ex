defmodule MateriaChat.Messages.ChatUnread do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chat_unreads" do
    field :chat_message_id, :integer
    field :is_unread, :integer, default: 1
    field :lock_version, :integer, default: 0
    #field :user_id, :integer

    belongs_to :user ,Materia.Accounts.User

    timestamps()
  end

  @doc false
  def create_changeset(chat_unread, attrs) do
    chat_unread
    |> cast(attrs, [:chat_message_id, :user_id, :is_unread, :lock_version])
    |> validate_required([:chat_message_id, :user_id])
    |> unique_constraint([:chat_message_id, :user_id])
  end

  @doc false
  def update_changeset(chat_unread, attrs) do
    chat_unread
    |> cast(attrs, [:chat_message_id, :user_id, :is_unread, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
    |> unique_constraint([:chat_message_id, :user_id])
  end

  def is_unread() do
    %{
      unread: 1,
      readed: 0,
    }
  end
end
