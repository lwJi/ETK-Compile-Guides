#!/bin/bash

cd ${ETKPATH}/Cactus

rm std*.log
rm -rf configs/etk

gmake etk options=${ETKGUIDE}/vista.cfg && \
cp thornlists/spacetimex.th configs/etk/ThornList && \
gmake -j24 etk > >(tee std.log) 2>&1
#gmake -j24 etk 2> >(tee stderr.log >&2) | tee stdout.log
