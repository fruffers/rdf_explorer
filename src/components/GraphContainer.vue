<template>
  <div class='c-graph-container'>
    <header>
      <nav>
        <img id='logo' src='../assets/epilogo.png'/>
        <div id='navInner'>
        RDF Explorer
        </div>
      </nav>
    </header>
    <main>
      <div id='levelWrapper'>
      <!-- <p v-html='this.instructions'/> -->
      <h1>Level: {{this.level}}</h1>
      <p v-html='this.levels[level].text'/>
      <goal-pal></goal-pal>
      </div>

      <button-pal
      id= 'buttons'
      @add-subject='addSubjectHandler'
      @add-object='addObjectHandler'
      @delete-node='deleteNodeHandler'
      @clear-canvas='clearCanvasHandler'
      @instruct-alert='instructAlertHandler'
      style='z-index: -100'>
      </button-pal>
      <!--encase in svg tag-->
      <svg
        id='svgContain'
        xmlns='http://www.w3.org/2000/svg'
        xmlns:xlink='http://www.w3.org/1999/xlink'
        width="1000px"
        height="1000px"
      >
          <graph-node
          class="node"
          v-for='node in nodes'
          :nodeData='node'
          :key='`node + ${node.id}`'
          @move='onMove'
          @move-end='onMoveEnd'
          @select-node='selectNodeHandler'
          @draw-edge='drawEdgeHandler'
          @label-input='labelInputHandler'
          @resize-node='resizeNodeHandler'
          :indexNo='node.id'
          ref='node'
        />
              <!-- the edge location moves with the fromNode and toNode bindings -->
        <graph-edge
          v-for='(edge, index) in edges'
          :fromNode='edge.fromNode'
          :edgeIndex='index'
          :toNode='edge.toNode'
          :edgeLabel='edge.edgeLabel'
          :key='`edge + ${index}`'
          :deleteEdgeBool='edge.delete'
          @label-input='edgeLabelHandler'
          @remove-edge='removeEdgeHandler'

          :dragDisplacement='dragDisplacement'
        />

      </svg>
      <prefix-pal
      @store-prefix='storePrefix'
      :prefixes='prefixes'
      />
      <turtle-convert
      :triples='triples'
      @turtle-convert='turtleConvert'
      />
    </main>
    <!-- <footer>
      the footer
    </footer> -->
  </div>
</template>

<script>
// `edge-${edge.fromNode.id}-${edge.toNode.id}` < old key gen
// import util from 'util'

// smart node that handles all of the data and event handlers

// import interact from 'interactjs'

// components
import GraphNode from './GraphNode'
import GraphEdge from './GraphEdge'
import buttonPal from './ButtonPalette'
import prefixPal from './PrefixPalette'
import turtleConvert from './TurtleConverter'
import goalPal from './GoalPalette'

