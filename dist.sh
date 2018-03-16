#!/bin/bash
# minimize content

CONTENT="content/"
DIST="dist/"

mkdir -p $DIST

for HTML in `ls -1 $CONTENT*.html`; do
    FILE=${HTML:8}
    html-minifier --collapse-whitespace --remove-tag-whitespace --remove-comments $HTML -o $DIST$FILE
done
