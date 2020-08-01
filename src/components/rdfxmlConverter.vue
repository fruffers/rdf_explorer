<template>
    <div>
        <div id='rdfxmlWrap'>
        </div>
    </div>
</template>

<script>
import rdf from 'rdf'
export default {
    name: 'converterPalette',
    methods: {
        create () {
            // convert triples inside graph nodes
            // to rdf/xml
            const namednode = new rdf.NamedNode('')
        }
    }

}
</script>