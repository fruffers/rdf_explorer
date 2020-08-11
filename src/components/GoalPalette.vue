<template>
    <div id='wrapper'>
        <div id='goal'> Goal: <slot></slot> </div>
        <div id='btnWrap'>
            <button @click="emitAnswer" id='submit'>SUBMIT ANSWER</button>
        </div>

    </div>
</template>

<script>
export default {
  name: 'goalPalette',
  methods: {
    emitAnswer (event) {
      this.$emit('answer')
    }
  }
}
</script>

<style scoped>
    #submit:hover {
        background-color: white;
        cursor: pointer;
        color: black;
        text-decoration: underline;
    }
    #submit {
        margin-top: 5%;
        padding: 5%;
        background-color: #79C5C4;
        color: black;
        font-size: 120%;
        transition: 0.6s;
    }
    #goal {
        background-color: rgb(167, 221, 199);
        color: black;
        padding: 10%;
        font-size: 120%;
        border-radius: 10px;
    }
    #wrapper {
        padding: 5%;
    }
</style>
