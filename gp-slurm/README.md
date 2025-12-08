# Install CarpetX on gp

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/gp-slurm"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to ${ETKPATH}

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx-gp.th
    ```

## gcc

* Load modules and activate spack env `gcc_12`

    ```bash
    source ${ETKGUIDE}/gcc/Load-Module-CarpetX.sh
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/gcc/gp.cfg -t thornlist/asterx-gp.th --fresh
    ```

## Refs

* read `/home/spack/doc/Readme`

* check `/home/spack/rocky8/var/spack/environments/gcc12/spack.yaml` for installed packages in env `gcc_12`
