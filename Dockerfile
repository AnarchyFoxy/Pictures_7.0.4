# syntax=docker/dockerfile:1
FROM ruby:3.0.4-alpine AS builder
RUN apk add \
  build-base

WORKDIR /code
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

FROM builder AS runner
RUN apk add \
    tzdata \
    nodejs \
    yarn
WORKDIR /code
# Copy over the entire gems directory for our builder image, containing the already built artifact
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
