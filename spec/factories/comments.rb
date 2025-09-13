FactoryBot.define do
  factory :comment do
    association :user
    association :article
    body { "コメント本文" }
  end
end
