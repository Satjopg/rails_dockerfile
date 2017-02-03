From alpine:latest

MAINTAINER Satoru Murakami

ENV RUNTIME_PACKAGES="tzdata nodejs ca-certificates" \
    RUBY_PACKAGES="ruby ruby-rdoc ruby-io-console ruby-irb ruby-json ruby-rake ruby-bigdecimal" \
    DEV_PACKAGES="build-base sqlite-dev libxml2-dev libxslt-dev libffi-dev ruby-dev"

RUN apk add --update --upgrade --no-cache $RUNTIME_PACKAGES $RUBY_PACKAGES

RUN apk add --update --virtual build-dependencies --no-cache $DEV_PACKAGES && \
    gem install -N bundler --no-document && \
    gem install -N nokogiri -- --use-system-libraries && \
    gem install -N ffi -- --use-system-libraries && \
    gem install -N rails && \
    bundle config build.nokogiri --use-system-libraries && \
    apk del build-dependencies

EXPOSE 3000

CMD ["/bin/sh"]
