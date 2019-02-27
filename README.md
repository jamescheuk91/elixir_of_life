# ElixirOfLife

To create a multiplayer web app version of Game of Life which is a famous simulation that demonstrates cellular automaton.
It is modeled as a grid with 4 simple rules:
  1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  2. Any live cell with two or three live neighbours lives on to the next generation.
  3. Any live cell with more than three live neighbours dies, as if by overcrowding.
  4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.


## Requirements
  * Erlang 20.1
  * Elixir 1.6.5
  * Nodejs 10.7.0

## Architecture
This web game is built on top of real-time web Phoenix Framework and Vue.js.
One of the challenges is to synchronize the world view between clients. Phoenix was chosen to solve the read-time update challenge. Phoenix is built on top of elixir and erlang which are highly concurrent.
Websocket and pub/sub communication are used for frontend and backend real-time communication.

It can be scale really well.(http://www.phoenixframework.org/blog/the-road-to-2-million-websocket-connections)

## Code Index
  * core game logic -> board.ex
  * pattern -> pattern.ex
  * read-time communication -> game_channel.ex
  * core front-end app logic -> elixirOfLifeApp.vue

## TODOS:
  * Show list of online users. Phoenix.Presence can be used. `https://hexdocs.pm/phoenix/Phoenix.Presence.html`
  * Leaderboard
  * Breakdown view into more components. etc. Board, Cell, Toolbar.
  * Write test cases for GameChannel



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
