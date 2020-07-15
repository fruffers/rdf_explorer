<template>
    <div>
        <div id='goal'> <slot></slot> </div>
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
        padding: 5%;
        background-color: lightblue;
        color: black;
        font-size: 120%;
        border-radius: 5%;
    }
</style>
