<template>
  <g>
    <!--arrow-->
    <marker
      id='arrow'
      viewBox='0 0 10 10'
      refX='5' refY='5'
      markerWidth='6'
      markerHeight='6'
      orient='auto-start-reverse'
    >
      <path d="M 0 0 L 10 5 L 0 10 z" />
    </marker>
    <!--edge-->
    <line
      :x1='startX'
      :y1='startY'
      :x2='endX'
      :y2='endY'
      class='c-graph-edge'
      marker-end='url("#arrow")'
    />
    <!-- <text
      class='edge-label'
      :x='Math.sqrt(endX * startX)'
      :y='Math.sqrt(endY * startY)'
      fill='black'
      text-anchor='middle'
      dominant-baseline='middle'
      >
      {{ startY }}
    </text> -->
    <!--label is connected to line location through startX and endY etc.-->
    <foreignObject :x='Math.sqrt(endX * startX) / 1.1' :y='Math.sqrt(endY * startY)' :width='140' :height='25'>
      <div xmlns="http://www.w3.org/1999/xhtml">
      <input :value='label'>
          </div>
    </foreignObject>

  </g>
</template>

<script>
// edit x and y of text label depending on
// import interact from 'interactjs'
export default {
  name: 'graph-edge',

  // fromnode and tonode are props which are passed down to the child from the parent
  // these props are both node objects
  props: {
    fromNode: {
      type: Object,
      required: true
    },
    toNode: {
      type: Object,
      required: true
    },
    dragNode: Object,
    deleteEdgeBool: Boolean,
    dragDisplacement: Object,
    dragMoveEdges: Array
    // label: Text

  },

  data: () => ({
    // define the handles of the to and from nodes
    // handles are points on the node where the edge can attach to
    fromNodePoints: null,
    toNodePoints: null,
    label: 'predicate'
  }),

  // computed values automatically update reactively
  // these will automatically be fired because they are bound in the template
  computed: {
    startX: {
      get: function () {
        // console.log('test ' + this.fromNode)
        // return this.fromNode.x + this.fromNode.w
        return this.closestHandlePair.fromHandle.x
      },

      set: function (newVal) {
        return newVal
      }

    },

    startY: {
      get: function () {
        // return this.fromNode.y + this.fromNode.h
        return this.closestHandlePair.fromHandle.y
      },

      set: function (newVal) {
        return newVal
      }

    },

    endX: {
      get: function () {
        // return this.toNode.x + this.toNode.w
        return this.closestHandlePair.toHandle.x
      },

      set: function (newVal) {
        return newVal
      }

    },

    endY: {
      get: function () {
        // return this.toNode.y + this.toNode.h
        return this.closestHandlePair.toHandle.y
      },

      set: function (newVal) {
        return newVal
      }

    },

    /* Cartesian product of the from handles and the to handles */
    handlePairs () {
      // fromHandles = {centre{x,y}, handles{{x,y},{x,y}}}
      const fromHandles = this.fromNodePoints.handles
      const toHandles = this.toNodePoints.handles

      const pairs = []
      for (const fromHandle of fromHandles) {
        for (const toHandle of toHandles) {
          pairs.push({ fromHandle, toHandle })
        }
      }

      return pairs
    },

    closestHandlePair () {
      let closestDist = null
      let closestPair = null

      for (const pair of this.handlePairs) {
        const d = this.distance(pair)

        if (!closestPair || d < closestDist) {
          closestDist = d
          closestPair = pair
        }
      }

      return closestPair
    }
  },

  // fire the functions when these variables change
  watch: {

    deleteEdgeBool: {
      handler: function (value) {
        if (value === true) {
          this.deleteEdge()
        }
      }
    },

    // dragDisplacement: {
    //   handler: function (value) {
    //     // add displacement to edge
    //     this.startX += this.displacement.x
    //     this.startY += this.displacement.y
    //   }
    // }

    // dragMoveEdges: {
    //   handler: function (value) {

    //   }
    // }

    // these are the functions that automatically fill fromNodePoints etc.
    // fromNodePoints is filled with handle details of the node passed in as param

    // when new nodes are pushed as props this will activate
    fromNode: {
      handler: function (node) {
        this.fromNodePoints = this.nodePoints(node)
      },
      immediate: true
    },
    toNode: {
      handler: function (node) {
        this.toNodePoints = this.nodePoints(node)
      },
      immediate: true
    }

    // dragDisplacement: {
    //   computeDrag: function (displacement) {
    //     // d = distance

    //     // displacement of start point
    //     var startdx = displacement.x - this.startX
    //     var startdy = displacement.y - this.startY
    //     var startd = Math.sqrt(startdx * startdx + startdy * startdy)

    //     // displacement of end point
    //     var enddx = displacement.x - this.endX
    //     var enddy = displacement.y - this.endY
    //     var endd = Math.sqrt(enddx * enddx + enddy * enddy)

    //     // add the distances to the current values

    //     // emit the distances data to the parent container
    //     // so it can reactively add distances to the current location values through props
    //     this.edgeDragDisplacementHandler(startd, endd)
    //     // this.$emit('edgeDragDisplacementComputed', startd, endd)
    //   }
    // }
  },

  methods: {

    deleteEdge () {
      this.startX = 0
      this.startY = 0
      this.endX = 0
      this.endY = 0
    },

    resetDisplacement () {
      this.displacement = {
        x: 0,
        y: 0
      }
    },

    // here calculate the handles around the edges of the node so as to attach edges to them
    // handles
    nodePoints (node) {
      if (!node) {
        return {}
      }

      // // rect node
      // rect only uses w and h
      // if (node.type === 'object') {

      // }
      return {
        handles: [
          { x: node.x + node.w / 2, y: node.y + node.h }, // south
          { x: node.x + node.w, y: node.y + node.h / 2 }, // east
          { x: node.x + node.w / 100, y: node.y + node.h / 2 }, // west
          { x: node.x + node.w / 2, y: node.y + node.h / 20 } // south
        ]
      }

      // to get the centre of the rect / w by 2

      // ellipse node
      // return {
      //   handles: [
      //     { x: node.x + node.w, y: node.y }, // north
      //     { x: node.x + node.w * 2, y: node.y + node.h }, // east
      //     { x: node.x + node.w, y: node.y + node.h * 2 }, // south
      //     { x: node.x, y: node.y + node.h } // west
      //   ]
      // }
    },

    /* Pythagorean distance between two points */
    distance ({ fromHandle, toHandle }) {
      const dx = fromHandle.x - toHandle.x
      const dy = fromHandle.y - toHandle.y

      return Math.sqrt(dx * dx + dy * dy)
    }
  }

}
</script>

<style>
.c-graph-edge {
  stroke: black;
}
</style>
