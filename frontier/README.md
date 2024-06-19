# Compile CarpetX on Frontier

* Download CarpetX, SpacetimeX and AsterX

    ```bash
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents
    chmod a+x GetComponents
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx-frontier.th
    ```

* Note that you need to use the `eschnett/crusher` branch of the `flesh`. And you need to run `git merge master` locally to make it work with current version of `CarpetX`.


## The Short Way

### AMD

#### cce15.0.0-rocm6.0

* Install

    ```bash
    source ETK-Compile-Guides/frontier/Load-Module-CarpetX-cce15-rocm6.0-amd.sh
    cd Cactus
    gmake AsterX options=ETK-Compile-Guides/frontier/configs/frontier-amd.cfg
    cp ETK-Compile-Guides/ThornList/asterx-frontier.th configs/AsterX/ThornList
    gmake -j24 AsterX
    ```

#### cce17.0.0-rocm6.0 (not working with GPU-aware-MPI)

* Install

    ```bash
    source ETK-Compile-Guides/frontier/Load-Module-CarpetX-cce17-rocm6.0-amd.sh
    cd Cactus
    gmake AsterX options=ETK-Compile-Guides/frontier/configs/frontier-amd.cfg
    cp ETK-Compile-Guides/ThornList/asterx-frontier.th configs/AsterX/ThornList
    gmake -j24 AsterX
    ```

### CRAY

#### cce17.0.0-rocm6.0




## The Long Way

### Compile AMReX

* Install `amrex` to `$HOME/local/amrex24.06-rocm6.0-cce15-amd-gpumpi`

    ```bash
    git clone https://github.com/AMReX-Codes/amrex.git

    cd amrex
    mkdir build && cd build
    
    source ETK-Compile-Guides/frontier/amrex/amd/Load-Module-AMReX.sh
    source ETK-Compile-Guides/frontier/amrex/amd/Export-AMReX.sh
    source ETK-Compile-Guides/frontier/amrex/amd/Compile-AMReX.sh
    
    make -j24 install
    ```

    - modify `Compile-AMReX.sh` if you want to install `amrex` somewhere else.

* Modify `ETK-Compile-Guides/frontier/configs/frontier-amd.cfg` to use your own `amrex` library.

### Compile AsterX

* Install AsterX as in The Short Way
