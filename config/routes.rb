Rails.application.routes.draw do
  get 'cipher/index'
  root to: "cipher#index"
end
