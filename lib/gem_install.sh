#!/bin/bash

cd "`dirname "$0"`"

# addressable atomic json-schema multipart-post net-http-persistent -v 2.9.4 psych rufus-lru sequel
GEM_HOME=$PWD/gems java -cp jruby-complete-9.1.17.0.jar org.jruby.Main -S gem install ${1+"$@"}
