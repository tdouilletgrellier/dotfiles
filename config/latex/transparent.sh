#!/bin/bash
# NOTE : Quote it else use array to avoid problems #
FILES="*.png"
for f in $FILES
do
  echo "Processing $f file..."

  f2="${f/.png/""}"
  # take action on each file. $f store current file name
  convert $f -fuzz 2% -transparent white $f2"t.png"

done