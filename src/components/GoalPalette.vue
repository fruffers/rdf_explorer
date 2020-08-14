<template>
    <div id='wrapper'>
        <div id='goal'> <h1>Goal:</h1> <slot></slot> </div>
        <div id='btnWrap'>
            <button id='leftSubmit' class='submit'>Need a hint?</button>
            <button @click="emitAnswer" class='submit'>SUBMIT ANSWER</button>
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
        background-color: #b1d8e7;
        cursor: pointer;
        color: black;
        text-decoration: underline;
    }
    #leftSubmit {
        margin-right: 14%;
    }
    .submit {
        margin-top: 5%;
        padding: 1%;
        background-color: white;
        color: black;
        font-size: 120%;
        transition: 0.6s;
        display: inline-block;
    }
    #goal {
        background-color: #b1d8e7;
        color: black;
        padding: 10%;
        font-size: 120%;
        border-radius: 2px;
        text-align: left;
        box-shadow: 0px 2px 5px 1px rgba(172, 172, 172, 0.2);
    }
    #wrapper {
        padding: 5%;
        padding-top: 0;
    }
    /* #btnWrap {
        padding: 5%;
    } */
</style>
