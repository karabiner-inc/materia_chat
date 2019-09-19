defmodule MateriaChat.Repo.Migrations.CreateChatRoomMembers do
  use Ecto.Migration

  def change do
    create table(:chat_room_members) do
      add :chat_room_id, :bigint
      add :user_id, :bigint
      add :is_admin, :integer
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

    create unique_index(:chat_room_members, [:status, :chat_room_id, :user_id, :is_admin])
    create index(:chat_room_members, [:status, :user_id, :chat_room_id, :is_admin])

  end
end
