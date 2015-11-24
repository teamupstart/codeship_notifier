Rails.application.routes.draw do
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  resource :codeship_webhooks, only: :create, defaults: { formats: :json }
end
