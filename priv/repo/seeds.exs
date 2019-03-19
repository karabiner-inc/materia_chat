# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Materia.Repo.insert!(%Materia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MateriaUtils.Test.TsvParser

alias Materia.Accounts
alias Materia.Locations

Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/users" })
Accounts.create_grant(%{ role: "admin", method: "ANY", request_path: "/api/ops/grants" })
Accounts.create_grant(%{ role: "operator", method: "GET", request_path: "/api/ops/grants" })
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/organizations" })
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/mail-templates" })

{:ok, user_hogehoge} = Accounts.create_user(%{ name: "hogehoge", email: "hogehoge@example.com", password: "hogehoge", role: "admin"})
Accounts.create_user(%{ name: "fugafuga", email: "fugafuga@example.com", password: "fugafuga", role: "operator"})
Accounts.create_user(%{ name: "higehige", email: "higehige@example.com", password: "higehige", role: "operator"})

Locations.create_address(%{user_id: user_hogehoge.id, subject: "living", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "港 x-x-xx"})
Locations.create_address(%{user_id: user_hogehoge.id, subject: "billing", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "大名 x-x-xx"})

alias Materia.Organizations

{:ok, organization_hogehoge} = Organizations.create_organization( %{name: "hogehoge.inc", one_line_message: "let's do this.", back_ground_img_url: "https://hogehoge.com/ib_img.jpg", profile_img_url: "https://hogehoge.com/prof_img.jpg", hp_url: "https://hogehoge.inc"})
Accounts.update_user(user_hogehoge, %{organization_id: organization_hogehoge.id})
Locations.create_address(%{organization_id: organization_hogehoge.id, subject: "registry", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "天神 x-x-xx"})
Locations.create_address(%{organization_id: organization_hogehoge.id, subject: "branch", location: "福岡県", zip_code: "812-ZZZZ", address1: "北九州市小倉北区", address2: "浅野 x-x-xx"})

{:ok, account} = Accounts.create_account(%{"external_code" => "hogehoge_code", "name" => "hogehoge account", "start_datetime" => "2019-01-10T10:03:50.293740Z", "main_user_id" => user_hogehoge.id, "organization_id" => organization_hogehoge.id})

alias MateriaChat.Rooms

rooms = "
id	title	access_poricy	status
1	test chat room 001	private	1
2	test public chat room 001	public	1
"

jsons = TsvParser.parse_tsv_to_json(rooms, "title")

    results = jsons
    |> Enum.map(fn(json) ->
      {:ok, result} = json
      |> Rooms.create_chat_room()
    end)

members = "
id	chat_room_id	user_id	is_admin
1	1	1	1
2	1	2	2
"

jsons = TsvParser.parse_tsv_to_json(members, "id")

    results = jsons
    |> Enum.map(fn(json) ->
      {:ok, result} = json
      |> Rooms.create_chat_room_member()
    end)








