<template>
  <g>
    <!--marker is the arrow-->
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
    <!--this is the line-->
    <line
      :x1='startX'
      :y1='startY'
      :x2='endX'
      :y2='endY'
      class='c-graph-edge'
      marker-end='url("#arrow")'
    />
    <text
      class='edge-label'
      :x='startX'
      :y='startY + 50'
      fill='black'
      text-anchor='middle'
      dominant-baseline='middle'
      >
      {{ startY }}
    </text>

  </g>
</template>

<script>
export default {
  name: 'graph-edge',

  // fromnode and tonode are props which are passed down to the child from the parent
  // these props are both node objects

  // currently we seem to be only able to draw 1 line?
  props: {
    // fromNode: {
    //   type: Object,
    //   required: true
    // },

    // toNode: {
    //   type: Object,
    //   required: true
    // }
    fromNode: Object,
    toNode: Object
    // label: Text

  },

  data: () => ({
    // define the handles of the to and from nodes
    // handles are points on the node where the edge can attach to
    fromNodePoints: [],
    toNodePoints: [],
    label: 'test'
  }),

  // computed values automatically update reactively
  // these will automatically be fired because they are bound in the template

  // need to return multiple edges fromnode to all the tonodes
  // could just draw multiple edges? there's no need for a toNodes only a tonode
  computed: {
    startX () {
      return this.fromNode.x + this.fromNode.w
      // return this.closestHandlePair.closestPair.fromHandle.x
    },

    startY () {
      return this.fromNode.y + this.fromNode.h
      // return this.closestHandlePair.closestPair.fromHandle.y
    },

    endX () {
      return this.toNode.x + this.toNode.w
      // return this.closestHandlePair.closestPair.toHandle.x
    },

    endY () {
      return this.toNode.y + this.toNode.h
      // return this.closestHandlePair.closestPair.toHandle.y
    }

  },

  // determineClosestHandlePairs () {
  // get handles

  // see which are closest

  // return the closest
  // },

  // these are two pairs of handles from the fromnode and tonode
  /* Cartesian product of the from handles and the to handles */
  // handlePairs () {
  //   // get handles from both nodes
  //   const fromHandles = this.fromNodePoints.handles
  //   const toHandles = this.toNodePoints.handles

  //   // iterate through fromHandles
  //   return fromHandles.map(function (fromHandle) {
  //     return toHandles.map(function (toHandle) { fromHandle, toHandle })
  //   }).flat()
  //   // flatten the two handles objects into one object
  // },

  // determine the closest pair of handles and join them
  // closestHandlePair () {
  //   const vm = this

  //   return this.handlePairs.reduce(
  //     function ({ distance, closestPair }, pair) {
  //       if (!closestPair) {
  //         return { distance: vm.distance(pair), closestPair: pair }
  //       } else {
  //         const d = vm.distance(pair)
  //         if (d < distance) {
  //           return { distance: d, closestPair: pair }
  //         }

  //         return { distance, closestPair }
  //       }
  //     },
  //     {}
  //   )
  // }
  // },

  // fire the functions when these variables change
  watch: {

    // these are the functions that automatically fill fromNodePoints etc.
    // fromNodePoints is filled with handle details of the node passed in as param

    // when new nodes are pushed as props this will activate
    fromNode: {
      // getting the node from the parent when it is passed in
      // as a prop
      // the watch function will watch for changes
      handler: function (node) {
        // nodePoints determines the handle the line is attached to
        // this.fromNodePoints = this.nodePoints(node)
        this.distance(node.x, node.x, node.y, node.y)
      },
      // ?
      immediate: true
    },

    toNode: {
      handler: function (node) {
        // fills toNodePoints with objects- centre: {x,y}, handles: {x,y} which is where the line attaches
        // this.toNodePoints = this.nodePoints(node)
      },
      immediate: true
    }
  },

  methods: {
    // here we calculate the handles around the edges of the node so we can attach lines to those
    // handles
    nodePoints (node) {
      if (!node) {
        return {}
      }

      return {
        // centre: {
        //   x: node.x + node.w,
        //   y: node.y + node.h
        // },

        // handles are in format of {x,y}
        // north is the x + x and then y=y so because we've doubled x this means the line has moved
        // horizontally to the end of the shape?
        // east is
        handles: [
          // the origin x and y are the top left corner of the node, on an ellipse this is outside
          // of the node itself

          // to get centre try x: node.x + node.w, y: node.y + node.h
          // south = +50
          // north = -50
          // south { x: node.x + node.w, y: node.y + (node.h * 2) }#
          // { x: node.x + node.w, y: node.y + (node.h / 100) } // north
          { x: node.x + node.w, y: node.y + node.h } // north

          // ian's handles from top left origin node.x + node.y as base for calculation
          // { x: node.x + node.w, y: node.y }, // north
          // { x: node.x + node.w * 2, y: node.y + node.h }, // east
          // { x: node.x + node.w, y: node.y + node.h * 2 }, // south
          // { x: node.x, y: node.y + node.h } // west
        ]
      }
    },

    distance (fromx, fromy, tox, toy) {
      // need to pass in both nodes
      console.log(fromx, fromy, tox, toy)
      var dx = parseFloat(fromx - tox)
      var dy = parseFloat(fromy - toy)
      var distance = Math.sqrt(dx * dx + dy * dy)
      console.log('distance' + fromx)
      return distance
    }

    // this determines the length of the edge
    /* Pythagorean distance between two points */
    //   distance ({ fromHandle, toHandle }) {
    //     const dx = fromHandle.x - toHandle.x
    //     const dy = fromHandle.y - toHandle.y

  //     // square distance values and then sqrt
  //     return Math.sqrt(dx * dx + dy * dy)
  //   }
  }
}
</script>

<style>
.c-graph-edge {
  stroke: black;
}
</style>
