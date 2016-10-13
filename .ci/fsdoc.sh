#!/bin/bash

# Script to run fsdoc on certain dirs in the FStar repo.
# Currently, gets called by the VSTF "FStar, Docs, Linux, CI" build. 
set -x

echo Running fsdoc in `pwd`

# SI: we assume F* has been built and is in the path.

# make the output dir
FSDOC_ODIR=fsdoc_odir
mkdir -p "$FSDOC_ODIR"

# fsdoc ulib/*.fst* 
pushd ulib
# Get fst, fsti files (files are sorted by default). 
FST_FILES=(*.fst *.fsti)
../bin/fstar-any.sh --odir "../$FSDOC_ODIR" --doc ${FST_FILES[*]} 
popd

# pandoc : md -> html
pushd $FSDOC_ODIR 
for f in "${FST_FILES[@]}"
do
    fe=`basename $f` # SI: should just be able to strip -s md if fsdoc outputs X.fst.md. 
    f="${fe%.*}"     #
    md="${f}.md"
    html="${f}.html"
    pandoc $md -f markdown -t html -o $html
done
popd

# push fstarlang.github.io with latest html
git clone https://github.com/FStarLang/fstarlang.github.io
pushd fstarlang.github.io
pushd docs
mv "../../$FSDOC_ODIR"/*.html .
git commit -am "Automated doc refresh"
git push 
popd
popd
rm -rf fstarlang

# SI: could cleanup FSDOC_ODIR too.


