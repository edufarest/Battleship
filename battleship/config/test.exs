use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :battleship, BattleshipWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :battleship, Battleship.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "shae3LeeRa4e",
  database: "battleship_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
