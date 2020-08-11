<template>
    <div id='wrapper'>
        <h3>N-Triples Converter</h3>
        <button @click='emitConvert'>Convert the graph</button>
        <!-- <textspan v-html='this.triples'/> -->
        {{triples}}

    </div>
</template>

<script>
export default {
  name: 'ntriplesConverter',
  props: {
    triples: String
  },
  methods: {
    emitConvert (event) {
      this.$emit('ntriples-convert')
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
