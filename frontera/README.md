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
    source ${ETKGUIDE}/oneapi/Load-Module-CarpetX
    ```

* Compile `AMReX`

    ```bash
    ${ETKGUIDE}/oneapi/Install-AMReX
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/oneapi/frontera.cfg --fresh
    ```
    - type `yes` when it ask 'Setup configuration etk'
    - run `${ETKGUIDE}/../CompileScript/Compile-ETK --help` to display the availible options

## gcc + nvcc

* To be set

## submit runs

* please use the parfile and submit script in `example` to reproduce the error

```
sbatch sub-gpu
```
