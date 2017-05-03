# ElixirOfLife
This web game is built on top of real-time web Phoenix Framework and Vue.js.

## Requirements
  * Erlang
  * Elixir
  * Nodejs


### To start app in local:
  * Install Hex with `mix local.hex`
  * Install Phoenix with `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


### To run test cases:
  * `mix test`

### Deploy to Heroku:
  * Install Heroku Cli
  * Create Heroku app with `heroku create --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"`
  * Add Phoenix Static Buildpack with `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git`
  * Deploy with `git push heroku master`
