<template>
  <div class='c-graph-container'>
    <div id='nav'>
        <div id='navWrapper'>
          <a href='https://www.epimorphics.com/'>
            <img id='logo' src='../assets/epi1.png'/>
          </a>
          <div id='navInner'>
            RDF Explorer
            <br/>
            ===========
          </div>
          <div id='padder'/>
          <div id='tagline'>Learn about the RDF with interactive knowledge graphs</div>
        </div>
    </div>
    <main>
      <div id='levelWrapper'>
      <!-- <p v-html='this.instructions'/> -->
      <h1>Level: <a v-html='level'/></h1>
      <p v-html='this.levels[level].text'/>
      <goal-pal @answer='answerHandler'><p v-html='this.levels[level].goal'></p></goal-pal>

      <feedback-pal
      :levelCompletion='levelCompletion'
      />
      </div>

      <button-pal
      id= 'buttons'
      @add-subject='addSubjectHandler'
      @add-object='addObjectHandler'
      @delete-node='deleteNodeHandler'
      @clear-canvas='clearCanvasHandler'
      @instruct-alert='instructAlertHandler'
      @load-graph='loadGraphHandler'
      @save-graph='saveGraphHandler'
      >
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
import feedbackPal from './LevelFeedback'

export default {
  name: 'graph-container',
  components: {
    GraphNode,
    GraphEdge,
    buttonPal,
    prefixPal,
    turtleConvert,
    goalPal,
    feedbackPal
  },

  data: () => ({
    // array of node objects
    // id must match the index
    nodes: [
    ],

    edges: [

    ], // fill with {fromNode and toNodes} objects

    prefixes: [
      { name: 'rdf:', uri: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#' },
      { name: 'rdfs:', uri: 'http://www.w3.org/2000/01/rdf-schema#' },
      { name: 'foaf:', uri: 'http://xmlns.com/foaf/0.1/' },
      { name: 'dct:', uri: 'https://www.dublincore.org/specifications/dublin-core/dcmi-terms/' },
      { name: 'tg:', uri: 'http://www.tolkiengateway.net/wiki/' },
      { name: 'wo:', uri: 'http://purl.org/ontology/wo/' },
      { name: 'dbpedia:', uri: 'https://wiki.dbpedia.org/' },
      { name: 'schema:', uri: 'https://schema.org/' }
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
    levelCompletion: { levelNo: 0, result: 'wrong' },
    levels: [
      {
        no: 0,
        text:
        `RDF stands for <b>'resource description framework'</b>. It is a syntax framework for describing resources, and their relationships to other resources. RDF syntax is used so that machines can read the data and make use of it. 
        <br/>
        <br/>
        A resource is any thing that can be identified. For example 'elephant', 'hunger', or 'wikipedia'. RDF has a data model that organizes data into triples. These consist of three parts. <b>Subject, predicate, object</b>.
        <br/>
        <br/>
        <b>
        Subject: a resource identified with a URI.
        <br/>
        <br/>
        Predicate: URI identifier to data specifying the relationship between the subject and object.
        <br/>
        <br/>
        Object: a resource or literal (string) that is related to the subject.
        </b>
        <br/>
        <br/>

        Ontologies are web-hosted vocabularies with classes and properties that can be used to describe resources.`,
        goal: `Add a 'hobbit' resource to the graph and connect it to other resources. 
        <br/>
        <br/>
        Think of it like this...
        <br/>
        <br/>
        subject: bilbo baggins
        <br/>
        predicate: has the species
        <br/>
        object: hobbit
        <br/>
        <br/>

        A prefix replaces part of a URI so that one only needs to type the suffix after the defined prefix instead of a whole URI. 
        &lt;www.tolkiengateway.net/Hobbits&gt; becomes tg:Hobbits
        <br/>
        <br/>
        Use the given prefixes at the bottom of the page. For this one you will need to use: tg (tolkiengate) and wo (wildlife ontology). 
        <br/>
        <br/>
        To find out more information about the ontologies follow their links to see the classes and properties associated with them. Your URI must be accurate in spelling; it must exist on the web.
        `,
        answer: 'tg:Bilbo_Baggins tg:Baggins_Family tg:Frodo_Baggins . ' +
        'tg:Frodo_Baggins foaf:knows tg:Merry_BrandyBuck . ' +
        'tg:Bilbo_Baggins foaf:interest "Mushrooms" . ' +
        'tg:Frodo_Baggins foaf:interest "Mushrooms" . ' +
        'tg:Merry_BrandyBuck foaf:interest "Mushrooms" . ' +
        'tg:Bilbo_Baggins wo:species tg:Hobbits . ' +
        'tg:Frodo_Baggins wo:species tg:Hobbits . ' +
        'tg:Merry_BrandyBuck wo:species tg:Hobbits . '
      }
    ],
    drawEdgeFrom: [],
    triples: [],
    ontoTerms: [],
    coordSystem: []
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
    // gen default graph on page load
    this.graphGen()
    this.idCount = this.nodes.length
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

    labelInputHandler (nodeIndex, newVal) {
      if (newVal !== null) {
        this.nodes[nodeIndex].label = newVal
      }
    },

    edgeLabelHandler (index, newVal) {
      if (newVal !== null) {
        this.edges[index].edgeLabel = newVal
      }
    },

    instructAlertHandler () {
      confirm(this.instructions)
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
      var newNode = Object.assign(node, { w: newWidth, h: newHeight, x: x, y: y })
      // this.nodes[nodeId] = newNode

      this.$set(this.nodes, node.id, newNode) // set node to have displacement on x and y
      this.updateAffectedEdges(Object.assign({}, node, { w: newWidth, h: newHeight, x: x, y: y }))
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
    },

    answerHandler () {
      // check whether answer is correct for current level
      // change turtle output format so it matches the answer format
      this.turtleConvert()
      var result = ''
      var a = 0
      for (a; a < this.triples.length; a++) {
        if (a !== 0) {
          result += '.' + ' '
        }
        for (var prop in this.triples[a]) {
          result += this.triples[a][prop] + ' '

          if (a === this.triples.length - 1 && prop === 'object') {
            result += '. '
          }
        }
      }
      if (result.includes(this.levels[this.level].answer)) {
        // correct
        this.success()
      } else {
        // wrong
        this.failure()
      }
    },

    success () {
      // this.levelCompletion.result = 'right'
      this.levelCompletion = { levelNo: this.level, result: 'right' }
      // update level
      this.level++
      // reassign
      // this.levelCompletion = { levelNo: this.level, result: 'wrong' }
      // gen next graph
      this.graphGen()
      console.log('success')
    },

    failure () {
      // regen graph
      this.levelCompletion = { levelNo: this.level, result: 'wrong' }
      this.graphGen()
      console.log('failure')
    },

    graphGen () {
      // delete current work
      this.clearCanvasHandler()
      // gen graph depending on level
      if (this.level === 0) {
        this.nodes.push(
          { id: 0, x: 200, y: 100, w: 150, h: 25, label: 'tg:Bilbo_Baggins', active: 'f', toNodes: [1, 2], type: 'subject', displacement: { x: 0, y: 0 } },
          { id: 1, x: 450, y: 400, w: 150, h: 25, label: 'tg:Frodo_Baggins', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 } },
          { id: 2, x: 400, y: 600, w: 150, h: 25, label: 'tg:Merry_BrandyBuck', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 } },
          { id: 3, x: 100, y: 400, w: 150, h: 50, label: '"Mushrooms"', active: 'f', toNodes: [1, 2, 3], type: 'object', displacement: { x: 0, y: 0 } }
        )
        this.edges.push(
          { fromNode: this.nodes[0], toNode: this.nodes[1], delete: false, edgeLabel: 'tg:Baggins_Family' },
          { fromNode: this.nodes[1], toNode: this.nodes[2], delete: false, edgeLabel: 'foaf:knows' },
          { fromNode: this.nodes[0], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:interest' },
          { fromNode: this.nodes[1], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:interest' },
          { fromNode: this.nodes[2], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:interest' }
        )
      }

      this.idCount = this.nodes.length
    },

    saveGraphHandler () {
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
}

/* header {
  height: 9vh;
  padding: 3%;
} */

.c-graph-container header, .c-graph-container footer {
/* background: rgb(74,128,154);
background: linear-gradient(90deg, rgba(74,128,154,1) 0%, rgba(67,89,135,1) 35%, rgba(0,28,57,1) 100%); */
  /* background: rgb(74,128,154);
background: linear-gradient(90deg, rgba(74,128,154,1) 0%, rgba(104,141,179,1) 35%, rgba(0,28,57,1) 100%); */
  /* background: rgb(85,106,116);
background: linear-gradient(90deg, rgba(85,106,116,1) 0%, rgba(82,100,135,1) 35%, rgba(0,28,57,1) 100%); */
  flex-grow: 0;
  color: white;
}

#navWrapper {
  height: 10vh;
  margin: 0;
  background-color: #001c39;
  height: 10vh;
  padding: 3%;
  color: white;
}

#nav {
  margin: 0;
  padding: 0;
  /* box-shadow: 0px 2px 0px 1px rgba(172, 172, 172, 0.8); */
}

#navInner {
  font-family: 'Montserrat', sans-serif;
  font-size: 130%;
  float: left;
  margin-top: 1.5%;
  color: white;
}

#padder {
  padding: 4vh;
}

#tagline {
  float: left;
  font-size: 80%;
  margin-right: 60%;
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
  padding-top: 0;
  height: 90%;
  margin-right: 1%;
  float: right;
}

#buttons {
  float: right;
  display: flex;
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

p {
  overflow-wrap:break-word;
}
</style>
