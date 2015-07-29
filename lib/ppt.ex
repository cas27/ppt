defmodule Ppt do
  #defp http(method, path, params \\ [], opts \\ []) do
    #credentials = Keyword.get(opts, :credentials)
    #headers     = [{"Content-Type", "application/x-www-form-urlencoded"}]
    #data        = params_to_string(params)

    #HTTPoison.request(method, path, data, headers, [hackney: [basic_auth: credentials]])
  #end

  def get_token do
    HTTPoison.request(:post,
                      "https://api.sandbox.paypal.com/v1/oauth2/token",
                      "grant_type=client_credentials",
                      [{"Content-Type", "application/x-www-form-urlencoded"}],
                      [hackney: [basic_auth:
                                 {"AeosmXJ1nZWwJgErHHhzxpOS0fH7Ki6qu4LVEotJA3al_bsZcnnYsvc1dDAi_71JYIdwkxeFHDu4sdEy",
                                  "EDL8FGl7O6Xy-oIjdvcl4TRrx9EqKEkU_vKTi2qV3S95vfh1RB9gqiBJ6Uys-NuhSWCOn3FO84JFdpXy"}]])
    |> token
  end

  def purchase do
    oauth_token = get_token
    HTTPoison.request(:post,
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

  defp token({:ok, %HTTPoison.Response{body: body}}) do
    data = Jazz.decode!(body)
    data["access_token"]
  end
end
