<template>
  <g
    :transform='svgLocation'
    ref='svgG'
    class='c-svg-g'
  >
  <!--drawing an ellipse with binded values-->
  <graph-edge></graph-edge>
  <test-child></test-child>
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
      ref='node'
    />

    <foreignObject :x='centreX/2' :y='centreY/1.5' :width='radiusX' :height='radiusY'>
      <div xmlns="http://www.w3.org/1999/xhtml">
      <input :value='label'>
          </div>
  </foreignObject>
    <!-- <input type='text'> -->
    <text
    contenteditable='true'
      class='c-graph-node__label'
      :x='textX'
      :y='textY'
      dominant-baseline='middle'
      text-anchor='middle'
      @click='drawEdge'
    >
      <!-- {{ label}} -->
    </text>
  </g>
</template>

<script>
import interact from 'interactjs'

import graphEdge from './GraphEdge.vue'
import testChild from './testDragChild.vue'

export default {
  name: 'graph-node',

  components: {
    testChild,
    graphEdge
  },

  props: {
    // prop object that we fill up with all
    // the data needed
    // prop is accessible on the component tag
    nodeData: Object,
    indexNo: Number
  },

  data: () => ({
    displacement: {
      x: 0,
      y: 0
    }
  }),

  computed: {
    // this controls the location for g group
    // so a transform is applied to the initial node location
    // moves the node
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

    // centre values control where centre of node is
    centreX () {
      return this.nodeData.w
    },

    centreY () {
      return this.nodeData.h
    },

    // radius values control the size of the node (and thus never change)
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
      // end of mouse move
      const { x, y } = event.page

      // difference of start vs end
      // displacement is reactive data
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
    },

    drawEdge (event) {
      var node = this.$refs.node
      this.$emit('draw-edge', event, node)
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

/* .c-graph-node__label {

} */
</style>
