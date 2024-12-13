# Compile ETK on Frontera

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/frontera"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx.th
    ```

## oneapi
* Load Modules

    ```bash
    source ${ETKGUIDE}/oneapi/Load-Module-CarpetX.sh
    ```

* Compile `AMReX`

    ```bash
    source ${ETKGUIDE}/oneapi/Install-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/oneapi/Compile-ETK --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/oneapi/Compile-ETK --help` to display the availible options

## gcc + nvcc

* Install `amrex` to `${ETKPATH}/nvcc/amrex-lib`

    ```bash
    ${ETKGUIDE}/nvcc/Compile-AMReX.sh
    ```


## submit runs

* please use the parfile and submit script in `example` to reproduce the error

```
sbatch sub-gpu
```
