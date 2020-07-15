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

export default {
  name: 'graph-node',

  components: {
  },

  props: {
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

    // this controls the location for g group
    // so a transform is applied to the initial node location
    // moves the node

    // due to being computed this will automatically detect changes in any of the dependencies inside
    // so when the node is dragged and displacement is updated then this will fire again
    svgLocation () {
      // only need x and y since this is moving the location
      const x = this.nodeData.x + this.nodeData.displacement.x
      const y = this.nodeData.y + this.nodeData.displacement.y
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

    // radius values control the size of the node
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
    // run these functions on document load
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
        autoScroll: true,
        // object containing listeners that wait for interactjs
        // event to trigger
        listeners: {
          move: this.onElementMove,
          end: this.onElementMoveEnd
        }
      })
      interactive.resizable({
        // these edges are too far in so replace them with
        // some handle elements later
        edges: { left: true, right: true, bottom: true, top: true },
        // listeners object
        listeners: {
          move: this.resizeMove
        }
        // modifiers: [
        //   interactive.modifiers.restrictEdges({
        //     outer: 'parent'
        //   }),
        //   interactive.modifiers.restrictSize({
        //     min: { width: 100, height: 50 }
        //   })
        // ]
      })
    },

    resizeMove (event) {
      // get x and y of event, where the mouse has grabbed
      console.log('event only ', event)
      // var target = event.target

      // target = rect

      var nodeId = this.nodeData.id

      // deltarect applied to transform to translate it
      // into the right place

      var x = this.nodeData.x
      var y = this.nodeData.y

      // change to new dimensions
      var newWidth = event.rect.width
      var newHeight = event.rect.height

      // change nodeData and nodeData displacement through
      // an emit

      // translate the shape location after resize
      // apply displacement
      x += event.deltaRect.left
      y += event.deltaRect.top

      this.$emit('resize-node', nodeId, newWidth, newHeight, x, y)
      // apply translation delta from deltarect

      // update width and height of svg using the event
      // grab resize handle
      // need to use the transform x and y of the g class
      // also need to change g.node width and height
      // and pass it to parent
      console.log('event target', event.target)
    },

    // resetDisplacement () {
    //   this.displacement = {
    //     x: 0,
    //     y: 0
    //   }
    // },

    onElementMove (event) {
      // calculating displacement during drag of mouse and node

      // destructuring statement
      // if event = {x0:"somex",y0="somey",h0="someh",u0="someu"}
      // then the statement below will only pick out and assign x0 and y0 to
      // seperate variables

      // page x and y coordinates of starting event
      const { x0, y0 } = event
      // end of mouse move
      const { x, y } = event.page

      this.$emit('move',
        {
          x: x - x0,
          y: y - y0,
          id: this.nodeData.id
        }
      )
    },

    onElementMoveEnd (event) {
      this.$emit('move-end', { id: this.nodeData.id })
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
