# Compile ETK on Frontier

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKDEBUG="{'where ETK-Compile-Guides is'}/frontier/forDebug"
    export ETKINSTALL="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKINSTALL}`

    ```bash
    mkdir ${ETKINSTALL} && cd ${ETKINSTALL} && curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && chmod a+x GetComponents && ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx-frontier.th
    ```

* Load Modules

    ```bash
    source ${ETKDEBUG}/Load-Module-CarpetX.sh
    ```

* Install `amrex` to `${ETKINSTALL}/amrex-lib`

    ```bash
    source ${ETKDEBUG}/Compile-AMReX.sh
    ```

* Compile `ETK`

    ```bash
    source ${ETKDEBUG}/Compile-ETK.sh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - remove the whole dir `${ETKINSTALL}/Cactus/configs/etk` if you want to recompile
        ```bash
        rm -rf ${ETKINSTALL}/Cactus/configs/etk
        ```

## submit runs

* please use the parfile and submit script in `example` to reproduce the error

```
sbatch sub-gpu
```
