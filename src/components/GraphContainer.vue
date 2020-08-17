<template>
  <div id='masterWrap'>
        <div id='nav'>
        <div id='navWrapper'>
          <a href='https://www.epimorphics.com/'>
            <img id='logo' src='../assets/epilogo.png'/>
          </a>
          <div id='navInner'>
            RDF Explorer
            <span id='tagline'>Learn about the RDF with interactive knowledge graphs</span>
          </div>
        </div>
    </div>

    <!-- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="#21A0C7" fill-opacity="1" d="M0,256L48,229.3C96,203,192,149,288,144C384,139,480,181,576,192C672,203,768,181,864,160C960,139,1056,117,1152,128C1248,139,1344,181,1392,202.7L1440,224L1440,0L1392,0C1344,0,1248,0,1152,0C1056,0,960,0,864,0C768,0,672,0,576,0C480,0,384,0,288,0C192,0,96,0,48,0L0,0Z"></path></svg> -->

    <!-- <div class='textHold'>
      <h1>Level: <a v-html='level'/></h1>
      <p v-html='this.levels[level-1].text'/>
    </div> -->
    <div id='levelButtons'>
    <level-buttons
      :levels='levels'
      @levelPick='graphGen'
    />
    </div>

  <div class='topWrap'>
  <div class='box1'>
        <div id='progressHolder'>
      <img id='levelLight' :src='levelLight'/>
    </div>
      <goal-pal @answer='answerHandler'>
        <template v-slot:goalslot>
        <p v-html='levels[level-1].goal'></p>
        </template>
        <template v-slot:hintslot>
          <p v-html='levels[level-1].hint'></p>
        </template>
      </goal-pal>
      <div id='levelWrapper'>
        <feedback-pal
        :levelCompletion='levelCompletion'
        />
      </div>

    <converter-choices
    @fetch-triples='ntriplesConvert'
    @ntriples-convert='ntriplesConvert'
    :triples='triples'
    :conversionTypes='conversionTypes'
    />

    <prefix-pal
    @store-prefix='storePrefix'
    :prefixes='prefixes'
    />

  </div>

  <div class='box2'>

    <div class='over'>

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
      <!--container of all svg elements-->
      <svg
        id='svgContain'
        xmlns='http://www.w3.org/2000/svg'
        xmlns:xlink='http://www.w3.org/1999/xlink'
        width="100%"
        height="500vh"
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

        <!-- <node-tool-tip
          v-for='(node,index) in nodes'
          :key='`tooltip + ${index}`'
          :svgLocation='node.textLocInfo.svgLocation'
          :textX='node.textLocInfo.textX'
          :textY='node.textLocInfo.textY'
          :textW='node.textLocInfo.textW'
          :textH='node.textLocInfo.textH'
        >
        </node-tool-tip> -->

      </svg>

      </div>

  </div>

</div>
</div>
</template>

<script>
// smart node that handles all of the data and event handlers

// images
import progress1 from '../assets/progressbars/SVG/Progress-1.svg'
import progress2 from '../assets/progressbars/SVG/Progress-2.svg'
import progress3 from '../assets/progressbars/SVG/Progress-3.svg'
import progress4 from '../assets/progressbars/SVG/Progress-4.svg'

// components
import GraphNode from './GraphNode'
import GraphEdge from './GraphEdge'
import buttonPal from './ButtonPalette'
import prefixPal from './PrefixPalette'
import goalPal from './GoalPalette'
import feedbackPal from './LevelFeedback'
import levelButtons from './LevelButtons'
import converterChoices from './ConverterChoices'
// import nodeToolTip from './NodeToolTip'

