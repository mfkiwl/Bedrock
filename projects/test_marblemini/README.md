# Marble1

Initial programming support for [Marble Mini hardware](https://github.com/BerkeleyLab/Marble-Mini).
The Marble.xdc file here is the one generated by a script in that repository.

Infrastructure provided by [Bedrock](https://github.com/BerkeleyLab/Bedrock).

Currently tested successful at booting a bitfile (using [openocd](http://openocd.org/)),
bringing up Ethernet (default 192.168.19.8), blinking LEDs,
and reading/writing/booting SPI Flash (using Bedrock's spi_test.py).
There's a trivial utility (mutil) that documents common operations,
and [instructions](bringup.txt) for initial FPGA/Flash programming.
Also see the [todo list](todo).

The [i2cbridge code](i2cbridge/README) here is meant to be general-purpose,
but hadn't been hardware-verified or published before this.

Top-level needs more automated regression testing.  Concept for testing in simulation:

    make net_slave_run &
    python testcase.py --sim --ramtest --stop
    make lb_marble_slave_view

and then with hardware, blinking LEDs and viewing bit-flicker on IN219 chips:

    ./mutil usb
    python testcase.py --vcd=capture.vcd
    gtkwave capture.vcd
    python testcase.py --poll --rlen=48

where, among other things, the high-order bit of the 32nd word is likely to tell
you the status of the write-protect switch: 255 (write-enabled) or 127 (write-protected).