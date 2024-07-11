#!/bin/bash
# NOTE : Quote it else use array to avoid problems #
FILES="*.avi"
for f in $FILES
do
  echo "Processing $f file..."
  filename="${f%.*}"
  # take action on each file. $f store current file name
  ffmpeg -i $f -vf "fps=10,scale=1080:-1:flags=lanczos" -c:v pam \
    -f image2pipe - | \
    convert -delay 10 - -loop 0 -layers optimize $filename.gif

  mkdir -p $filename

  convert -coalesce $filename.gif $filename/$filename.png  

done