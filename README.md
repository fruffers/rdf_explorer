# RDF explorer

A VueJS app for teaching users about constructing RDF graphs. Created
by [@fruffers](https://github.com/fruffers) during her 2020 summer
internship at [Epimorphics](https://www.epimorphics.com).

## Using the explorer

  1. Select nodes by clicking on them (they will
        be given a cyan outline).

  2. Deselect nodes by clicking on them again.

  3. Multiple selected nodes can be deleted by pressing
    'bin nodes'.

  4. Double click a node, then double click another node, to
    draw an edge between them.

  5. Drag nodes around to rearrange them.

  6. Delete edges by double clicking on them.

## Project setup

```sh
yarn install
```

### Compiles and hot-reloads for development

```sh
yarn serve
```

### Compiles and minifies for production

```sh
yarn build
```

### Run your unit tests

```sh
yarn test:unit
```

### Lints and fixes files

```sh
yarn lint
```

### Customize configuration

See [Configuration Reference](https://cli.vuejs.org/config/).

### Deployment

The app is deployed to [GitHub pages](https://epimorphics.github.com/rdf_explorer/).
To update the deployment, ensure you don't have any uncommitted changes then run
the `./deploy.sh` Bash script.

**Note**: this script does do some force checkouts to update `gh-pages` branch, so
uncommitted changes in the current branch will be lost. Commit or stash changes
before running the deploy script!
