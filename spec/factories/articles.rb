FactoryBot.define do
  factory :article do
    association :user
    title { "タイトル" }
    body  { "本文" * 10 }
  end
end
