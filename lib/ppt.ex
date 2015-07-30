defmodule Ppt do

  def get_token do
    HTTPoison.request!(:post,
                      "https://api.sandbox.paypal.com/v1/oauth2/token",
                      "grant_type=client_credentials",
                      [{"Content-Type", "application/x-www-form-urlencoded"}],
                      [hackney: [basic_auth:
                                 {Application.get_env(:ppt, :user),
                                  Application.get_env(:ppt, :secret)}]])
    |> token
  end

  def purchase do
    {_, oauth_token} = get_token
    HTTPoison.request!(:post,
                      "https://api.sandbox.paypal.com/v1/payments/payment",
                      Jazz.encode!(%{
                        intent: "sale",
                        payer: %{
                          payment_method: "credit_card",
                          funding_instruments:
                          [
                            %{
                              credit_card: %{
                                number: "5500005555555559",
                                type: "mastercard",
                                expire_month: 12,
                                expire_year: 2020,
                                cvv2: 111
                              }
                             }
                          ]
                        },
                        transactions: [
                          %{
                            amount: %{
                              total: "19.99",
                              currency: "USD"
                            },
                            description: "Test payment"
                          }
                        ]
                      }),
                      [{"Content-Type", "application/json"}, {"Authorization", "Bearer #{oauth_token}"}])
  end

  defp token(%{body: body, status_code: 200}) do
    data = Jazz.decode!(body)
    {:ok, data["access_token"]}
  end

  defp token(%{body: body, status_code: 401}) do
    data = Jazz.decode!(body)
    {:error, data["error"]}
  end
end
