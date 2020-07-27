<template>
    <div>
        <div id='pal' v-for='(level,index) in levels' :key='index'>
            <button @click='levelChangeEmit'> Level <a id='levelPickBtn'>{{level.no}}</a> </button>
        </div>
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
    #pal {
        display: inline-block;
        padding: 2%;
        padding-bottom: 0;
        margin-right: 80%;
    }
    button {
        padding: 5%;
    }
</style>
