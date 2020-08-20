<template>
    <div id='wrapper'>
        <h3>Add prefixes</h3>
        name
        <input class='inputBox' id='name'/>
        URI
        <input class='inputBox' id='uri'/>
        <button id='enter' @click='emitPrefix'>add</button>
        <div id='prefixList' v-for='prefix in prefixes' :key= 'prefix.index'>
            <p>{{prefix.name}}   {{prefix.uri}}</p>
            <br/>
        </div>
    </div>
</template>

<script>
export default {
  name: 'prefixPalette',
  data () {
    return {
      name: null,
      uri: null
    }
  },
  props: {
    prefixes: Array // {name, value}
  },

  methods: {
    emitPrefix (event) {
      // store vals
      this.name = document.getElementById('name').value
      this.uri = document.getElementById('uri').value

      this.$emit('store-prefix', this.name, this.uri)
    }
  }
}
</script>

<style scoped>
  #wrapper {
    padding: 10%;
    text-align: left;
    overflow-wrap:break-word;
  }

  li {
    list-style-type: none;
    padding: 0;
    margin: 0;
  }
</style>
