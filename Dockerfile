FROM ruby:3.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN useradd -M developer && chown developer:developer /usr/src/app

COPY Gemfile* ./

RUN bundle config set --local deployment 'true'

RUN bundle config set --local without 'deployment test'

RUN bundle install --quiet --retry 3 --jobs 4

COPY . .

RUN touch log/development.log && chown developer:developer log/development.log

EXPOSE 6060

USER developer

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
