defmodule Freshy.AuthPlug do
  use FreshyWeb, :controller

  def init(options), do: options

  def call(conn, _options) do
    user = Plug.Conn.get_session(conn, :current_user)
    if !user do
      conn
      |> put_status(302)
      |> redirect(to: Routes.auth_path(conn, :authenticate, :keycloak))
    else
      conn
      |> put_status(200)
      |> Plug.Conn.assign(:current_user, user)
    end
  end
end
