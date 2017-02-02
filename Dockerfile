From alpine:latest

MAINTAINER Satoru Murakami

ENV RUNTIME_PACKAGES = "ruby ruby-irb ruby-json ruby-rake ruby-bigdecimal ruby-io-console ruby-rdoc ruby-dev libxml2-dev libxslt-dev sqlite tzdata nodejs ca-certificates"\
    DEV_PACKEGES = "build-base sqlite-dev"

RUN mkdir -p /usr/src/my_app
WORKDIR /usr/src/my_app

RUN apk add --update --no-cache ruby ruby-irb ruby-json ruby-rake ruby-bigdecimal ruby-io-console ruby-rdoc ruby-dev libxml2-dev libxslt-dev sqlite tzdata nodejs ca-certificates

COPY Gemfile /usr/src/my_app
COPY Gemfile.lock /usr/src/my_app

RUN apk add --update\
    --virtual build-dependencies\
    --no-cache\
    $DEV_PACKAGES && \
    gem install bundler --no-document && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --without development test && \
    apk del build-dependencies

COPY . .

RUN rails assets:precompile RAILS_ENV=production

CMD rails s -p 3000 -b '0.0.0.0'
