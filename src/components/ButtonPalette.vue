<template>
    <div>
        <button ref="add" @click='addNodeEmit'>Add node</button>
        <button ref="delete" @click='deleteNodeEmit'>Bin nodes</button>
        <button ref="clear" @click='clearCanvasEmit'>Clear canvas</button>

    </div>
</template>

<script>
// import interact from 'interactjs'
export default {
  name: 'buttonPal',

  methods: {
    addNodeEmit () {
      this.$emit('add-node')
    },

    deleteNodeEmit () {
      this.$emit('delete-node')
    },

    clearCanvasEmit () {
      this.$emit('clear-canvas')
    }

  }
}
</script>
