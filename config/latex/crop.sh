#!/bin/bash
# NOTE : Quote it else use array to avoid problems #
FILES="*.png"
for f in $FILES
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  convert -trim $f $f
done