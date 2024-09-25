# Compile CarpetX on Frontier

* Download CarpetX, SpacetimeX and AsterX

    ```bash
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents
    chmod a+x GetComponents
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/asterx-frontier.th
    ```

* If you are setting `EXTERNAL_FOO` in you `cfg` file (say the `frontier.cfg` file in simfactory), you need to use the `eschnett/crusher` branch of the `flesh`, and you need to run `git merge master` locally to make it work with current version of `CarpetX`.


## Compile AMReX

* Install `amrex` to `$HOME/local/amrex`

    ```bash
    mkdir $HOME/local/amrex  # this is the installation place

    cd $HOME  # here we put the amrex source code
    git clone https://github.com/AMReX-Codes/amrex.git
    ```
    replace `inline bool UseGpuAwareMpi () { return use_gpu_aware_mpi; }`
    with `inline bool UseGpuAwareMpi () { return true; }`
    on line 111 in `Src/Base/AMReX_ParallelDescriptor.H` to turn on GPU-aware-MPI by default

    ```
    cd amrex
    mkdir build && cd build
    
    source ETK-Compile-Guides/frontier/amrex/Load-Module-AMReX.sh
    source ETK-Compile-Guides/frontier/amrex/amd/Export-AMReX.sh
    source ETK-Compile-Guides/frontier/amrex/amd/Compile-AMReX.sh
    
    make -j24 install
    ```

    - modify `Compile-AMReX.sh` if you want to install `amrex` somewhere else.

* Modify `ETK-Compile-Guides/frontier/configs/frontier-amd.cfg` to use your own `amrex` library.


## Compile ETK

* Install

    ```bash
    source ETK-Compile-Guides/frontier/Load-Module-CarpetX.sh
    cd Cactus
    gmake etk options=ETK-Compile-Guides/frontier/configs/frontier-amd.cfg
    cp ETK-Compile-Guides/ThornList/asterx-frontier.th configs/etk/ThornList
    gmake -j24 etk
    ```

