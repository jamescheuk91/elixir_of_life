// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

import Vue from 'vue'
import ElixirOfLifeApp from "../components/elixirOfLifeApp.vue"

// Create the main component
Vue.component('app', ElixirOfLifeApp)

// And create the top-level view model:
new Vue({
  el: '#app',
  render(createElement) {
    return createElement(ElixirOfLifeApp, {})
  },

});
