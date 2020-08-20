<template>
    <div>
        <p v-for='(onto, index) in coreOntro' :key='index'>

        </p>
    </div>
</template>

<script>
export default {
  name: 'coreOntoTerms',
  props: {
    ontoTerms: Array
  }

}
</script>
