# un_pola
DIY instant camera with Open MV and AdaFruit's thermal printer

See more at: http://blog.adacore.com/make-with-ada-diy-instant-camera#sthash.d0LSag5R.dpuf

##  Build instructions

- Make sure to get all the Git submodules:

    ```shell
    # Get Ada_Drivers_Library for un_pola
    $ git submodule init
    $ git submodule update

    # Get embedded-runtimes for Ada_Drivers_Library
    $ cd drivers
    $ git submodule init
    $ git submodule update

    # Build embedded-runtimes
    $ make -C drivers/embedded-runtimes
    ```

- Download and install the [GNAT for ARM package](http://libre.adacore.com/download/configurations)
- Start GNAT Programing Studio
- Open the project file `un_pola.gpr`
- Use the "Build all" button to compile

## Flash the OpenMV

- You will need to connect the OpenMV module to and st-link debugger. Unfortunatly, I don't think this is documented anywhere. I will try to take care of it.
- use the "Flash to board" button to program the OpenMV from GNAT Programing Studio
