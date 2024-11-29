# Compile ETK on Vista

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/vista"
    export ETKPATH="$WORK/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/spacetimex.th
    ```

* Load Modules

    ```bash
    source ${ETKGUIDE}/Load-Module-CarpetX.sh
    ```

* Install `amrex` to `${ETKPATH}/amrex-lib`

    ```bash
    source ${ETKGUIDE}/Compile-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    source ${ETKGUIDE}/Compile-ETK.sh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - remove the whole dir `${ETKPATH}/Cactus/configs/etk` if you want to recompile
        ```bash
        rm -rf ${ETKPATH}/Cactus/configs/etk
        ```

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
