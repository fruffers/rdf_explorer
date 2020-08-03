<template>
    <div>
        <div id='rdfxmlWrap'>
        </div>
    </div>
</template>

<script>
import rdfTranslator from 'rdf-translator'
export default {
  name: 'converterPalette',
  methods: {
    convert (input) {
      // convert n-triples to xml/rdf
      const xml = rdfTranslator(input, 'n-triples', 'xml', function (err, data) {
        if (err) { return console.error(err) }
        console.log(data)
        return data
      })
      return xml
    }
  }

}
</script>
