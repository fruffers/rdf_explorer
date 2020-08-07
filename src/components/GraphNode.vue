<template>
  <g
    :transform='svgLocation'
    ref='svgG'
    class='c-svg-g'
  >
  <!--drawing an ellipse with binded values-->
    <rect
      :width='centreX'
      :height='centreY'
      rx='500'
      class='ellipse'
      stroke-width= '2'
      stroke= 'black'
      @click='selectNode'
      @dblclick='drawEdge'
      id='unactive'
      :indexval='indexNo'
      ref='subject'
    />

    <rect
    class='rect'
    :width='rectX'
    :height='rectY'
    rx='10'
    @click='selectNode'
    @dblclick='drawEdge'
    :indexval='indexNo'
    ref='object'
    id='unactive'
    style='fill: lightblue; stroke-width: 2px; stroke: black;'
    />

    <foreignObject
    ref='nodeLabel'
    :width='textW'
    :height='textH'
    :x='textX'
    :y='textY'>
      <div xmlns="http://www.w3.org/1999/xhtml">
      <input
      :value='label'
      @input='labelEmit'>
      </div>
    </foreignObject>

  </g>
</template>

<script>
import interact from 'interactjs'

export default {
  name: 'graph-node',

  components: {
  },

  props: {
    nodeData: {
      type: Object,
      required: true
    },
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
    // due to being computed this will automatically detect changes in any of the dependencies inside
    // so when the node is dragged and displacement is updated then this will fire again
    svgLocation () {
      // only need x and y since this is moving the location
      const x = this.nodeData.x + this.nodeData.displacement.x
      const y = this.nodeData.y + this.nodeData.displacement.y
      return `translate(${x} ${y})`
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

    // cx, cy etc. dimensions of ellipse
    // centre values control where centre of node is
    centreX () {
      return this.supressObject(this.nodeData.w)
    },

    centreY () {
      return this.supressObject(this.nodeData.h)
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
        return this.nodeData.w / 8
      } else {
        return this.nodeData.w / 25
      }
    },

    textY () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.h / 3
      } else {
        return this.nodeData.h / 4
      }
    },

    textW () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.w / 1.6
      } else {
        return this.nodeData.w / 1.4
      }
    },

    textH () {
      if (this.nodeData.type === 'subject') {
        return this.nodeData.h / 3
      } else {
        return this.nodeData.h / 2
      }
    }
  },

  mounted () {
    // execute on document load. sendlocinfo is for the tooltips
    this.initInteractJs()
    // this.sendLocationInfo()
  },

  methods: {

    // sendLocationInfo () {
    //   // send location information to parent then tooltip component
    //   const locInfo = { textX: this.textX, textY: this.textY, textW: this.textW, textH: this.textH, svgLocation: this.svgLocation }
    //   this.$emit('emit-loc', locInfo, this.nodeData.id)
    // },

    supressObject (changeVal) {
      // object is rectangular node. This makes it flat/invisible
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
        origin: 'self',
        inertia: true, // throw nodes
        // object containing listeners that wait for interactjs
        // event to trigger
        modifiers: {
          restriction: self,
          endOnly: true
        },
        listeners: {
          move: this.onElementMove,
          end: this.onElementMoveEnd
        }
      })
      interactive.resizable({
        // these edges are too far in so replace them with
        // some handle elements later
        edges: { left: true, right: true, bottom: true, top: true },
        // listeners objects which are predefined in library
        listeners: {
          move: this.resizeMove,
          end: this.resizeMoveEnd
        },
        modifiers: [
          interact.modifiers.restrictSize(
            {
              min: { width: 50, height: this.minHeight() }
              // max: { width: 500, height: 25 }
            }
          )
        ]
      })
    },

    minHeight () {
      if (this.nodeData.type === 'subject') {
        return 70
      } else {
        return 50
      }
    },

    resizeMove (event) {
      const nodeId = this.nodeData.id

      let x = this.nodeData.x
      let y = this.nodeData.y

      // change width and height to new dimensions
      const newWidth = event.rect.width
      const newHeight = event.rect.height

      // change nodeData and nodeData displacement through
      // an emit

      // translate the shape location after resize
      // apply displacement
      x += event.deltaRect.left
      y += event.deltaRect.top

      this.$emit('resize-node', nodeId, newWidth, newHeight, x, y)
      // this.sendLocationInfo()
      // apply translation delta from deltarect
    },

    resizeMoveEnd (event) {
      this.$emit('resize-end')
    },

    onElementMove (event) {
      // calculating displacement during drag of mouse and node

      // destructuring statement
      // if event = {x0:"somex",y0="somey",h0="someh",u0="someu"}
      // then the statement below will only pick out and assign x0 and y0 to
      // seperate constiables

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
      this.sendLocationInfo()
    },

    selectNode (event) {
      // emit select event and pass the selected node
      this.$emit('select-node', event)
    },

    drawEdge (event) {
      const node = this.nodeData
      const stage = 'select'
      this.$emit('draw-edge', node, stage)
    },

    labelEmit (event) {
      // change the node label via input, passes whole value
      this.$emit('label-input', this.nodeData.id, event.target.value)
    }
  }
}
</script>

<style>
.c-svg-g {
  touch-action: none;
}

.rect {
  fill: #67c7c6;
}

.ellipse {
  fill: #99c;
}
</style>
