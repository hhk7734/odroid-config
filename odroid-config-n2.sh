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
        modprobe spi_meson_spicc
        whiptail --msgbox "The SPI interface is enabled" 20 60
    elif [ $BUTTON -eq 1 ]; then
        modprobe -r spidev
        modprobe -r spi_meson_spicc
        whiptail --msgbox "The SPI interface is disabled" 20 60
    fi
}

do_i2c()
{
    I2C_2=OFF
    if [ -e /dev/i2c-2 ]; then
        I2C_2=ON
    fi

    I2C_3=OFF
    if [ -e /dev/i2c-3 ]; then
        I2C_3=ON
    fi

    OPTION=$(whiptail --title "ODROID Configuration Tool" \
        --backtitle "$DEVICE" \
        --checklist "Select the I2C interfaces to be enabled.(using the space bar)" "$WT_HEIGHT" "$WT_WIDTH" "$WT_MENU_HEIGHT" \
        "1 /dev/i2c-2" "Enable/Disable the I2C-2 interface." "$I2C_2"\
        "2 /dev/i2c-3" "Enable/Disable the I2C-3 interface." "$I2C_3"\
        3>&1 1>&2 2>&3)
    BUTTON=$?
    if [ $BUTTON -eq 1 ]; then
        # Cancel
        return 0
    elif [ $BUTTON -eq 0 ]; then
        # Ok
        CHANGE=1
        case "$OPTION" in
            *i2c-2*i2c-3*)
                if [ "$I2C_2" != ON ] || [ "$I2C_3" != ON ]; then
                    I2C_2=ON && I2C_3=ON && CHANGE=0
                fi
                ;;
            *i2c-2*)
                if [ "$I2C_2" != ON ] || [ "$I2C_3" != OFF ]; then
                    I2C_2=ON && I2C_3=OFF && CHANGE=0
                fi
                ;;
            *i2c-3*)
                if [ "$I2C_2" != OFF ] || [ "$I2C_3" != ON ]; then
                    I2C_2=OFF && I2C_3=ON && CHANGE=0
                fi
                ;;
            "")
                if [ "$I2C_2" != OFF ] || [ "$I2C_3" != OFF ]; then
                    I2C_2=OFF && I2C_3=OFF && CHANGE=0
                fi
                ;;
            *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 ;;
        esac || whiptail --msgbox "There was an error running option $OPTION" 20 60

        if [ "$CHANGE" -eq 0 ]; then
            fdtput -t s /media/boot/meson64_odroidn2.dtb /soc/cbus@ffd00000/i2c@1d000 status "$([ "$I2C_2" = ON ] && echo okay || echo disabled)"
            fdtput -t s /media/boot/meson64_odroidn2.dtb /soc/cbus@ffd00000/i2c@1c000 status "$([ "$I2C_3" = ON ] && echo okay || echo disabled)"
            ASK_TO_REBOOT=1
            whiptail --msgbox "The I2C-2 interface is $([ "$I2C_2" = ON ] && echo enabled || echo disabled).\n\
The I2C-3 interface is $([ "$I2C_3" = ON ] && echo enabled || echo disabled)." 20 60
        fi
    fi
}

do_serial()
{
    SERIAL_1=OFF
    if [ -e /dev/ttyS1 ]; then
        SERIAL_1=ON
    fi

    SERIAL_2=OFF
    if [ -e /dev/ttyS2 ]; then
        SERIAL_2=ON
    fi

    OPTION=$(whiptail --title "ODROID Configuration Tool" \
        --backtitle "$DEVICE" \
        --checklist "Select the serial(UART) interfaces to be enabled.(using the space bar)" "$WT_HEIGHT" "$WT_WIDTH" "$WT_MENU_HEIGHT" \
        "1 /dev/ttyS1" "Enable/Disable the serial1 interface." "$SERIAL_1"\
        "2 /dev/ttyS2" "Enable/Disable the serial2 interface." "$SERIAL_2"\
        3>&1 1>&2 2>&3)
    BUTTON=$?
    if [ $BUTTON -eq 1 ]; then
        # Cancel
        return 0
    elif [ $BUTTON -eq 0 ]; then
        # Ok
        CHANGE=1
        case "$OPTION" in
            *ttyS1*ttyS2*)
                if [ "$SERIAL_1" != ON ] || [ "$SERIAL_2" != ON ]; then
                    SERIAL_1=ON && SERIAL_2=ON && CHANGE=0
                fi
                ;;
            *ttyS1*)
                if [ "$SERIAL_1" != ON ] || [ "$SERIAL_2" != OFF ]; then
                    SERIAL_1=ON && SERIAL_2=OFF && CHANGE=0
                fi
                ;;
            *ttyS2*)
                if [ "$SERIAL_1" != OFF ] || [ "$SERIAL_2" != ON ]; then
                    SERIAL_1=OFF && SERIAL_2=ON && CHANGE=0
                fi
                ;;
            "")
                if [ "$SERIAL_1" != OFF ] || [ "$SERIAL_2" != OFF ]; then
                    SERIAL_1=OFF && SERIAL_2=OFF && CHANGE=0
                fi
                ;;
            *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 ;;
        esac || whiptail --msgbox "There was an error running option $OPTION" 20 60

        if [ "$CHANGE" -eq 0 ]; then
            fdtput -t s /media/boot/meson64_odroidn2.dtb /serial@ffd24000 status "$([ "$SERIAL_1" = ON ] && echo okay || echo disabled)"
            fdtput -t s /media/boot/meson64_odroidn2.dtb /serial@ffd23000 status "$([ "$SERIAL_2" = ON ] && echo okay || echo disabled)"
            ASK_TO_REBOOT=1
            whiptail --msgbox "The serial1 interface is $([ "$SERIAL_1" = ON ] && echo enabled || echo disabled).\n\
The serial2 interface is $([ "$SERIAL_2" = ON ] && echo enabled || echo disabled)." 20 60
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
        if [ -n "$DEFAULT" ]; then
            fdtput -t s /media/boot/meson64_odroidn2.dtb /onewire status okay
            ASK_TO_REBOOT=1
            whiptail --msgbox "The 1-Wire interface is enabled" 20 60
        fi
    elif [ $BUTTON -eq 1 ]; then
        if [ -z "$DEFAULT" ]; then
            fdtput -t s /media/boot/meson64_odroidn2.dtb /onewire status disabled
            whiptail --msgbox "The 1-Wire interface is disabled" 20 60
            ASK_TO_REBOOT=1
        fi
    fi
}