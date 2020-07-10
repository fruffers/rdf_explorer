<template>
  <g
    :transform='svgLocation'
    ref='svgG'
    class='c-svg-g'
  >
  <!--drawing an ellipse with binded values-->
  <!-- <test-child></test-child> -->
    <ellipse
      :cx='centreX'
      :cy='centreY'
      :rx='radiusX'
      :ry='radiusY'
      class='c-graph-node'
      stroke-width= '2'
      stroke= 'black'
      @click='selectNode'
      @dblclick='drawEdge'
      id='unactive'
      :indexval='indexNo'
      ref='subject'
    />

    <rect
    :width='rectX'
    :height='rectY'
    @click='selectNode'
    @dblclick='drawEdge'
    :indexval='indexNo'
    ref='object'
    id='unactive'
    style='fill: lightblue; stroke-width: 2px; stroke: black;'
    />

    <foreignObject
    ref='nodeLabel'
    :x='textX'
    :y='textY'
    :width='textW'
    :height='textH'>
      <div xmlns="http://www.w3.org/1999/xhtml">
      <input
      :value='label'
      @input='labelEmit'>
      </div>
    </foreignObject>

    <!-- <text
    contenteditable='true'
      class='c-graph-node__label'
      :x='textX'
      :y='textY'
      dominant-baseline='middle'
      text-anchor='middle'

    >
      {{ label}}
    </text> -->
  </g>
</template>

<script>
import interact from 'interactjs'
// import testChild from './testDragChild.vue'

export default {
  name: 'graph-node',

  components: {
    // testChild
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
    },
    nodeType: ''
  }),

  computed: {

    // rectActive () {
    //   if (this.nodeData.type === 'object') {
    //     this.nodeType = 'object'
    //     // var wCopy = this.nodeData.w
    //     // var hCopy = this.nodeData.h
    //     // hide all
    //     // this.flattenEllipse()

    //     // show rect
    //     return { w: this.nodeData.w, h: this.nodeData.h }
    //   } else {
    //     // flatten rect so it doesn't appear
    //     return { w: 0, h: 0 }
    //   }
    // },

    // this controls the location for g group
    // so a transform is applied to the initial node location
    // moves the node

    // due to being computed this will automatically detect changes in any of the dependencies inside
    // so when the node is dragged and displacement is updated then this will fire again
    svgLocation () {
      // only need x and y since this is moving the location
      const x = this.nodeData.x + this.displacement.x
      const y = this.nodeData.y + this.displacement.y
      // the ${} allows injecting variables into html
      // translate() is an svg method applied to transform attribute, to move an svg somewhere
      return `translate(${x},${y})`
    },

    rectX () {
      if (this.nodeData.type === 'object') {
        return this.nodeData.w
      } else {
        return 0
      }
    },
    rectY () {
      if (this.nodeData.type === 'object') {
        return this.nodeData.h
      } else {
        return 0
      }
    },

    // these are cx, cy etc. dimensions of ellipse

    // cx === rx
    // cy === ry

    // rpoblem: computed nodeData.label is always reverting back
    // to the old label > you can emit it and change it in parent?

    // centre values control where centre of node is
    centreX: {
      get: function () {
        return this.supressObject(this.nodeData.w)
        // return this.nodeData.w
      },

      set: function (newVal) {
        return newVal
      }

    },

    centreY: {
      get: function () {
        // return this.nodeData.h
        return this.supressObject(this.nodeData.h)
      },

      set: function (newVal) {
        return newVal
      }

    },

    // radius values control the size of the node (and thus never change)
    radiusX: {
      get: function () {
        return this.supressObject(this.nodeData.w)
        // return this.nodeData.w
      },

      set: function (newVal) {
        return newVal
      }

    },

    radiusY: {
      get: function () {
        return this.supressObject(this.nodeData.h)
        // return this.nodeData.h
      },

      set: function (newVal) {
        return this.newVal
      }

    },

    label: {
      get: function () {
        return this.nodeData.label || ' '
      },

      set: function (newVal) {
        return newVal
      }

    },

    textX () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.w / 3.6
      } else {
        return this.nodeData.w / 25
      }
    },

    textY () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.h / 2
      } else {
        return this.nodeData.h / 4
      }
    },

    textW () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.w * 1.4
      } else {
        return this.nodeData.w / 1.1
      }
    },

    textH () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.h
      } else {
        return this.nodeData.h / 2
      }
    }
  },

  mounted () {
    this.initInteractJs()
  },

  methods: {

    supressObject (changeVal) {
      if (this.nodeData.type === 'object') {
        return 0
      } else {
        return changeVal
      }
    },

    initInteractJs () {
      // these are all methods from interactjs
      const interactive = interact(this.$refs.svgG)
      interactive.draggable({
        inertia: true, // throw nodes
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

      // all of this is calculated during the drag
      // so reactive elements must be attached to these values
      // otherwise they will only move at the end

      // hook edge up in here to be reactive

      // page x and y coordinates of starting event
      const { x0, y0 } = event
      // end of mouse move
      const { x, y } = event.page

      // difference of start vs end
      // displacement is reactive data

      // local drag changes that are not permament due to no link to parent datastore
      this.displacement = {
        x: x - x0,
        y: y - y0
      }

      // need to reattach edge during drag so
      // when the node is locally changing its svg location
      // therefore put an emit event in svg location compute?
      this.$emit('drag-displacement-pass', {
        displacement: {
          x: x - x0,
          y: y - y0
        }
      })

      // this.$emit('drag-node', this.nodeData, this.displacement)
    },

    onElementMoveEnd (event) {
      // emits a new event 'move'
      // event for parent to handle
      // also passes object of xy,id with it

      var passNodeData
      passNodeData = {
        x: this.nodeData.x + this.displacement.x,
        y: this.nodeData.y + this.displacement.y,
        id: this.nodeData.id
      }
      // move to a new position when that new position is held
      // the node is grabbed
      // place the node on the canvas permamently by changing the parent node's datastore
      this.$emit('move', passNodeData)
      // reset displacement after node has moved into new position
      this.resetDisplacement()
    },

    selectNode (event) {
      // emit select event and pass the selected node
      this.$emit('select-node', event)
    },

    drawEdge (event) {
      var node = this.nodeData
      var stage = 'select'
      this.$emit('draw-edge', node, stage)
    },

    labelEmit (event) {
      // change the node label via input, passes 1 char at a time
      this.$emit('label-input', this.nodeData.id, event.data)
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
