<template>
    <div id='wrapper'>
        <a ref='levelButtons' id='pal' v-for='(level,index) in levels' :key='index'>
            <button @click='levelChangeEmit'> Level <a ref='levelCount' id='levelPickBtn'>{{parseInt(level.no)}}</a> </button>
        </a>
    </div>
</template>

<script>
export default {
  name: 'levelButtons',
  props: {
    levels: Array,
    completedLevels: Array
  },
  watch: {
    completedLevels: function () {
      this.levelUnlocks()
    }
  },
  mounted () {
    this.levelUnlocks()
  },
  methods: {
    levelUnlocks () {
      for (let level = 0; level < this.levels.length; level++) {
        if (this.completedLevels.includes(level + 1)) {
          this.$refs.levelButtons[level].childNodes[0].style.backgroundColor = 'palegreen'
        } else {
          this.$refs.levelButtons[level].childNodes[0].style.backgroundColor = 'palevioletred'
        }
      }
    },
    levelChangeEmit (event) {
      // give level change number
      // console.dir(event.currentTarget, { depth: null })
      const levelCount = event.currentTarget.lastElementChild.innerText
      if (this.completedLevels.includes(parseInt(levelCount))) {
        this.$emit('levelPick', levelCount)
      }
    }
  }
}
</script>
<style scoped>

</style>
