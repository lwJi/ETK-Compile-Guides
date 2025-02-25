# Compile ETK on Frontier

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/frontier"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx-frontier.th
    ```

## amd

* Load Modules

    ```bash
    source ${ETKGUIDE}/amd/Load-Module-CarpetX
    ```

* Install `amrex` to `${ETKPATH}/amrex-amd`

    ```bash
    ${ETKGUIDE}/amd/Install-AMReX
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/amd/frontier.cfg -t thornlists/asterx-frontier.th --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/../CompileScript/Compile-ETK --help` to display the availible options


## cray

* Load Modules

    ```bash
    source ${ETKGUIDE}/cray/Load-Module-CarpetX
    ```

* Install `amrex` to `${ETKPATH}/amrex-cray`

    ```bash
    ${ETKGUIDE}/cray/Install-AMReX
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/cray/frontier.cfg -t thornlists/asterx-frontier.th --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/../CompileScript/Compile-ETK --help` to display the availible options


## submit runs

* please use the parfile and submit script in `example` to reproduce the error

```
sbatch sub-gpu
```

## notes about the machine

### Workaround when turn on GPU-aware-MPI

* for `cray-mpich/8.1.28` or `cray-mpich/8.1.29` use

    ```bash
    export GTL_HSA_MAX_IPC_CACHE_SIZE=1000
    ```

* for `cray-mpich/8.1.30` use

    ```bash
    export MPICH_GPU_IPC_CACHE_MAX_SIZE=1000
    ```
