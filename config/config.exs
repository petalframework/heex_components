import Config

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
