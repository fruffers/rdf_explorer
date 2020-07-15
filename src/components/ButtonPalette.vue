<template>
    <div>
        <button ref="addSubj" @click='addNodeSubjectEmit'>Add subject</button>
        <button ref="addObj" @click='addNodeObjectEmit'>Add object</button>
        <button ref="delete" @click='deleteNodeEmit'>Bin nodes</button>
        <button ref="clear" @click='clearCanvasEmit'>Clear canvas</button>
        <button ref="instruct" @click='showInstructionsEmit'>Instructions</button>

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
    }

  }
}
</script>

<style scoped>
  button:hover {
    cursor: pointer;
  }
</style>
