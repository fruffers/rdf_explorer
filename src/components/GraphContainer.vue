<template>
  <div class='c-graph-container'>
    <header>
      <nav>
        the header
      </nav>
    </header>
    <main>
      node id num: {{this.edges}}
      <button-pal
      @add-subject='addSubjectHandler'
      @add-object='addObjectHandler'
      @delete-node='deleteNodeHandler'
      @clear-canvas='clearCanvasHandler'
      style='z-index: -100'>
      </button-pal>
      <!--encase in svg tag-->
      <svg
        xmlns='http://www.w3.org/2000/svg'
        xmlns:xlink='http://www.w3.org/1999/xlink'
        width="1000px"
        height="1000px"
        style=' background-color:green; '
      >
        <!-- <bin-rect @delete-node='deleteNodeHandler'></bin-rect> -->
        <!--key bindings are for v-for, they are random and unique-->
        <g
        ref='nodeAndEdgeGroup'
        >
        <graph-node
          class="node"
          v-for='node in nodes'
          :nodeData='node'
          :key='node.id'
          @move='onMove'
          @select-node='selectNodeHandler'
          @draw-edge='drawEdgeHandler'
          @drag-displacement-pass='dragDisplacementHandler'
          :indexNo='node.id'
          ref='node'
        />
        <!-- the edge location moves with the fromNode and toNode bindings -->
        <graph-edge
          v-for='edge in edges'
          :fromNode='edge.fromNode'
          :toNode='edge.toNode'
          :key='`edge-${edge.fromNode.id}-${edge.toNode.id}`'
          :deleteEdgeBool='edge.delete'

          :dragDisplacement='dragDisplacement'
        />
        </g>
      </svg>
    </main>
    <footer>
      the footer
    </footer>
  </div>
</template>

<script>
// import util from 'util'

// smart node that handles all of the data and event handlers

// import interact from 'interactjs'

// import svg elements as vue components
import GraphNode from './GraphNode'
import GraphEdge from './GraphEdge'
import buttonPal from './ButtonPalette'

