<template>
    <div>
        <div id='goal'> Goal: <slot></slot> </div>
        <div id='btnWrap'>
            <button id='submit'>SUBMIT ANSWER</button>
        </div>

    </div>
</template>

<script>
export default {
  name: 'goalPalette'
}
</script>

<style scoped>
    #submit:hover {
        background-color: #67c7c6;
        cursor: pointer;
        color: black;
        text-decoration: underline;
    }
    #submit {
        margin-top: 5%;
        padding: 5%;
        background-color: #001c39;
        color: white;
        font-size: 120%;
        border: 4px solid white;
    }
    #goal {
        background-color: #9ec1ee;
        padding: 10%;
    }
</style>
