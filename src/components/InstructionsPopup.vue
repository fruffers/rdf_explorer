<template>
    <div class='popupBacksplash'>
        <div class='popupBackground'>
            <div @click='emitPopup' class='popupCloseButton'>&times;</div>
            <p><slot></slot></p>
        </div>
    </div>
</template>

<script>
export default {
  name: 'instructionsPopup',
  methods: {
    emitPopup () {
      this.$emit('popup-emit')
    }
  }
}
</script>
