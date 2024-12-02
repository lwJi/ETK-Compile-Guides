# ETK-Compile-Guides

## `gmake` options

* Clean compilation files

    ```
    gmake <config>-clean
    gmake <config>-realclean
    ```

* Reconfig after modifying `config-info`

    ```
    gmake <config>-reconfig options=<cfgfile>
    ```

* Only compile AMReX

    ```
    gmake -j24 <config>-build BUILDLIST=AMReX
    ```

* Verbose

    ```
    gmake -j8 <config> VERBOSE=yes
    ```
