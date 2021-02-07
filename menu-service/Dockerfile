FROM ruby:3-alpine

RUN apk update && \
    apk add -f bash \
               build-base \
               postgresql-dev
WORKDIR /usr/src/app/
COPY . /usr/src/app/
COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install -j $(nproc)

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-p", "3000"]