use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

# Configures Sentry
# config :sentry,
#   enable_source_code_context: true,
#   root_source_code_path: File.cwd!(),
#   tags: %{
#     env: "production"
#   }
