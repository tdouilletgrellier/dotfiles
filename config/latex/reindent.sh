#!/bin/bash
# NOTE : Quote it else use array to avoid problems #
FILES="*.tex"
for f in $FILES
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  latexindent -w -s $f
done