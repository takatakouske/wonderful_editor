set -o errexit

bundle install
yarn install --frozen-lockfile || yarn install

# 初回も再デプロイもこれでOK（create + migrate）
bundle exec rails db:prepare

# 本番アセット
bundle exec rails assets:precompile
bundle exec rails assets:clean
