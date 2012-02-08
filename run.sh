#!/bin/bash

set -e
coffee -c app.coffee
coffee -c model/*.coffee
echo "About to start"
pwd
node ./app.js
