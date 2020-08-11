<template>
    <div>
      <div v-for='(ctype, index) in conversionTypes' :key='index'>
          <button
          @click='fetchNtriples(ctype)'
          >
          Convert to {{ctype}}</button>
          <div id='conversionWrap'>
              {{conversion}}
          </div>
      </div>
    </div>
</template>

<script>
import jquery from 'jquery'

export default {
  name: 'converterPalette',
  props: {
    triples: String,
    conversionTypes: Object
  },
  data: () => ({
    conversion: ''
  }),
  methods: {
    fetchNtriples (convertType) {
      this.$emit('fetch-triples')
      this.convertTypes(this.triples, convertType)
    },
    convertTypes (input, convertType) {
      // convert N-triples to other syntaxes
      console.log('input' + input)

      // add 'content=' to let api recognise data
      // input = '<https://schema.org/foaf:Person> <https://schema.org/foaf:firstName> "Bethany" .\n <https://schema.org/foaf:Person> <https://schema.org/foaf:birthday> "07/08/2020" .'

      input = 'content=' + input

      // use API http://rdf-translator.appspot.com/
      var self = this
      // make sure to have global this identifiable inside internal function

      // post to API
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
