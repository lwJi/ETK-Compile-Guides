# Compile ETK on MacOS (Apple Silicon)

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/macos"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx.th
    ```

## gcc (Homebrew GCC 15)

* Compile `AMReX`

    ```bash
    ${ETKGUIDE}/Install-AMReX
    ```

* Compile `ETK`

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/macos.cfg --fresh
    ```

## Run

* Add `SubmitScript` to your path

    ```bash
    export PATH="{path_to_ETK-Compile-Guides}/SubmitScript:$PATH"
    ```

* Copy the example subscript next to your parameter file and adjust the environment setup if needed

    ```bash
    cp ${ETKGUIDE}/../SubmitScript/example/macos/subscript .
    ```

* Run in the foreground (no scheduler): `-m` sets `mpirun -np`, `-o` sets `OMP_NUM_THREADS`, and `-n` must be `1`

    ```bash
    SubmitJobs -n 1 -e ${ETKPATH}/Cactus/exe/cactus_etk -p my.par -m 4 -o 2 -s subscript
    ```

