
Scope (\_SB.PEP0)
{
    Method (LPMX, 0, NotSerialized)
    {
        Return (LPXC) /* \_SB_.PEP0.LPXC */
    }

    Name (LPXC, Package (0x01)
    {
        // HX83112 Touch PEP States
        Package()
        {
            "DEVICE", 
            "\\_SB.TSC1", 
            // D0 - Power on sequence
            Package (0x0B)
            {
                "DSTATE", 
                0x00, 

                // RESET low
                Package()
                {
                    "TLMMGPIO",
                    Package (0x06)
                    {
                        54, // himax,reset_gpio
                        0, 
                        0, 
                        1, // OUT
                        0, // NO PULL
                        0
                    }
                }, 

                Package()
                {
                    "PMICVREGVOTE", 
                    Package (0x08)
                    {
                        "PPP_RESOURCE_ID_LDO1_C", 
                        One, 
                        0x001B7740, 
                        One, 
                        0x07, 
                        Zero, 
                        "HLOS_DRV", 
                        "REQUIRED"
                    }
                }, 

                Package()
                {
                    "TLMMGPIO", 
                    Package (0x06)
                    {
                        37, 
                        1, 
                        0, 
                        1, // OUT
                        3, // UP
                        0
                    }
                }, 

                Package()
                {
                    "DELAY", 
                    Package()
                    {
                        4000
                    }
                }, 

                Package()
                {
                    "PMICGPIO", 
                    Package (0x08)
                    {
                        "IOCTL_PM_GPIO_CONFIG_DIGITAL_OUTPUT", 
                        One, 
                        0x04, 
                        Zero, 
                        One, 
                        0x0A, 
                        0x03, 
                        0x04
                    }
                }, 

                Package()
                {
                    "DELAY", 
                    Package()
                    {
                        4000
                    }
                }, 

                // RESET high
                Package()
                {
                    "TLMMGPIO", 
                    Package (0x06)
                    {
                        54, // himax,reset_gpio
                        1, 
                        0, 
                        1, // OUT
                        0, // NO PULL
                        0
                    }
                }, 

                Package()
                {
                    "DELAY", 
                    Package()
                    {
                        200
                    }
                }, 

                // TS_INT GPIO
                Package()
                {
                    "TLMMGPIO", 
                    Package (0x06)
                    {
                        122, // himax,interrupt_gpio
                        0, 
                        0, 
                        0, // IN
                        3, // UP
                        0
                    }
                }
            }, 

            // D3 - Power off sequence
            Package (0x0A)
            {
                "DSTATE", 
                0x03, 
                Package()
                {
                    "TLMMGPIO", 
                    Package (0x06)
                    {
                        122, // himax,interrupt_gpio
                        0, 
                        0, 
                        0, // IN
                        1, // DOWN
                        0
                    }
                }, 

                Package()
                {
                    "TLMMGPIO", 
                    Package (0x06)
                    {
                        37, 
                        0, 
                        0, 
                        1, // OUT
                        0, // NO PULL
                        0
                    }
                }, 

                Package()
                {
                    "DELAY", 
                    Package (0x01)
                    {
                        0x0FA0
                    }
                }, 

                Package()
                {
                    "PMICGPIO", 
                    Package (0x08)
                    {
                        "IOCTL_PM_GPIO_CONFIG_DIGITAL_OUTPUT", 
                        One, 
                        0x04, 
                        Zero, 
                        One, 
                        Zero, 
                        0x03, 
                        0x04
                    }
                }, 

                Package()
                {
                    "TLMMGPIO", 
                    Package (0x06)
                    {
                        54, // himax,reset_gpio
                        0, 
                        0, 
                        0, // IN
                        1, // DOWN
                        0
                    }
                }, 

                Package()
                {
                    "DELAY", 
                    Package (0x01)
                    {
                        0x0FA0
                    }
                }, 

                Package()
                {
                    "PMICVREGVOTE", 
                    Package (0x07)
                    {
                        "PPP_RESOURCE_ID_LDO1_C", 
                        One, 
                        Zero, 
                        One, 
                        0x07, 
                        Zero, 
                        "REQUIRED"
                    }
                }, 

                Package()
                {
                    "DELAY", 
                    Package (0x01)
                    {
                        0x64
                    }
                }
            }
        }
    })
}
