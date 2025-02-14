FROM elixir:1.15-alpine

RUN apk add --no-cache bash openssl-dev build-base git npm inotify-tools

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only dev && \
    mix deps.compile

COPY . .

RUN mix deps.get && mix deps.compile

RUN mix compile

EXPOSE 4000

CMD ["mix", "phx.server"]
