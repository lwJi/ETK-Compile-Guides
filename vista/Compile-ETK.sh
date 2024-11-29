#!/bin/bash

cd ${ETKPATH}/Cactus

rm std*.log
rm -r configs/etk

gmake etk options=${ETKGUIDE}/vista.cfg && \
cp ${ETKGUIDE}/../ThornList/spacetimex.th configs/etk/ThornList && \
gmake -j24 etk > >(tee stdout.log) 2> >(tee stderr.log)
