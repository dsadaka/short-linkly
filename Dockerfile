FROM ruby:2.6.2
MAINTAINER warren@travelershaven.com

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
  bundle install

COPY . ./

EXPOSE 3000
