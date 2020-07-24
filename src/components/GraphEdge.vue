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
      stroke-width = '1.7'
      @dblclick='removeEdgeEmit'
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
        <input
        :value='edgeLabel'
        @input='edgeLabelEmit'>
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
    edgeLabel: String,
    edgeIndex: Number,
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
    // startX calculates where the x start position of line is on fromnode
    // by getting the closest handle on the opposite tonode
    startX: {
      get: function () {
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

    // edgeLabel: {
    //   get: function () {
    //     return this.edgeLabel || ' '
    //   }
    // },

    /* Cartesian product of the from handles and the to handles */
    handlePairs () {
      // fromHandles = {centre{x,y}, handles{{x,y},{x,y}}}
      const fromHandles = this.fromNodePoints.handles
      const toHandles = this.toNodePoints.handles

      // returns pairs of all handles cartesian, with one from and one to
      // {to,from} for every so {n, n}, {n, e}, {n, s}, {n, w} and so forth
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

      // x and y positions with displacement added
      const x = node.x + node.displacement.x
      const y = node.y + node.displacement.y

      // decide whether handles are needed for rect or for ellipse

      if (node.type === 'object') {
        // rect handles
        return {
          handles: [
            { x: x + node.w / 2, y: y + node.h }, // south
            { x: x + node.w, y: y + node.h / 2 }, // east
            { x: x + node.w / 100, y: y + node.h / 2 }, // west
            { x: x + node.w / 2, y: y + node.h / 200 } // north
          ]
        }
      } else {
        // ellipse handles
        // given x
        // var givenx = x
        // var y1 = (node.h) * Math.sqrt((1 + (4 * (givenx ** 2))) / ((node.w) ** 2))
        // use outer rect bounds to cut diagonal lines
        // through ellipse and get points at intersections on
        // ellipse circumference
        // get rect bounds
        // var north = { x: x + node.w, y: y }
        // var east = { x: x + node.w * 2, y: y + node.h }
        // var south = { x: x + node.w, y: y + node.h * 2 }
        // var west = { x: x, y: y + node.h }

        var nwX = (node.w + x) + (node.w * Math.cos(10))
        var nwY = (node.h + y) + (node.h * Math.sin(10))
        var neX = (node.w + x) + (node.w * Math.cos(100))
        var neY = (node.h + y) + (node.h * Math.sin(10))
        var swX = (node.w + x) + (node.w * Math.cos(-10))
        var swY = (node.h + y) + (node.h * Math.sin(-10))
        var seX = (node.w + x) + (node.w * Math.cos(-100))
        var seY = (node.h + y) + (node.h * Math.sin(-10))

        // var t1 = { x: west.x, y: north.y }
        // var t2 = { x: east.x, y: north.y }
        // var b1 = { x: west.x, y: south.y }
        // var b2 = { x: east.x, y: south.y }

        // var a = node.w / 2
        // var b = node.h / 2
        // // length to focis
        // var c = Math.sqrt((a * a) - (b * b))
        // var center = { x: t1.x + node.w / 2, y: t1.y + node.h / 2 }
        // var center = { x: x + node.w, y: y + node.h }
        // var lfx = center.x - c
        // var rfx = center.x + c
        // var leftFoci = { x: lfx, y: center.y }
        // var rightFoci = { x: rfx, y: center.y }

        // var longestLen = x + node.w * 2

        // var onePart = longestLen / 4

        // var xnw = ((t1.x) ** 2) / (center.x)
        // var ynw = ((t1.y) ** 2) / (center.y)

        // how to get points using the foci?
        // the width to the two foci has to equal longest len

        // console.log('center' + center.x)
        // console.log('left foci' + leftFoci.x)
        // console.log('right foci ' + rightFoci.x)
        // console.log('width ' + longestLen)

        // distance from (-c,0) to (x,y) where (x,y) is point and (-c,0) is left foci
        // var d1 = 0
        // distance from right foci to point
        // var d2 = 0

        // set of all points on the coordinate system
        // var boundBox = []
        // var x1 = 0
        // var y1 = 0
        // make bounding box around ellipse to pick points from
        // ranges from x+y to (x+y)*2
        // ranges from

        // var diagPoints = [{ x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 }]

        // diagPoints.forEach((p, i) => {
        //   var t = Math.tan(i * Math.PI / 4 + Math.atan(2 * b / a) / 2)
        //   var px = a * (1 - t ** 2) / (1 + t ** 2)
        //   var py = b * 2 * t / (1 + t ** 2)
        //   // console.log('px ' + px)
        //   p.x = px
        //   p.y = py
        // })

        // var ellipsePointSet = []
        // var count = 0

        // sum of distance must equal width

        return {
          handles: [
            { x: neX, y: neY },
            { x: seX, y: seY },
            { x: nwX, y: nwY },
            { x: swX, y: swY },
            { x: x + node.w, y: y }, // north
            { x: x + node.w * 2, y: y + node.h }, // east
            { x: x + node.w, y: y + node.h * 2 }, // south
            { x: x, y: y + node.h } // west
          ]
        }
      }

      // to get the centre of the width of rect / w by 2
    },

    /* Pythagorean distance between two points */
    distance ({ fromHandle, toHandle }) {
      const dx = fromHandle.x - toHandle.x
      const dy = fromHandle.y - toHandle.y

      // returns distance between handle sets
      return Math.sqrt(dx * dx + dy * dy)
    },

    edgeLabelEmit (event) {
      // edge labels are stored in edges array
      this.$emit('label-input', this.edgeIndex, event.data)
    },

    removeEdgeEmit (event) {
      this.$emit('remove-edge', this.edgeIndex)
    }
  }

}
</script>

<style>
.c-graph-edge {
  stroke: black;
}
</style>
