# Compile ETK on Vista

* Hostname (username is the same as the one used on Frontera)

    ```bash
    vista.tacc.utexas.edu
    ```

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/vista"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx.th
    ```

* If you are using nvc compilers, please use the following branch `rhass/nvhpc` for CarpetX.

## nvc + nvcc

* Load Modules

    ```bash
    source ${ETKGUIDE}/nvc-nvcc/Load-Module-CarpetX
    ```

* Install `amrex` to `${ETKPATH}/amrex-lib-nvc-nvcc`

    ```bash
    ${ETKGUIDE}/nvc-nvcc/Install-AMReX
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/nvc-nvcc/vista.cfg --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/../CompileScript/Compile-ETK --help` to display the availible options

## nvc (for gg)

* Load Modules

    ```bash
    source ${ETKGUIDE}/nvc/Load-Module-CarpetX
    ```

* Install `amrex` to `${ETKPATH}/amrex-lib-nvc`

    ```bash
    ${ETKGUIDE}/nvc/Install-AMReX
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/nvc/vista.cfg --fresh
    ```

## gcc + nvcc

* Load Modules

    ```bash
    source ${ETKGUIDE}/gcc-nvcc/Load-Module-CarpetX.sh
    ```

* Compile `AMReX`

    ```bash
    ${ETKGUIDE}/gcc-nvcc/Install-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/gcc-nvcc/vista.cfg --fresh
    ```

## gcc (for gg)

* Load Modules

    ```bash
    source ${ETKGUIDE}/gcc/Load-Module-CarpetX.sh
    ```

* Compile `AMReX`

    ```bash
    ${ETKGUIDE}/gcc/Install-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/gcc/vista.cfg --fresh
    ```

## submit runs

* Add a line
    ```bash
    source {your_compiler}/Load-Module-CarpetX.sh
    ```
    to file `${ETKGUIDE}/../SubmitScript/subscript-baremetal`

* run the following to submit a job

    ```bash
    ${ETKGUIDE}/../SubmitScript/SubmitJobs -n 5 -e /path/to/executable -p params.par -N 4 -m 8 -o 2 -t 02:00:00 -q high_priority -a my_project -s ${ETKGUIDE}/../SubmitScript/subscript-baremetal
    ```

    - run `${ETKGUIDE}/../SubmitScript/SubmitJobs --help` for available options


## notes about the machine

### NVIDIA Compilers

* [Documentatiion](https://docs.nvidia.com/hpc-sdk//index.html)

#### Architecture-Specific Flags

* CPU used Neovers V2 cores (include `-tp neoverse-v2` compile option)
    - support Arm's Scalable Vector Extension v2(SVE2)
    - advanced SIMD(NEON) technologies
    - each core has four 128-bit functional units that support 8 64-bit FMA operations.
* It's safe to use `-fast` option with the NVIDIA compilers
* The env variable `$TACC_VEC_FLAGS` sets
    - `-Mvect=simd -fast -Mipa=fast,inline`


#### NVIDIA Performance Libraries (NVPL)

a collection of high-performance mathematical libaraires optimized for the NVIDIA Grace
Armv9.0 architecture (CPU-only)

* [documentaion](https://docs.nvidia.com/nvpl/)

### GNU Compilers

* The env variable `$TACC_VEC_FLAGS` sets
    - `-O3 -mcpu-neoverse-v2`


## Todo
 - [ ] make nvhpc work
