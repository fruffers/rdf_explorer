<template>
    <div>
        <div id='pal' v-for='(level,index) in levels' :key='index'>
            <button @click='levelChangeEmit'> Level {{level.no}} </button>
        </div>
    </div>
</template>

<script>
export default {
  name: 'levelButtons',
  props: {
    levels: Array
  }
}
</script>
<style scoped>
    #pal {
        padding: 2%;
        padding-bottom: 0;
        margin-right: 80%;
    }
    button {
        padding: 5%;
    }
</style>
