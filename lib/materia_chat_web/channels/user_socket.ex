defmodule MateriaChatWeb.UserSocket do
  use Phoenix.Socket

  alias Materia.UserAuthenticator
  alias Guardian.Token.Jwt

  require Logger

  ## Channels
   channel "room:*", MateriaChatWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    #{:ok, socket}
    Logger.debug("#{__MODULE__} connect. params:#{inspect(params)} socket:#{inspect(socket)}")
    #Logger.debug("#{__MODULE__} connect. token:#{inspect(token)}")
    #try do
      access_token = params["access_token"]
      {:ok, claims } = Jwt.decode_token(UserAuthenticator, access_token)
      Logger.debug("#{__MODULE__} connect. claims:#{inspect(claims)}")
      {:ok, claims} = UserAuthenticator.on_verify(claims, access_token, %{})
      {:ok, assign(socket, :claims, claims)}
    #rescue
    #  e ->
    #    Logger.debug("#{__MODULE__} connect. exception occered.")
    #    Logger.debug("inspect(e)")
    #    {:error, "unauthenticated"}
    #end


  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MateriaWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
