<template>
  <div class='c-graph-container'>
    <header>
      <nav>
        the header
      </nav>
    </header>
    <main>
      node id num: {{this.nodes}}
      <button-pal @add-node='addNodeHandler' @delete-node='deleteNodeHandler' style='z-index: -100'></button-pal>
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
          @move='onNodeMove'
          @select-node='selectNodeHandler'
          @draw-edge='drawEdgeHandler'
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
      { id: 0, x: 200, y: 100, w: 100, h: 50, label: 'frodo', active: 'f', toNodes: [] },
      { id: 1, x: 450, y: 400, w: 100, h: 50, label: 'sam', active: 'f', toNodes: [] },
      { id: 2, x: 600, y: 600, w: 100, h: 50, label: 'strider', active: 'f', toNodes: [] }
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
    }
  }),

  computed: {

  },

  watch: {
    // watch can't detect property addition or deletion, only other changes

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

    // triggered on graph-node move
    onNodeMove ({ x, y, id }) {
      // this is getting a node by the index
      // meaning the index has to be the same as the id
      // const node = this.nodes[id]
      console.log('move ' + id + ' to ' + x + ' ' + y)

      // assign end position of node after drag
      this.nodes[id].x = x
      this.nodes[id].y = y

      // adds updatedNode var to data()
      // const updatedNode = Object.assign({}, node, { x, y })
      // const updateNode = Object.assign({}, node, { x: x, y: y })
      // set this.nodes' id to updatedNode
      // if (node) {
      // this is adding a new node that is a duplicate !
      // this.nodes[id] = updatedNode
      // this.$set(this.nodes, anode, updateNode)
      // this.$set(this.nodes, node.id, updatedNode)
      // run func to update the edge connection
      // this.updateAffectedEdges(updatedNode)
      // }
    },

    // updateAffectedEdges (node) {
    //   // this is to move the edge around with nodes
    //   // when one of the paired nodes is dragged then
    //   // the edge will move too and reconnect to it
    //   for (const edge of this.edges) {
    //     if (edge.fromNode.id === node.id) {
    //       // sets edge.fromNode in edges to node
    //       // adds this value to node since node doesn't come with a 'fromNode' property
    //       this.$set(edge, 'fromNode', node)
    //     } else if (edge.toNode.id === node.id) {
    //       this.$set(edge, 'toNode', node)
    //     }
    //   }
    // },

    addNodeHandler () {
    // make a new node
    // increment the idCount while making a new node so no duplicate ids
      var newnode = { id: this.idCount++, x: 100, y: 100, w: 100, h: 50, label: 'gandalf', active: 'f', toNodes: [] }
      this.nodes.push(newnode)
      console.log(this.nodes)
      // this.message = 'test'
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
      // this.idCompute(target.id)
      // need to check what the ids have changed to?

      this.deleteAttachedEdges(result)
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
      // highlight selected node with a cyan outline
      // give the node an activated class or ref etc. so it can be
      // identified by special buttons
      // console.log(event.target)

      // change indexval to id val since it's not the same as the index

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

    drawEdgeHandler (event, node) {
      // if node text has been clicked then draw edge to the next one that is cicked
      console.log('clicked text')
      // not working
      // console.log(event.currentTarget)
      // connect an edge from this node to the next node... use selected array?
      // this.edgeSelectNodes.push(node)
    }

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
