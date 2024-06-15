# Compile CarpetX on Frontier

* Download CarpetX and SpacetimeX

    ```bash
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents
    chmod a+x GetComponents
    ./GetComponents --root Cactus --parallel --no-shallow https://github.com/EinsteinToolkit/SpacetimeX/blob/main/Docs/thornlist/asterx-frontier.th
    ```

## The Short Way


### cce-17.0.0 (amrex-24.06)

* Load modules

    ```bash
    source ETK-Compile-Guides/frontier/Load-Module-CarpetX-cce17-amd.sh
    ```

* Install AsterX

    ```bash
    cd Cactus
    gmake AsterX options=ETK-Compile-Guides/frontier/configs/frontier-amd.cfg
    cp ETK-Compile-Guides/ThornList/asterx-frontier.th configs/AsterX/ThornList
    gmake -j24 AsterX
    ```


### cce-15.0.0 (amrex-23.06)

* Load modules

    ```bash
    source ETK-Compile-Guides/frontier/Load-Module-CarpetX-cce15.sh
    ```

* Install AsterX

    ```bash
    cd Cactus
    gmake AsterX options=simfactory/mdb/optionlists/frontier.cfg
    cp ETK-Compile-Guides/ThornList/asterx-frontier.th configs/AsterX/ThornList
    gmake -j24 AsterX
    ```



## The Long Way

### Compile AMReX

* Clone `amrex`

    ```bash
    git clone https://github.com/AMReX-Codes/amrex.git
    ```

* Install `amrex` to `$HOME/local/amrex-24.06`

    ```bash
    cd amrex
    mkdir build
    cd build
    
    source ETK-Compile-Guides/frontier/amrex/amd/Load-Module-AMReX.sh
    source ETK-Compile-Guides/frontier/amrex/amd/Export-AMReX.sh
    source ETK-Compile-Guides/frontier/amrex/amd/Compile-AMReX.sh
    
    make -j24 install
    ```

    It will install `amrex` library to `${HOME}/local/amrex-24.06-amd`.

* Modify `frontier-amd.cfg` to use your own `amrex` library.
