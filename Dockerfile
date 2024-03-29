# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rode app lives here
WORKDIR /roda

# Set production environment
ENV RODA_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libsqlite3-dev libvips pkg-config

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libsqlite3-dev libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /roda /roda

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 roda && \
    useradd roda --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R roda:roda storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/roda/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
# EXPOSE 3000
CMD ["./bin/rake", "server"]
