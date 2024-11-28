#!/bin/bash

cd ${ETKPATH}/Cactus && \
gmake etk options=${ETKGUIDE}/vista.cfg && \
cp ${ETKGUIDE}/../../ThornList/spacetimex.th configs/etk/ThornList && \
gmake -j24 etk