export default {
  name: 'graph-container',
  components: {
    GraphNode,
    GraphEdge,
    buttonPal
  },

  // this is the info put into the g group of each node for the x and y position of the whole
  // also the dimensions of ellipse are calculated with y= cy and w= cx h=
  data: () => ({
    // array of node objects
    // id must match the index
    nodes: [
      { id: 0, x: 200, y: 100, w: 100, h: 50, label: 'frodo', active: 'f', toNodes: [1, 2], type: 'object' },
      { id: 1, x: 450, y: 400, w: 60, h: 25, label: 'sam', active: 'f', toNodes: [], type: 'subject' },
      { id: 2, x: 600, y: 600, w: 60, h: 25, label: 'strider', active: 'f', toNodes: [], type: 'subject' }
    ],

    // idCount: this.idCompute,

    // nodesStartCount: this.nodes.length(),

    // carries 2 node objects, fromNode and toNode
    // apparently you can't have more than 2 or we need to know how to identify them using their ids
    // but an easier way would be to put the two nodes into one object or array and access them using
    // it as a namespace
    // this way edges will be more accessible as singular entities
    edges: [

    ], // fill with {fromNode and toNodes} objects

    message: 'no action',
    idCount: 0,
    dragDisplacement: {
      x: 0,
      y: 0
    },

    drawEdgeFrom: {},
    stage: '',
    edgesDragMove: [] // temp store of locations used during drag moving
  }),

  computed: {
    // compute displacement on drag to be reactive to both nodes and edges
    // need to pass the affected node and edges..... so that only those update
    // pass the affected node
    // work out all the edges attached to that node
    // pass the affected edges

  },

  watch: {
    // watch can't detect property addition or deletion, only other changes

    // displacement () {
    //   // update nodes and edges to add displacement values to select nodes

    // }

    // .................. this produces an error with #2 bin nodes. Return to it later?
    // nodes: {
    //   handler: function () {
    //     // allow new nodes to be connected to by entering their indexes in nodes.toNodes
    //     var newEdges = this.edges || []
    //     var x = 0
    //     var b = 0
    //     for (x in this.nodes) {
    //       if (this.nodes[x].toNodes) {
    //         for (b in this.nodes[x].toNodes) {
    //           newEdges.push({ fromNode: this.nodes[x], toNode: this.nodes[this.nodes[x].toNodes[b]] })
    //           // newEdges[this.nodes[x].toNodes] = { fromNode: this.nodes[x], toNode: this.nodes[x].toNodes[b], delete: false, dragDisplacement: {} }
    //         }
    //       }
    //     }
    //     this.edges = newEdges
    //   },
    //   immediate: true

    // }

  },

  mounted () {
    // create some test edges

    this.idCount = this.nodes.length

    this.edges.push(
      { fromNode: this.nodes[0], toNode: this.nodes[1], delete: false },
      { fromNode: this.nodes[0], toNode: this.nodes[2], delete: false }
    )

    // pushing an object of 2 node objects into edges. The nodes will carry {id,x,y,w,h,label}.
    // and each object has its name depending on what it is. fromNode. toNode.
  },

  methods: {

    dragDisplacementHandler (displacement) {
      this.dragDisplacement = displacement

      // need to move only the edge and not the node attached therefore use a seperate
      // data storage?
      // this.edges[0].fromNode.x += 10
      // this.edges[0].fromNode.x += 10
      // this.edges[0].fromNodde.y += 10
      // this.nodes[2].x += 10
      // this.nodes[2].y += 10
      // update all displacement dependencies (x,y positions of edge and node)

      // get edges attached to node
    },

    resetDisplacement () {
      this.displacement = {
        x: 0,
        y: 0
      }
    },

    // triggered on graphNode move
    // onNodeMove ({ x, y, id }) {
    //   // this is getting a node by the index
    //   // meaning the index has to be the same as the id
    //   // const node = this.nodes[id]
    //   console.log('move ' + id + ' to ' + x + ' ' + y)

    //   // assign end position of node after drag
    //   this.nodes[id].x = x
    //   this.nodes[id].y = y

    //   // this.resetDisplacement()

    //   const node = this.nodes[id]
    //   // const updatedNode = Object.assign({}, node, { x, y })

    //   if (node) {
    //     // this.$set(this.nodes, node.id, updatedNode)
    //     this.updateAffectedEdges(node)
    //   }
    // },

    onMove ({ x, y, id }) {
      const node = this.nodes[id]
      const updatedNode = Object.assign({}, node, { x, y })

      if (node) {
        this.$set(this.nodes, node.id, updatedNode)
        this.updateAffectedEdges(updatedNode)
      }
    },

    updateAffectedEdges (node) {
      for (const edge of this.edges) {
        if (edge.fromNode.id === node.id) {
          this.$set(edge, 'fromNode', node)
        } else if (edge.toNode.id === node.id) {
          this.$set(edge, 'toNode', node)
        }
      }
    },

    addSubjectHandler () {
    // make a new node
    // increment the idCount while making a new node so no duplicate ids
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 60, h: 25, label: 'gandalf', active: 'f', toNodes: [], type: 'subject' }
      this.nodes.push(newnode)
      console.log(this.nodes)
    },

    addObjectHandler () {
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 100, h: 50, label: 'gandalf', active: 'f', toNodes: [], type: 'object' }
      this.nodes.push(newnode)
      console.log(this.nodes)
    },

    deleteNodeHandler () {
      var activeNodes = this.nodes.filter(function (node) {
        return node.active === 't'
      })

      // deletes all nodes with active 't'
      var result = this.nodes.filter(function (node) {
        return node.active === 'f'
      })
      // reassign nodes array to only nodes with 'f'
      // recompute ids
      this.idCompute(activeNodes)
      this.nodes = result
      // recompute ids to match indexes

      this.deleteAttachedEdges(activeNodes)
    },

    clearCanvasHandler () {
      this.nodes = []
      this.edges = []
      this.idCount = 0
    },

    deleteAttachedEdges (deletedNodes) {
      // delete edges attached to deleted nodes
      var x = 0
      var a = 0
      for (x in this.edges) {
        for (a in deletedNodes) {
          if (this.edges[x].fromNode === deletedNodes[a] || this.edges[x].toNode === deletedNodes[a]) {
            this.edges[x].delete = true
          }
        }
      }

      var newEdges = this.edges.filter(function (edge) {
        return edge.delete === false
      })

      this.edges = newEdges
    },

    idCompute (removedNodes) {
      console.log('idrecompute')
      var a = 0
      var b = 0
      for (a in removedNodes) {
        for (b in this.nodes) {
          if (this.nodes[b].id > removedNodes[a].id) {
            this.nodes[b].id = this.nodes[b].id - 1
          }
        }
      }
      // edit idCount to reflect new num of nodes
      this.idCount = this.nodes.length - removedNodes.length
    },

    selectNodeHandler (event) {
      // highlight with cyan outline and give target an active property

      console.log('select')

      var index = event.target.getAttribute('indexval')

      if (event.target.id === 'unactive') {
        event.target.id = 'active'
        event.target.style.stroke = 'cyan'
        event.target.style.strokeWidth = '4'

        // use indexVal to get the corresponding node in nodes
        // so that it can be marked for actions and deletion
        this.nodes[index].active = 't'
      } else if (event.target.id === 'active') {
        event.target.id = 'unactive'
        event.target.style.stroke = 'black'
        event.target.style.strokeWidth = '2'

        this.nodes[index].active = 'f'
      }

      // if user clicks twice then they deselect. so we can bin multiple
      // nodes at once
    },

    drawEdgeHandler (node, stage) {
      // problem: there can be duplicate edges which create duplicate key problem

      // if tracker is empty
      if (Object.keys(this.drawEdgeFrom).length === 0) {
        this.drawEdgeFrom = node
      } else if (node !== this.drawEdgeFrom) {
        // set up new edge to push
        var newEdge = { fromNode: this.drawEdgeFrom, toNode: node }

        // check if edge already exists
        var x = 0
        for (x in this.edges) {
          if (this.edges[x] === newEdge) {
            return
          }
        }
        // draw an edge to this new node
        this.edges.push(newEdge)

        // empty the store to get a new fromNode
        this.drawEdgeFrom = {}
      }
    }

    //   dragAlongHandler (node, displacement) {
    //     // create a store for affected node points
    //     var nodePoints = { fromNode: {}, toNodes: [], origin: '', indexes: [] }

    //     // check if dragged node is attached to any edges
    //     var x = 0
    //     var b = 0
    //     for (x in this.edges) {
    //       if (node === this.edges[x].fromNode) {
    //         // only one fromNode
    //         nodePoints.fromNode = this.edges[x].fromNode
    //         nodePoints.origin = 'from'
    //         // there may be multiple toNodes
    //         for (b in this.edges) {
    //           if (this.edges[b].fromNode === node) {
    //             // get the toNode attached to each matching fromNode found
    //             nodePoints.toNodes += this.edges[b].toNode

    //             // change the startx and starty of each node
    //             this.edges[b].toNode.x += displacement.x
    //             this.edges[b].toNode.y += displacement.y
    //           }
    //         }
    //       } else if (node === this.edges[x].toNode) {
    //         // there will only be one matching fromNode
    //         nodePoints.fromNode = this.edges[x].fromNode
    //         nodePoints.origin = 'to'

    //         this.edges[x].fromNode.x += displacement.x
    //         this.edges[x].fromNode.y += displacement.y
    //       }
    //     }

    //     // apply displacement to every node in store

    //     // if origin is 'from' then change startx and starty of every edge attached to a toNode

    //     // if origin is 'to' then change endx and endy of origin node

    //     // different if we are dragging a fromNode

    //     console.log('drag')

    //     // console.log('fromnode ' + this.edges[0].fromNode)
    //   }

    // }

  }

}
</script>

<style>
body {
  margin: 0;
  padding: 0;
}
.c-graph-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.c-graph-container header, .c-graph-container footer {
  height: 3em;
  background-color: #999;
  flex-grow: 0;
}

.c-graph-conta    iner main {
  flex-grow: 1;
}

.c-graph-container main svg {
  height: 100%;
  width: 100%;
}

</style>
