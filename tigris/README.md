# Compile ETK on Tigris (RIT)

* Hostname (RIT Research Computing account)

    ```bash
    tigris.rc.rit.edu
    ```

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/tigris"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx.th
    ```

## gcc13 + nvcc (GH200)

* Load Modules

    ```bash
    source ${ETKGUIDE}/gcc13-nvcc/Load-Module-CarpetX
    ```

    - tigris has no TACC-style modules; this sets paths to the central Spack
      installs directly (see [notes](#spack-environment) for why `spack load`
      is not used)

* Compile `AMReX` (installs to `${ETKPATH}/amrex-lib-gcc13-nvcc`)

    ```bash
    ${ETKGUIDE}/gcc13-nvcc/Install-AMReX
    ```

* Compile `Silo` (installs to `${ETKPATH}/silo-lib-gcc13`)

    ```bash
    cd ${ETKPATH}
    ${ETKGUIDE}/gcc13-nvcc/Install-Silo         # argument = parallel jobs (default 2)
    ```

    - builds the Silo tarball shipped in `ExternalLibraries/Silo/dist` with the
      MPI wrappers; `tigris.cfg` points `SILO_DIR` at it. `Silo=BUILD` do not 
      work in tigris.

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/gcc13-nvcc/tigris.cfg --fresh
    ```
