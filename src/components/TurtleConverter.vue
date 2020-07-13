<template>
    <div>
        <h3>Turtle Converter</h3>
        <button @click='emitConvert'>Convert the graph</button>
        <pre id='wrapper'>
            <code v-for='triple in triples' :key='triple.index'>
                {{triple.subject}} {{triple.predicate}} {{triple.object}} .
                <br/>
            </code>
        </pre>
    </div>
</template>

<script>
export default {
  name: 'turtleConverter',
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
        margin-right: 20%;
    }
</style>
