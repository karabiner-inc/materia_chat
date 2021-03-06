use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :materia_chat, MateriaChatWeb.Test.Endpoint,
  http: [port: 4001],
  server: true,
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :materia_chat, MateriaChat.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "materia_chat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :materia_chat, repo: MateriaChat.Test.Repo

# Configures GuardianDB
config :guardian, Guardian.DB,
  repo: MateriaChat.Test.Repo,
  # default
  schema_name: "guardian_tokens",
  # token_types: ["refresh_token"], # store all token types if not set
  # default: 60 minutes
  sweep_interval: 60

# Configures MateriUtils
config :materia_utils, test_base_datetime: "2019-03-03T00:00:00.000Z"
