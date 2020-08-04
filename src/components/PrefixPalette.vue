<template>
    <div id='wrapper'>
        <h3>Add prefixes</h3>
        name
        <input class='input' id='name'/>
        URI
        <input class='input' id='uri'/>
        <button id='enter' @click='emitPrefix'>add</button>
        <ul id='prefixList' v-for='prefix in prefixes' :key= 'prefix.index'>
            <li>{{prefix.name}}   {{prefix.uri}}</li>
            <br/>
        </ul>
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
    padding: 2%;
    margin-bottom: 20%;
    text-align: left;
    overflow-wrap:break-word;
  }

  li {
    list-style-type: none;
    float: left;
  }

  h3 {
    line-height: 1%;
  }
</style>
