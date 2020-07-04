<template>
    <g id="innerbinrect">
          <rect ref='deletebin'  fill="red" width=100 height=100></rect>
          <text font-family="Verdana" font-size="35" x=10 y=50>bin</text>
    </g>
</template>

<script>
import interact from 'interactjs'

export default {
  name: 'binRect',

  mounted () {
    this.deleteDropZone()
  },

  methods: {

    deleteDropZone () {
      const interactive = interact('#innerbinrect')

      interactive.dropzone({
        accept: '.node',
        overlap: 0.10,
        // listeners. these are automatic so nothing has to be bound in the template DOM
        ondropactivate: this.deleteNodeEmit

      })
    },

    deleteNodeEmit (event) {
      this.$emit('delete-node', event)
    }

  }

}
</script>
