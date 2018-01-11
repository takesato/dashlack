FROM ruby:2.4-alpine3.6

WORKDIR "/app"
COPY . "/app"

RUN apk --no-cache update \
 && apk --update add build-base \
 && rm -rf /var/cache/apk/* \
 && cd /app \
 && bundle install


CMD ["bundle", "exec", "dashing", "start", "-d"]

