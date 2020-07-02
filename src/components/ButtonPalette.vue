<template>
    <div>
        <button ref="add" @click='addNodeEmit'>add node</button>
        <button ref="delete" @click='deleteNodeEmit'>bin nodes</button>

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
    }

  }
}
</script>
