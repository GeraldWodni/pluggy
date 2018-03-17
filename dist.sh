#!/bin/bash
# minimize content

CONTENT="content/"
DIST="dist/"

mkdir -p $DIST

for HTML in `ls -1 $CONTENT*.html`; do
    FILE=${HTML:8}
    html-minifier --collapse-whitespace --remove-tag-whitespace --remove-comments $HTML -o $DIST$FILE
done

for CSS  in `ls -1 $CONTENT*.css`;  do
    FILE=${CSS:8}
    cleancss -o $DIST$FILE $CSS
done

for JS   in `ls -1 $CONTENT*.js`;   do
    FILE=${JS:8}
    uglifyjs -o $DIST$FILE $JS
done
