<template>
    <div id='wrapper'>
        <div id='goal'> <h1>Goal:</h1> <slot></slot> </div>
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
        box-shadow: 0px 2px 5px 1px rgba(172, 172, 172, 0.2);
    }
    #wrapper {
        padding: 5%;
    }
</style>
