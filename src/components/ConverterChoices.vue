<template>
    <div>
      <div class='buttonHold' v-for='(ctype, index) in conversionTypes' :key='index'>
          <button
          @click='fetchNtriples(ctype)'
          >
          {{ctype}}</button>
      </div>
      <a id='wrapper'>
        <button @click='emitConvert'>Ntriples</button>
      </a>
      <textarea id='outputarea' v-model= 'conversion[currentType]' readonly>
      </textarea>
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
    conversion: { xml: '', jsonld: '', n3: '', triples: '' },
    currentType: '',
    ntripHTML: ''
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
      this.currentType = convertType
      this.conversion[convertType] = data
    },

    emitConvert (event) {
      this.$emit('ntriples-convert')
      this.currentType = 'triples'
      this.conversion.triples = this.triples
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
  .buttonHold {
  text-align: left;
  display: inline-block;
  overflow-wrap:break-word;
  padding-top: 0;
  }
  button {
    width: 80px;
  }
  #outputarea {
    width: 90%;
    height: 100vh;
    border: 2px solid black;
  }
</style>
