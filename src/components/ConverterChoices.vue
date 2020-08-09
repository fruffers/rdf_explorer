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
// import rdfTranslator from 'rdf-translator'
import jquery from 'jquery'
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
      // use API http://rdf-translator.appspot.com/
      jquery.ajax({
        type: 'POST',
        url: 'http://rdf-translator.appspot.com/convert/nt/xml/content',
        data: 'content=<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> .',
        success: function successHandler (data) {
          var reader = new FileReader()
          const output = reader.readAsText(data)
          console.log(output)
        }

      })
    },
    readFileAsString (file) {
      var reader = new FileReader()
      const output = reader.readAsText(file)
      console.log(output)
    }
  }

}
</script>
