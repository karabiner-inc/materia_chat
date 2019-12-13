defmodule MateriaChatWeb.Router do
  use MateriaChatWeb, :router

  require Logger

  # pipeline :browser do
  #  plug :accepts, ["html"]
  #  plug :fetch_session
  #  plug :fetch_flash
  #  plug :protect_from_forgery
  #  plug :put_secure_browser_headers
  # end

  pipeline :browser do
    plug(:put_user_token)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :guardian_auth_user do
    plug(Materia.UserAuthPipeline)
  end

  pipeline :guardian_auth_account do
    plug(Materia.AccountAuthPipeline)
  end

  pipeline :grant_check do
    repo = Application.get_env(:materia, :repo)
    plug(Materia.Plug.GrantChecker, repo: repo)
  end

  scope "/api", MateriaWeb do
    pipe_through(:api)

    post("sign-in", AuthenticatorController, :sign_in)
  end

  scope "/api", MateriaChatWeb do
    pipe_through(:api)

    resources("/chat_rooms", ChatRoomController, except: [:new, :edit])
    resources("/chat_room_members", ChatRoomMemberController, except: [:new, :edit])
    resources("/chat_messages", ChatMessageController, except: [:new, :edit])
    resources("/chat_unreads", ChatUnreadController, except: [:new, :edit])
  end

  scope "/api", MateriaChatWeb do
    pipe_through([:api, :guardian_auth_user])

    get("/my-chat-rooms", ChatRoomController, :list_my_chat_rooms)
    post("/create-my-chat-room", ChatRoomController, :create_my_chat_room)
    post("/add-my-chat-room-members", ChatRoomController, :add_my_chat_room_members)
    post("/remove-my-chat-room-members", ChatRoomController, :remove_my_chat_room_members)
    post("list-my-chat-message-recent", ChatMessageController, :list_my_chat_messages_recent)
  end

  def put_user_token(conn, _) do
    Logger.debug("#{__MODULE__} put_user_token. conn: #{inspect(conn)}")
    conn
  end
end
