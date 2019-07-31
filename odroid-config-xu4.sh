#!/bin/sh

do_spi()
{
    DEFAULT=--defaultno
    if lsmod | grep -q spi; then
        DEFAULT=
    fi

    whiptail --yesno "Would you like the SPI interface to be enabled?" $DEFAULT 20 60
    BUTTON=$?
    if [ $BUTTON -eq 0 ]; then
        modprobe spidev
        modprobe spi_s3c64xx
        whiptail --msgbox "The SPI interface is enabled" 20 60
    elif [ $BUTTON -eq 1 ]; then
        modprobe -r spidev
        modprobe -r spi_s3c64xx
        whiptail --msgbox "The SPI interface is disabled" 20 60
    fi
}