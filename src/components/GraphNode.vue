<template>
  <g
    :transform='svgLocation'
    ref='svgG'
    class='c-svg-g'
  >
  <!--drawing an ellipse with binded values-->
    <ellipse
      :cx='centreX'
      :cy='centreY'
      :rx='radiusX'
      :ry='radiusY'
      class='c-graph-node'
      stroke-width= '2'
      stroke= 'black'
      @click='selectNode'
      id="unactive"
      :indexval='indexNo'
    />
    <text
      class='c-graph-node__label'
      :x='textX'
      :y='textY'
      dominant-baseline='middle'
      text-anchor='middle'
    >
      <tspan>{{ label }}</tspan>
    </text>
  </g>
</template>

<script>
import interact from 'interactjs'

export default {
  name: 'graph-node',

  props: {
    // prop object that we fill up with all
    // the data needed
    // prop is accessible on the component tag
    nodeData: Object,
    indexNo: Number
  },

  data: () => ({
    // ?
    displacement: {
      x: 0,
      y: 0
    }
  }),

  computed: {
    svgLocation () {
      // only need x and y since this is moving the location
      const x = this.nodeData.x + this.displacement.x
      const y = this.nodeData.y + this.displacement.y
      // the ${} allows injecting variables into html
      // translate() is an svg method applied to transform attribute, to move an svg somewhere
      return `translate(${x},${y})`
    },

    // these are cx, cy etc. dimensions of ellipse

    // cx === rx
    // cy === ry

    // values are the same so that the node doesn't change shape when it is being moved
    // since all that needs to be changed is x and y and not the radius because the shape
    // will not change, only move

    centreX () {
      return this.nodeData.w
    },

    centreY () {
      return this.nodeData.h
    },

    radiusX () {
      return this.nodeData.w
    },

    radiusY () {
      return this.nodeData.h
    },

    label () {
      return this.nodeData.label || 'A node with no name'
    },

    textX () {
      return this.nodeData.w
    },

    textY () {
      return this.nodeData.h
    }
  },

  mounted () {
    this.initInteractJs()
  },

  methods: {
    initInteractJs () {
      // these are all methods from interactjs
      const interactive = interact(this.$refs.svgG)
      interactive.draggable({
        origin: 'self',
        inertia: false,
        modifiers: [
          interact.modifiers.restrict({
            restriction: 'parent'
          })
        ],
        // listeners that wait for interactjs
        // event to trigger
        listeners: {
          // objects
          move: this.onElementMove,
          end: this.onElementMoveEnd
        }
      })
    },

    resetDisplacement () {
      this.displacement = {
        x: 0,
        y: 0
      }
    },

    onElementMove (event) {
      // destructuring statement
      // if event = {x0:"somex",y0="somey",h0="someh",u0="someu"}
      // then the statement below will only pick out and assign x0 and y0 to
      // seperate variables

      // these are library properties that belong
      // to interactEvent
      // this is picking them out of the event

      // page x and y coordinates of starting event
      const { x0, y0 } = event

      const { x, y } = event.page

      // difference of start vs end?
      this.displacement = {
        x: x - x0,
        y: y - y0
      }
    },

    onElementMoveEnd (event) {
      // emits a new event 'move'
      // event for parent to handle
      // also passes object of xy,id with it
      this.$emit('move',
        {
          x: this.nodeData.x + this.displacement.x,
          y: this.nodeData.y + this.displacement.y,
          id: this.nodeData.id
        })

      this.resetDisplacement()
    },

    selectNode (event) {
      // emit select event and pass the selected node
      this.$emit('select-node', event)
    }
  }
}
</script>

<style>
.c-svg-g {
  touch-action: none;
}

.c-graph-node {
  fill: #99c;
  /* stroke: #336; */
}

.c-graph-node__label {
  fill: black;
  stroke: black;
}
</style>
