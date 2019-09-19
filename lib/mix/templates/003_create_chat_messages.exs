defmodule MateriaChat.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :chat_room_id, :bigint
      add :from_user_id, :bigint
      add :status, :integer
      add :body, :string, size: 1000
      add :lock_version, :bigint
      add :send_datetime, :utc_datetime

      timestamps()
    end

    create index(:chat_messages, [:chat_room_id, :status, :from_user_id])
    create index(:chat_messages, [:from_user_id, :status, :chat_room_id])

  end
end
