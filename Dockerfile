#  rubyの2.7.1 をベースイメージに指定
FROM ruby:2.7.1

# ruby コンテナの中で実行するコマンドを以降に記載

# rails 実行に必要な build-essentialとnodejsをインストール
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#RUN apt-get  && apt-get install -y nodejs yarn postgresql-client
# chromeの追加
RUN apt-get update && apt-get install -y unzip && \
CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
unzip ~/chromedriver_linux64.zip -d ~/ && \
rm ~/chromedriver_linux64.zip && \
chown root:root ~/chromedriver && \
chmod 755 ~/chromedriver && \
mv ~/chromedriver /usr/bin/chromedriver && \
sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
apt-get update && apt-get install -y google-chrome-stable


# ruby コンテナのルートディレクトリにappディレクトリを作成
RUN mkdir /app

# appディレクトリを作業ディレクトリに指定
WORKDIR /app

# Dockerfileと同じディレクトリに存在するファイルをrubyコンテナのappディレクトリ配下にコピーする
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Gemのインストールコマンド
RUN bundle install

# Dockerfileと同じディレクトリに存在するファイルをrubyコンテナ内にコピーする
COPY . /app
