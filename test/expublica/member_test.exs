defmodule ExPublica.MemberTest do
  use ExUnit.Case
  doctest ExPublica.Member

  alias ExPublica.Member

  describe "from_json" do
    test "with id" do
      raw_hash = %{"id" => 42, "first_name" => "Paul"}
      assert Member.from_json(raw_hash) == %Member{id: 42, first_name: "Paul"}
    end

    test "with member_id" do
      raw_hash = %{"member_id" => 42, "first_name" => "Paul"}
      assert Member.from_json(raw_hash) == %Member{id: 42, first_name: "Paul"}
    end
  end
end
