# Materia Chat

[![hex.pm](https://img.shields.io/hexpm/l/plug.svg)](https://github.com/karabiner-inc/materia_chat/blob/master/LICENSE)
[![Coverage Status](https://coveralls.io/repos/github/karabiner-inc/materia_chat/badge.svg?branch=master)](https://coveralls.io/github/karabiner-inc/materia_chat?branch=master)
[![Build Status](https://travis-ci.org/karabiner-inc/materia_chat.svg?branch=master)](https://travis-ci.org/karabiner-inc/materia_chat)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


## Installation

add deps

mix.exs

```
 defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:mariaex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:materia_chat, git: "git@github.com:karabiner-inc/materia_chat.git"}, #<- add here
    ]
  end
```

## Configure

 this repository based on materia(https://github.com/karabiner-inc/materia)
 you need configure materia before setting materia_chat configure.


 #### generate migration files

  create migration files.

  ```
  mix materia_chat.gen.migration
  mix ecto.migration
  ```
#### configure for MateriaChat

modify lib/your_app_web/endpoint.ex file socket definition. 

```
defmodule YourAppWeb.Endpoint do

  use Phoenix.Endpoint, otp_app: :your_app

  #socket "/socket", YourAppWeb.UserSocket # <- remove here
  socket "/your-socket-path", MateriaChatWeb.UserSocket # <- add here

```

add routing MateriaChat endpoint on lib/your_app_web/endpoint.ex file if you need.

```
scope "/api", MateriaChatWeb do
    pipe_through [:api, :user_auth]

    get "/my-chat-rooms", ChatRoomController, :list_my_chat_rooms
    post "/create-my-chat-room", ChatRoomController, :create_my_chat_room
    post "/add-my-chat-room-members", ChatRoomController, :add_my_chat_room_members
    post "/remove-my-chat-room-members", ChatRoomController, :remove_my_chat_room_members
    post "list-my-chat-message-recent", ChatMessageController, :list_my_chat_messages_recent

  end

```

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix