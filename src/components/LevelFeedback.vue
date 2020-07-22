<template>
    <div :id='color'>
        <p :v-html='text'/>
    </div>
</template>

<script>
export default {
  name: 'levelFeedback',
  props: {
    levelCompletion: Array
  },
  data: function () {
    return {
      color: '',
      text: '',
      feedback: [
        { right: 'That\'s correct', wrong: 'That is not correct.' }
      ]
    }
  },
  watch: {
    levelCompletion: function (change) {
      if (this.levelCompletion.result === 'right') {
        this.color = 'success'
        this.text = this.feedback[this.levelCompletion.levelNo]
      }
    }
  }
}
</script>

<style scoped>
    #success {
        background-color: palegreen;
        padding: 10%;
    }
    #failure {
        background-color: palevioletred;
        padding: 10%;
    }
</style>
