# Compile ETK on Frontier

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{'where ETK-Compile-Guides is'}/frontier/forDebug"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && chmod a+x GetComponents && ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx-frontier.th
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
