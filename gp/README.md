# Install CarpetX on gp

* Download repo

    ```bash
    git clone https://github.com/lwJi/ETK-Compile-Guides.git
    ```

* Set env variable

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/gp"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

* Load spack

    ```bash
    . ~spack/newspack/share/spack/setup-env.sh
    spack env list
    spack env activate etk_gcc_13
    ```
