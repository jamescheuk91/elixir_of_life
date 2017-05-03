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

    <select v-model="selectedPattern">
      <option value=null>Select Pattern</option>
      <option value="blinker">Blinker</option>
      <option value="block">Block</option>
      <option value="acorn">Acorn</option>
      <option value="beacon">Beacon</option>
    </select>
  </div>
</template>

<script>

import socket from "../js/socket"

export default {
  data() {
    let randomColorHex = '#'+(Math.random()*0xFFFFFF<<0).toString(16);
    return {
      channel: null,
      userColor: randomColorHex,
      generation: null,
      size: {
        cols: 0,
        rows: 0
      },
      liveCells: {},
      selectedPattern: null,
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
      this.pushCell({col: col, row: row, color: this.userColor, pattern: this.selectedPattern})
    },
    pushCell(params) {
      this.channel.push("add_cells", params)
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
