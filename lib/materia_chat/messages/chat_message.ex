defmodule MateriaChat.Messages.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_messages" do
    field(:body, :string)
    field(:chat_room_id, :integer)
    # field :from_user_id, :integer
    field(:lock_version, :integer, default: 0)
    field(:status, :integer, default: 1)
    field(:send_datetime, :utc_datetime)

    belongs_to(:from_user, Materia.Accounts.User, foreign_key: :from_user_id)

    timestamps()
  end

  @doc false
  def create_changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:chat_room_id, :from_user_id, :status, :body, :send_datetime, :lock_version])
    |> validate_required([:chat_room_id, :from_user_id, :body])
  end

  @doc false
  def update_changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:chat_room_id, :from_user_id, :status, :body, :send_datetime, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      active: 1,
      deleted: 9
    }
  end
end
