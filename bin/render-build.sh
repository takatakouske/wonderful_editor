#!/usr/bin/env bash
set -o errexit

# Node deps (Webpacker用)
yarn install --frozen-lockfile || yarn install

# Ruby deps
bundle install

# アセット & DB
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
