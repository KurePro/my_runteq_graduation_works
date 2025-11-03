FROM ruby:3.3

# 必要ツールをまとめてインストール（nodejsを削除）
RUN apt-get update -qq && apt-get install -y \
    curl \
    gnupg \
    git \
    build-essential \
    libpq-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Node.js のセットアップ（Debian公式）
# 1. NodeSourceのリポジトリを追加するスクリプトを実行
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# 2. リポジトリ追加後、パッケージリストを更新してから nodejs をインストール
RUN apt-get update -qq && apt-get install -y nodejs

# Corepack/Yarnを初期化して安定版を有効化
RUN corepack enable \
    && corepack prepare yarn@1.22.22 --activate \
    && yarn -v

WORKDIR /rails

# Gemfileだけ先にコピーして bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle config set path 'vendor/bundle' \
    && bundle install

# アプリケーションコピー
COPY . .

# entrypoint.sh の設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 開発用ポート
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]