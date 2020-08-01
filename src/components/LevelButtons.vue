<template>
    <div id='wrapper'>
        <a id='pal' v-for='(level,index) in levels' :key='index'>
            <button @click='levelChangeEmit'> Level <a id='levelPickBtn'>{{level.no}}</a> </button>
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
      this.$emit('levelPick', document.getElementById('levelPickBtn').innerText)
    }
  }
}
</script>
<style scoped>
    #wrapper {
      margin-right: 50%;
      margin-bottom: 0;
      padding-top: 5%;
      padding-bottom: 0;
    }
    #pal {
        /* display: block; */
        /* padding: 2%;
        padding-top: 5%;
        margin-bottom: 0;
        padding-bottom: 0;
        margin-right: 90%; */
    }
    button {
        display: inline-block;
        padding: 1%;
    }
</style>
