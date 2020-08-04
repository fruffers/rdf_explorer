<template>
    <div id='wrapper'>
        <button ref="addSubj" @click='addNodeSubjectEmit'>Add subject</button>
        <button ref="addObj" @click='addNodeObjectEmit'>Add literal</button>
        <button ref="delete" @click='deleteNodeEmit'>Bin nodes</button>
        <button ref="clear" @click='clearCanvasEmit'>Clear canvas</button>
        <button ref="instruct" @click='showInstructionsEmit'>Instructions</button>
        <button
          class='collapse'
          ref='saveGraph'
          @click='showCollapseContent'>
          Save graph
        </button>
          <div class='collapseContent'>
            <p><a>Save locally</a></p>
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
            <a
            v-for='(importa,index) in imports' :key='index'>
              <a href='importa.link'>{{importa.name}}</a>
            </a>
            <p>Import file<input @change='fileInputEmit'
            type='file'
            value='Import JSON'
            accept='.json, .txt'
            ></p>
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
  #wrapper {
    padding: 0;
    height: 1px;
    width: 50%;
  }
  button:hover {
    cursor: pointer;
    text-decoration: underline;
  }
  button {
      height: 1%;
      float: right;
      color: #001c39;
      border: 4px solid #001c39;
      text-transform: uppercase;
  }
  .collapseContent {
    padding: 5%;
    display: none; /*swap between none and block to show content*/
    overflow: hidden;
  }
</style>
