defmodule MateriaChatWeb.RoomChannel do
  use Phoenix.Channel

  alias MateriaChat.Rooms
  alias MateriaChat.Rooms.ChatRoomMember
  alias MateriaChat.Messages
  alias MateriaUtils.Calendar.CalendarUtil

  require Logger
  def join("room:" <> chat_room_id, params, socket) do
    Logger.debug("#{__MODULE__} join. socket:#{inspect(socket)}")
    Logger.debug("#{__MODULE__} join. room_id:#{inspect(chat_room_id)}")
    Logger.debug("#{__MODULE__} join. params:#{inspect(params)}")
    #access_token = params["access_token"]
    int_room_id = String.to_integer(chat_room_id)
    claims = socket.assigns.claims
    {:ok, sub} = Poison.decode(claims["sub"])
    user_id = sub["user_id"]
    rooms = Rooms.list_my_chat_rooms(user_id)
    rooms
    |> Enum.filter(fn(room) ->
      room.members
      |> Enum.any?(fn(member) ->
        member.user_id == user_id and member.status == ChatRoomMember.status.active
      end)
    end)

    if Enum.any?(rooms, fn(room) ->
      Logger.debug("#{__MODULE__} join. room.id:#{room.id} == int_room_id:#{int_room_id}")
      room.id == int_room_id
    end) do
      #{:ok, socket}
      assigned_socket = socket
      |> assign(:chat_room_id, int_room_id)
      |> assign(:user_id, user_id)
      {:ok, assigned_socket}
    else
      Logger.debug("#{__MODULE__} join. chat_room_id:#{chat_room_id} not found your chat_rooms:#{inspect(rooms)}")
      {:error, %{reason: "unauthorized"}}
    end

  end

  def join("room:" <> _private_room_id, _params, _socket) do
    Logger.debug("#{__MODULE__} join. on error")
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("msg", %{"body" => body}, socket) do
    Logger.debug("#{__MODULE__} handle_in. with msg body:#{inspect(body)}")
    Logger.debug("#{__MODULE__} handle_in. with msg socket:#{inspect(socket)}")
    chat_room_id = socket.assigns.chat_room_id
    from_user_id = socket.assigns.user_id
    Logger.debug("#{__MODULE__} handle_in. with msg chat_room_id:#{chat_room_id} from_user_id:#{from_user_id}")

    {:ok, message} = Messages.create_chat_message(%{chat_room_id: chat_room_id, from_user_id: from_user_id, body: body, send_datetime: CalendarUtil.now()})
    {:ok, _unreads} = Messages.create_chat_unreads(chat_room_id, message.id)

    broadcast!(socket, "msg", %{id: message.id, body: message.body, from_user_id: message.from_user_id, send_datetime: CalendarUtil.now()})
    {:noreply, socket}
  end

end
