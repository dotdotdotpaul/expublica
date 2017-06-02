defmodule ExPublica.Member do

  alias __MODULE__
  alias ExPublica.API

  @enforce_keys [:id]
  defstruct  [:id, :api_uri, :first_name, :middle_name, :last_name,
              :party, :leadership_role, :twitter_account, :facebook_account,
              :govtrack_id, :cspan_id, :votesmart_id, :icpsr_id, :crp_id,
              :google_entity_id, :url, :rss_url, :domain, :in_office,
              :dw_nominate, :ideal_point, :seniority, :next_election,
              :total_votes, :missed_votes, :total_present, :ocd_id, :office,
              :phone, :state, :senate_class, :state_rank, :lis_id, 
              :missed_votes_pct, :votes_with_party_pct]


  def by_id(id) when is_binary(id) do
    {:ok, resp} = "https://api.propublica.org/congress/v1/members/#{id}.json"
                  |> API.get()
    case resp.body do
      %{"results" => results} -> results |> List.first |> from_json
      _ -> nil
    end
  end

  def from_json(%{} = hash) do
    %Member{id: 0}
    |> Map.keys
    |> Enum.reduce(%Member{id: 0}, fn(key, acc) ->
      %{ acc | key => hash[to_string(key)] }
    end)   
    |> Map.merge(%{id: hash["member_id"] || hash["id"]})
  end

end

