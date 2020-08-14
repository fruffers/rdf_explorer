<template>
    <div id='wrapper'>
        <a id='pal' v-for='(level,index) in levels' :key='index'>
            <button @click='levelChangeEmit'> Level <a ref='levelCount' id='levelPickBtn'>{{parseInt(level.no)}}</a> </button>
        </a>
    </div>
</template>

<script>
export default {
  name: 'levelButtons',
  props: {
    levels: Array
  },
  methods: {
    levelChangeEmit (event) {
    // give level change number
      // console.dir(event.currentTarget, { depth: null })
      const levelCount = event.currentTarget.lastElementChild.innerText
      this.$emit('levelPick', levelCount)
    }
  }
}
</script>
<style scoped>

</style>
