#!/bin/bash

(cd ${ETKINSTALL}/Cactus && \
gmake etk options=${ETKDEBUG}/frontier-amd.cfg && \
cp ${ETKDEBUG}/../../ThornList/asterx-frontier.th configs/etk/ThornList && \
gmake -j24 etk && \
)
