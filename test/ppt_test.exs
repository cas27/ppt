defmodule PptTest do
  use ExUnit.Case
  import Ppt

  test "token" do
    {status, msg } = get_token
    assert status == :ok
  end

  test "purchase" do
    card = %{number: "5500005555555559",
             type: "mastercard",
             expire_month: 12,
             expire_year: 2020,
             cvv2: 111
            }
    transaction = %{total: "25.99",
                    description: "Test description"
                   }
    %{status_code: status_code} = purchase(card, transaction)
    assert status_code == 201
  end
end
