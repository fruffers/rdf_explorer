<template>
    <div>
        <div id='goal'> Goal: <slot></slot> </div>
        <button id='submit'>Submit Answer</button>

    </div>
</template>

<script>
export default {
  name: 'goalPalette'
}
</script>

<style scoped>
    #submit:hover {
        background-color: coral;
        cursor: pointer;
    }
    #submit {
        margin-top: 5%;
        padding: 5%;
        background-color: lightblue;
        color: black;
        font-size: 120%;
        border-radius: 5%;
    }
    #goal {
        background-color: palegreen;
        padding: 20%;
    }
</style>
