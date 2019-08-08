#!/bin/sh

do_spi()
{
    DEFAULT=--defaultno
    if exist_in "/dev/" "spidev*"; then
        DEFAULT=
    fi

    whiptail --yesno "Would you like the SPI interface to be enabled?" $DEFAULT 20 60
    BUTTON=$?
    if [ $BUTTON -eq 0 ]; then
        if [ -n "$DEFAULT" ]; then
            config_setting spidev enable
            config_setting spicc enable
            whiptail --msgbox "The SPI interface is enabled." 20 60
        fi
    elif [ $BUTTON -eq 1 ]; then
        if [ -z "$DEFAULT" ]; then
            config_setting spidev disalbe
            config_setting spicc disable
            whiptail --msgbox "The SPI interface is disabled." 20 60
        fi
    fi
}


do_i2c()
{
    DEFAULT=--defaultno
    if exist_in "/dev/" "i2c*"; then
        DEFAULT=
    fi

    whiptail --yesno "Would you like the I2C interface to be enabled?" $DEFAULT 20 60
    BUTTON=$?
    if [ $BUTTON -eq 0 ]; then
        if [ -n "$DEFAULT" ]; then
            config_setting aml_i2c enable
            whiptail --msgbox "The I2C interface is enabled." 20 60
        fi
    elif [ $BUTTON -eq 1 ]; then
        if [ -z "$DEFAULT" ]; then
            config_setting aml_i2c disalbe
            whiptail --msgbox "The I2C interface is disabled." 20 60
        fi
    fi
}

do_onewire()
{
    DEFAULT=--defaultno
    if exist_in "/sys/bus/w1/devices/" "w1_bus*"; then
        DEFAULT=
    fi

    whiptail --yesno "Would you like the 1-Wire interface to be enabled?" $DEFAULT 20 60
    BUTTON=$?
    if [ $BUTTON -eq 0 ]; then
        if [ -n "$DEFAULT" ]; then
            config_setting w1-gpio enable
            config_setting w1-therm enable
            whiptail --msgbox "The I2C interface is enabled." 20 60
        fi
    elif [ $BUTTON -eq 1 ]; then
        if [ -z "$DEFAULT" ]; then
            config_setting w1-gpio disable
            config_setting w1-therm disable
            whiptail --msgbox "The I2C interface is disabled." 20 60
        fi
    fi
}