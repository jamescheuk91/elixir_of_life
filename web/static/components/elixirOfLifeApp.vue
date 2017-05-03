<template>
  <div class="app">
    <h1>Game Of Life {{generation}}</h1>

    <table class="game-board">
      <tr v-for="row in size.rows" track-by="$index">
        <td
          v-for="col in size.cols"
          v-bind:style="{
            backgroundColor: liveCells[col] && liveCells[col][row] ? liveCells[col][row].color : null
          }"
          v-on:click="clickCell(col, row)"
          track-by="$index">
        </td>
      </tr>
    </table>
  </div>
</template>

<script>

import socket from "../js/socket"

export default {
  data() {
    let randomColorHex = '#'+Math.floor(Math.random()*16777215).toString(16)
    return {
      channel: null,
      userColor: randomColorHex,
      generation: null,
      size: {
        cols: 0,
        rows: 0
      },

      liveCells: {}
    }
  },
  mounted() {
    this.channel = socket.channel("game:lobby", {});
    this.channel.on("board_state", payload => {
      console.log(payload)
    })
    this.channel.on("board_update", payload => {
      console.log(payload)
      this.setBoardData(payload)
    });
    this.channel.join()
      .receive("ok", payload => {
        console.log("Joined successfully", payload)
        this.setBoardData(payload)
      })
      .receive("error", response => { console.log("Unable to join", payload) })
  },



  render(createElement) {
    return createElement(App, {})
  },

  methods: {
    clickCell(col, row) {
      this.pushCells([{col: col, row: row, color: this.userColor}])
    },
    pushCells(cells) {
      this.channel.push("add_cells", {cells: cells})
    },
    setBoardData(payload) {
      this.generation = payload.generation
      this.size = payload.size
      this.liveCells = payload.live_cells
      console.log(this.liveCells)
    }
  }
}
</script>

<style lang="sass">
.app {
  h1 {
    text-align: center;
    margin-right: auto;
    margin-left: auto;
  }
}

.game-board {
  margin-right: auto;
  margin-left: auto;
  table-layout: fixed;
  border-collapse: collapse;
  border-spacing: 0;
  background-color: #d5dae6;
  tr {
    height : 9px;
  }
  td {
    // padding: 0;
    border: 1px solid white;
    width: 10px;
  }
}
</style>
