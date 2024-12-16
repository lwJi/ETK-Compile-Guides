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
    source ${ETKGUIDE}/amd/Load-Module-CarpetX.sh
    ```

* Install `amrex` to `${ETKPATH}/amrex-lib`

    ```bash
    source ${ETKGUIDE}/amd/Install-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/amd/Compile-ETK --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/Compile-ETK --help` to display the availible options

## cray

* Load Modules

    ```bash
    source ${ETKGUIDE}/cray/Load-Module-CarpetX.sh
    ```

* Install `amrex` to `${ETKPATH}/amrex-lib`

    ```bash
    source ${ETKGUIDE}/cray/Install-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/cray/Compile-ETK --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/Compile-ETK --help` to display the availible options

* Install `amrex` to `${ETKPATH}/amrex-lib`

## submit runs

* please use the parfile and submit script in `example` to reproduce the error

```
sbatch sub-gpu
```
