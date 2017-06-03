defmodule ExPublica.Members do
  use GenServer

  alias __MODULE__
  alias ExPublica.{API, Member}

  @enforce_keys [:id]
  # This struct reflects the data from the "List of Members" return.
  # It appears to be the most complete for contact information and
  # current resources.
  defstruct  [:id, :api_uri, :first_name, :middle_name, :last_name,
              :party, :leadership_role, :twitter_account, :facebook_account,
              :govtrack_id, :cspan_id, :votesmart_id, :icpsr_id, :crp_id,
              :google_entity_id, :url, :rss_url, :domain, :in_office,
              :dw_nominate, :ideal_point, :seniority, :next_election,
              :total_votes, :missed_votes, :total_present, :ocd_id, :office,
              :phone, :state, :senate_class, :state_rank, :lis_id, 
              :missed_votes_pct, :votes_with_party_pct]


  def start_link(), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def list(chamber, congress \\ 115), do: do_list(chamber, congress)
  defp do_list(pid, chamber, congress) when is_integer(congress) do
    GenServer.call(__MODULE__, {:list, chamber, congress})
  end
  defp do_list(pid, chamber, congress) when is_binary(congress) do
    do_list(pid, chamber, String.to_integer(congress))
  end

  ### GenServer implementations

  def handle_call({:list, "senate", congress}, from, state) do
    handle_list(congress, "senate", from, state)
  end
  def handle_call({:list, "house", congress}, from, state) do
    handle_list(congress, "house", from, state)
  end
  def handle_call({:list, chamber, congress}, from, state)
      when not is_binary(chamber) do
    handle_call({:list, String.downcase(to_string(chamber)), congress},
                from, state)
  end
  # Cache handling
  defp handle_list(congress, chamber, from, state) do
    new_state = Map.put_new_lazy(state, congress, fn -> %{} end)
    congress_state = Map.get(new_state, congress)
    new_congress_state = Map.put_new_lazy(congress_state, chamber,
                               fn -> retrieve(congress, chamber) end)
    response = case Map.get(new_congress_state, chamber) do
      {:error, errors} -> {:error, errors}
      members -> {:ok, members}
    end
    
    {:reply, response, %{new_state | congress => new_congress_state}}
  end

  defp retrieve(congress, chamber) do
    {:ok, response} = API.get("https://api.propublica.org/congress/v1/#{congress}/#{chamber}/members.json")
    result_from_response(response.body)
  end
  defp result_from_response(%{"results" => [results|_]}) do
    Map.get(results, "members") |> Enum.map(&Member.from_json/1)
  end
  defp result_from_response(response) do
    {:error, Map.get(response, "errors") |> Enum.map(&(Map.get(&1, "error")))}
  end

end

