#! /bin/bash

test -d "${chart_name}" || exit 
helm lint ${chart_name}