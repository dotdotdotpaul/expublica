defmodule ExPublica.Member do

  @enforce_keys [:id]

  # This struct reflects the data from the "List of Members" return.
  # It appears to be the most complete for contact information and
  # current resources.
  @keys [:id, :api_uri, :first_name, :middle_name, :last_name,
         :party, :leadership_role, :twitter_account, :facebook_account,
         :govtrack_id, :cspan_id, :votesmart_id, :icpsr_id, :crp_id,
         :google_entity_id, :url, :rss_url, :domain, :in_office,
         :dw_nominate, :ideal_point, :seniority, :next_election,
         :total_votes, :missed_votes, :total_present, :ocd_id, :office,
         :phone, :state, :senate_class, :state_rank, :lis_id, 
         :missed_votes_pct, :votes_with_party_pct]

  defstruct @keys

  def from_json(%{} = hash) do
    struct(__MODULE__, conform_hash(hash))
  end
  defp conform_hash(hash) do
    Enum.reduce(@keys, %{}, fn(key, acc) ->
      Map.put(acc, key, Map.get(hash, to_string(key)) || Map.get(hash, key))
    end)   
    |> case do
      %{id: id}=x when is_nil(id) -> %{x | id: Map.get(hash, "member_id")}
      result -> result
    end
  end

end

