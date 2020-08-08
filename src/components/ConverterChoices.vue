<template>
    <div>
        <button
        @click='fetchNtriples'
        >
        Convert to RDF XML</button>
        <div id='rdfxmlWrap'>
            {{rdfxml}}
        </div>
    </div>
</template>

<script>
import rdfTranslator from 'rdf-translator'
export default {
  name: 'converterPalette',
  props: {
    triples: Array
  },
  data () {
    return {
      rdfxml: 'test'
    }
  },
  methods: {
    fetchNtriples () {
      this.$emit('fetch-triples')
      this.convertRDFXML(this.triples)
    },
    convertRDFXML (input) {
      // convert n-triples to xml/rdf
      const xml = rdfTranslator(input, 'n-triples', 'xml', function (err, data) {
        if (err) { return console.error(err) }
        console.log(data)
        this.rdfxml = data
      })
      this.rdfxml = xml
    }
  }

}
</script>
