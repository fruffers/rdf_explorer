#!/usr/bin/env sh
# abort on errors
set -e

# set the NODE_ENV to production, unless overridden by an existing
# environment variable
export NODE_ENV=${NODE_ENV:-production}
echo "Deploying rdf_explorer in ${NODE_ENV} to GitHub pages ..."

# remember which branch we're on at the moment
current_branch=`git branch --show-current`

# build the project into ./dist
yarn build

# to deploy to GH pages, we push the content of the `dist` directory
# to the `gh-pages` git branch

git checkout --orphan gh-pages
git --work-tree dist add --all
git --work-tree dist commit -m "gh-pages"
git push origin HEAD:gh-pages --force

# # cleanup
git checkout -f $current_branch
git branch -D gh-pages

echo "Done."
