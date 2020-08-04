<template>
    <g
    :transform='svgLocation'
    >
        <foreignObject
            ref='nodeTooltip'
            @mouseover='activateTooltip'
            :x='textX'
            :y='textY'
            :width='textW'
            :height='textH'>
            <div>
            <span
            ></span>
        </div>
        </foreignObject>
        <foreignObject
            ref='nodeTooltip'
            id='nodeTooltip'
            :x='textX'
            :y='textY + 70'
            :width='textW'
            :height='textH'>
            <div>
            <span ref='test' class='tooltiptext'></span>
        </div>
        </foreignObject>
    </g>
</template>

<script>
// this class allows tooltip to be placed on top of edges
// if first foreignobject span is hovered over this activates
// tooltip
export default {
  name: 'nodeToolTip',
  props: {
    svgLocation: String,
    textX: Number,
    textY: Number,
    textW: Number,
    textH: Number
  },
  mounted () {
  },
  methods: {
    activateTooltip (event) {
      console.log('hover')
      // change tooltip to visible
      var tooltip = this.$refs.test
      tooltip.style.color = 'blue'
    }
  }
}
</script>

<style scoped>
     /* Tooltip container */
.tooltip {
  position: relative;
  height: 400px;
  width: 400px;
  background-color: blue;
  display: inline-block;
  border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
}

/* Tooltip text */
.tooltiptext {
  /* visibility: hidden; */
  width: 120px;
  color: red;
  text-align: center;
  padding: 5px 0;
  border-radius: 6px;

  /* Position the tooltip text */
  /* position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 50%;
  margin-left: -60px; */

  /* Fade in tooltip */
  /* opacity: 0;
  transition: opacity 0.3s; */
}

/* Tooltip arrow */
.tooltip .tooltiptext::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
    background-color: red;
  border-color: #555 transparent transparent transparent;
}

/* Show the tooltip text when you mouse over the tooltip container */
.tooltip:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
  background-color: red;
}

</style>
