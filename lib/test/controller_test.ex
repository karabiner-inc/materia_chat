defmodule MateriaTest.Test.ControllerTest do


  @doc """

  """
  def post!(request_url, params, access_token \\ nil) do

    {:ok, request_body} = Poison.encode(params)

    request_header = [{"Content-Type", "application/json"}]

    request_header =
      if access_token != nil do
        request_header ++ [{"Authorization", "Bearer #{access_token}"}]
      else
        request_header
      end

    response = HTTPoison.post!(request_url, request_body, request_header)

    body =
    try do
      {:ok, body} = Poison.decode(response.body)
      body
    rescue
      e ->
        response.body
    end

    {response.status_code, body}
  end

  @doc """

  """
  def get!(request_url, access_token \\ nil) do

    request_header = [{"Content-Type", "application/json"}]

    request_header =
      if access_token != nil do
        request_header ++ [{"Authorization", "Bearer #{access_token}"}]
      else
        request_header
      end

    response = HTTPoison.get!(request_url, request_header)

    body =
    try do
      {:ok, body} = Poison.decode(response.body)
      body
    rescue
      e ->
        IO.inspect(e)
        response.body
    end

    {response.status_code, body}
  end

  @doc """



  %{
  "access_token" => "xxx",
  "id" => 1,
  "refresh_token" => "yyyy"
  }

  """
  def sign_in(request_url, email, password) do

    params = %{
      email: email,
      password: password
    }

    {status_code, body} = post!(request_url, params)
  end
end
