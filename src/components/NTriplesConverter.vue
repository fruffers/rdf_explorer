<template>
    <div id='wrapper'>
        <h3>N-Triples Converter</h3>
        <button @click='emitConvert'>Convert the graph</button>
        <!-- <span v-html='this.ntripHTML'/> -->
        {{triples}}

    </div>
</template>

<script>
export default {
  name: 'ntriplesConverter',
  props: {
    triples: String
  },
  data: function () {
    return {
      ntripHTML: ''
    }
  },
  methods: {
    emitConvert (event) {
      this.$emit('ntriples-convert')
      // convert triples to html
      // let a = 0
      // let pushValue = ''
      // let completeHTML = ''
      // for (a in this.triples) {
      //   // replace <. with &lt and &gt
      //   if (this.triples[a] === '<') {
      //     pushValue = '&lt'
      //   } else if (this.triples[a] === '>') {
      //     pushValue = '&gt'
      //   } else if (this.triples[a] === ' . ') {
      //     pushValue = '.</br>'
      //   } else {
      //     pushValue = this.triples[a]
      //   }
      //   completeHTML += pushValue
      // }
      // this.ntripHTML = completeHTML
    }
  }
}
</script>

<style scoped>
#wrapper {
  text-align: left;
  overflow-wrap:break-word;
  padding: 10%;
}
</style>
