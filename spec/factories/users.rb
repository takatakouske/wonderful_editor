FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    provider { 'email' }
    uid { email } # devise_token_auth は [uid, provider] が一意。uid に email を入れる運用が楽
  end
end
