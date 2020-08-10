<template>
    <div>
        <button
        @click='fetchNtriples'
        >
        Convert to RDF XML</button>
        <div id='conversionWrap'>
            {{conversion}}
        </div>
    </div>
</template>

<script>
import jquery from 'jquery'

export default {
  name: 'converterPalette',
  props: {
    triples: String
  },
  data: () => ({
    conversion: ''
  }),
  methods: {
    fetchNtriples () {
      this.$emit('fetch-triples')
      this.convertTypes(this.triples)
    },
    convertTypes (input, convertType) {
      // convert N-triples to other syntaxes

      // use API http://rdf-translator.appspot.com/
      var self = this
      // make sure to have global this identifiable inside internal function

      // send to API post
      jquery.ajax({
        type: 'POST',
        url: `http://rdf-translator.appspot.com/convert/nt/${convertType}/content`,
        data: input,
        dataType: 'text',
        success: function (file) {
          self.updateText(file, convertType)
        }
      })
    },
    updateText (data, convertType) {
      this.conversion = data
    }

  }

}
</script>
