FROM jekyll/jekyll:pages

WORKDIR /srv/jekyll
COPY Gemfile* .
RUN apk update && apk add ruby-dev make cmake gcc curl build-base libc-dev libffi-dev zlib-dev libxml2-dev libgcrypt-dev libxslt-dev python

RUN bundle config build.nokogiri --use-system-libraries && \
bundle install

EXPOSE 35729 3000 4000
