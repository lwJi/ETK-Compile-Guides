#!/bin/bash

cd ${WORK}/Laudau/Cactus

rm std*.log
rm -rf configs/etk-nvhpc

gmake etk-nvhpc options=${ETKGUIDE}/nvhpc/vista.cfg && \
cp thornlists/spacetimex.th configs/etk-nvhpc/ThornList && \
gmake -j24 etk-nvhpc > >(tee std.log) 2>&1
#gmake -j24 etk-nvhpc 2> >(tee stderr.log >&2) | tee stdout.log
