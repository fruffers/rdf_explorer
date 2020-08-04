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
      console.log('inner level' + this.$refs.levelCount)
      this.$emit('levelPick', this.$refs.levelCount)
    }
  }
}
</script>
<style scoped>
    #wrapper {
      margin-bottom: 0;
      padding-top: 5%;
      padding-bottom: 0;
      margin-right: 30%;
    }
    #pal {
        margin-bottom: 0;
        padding-bottom: 0;
    }
    button {
        display: inline-block;
        padding: 1%;
    }
</style>
