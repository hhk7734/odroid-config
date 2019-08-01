#!/bin/sh

do_spi()
{
    DEFAULT=--defaultno
    if [ -e /dev/spidev1* ]; then
        DEFAULT=
    fi

    whiptail --yesno "Would you like the SPI interface to be enabled?" $DEFAULT 20 60
    BUTTON=$?
    if [ $BUTTON -eq 0 ]; then
        if [ -n "$DEFAULT" ]; then
            fdtput -t s /media/boot/exynos5422-odroidxu4.dtb /soc/spi@12d30000 status okay
            ASK_TO_REBOOT=1
            whiptail --msgbox "The SPI interface will be enabled after rebooting." 20 60
        fi
    elif [ $BUTTON -eq 1 ]; then
        if [ -z "$DEFAULT" ]; then
            fdtput -t s /media/boot/exynos5422-odroidxu4.dtb /soc/spi@12d30000 status disabled
            ASK_TO_REBOOT=1
            whiptail --msgbox "The SPI interface will be disabled after rebooting." 20 60
        fi
    fi
}

do_onewire()
{
    DEFAULT=--defaultno
    if lsmod | grep -q w1_; then
        DEFAULT=
    fi

    whiptail --yesno "Would you like the 1-Wire interface to be enabled?" $DEFAULT 20 60
    BUTTON=$?
    if [ $BUTTON -eq 0 ]; then
        modprobe w1_gpio
        modprobe w1_therm
        whiptail --msgbox "The 1-Wire interface is enabled.(After rebooting, it will be disabled)" 20 60
    elif [ $BUTTON -eq 1 ]; then
        modprobe -r w1_gpio
        modprobe -r w1_therm
        whiptail --msgbox "The 1-Wire interface is disabled" 20 60
    fi
}