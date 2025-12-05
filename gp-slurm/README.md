# Install CarpetX on gp

read `/home/spack/doc/Readme`

check `/home/spack/rocky8/var/spack/environments/gcc12/spack.yaml`

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/gp"
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

* Load spack

    ```bash
    . ~spack/newspack/share/spack/setup-env.sh
    spack env list
    spack env activate etk_gcc_13
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/gcc/Compile-ETK --fresh
    ```
