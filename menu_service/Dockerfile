FROM ruby:3-alpine

ENV APP_PATH=/usr/src/app/

RUN apk update && \
    apk add -f bash \
               build-base \
               postgresql-dev \
               postgresql-client

WORKDIR ${APP_PATH}
COPY . ${APP_PATH}
COPY Gemfile Gemfile.lock ${APP_PATH}
RUN bundle install -j $(nproc)

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-p", "3000"]