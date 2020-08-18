<template>
    <div id='wrapper'>
        <button id='instructions' ref="instruct" @click='showInstructionsEmit'>Instructions</button>
        <button ref="addSubj" @click='addNodeSubjectEmit'>Add subject</button>
        <button ref="addObj" @click='addNodeObjectEmit'>Add literal</button>
        <button ref="delete" @click='deleteNodeEmit'>Bin nodes</button>
        <button ref="clear" @click='clearCanvasEmit'>Clear</button>
        <button
          class='collapse'
          ref='saveGraph'
          @click='showCollapseContent'>
          Save graph
        </button>
          <div class='collapseContent'>
            <p><a>Save locally</a></p>
            <br/>
            <p>
              <a
              @click='exportGraphEmit'
              :download='graphName'
              :href='exportURL'>
              Export to JSON
              </a>
            </p>
          </div>
        <button
          class='collapse'
          ref='loadGraph'
          @click='showCollapseContent'>
          Load graph
        </button>
          <div class='collapseContent'>
            <p><a>Load locally</a></p>
            <br/>
            <a
            v-for='(importa,index) in imports' :key='index'>
              <a href='importa.link'>{{importa.name}}</a>
            </a>
            <a @click='fileLoader'>Import file</a>
            <a>
              <input ref='fileIn' id='fileInputBox' @change='fileInputEmit'
                type='file'
                value='Import JSON'
                accept='.json, .txt'
              >
            </a>
          </div>

    </div>
</template>

<script>
// import interact from 'interactjs'
export default {
  name: 'buttonPal',
  props: {
    exportURL: String,
    graphName: String,
    imports: Array
  },

  methods: {
    fileLoader (event) {
      const el = this.$refs.fileIn
      el.click()
    },

    addNodeSubjectEmit () {
      this.$emit('add-subject')
    },

    addNodeObjectEmit () {
      this.$emit('add-object')
    },

    deleteNodeEmit () {
      this.$emit('delete-node')
    },

    clearCanvasEmit () {
      this.$emit('clear-canvas')
    },

    showInstructionsEmit () {
      this.$emit('instruct-alert')
    },

    showCollapseContent (event) {
      // show dropdown
      const content = event.target.nextElementSibling
      if (content.style.display === 'block') {
        content.style.display = 'none'
      } else {
        content.style.display = 'block'
      }
    },

    exportGraphEmit () {
      this.$emit('export-graph')
    },

    fileInputEmit (event) {
      // use File API to access file contents
      this.$emit('file-input', event.target.files)
    }

  }
}
</script>

<style scoped>
  button:hover {
    cursor: pointer;
    text-decoration: underline;
  }
  button {
      height: 1%;
      /* float: right; */
      color: #001c39;
      text-transform: uppercase;
      padding-bottom: 50%;
      padding-top: 30%;
      text-align: center;
  }
  .collapseContent {
    padding: 5%;
    display: none; /*swap between none and block to show content*/
    overflow: hidden;
  }

  .inputBox {
    padding: 0;
    margin: 0;
  }

  #fileInputBox {
    display: none;
  }
  #instructions {
    background-color: whitesmoke;
  }
</style>
