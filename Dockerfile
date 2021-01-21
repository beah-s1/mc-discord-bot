FROM ruby:2.7.1

WORKDIR /usr/src/app
COPY . /usr/src/app
RUN gem install bundler && \
    bundle install

CMD bundle exec ruby main.rb