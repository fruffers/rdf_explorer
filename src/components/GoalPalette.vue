<template>
    <div id='wrapper'>
        <div id='goal'> <h1>Goal:</h1> <slot name="goalslot"></slot> </div>
        <div ref='hint' id='hinthidden'> <h1>Hint:</h1> <slot name="hintslot"></slot> </div>
        <div id='btnWrap'>
            <button id='leftSubmit' @click='showHint' class='submit'>Need a hint?</button>
            <button @click="emitAnswer" class='submit'>Submit answer</button>
        </div>

    </div>
</template>

<script>
export default {
  name: 'goalPalette',
  methods: {
    emitAnswer (event) {
      this.$emit('answer')
    },
    showHint (event) {
      if (this.$refs.hint.id === 'hint') {
        this.$refs.hint.id = 'hinthidden'
      } else {
        this.$refs.hint.id = 'hint'
      }
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
        margin-right: 18%;
    }
    .submit {
        margin-top: 5%;
        padding: 1%;
        background-color: white;
        color: black;
        width: 40%;
        font-size: 100%;
        transition: 0.6s;
        display: inline-block;
    }
    #goal {
        background-color: rgb(185, 221, 228);
        color: black;
        padding: 5%;
        font-size: 120%;
        border-radius: 1px;
        text-align: left;
        border-radius: 3px;
        /* border: 3px solid #b1d8e7; */
    }
    #hinthidden {
        display: none;
    }
    #hint {
        background-color: #f38f1c;
        margin-top: 2%;
        color: black;
        padding: 5%;
        font-size: 120%;
        border-radius: 1px;
        text-align: left;
        border-radius: 3px;
    }
    #wrapper {
        padding: 5%;
        padding-top: 0;
    }
</style>