export default {
  name: 'graph-container',
  components: {
    GraphNode,
    GraphEdge,
    buttonPal,
    prefixPal,
    goalPal,
    feedbackPal,
    levelButtons,
    converterChoices
    // nodeToolTip
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
      { name: 'dct:', uri: 'http://purl.org/dc/terms/' },
      { name: 'wo:', uri: 'http://purl.org/ontology/wo/about/' },
      { name: 'dbpedia:', uri: 'http://dbpedia.org/page/' },
      { name: 'schema:', uri: 'https://schema.org/' }
    ],

    conversionTypes: { xml: 'xml', jsonld: 'jsonld', n3: 'n3' },

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
        
     8. Convert your graph to other formats with button clicks.
     
     9. Resize nodes by hovering over them and 
        dragging out once an arrow handle appears.`,
    level: 1,
    levelCompletion: { levelNo: 1, result: 'wrong' },
    levels: [
      {
        no: 1,
        light: progress1,
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
        Object: a resource URI or literal (string) related to the subject.
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
        goal: `Bethany Gunn has an interest in the topic marine biology. Add this to the graph
        using the foaf ontology and dbpedia.
        `,
        hint: `
        FOAF Classes: Person
        </br>
        FOAF Properties: firstName, lastName, Nickname, birthday, age
        `,
        answer: `
        <https://schema.org/foaf:Person> <https://schema.org/foaf:firstName> "Bethany" . <https://schema.org/foaf:Person> <https://schema.org/foaf:birthday> "07/08/2020" . <https://schema.org/foaf:Person> <https://schema.org/foaf:nickname> "Beth" . <https://schema.org/foaf:Person> <https://schema.org/foaf:age> "37" . <https://schema.org/foaf:Person> <https://schema.org/foaf:interest> <https://schema.org/dbpedia:Marine_biology> 
        `
      },
      {
        no: 2,
        light: progress2,
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
        no: 3,
        light: progress3,
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
        no: 4,
        light: progress4,
        text:
        `undefined
        `,
        goal: `undefined
        `,
        answer: ''
      }
    ],
    drawEdgeFrom: [],
    triples: '',
    ontoTerms: [],
    graphFile: '',
    graphExportName: 'graph.json',
    feedbackTriples: [],
    completedLevels: [],
    locInfo: {}
  }),

  computed: {
    levelLight () {
      return this.levels[this.level - 1].light
    }

  },

  watch: {

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
      const newnode = { id: this.idCount++, x: 400, y: 100, w: 177, h: 55, label: '', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 }, textLocInfo: {} }
      this.nodes.push(newnode)
    },

    addObjectHandler () {
      const newnode = { id: this.idCount++, x: 400, y: 100, w: 150, h: 50, label: '', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} }
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

      // recompute ids to match new node indexes
      this.idCompute(activeNodes)
      // reassign nodes array to only nodes with 'f'
      this.nodes = result
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
      const index = event.target.getAttribute('indexval')

      if (event.target.id === 'unactive') {
        event.target.id = 'active'
        event.target.style.stroke = 'blue'
        event.target.style.strokeWidth = '4'

        // select multiple nodes by giving them an active property
        this.nodes[index].active = 't'
      } else if (event.target.id === 'active') {
        event.target.id = 'unactive'
        event.target.style.stroke = 'black'
        event.target.style.strokeWidth = '2'

        this.nodes[index].active = 'f'
      }
    },

    drawEdgeHandler (node, stage) {
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

    whiteSpaceTrimmer (input) {
      // remove '' whitespace at start of input labels
      return input.replace(/^\s+|\s+$/gm, '')
    },

    labelInputHandler (nodeIndex, newVal) {
      newVal = this.whiteSpaceTrimmer(newVal)
      this.nodes[nodeIndex].label = newVal
    },

    edgeLabelHandler (index, newVal) {
      newVal = this.whiteSpaceTrimmer(newVal)
      this.edges[index].edgeLabel = newVal
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

      this.$set(this.nodes, node.id, newNode) // set node to have displacement on x and y
      this.updateAffectedEdges(Object.assign({}, node, { w: newWidth, h: newHeight, x: x, y: y }))
    },

    storePrefix (name, uri) {
      // add new prefix
      const newPrefix = { name: name, uri: uri }
      this.prefixes.push(newPrefix)
    },

    determinePrefixes () {
    },

    ntriplesConvert () {
      // convert graph to ntriples format
      var catchTriples = ''
      var triple = ''

      // convert prefixes to full uri and append rest of node label
      // surround with <>
      // leave literals as they are

      let a = 0
      let b = 0
      // uri trackers
      let subject = false
      let predicate = false
      let object = false
      for (a in this.edges) {
        // check if last triple lacked uris

        b = 0
        subject = false
        predicate = false
        object = false

        // check if there's a prefix in the node
        for (b in this.prefixes) {
          if (this.edges[a].fromNode.label.includes(this.prefixes[b].name)) {
            subject = true
          }
          if (this.edges[a].edgeLabel.includes(this.prefixes[b].name)) {
            predicate = true
          }
          if (this.edges[a].toNode.label.includes(this.prefixes[b].name)) {
            object = true
          }
        }
        if (subject === false) {
          triple += `<${this.edges[a].fromNode.label}> `
        } else if (subject === true) {
          // strip prefix out of node
          const suffix = this.edges[a].fromNode.label.replace(this.prefixes[b].name, '')
          // push uri version of node
          triple += `<${this.prefixes[b].uri}${suffix}> `
        }
        if (predicate === false) {
          triple += `<${this.edges[a].edgeLabel}> `
        } else if (predicate === true) {
          // strip prefix out of node
          const suffix = this.edges[a].edgeLabel.replace(this.prefixes[b].name, '')
          // push uri version of node
          triple += `<${this.prefixes[b].uri}${suffix}> `
        }
        if (object === false) {
          if (this.edges[a].toNode.label.includes('"')) {
            // literal
            triple += `${this.edges[a].toNode.label} .\n ` // needs linebreak
          } else {
            // fully defined uri
            triple += `<${this.edges[a].toNode.label}> .\n ` // needs linebreak
          }
        } else if (object === true) {
          // strip prefix out of node
          const suffix = this.edges[a].toNode.label.replace(this.prefixes[b].name, '')
          // push uri version of node
          triple += `<${this.prefixes[b].uri}${suffix}> `
        }
      }

      catchTriples = triple

      this.triples = catchTriples
    },

    answerHandler () {
      // check whether answer is correct for current level
      // change to n-triples output format so it matches the answer format
      const result = this.ntriplesConvert()
      if (result.includes(this.levels[this.level].answer)) {
        // correct
        this.success()
      } else {
        // wrong
        this.failure()
      }
    },

    success () {
      this.levelCompletion = { levelNo: this.level, result: 'right' }
      this.level++
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
      if (level === 1) {
        this.nodes.push(
          { id: 0, x: 370, y: 200, w: 177, h: 55, label: 'foaf:Person', active: 'f', toNodes: [], type: 'subject', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 1, x: 10, y: 190, w: 130, h: 50, label: '"Bethany"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 2, x: 20, y: 320, w: 150, h: 50, label: '"07/08/2020"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 3, x: 200, y: 20, w: 110, h: 50, label: '"Beth"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} },
          { id: 4, x: 50, y: 70, w: 60, h: 50, label: '"37"', active: 'f', toNodes: [], type: 'object', displacement: { x: 0, y: 0 }, textLocInfo: {} }
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
      // add a seperator between nodes and edges
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

    feedbackConvert () {
      const catchTriples = []
      // parse graph data in simpler format so it can match a simply written answer
      let x = 0
      for (x in this.edges) {
        catchTriples.push({
          subject: this.edges[x].fromNode.label,
          predicate: this.edges[x].edgeLabel,
          object: this.edges[x].toNode.label
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
      this.feedbackTriples = catchTriples
    },

    emitLocTooltipHandler (loc, nodeId) {
      // this.nodes[nodeId].textLocInfo = loc
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
  width: 15%;
  margin-top: -15px;
}
.box2 {
  display: flexbox;
  /* background-color: green; */
  width: 90%;
  padding-right: 0.5%;
}
#buttons {
  position: absolute;
  display: grid;
  right: 2%;
  margin-top: 10%;
}
/* .over {
  position:absolute;
  top:0;
  left:0;
  right:0;
  bottom:0;
} */
.box3 {
  display: flexbox;
  /* background-color: blue; */
  width: 10%;
  padding-right: 2%;
  margin-top: 110px;
}
body {
  margin: 0;
  padding: 0;
}

#navWrapper {
  height: 5vh;
  padding: 2%;
  margin: 0;
  background-color: #21A0C7;
  color: white;
  margin-bottom: 3%;
}

#nav {
  margin: 0;
  padding: 0;
  /* box-shadow: 0px 2px 5px 1px rgba(172, 172, 172, 0.3); */
}

.textHold {
  text-align: left;
  padding: 10%;
  padding-bottom: 0;
  padding-top: 0;
  padding-left: 3%;
  padding-right: 1%;
  margin-top: 10%;
}

#navInner {
  font-family: 'Montserrat', sans-serif;
  text-align: left;
  font-size: 4vh;
  margin-left: 1%;
  color: white;
}

#tagline {
  color: rgb(33, 46, 49);
  font-size: 1.5vh;
}

#svgContain {
  background-image: url(../assets/grid6.png);
  /* background-size:contain; */
  background-color: white;
  border-radius: 2px;
  margin-top: 2%;
  border: 2px solid rgb(167, 221, 199);
}

#logo {
  padding-top: 0;
  width: 30vh;
  margin-right: 1%;
  float: right;
}

/* #levelWrapper {
  font-size: 20px;
  text-align: left;
  padding: 8%;
  padding-bottom: 0;
  margin-top: 0;
  margin-bottom: 0;
} */

p {
  overflow-wrap:break-word;
}

#masterWrap {
  margin: 0;
  padding: 0;
  word-wrap: break-word;
}
#progressHolder {
  padding: 5%;
  padding-top: 0;
}
#levelButtons {
  margin-left: 85%;
}

</style>
