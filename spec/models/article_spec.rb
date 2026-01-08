require 'rails_helper'

RSpec.describe Article, type: :model do
  subject { build(:article) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(100) }

  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_most(10_000) }
    describe 'status enum' do
    it 'enum が定義されている（draft:0, published:1）' do
      expect(Article.statuses).to eq("draft"=>0, "published"=>1)
    end

    it 'デフォルトは draft になる' do
      article = build(:article) # factoryでstatus未指定
      expect(article.status).to eq('draft')
      expect(article.status_draft?).to be true
    end

    it '下書き記事として保存できる（status: :draft）' do
      article = build(:article, status: :draft)
      expect(article.save).to be true
      expect(article.reload.status_draft?).to be true
    end

    it '公開記事として保存できる（status: :published）' do
      article = build(:article, status: :published)
      expect(article.save).to be true
      expect(article.reload.status_published?).to be true
    end
  end
end
