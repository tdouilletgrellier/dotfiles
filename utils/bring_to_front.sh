#!/bin/bash

if [ $(wmctrl -xl | grep -c "$2") != 0 ]; then
	wmctrl -xa "$2"
else
	$1 &
fi
