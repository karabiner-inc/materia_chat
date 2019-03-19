defmodule MateriaChat.Repo.Migrations.CreateChatUnreads do
  use Ecto.Migration

  def change do
    create table(:chat_unreads) do
      add :chat_message_id, :bigint
      add :user_id, :bigint
      add :is_unread, :integer
      add :lock_version, :bigint

      timestamps()
    end

    create unique_index(:chat_unreads, [:chat_message_id, :user_id])
    create index(:chat_unreads, [:user_id, :chat_message_id, :is_unread])

  end
end
