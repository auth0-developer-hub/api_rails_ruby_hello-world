FROM ruby:3.1.0@sha256:c980973bd1a1475349da614701cce0e19e6b0b93238a53ea9c07380e64c264c7 as build

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir /app

RUN useradd -m developer

RUN groupadd auth0

RUN usermod -a -G auth0 developer

RUN chown -R developer:auth0 /app

WORKDIR /app

RUN mkdir log && touch log/production.log && chown developer:auth0 log/production.log

USER developer

RUN mkdir -p tmp/pids

COPY Gemfile* ./

RUN bundle config set --local deployment 'true'

RUN bundle config set --local without 'development test'

RUN bundle install --retry 3

COPY app app/
COPY config config/
COPY config.ru Rakefile ./


FROM ruby:3.1.0-slim-buster@sha256:1a3487de40a5400638f9494d7f920b21e26cdec949ad7d1851a84bb93f95b93a

RUN mkdir /app

RUN useradd -m developer

RUN groupadd auth0

RUN usermod -a -G auth0 developer

RUN chown -R developer:auth0 /app

WORKDIR /app

USER developer

COPY --from=build /app /app

ENV RAILS_ENV=production

RUN bundle config set --local deployment 'true'

RUN bundle config set --local without 'development test'

EXPOSE 6060

CMD ["bundle", "exec", "puma"]
