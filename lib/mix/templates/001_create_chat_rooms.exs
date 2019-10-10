defmodule MateriaChat.Repo.Migrations.CreateChatRooms do
  use Ecto.Migration

  def change do
    create table(:chat_rooms) do
      add :title, :string
      add :access_poricy, :string
      add :status, :integer
      add :lock_version, :bigint

      timestamps()
    end

    create index(:chat_rooms, [:status])

  end
end
