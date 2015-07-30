defmodule PptTest do
  use ExUnit.Case
  import Ppt

  test "token" do
    {status, msg } = get_token
    assert status == :ok
  end

  test "purchase" do
    %{status_code: status_code} = purchase
    assert status_code == 201
  end
end
