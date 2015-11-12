Rails.application.routes.draw do
  get 'home/index'
  get "home/encryption" => "home#perform_encryption"
  get "home/decryption" => "home#perform_decryption"
  root to: "home#index"
end
