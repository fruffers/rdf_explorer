<template>
  <div class='c-graph-container'>
    <header>
      <nav>
        <div id='navInner'>
        RDF Explorer
        </div>
      </nav>
    </header>
    <main>
      <!-- <p v-html='this.instructions'/> -->
      <!-- Level:{{this.level}}
      {{this.levels[level]}} -->
      <button-pal
      @add-subject='addSubjectHandler'
      @add-object='addObjectHandler'
      @delete-node='deleteNodeHandler'
      @clear-canvas='clearCanvasHandler'
      @instruct-alert='instructAlertHandler'
      style='z-index: -100'>
      </button-pal>
      <!--encase in svg tag-->
      <svg
        xmlns='http://www.w3.org/2000/svg'
        xmlns:xlink='http://www.w3.org/1999/xlink'
        width="1000px"
        height="1000px"
        style=' background-color:whitesmoke; '
      >
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

  data: () => ({
    // array of node objects
    // id must match the index
    nodes: [
      { id: 0, x: 200, y: 100, w: 150, h: 50, label: 'frodo', active: 'f', toNodes: [1, 2], type: 'object' },
      { id: 1, x: 450, y: 400, w: 90, h: 25, label: 'sam', active: 'f', toNodes: [], type: 'subject' },
      { id: 2, x: 600, y: 600, w: 90, h: 25, label: 'strider', active: 'f', toNodes: [], type: 'subject' }
    ],

    edges: [

    ], // fill with {fromNode and toNodes} objects

    message: 'no action',
    idCount: 0,
    dragDisplacement: {
      x: 0,
      y: 0
    },
    instructions:
    `
     1. Select nodes by clicking on them.
     2. Multiple selected nodes can be deleted by pressing 
        'bin nodes'.
     3. Double click a node, then double click another node, to 
        draw an edge between them.
     4. Drag nodes around to rearrange them.`,
    level: 0,
    levels: [
      {
        no: 0,
        text:
        `Introducing RDF 
        knowledge graphs.`
      }
    ]
  }),

  computed: {

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

    resetDisplacement () {
      this.displacement = {
        x: 0,
        y: 0
      }
    },

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
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 90, h: 25, label: 'gandalf', active: 'f', toNodes: [], type: 'subject' }
      this.nodes.push(newnode)
    },

    addObjectHandler () {
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 150, h: 50, label: 'gandalf', active: 'f', toNodes: [], type: 'object' }
      this.nodes.push(newnode)
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
    },

    instructAlertHandler () {
      alert(this.instructions)
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
  background-color: rgb(62, 86, 117);
  flex-grow: 0;
  color: white;
}

#navInner {
  padding: 1.5%;
  float: left;
}

.c-graph-conta    inner, main {
  flex-grow: 1;
}

.c-graph-container main svg {
  height: 100%;
  width: 100%;
}
</style>
