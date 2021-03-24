defmodule FreshyWeb.AuthController do
  use FreshyWeb, :controller

  alias OpenIDConnect

  def authenticate(conn, params) do
    conn
    |> redirect(external: OpenIDConnect.authorization_uri(String.to_existing_atom(params["provider"])))
  end

  def authorization_uri(conn, params) do
    json(conn, %{
      uri: OpenIDConnect.authorization_uri(String.to_existing_atom(params["provider"]))
    })
  end

  def callback(conn, params) do
    with provider = String.to_existing_atom(params["provider"]),
         {:ok, tokens} <- OpenIDConnect.fetch_tokens(provider, %{code: params["code"]}),
         {:ok, claims} <- OpenIDConnect.verify(provider, tokens["access_token"]) do
      conn
      |> Plug.Conn.put_session(:provider, provider)
      |> Plug.Conn.put_session(:refresh_token, tokens["refresh_token"])
      |> Plug.Conn.put_session(:current_user, claims)
      |> Plug.Conn.assign(:current_user, claims)
      |> redirect(to: Routes.page_path(conn, :index))
    else
      _ -> send_resp(conn, 401, "User not found or unauthorized.")
    end
  end
end
