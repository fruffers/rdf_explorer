<template>
    <div id='wrapper'>
        <h3>N-Triples Converter</h3>
        <button @click='emitConvert'>Convert the graph</button>
        <br/>
            <code v-for='triple in triples' :key='triple.index'>
                {{triple.subject}} {{triple.predicate}} {{triple.object}} .
                <br/>
            </code>
    </div>
</template>

<script>
export default {
  name: 'ntriplesConverter',
  props: {
    triples: Array
  },
  methods: {
    emitConvert (event) {
      this.$emit('turtle-convert')
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
