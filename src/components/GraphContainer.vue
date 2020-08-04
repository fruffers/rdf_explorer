<template>
  <div id='masterWrap'>
        <div id='nav'>
        <div id='navWrapper'>
          <a href='https://www.epimorphics.com/'>
            <img id='logo' src='../assets/epi1.png'/>
          </a>
          <div id='navInner'>
            RDF Explorer
            <br/>
            ===========
            <!-- <p id='tagline'>Learn about the RDF with interactive knowledge graphs</p> -->
          </div>
          <div id='tagline'>Learn about the RDF with interactive knowledge graphs</div>
        </div>
    </div>

  <div class='topWrap'>
  <div class='box1'>

      <level-buttons
      :levels='levels'
      @levelPick='graphGen'
      />
      <goal-pal @answer='answerHandler'><p v-html='this.levels[level].goal'></p></goal-pal>
      <div id='levelWrapper'>
          <h1>Level: <a v-html='level'/></h1>
          <p v-html='this.levels[level].text'/>

      <feedback-pal
      :levelCompletion='levelCompletion'
      />
      </div>

  </div>

  <div class='box2'>

    <div id='box2Buttons'>
      <button-pal
      id= 'buttons'
      :exportURL='graphFile'
      :graphName='graphExportName'
      @add-subject='addSubjectHandler'
      @add-object='addObjectHandler'
      @delete-node='deleteNodeHandler'
      @clear-canvas='clearCanvasHandler'
      @instruct-alert='instructAlertHandler'
      @export-graph='exportGraphHandler'
      @file-input='fileLoadHandler'
      >
      </button-pal>
    </div>
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
          @emit-loc='emitLocTooltipHandler'
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

        <node-tool-tip
          v-for='(node,index) in nodes'
          :key='`tooltip + ${index}`'
          :svgLocation='node.textLocInfo.svgLocation'
          :textX='node.textLocInfo.textX'
          :textY='node.textLocInfo.textY'
          :textW='node.textLocInfo.textW'
          :textH='node.textLocInfo.textH'
        >
        </node-tool-tip>

      </svg>

  </div>

  <div class='box3'>

      <turtle-convert
      :triples='triples'
      @turtle-convert='turtleConvert'
      />

      <prefix-pal
      @store-prefix='storePrefix'
      :prefixes='prefixes'
      />
    <!-- <footer>
      the footer
    </footer> -->

  </div>

</div>
</div>
</template>

<script>
// `edge-${edge.fromNode.id}-${edge.toNode.id}` < old key gen
// import util from 'util'

// smart node that handles all of the data and event handlers

// components
import GraphNode from './GraphNode'
import GraphEdge from './GraphEdge'
import buttonPal from './ButtonPalette'
import prefixPal from './PrefixPalette'
import turtleConvert from './TurtleConverter'
import goalPal from './GoalPalette'
import feedbackPal from './LevelFeedback'
import levelButtons from './LevelButtons'
import nodeToolTip from './NodeToolTip'

