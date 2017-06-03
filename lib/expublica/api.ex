defmodule ExPublica.API do
  @moduledoc """
    Contains the actual API call handling functions.
  """

  use HTTPoison.Base

  def key() do
    Application.get_env(:expublica, :api_key)
  end

  def process_request_headers(headers) do
    Map.put(headers, :"X-API-Key", key())
  end

  def process_request_options(options \\ []) do
    Keyword.merge(options, [ssl: [{:versions, [:'tlsv1.2']}]])
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end

