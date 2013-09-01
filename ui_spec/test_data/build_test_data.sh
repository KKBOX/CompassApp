#!/bin/bash

ORIGIN_DIR=$(pwd)
BASE_DIR=$(dirname $0)

IMAGES_DIR="images"
SASS_DIR="sass"
SASS_FILE="$SASS_DIR/swt_test.scss"

relative_assets=(enable disable)
line_comments=(enable disable)
debug_info=(enable disable)
output_style=(compact compressed expanded nested)


for r in ${relative_assets[@]}; do
  for l in ${line_comments[@]}; do
    for d in ${debug_info[@]}; do
      for o in ${output_style[@]}; do
        CSS_DIR="${r}_relative_assets/${l}_line_comments/${d}_debug_info/$o"
        SRC_DIR="$CSS_DIR/../$SASS_DIR"
        mkdir -p "$BASE_DIR/$SRC_DIR"
        cp "$BASE_DIR/$SASS_FILE" "$BASE_DIR/$SRC_DIR"

        options=""
        if [ "$r" == "enable" ]; then
          options="$options --relative-assets"
        fi
        if [ "$l" == "disable" ]; then
          options="$options --no-line-comments"
        fi
        if [ "$d" == "enable" ]; then
          options="$options --debug-info"
        fi
        options="$options --output-style $o "

        echo $CSS_DIR
        #mkdir -p "$CSS_DIR"
        compass compile $BASE_DIR --css-dir $CSS_DIR --sass-dir $SRC_DIR $options --quiet
      done
    done
  done
done

