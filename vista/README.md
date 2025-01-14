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

    ${ETKGUIDE}/gcc-nvcc/Compile-ETK --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/gcc-nvcc/Compile-ETK --help` to display the availible options

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

    ${ETKGUIDE}/gcc/Compile-ETK --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/gcc/Compile-ETK --help` to display the availible options

## nvc + nvcc

* Load Modules

    ```bash
    source ${ETKGUIDE}/nvc-nvcc/Load-Module-CarpetX
    ```

* Install `amrex` to `${ETKPATH}/amrex-lib-nvc-nvcc`

    ```bash
    ${ETKGUIDE}/nvc-nvcc/Install-AMReX
    ```

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

    ${ETKGUIDE}/nvc/Compile-ETK --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/nvc/Compile-ETK --help` to display the availible options

## submit runs

* please use the parfile and submit script in `example` to reproduce the error

```
sbatch sub-gpu
```


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
