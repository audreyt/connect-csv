#!/usr/bin/env lsc -cj
author:
  name: ['Audrey Tang']
  email: 'audreyt@audreyt.org'
name: 'connect-csv'
description: 'Connect middleware for accepting text/csv data type'
version: '0.0.1'
main: \lib/index.js
repository:
  type: 'git'
  url: 'git://github.com/audreyt/connect-csv.git'
scripts:
  test: """
    env PATH="./node_modules/.bin:$PATH" mocha
  """
  prepublish: """
    env PATH="./node_modules/.bin:$PATH" lsc -cj package.ls &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc bin &&
    env PATH="./node_modules/.bin:$PATH" lsc -bc -o lib src
  """
engines: {node: '*'}
dependencies:
  fast-csv: \*
  connect: \*
devDependencies:
  LiveScript: \1.1.x
optionalDependencies: {}
