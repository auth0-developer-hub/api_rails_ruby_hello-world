FROM ruby:3.1.0@sha256:c980973bd1a1475349da614701cce0e19e6b0b93238a53ea9c07380e64c264c7 as build
RUN groupadd auth0 && useradd -m developer -g auth0
USER developer
RUN mkdir /home/developer/app
WORKDIR /home/developer/app
COPY Gemfile* ./
RUN bundle config set --local deployment 'true'
RUN bundle config set --local without 'development test'
RUN bundle install --retry 3
COPY app app
COPY config config
COPY config.ru Rakefile ./

FROM ruby:3.1.0-slim-buster@sha256:1a3487de40a5400638f9494d7f920b21e26cdec949ad7d1851a84bb93f95b93a
RUN groupadd auth0 && useradd -m developer -g auth0
USER developer
RUN mkdir /home/developer/app
WORKDIR /home/developer/app
COPY --from=build /home/developer/app /home/developer/app
RUN mkdir log \
    && touch log/production.log \
    && mkdir -p tmp/pids
RUN bundle config set --local deployment 'true'
RUN bundle config set --local without 'development test'
ENV RAILS_ENV=production
EXPOSE 6060
CMD ["bundle", "exec", "puma"]
