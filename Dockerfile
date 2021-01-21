FROM ruby:2.7.1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock /usr/src/app/

RUN gem install bundler && \
    bundle install

COPY . /usr/src/app

CMD bundle exec ruby main.rb -p 3000 -o 0.0.0.0
EXPOSE 3000