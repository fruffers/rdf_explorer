<template>
    <div id='wrapper'>
        <button ref="addSubj" @click='addNodeSubjectEmit'>Add subject</button>
        <button ref="addObj" @click='addNodeObjectEmit'>Add literal</button>
        <button ref="delete" @click='deleteNodeEmit'>Bin nodes</button>
        <button ref="clear" @click='clearCanvasEmit'>Clear canvas</button>
        <button ref="instruct" @click='showInstructionsEmit'>Instructions</button>
        <button ref='saveGraph' @click='saveGraphEmit'>Save graph</button>
        <button ref='loadGraph' @click='loadGraphEmit'>Load graph</button>

    </div>
</template>

<script>
// import interact from 'interactjs'
export default {
  name: 'buttonPal',

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

    saveGraphEmit () {
      this.$emit('save-graph')
    },

    loadGraphEmit () {
      this.$emit('load-graph')
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
      margin: 0.5%;
      color: #001c39;
      background-color: white;
      border: 4px solid #001c39;
      text-transform: uppercase;
  }
</style>