export default {
  name: 'graph-container',
  components: {
    GraphNode,
    GraphEdge,
    buttonPal,
    prefixPal,
    turtleConvert,
    goalPal
  },

  data: () => ({
    // array of node objects
    // id must match the index
    nodes: [
      { id: 0, x: 200, y: 100, w: 150, h: 25, label: 'tg:Bilbo_Baggins', active: 'f', toNodes: [1, 2], type: 'subject', displacement: { x: 0, y: 0 } },
      { id: 1, x: 450, y: 400, w: 150, h: 25, label: 'tg:Frodo_Baggins', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 } },
      { id: 2, x: 600, y: 600, w: 150, h: 25, label: 'tg:Merry_BrandyBuck', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 } },
      { id: 3, x: 100, y: 400, w: 150, h: 50, label: '"Mushrooms"', active: 'f', toNodes: [1, 2, 3], type: 'object', displacement: { x: 0, y: 0 } }
    ],

    edges: [

    ], // fill with {fromNode and toNodes} objects

    prefixes: [
      { name: 'rdf:', uri: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#' },
      { name: 'rdfs:', uri: 'http://www.w3.org/2000/01/rdf-schema#' },
      { name: 'foaf:', uri: 'http://xmlns.com/foaf/0.1/' },
      { name: 'dct:', uri: 'https://www.dublincore.org/specifications/dublin-core/dcmi-terms/' },
      { name: 'tg:', uri: 'http://www.tolkiengateway.net/wiki/' },
      { name: 'wiki:', uri: 'https://www.wikipedia.org/' }
    ],

    message: 'no action',
    idCount: 0,
    dragDisplacement: {
      x: 0,
      y: 0
    },
    instructions:
    `
     1. Select nodes by clicking on them (they will
        be given a cyan outline).

     2. Deselect nodes by clicking on them again.

     3. Multiple selected nodes can be deleted by 
        pressing 'bin nodes'.

     4. Double click a node, then double click 
        another node, to draw an edge between 
        them.

     5. Drag nodes around to rearrange them.
     
     6. Delete edges by double clicking on them.
     
     7. Scroll down to the bottom. You can add 
        new prefixes and see existing ones.
        
     8. Convert your graph to turtle at the page 
        bottom.
     
     9. Resize nodes by hovering over them and 
        dragging out once an arrow handle appears. 
        To resize equally use the diagonal 
        corners/black arrows.`,
    level: 0,
    levels: [
      {
        no: 0,
        text:
        `Introducing RDF knowledge graphs.
        What is RDF? RDF stands for 'resource description framework'. It 
        is a syntax framework for describing resources (data/any subject that can be identified) on the web. `
      }
    ],
    drawEdgeFrom: [],
    triples: [],
    ontoTerms: []
  }),

  computed: {
    // ontoTerms() {

    // }

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
      { fromNode: this.nodes[0], toNode: this.nodes[1], delete: false, edgeLabel: 'tg:Baggins_Family' },
      { fromNode: this.nodes[1], toNode: this.nodes[2], delete: false, edgeLabel: 'foaf:knows' },
      { fromNode: this.nodes[0], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:interest' },
      { fromNode: this.nodes[1], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:interest' },
      { fromNode: this.nodes[2], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:interest' }
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

      if (node) {
        this.updateNodePosition(Object.assign({}, node, { displacement: { x, y } }))
      }
    },

    onMoveEnd ({ id }) {
      const node = this.nodes[id]

      if (node) {
        const x = node.x + node.displacement.x
        const y = node.y + node.displacement.y

        this.updateNodePosition(
          Object.assign({}, node, { x, y, displacement: { x: 0, y: 0 } })
        )
      }
    },

    updateNodePosition (node) {
      this.$set(this.nodes, node.id, node) // set node to have displacement on x and y
      this.updateAffectedEdges(node)
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
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 90, h: 25, label: '', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 } }
      this.nodes.push(newnode)
    },

    addObjectHandler () {
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 150, h: 50, label: '', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 } }
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

      // need to delete attached edges before the indexes change after nodes reassignment
      this.deleteAttachedEdges(activeNodes)

      // reassign nodes array to only nodes with 'f'
      // recompute ids
      this.idCompute(activeNodes)
      this.nodes = result
      // recompute ids to match indexes
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
          if (this.edges[x].fromNode.id === deletedNodes[a].id || this.edges[x].toNode.id === deletedNodes[a].id) {
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
      console.log('draw edge')
      // if tracker (drawEdgeFrom) is empty
      if (Object.keys(this.drawEdgeFrom).length === 0) {
        this.drawEdgeFrom = node
      } else if (node !== this.drawEdgeFrom) {
        // set up new edge to push
        var newEdge = { fromNode: this.drawEdgeFrom, toNode: node, edgeLabel: '', delete: false }

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

    labelInputHandler (nodeIndex, newChar) {
      var editLabel = this.nodes[nodeIndex].label
      if (newChar !== null) {
        this.nodes[nodeIndex].label += newChar
      } else {
        // remove a char since a backspace was entered
        this.nodes[nodeIndex].label = editLabel.substring(0, editLabel.length - 1)
      }
    },

    edgeLabelHandler (index, newChar) {
      var editLabel = this.edges[index].edgeLabel
      if (newChar !== null) {
        this.edges[index].edgeLabel += newChar
      } else {
        this.edges[index].edgeLabel = editLabel.substring(0, editLabel.length - 1)
      }
    },

    instructAlertHandler () {
      alert(this.instructions)
    },

    removeEdgeHandler (deleteIndex) {
      // return edges without specified index
      var oldEdges = this.edges
      var newEdges = oldEdges.filter(function (edge, index) {
        return index !== deleteIndex
      })

      this.edges = newEdges
    },

    resizeNodeHandler (nodeId, newWidth, newHeight, x, y) {
      var node = this.nodes[nodeId]
      var newNode = Object.assign(node, { w: newWidth, h: newHeight, x: x, y: y, displacement: { x: 0, y: 0 } })
      this.nodes[nodeId] = newNode

      this.$set(this.nodes, node.id, newNode) // set node to have displacement on x and y
      this.updateAffectedEdges(Object.assign({}, node, { w: newWidth, h: newHeight, x: x, y: y, displacement: { x: 0, y: 0 } }))
    },

    storePrefix (name, uri) {
      // add new prefix
      var newPrefix = { name: name, uri: uri }
      // this.$set(this.prefixes,)
      this.prefixes.push(newPrefix)
    },

    determinePrefixes () {
    },

    turtleConvert () {
      var catchTriples = []
      // represent graph as simple turtle triples
      var x = 0
      for (x in this.edges) {
        catchTriples.push({
          subject: this.edges[x].fromNode.label || '_:blank', // the boolean tracks whether it is prefixed or not
          predicate: this.edges[x].edgeLabel || '_:blank',
          object: this.edges[x].toNode.label || '_:blank'
        })
      }

      var a = 0
      var b = 0
      var c = 0
      for (a in catchTriples) {
        for (b in catchTriples[a]) {
          var origin = catchTriples[a][b]
          var uriForm = `<${catchTriples[a][b]}>`
          for (c in this.prefixes) {
            if (catchTriples[a][b].includes(this.prefixes[c].name) || catchTriples[a][b].includes('"') || catchTriples[a][b].includes('<>')) {
              catchTriples[a][b] = origin
              break
            } else {
              catchTriples[a][b] = uriForm
            }
          }
        }
      }

      // filter to take out the boolean trackers
      this.triples = catchTriples
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
  height: 5em;
  background-color: rgb(62, 86, 117);
  flex-grow: 0;
  color: white;
}

#navInner {
  font-size: 30px;
  padding: 1.5%;
  padding-top: 1%;
  float: left;
}

.c-graph-conta    inner, main {
  flex-grow: 1;
}

.c-graph-container main svg {
  height: 100%;
  width: 100%;
}

#svgContain {
  /* background-image: url(../assets/grid2.gif); */
  background-color: whitesmoke;
}

#logo {
  padding: 1%;
  height: 45px;
  float: right;
}

#buttons {
  float: right;
  padding: 1%;
}

#levelWrapper {
  font-size: 18px;
  line-height: 145%;
  text-align: left;
  margin-left: 10%;
  margin-right: 60%;
  padding: 3%;
  margin-top: 0;
  margin-bottom: 0;
}
</style>
