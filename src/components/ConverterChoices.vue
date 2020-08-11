<template>
    <div>
      <div v-for='(ctype, index) in conversionTypes' :key='index'>
          <button
          @click='fetchNtriples(ctype)'
          >
          Convert to {{ctype}}</button>
          <div id='conversionWrap'>
              {{conversion[ctype]}}
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
    conversion: { xml: '', jsonld: '', n3: '' }
  }),
  methods: {
    fetchNtriples (convertType) {
      this.$emit('fetch-triples')
      this.convertTypes(this.triples, convertType)
    },
    convertTypes (input, convertType) {
      // convert N-triples to other syntaxes
      // use API http://rdf-translator.appspot.com/

      if (convertType === 'jsonld') {
        convertType = 'json-ld'
      }

      // add 'content=' to let api recognise data
      input = 'content=' + input

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
      if (convertType === 'json-ld') {
        convertType = 'jsonld'
      }
      this.conversion[convertType] = data
    }

  }

}
</script>
