<template>
    <div :id='color'>
        <p v-html='text'/>
    </div>
</template>

<script>
export default {
  name: 'levelFeedback',
  props: {
    levelCompletion: Object
  },
  data: function () {
    return {
      color: '',
      text: '',
      feedback: [
        { right: 'Well done!', wrong: 'Oops! Try again.' },
        { right: 'Well done!', wrong: 'Oops! Try again.' },
        { right: 'Well done!', wrong: 'Oops! Try again.' },
        { right: 'Well done!', wrong: 'Oops! Try again.' },
        { right: 'Well done!', wrong: 'Oops! Try again.' }
      ]
    }
  },
  watch: {
    levelCompletion: function (change) {
      if (this.levelCompletion.result === 'right') {
        this.color = 'success'
        this.text = this.feedback[this.levelCompletion.levelNo].right
      } else {
        this.color = 'failure'
        this.text = this.feedback[this.levelCompletion.levelNo].wrong
      }
    }
  }
}
</script>

<style scoped>
    #success {
        background-color: palegreen;
        padding: 5%;
        border-radius: 2px;
        margin-right: 5%;
    }
    #failure {
        background-color: palevioletred;
        padding: 5%;
        border-radius: 2px;
        margin-right: 5%;
    }
</style>
