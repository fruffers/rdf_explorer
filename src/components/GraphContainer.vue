<template>
  <div class='c-graph-container'>
    <header>
      <nav>
        the header
      </nav>
    </header>
    <main>
      node id num: {{idCompute}}
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
        <graph-node
          class="node"
          v-for='node in nodes'
          :nodeData='node'
          :key='node.id'
          @move='onMove'
          @select-node='selectNodeHandler'
          :indexNo='node.id'
        />
        <graph-edge
          v-for='edge in edges'
          :fromNode='edge.fromNode'
          :toNode='edge.toNode'
          :key='`edge-${edge.fromNode.id}-${edge.toNode.id}`'
        />
      </svg>
    </main>
    <footer>
      the footer
    </footer>
  </div>
</template>

<script>
// smart node that handles all of the data and event handlers

// import svg elements as vue components
import GraphNode from './GraphNode'
import GraphEdge from './GraphEdge'
import buttonPal from './ButtonPalette'
// import binRect from './binRect'

export default {
  name: 'graph-container',
  components: {
    GraphNode,
    GraphEdge,
    buttonPal
    // binRect
  },

  // this is the info put into the g group of each node for the x and y position of the whole
  // also the dimensions of ellipse are calculated with y= cy and w= cx h=
  data: () => ({
    // array of node objects
    // id must match the index
    nodes: [
      { id: 0, x: 200, y: 100, w: 100, h: 50, label: 'frodo', active: 'f' },
      { id: 1, x: 450, y: 400, w: 100, h: 50, label: 'sam', active: 'f' },
      { id: 2, x: 600, y: 600, w: 100, h: 50, label: 'strider', active: 'f' }
    ],

    // idCount: this.idCompute,

    // nodesStartCount: this.nodes.length(),

    // carries 2 node objects, fromNode and toNode
    // apparently you can't have more than 2 or we need to know how to identify them using their ids
    // but an easier way would be to put the two nodes into one object or array and access them using
    // it as a namespace
    // this way edges will be more accessible as singular entities
    edges: [],
    message: 'no action',
    selectedNodes: []
  }),

  // watch: {
  // nodes: {
  //   handler () {
  //     // incremement id each time a new node is pushed in so there are no
  //     // duplicate keys
  //     if (this.nodes.length() > this.nodesStartCount) {

  //     }
  //   }
  // }
  // },

  computed: {
    idCompute () {
      return parseInt(this.nodes.length - 1 + 1)
    }

  },

  watch: {
    // nodes: function (nodes) {
    //   var node
    //   for (node in this.nodes) {
    //     console.log(node)
    //     if (this.nodes[node].active === 't') {
    //
    //     }
    //   }
    // }
  },

  mounted () {
    // create some test edges

    // pushing an object of 2 node objects into edges. The nodes will carry {id,x,y,w,h,label}.
    // and each object has its name depending on what it is. fromNode. toNode.
    this.edges.push(
      { fromNode: this.nodes[0], toNode: this.nodes[1] }
    )
  },

  methods: {
    // triggered on graph-node move
    onMove ({ x, y, id }) {
      // get node id
      const node = this.nodes[id]
      // adds updatedNode var to data()
      const updatedNode = Object.assign({}, node, { x, y })
      // set this.nodes' id to updatedNode
      if (node) {
        this.$set(this.nodes, node.id, updatedNode)
        // run func to update the edges7
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

    addNodeHandler () {
    // make a new node
    // increment the idCount while making a new node so no duplicate ids
      var newnode = { id: this.idCompute, x: 100, y: 100, w: 100, h: 50, label: 'gandalf', active: 'f' }
      this.nodes.push(newnode)
      console.log(this.nodes)
      // this.message = 'test'
    },

    deleteNodeHandler (target) {
      // delete node by pushing it out of array, use it's id to find the index
      // or just delete it
      console.log('delete a node')
      // deletes all nodes with active 't'
      var result = this.nodes.filter(function (node) {
        return node.active === 'f'
      })
      console.log(result)
      // reassign nodes array to only nodes with 'f'
      this.nodes = result
      // need to check what the ids have changed to?

      // console.log(this.nodes[0].active)
    },

    selectNodeHandler (event) {
      // highlight selected node with a cyan outline
      // give the node an activated class or ref etc. so it can be
      // identified by special buttons
      // console.log(event.target)

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

      // need to deselect node if another node is selected
      // or if user clicks anywhere else in graph
      // if user clicks twice then they deselect?? so we can bin multiple
      // nodes at once
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
