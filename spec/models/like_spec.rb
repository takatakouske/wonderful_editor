require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { build(:like) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:article) }

  it 'validates uniqueness of [user_id, article_id]' do
    existing = create(:like)
    dup = build(:like, user: existing.user, article: existing.article)
    expect(dup).to be_invalid
    expect(dup.errors[:user_id]).to be_present
  end
end
