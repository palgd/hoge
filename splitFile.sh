#!/bin/bash

bn=`basename $0`;

if [ $bn == "div" ]; then
	for f in $@
  do
    java -cp /Users/pal_ty/Documents/splitworkspace/SplitFile/bin splitFile.Div $f
  done
fi

if [ $bn == "un-div" ]; then
  for f in $@
	do
    java -cp /Users/pal_ty/Documents/splitworkspace/SplitFile/bin splitFile.UnDiv $f
  done
fi

if [ $bn == "div-cat" ]; then
  for f in $@
  do
    java -cp /Users/pal_ty/Documents/splitworkspace/SplitFile/bin splitFile.DivCat $f
  done
fi

if [ $bn == "div-out" ]; then
  for f in $@
  do
    java -cp /Users/pal_ty/Documents/splitworkspace/SplitFile/bin splitFile.DivOut $f
  done
fi

if [ $bn == "div-cp" ]; then
  #for f in $@
  #do
  java -cp /Users/pal_ty/Documents/splitworkspace/SplitFile/bin splitFile.DivCopy $1 $2
  #done
fi
