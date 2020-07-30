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

  // fire the functions when these constiables change
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
            { x: x + node.w / 2, y: y + node.h / 200 }, // north
            { x: x + node.w / 2 * 1.7, y: y + node.h }, // se
            { x: x + node.w / 2 / 4, y: y + node.h }, // sw
            { x: x + node.w / 2 / 5, y: y + node.h / 200 }, // nw
            { x: x + node.w / 2 * 1.7, y: y + node.h / 200 } // ne
          ]
        }
      } else {
        // ellipse handles
        // given x
        // const givenx = x
        // const y1 = (node.h) * Math.sqrt((1 + (4 * (givenx ** 2))) / ((node.w) ** 2))
        // use outer rect bounds to cut diagonal lines
        // through ellipse and get points at intersections on
        // ellipse circumference
        // get rect bounds
        // const north = { x: x + node.w, y: y }
        // const east = { x: x + node.w * 2, y: y + node.h }
        // const south = { x: x + node.w, y: y + node.h * 2 }
        // const west = { x: x, y: y + node.h }

        // https://stackoverflow.com/questions/9411861/how-do-i-calculate-a-point-on-a-ellipse-s-circumference
        // use angle to find handles
        const nwX = (node.w + x) + (node.w * Math.cos(10))
        const nwY = (node.h + y) + (node.h * Math.sin(10))
        const neX = (node.w + x) + (node.w * Math.cos(100))
        const neY = (node.h + y) + (node.h * Math.sin(10))
        const swX = (node.w + x) + (node.w * Math.cos(-10))
        const swY = (node.h + y) + (node.h * Math.sin(-10))
        const seX = (node.w + x) + (node.w * Math.cos(-100))
        const seY = (node.h + y) + (node.h * Math.sin(-10))

        const swX2 = (node.w + x) + (node.w * Math.cos(130))
        const swY2 = (node.h + y) + (node.h * Math.sin(30))
        const nwX2 = (node.w + x) + (node.w * Math.cos(130))
        const nwY2 = (node.h + y) + (node.h * Math.sin(-30))
        const neX2 = (node.w + x) + (node.w * Math.cos(-200))
        const neY2 = (node.h + y) + (node.h * Math.sin(200))
        const seX2 = (node.w + x) + (node.w * Math.cos(200))
        const seY2 = (node.h + y) + (node.h * Math.sin(800))

        // const t1 = { x: west.x, y: north.y }
        // const t2 = { x: east.x, y: north.y }
        // const b1 = { x: west.x, y: south.y }
        // const b2 = { x: east.x, y: south.y }

        // const a = node.w / 2
        // const b = node.h / 2
        // // length to focis
        // const c = Math.sqrt((a * a) - (b * b))
        // const center = { x: t1.x + node.w / 2, y: t1.y + node.h / 2 }
        // const center = { x: x + node.w, y: y + node.h }
        // const lfx = center.x - c
        // const rfx = center.x + c
        // const leftFoci = { x: lfx, y: center.y }
        // const rightFoci = { x: rfx, y: center.y }

        // const longestLen = x + node.w * 2

        // const onePart = longestLen / 4

        // const xnw = ((t1.x) ** 2) / (center.x)
        // const ynw = ((t1.y) ** 2) / (center.y)

        // how to get points using the foci?
        // the width to the two foci has to equal longest len

        // console.log('center' + center.x)
        // console.log('left foci' + leftFoci.x)
        // console.log('right foci ' + rightFoci.x)
        // console.log('width ' + longestLen)

        // distance from (-c,0) to (x,y) where (x,y) is point and (-c,0) is left foci
        // const d1 = 0
        // distance from right foci to point
        // const d2 = 0

        // set of all points on the coordinate system
        // const boundBox = []
        // const x1 = 0
        // const y1 = 0
        // make bounding box around ellipse to pick points from
        // ranges from x+y to (x+y)*2
        // ranges from

        // const diagPoints = [{ x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 }]

        // diagPoints.forEach((p, i) => {
        //   const t = Math.tan(i * Math.PI / 4 + Math.atan(2 * b / a) / 2)
        //   const px = a * (1 - t ** 2) / (1 + t ** 2)
        //   const py = b * 2 * t / (1 + t ** 2)
        //   // console.log('px ' + px)
        //   p.x = px
        //   p.y = py
        // })

        // const ellipsePointSet = []
        // const count = 0

        // sum of distance must equal width

        return {
          handles: [
            { x: seX2, y: seY2 }, // se2
            { x: neX2, y: neY2 }, // ne2
            { x: nwX2, y: nwY2 }, // nw2
            { x: swX2, y: swY2 }, // se2
            { x: neX, y: neY }, // ne
            { x: seX, y: seY }, // se
            { x: nwX, y: nwY }, // nw
            { x: swX, y: swY }, // sw
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
      this.$emit('label-input', this.edgeIndex, event.target.value)
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
