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
    <!--input label is connected to edge location through startX and endY etc.-->
    <foreignObject :x='Math.sqrt(endX * startX) / 1.1' :y='Math.sqrt(endY * startY)' :width='140' :height='25'>
      <div xmlns="http://www.w3.org/1999/xhtml">
        <input
        class='inputBox'
        :value='edgeLabel'
        @input='edgeLabelEmit'>
      </div>
    </foreignObject>

  </g>
</template>

<script>
export default {
  name: 'graph-edge',

  // these props are both node objects with all info about node
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
    // startX calculates where the x start position of edge is on fromnode
    // by getting the closest handle on the opposite tonode
    startX: {
      get: function () {
        return this.closestHandlePair.fromHandle.x
      },

      set: function (newVal) {
        return newVal
      }

    },

    startY: {
      get: function () {
        return this.closestHandlePair.fromHandle.y
      },

      set: function (newVal) {
        return newVal
      }

    },

    endX: {
      get: function () {
        return this.closestHandlePair.toHandle.x
      },

      set: function (newVal) {
        return newVal
      }

    },

    endY: {
      get: function () {
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

  // fire functions on variable changes
  watch: {

    deleteEdgeBool: {
      handler: function (value) {
        if (value === true) {
          this.deleteEdge()
        }
      }
    },

    // these are the functions that automatically fill fromNodePoints etc.
    // fromNodePoints is filled with handles details of the node passed in as param

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

    // calculate the 'handles' points around the edges of the node so as to attach edges to them
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

        // https://stackoverflow.com/questions/9411861/how-do-i-calculate-a-point-on-a-ellipse-s-circumference
        // use angle to find handles
        const nwX = (x + node.w) + (node.w * Math.cos(10))
        const nwY = (y + node.h / 1.5) + (node.h * Math.sin(10))
        const neX = (x + node.w / 80) + (node.w * Math.cos(100))
        const neY = (y + node.h / 1.4) + (node.h * Math.sin(10))
        const swX = (x + node.w / 1) + (node.w * Math.cos(-10))
        const swY = (y + node.h / 3) + (node.h * Math.sin(-10))
        const seX = (x + node.w / 20) + (node.w * Math.cos(-100))
        const seY = (y + node.h / 4) + (node.h * Math.sin(-10))

        return {
          handles: [
            { x: x + node.w / 2, y: y + node.h }, // south
            { x: x + node.w, y: y + node.h / 2 }, // east
            { x: x + node.w / 200, y: y + node.h / 2 }, // west
            { x: x + node.w / 2, y: y + node.h / 200 }, // north
            { x: seX, y: seY }, // se
            { x: swX, y: swY }, // sw
            { x: nwX, y: nwY }, // nw
            { x: neX, y: neY } // ne
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
