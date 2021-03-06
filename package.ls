#!/usr/bin/env lsc -cj
author:
  name: ['Audrey Tang']
  email: 'audreyt@audreyt.org'
name: 'connect-csv'
keywords: <[ connect middleware csv ]>
description: 'Connect middleware for accepting text/csv data type'
version: '0.1.0'
main: \lib/index.js
repository:
  type: 'git'
  url: 'git://github.com/audreyt/connect-csv.git'
scripts:
  test: """
    env PATH="./node_modules/.bin:$PATH" mocha
  """
  precompile: """
    (node node_modules/LiveScript/bin/lsc -cj package.ls || echo) && (node node_modules/LiveScript/bin/lsc -c index.ls || echo)
  """
engines: {node: '*'}
dependencies:
  connect: \3.x.x
  'csv-parse': \0.0.6
  'type-is': \1.3.x
devDependencies:
  LiveScript: \1.2.x
optionalDependencies: {}