export default {
  name: 'graph-container',
  components: {
    GraphNode,
    GraphEdge,
    buttonPal,
    prefixPal,
    turtleConvert,
    goalPal,
    feedbackPal,
    levelButtons,
    nodeToolTip
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
        `RDF stands for resource description framework. It is a syntax model for presenting data to describe resources. A resource
        is anything which can be identified. RDF is particularly concerned with resources found on the web. RDF describes a resource
        and its relationship to other resources used a triple format of subject, predicate, object. 
        URIs are used as unique identifiers to point to a document on the web that describes the exact resource. The resource cannot
        be identified with simply a string 'John Doe' because there might be multiple John Does'.
        <br/>
        <br/>
        Subject: the identifier (URI) resource being described.
        <br/>
        <br/>
        Predicate: the relationship between the subject and object resources. This will usually be taken from a vocabulary which is a document set of predefined relationship types.
        <br/>
        <br/>
        Object: the resource or literal (string) related to the subject.
        A vocabulary is a set of properties and classes used to describe relationships between
        resources.
        <br/>
        <br/>
        RDF uses prefixes such as 
        db:lion
        The prefix is 'db:'
        The prefix is associated with a URI. Using the prefix means that the entire URI does
        not have to be repeated throughout the document if its used on several occasions, it
        is replaced with the prefix. And the added part is a suffix of the URI. Such as
        http://dbpedia.org/about/lion

        <br/>
        <br/>
        RDF documents can be written in several different formats which include TURTLE, RDF/XML, N-triples, N3, JSON-LD.
        `,
        goal: `Bethany Gunn, known as Beth, will celebrate her 37th birthday on 07/08
      </br>
      </br>
FOAF Classes: Person
FOAF Properties: firstName, lastName. Nickname, birthday, age


        `,
        answer: 'tg:Bilbo_Baggins tg:Baggins_Family tg:Frodo_Baggins . ' +
        'tg:Frodo_Baggins foaf:knows tg:Merry_BrandyBuck . ' +
        'tg:Bilbo_Baggins foaf:interest "Mushrooms" . ' +
        'tg:Frodo_Baggins foaf:interest "Mushrooms" . ' +
        'tg:Merry_BrandyBuck foaf:interest "Mushrooms" . ' +
        'tg:Bilbo_Baggins wo:species tg:Hobbits . ' +
        'tg:Frodo_Baggins wo:species tg:Hobbits . ' +
        'tg:Merry_BrandyBuck wo:species tg:Hobbits . '
      },
      {
        no: 1,
        text:
        `undefined
        `,
        goal: `Beth works at The Creature Garden along with her colleague Amy. Amy is an editor and Beth is a photographer
      </br>
      </br>
FOAF Classes: Person, Organization
FOAF Properties: name, knows, focus/interest

        `,
        answer: ''
      },
      {
        no: 2,
        text:
        `undefined
        `,
        goal: `Beth, Amy and Jack have been working on publishing a piece of their own research, based on the growth rate of succulents. 
      </br>
      </br>
FOAF Classes: Person, Document
FOAF Properties: topic, publications, PrimaryTopic

        `,
        answer: ''
      },
      {
        no: 3,
        text:
        `undefined
        `,
        goal: `undefined
        `,
        answer: ''
      }
    ],
    drawEdgeFrom: [],
    triples: [],
    ontoTerms: [],
    coordSystem: [],
    graphFile: '',
    graphExportName: 'graph.json',
    locInfo: {}
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
    //     let newEdges = this.edges || []
    //     let x = 0
    //     let b = 0
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
    this.graphGen(this.level)
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
      const newnode = { id: this.idCount++, x: 100, y: 100, w: 90, h: 25, label: '', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 }, textLocInfo: {} }
      this.nodes.push(newnode)
    },

    addObjectHandler () {
      const newnode = { id: this.idCount++, x: 100, y: 100, w: 150, h: 50, label: '', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} }
      this.nodes.push(newnode)
    },

    deleteNodeHandler () {
      const activeNodes = this.nodes.filter(function (node) {
        return node.active === 't'
      })

      // deletes all nodes with active 't'
      const result = this.nodes.filter(function (node) {
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
      let x = 0
      let a = 0
      for (x in this.edges) {
        for (a in deletedNodes) {
          if (this.edges[x].fromNode.id === deletedNodes[a].id || this.edges[x].toNode.id === deletedNodes[a].id) {
            this.edges[x].delete = true
          }
        }
      }

      const newEdges = this.edges.filter(function (edge) {
        return edge.delete === false
      })

      this.edges = newEdges
    },

    idCompute (removedNodes) {
      let a = 0
      let b = 0
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

      const index = event.target.getAttribute('indexval')

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
        const newEdge = { fromNode: this.drawEdgeFrom, toNode: node, edgeLabel: '', delete: false }

        // check if edge already exists
        let x = 0
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
      const oldEdges = this.edges
      const newEdges = oldEdges.filter(function (edge, index) {
        return index !== deleteIndex
      })

      this.edges = newEdges
    },

    resizeNodeHandler (nodeId, newWidth, newHeight, x, y) {
      const node = this.nodes[nodeId]
      const newNode = Object.assign(node, { w: newWidth, h: newHeight, x: x, y: y })
      // this.nodes[nodeId] = newNode

      this.$set(this.nodes, node.id, newNode) // set node to have displacement on x and y
      this.updateAffectedEdges(Object.assign({}, node, { w: newWidth, h: newHeight, x: x, y: y }))
    },

    storePrefix (name, uri) {
      // add new prefix
      const newPrefix = { name: name, uri: uri }
      // this.$set(this.prefixes,)
      this.prefixes.push(newPrefix)
    },

    determinePrefixes () {
    },

    turtleConvert () {
      const catchTriples = []
      // represent graph as simple turtle triples
      let x = 0
      for (x in this.edges) {
        catchTriples.push({
          subject: this.edges[x].fromNode.label || '_:blank', // the boolean tracks whether it is prefixed or not
          predicate: this.edges[x].edgeLabel || '_:blank',
          object: this.edges[x].toNode.label || '_:blank'
        })
      }

      let a = 0
      let b = 0
      let c = 0
      for (a in catchTriples) {
        for (b in catchTriples[a]) {
          const origin = catchTriples[a][b]
          const uriForm = `<${catchTriples[a][b]}>`
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
      let result = ''
      let a = 0
      for (a; a < this.triples.length; a++) {
        if (a !== 0) {
          result += '.' + ' '
        }
        for (const prop in this.triples[a]) {
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
      // gen next graph
      this.graphGen(this.level)
      console.log('success')
    },

    failure () {
      // regen graph
      this.levelCompletion = { levelNo: this.level, result: 'wrong' }
      console.log('failure')
    },

    graphGen (level) {
      level = parseInt(level, 10)
      this.level = level
      // delete current work
      this.clearCanvasHandler()
      // gen graph depending on level
      if (level === 0) {
        this.nodes.push(
          { id: 0, x: 200, y: 200, w: 150, h: 25, label: 'foaf:person', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 1, x: 450, y: 400, w: 150, h: 50, label: '"Bethany"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 2, x: 200, y: 400, w: 150, h: 50, label: '"07/08/2020"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 3, x: 400, y: 90, w: 150, h: 50, label: '"Beth"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 4, x: 50, y: 70, w: 150, h: 50, label: '"37"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} }
        )
        this.edges.push(
          { fromNode: this.nodes[0], toNode: this.nodes[1], delete: false, edgeLabel: 'foaf:firstName' },
          { fromNode: this.nodes[0], toNode: this.nodes[2], delete: false, edgeLabel: 'foaf:birthday' },
          { fromNode: this.nodes[0], toNode: this.nodes[3], delete: false, edgeLabel: 'foaf:nickname' },
          { fromNode: this.nodes[0], toNode: this.nodes[4], delete: false, edgeLabel: 'foaf:age' }
        )
      }

      this.idCount = this.nodes.length
      console.log(this.level)
    },

    exportGraphHandler () {
      let nodeJSONdata = ''
      // parse the nodes into json
      for (const node in this.nodes) {
        nodeJSONdata += JSON.stringify(this.nodes[node])
      }
      // add a seperator
      nodeJSONdata += ','
      // parse edges
      for (const edge in this.edges) {
        nodeJSONdata += JSON.stringify(this.edges[edge])
      }

      // bind new file URI
      this.graphFile = 'data:text/json;charset=utf-8,' + encodeURIComponent(nodeJSONdata)
    },

    fileLoadHandler (file) {
      const inputFile = file[0]
      console.log(inputFile)
      // const fileRead = new FileReader()
      // const fileData = fileRead.readAsText(file)
      // console.log(fileData)
      // check if file JSON
      // parse file to seperate nodes and edges
      // load into graph
    },

    emitLocTooltipHandler (loc, nodeId) {
      this.nodes[nodeId].textLocInfo = loc
    }

  }

}
</script>

<style>
.topWrap {
  display: flex;
  width: 100%;
  height: 100%;
}
.box1 {
  display: flexbox;
  /* background-color: red; */
  width: 20%;
}
.box2 {
  display: flexbox;
  /* background-color: green; */
  width: 90%;
}
.box3 {
  display: flexbox;
  /* background-color: blue; */
  width: 20%;
}
body {
  margin: 0;
  padding: 0;
}

#navWrapper {
  height: 2vh;
  margin: 0;
  background-color: #001c39;
  color: white;
}

#nav {
  margin: 0;
  padding: 0;
  /* box-shadow: 0px 2px 0px 1px rgba(172, 172, 172, 0.8); */
}

#navInner {
  font-family: 'Montserrat', sans-serif;
  text-align: left;
  margin-left: 1%;
  color: white;
}

/* #padder {
  padding: 4vh;
} */

#tagline {
  font-size: 100%;
  margin-right: 50%;
  text-align: left;
}

/* .topWrap main svg {
  height: 100%;
  width: 100%;
} */

#svgContain {
  /* background-image: url(../assets/grid2.gif); */
  background-color: whitesmoke;
  width: 100%;
  height: 100%;
}

#logo {
  padding-top: 0;
  width: 5%;
  margin-right: 1%;
  float: right;
}

/* #buttons {
  float: right;
  display: flex;
  padding: 1%;
} */

#levelWrapper {
  font-size: 18px;
  text-align: left;
  padding: 10%;
  padding-bottom: 0;
  margin-top: 0;
  margin-bottom: 0;
}

p {
  overflow-wrap:break-word;
}

#masterWrap {
  margin: 0;
  padding: 0;
  word-wrap: break-word;
}
</style>
