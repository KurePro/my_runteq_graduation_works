FROM ruby:3.3

# Node.jsとYarnのセットアップ
RUN apt-get update -qq && apt-get install -y curl gnupg

# Node.js (Debian公式)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Yarn（corepack）とRails用ライブラリ
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    git \
    build-essential \
    libpq-dev \
    libyaml-dev && \
    corepack enable && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rails

COPY Gemfile Gemfile.lock ./
RUN bundle config set path 'vendor/bundle'
RUN bundle install

COPY . .

# entrypoint.sh の設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Railsサーバ起動
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]