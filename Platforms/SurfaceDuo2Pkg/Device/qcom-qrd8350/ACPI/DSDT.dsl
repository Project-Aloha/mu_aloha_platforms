DefinitionBlock ("", "DSDT", 2, "QCOMM ", "SDM8350 ", 0x00000003)
{
    External (_SB_.DMMY, UnknownObj)
    External (_SB_.DPP0, IntObj)
    External (_SB_.DPP1, IntObj)
    External (_SB_.MPP0, IntObj)
    External (_SB_.MPP1, IntObj)
    External (_SB_.TZ13.TPSV, UnknownObj)
    External (_SB_.TZ13.TTC1, UnknownObj)
    External (_SB_.TZ13.TTC2, UnknownObj)
    External (_SB_.TZ13.TTSP, UnknownObj)
    External (_SB_.TZ52, UnknownObj)
    External (_SB_.TZ52._PSV, IntObj)
    External (_SB_.TZ52._TC1, IntObj)
    External (_SB_.TZ52._TC2, IntObj)
    External (_SB_.TZ52._TSP, IntObj)
    External (_SB_.TZ52.TPSV, UnknownObj)
    External (_SB_.TZ52.TTC1, UnknownObj)
    External (_SB_.TZ52.TTC2, UnknownObj)
    External (_SB_.TZ52.TTSP, UnknownObj)

    Scope (\_SB)
    {
        Name (PSUB, "QRD08350")
        Name (SOID, 0xFFFFFFFF)
        Name (STOR, 0xABCABCAB)
        Name (SIDS, "899800000000000")
        Name (SIDV, 0xFFFFFFFF)
        Name (SVMJ, 0xFFFF)
        Name (SVMI, 0xFFFF)
        Name (SDFE, 0xFFFF)
        Name (SFES, "899800000000000")
        Name (SIDM, 0x0000000FFFFFFFFF)
        Name (SUFS, 0xFFFFFFFF)
        Name (PUS3, 0xFFFFFFFF)
        Name (SUS3, 0xFFFFFFFF)
        Name (SIDT, 0xFFFFFFFF)
        Name (SOSN, 0xAAAAAAAABBBBBBBB)
        Name (PLST, 0xFFFFFFFF)
        Name (EMUL, 0xFFFFFFFF)
        Name (SJTG, 0xFFFFFFFF)
        Name (RMTB, 0xAAAAAAAA)
        Name (RMTX, 0xBBBBBBBB)
        Name (RFMB, 0xCCCCCCCC)
        Name (RFMS, 0xDDDDDDDD)
        Name (RFAB, 0xEEEEEEEE)
        Name (RFAS, 0x77777777)
        Name (TCMA, 0xDEADBEEF)
        Name (TCML, 0xBEEFDEAD)
        Name (SOSI, 0xDEADBEEFFFFFFFFF)
        Name (PRP0, 0xFFFFFFFF)
        Name (PRP1, 0xFFFFFFFF)
        Device (UFS0)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((STOR == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_HID, "QCOM24A5")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Alias (\_SB.EMUL, EMUL)
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CCA, One)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x01D84000,         // Address Base
                        0x0001C000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000129,
                    }
                })
                Return (RBUF) /* \_SB_.UFS0._CRS.RBUF */
            }

            Device (DEV0)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (0x08)
                }

                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                {
                    Return (Zero)
                }
            }
        }

        Device (SDC2)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.GIO0
            })
            Name (_HID, "QCOM2466")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x08804000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000EF,
                    }
                    GpioInt (Edge, ActiveBoth, Shared, PullUp, 0x1388,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x005C
                        }
                    GpioIo (Shared, PullUp, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x005C
                        }
                })
                Return (RBUF) /* \_SB_.SDC2._CRS.RBUF */
            }

            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (ABD)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_HID, "QCOM0527")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            OperationRegion (ROP1, GenericSerialBus, Zero, 0x0100)
            Name (AVBL, Zero)
            Method (_REG, 2, NotSerialized)  // _REG: Region Availability
            {
                If ((Arg0 == 0x09))
                {
                    AVBL = Arg1
                }
            }
        }

        Name (ESNL, 0x14)
        Name (DBFL, 0x17)
        Device (PMIC)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.SPMI
            })
            Name (_HID, "QCOM1A2B")  // _HID: Hardware ID
            Name (_CID, "PNP0CA3")  // _CID: Compatible ID
            Alias (\_SB.PSUB, _SUB)
            Method (PMCF, 0, NotSerialized)
            {
                Name (CFG0, Package (0x0B)
                {
                    0x0A, 
                    Package (0x02)
                    {
                        Zero, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        One, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x02, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x03, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x04, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x05, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x10, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x10, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x10, 
                        0x10
                    }, 

                    Package (0x02)
                    {
                        0x10, 
                        0x10
                    }
                })
                Return (CFG0) /* \_SB_.PMIC.PMCF.CFG0 */
            }
        }

        Device (PML0)
        {
            Name (_HID, "QCOM1AD3")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.IC14
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0008, ControllerInitiated, 0x000186A0,
                        AddressingMode7Bit, "\\_SB.IC14",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    I2cSerialBusV2 (0x0009, ControllerInitiated, 0x000186A0,
                        AddressingMode7Bit, "\\_SB.IC14",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    I2cSerialBusV2 (0x000C, ControllerInitiated, 0x000186A0,
                        AddressingMode7Bit, "\\_SB.IC14",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    I2cSerialBusV2 (0x000D, ControllerInitiated, 0x000186A0,
                        AddressingMode7Bit, "\\_SB.IC14",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    GpioIo (Exclusive, PullNone, 0x0000, 0x00C8, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0021
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x00C8, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0023
                        }
                })
                Return (RBUF) /* \_SB_.PML0._CRS.RBUF */
            }
        }

        Device (PM01)
        {
            Name (_HID, "QCOM1A2D")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, One)  // _UID: Unique ID
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PMIC
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x00000201,
                    }
                })
                Return (RBUF) /* \_SB_.PM01._CRS.RBUF */
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                While (One)
                {
                    Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    {
                         0x00                                             // .
                    })
                    CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.PM01._DSM._T_0 */
                    If ((_T_0 == ToUUID ("4f248f40-d5e2-499f-834c-27758ea1cd3f") /* GPIO Controller */))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = ToInteger (Arg2)
                            If ((_T_1 == Zero))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                                             // .
                                })
                            }
                            ElseIf ((_T_1 == One))
                            {
                                Return (Package (0x02)
                                {
                                    0x07, 
                                    0x06
                                })
                            }
                            Else
                            {
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (Buffer (One)
                        {
                             0x00                                             // .
                        })
                    }

                    Break
                }
            }
        }

        Device (PMAP)
        {
            Name (_HID, "QCOM1A2C")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.PMIC, 
                \_SB.ABD, 
                \_SB.SCM0
            })
            Method (GEPT, 0, NotSerialized)
            {
                Name (BUFF, Buffer (0x04){})
                CreateByteField (BUFF, Zero, STAT)
                CreateWordField (BUFF, 0x02, DATA)
                DATA = 0x02
                Return (DATA) /* \_SB_.PMAP.GEPT.DATA */
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, Buffer (0x02)
                {
                     0x79, 0x00                                       // y.
                })
                Return (RBUF) /* \_SB_.PMAP._CRS.RBUF */
            }
        }

        Device (PRTC)
        {
            Name (_HID, "ACPI000E" /* Time and Alarm Device */)  // _HID: Hardware ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                "\\_SB.PMAP"
            })
            Method (_GCP, 0, NotSerialized)  // _GCP: Get Capabilities
            {
                Return (0x04)
            }

            Field (\_SB.ABD.ROP1, BufferAcc, NoLock, Preserve)
            {
                Connection (
                    I2cSerialBusV2 (0x0002, ControllerInitiated, 0x00000000,
                        AddressingMode7Bit, "\\_SB.ABD",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                ), 
                AccessAs (BufferAcc, AttribRawBytes (0x18)), 
                FLD0,   192
            }

            Method (_GRT, 0, NotSerialized)  // _GRT: Get Real Time
            {
                Name (BUFF, Buffer (0x1A){})
                CreateField (BUFF, 0x10, 0x80, TME1)
                CreateField (BUFF, 0x90, 0x20, ACT1)
                CreateField (BUFF, 0xB0, 0x20, ACW1)
                BUFF = FLD0 /* \_SB_.PRTC.FLD0 */
                Return (TME1) /* \_SB_.PRTC._GRT.TME1 */
            }

            Method (_SRT, 1, NotSerialized)  // _SRT: Set Real Time
            {
                Name (BUFF, Buffer (0x32){})
                CreateByteField (BUFF, Zero, STAT)
                CreateField (BUFF, 0x10, 0x80, TME1)
                CreateField (BUFF, 0x90, 0x20, ACT1)
                CreateField (BUFF, 0xB0, 0x20, ACW1)
                ACT1 = Zero
                TME1 = Arg0
                ACW1 = Zero
                BUFF = FLD0 = BUFF /* \_SB_.PRTC._SRT.BUFF */
                If ((STAT != Zero))
                {
                    Return (One)
                }

                Return (Zero)
            }
        }

        Device (PMBM)
        {
            Name (_HID, "QCOM1A2A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PMGK
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, Buffer (0x02)
                {
                     0x79, 0x00                                       // y.
                })
                Return (RBUF) /* \_SB_.PMBM._CRS.RBUF */
            }
        }

        Device (BCL1)
        {
            Name (_HID, "QCOM1A77")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PMIC
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveLow, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0108
                        }
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0109
                        }
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x010A
                        }
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x010B
                        }
                    GpioInt (Edge, ActiveLow, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0210
                        }
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0211
                        }
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0212
                        }
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0213
                        }
                })
                Return (RBUF) /* \_SB_.BCL1._CRS.RBUF */
            }

            Method (BCLQ, 0, NotSerialized)
            {
                Name (CFG0, Package (0x08)
                {
                    "PM3_BCLBIG_LVL0", 
                    "PM3_BCLBIG_LVL1", 
                    "PM3_BCLBIG_LVL2", 
                    "PM3_BCLBIG_BAN", 
                    "PM7_BCLBIG_LVL0", 
                    "PM7_BCLBIG_LVL1", 
                    "PM7_BCLBIG_LVL2", 
                    "PM7_BCLBIG_BAN"
                })
                Return (CFG0) /* \_SB_.BCL1.BCLQ.CFG0 */
            }
        }

        Device (PMGK)
        {
            Name (_HID, "QCOM1A8E")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.GLNK, 
                \_SB.ABD
            })
            Name (LKUP, Zero)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }

            Method (GEPT, 0, NotSerialized)
            {
                Name (BUFF, Buffer (0x04){})
                CreateByteField (BUFF, Zero, STAT)
                CreateWordField (BUFF, 0x02, DATA)
                DATA = 0x03
                Return (DATA) /* \_SB_.PMGK.GEPT.DATA */
            }

            Name (UBUF, Buffer (0x32){})
            CreateField (UBUF, Zero, 0x08, BSTA)
            CreateField (UBUF, 0x08, 0x08, BSIZ)
            CreateField (UBUF, 0x10, 0x10, BVER)
            CreateField (UBUF, 0x30, 0x20, BCCI)
            CreateField (UBUF, 0x50, 0x40, BCTL)
            CreateField (UBUF, 0x90, 0x80, BMGI)
            CreateField (UBUF, 0x0110, 0x80, BMGO)
            Method (USBN, 1, NotSerialized)
            {
                UBUF = UCSI /* \_SB_.PMGK.UCSI */
                \_SB.UCSI.VERS = BVER /* \_SB_.PMGK.BVER */
                \_SB.UCSI.MSGI = BMGI /* \_SB_.PMGK.BMGI */
                \_SB.UCSI.CCI = BCCI /* \_SB_.PMGK.BCCI */
                Notify (\_SB.UCSI, Arg0)
                Return (Zero)
            }

            Name (PBUF, Buffer (0x10){})
            CreateField (PBUF, Zero, 0x08, BPID)
            CreateField (PBUF, 0x08, 0x08, BORI)
            CreateField (PBUF, 0x10, 0x08, BMUX)
            CreateField (PBUF, 0x20, 0x10, BVID)
            CreateField (PBUF, 0x30, 0x10, BSID)
            CreateField (PBUF, 0x40, 0x08, BSSD)
            Method (UPAN, 1, NotSerialized)
            {
                PBUF = Arg0
                \_SB.UCS0.EINF = 0x02
                While (One)
                {
                    Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    _T_0 = BPID /* \_SB_.PMGK.BPID */
                    If ((_T_0 == Zero))
                    {
                        \_SB.UCS0.EUPD |= One
                        \_SB.UCS0.ECC0 = BORI /* \_SB_.PMGK.BORI */
                        \_SB.UCS0.EMX0 = BMUX /* \_SB_.PMGK.BMUX */
                        \_SB.UCS0.EVI0 = BVID /* \_SB_.PMGK.BVID */
                        \_SB.UCS0.ESI0 = BSID /* \_SB_.PMGK.BSID */
                        \_SB.UCS0.ESV0 = BSSD /* \_SB_.PMGK.BSSD */
                        \_SB.UCS0.USBR ()
                        Break
                    }
                    ElseIf ((_T_0 == One))
                    {
                        \_SB.UCS0.EUPD |= 0x02
                        \_SB.UCS0.ECC1 = BORI /* \_SB_.PMGK.BORI */
                        \_SB.UCS0.EMX1 = BMUX /* \_SB_.PMGK.BMUX */
                        \_SB.UCS0.EVI1 = BVID /* \_SB_.PMGK.BVID */
                        \_SB.UCS0.ESI1 = BSID /* \_SB_.PMGK.BSID */
                        \_SB.UCS0.ESV1 = BSSD /* \_SB_.PMGK.BSSD */
                        \_SB.UCS0.USBR ()
                        Break
                    }

                    Break
                }

                Return (Zero)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, Buffer (0x02)
                {
                     0x79, 0x00                                       // y.
                })
                Return (RBUF) /* \_SB_.PMGK._CRS.RBUF */
            }

            Method (LKST, 1, NotSerialized)
            {
                LKUP = Arg0
                Notify (\_SB.UCSI, Zero) // Bus Check
                Return (Zero)
            }

            Field (\_SB.ABD.ROP1, BufferAcc, NoLock, Preserve)
            {
                Connection (
                    I2cSerialBusV2 (0x0003, ControllerInitiated, 0x00000000,
                        AddressingMode7Bit, "\\_SB.ABD",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                ), 
                AccessAs (BufferAcc, AttribRawBytes (0x30)), 
                UCSI,   384
            }
        }

        Device (PEP0)
        {
            Name (_HID, "QCOM1A17")  // _HID: Hardware ID
            Name (_CID, "PNP0D80" /* Windows-compatible System Power Management Controller */)  // _CID: Compatible ID
            Method (THTZ, 4, NotSerialized)
            {
                While (One)
                {
                    Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    _T_0 = ToInteger (Arg0)
                    If ((_T_0 == One))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = ToInteger (Arg3)
                            If ((_T_1 == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ1.TPSV = Arg1
                                    Notify (\_SB.TZ1, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ1._PSV ())
                            }
                            ElseIf ((_T_1 == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ1.TTSP = Arg1
                                    Notify (\_SB.TZ1, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ1._TSP ())
                            }
                            ElseIf ((_T_1 == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ1.TTC1 = Arg1
                                    Notify (\_SB.TZ1, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ1._TC1 ())
                            }
                            ElseIf ((_T_1 == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ1.TTC2 = Arg1
                                    Notify (\_SB.TZ1, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ1._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x03))
                    {
                        While (One)
                        {
                            Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_2 = ToInteger (Arg3)
                            If ((_T_2 == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ3.TPSV = Arg1
                                    Notify (\_SB.TZ3, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ3._PSV ())
                            }
                            ElseIf ((_T_2 == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ3.TTSP = Arg1
                                    Notify (\_SB.TZ3, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ3._TSP ())
                            }
                            ElseIf ((_T_2 == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ3.TTC1 = Arg1
                                    Notify (\_SB.TZ3, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ3._TC1 ())
                            }
                            ElseIf ((_T_2 == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ3.TTC2 = Arg1
                                    Notify (\_SB.TZ3, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ3._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x05))
                    {
                        While (One)
                        {
                            Name (_T_3, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_3 = ToInteger (Arg3)
                            If ((_T_3 == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ5.TPSV = Arg1
                                    Notify (\_SB.TZ5, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ5._PSV ())
                            }
                            ElseIf ((_T_3 == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ5.TTSP = Arg1
                                    Notify (\_SB.TZ5, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ5._TSP ())
                            }
                            ElseIf ((_T_3 == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ5.TTC1 = Arg1
                                    Notify (\_SB.TZ5, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ5._TC1 ())
                            }
                            ElseIf ((_T_3 == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ5.TTC2 = Arg1
                                    Notify (\_SB.TZ5, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ5._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x0B))
                    {
                        While (One)
                        {
                            Name (_T_4, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_4 = ToInteger (Arg3)
                            If ((_T_4 == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ11.TPSV = Arg1
                                    Notify (\_SB.TZ11, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ11._PSV ())
                            }
                            ElseIf ((_T_4 == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ11.TTSP = Arg1
                                    Notify (\_SB.TZ11, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ11._TSP ())
                            }
                            ElseIf ((_T_4 == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ11.TTC1 = Arg1
                                    Notify (\_SB.TZ11, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ11._TC1 ())
                            }
                            ElseIf ((_T_4 == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ11.TTC2 = Arg1
                                    Notify (\_SB.TZ11, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ11._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x0D))
                    {
                        While (One)
                        {
                            Name (_T_5, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_5 = ToInteger (Arg3)
                            If ((_T_5 == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ13.TPSV = Arg1
                                    Notify (\_SB.TZ13, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ13._PSV ())
                            }
                            ElseIf ((_T_5 == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ13.TTSP = Arg1
                                    Notify (\_SB.TZ13, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ13._TSP)
                            }
                            ElseIf ((_T_5 == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ13.TTC1 = Arg1
                                    Notify (\_SB.TZ13, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ13._TC1)
                            }
                            ElseIf ((_T_5 == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ13.TTC2 = Arg1
                                    Notify (\_SB.TZ13, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ13._TC2)
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x0E))
                    {
                        While (One)
                        {
                            Name (_T_6, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_6 = ToInteger (Arg3)
                            If ((_T_6 == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ14.TPSV = Arg1
                                    Notify (\_SB.TZ14, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ14._PSV ())
                            }
                            ElseIf ((_T_6 == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ14.TTSP = Arg1
                                    Notify (\_SB.TZ14, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ14._TFP ())
                            }
                            ElseIf ((_T_6 == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ14.TTC1 = Arg1
                                    Notify (\_SB.TZ14, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ14._TC1 ())
                            }
                            ElseIf ((_T_6 == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ14.TTC2 = Arg1
                                    Notify (\_SB.TZ14, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ14._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x0F))
                    {
                        While (One)
                        {
                            Name (_T_7, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_7 = ToInteger (Arg3)
                            If ((_T_7 == Zero))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ15._PSV ())
                            }
                            ElseIf ((_T_7 == 0x02))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ15._TSP)
                            }
                            ElseIf ((_T_7 == 0x03))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ15._TC1 ())
                            }
                            ElseIf ((_T_7 == 0x04))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ15._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x10))
                    {
                        While (One)
                        {
                            Name (_T_8, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_8 = ToInteger (Arg3)
                            If ((_T_8 == Zero))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ16._PSV ())
                            }
                            ElseIf ((_T_8 == One))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ16._CRT ())
                            }
                            ElseIf ((_T_8 == 0x02))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ16._TSP)
                            }
                            ElseIf ((_T_8 == 0x03))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ16._TC1 ())
                            }
                            ElseIf ((_T_8 == 0x04))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ16._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x11))
                    {
                        While (One)
                        {
                            Name (_T_9, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_9 = ToInteger (Arg3)
                            If ((_T_9 == Zero))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ17._PSV ())
                            }
                            ElseIf ((_T_9 == 0x02))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ17._TSP)
                            }
                            ElseIf ((_T_9 == 0x03))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ17._TC1 ())
                            }
                            ElseIf ((_T_9 == 0x04))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ17._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x12))
                    {
                        While (One)
                        {
                            Name (_T_A, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_A = ToInteger (Arg3)
                            If ((_T_A == Zero))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ18._PSV ())
                            }
                            ElseIf ((_T_A == 0x02))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ18._TSP)
                            }
                            ElseIf ((_T_A == 0x03))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ18._TC1 ())
                            }
                            ElseIf ((_T_A == 0x04))
                            {
                                If (Arg2)
                                {
                                    Return (0xFFFF)
                                }

                                Return (\_SB.TZ18._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x1F))
                    {
                        While (One)
                        {
                            Name (_T_B, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_B = ToInteger (Arg3)
                            If ((_T_B == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ31.TPSV = Arg1
                                    Notify (\_SB.TZ31, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ31._PSV ())
                            }
                            ElseIf ((_T_B == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ31.TTSP = Arg1
                                    Notify (\_SB.TZ31, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ31._TSP ())
                            }
                            ElseIf ((_T_B == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ31.TTC1 = Arg1
                                    Notify (\_SB.TZ31, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ31._TC1 ())
                            }
                            ElseIf ((_T_B == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ31.TTC2 = Arg1
                                    Notify (\_SB.TZ31, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ31._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x20))
                    {
                        While (One)
                        {
                            Name (_T_C, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_C = ToInteger (Arg3)
                            If ((_T_C == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ32.TPSV = Arg1
                                    Notify (\_SB.TZ32, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ32._PSV ())
                            }
                            ElseIf ((_T_C == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ32.TTSP = Arg1
                                    Notify (\_SB.TZ32, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ32._TSP ())
                            }
                            ElseIf ((_T_C == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ32.TTC1 = Arg1
                                    Notify (\_SB.TZ32, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ32._TC1 ())
                            }
                            ElseIf ((_T_C == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ32.TTC2 = Arg1
                                    Notify (\_SB.TZ32, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ32._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x21))
                    {
                        While (One)
                        {
                            Name (_T_D, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_D = ToInteger (Arg3)
                            If ((_T_D == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ33.TPSV = Arg1
                                    Notify (\_SB.TZ33, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ33._PSV ())
                            }
                            ElseIf ((_T_D == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ33.TTSP = Arg1
                                    Notify (\_SB.TZ33, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ33._TSP ())
                            }
                            ElseIf ((_T_D == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ33.TTC1 = Arg1
                                    Notify (\_SB.TZ33, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ33._TC1 ())
                            }
                            ElseIf ((_T_D == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ33.TTC2 = Arg1
                                    Notify (\_SB.TZ33, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ33._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x22))
                    {
                        While (One)
                        {
                            Name (_T_E, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_E = ToInteger (Arg3)
                            If ((_T_E == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ34.TPSV = Arg1
                                    Notify (\_SB.TZ34, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ34._PSV ())
                            }
                            ElseIf ((_T_E == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ34.TTSP = Arg1
                                    Notify (\_SB.TZ34, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ34._TSP ())
                            }
                            ElseIf ((_T_E == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ34.TTC1 = Arg1
                                    Notify (\_SB.TZ34, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ34._TC1 ())
                            }
                            ElseIf ((_T_E == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ34.TTC2 = Arg1
                                    Notify (\_SB.TZ34, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ34._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x23))
                    {
                        While (One)
                        {
                            Name (_T_F, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_F = ToInteger (Arg3)
                            If ((_T_F == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ35.TPSV = Arg1
                                    Notify (\_SB.TZ35, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ35._PSV ())
                            }
                            ElseIf ((_T_F == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ35.TTSP = Arg1
                                    Notify (\_SB.TZ35, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ35._TSP ())
                            }
                            ElseIf ((_T_F == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ35.TTC1 = Arg1
                                    Notify (\_SB.TZ35, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ35._TC1 ())
                            }
                            ElseIf ((_T_F == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ35.TTC2 = Arg1
                                    Notify (\_SB.TZ35, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ35._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x24))
                    {
                        While (One)
                        {
                            Name (_T_G, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_G = ToInteger (Arg3)
                            If ((_T_G == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ36.TPSV = Arg1
                                    Notify (\_SB.TZ36, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ36._PSV ())
                            }
                            ElseIf ((_T_G == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ36.TTSP = Arg1
                                    Notify (\_SB.TZ36, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ36._TSP ())
                            }
                            ElseIf ((_T_G == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ36.TTC1 = Arg1
                                    Notify (\_SB.TZ36, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ36._TC1 ())
                            }
                            ElseIf ((_T_G == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ36.TTC2 = Arg1
                                    Notify (\_SB.TZ36, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ36._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x25))
                    {
                        While (One)
                        {
                            Name (_T_H, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_H = ToInteger (Arg3)
                            If ((_T_H == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ37.TPSV = Arg1
                                    Notify (\_SB.TZ37, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ37._PSV ())
                            }
                            ElseIf ((_T_H == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ37.TTSP = Arg1
                                    Notify (\_SB.TZ37, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ37._TSP ())
                            }
                            ElseIf ((_T_H == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ37.TTC1 = Arg1
                                    Notify (\_SB.TZ37, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ37._TC1 ())
                            }
                            ElseIf ((_T_H == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ37.TTC2 = Arg1
                                    Notify (\_SB.TZ37, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ37._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x26))
                    {
                        While (One)
                        {
                            Name (_T_I, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_I = ToInteger (Arg3)
                            If ((_T_I == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ38.TPSV = Arg1
                                    Notify (\_SB.TZ38, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ38._PSV ())
                            }
                            ElseIf ((_T_I == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ38.TTSP = Arg1
                                    Notify (\_SB.TZ38, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ38._TSP ())
                            }
                            ElseIf ((_T_I == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ38.TTC1 = Arg1
                                    Notify (\_SB.TZ38, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ38._TC1 ())
                            }
                            ElseIf ((_T_I == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ38.TTC2 = Arg1
                                    Notify (\_SB.TZ38, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ38._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x33))
                    {
                        While (One)
                        {
                            Name (_T_J, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_J = ToInteger (Arg3)
                            If ((_T_J == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ51.TPSV = Arg1
                                    Notify (\_SB.TZ51, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ51._PSV ())
                            }
                            ElseIf ((_T_J == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ51.TTSP = Arg1
                                    Notify (\_SB.TZ51, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ51._TSP ())
                            }
                            ElseIf ((_T_J == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ51.TTC1 = Arg1
                                    Notify (\_SB.TZ51, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ51._TC1 ())
                            }
                            ElseIf ((_T_J == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ51.TTC2 = Arg1
                                    Notify (\_SB.TZ51, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ51._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x34))
                    {
                        While (One)
                        {
                            Name (_T_K, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_K = ToInteger (Arg3)
                            If ((_T_K == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ52.TPSV = Arg1
                                    Notify (\_SB.TZ52, 0x81) // Information Change
                                }

                                Return (\_SB.TZ52._PSV) /* External reference */
                            }
                            ElseIf ((_T_K == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ52.TTSP = Arg1
                                    Notify (\_SB.TZ52, 0x81) // Information Change
                                }

                                Return (\_SB.TZ52._TSP) /* External reference */
                            }
                            ElseIf ((_T_K == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ52.TTC1 = Arg1
                                    Notify (\_SB.TZ52, 0x81) // Information Change
                                }

                                Return (\_SB.TZ52._TC1) /* External reference */
                            }
                            ElseIf ((_T_K == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ52.TTC2 = Arg1
                                    Notify (\_SB.TZ52, 0x81) // Information Change
                                }

                                Return (\_SB.TZ52._TC2) /* External reference */
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x3A))
                    {
                        While (One)
                        {
                            Name (_T_L, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_L = ToInteger (Arg3)
                            If ((_T_L == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ58.TPSV = Arg1
                                    Notify (\_SB.TZ58, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ58._PSV ())
                            }
                            ElseIf ((_T_L == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ58.TTSP = Arg1
                                    Notify (\_SB.TZ58, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ58._TSP ())
                            }
                            ElseIf ((_T_L == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ58.TTC1 = Arg1
                                    Notify (\_SB.TZ58, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ58._TC1 ())
                            }
                            ElseIf ((_T_L == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ58.TTC2 = Arg1
                                    Notify (\_SB.TZ58, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ58._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x3B))
                    {
                        While (One)
                        {
                            Name (_T_M, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_M = ToInteger (Arg3)
                            If ((_T_M == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ59.TPSV = Arg1
                                    Notify (\_SB.TZ59, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ59._PSV ())
                            }
                            ElseIf ((_T_M == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ59.TTSP = Arg1
                                    Notify (\_SB.TZ59, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ59._TSP ())
                            }
                            ElseIf ((_T_M == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ59.TTC1 = Arg1
                                    Notify (\_SB.TZ59, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ59._TC1 ())
                            }
                            ElseIf ((_T_M == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ59.TTC2 = Arg1
                                    Notify (\_SB.TZ59, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ59._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x3D))
                    {
                        While (One)
                        {
                            Name (_T_N, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_N = ToInteger (Arg3)
                            If ((_T_N == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ61.TPSV = Arg1
                                    Notify (\_SB.TZ61, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ61._PSV ())
                            }
                            ElseIf ((_T_N == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ61.TTSP = Arg1
                                    Notify (\_SB.TZ61, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ61._TSP ())
                            }
                            ElseIf ((_T_N == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ61.TTC1 = Arg1
                                    Notify (\_SB.TZ61, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ61._TC1 ())
                            }
                            ElseIf ((_T_N == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ61.TTC2 = Arg1
                                    Notify (\_SB.TZ61, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ61._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    ElseIf ((_T_0 == 0x63))
                    {
                        While (One)
                        {
                            Name (_T_O, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_O = ToInteger (Arg3)
                            If ((_T_O == Zero))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ99.TPSV = Arg1
                                    Notify (\_SB.TZ99, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ99._PSV ())
                            }
                            ElseIf ((_T_O == One))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ99.TCRT = Arg1
                                    Notify (\_SB.TZ99, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ99._CRT ())
                            }
                            ElseIf ((_T_O == 0x02))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ99.TTSP = Arg1
                                    Notify (\_SB.TZ99, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ99._TSP ())
                            }
                            ElseIf ((_T_O == 0x03))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ99.TTC1 = Arg1
                                    Notify (\_SB.TZ99, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ99._TC1 ())
                            }
                            ElseIf ((_T_O == 0x04))
                            {
                                If (Arg2)
                                {
                                    \_SB.TZ99.TTC2 = Arg1
                                    Notify (\_SB.TZ99, 0x81) // Thermal Trip Point Change
                                }

                                Return (\_SB.TZ99._TC2 ())
                            }
                            Else
                            {
                                Return (0xFFFF)
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (0xFFFF)
                    }

                    Break
                }
            }

            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.IPCC
            })
            Method (_SUB, 0, NotSerialized)  // _SUB: Subsystem ID
            {
                If ((\_SB.PSUB == "MTP08350"))
                {
                    Return ("MTP08350")
                }
                ElseIf ((\_SB.PSUB == "QRD08350"))
                {
                    Return ("QRD08350")
                }
                ElseIf ((\_SB.PSUB == "CDP08350"))
                {
                    Return ("CDP08350")
                }
                ElseIf ((\_SB.PSUB == "ATP08350"))
                {
                    Return ("ATP08350")
                }
                ElseIf ((\_SB.PSUB == "HDK08350"))
                {
                    Return ("HDK08350")
                }
                ElseIf ((\_SB.PSUB == "HHG08350"))
                {
                    Return ("HHG08350")
                }
                ElseIf ((\_SB.PSUB == "QSP08350"))
                {
                    Return ("QSP08350")
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                While (One)
                {
                    Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    {
                         0x00                                             // .
                    })
                    CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.PEP0._DSM._T_0 */
                    If ((_T_0 == ToUUID ("8d5ca34c-ae83-4a2a-9dd1-a74ffead548b") /* Unknown UUID */))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = ToInteger (Arg2)
                            If ((_T_1 == Zero))
                            {
                                While (One)
                                {
                                    Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                    _T_2 = ToInteger (Arg1)
                                    If ((_T_2 == Zero))
                                    {
                                        Return (0x7E)
                                    }

                                    Break
                                }

                                Return (Zero)
                            }
                            ElseIf ((_T_1 == One))
                            {
                                Name (SUBI, Package (0x05)
                                {
                                    Package (0x03)
                                    {
                                        "adsp", 
                                        One, 
                                        0x02
                                    }, 

                                    Package (0x03)
                                    {
                                        "slpi", 
                                        Zero, 
                                        0x03
                                    }, 

                                    Package (0x03)
                                    {
                                        "cdsp", 
                                        One, 
                                        0x04
                                    }, 

                                    Package (0x03)
                                    {
                                        "modem", 
                                        One, 
                                        0x05
                                    }, 

                                    Package (0x03)
                                    {
                                        "spss", 
                                        Zero, 
                                        0x06
                                    }
                                })
                                Return (SUBI) /* \_SB_.PEP0._DSM.SUBI */
                            }
                            ElseIf ((_T_1 == 0x02))
                            {
                                If (CondRefOf (\_SB.ADSP))
                                {
                                    If (CondRefOf (\_SB.ADSP._STA))
                                    {
                                        Return (\_SB.ADSP._STA ())
                                    }
                                    Else
                                    {
                                        Return (0x0F)
                                    }
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }
                            ElseIf ((_T_1 == 0x03))
                            {
                                If (CondRefOf (\_SB.SCSS))
                                {
                                    If (CondRefOf (\_SB.SCSS._STA))
                                    {
                                        Return (\_SB.SCSS._STA ())
                                    }
                                    Else
                                    {
                                        Return (0x0F)
                                    }
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }
                            ElseIf ((_T_1 == 0x04))
                            {
                                If (CondRefOf (\_SB.NSP0))
                                {
                                    If (CondRefOf (\_SB.NSP0._STA))
                                    {
                                        Return (\_SB.NSP0._STA ())
                                    }
                                    Else
                                    {
                                        Return (0x0F)
                                    }
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }
                            ElseIf ((_T_1 == 0x05))
                            {
                                If (CondRefOf (\_SB.AMSS))
                                {
                                    If (CondRefOf (\_SB.AMSS._STA))
                                    {
                                        Return (\_SB.AMSS._STA ())
                                    }
                                    Else
                                    {
                                        Return (0x0F)
                                    }
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }
                            ElseIf ((_T_1 == 0x06))
                            {
                                If (CondRefOf (\_SB.SPSS))
                                {
                                    If (CondRefOf (\_SB.SPSS._STA))
                                    {
                                        Return (\_SB.SPSS._STA ())
                                    }
                                    Else
                                    {
                                        Return (0x0F)
                                    }
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }
                            Else
                            {
                                Return (Zero)
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }

                    Break
                }
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, ExclusiveAndWake, ,, )
                    {
                        0x0000021A,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, ExclusiveAndWake, ,, )
                    {
                        0x0000021C,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, ExclusiveAndWake, ,, )
                    {
                        0x0000021B,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, ExclusiveAndWake, ,, )
                    {
                        0x0000021D,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000025,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000003E,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000003F,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000033,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000265,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000010D,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000113,
                    }
                })
            }

            Field (\_SB.ABD.ROP1, BufferAcc, NoLock, Preserve)
            {
                Connection (
                    I2cSerialBusV2 (0x0001, ControllerInitiated, 0x00000000,
                        AddressingMode7Bit, "\\_SB.ABD",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                ), 
                AccessAs (BufferAcc, AttribRawBytes (0x15)), 
                FLD0,   168
            }

            Method (GEPT, 0, NotSerialized)
            {
                Name (BUFF, Buffer (0x04){})
                CreateByteField (BUFF, Zero, STAT)
                CreateWordField (BUFF, 0x02, DATA)
                DATA = One
                Return (DATA) /* \_SB_.PEP0.GEPT.DATA */
            }

            Name (ROST, Zero)
            Method (NPUR, 1, NotSerialized)
            {
                \_SB.AGR0._PUR [One] = Arg0
                Notify (\_SB.AGR0, 0x80) // Status Change
            }

            Method (INTR, 0, NotSerialized)
            {
                Name (RBUF, Package (0x18)
                {
                    0x02, 
                    One, 
                    0x03, 
                    One, 
                    0x06, 
                    0x17911008, 
                    One, 
                    Zero, 
                    0x86000000, 
                    0x00200000, 
                    Zero, 
                    Zero, 
                    0x0C300000, 
                    0x1000, 
                    Zero, 
                    Zero, 
                    0x01FD4000, 
                    0x08, 
                    Zero, 
                    Zero, 
                    0x17C0000C, 
                    Zero, 
                    Zero, 
                    Zero
                })
                Return (RBUF) /* \_SB_.PEP0.INTR.RBUF */
            }

            Method (STND, 0, NotSerialized)
            {
                Return (STNX) /* \_SB_.PEP0.STNX */
            }

            Name (STNX, Package (0x0A)
            {
                "DMPO", 
                "DMPA", 
                "DMPB", 
                "DMDS", 
                "DMPL", 
                "DMWE", 
                "XMPL", 
                "XMPK", 
                "XMPT", 
                "DMEP"
            })
            Method (CTPM, 0, NotSerialized)
            {
                Name (CTPN, Package (0x02)
                {
                    "CORE_TOPOLOGY", 
                    0x08
                })
                Return (CTPN) /* \_SB_.PEP0.CTPM.CTPN */
            }

            Name (DCVS, Zero)
            Method (PGDS, 0, NotSerialized)
            {
                Return (DCVS) /* \_SB_.PEP0.DCVS */
            }

            Name (PPPP, Package (0x42)
            {
                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS5_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS6_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS9_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS10_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS11_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS12_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS1_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS2_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS3_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS4_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS6_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS8_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS10_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS1_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS2_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_SMPS3_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO1_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO2_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO3_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO4_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO5_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO6_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO7_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO8_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO9_B"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO1_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO2_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO3_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO4_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO5_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO6_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO7_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO8_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO9_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO10_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO11_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO12_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO13_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO1_D"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO1_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO2_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO3_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO4_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO5_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO6_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO7_E"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO1_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO2_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO3_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO4_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO5_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO6_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO7_P"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO1_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO2_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO3_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO4_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO5_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO6_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_LDO7_Q"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_CXO_BUFFERS_BBCLK2_A"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_CXO_BUFFERS_RFCLK1_A"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_CXO_BUFFERS_RFCLK2_A"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_BUCK_BOOST1_C"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_FIXED_VREG1"
                }, 

                Package (0x01)
                {
                    "PPP_RESOURCE_ID_FIXED_VREG2"
                }
            })
            Method (PPPM, 0, NotSerialized)
            {
                Return (PPPP) /* \_SB_.PEP0.PPPP */
            }

            Name (PRRP, Package (0x46)
            {
                "PPP_RESOURCE_ID_LDO1_P", 
                "PPP_RESOURCE_ID_SMPS12_B", 
                0x0012AD40, 
                0x0014C080, 
                0x0001D4C0, 
                "PPP_RESOURCE_ID_LDO2_P", 
                "PPP_RESOURCE_ID_SMPS12_B", 
                0x0012AD40, 
                0x0014C080, 
                0x000157C0, 
                "PPP_RESOURCE_ID_LDO3_P", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x00023280, 
                "PPP_RESOURCE_ID_LDO4_P", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x0001F400, 
                "PPP_RESOURCE_ID_LDO5_P", 
                "PPP_RESOURCE_ID_SMPS1_C", 
                0x001B7740, 
                0x001DC900, 
                0x00021340, 
                "PPP_RESOURCE_ID_LDO6_P", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x0001F400, 
                "PPP_RESOURCE_ID_LDO7_P", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x0004C2C0, 
                "PPP_RESOURCE_ID_LDO1_Q", 
                "PPP_RESOURCE_ID_SMPS12_B", 
                0x0012AD40, 
                0x0014C080, 
                0x0001D4C0, 
                "PPP_RESOURCE_ID_LDO2_Q", 
                "PPP_RESOURCE_ID_SMPS12_B", 
                0x0012AD40, 
                0x0014C080, 
                0x000157C0, 
                "PPP_RESOURCE_ID_LDO3_Q", 
                "PPP_RESOURCE_ID_SMPS1_C", 
                0x001B7740, 
                0x001DC900, 
                0x00021340, 
                "PPP_RESOURCE_ID_LDO4_Q", 
                "PPP_RESOURCE_ID_SMPS1_C", 
                0x001B7740, 
                0x001DC900, 
                0x00021340, 
                "PPP_RESOURCE_ID_LDO5_Q", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x00017700, 
                "PPP_RESOURCE_ID_LDO6_Q", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x00013880, 
                "PPP_RESOURCE_ID_LDO7_Q", 
                "PPP_RESOURCE_ID_BUCK_BOOST1_C", 
                0x002DE600, 
                0x003C6CC0, 
                0x00013880
            })
            Method (PPRR, 0, NotSerialized)
            {
                Return (PRRP) /* \_SB_.PEP0.PRRP */
            }

            Name (FPDP, Zero)
            Method (FPMD, 0, NotSerialized)
            {
                Return (FPDP) /* \_SB_.PEP0.FPDP */
            }

            Method (DPRF, 0, NotSerialized)
            {
                Return (\_SB.DPP0) /* External reference */
            }

            Method (DMRF, 0, NotSerialized)
            {
                Return (\_SB.DPP1) /* External reference */
            }

            Method (MPRF, 0, NotSerialized)
            {
                Return (\_SB.MPP0) /* External reference */
            }

            Method (MMRF, 0, NotSerialized)
            {
                Return (\_SB.MPP1) /* External reference */
            }
        }

        Scope (\_SB.PEP0)
        {
            Method (PREL, 0, NotSerialized)
            {
                Name (PREX, Package (0x07)
                {
                    "DM0G", 
                    "DM7G", 
                    "DM8G", 
                    "DM9G", 
                    "DMKG", 
                    "DMLG", 
                    "DMMG"
                })
                Return (PREX) /* \_SB_.PEP0.PREL.PREX */
            }
        }

        Scope (\_SB.PEP0)
        {
            Method (PEPH, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    "ACPI\\VEN_QCOM&DEV_1A17"
                })
            }
        }

        Scope (\_SB.PEP0)
        {
            Method (APMD, 0, NotSerialized)
            {
                Return (APCC) /* \_SB_.PEP0.APCC */
            }

            Name (APCC, Package (0x01)
            {
                Package (0x06)
                {
                    "DEVICE", 
                    "\\_SB.ADSP.ADCM.AUCD.QCRT", 
                    Package (0x03)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }
                    }, 

                    Package (0x03)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_xo", 
                                0x80
                            }
                        }
                    }, 

                    Package (0x03)
                    {
                        "DSTATE", 
                        One, 
                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_xo", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x03)
                    {
                        "DSTATE", 
                        0x02, 
                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_xo", 
                                Zero
                            }
                        }
                    }
                }
            })
        }

        Scope (\_SB.PEP0)
        {
            Method (G0MD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0C)
                        {
                            "COMPONENT", 
                            Zero, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x0E)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x08)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x05, 
                                Package (0x07)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            0x02
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            0x02
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            0x02
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            0x02
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            0x02
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.G0MD.GPCC */
            }

            Method (G7MD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0B)
                        {
                            "COMPONENT", 
                            0x07, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x11)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_edp2_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx2_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx2_pixel0_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx2_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx2_pixel0_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.G7MD.GPCC */
            }

            Method (G8MD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0B)
                        {
                            "COMPONENT", 
                            0x08, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x10)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_edp2_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx2_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx2_aux_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.G8MD.GPCC */
            }

            Method (G9MD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0C)
                        {
                            "COMPONENT", 
                            0x09, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x17)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_edp0_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_top_edp0_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb3_prim_phy_pipe_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb4_eud_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb30_prim_sleep_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_pixel0_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_intf_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x06)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_pixel0_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_intf_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x05, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_usb_router_link_intf_clk", 
                                            0x02
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.G9MD.GPCC */
            }

            Method (GKMD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0C)
                        {
                            "COMPONENT", 
                            0x0A, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x17)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb3_prim_phy_pipe_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb4_eud_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb30_prim_sleep_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_edp0_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_top_edp0_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_pixel1_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_intf_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x06)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_pixel1_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_link_intf_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x05, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx0_usb_router_link_intf_clk", 
                                            0x02
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.GKMD.GPCC */
            }

            Method (GLMD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0C)
                        {
                            "COMPONENT", 
                            0x0B, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x17)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_edp1_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_top_edp1_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb3_sec_phy_pipe_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb4_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb30_sec_sleep_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_pixel0_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_intf_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x06)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_pixel0_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_intf_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x05, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_usb_router_link_intf_clk", 
                                            0x02
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.GLMD.GPCC */
            }

            Method (GMMD, 0, NotSerialized)
            {
                Name (GPCC, Package (0x01)
                {
                    Package (0x04)
                    {
                        "DEVICE", 
                        0x82, 
                        "\\_SB.GPU0", 
                        Package (0x0C)
                        {
                            "COMPONENT", 
                            0x0C, 
                            Package (0x03)
                            {
                                "FSTATE", 
                                Zero, 
                                Package (0x17)
                                {
                                    "EXIT", 
                                    Package (0x02)
                                    {
                                        "NPARESOURCE", 
                                        Package (0x03)
                                        {
                                            One, 
                                            "/arc/client/rail_mmcx", 
                                            0x40
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_xo_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_edp1_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_top_edp1_phy_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "FOOTSWITCH", 
                                        Package (0x03)
                                        {
                                            "mdss_0_disp_cc_mdss_core_gdsc", 
                                            One, 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_ROTATOR", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x2FAF0800, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_hf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_disp_sf_axi_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb3_sec_phy_pipe_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb4_clkref_en", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "gcc_usb30_sec_sleep_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_rscc_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_ahb_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_pixel1_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_intf_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }
                            }, 

                            Package (0x02)
                            {
                                "FSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "INIT_FSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PRELOAD_FSTATE", 
                                One
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE", 
                                    Zero
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                One, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_APPSS_PROC", 
                                            "ICBID_SLAVE_DISPLAY_CFG", 
                                            0x023C3460, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x02, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            Zero, 
                                            0x77359400
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x03, 
                                Package (0x04)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MDP0", 
                                            "ICBID_SLAVE_MNOC_HF_MEM_NOC", 
                                            Zero, 
                                            Zero
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "BUSARB", 
                                        Package (0x05)
                                        {
                                            0x03, 
                                            "ICBID_MASTER_MNOC_HF_MEM_NOC", 
                                            "ICBID_SLAVE_EBI1", 
                                            0x35A4E900, 
                                            Zero
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x04, 
                                Package (0x06)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_pixel1_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_aux_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_clk", 
                                            One
                                        }
                                    }, 

                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_link_intf_clk", 
                                            One
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE_SET", 
                                0x05, 
                                Package (0x03)
                                {
                                    "PSTATE", 
                                    Zero, 
                                    Package (0x02)
                                    {
                                        "CLOCK", 
                                        Package (0x02)
                                        {
                                            "mdss_0_disp_cc_mdss_dptx1_usb_router_link_intf_clk", 
                                            0x02
                                        }
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PRELOAD_PSTATE", 
                                    Zero
                                }
                            }
                        }
                    }
                })
                Return (GPCC) /* \_SB_.PEP0.GMMD.GPCC */
            }
        }

        Scope (\_SB.PEP0)
        {
            Method (MPMD, 0, NotSerialized)
            {
                Return (MPCC) /* \_SB_.PEP0.MPCC */
            }

            Name (MPCC, Package (0x00){})
        }

        Scope (\_SB.PEP0)
        {
            Method (LPMD, 0, NotSerialized)
            {
                Return (LPCC) /* \_SB_.PEP0.LPCC */
            }

            Name (LPCC, Package (0x06)
            {
                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.URS0", 
                    Package (0x05)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }, 

                Package (0x08)
                {
                    "DEVICE", 
                    "\\_SB.URS0.USB0", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            Zero
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_sleep_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x08, 
                                0x4B00, 
                                0x07
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                0x0100
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                0x28000000, 
                                0x28000000
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                0x0BEBC200, 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        One, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        0x02, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0F)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_sleep_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x13
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "ABANDON_DSTATE", 
                        0x03
                    }
                }, 

                Package (0x08)
                {
                    "DEVICE", 
                    "\\_SB.URS0.UFN0", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            Zero
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_sleep_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x08, 
                                0x4B00, 
                                0x07
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                0x0100
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                0x28000000, 
                                0x28000000
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                0x0BEBC200, 
                                Zero
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        0x02, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0F)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_sleep_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_prim_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_prim_master_clk", 
                                0x09, 
                                0x13
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_prim_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_eud_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_0", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_0", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_prim_gdsc", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "ABANDON_DSTATE", 
                        0x03
                    }
                }, 

                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.URS1", 
                    Package (0x05)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }, 

                Package (0x08)
                {
                    "DEVICE", 
                    "\\_SB.URS1.USB1", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            Zero
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_sleep_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x08, 
                                0x4B00, 
                                0x07
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                0x0100
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                0x28000000, 
                                0x28000000
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                0x0BEBC200, 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        One, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        0x02, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0F)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_sleep_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x13
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "ABANDON_DSTATE", 
                        0x03
                    }
                }, 

                Package (0x08)
                {
                    "DEVICE", 
                    "\\_SB.URS1.UFN1", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "PSTATE", 
                            Zero
                        }
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_sleep_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x08, 
                                0xC8, 
                                0x09
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x08, 
                                0x4B00, 
                                0x07
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                0x0100
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                0x28000000, 
                                0x28000000
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                0x0BEBC200, 
                                Zero
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x0E)
                    {
                        "DSTATE", 
                        0x02, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x12
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x0F)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_sleep_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb3_sec_phy_pipe_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x04)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x03, 
                                0x2580, 
                                0x05
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x03)
                            {
                                "gcc_usb30_sec_master_clk", 
                                0x09, 
                                0x13
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_aggre_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_cfg_noc_usb3_sec_axi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_mock_utmi_clk", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "CLOCK", 
                            Package (0x02)
                            {
                                "gcc_usb4_clkref_en", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_USB3_1", 
                                "ICBID_SLAVE_EBI1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "BUSARB", 
                            Package (0x05)
                            {
                                0x03, 
                                "ICBID_MASTER_APPSS_PROC", 
                                "ICBID_SLAVE_USB3_1", 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "FOOTSWITCH", 
                            Package (0x02)
                            {
                                "gcc_usb30_sec_gdsc", 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "NPARESOURCE", 
                            Package (0x03)
                            {
                                One, 
                                "/arc/client/rail_cx", 
                                Zero
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "ABANDON_DSTATE", 
                        0x03
                    }
                }
            })
        }

        Scope (\_SB.PEP0)
        {
            Method (BPMD, 0, NotSerialized)
            {
                If ((STOR == One))
                {
                    Return (CPCC) /* \_SB_.PEP0.CPCC */
                }
                Else
                {
                    Return (FPCC) /* \_SB_.PEP0.FPCC */
                }
            }

            Method (SDMD, 0, NotSerialized)
            {
                Return (SDCC) /* \_SB_.PEP0.SDCC */
            }

            Name (CPCC, Package (0x01)
            {
                Package (0x06)
                {
                    "DEVICE", 
                    "\\_SB.UFS0", 
                    Package (0x07)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x05)
                        {
                            "FSTATE", 
                            Zero, 
                            Package (0x02)
                            {
                                "PSTATE_ADJUST", 
                                Package (0x02)
                                {
                                    Zero, 
                                    Zero
                                }
                            }, 

                            Package (0x02)
                            {
                                "PSTATE_ADJUST", 
                                Package (0x02)
                                {
                                    One, 
                                    Zero
                                }
                            }, 

                            Package (0x02)
                            {
                                "PSTATE_ADJUST", 
                                Package (0x02)
                                {
                                    0x02, 
                                    Zero
                                }
                            }
                        }, 

                        Package (0x05)
                        {
                            "FSTATE", 
                            One, 
                            Package (0x02)
                            {
                                "PSTATE_ADJUST", 
                                Package (0x02)
                                {
                                    0x02, 
                                    One
                                }
                            }, 

                            Package (0x02)
                            {
                                "PSTATE_ADJUST", 
                                Package (0x02)
                                {
                                    One, 
                                    One
                                }
                            }, 

                            Package (0x02)
                            {
                                "PSTATE_ADJUST", 
                                Package (0x02)
                                {
                                    Zero, 
                                    One
                                }
                            }
                        }, 

                        Package (0x04)
                        {
                            "PSTATE_SET", 
                            Zero, 
                            Package (0x02)
                            {
                                "PSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PSTATE", 
                                One
                            }
                        }, 

                        Package (0x04)
                        {
                            "PSTATE_SET", 
                            One, 
                            Package (0x02)
                            {
                                "PSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PSTATE", 
                                One
                            }
                        }, 

                        Package (0x04)
                        {
                            "PSTATE_SET", 
                            0x02, 
                            Package (0x02)
                            {
                                "PSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PSTATE", 
                                One
                            }
                        }
                    }, 

                    Package (0x06)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                0x02, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "DELAY", 
                            Package (0x01)
                            {
                                0x23
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                One, 
                                Zero
                            }
                        }
                    }, 

                    Package (0x05)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                One, 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                Zero, 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                0x02, 
                                One
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "CRASHDUMP_DSTATE", 
                        Zero
                    }
                }
            })
            Name (FPCC, Package (0x01)
            {
                Package (0x06)
                {
                    "DEVICE", 
                    "\\_SB.UFS0", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "FSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "PRELOAD_DSTATE", 
                        0x03
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }
            })
            Name (SDCC, Package (0x01)
            {
                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.SDC2", 
                    Package (0x09)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "FSTATE", 
                            One
                        }, 

                        Package (0x19)
                        {
                            "PSTATE_SET", 
                            Zero, 
                            Package (0x03)
                            {
                                "PSTATE", 
                                Zero, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                One, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x02, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x03, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x04, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x05, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x06, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x07, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x08, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x09, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x0B, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x0C, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x0D, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x0E, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x0F, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x10, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x11, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x12, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x13, 
                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        One
                                    }
                                }
                            }, 

                            Package (0x08)
                            {
                                "PSTATE", 
                                0x14, 
                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO9_C", 
                                        One, 
                                        Zero, 
                                        Zero, 
                                        Zero, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO6_C", 
                                        One, 
                                        Zero, 
                                        Zero, 
                                        Zero, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        0x23
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO9_C", 
                                        One, 
                                        0x002D2A80, 
                                        One, 
                                        0x07, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO6_C", 
                                        One, 
                                        0x002D0370, 
                                        One, 
                                        0x07, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        0x23
                                    }
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE", 
                                0x15, 
                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO6_C", 
                                        One, 
                                        0x001B7740, 
                                        One, 
                                        0x07, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        0x23
                                    }
                                }
                            }, 

                            Package (0x05)
                            {
                                "PSTATE", 
                                0x16, 
                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO9_C", 
                                        One, 
                                        0x002D2A80, 
                                        One, 
                                        0x07, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO6_C", 
                                        One, 
                                        0x002D0370, 
                                        One, 
                                        0x07, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        0x23
                                    }
                                }
                            }, 

                            Package (0x05)
                            {
                                "PSTATE", 
                                0x17, 
                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO9_C", 
                                        One, 
                                        Zero, 
                                        Zero, 
                                        Zero, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PMICVREGVOTE", 
                                    Package (0x06)
                                    {
                                        "PPP_RESOURCE_ID_LDO6_C", 
                                        One, 
                                        Zero, 
                                        Zero, 
                                        Zero, 
                                        Zero
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "DELAY", 
                                    Package (0x01)
                                    {
                                        0x23
                                    }
                                }
                            }
                        }, 

                        Package (0x05)
                        {
                            "PSTATE_SET", 
                            One, 
                            Package (0x02)
                            {
                                "PSTATE", 
                                Zero
                            }, 

                            Package (0x02)
                            {
                                "PSTATE", 
                                One
                            }, 

                            Package (0x02)
                            {
                                "PSTATE", 
                                0x02
                            }
                        }, 

                        Package (0x05)
                        {
                            "PSTATE_SET", 
                            0x02, 
                            Package (0x03)
                            {
                                "PSTATE", 
                                Zero, 
                                Package (0x02)
                                {
                                    "BUSARB", 
                                    Package (0x05)
                                    {
                                        0x03, 
                                        "ICBID_MASTER_SDCC_2", 
                                        "ICBID_SLAVE_EBI1", 
                                        0x17D78400, 
                                        0x0BEBC200
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                One, 
                                Package (0x02)
                                {
                                    "BUSARB", 
                                    Package (0x05)
                                    {
                                        0x03, 
                                        "ICBID_MASTER_SDCC_2", 
                                        "ICBID_SLAVE_EBI1", 
                                        0x0BEBC200, 
                                        0x05F5E100
                                    }
                                }
                            }, 

                            Package (0x03)
                            {
                                "PSTATE", 
                                0x02, 
                                Package (0x02)
                                {
                                    "BUSARB", 
                                    Package (0x05)
                                    {
                                        0x03, 
                                        "ICBID_MASTER_SDCC_2", 
                                        "ICBID_SLAVE_EBI1", 
                                        Zero, 
                                        Zero
                                    }
                                }
                            }
                        }, 

                        Package (0x04)
                        {
                            "PSTATE_SET", 
                            0x03, 
                            Package (0x04)
                            {
                                "PSTATE", 
                                Zero, 
                                Package (0x02)
                                {
                                    "PSTATE_ADJUST", 
                                    Package (0x02)
                                    {
                                        One, 
                                        0x02
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PSTATE_ADJUST", 
                                    Package (0x02)
                                    {
                                        0x02, 
                                        Zero
                                    }
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE", 
                                One, 
                                Package (0x02)
                                {
                                    "PSTATE_ADJUST", 
                                    Package (0x02)
                                    {
                                        One, 
                                        One
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "PSTATE_ADJUST", 
                                    Package (0x02)
                                    {
                                        0x02, 
                                        One
                                    }
                                }
                            }
                        }, 

                        Package (0x04)
                        {
                            "PSTATE_SET", 
                            0x04, 
                            Package (0x04)
                            {
                                "PSTATE", 
                                Zero, 
                                Package (0x02)
                                {
                                    "CLOCK", 
                                    Package (0x02)
                                    {
                                        "gcc_sdcc2_ahb_clk", 
                                        One
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "CLOCK", 
                                    Package (0x02)
                                    {
                                        "gcc_sdcc2_at_clk", 
                                        One
                                    }
                                }
                            }, 

                            Package (0x04)
                            {
                                "PSTATE", 
                                One, 
                                Package (0x02)
                                {
                                    "CLOCK", 
                                    Package (0x02)
                                    {
                                        "gcc_sdcc2_ahb_clk", 
                                        0x02
                                    }
                                }, 

                                Package (0x02)
                                {
                                    "CLOCK", 
                                    Package (0x02)
                                    {
                                        "gcc_sdcc2_at_clk", 
                                        0x02
                                    }
                                }
                            }
                        }
                    }, 

                    Package (0x07)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                Zero, 
                                0x16
                            }
                        }, 

                        Package (0x02)
                        {
                            "TLMMPORT", 
                            Package (0x03)
                            {
                                0x001CF000, 
                                0x7FFF, 
                                0x1FE4
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                0x02, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                0x04, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                One, 
                                0x02
                            }
                        }
                    }, 

                    Package (0x07)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                One, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                0x04, 
                                One
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                0x02, 
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "TLMMPORT", 
                            Package (0x03)
                            {
                                0x001CF000, 
                                0x7FFF, 
                                0x0A00
                            }
                        }, 

                        Package (0x02)
                        {
                            "PSTATE_ADJUST", 
                            Package (0x02)
                            {
                                Zero, 
                                0x17
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "CRASHDUMP_EXCEPTION", 
                        Package (0x02)
                        {
                            "EXECUTE_FUNCTION", 
                            Package (0x01)
                            {
                                "ExecuteOcdSdCardExceptions"
                            }
                        }
                    }, 

                    Package (0x02)
                    {
                        "CRASHDUMP_DSTATE", 
                        Zero
                    }
                }
            })
        }

        Scope (\_SB.PEP0)
        {
            Method (EWMD, 0, NotSerialized)
            {
                Return (WBRC) /* \_SB_.PEP0.WBRC */
            }

            Name (WBRC, Package (0x01)
            {
                Package (0x05)
                {
                    "DEVICE", 
                    "\\_SB.FMRT", 
                    Package (0x03)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }
                    }, 

                    Package (0x04)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_LDO7_E", 
                                One, 
                                0x002AB980, 
                                One, 
                                0x04, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_SMPS10_B", 
                                0x02, 
                                0x001B7740, 
                                One, 
                                Zero, 
                                Zero
                            }
                        }
                    }, 

                    Package (0x04)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_SMPS10_B", 
                                0x02, 
                                0x001B7740, 
                                Zero, 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_LDO7_E", 
                                One, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            }
                        }
                    }
                }
            })
        }

        Scope (\_SB.PEP0)
        {
            Method (PEMD, 0, NotSerialized)
            {
                Return (PEMC) /* \_SB_.PEP0.PEMC */
            }

            Name (PEMC, Package (0x04)
            {
                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.PCI0", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "FSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }, 

                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.PCI0.RP1", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "FSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }, 

                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.PCI1", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "FSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }, 

                Package (0x07)
                {
                    "DEVICE", 
                    "\\_SB.PCI1.RP1", 
                    Package (0x04)
                    {
                        "COMPONENT", 
                        Zero, 
                        Package (0x02)
                        {
                            "FSTATE", 
                            Zero
                        }, 

                        Package (0x02)
                        {
                            "FSTATE", 
                            One
                        }
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "DSTATE", 
                        0x03
                    }
                }
            })
        }

        Device (WLDS)
        {
            Name (_HID, "QCOM1AD0")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Scope (\_SB.PEP0)
        {
            Method (LPMX, 0, NotSerialized)
            {
                Return (LPXC) /* \_SB_.PEP0.LPXC */
            }

            Name (LPXC, Package (0x01)
            {
                Package (0x04)
                {
                    "DEVICE", 
                    "\\_SB.TSC5", 
                    Package (0x07)
                    {
                        "DSTATE", 
                        Zero, 
                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_LDO3_C", 
                                One, 
                                0x002DE600, 
                                One, 
                                0x04, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_LDO8_C", 
                                One, 
                                0x001B7740, 
                                One, 
                                0x04, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "DELAY", 
                            Package (0x01)
                            {
                                0x02
                            }
                        }, 

                        Package (0x02)
                        {
                            "TLMMGPIO", 
                            Package (0x06)
                            {
                                0x16, 
                                One, 
                                Zero, 
                                One, 
                                0x03, 
                                0x03
                            }
                        }, 

                        Package (0x02)
                        {
                            "DELAY", 
                            Package (0x01)
                            {
                                0xC8
                            }
                        }
                    }, 

                    Package (0x05)
                    {
                        "DSTATE", 
                        0x03, 
                        Package (0x02)
                        {
                            "TLMMGPIO", 
                            Package (0x06)
                            {
                                0x16, 
                                Zero, 
                                Zero, 
                                One, 
                                One, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_LDO8_C", 
                                One, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            }
                        }, 

                        Package (0x02)
                        {
                            "PMICVREGVOTE", 
                            Package (0x06)
                            {
                                "PPP_RESOURCE_ID_LDO3_C", 
                                One, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            }
                        }
                    }
                }
            })
        }

        Scope (\_SB.PEP0)
        {
        }

        Scope (\_SB.PEP0)
        {
        }

        Device (BAM1)
        {
            Name (_HID, "QCOM1A0A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, One)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x01DC4000,         // Address Base
                        0x00024000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000130,
                    }
                })
                Return (RBUF) /* \_SB_.BAM1._CRS.RBUF */
            }
        }

        Device (BAM5)
        {
            Name (_HID, "QCOM1A0A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x05)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x03A84000,         // Address Base
                        0x00032000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000C4,
                    }
                })
                Return (RBUF) /* \_SB_.BAM5._CRS.RBUF */
            }
        }

        Device (BAMD)
        {
            Name (_HID, "QCOM1A0A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x0D)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0A904000,         // Address Base
                        0x00017000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000A9,
                    }
                })
                Return (RBUF) /* \_SB_.BAMD._CRS.RBUF */
            }
        }

        Device (BAME)
        {
            Name (_HID, "QCOM1A0A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x0E)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x06064000,         // Address Base
                        0x00015000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000C7,
                    }
                })
                Return (RBUF) /* \_SB_.BAME._CRS.RBUF */
            }
        }

        Device (BAMF)
        {
            Name (_HID, "QCOM1A0A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x0F)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0A704000,         // Address Base
                        0x00017000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000A4,
                    }
                })
                Return (RBUF) /* \_SB_.BAMF._CRS.RBUF */
            }
        }

        Device (UARD)
        {
            Name (_HID, "QCOM1A16")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x04)  // _UID: Unique ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_STR, Unicode ("QUP_0_SE_3,DBG"))  // _STR: Description String
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0098C000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000027C,
                    }
                    GpioInt (Edge, ActiveLow, Exclusive, PullDown, 0x0000,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0013
                        }
                })
                Return (RBUF) /* \_SB_.UARD._CRS.RBUF */
            }
        }

        Device (I2C5)
        {
            Name (_HID, "QCOM1A10")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x05)  // _UID: Unique ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_STR, Unicode ("QUP_0_SE_4"))  // _STR: Description String
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00990000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000027D,
                    }
                })
                Return (RBUF) /* \_SB_.I2C5._CRS.RBUF */
            }
        }

        Device (IC14)
        {
            Name (_HID, "QCOM1A10")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x0E)  // _UID: Unique ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_STR, Unicode ("QUP_1_SE_5"))  // _STR: Description String
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00A94000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000186,
                    }
                })
                Return (RBUF) /* \_SB_.IC14._CRS.RBUF */
            }
        }

        Device (IC18)
        {
            Name (_HID, "QCOM1A10")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x12)  // _UID: Unique ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_STR, Unicode ("QUP_2_SE_1"))  // _STR: Description String
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00884000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000267,
                    }
                })
                Return (RBUF) /* \_SB_.IC18._CRS.RBUF */
            }
        }

        Device (UR21)
        {
            Name (_HID, "QCOM1A16")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x15)  // _UID: Unique ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_STR, Unicode ("QUP_2_SE_4,4W,BT"))  // _STR: Description String
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00890000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000026A,
                    }
                    GpioInt (Level, ActiveHigh, Exclusive, PullDown, 0x0000,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0047
                        }
                })
                Return (RBUF) /* \_SB_.UR21._CRS.RBUF */
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }
        }

        Device (RPEN)
        {
            Name (_HID, "QCOM1AE1")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (PILC)
        {
            Name (_HID, "QCOM1AE0")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (CDI)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PILC, 
                \_SB.RPEN
            })
            Name (_HID, "QCOM1A2F")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (SCSS)
        {
            Name (_DEP, Package (0x07)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.PILC, 
                \_SB.GLNK, 
                \_SB.IPC0, 
                \_SB.RPEN, 
                \_SB.SSDD, 
                \_SB.ARPC
            })
            Name (_HID, "QCOM1A1F")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000C6,
                    }
                })
                Return (RBUF) /* \_SB_.SCSS._CRS.RBUF */
            }
        }

        Device (ADSP)
        {
            Name (_DEP, Package (0x09)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.PILC, 
                \_SB.GLNK, 
                \_SB.IPC0, 
                \_SB.RPEN, 
                \_SB.SSDD, 
                \_SB.ARPC, 
                \_SB.TFTP, 
                \_SB.PDSR
            })
            Name (_HID, "QCOM1A1B")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000206,
                    }
                })
                Return (RBUF) /* \_SB_.ADSP._CRS.RBUF */
            }

            Device (SLM1)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    Name (RBUF, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadWrite,
                            0x03AC0000,         // Address Base
                            0x0002C000,         // Address Length
                            )
                        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                        {
                            0x000000C3,
                        }
                    })
                    Return (RBUF) /* \_SB_.ADSP.SLM1._CRS.RBUF */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }

            Device (ADCM)
            {
                Alias (\_SB.PSUB, _SUB)
                Name (_ADR, One)  // _ADR: Address
                Name (_DEP, Package (0x02)  // _DEP: Dependencies
                {
                    \_SB.MMU0, 
                    \_SB.IMM0
                })
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (CHLD, 0, NotSerialized)
                {
                    Return (Package (0x01)
                    {
                        "ADCM\\QCOM1AC1"
                    })
                }

                Device (AUCD)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Alias (\_SB.PSUB, _SUB)
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                    {
                        Name (RBUF, ResourceTemplate ()
                        {
                            GpioIo (Exclusive, PullNone, 0x0000, 0x0640, IoRestrictionNone,
                                "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                                )
                                {   // Pin list
                                    0x006A
                                }
                            GpioIo (Exclusive, PullNone, 0x0000, 0x0640, IoRestrictionNone,
                                "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                                )
                                {   // Pin list
                                    0x00B2
                                }
                            GpioIo (Exclusive, PullNone, 0x0000, 0x0640, IoRestrictionNone,
                                "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                                )
                                {   // Pin list
                                    0x00B3
                                }
                            GpioIo (Exclusive, PullNone, 0x0000, 0x0640, IoRestrictionNone,
                                "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                                )
                                {   // Pin list
                                    0x0061
                                }
                            GpioIo (Exclusive, PullNone, 0x0000, 0x0640, IoRestrictionNone,
                                "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                                )
                                {   // Pin list
                                    0x0062
                                }
                            GpioInt (Edge, ActiveBoth, ExclusiveAndWake, PullDown, 0x0000,
                                "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                                )
                                {   // Pin list
                                    0x0140
                                }
                            Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                            {
                                0x000003DF,
                            }
                            Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                            {
                                0x000000BB,
                            }
                            Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                            {
                                0x000000CA,
                            }
                            Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                            {
                                0x000000CB,
                            }
                        })
                        Return (RBUF) /* \_SB_.ADSP.ADCM.AUCD._CRS.RBUF */
                    }

                    Method (CHLD, 0, NotSerialized)
                    {
                        Name (CH, Package (0x01)
                        {
                            "AUCD\\QCOM1A29"
                        })
                        Return (CH) /* \_SB_.ADSP.ADCM.AUCD.CHLD.CH__ */
                    }

                    Device (QCRT)
                    {
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_ADR, Zero)  // _ADR: Address
                    }
                }
            }
        }

        Device (AMSS)
        {
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_DEP, Package (0x09)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.GLNK, 
                \_SB.PILC, 
                \_SB.RFS0, 
                \_SB.RPEN, 
                \_SB.SSDD, 
                \_SB.IPC0, 
                \_SB.TFTP, 
                \_SB.PDSR
            })
            Name (_HID, "QCOM1A1C")  // _HID: Hardware ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000128,
                    }
                })
                Return (RBUF) /* \_SB_.AMSS._CRS.RBUF */
            }
        }

        Device (QSM)
        {
            Name (_HID, "QCOM1A1E")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (0x04)  // _DEP: Dependencies
            {
                \_SB.GLNK, 
                \_SB.IPC0, 
                \_SB.PILC, 
                \_SB.RPEN
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (SSDD)
        {
            Name (_HID, "QCOM1A20")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.GLNK
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (PDSR)
        {
            Name (_HID, "QCOM1ADF")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.GLNK, 
                \_SB.IPC0
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (NSP0)
        {
            Name (_DEP, Package (0x08)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.PILC, 
                \_SB.GLNK, 
                \_SB.IPC0, 
                \_SB.RPEN, 
                \_SB.SSDD, 
                \_SB.ARPC, 
                \_SB.PDSR
            })
            Name (_HID, "QCOM1AB0")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000262,
                    }
                })
                Return (RBUF) /* \_SB_.NSP0._CRS.RBUF */
            }
        }

        Device (CSW0)
        {
            Name (_HID, "QCOM1AC3")  // _HID: Hardware ID
            Name (_CID, "QCOMFFE0")  // _CID: Compatible ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.NSP0, 
                \_SB.SBTD
            })
        }

        Device (SBTD)
        {
            Name (_HID, "QCOM1AE5")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (SPSS)
        {
            Name (_DEP, Package (0x04)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.PILC, 
                \_SB.RPEN, 
                \_SB.GLNK
            })
            Name (_HID, "QCOM1A8D")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000180,
                    }
                    Memory32Fixed (ReadWrite,
                        0x01881028,         // Address Base
                        0x00000004,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x01881024,         // Address Base
                        0x00000004,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0188101C,         // Address Base
                        0x00000004,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0188103C,         // Address Base
                        0x00000004,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0188200C,         // Address Base
                        0x00000004,         // Address Length
                        )
                })
                Return (RBUF) /* \_SB_.SPSS._CRS.RBUF */
            }
        }

        Device (TFTP)
        {
            Name (_HID, "QCOM1ADC")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.IPC0
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (QCSK)
        {
            Name (_HID, "QCOM1AAC")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }
        }

        Scope (\_SB.ADSP)
        {
        }

        Scope (\_SB.AMSS)
        {
        }

        Scope (\_SB.SCSS)
        {
        }

        Scope (\_SB.PILC)
        {
        }

        Scope (\_SB.CDI)
        {
        }

        Scope (\_SB.RPEN)
        {
        }

        Scope (\_SB.NSP0)
        {
            Name (_CID, "QCOMFFE7")  // _CID: Compatible ID
        }

        Scope (\_SB.AMSS)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_SUB, 0, NotSerialized)  // _SUB: Subsystem ID
            {
                Return (\_SB.PSUB)
            }
        }

        Device (LLC)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_HID, "QCOM1A83")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Alias (\_SB.SVMJ, _HRV)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x09600000,         // Address Base
                        0x00050000,         // Address Length
                        )
                    Memory32Fixed (ReadOnly,
                        0x01FC8088,         // Address Base
                        0x00000004,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000266,
                    }
                })
            }
        }

        Device (MMU0)
        {
            Name (_HID, "QCOM1A09")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Alias (\_SB.SVMJ, _HRV)
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x15000000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000081,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000082,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000083,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000084,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000085,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000086,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000087,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000088,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000089,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000008A,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000008B,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000008C,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000008D,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000008E,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000008F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000090,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000091,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000092,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000093,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000094,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000095,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000096,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000D5,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000D6,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000D7,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000D8,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000D9,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000DA,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000DB,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000DC,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000DD,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000DE,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000DF,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000E0,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000015B,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000015C,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000015D,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000015E,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000015F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000160,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000161,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000162,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000163,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000164,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000165,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000166,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000167,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000168,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000169,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000016A,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000016B,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000016C,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000016D,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000016E,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000016F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000170,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000171,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000172,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000173,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000174,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000175,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000176,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000177,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000178,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000179,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001AB,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001AC,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001AD,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001AE,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001AF,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001B0,
                    }
                })
            }
        }

        Device (MMU1)
        {
            Name (_HID, "QCOM1A09")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Alias (\_SB.SVMJ, _HRV)
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x03DA0000,         // Address Base
                        0x00020000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002C6,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002C7,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002C8,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002C9,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002CA,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002CB,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002CC,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002CD,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002CE,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002CF,
                    }
                })
            }
        }

        Device (IMM0)
        {
            Name (_HID, "QCOM1A8F")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
        }

        Device (IMM1)
        {
            Name (_HID, "QCOM1A8F")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, One)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (GPU0)
        {
            Name (_HID, "QCOM1A36")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CLS, 0x0003000000000000)  // _CLS: Class Code
            Device (MON0)
            {
                Method (_ADR, 0, NotSerialized)  // _ADR: Address
                {
                    Return (Zero)
                }
            }

            Name (_DEP, Package (0x0A)  // _DEP: Dependencies
            {
                \_SB.MMU0, 
                \_SB.MMU1, 
                \_SB.IMM0, 
                \_SB.IMM1, 
                \_SB.PEP0, 
                \_SB.PMIC, 
                \_SB.PILC, 
                \_SB.RPEN, 
                \_SB.TREE, 
                \_SB.SCM0
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (ABUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0AE00000,         // Address Base
                        0x00200000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x088E0000,         // Address Base
                        0x00034000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000073,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000375,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000036E,
                    }
                    Memory32Fixed (ReadWrite,
                        0x03D00000,         // Address Base
                        0x0003F010,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x03D60000,         // Address Base
                        0x0003F000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000014C,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000014D,
                    }
                    Memory32Fixed (ReadWrite,
                        0x0B290000,         // Address Base
                        0x00010000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0B490000,         // Address Base
                        0x00010000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x03D90000,         // Address Base
                        0x00009000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x03DE0000,         // Address Base
                        0x00010000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0C200000,         // Address Base
                        0x0000FFFF,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AA00000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000000CE,
                    }
                    GpioIo (Exclusive, PullUp, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0026
                        }
                })
                Return (ABUF) /* \_SB_.GPU0._CRS.ABUF */
            }

            Method (RESI, 0, NotSerialized)
            {
                Name (AINF, Package (0x13)
                {
                    0x03, 
                    Zero, 
                    Package (0x03)
                    {
                        "RESOURCE", 
                        "MDP_REGS", 
                        "DISPLAY"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "DP_PHY_REGS", 
                        "DISPLAY"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "VSYNC_INTERRUPT", 
                        "DISPLAY"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "USB4_DP_AP_0_INTERRUPT", 
                        "DISPLAY"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "USB4_DP_AP_1_INTERRUPT", 
                        "DISPLAY"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GFX_REGS", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GFX_REG_CONT", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GFX_INTERRUPT", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GFX_LPAC_INTERRUPT", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GPU_PDC_SEQ_MEM", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GPU_PDC_REGS", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GPU_CC", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GPU_RSCC", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "GPU_RPMH_CPRF", 
                        "GRAPHICS"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "VIDEO_REGS", 
                        "VIDEO"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "VIDC_INTERRUPT", 
                        "VIDEO"
                    }, 

                    Package (0x03)
                    {
                        "RESOURCE", 
                        "DSI_PANEL_RESET", 
                        "DISPLAY"
                    }
                })
                Return (AINF) /* \_SB_.GPU0.RESI.AINF */
            }

            Method (_ROM, 3, NotSerialized)  // _ROM: Read-Only Memory
            {
                Name (PCFG, Buffer (0x1469)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x50, 0x61, 0x6E, 0x65, 0x6C, 0x4E, 0x61, 0x6D,  // PanelNam
                    /* 0030 */  0x65, 0x3E, 0x4C, 0x53, 0x30, 0x36, 0x30, 0x52,  // e>LS060R
                    /* 0038 */  0x31, 0x53, 0x58, 0x30, 0x33, 0x3C, 0x2F, 0x50,  // 1SX03</P
                    /* 0040 */  0x61, 0x6E, 0x65, 0x6C, 0x4E, 0x61, 0x6D, 0x65,  // anelName
                    /* 0048 */  0x3E, 0x0A, 0x3C, 0x50, 0x61, 0x6E, 0x65, 0x6C,  // >.<Panel
                    /* 0050 */  0x44, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74,  // Descript
                    /* 0058 */  0x69, 0x6F, 0x6E, 0x3E, 0x53, 0x68, 0x61, 0x72,  // ion>Shar
                    /* 0060 */  0x70, 0x20, 0x44, 0x75, 0x61, 0x6C, 0x20, 0x44,  // p Dual D
                    /* 0068 */  0x53, 0x49, 0x20, 0x56, 0x69, 0x64, 0x65, 0x6F,  // SI Video
                    /* 0070 */  0x20, 0x4D, 0x6F, 0x64, 0x65, 0x20, 0x50, 0x61,  //  Mode Pa
                    /* 0078 */  0x6E, 0x65, 0x6C, 0x20, 0x77, 0x69, 0x74, 0x68,  // nel with
                    /* 0080 */  0x20, 0x44, 0x53, 0x43, 0x20, 0x28, 0x32, 0x31,  //  DSC (21
                    /* 0088 */  0x36, 0x30, 0x78, 0x33, 0x38, 0x34, 0x30, 0x20,  // 60x3840 
                    /* 0090 */  0x32, 0x34, 0x62, 0x70, 0x70, 0x29, 0x3C, 0x2F,  // 24bpp)</
                    /* 0098 */  0x50, 0x61, 0x6E, 0x65, 0x6C, 0x44, 0x65, 0x73,  // PanelDes
                    /* 00A0 */  0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6F, 0x6E,  // cription
                    /* 00A8 */  0x3E, 0x0A, 0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70,  // >.<Group
                    /* 00B0 */  0x20, 0x69, 0x64, 0x3D, 0x27, 0x45, 0x44, 0x49,  //  id='EDI
                    /* 00B8 */  0x44, 0x20, 0x43, 0x6F, 0x6E, 0x66, 0x69, 0x67,  // D Config
                    /* 00C0 */  0x75, 0x72, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x27,  // uration'
                    /* 00C8 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x4D,  // >.    <M
                    /* 00D0 */  0x61, 0x6E, 0x75, 0x66, 0x61, 0x63, 0x74, 0x75,  // anufactu
                    /* 00D8 */  0x72, 0x65, 0x49, 0x44, 0x3E, 0x30, 0x78, 0x31,  // reID>0x1
                    /* 00E0 */  0x30, 0x34, 0x44, 0x3C, 0x2F, 0x4D, 0x61, 0x6E,  // 04D</Man
                    /* 00E8 */  0x75, 0x66, 0x61, 0x63, 0x74, 0x75, 0x72, 0x65,  // ufacture
                    /* 00F0 */  0x49, 0x44, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // ID>.    
                    /* 00F8 */  0x3C, 0x50, 0x72, 0x6F, 0x64, 0x75, 0x63, 0x74,  // <Product
                    /* 0100 */  0x43, 0x6F, 0x64, 0x65, 0x3E, 0x38, 0x35, 0x30,  // Code>850
                    /* 0108 */  0x3C, 0x2F, 0x50, 0x72, 0x6F, 0x64, 0x75, 0x63,  // </Produc
                    /* 0110 */  0x74, 0x43, 0x6F, 0x64, 0x65, 0x3E, 0x0A, 0x20,  // tCode>. 
                    /* 0118 */  0x20, 0x20, 0x20, 0x3C, 0x53, 0x65, 0x72, 0x69,  //    <Seri
                    /* 0120 */  0x61, 0x6C, 0x4E, 0x75, 0x6D, 0x62, 0x65, 0x72,  // alNumber
                    /* 0128 */  0x3E, 0x30, 0x78, 0x30, 0x30, 0x30, 0x30, 0x30,  // >0x00000
                    /* 0130 */  0x31, 0x3C, 0x2F, 0x53, 0x65, 0x72, 0x69, 0x61,  // 1</Seria
                    /* 0138 */  0x6C, 0x4E, 0x75, 0x6D, 0x62, 0x65, 0x72, 0x3E,  // lNumber>
                    /* 0140 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x57, 0x65,  // .    <We
                    /* 0148 */  0x65, 0x6B, 0x6F, 0x66, 0x4D, 0x61, 0x6E, 0x75,  // ekofManu
                    /* 0150 */  0x66, 0x61, 0x63, 0x74, 0x75, 0x72, 0x65, 0x3E,  // facture>
                    /* 0158 */  0x30, 0x78, 0x30, 0x31, 0x3C, 0x2F, 0x57, 0x65,  // 0x01</We
                    /* 0160 */  0x65, 0x6B, 0x6F, 0x66, 0x4D, 0x61, 0x6E, 0x75,  // ekofManu
                    /* 0168 */  0x66, 0x61, 0x63, 0x74, 0x75, 0x72, 0x65, 0x3E,  // facture>
                    /* 0170 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x59, 0x65,  // .    <Ye
                    /* 0178 */  0x61, 0x72, 0x6F, 0x66, 0x4D, 0x61, 0x6E, 0x75,  // arofManu
                    /* 0180 */  0x66, 0x61, 0x63, 0x74, 0x75, 0x72, 0x65, 0x3E,  // facture>
                    /* 0188 */  0x30, 0x78, 0x31, 0x42, 0x3C, 0x2F, 0x59, 0x65,  // 0x1B</Ye
                    /* 0190 */  0x61, 0x72, 0x6F, 0x66, 0x4D, 0x61, 0x6E, 0x75,  // arofManu
                    /* 0198 */  0x66, 0x61, 0x63, 0x74, 0x75, 0x72, 0x65, 0x3E,  // facture>
                    /* 01A0 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x45, 0x44,  // .    <ED
                    /* 01A8 */  0x49, 0x44, 0x56, 0x65, 0x72, 0x73, 0x69, 0x6F,  // IDVersio
                    /* 01B0 */  0x6E, 0x3E, 0x31, 0x3C, 0x2F, 0x45, 0x44, 0x49,  // n>1</EDI
                    /* 01B8 */  0x44, 0x56, 0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E,  // DVersion
                    /* 01C0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x45,  // >.    <E
                    /* 01C8 */  0x44, 0x49, 0x44, 0x52, 0x65, 0x76, 0x69, 0x73,  // DIDRevis
                    /* 01D0 */  0x69, 0x6F, 0x6E, 0x3E, 0x33, 0x3C, 0x2F, 0x45,  // ion>3</E
                    /* 01D8 */  0x44, 0x49, 0x44, 0x52, 0x65, 0x76, 0x69, 0x73,  // DIDRevis
                    /* 01E0 */  0x69, 0x6F, 0x6E, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ion>.   
                    /* 01E8 */  0x20, 0x3C, 0x56, 0x69, 0x64, 0x65, 0x6F, 0x49,  //  <VideoI
                    /* 01F0 */  0x6E, 0x70, 0x75, 0x74, 0x44, 0x65, 0x66, 0x69,  // nputDefi
                    /* 01F8 */  0x6E, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x3E, 0x30,  // nition>0
                    /* 0200 */  0x78, 0x38, 0x30, 0x3C, 0x2F, 0x56, 0x69, 0x64,  // x80</Vid
                    /* 0208 */  0x65, 0x6F, 0x49, 0x6E, 0x70, 0x75, 0x74, 0x44,  // eoInputD
                    /* 0210 */  0x65, 0x66, 0x69, 0x6E, 0x69, 0x74, 0x69, 0x6F,  // efinitio
                    /* 0218 */  0x6E, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // n>.    <
                    /* 0220 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 0228 */  0x61, 0x6C, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6E,  // alScreen
                    /* 0230 */  0x53, 0x69, 0x7A, 0x65, 0x3E, 0x30, 0x78, 0x30,  // Size>0x0
                    /* 0238 */  0x37, 0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A,  // 7</Horiz
                    /* 0240 */  0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x53, 0x63, 0x72,  // ontalScr
                    /* 0248 */  0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x3E,  // eenSize>
                    /* 0250 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56, 0x65,  // .    <Ve
                    /* 0258 */  0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53, 0x63,  // rticalSc
                    /* 0260 */  0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65,  // reenSize
                    /* 0268 */  0x3E, 0x30, 0x78, 0x30, 0x43, 0x3C, 0x2F, 0x56,  // >0x0C</V
                    /* 0270 */  0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53,  // erticalS
                    /* 0278 */  0x63, 0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A,  // creenSiz
                    /* 0280 */  0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // e>.    <
                    /* 0288 */  0x44, 0x69, 0x73, 0x70, 0x6C, 0x61, 0x79, 0x54,  // DisplayT
                    /* 0290 */  0x72, 0x61, 0x6E, 0x73, 0x66, 0x65, 0x72, 0x43,  // ransferC
                    /* 0298 */  0x68, 0x61, 0x72, 0x61, 0x63, 0x74, 0x65, 0x72,  // haracter
                    /* 02A0 */  0x69, 0x73, 0x74, 0x69, 0x63, 0x73, 0x3E, 0x30,  // istics>0
                    /* 02A8 */  0x78, 0x37, 0x38, 0x3C, 0x2F, 0x44, 0x69, 0x73,  // x78</Dis
                    /* 02B0 */  0x70, 0x6C, 0x61, 0x79, 0x54, 0x72, 0x61, 0x6E,  // playTran
                    /* 02B8 */  0x73, 0x66, 0x65, 0x72, 0x43, 0x68, 0x61, 0x72,  // sferChar
                    /* 02C0 */  0x61, 0x63, 0x74, 0x65, 0x72, 0x69, 0x73, 0x74,  // acterist
                    /* 02C8 */  0x69, 0x63, 0x73, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ics>.   
                    /* 02D0 */  0x20, 0x3C, 0x46, 0x65, 0x61, 0x74, 0x75, 0x72,  //  <Featur
                    /* 02D8 */  0x65, 0x53, 0x75, 0x70, 0x70, 0x6F, 0x72, 0x74,  // eSupport
                    /* 02E0 */  0x3E, 0x30, 0x78, 0x32, 0x3C, 0x2F, 0x46, 0x65,  // >0x2</Fe
                    /* 02E8 */  0x61, 0x74, 0x75, 0x72, 0x65, 0x53, 0x75, 0x70,  // atureSup
                    /* 02F0 */  0x70, 0x6F, 0x72, 0x74, 0x3E, 0x0A, 0x20, 0x20,  // port>.  
                    /* 02F8 */  0x20, 0x20, 0x3C, 0x52, 0x65, 0x64, 0x2E, 0x47,  //   <Red.G
                    /* 0300 */  0x72, 0x65, 0x65, 0x6E, 0x42, 0x69, 0x74, 0x73,  // reenBits
                    /* 0308 */  0x3E, 0x30, 0x78, 0x41, 0x35, 0x3C, 0x2F, 0x52,  // >0xA5</R
                    /* 0310 */  0x65, 0x64, 0x2E, 0x47, 0x72, 0x65, 0x65, 0x6E,  // ed.Green
                    /* 0318 */  0x42, 0x69, 0x74, 0x73, 0x3E, 0x0A, 0x20, 0x20,  // Bits>.  
                    /* 0320 */  0x20, 0x20, 0x3C, 0x42, 0x6C, 0x75, 0x65, 0x2E,  //   <Blue.
                    /* 0328 */  0x57, 0x68, 0x69, 0x74, 0x65, 0x42, 0x69, 0x74,  // WhiteBit
                    /* 0330 */  0x73, 0x3E, 0x30, 0x78, 0x35, 0x38, 0x3C, 0x2F,  // s>0x58</
                    /* 0338 */  0x42, 0x6C, 0x75, 0x65, 0x2E, 0x57, 0x68, 0x69,  // Blue.Whi
                    /* 0340 */  0x74, 0x65, 0x42, 0x69, 0x74, 0x73, 0x3E, 0x0A,  // teBits>.
                    /* 0348 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x52, 0x65, 0x64,  //     <Red
                    /* 0350 */  0x58, 0x3E, 0x30, 0x78, 0x41, 0x36, 0x3C, 0x2F,  // X>0xA6</
                    /* 0358 */  0x52, 0x65, 0x64, 0x58, 0x3E, 0x0A, 0x20, 0x20,  // RedX>.  
                    /* 0360 */  0x20, 0x20, 0x3C, 0x52, 0x65, 0x64, 0x59, 0x3E,  //   <RedY>
                    /* 0368 */  0x30, 0x78, 0x35, 0x34, 0x3C, 0x2F, 0x52, 0x65,  // 0x54</Re
                    /* 0370 */  0x64, 0x59, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // dY>.    
                    /* 0378 */  0x3C, 0x47, 0x72, 0x65, 0x65, 0x6E, 0x58, 0x3E,  // <GreenX>
                    /* 0380 */  0x30, 0x78, 0x33, 0x33, 0x3C, 0x2F, 0x47, 0x72,  // 0x33</Gr
                    /* 0388 */  0x65, 0x65, 0x6E, 0x58, 0x3E, 0x0A, 0x20, 0x20,  // eenX>.  
                    /* 0390 */  0x20, 0x20, 0x3C, 0x47, 0x72, 0x65, 0x65, 0x6E,  //   <Green
                    /* 0398 */  0x59, 0x3E, 0x30, 0x78, 0x42, 0x33, 0x3C, 0x2F,  // Y>0xB3</
                    /* 03A0 */  0x47, 0x72, 0x65, 0x65, 0x6E, 0x59, 0x3E, 0x0A,  // GreenY>.
                    /* 03A8 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x6C, 0x75,  //     <Blu
                    /* 03B0 */  0x65, 0x58, 0x3E, 0x30, 0x78, 0x32, 0x36, 0x3C,  // eX>0x26<
                    /* 03B8 */  0x2F, 0x42, 0x6C, 0x75, 0x65, 0x58, 0x3E, 0x0A,  // /BlueX>.
                    /* 03C0 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x6C, 0x75,  //     <Blu
                    /* 03C8 */  0x65, 0x59, 0x3E, 0x30, 0x78, 0x31, 0x32, 0x3C,  // eY>0x12<
                    /* 03D0 */  0x2F, 0x42, 0x6C, 0x75, 0x65, 0x59, 0x3E, 0x0A,  // /BlueY>.
                    /* 03D8 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x57, 0x68, 0x69,  //     <Whi
                    /* 03E0 */  0x74, 0x65, 0x58, 0x3E, 0x30, 0x78, 0x34, 0x46,  // teX>0x4F
                    /* 03E8 */  0x3C, 0x2F, 0x57, 0x68, 0x69, 0x74, 0x65, 0x58,  // </WhiteX
                    /* 03F0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x57,  // >.    <W
                    /* 03F8 */  0x68, 0x69, 0x74, 0x65, 0x59, 0x3E, 0x30, 0x78,  // hiteY>0x
                    /* 0400 */  0x35, 0x34, 0x3C, 0x2F, 0x57, 0x68, 0x69, 0x74,  // 54</Whit
                    /* 0408 */  0x65, 0x59, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // eY>.    
                    /* 0410 */  0x3C, 0x45, 0x73, 0x74, 0x61, 0x62, 0x6C, 0x69,  // <Establi
                    /* 0418 */  0x73, 0x68, 0x65, 0x64, 0x54, 0x69, 0x6D, 0x69,  // shedTimi
                    /* 0420 */  0x6E, 0x67, 0x73, 0x49, 0x3E, 0x30, 0x78, 0x30,  // ngsI>0x0
                    /* 0428 */  0x3C, 0x2F, 0x45, 0x73, 0x74, 0x61, 0x62, 0x6C,  // </Establ
                    /* 0430 */  0x69, 0x73, 0x68, 0x65, 0x64, 0x54, 0x69, 0x6D,  // ishedTim
                    /* 0438 */  0x69, 0x6E, 0x67, 0x73, 0x49, 0x3E, 0x0A, 0x20,  // ingsI>. 
                    /* 0440 */  0x20, 0x20, 0x20, 0x3C, 0x45, 0x73, 0x74, 0x61,  //    <Esta
                    /* 0448 */  0x62, 0x6C, 0x69, 0x73, 0x68, 0x65, 0x64, 0x54,  // blishedT
                    /* 0450 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x49, 0x49,  // imingsII
                    /* 0458 */  0x3E, 0x30, 0x78, 0x30, 0x3C, 0x2F, 0x45, 0x73,  // >0x0</Es
                    /* 0460 */  0x74, 0x61, 0x62, 0x6C, 0x69, 0x73, 0x68, 0x65,  // tablishe
                    /* 0468 */  0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73,  // dTimings
                    /* 0470 */  0x49, 0x49, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // II>.    
                    /* 0478 */  0x3C, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61, 0x63,  // <Manufac
                    /* 0480 */  0x74, 0x75, 0x72, 0x65, 0x73, 0x54, 0x69, 0x6D,  // turesTim
                    /* 0488 */  0x69, 0x6E, 0x67, 0x3E, 0x30, 0x78, 0x30, 0x3C,  // ing>0x0<
                    /* 0490 */  0x2F, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61, 0x63,  // /Manufac
                    /* 0498 */  0x74, 0x75, 0x72, 0x65, 0x73, 0x54, 0x69, 0x6D,  // turesTim
                    /* 04A0 */  0x69, 0x6E, 0x67, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ing>.   
                    /* 04A8 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 04B0 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 04B8 */  0x73, 0x31, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s1/>.   
                    /* 04C0 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 04C8 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 04D0 */  0x73, 0x32, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s2/>.   
                    /* 04D8 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 04E0 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 04E8 */  0x73, 0x33, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s3/>.   
                    /* 04F0 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 04F8 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 0500 */  0x73, 0x34, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s4/>.   
                    /* 0508 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 0510 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 0518 */  0x73, 0x35, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s5/>.   
                    /* 0520 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 0528 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 0530 */  0x73, 0x36, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s6/>.   
                    /* 0538 */  0x20, 0x3C, 0x53, 0x74, 0x61, 0x6E, 0x64, 0x61,  //  <Standa
                    /* 0540 */  0x72, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // rdTiming
                    /* 0548 */  0x73, 0x37, 0x2F, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // s7/>.   
                    /* 0550 */  0x20, 0x3C, 0x53, 0x69, 0x67, 0x6E, 0x61, 0x6C,  //  <Signal
                    /* 0558 */  0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67, 0x49, 0x6E,  // TimingIn
                    /* 0560 */  0x74, 0x65, 0x72, 0x66, 0x61, 0x63, 0x65, 0x2F,  // terface/
                    /* 0568 */  0x3E, 0x0A, 0x3C, 0x2F, 0x47, 0x72, 0x6F, 0x75,  // >.</Grou
                    /* 0570 */  0x70, 0x3E, 0x0A, 0x3C, 0x47, 0x72, 0x6F, 0x75,  // p>.<Grou
                    /* 0578 */  0x70, 0x20, 0x69, 0x64, 0x3D, 0x27, 0x44, 0x65,  // p id='De
                    /* 0580 */  0x74, 0x61, 0x69, 0x6C, 0x65, 0x64, 0x20, 0x54,  // tailed T
                    /* 0588 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x27, 0x3E, 0x0A,  // iming'>.
                    /* 0590 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72,  //     <Hor
                    /* 0598 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x53,  // izontalS
                    /* 05A0 */  0x63, 0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A,  // creenSiz
                    /* 05A8 */  0x65, 0x4D, 0x4D, 0x3E, 0x30, 0x78, 0x34, 0x34,  // eMM>0x44
                    /* 05B0 */  0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  // </Horizo
                    /* 05B8 */  0x6E, 0x74, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65,  // ntalScre
                    /* 05C0 */  0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x4D, 0x4D,  // enSizeMM
                    /* 05C8 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56,  // >.    <V
                    /* 05D0 */  0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53,  // erticalS
                    /* 05D8 */  0x63, 0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A,  // creenSiz
                    /* 05E0 */  0x65, 0x4D, 0x4D, 0x3E, 0x30, 0x78, 0x37, 0x38,  // eMM>0x78
                    /* 05E8 */  0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74, 0x69, 0x63,  // </Vertic
                    /* 05F0 */  0x61, 0x6C, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6E,  // alScreen
                    /* 05F8 */  0x53, 0x69, 0x7A, 0x65, 0x4D, 0x4D, 0x3E, 0x0A,  // SizeMM>.
                    /* 0600 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72,  //     <Hor
                    /* 0608 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x56,  // izontalV
                    /* 0610 */  0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53,  // erticalS
                    /* 0618 */  0x63, 0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A,  // creenSiz
                    /* 0620 */  0x65, 0x4D, 0x4D, 0x3E, 0x30, 0x78, 0x30, 0x30,  // eMM>0x00
                    /* 0628 */  0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  // </Horizo
                    /* 0630 */  0x6E, 0x74, 0x61, 0x6C, 0x56, 0x65, 0x72, 0x74,  // ntalVert
                    /* 0638 */  0x69, 0x63, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65,  // icalScre
                    /* 0640 */  0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x4D, 0x4D,  // enSizeMM
                    /* 0648 */  0x3E, 0x0A, 0x3C, 0x2F, 0x47, 0x72, 0x6F, 0x75,  // >.</Grou
                    /* 0650 */  0x70, 0x3E, 0x0A, 0x3C, 0x47, 0x72, 0x6F, 0x75,  // p>.<Grou
                    /* 0658 */  0x70, 0x20, 0x69, 0x64, 0x3D, 0x27, 0x41, 0x63,  // p id='Ac
                    /* 0660 */  0x74, 0x69, 0x76, 0x65, 0x20, 0x54, 0x69, 0x6D,  // tive Tim
                    /* 0668 */  0x69, 0x6E, 0x67, 0x27, 0x3E, 0x0A, 0x20, 0x20,  // ing'>.  
                    /* 0670 */  0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A,  //   <Horiz
                    /* 0678 */  0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x41, 0x63, 0x74,  // ontalAct
                    /* 0680 */  0x69, 0x76, 0x65, 0x3E, 0x32, 0x31, 0x36, 0x30,  // ive>2160
                    /* 0688 */  0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  // </Horizo
                    /* 0690 */  0x6E, 0x74, 0x61, 0x6C, 0x41, 0x63, 0x74, 0x69,  // ntalActi
                    /* 0698 */  0x76, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // ve>.    
                    /* 06A0 */  0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E,  // <Horizon
                    /* 06A8 */  0x74, 0x61, 0x6C, 0x46, 0x72, 0x6F, 0x6E, 0x74,  // talFront
                    /* 06B0 */  0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E, 0x33, 0x30,  // Porch>30
                    /* 06B8 */  0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  // </Horizo
                    /* 06C0 */  0x6E, 0x74, 0x61, 0x6C, 0x46, 0x72, 0x6F, 0x6E,  // ntalFron
                    /* 06C8 */  0x74, 0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E, 0x0A,  // tPorch>.
                    /* 06D0 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72,  //     <Hor
                    /* 06D8 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x42,  // izontalB
                    /* 06E0 */  0x61, 0x63, 0x6B, 0x50, 0x6F, 0x72, 0x63, 0x68,  // ackPorch
                    /* 06E8 */  0x3E, 0x31, 0x30, 0x30, 0x3C, 0x2F, 0x48, 0x6F,  // >100</Ho
                    /* 06F0 */  0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C,  // rizontal
                    /* 06F8 */  0x42, 0x61, 0x63, 0x6B, 0x50, 0x6F, 0x72, 0x63,  // BackPorc
                    /* 0700 */  0x68, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // h>.    <
                    /* 0708 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 0710 */  0x61, 0x6C, 0x53, 0x79, 0x6E, 0x63, 0x50, 0x75,  // alSyncPu
                    /* 0718 */  0x6C, 0x73, 0x65, 0x3E, 0x34, 0x3C, 0x2F, 0x48,  // lse>4</H
                    /* 0720 */  0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61,  // orizonta
                    /* 0728 */  0x6C, 0x53, 0x79, 0x6E, 0x63, 0x50, 0x75, 0x6C,  // lSyncPul
                    /* 0730 */  0x73, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // se>.    
                    /* 0738 */  0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E,  // <Horizon
                    /* 0740 */  0x74, 0x61, 0x6C, 0x53, 0x79, 0x6E, 0x63, 0x53,  // talSyncS
                    /* 0748 */  0x6B, 0x65, 0x77, 0x3E, 0x30, 0x3C, 0x2F, 0x48,  // kew>0</H
                    /* 0750 */  0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61,  // orizonta
                    /* 0758 */  0x6C, 0x53, 0x79, 0x6E, 0x63, 0x53, 0x6B, 0x65,  // lSyncSke
                    /* 0760 */  0x77, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // w>.    <
                    /* 0768 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 0770 */  0x61, 0x6C, 0x4C, 0x65, 0x66, 0x74, 0x42, 0x6F,  // alLeftBo
                    /* 0778 */  0x72, 0x64, 0x65, 0x72, 0x3E, 0x30, 0x3C, 0x2F,  // rder>0</
                    /* 0780 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 0788 */  0x61, 0x6C, 0x4C, 0x65, 0x66, 0x74, 0x42, 0x6F,  // alLeftBo
                    /* 0790 */  0x72, 0x64, 0x65, 0x72, 0x3E, 0x0A, 0x20, 0x20,  // rder>.  
                    /* 0798 */  0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A,  //   <Horiz
                    /* 07A0 */  0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x52, 0x69, 0x67,  // ontalRig
                    /* 07A8 */  0x68, 0x74, 0x42, 0x6F, 0x72, 0x64, 0x65, 0x72,  // htBorder
                    /* 07B0 */  0x3E, 0x30, 0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69,  // >0</Hori
                    /* 07B8 */  0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x52, 0x69,  // zontalRi
                    /* 07C0 */  0x67, 0x68, 0x74, 0x42, 0x6F, 0x72, 0x64, 0x65,  // ghtBorde
                    /* 07C8 */  0x72, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // r>.    <
                    /* 07D0 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 07D8 */  0x41, 0x63, 0x74, 0x69, 0x76, 0x65, 0x3E, 0x33,  // Active>3
                    /* 07E0 */  0x38, 0x34, 0x30, 0x3C, 0x2F, 0x56, 0x65, 0x72,  // 840</Ver
                    /* 07E8 */  0x74, 0x69, 0x63, 0x61, 0x6C, 0x41, 0x63, 0x74,  // ticalAct
                    /* 07F0 */  0x69, 0x76, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ive>.   
                    /* 07F8 */  0x20, 0x3C, 0x56, 0x65, 0x72, 0x74, 0x69, 0x63,  //  <Vertic
                    /* 0800 */  0x61, 0x6C, 0x46, 0x72, 0x6F, 0x6E, 0x74, 0x50,  // alFrontP
                    /* 0808 */  0x6F, 0x72, 0x63, 0x68, 0x3E, 0x38, 0x3C, 0x2F,  // orch>8</
                    /* 0810 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 0818 */  0x46, 0x72, 0x6F, 0x6E, 0x74, 0x50, 0x6F, 0x72,  // FrontPor
                    /* 0820 */  0x63, 0x68, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // ch>.    
                    /* 0828 */  0x3C, 0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61,  // <Vertica
                    /* 0830 */  0x6C, 0x42, 0x61, 0x63, 0x6B, 0x50, 0x6F, 0x72,  // lBackPor
                    /* 0838 */  0x63, 0x68, 0x3E, 0x37, 0x3C, 0x2F, 0x56, 0x65,  // ch>7</Ve
                    /* 0840 */  0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x42, 0x61,  // rticalBa
                    /* 0848 */  0x63, 0x6B, 0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E,  // ckPorch>
                    /* 0850 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56, 0x65,  // .    <Ve
                    /* 0858 */  0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53, 0x79,  // rticalSy
                    /* 0860 */  0x6E, 0x63, 0x50, 0x75, 0x6C, 0x73, 0x65, 0x3E,  // ncPulse>
                    /* 0868 */  0x31, 0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74, 0x69,  // 1</Verti
                    /* 0870 */  0x63, 0x61, 0x6C, 0x53, 0x79, 0x6E, 0x63, 0x50,  // calSyncP
                    /* 0878 */  0x75, 0x6C, 0x73, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // ulse>.  
                    /* 0880 */  0x20, 0x20, 0x3C, 0x56, 0x65, 0x72, 0x74, 0x69,  //   <Verti
                    /* 0888 */  0x63, 0x61, 0x6C, 0x53, 0x79, 0x6E, 0x63, 0x53,  // calSyncS
                    /* 0890 */  0x6B, 0x65, 0x77, 0x3E, 0x30, 0x3C, 0x2F, 0x56,  // kew>0</V
                    /* 0898 */  0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53,  // erticalS
                    /* 08A0 */  0x79, 0x6E, 0x63, 0x53, 0x6B, 0x65, 0x77, 0x3E,  // yncSkew>
                    /* 08A8 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56, 0x65,  // .    <Ve
                    /* 08B0 */  0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x54, 0x6F,  // rticalTo
                    /* 08B8 */  0x70, 0x42, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x3E,  // pBorder>
                    /* 08C0 */  0x30, 0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74, 0x69,  // 0</Verti
                    /* 08C8 */  0x63, 0x61, 0x6C, 0x54, 0x6F, 0x70, 0x42, 0x6F,  // calTopBo
                    /* 08D0 */  0x72, 0x64, 0x65, 0x72, 0x3E, 0x0A, 0x20, 0x20,  // rder>.  
                    /* 08D8 */  0x20, 0x20, 0x3C, 0x56, 0x65, 0x72, 0x74, 0x69,  //   <Verti
                    /* 08E0 */  0x63, 0x61, 0x6C, 0x42, 0x6F, 0x74, 0x74, 0x6F,  // calBotto
                    /* 08E8 */  0x6D, 0x42, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x3E,  // mBorder>
                    /* 08F0 */  0x30, 0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74, 0x69,  // 0</Verti
                    /* 08F8 */  0x63, 0x61, 0x6C, 0x42, 0x6F, 0x74, 0x74, 0x6F,  // calBotto
                    /* 0900 */  0x6D, 0x42, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x3E,  // mBorder>
                    /* 0908 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x49, 0x6E,  // .    <In
                    /* 0910 */  0x76, 0x65, 0x72, 0x74, 0x44, 0x61, 0x74, 0x61,  // vertData
                    /* 0918 */  0x50, 0x6F, 0x6C, 0x61, 0x72, 0x69, 0x74, 0x79,  // Polarity
                    /* 0920 */  0x3E, 0x46, 0x61, 0x6C, 0x73, 0x65, 0x3C, 0x2F,  // >False</
                    /* 0928 */  0x49, 0x6E, 0x76, 0x65, 0x72, 0x74, 0x44, 0x61,  // InvertDa
                    /* 0930 */  0x74, 0x61, 0x50, 0x6F, 0x6C, 0x61, 0x72, 0x69,  // taPolari
                    /* 0938 */  0x74, 0x79, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // ty>.    
                    /* 0940 */  0x3C, 0x49, 0x6E, 0x76, 0x65, 0x72, 0x74, 0x56,  // <InvertV
                    /* 0948 */  0x73, 0x79, 0x6E, 0x63, 0x50, 0x6F, 0x6C, 0x61,  // syncPola
                    /* 0950 */  0x69, 0x72, 0x74, 0x79, 0x3E, 0x46, 0x61, 0x6C,  // irty>Fal
                    /* 0958 */  0x73, 0x65, 0x3C, 0x2F, 0x49, 0x6E, 0x76, 0x65,  // se</Inve
                    /* 0960 */  0x72, 0x74, 0x56, 0x73, 0x79, 0x6E, 0x63, 0x50,  // rtVsyncP
                    /* 0968 */  0x6F, 0x6C, 0x61, 0x69, 0x72, 0x74, 0x79, 0x3E,  // olairty>
                    /* 0970 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x49, 0x6E,  // .    <In
                    /* 0978 */  0x76, 0x65, 0x72, 0x74, 0x48, 0x73, 0x79, 0x6E,  // vertHsyn
                    /* 0980 */  0x63, 0x50, 0x6F, 0x6C, 0x61, 0x72, 0x69, 0x74,  // cPolarit
                    /* 0988 */  0x79, 0x3E, 0x46, 0x61, 0x6C, 0x73, 0x65, 0x3C,  // y>False<
                    /* 0990 */  0x2F, 0x49, 0x6E, 0x76, 0x65, 0x72, 0x74, 0x48,  // /InvertH
                    /* 0998 */  0x73, 0x79, 0x6E, 0x63, 0x50, 0x6F, 0x6C, 0x61,  // syncPola
                    /* 09A0 */  0x72, 0x69, 0x74, 0x79, 0x3E, 0x0A, 0x20, 0x20,  // rity>.  
                    /* 09A8 */  0x20, 0x20, 0x3C, 0x42, 0x6F, 0x72, 0x64, 0x65,  //   <Borde
                    /* 09B0 */  0x72, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x3E, 0x30,  // rColor>0
                    /* 09B8 */  0x78, 0x30, 0x3C, 0x2F, 0x42, 0x6F, 0x72, 0x64,  // x0</Bord
                    /* 09C0 */  0x65, 0x72, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x3E,  // erColor>
                    /* 09C8 */  0x0A, 0x3C, 0x2F, 0x47, 0x72, 0x6F, 0x75, 0x70,  // .</Group
                    /* 09D0 */  0x3E, 0x0A, 0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70,  // >.<Group
                    /* 09D8 */  0x20, 0x69, 0x64, 0x3D, 0x27, 0x44, 0x69, 0x73,  //  id='Dis
                    /* 09E0 */  0x70, 0x6C, 0x61, 0x79, 0x20, 0x49, 0x6E, 0x74,  // play Int
                    /* 09E8 */  0x65, 0x72, 0x66, 0x61, 0x63, 0x65, 0x27, 0x3E,  // erface'>
                    /* 09F0 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x49, 0x6E,  // .    <In
                    /* 09F8 */  0x74, 0x65, 0x72, 0x66, 0x61, 0x63, 0x65, 0x54,  // terfaceT
                    /* 0A00 */  0x79, 0x70, 0x65, 0x3E, 0x38, 0x3C, 0x2F, 0x49,  // ype>8</I
                    /* 0A08 */  0x6E, 0x74, 0x65, 0x72, 0x66, 0x61, 0x63, 0x65,  // nterface
                    /* 0A10 */  0x54, 0x79, 0x70, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // Type>.  
                    /* 0A18 */  0x20, 0x20, 0x3C, 0x49, 0x6E, 0x74, 0x65, 0x72,  //   <Inter
                    /* 0A20 */  0x66, 0x61, 0x63, 0x65, 0x43, 0x6F, 0x6C, 0x6F,  // faceColo
                    /* 0A28 */  0x72, 0x46, 0x6F, 0x72, 0x6D, 0x61, 0x74, 0x3E,  // rFormat>
                    /* 0A30 */  0x33, 0x3C, 0x2F, 0x49, 0x6E, 0x74, 0x65, 0x72,  // 3</Inter
                    /* 0A38 */  0x66, 0x61, 0x63, 0x65, 0x43, 0x6F, 0x6C, 0x6F,  // faceColo
                    /* 0A40 */  0x72, 0x46, 0x6F, 0x72, 0x6D, 0x61, 0x74, 0x3E,  // rFormat>
                    /* 0A48 */  0x0A, 0x3C, 0x2F, 0x47, 0x72, 0x6F, 0x75, 0x70,  // .</Group
                    /* 0A50 */  0x3E, 0x0A, 0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70,  // >.<Group
                    /* 0A58 */  0x20, 0x69, 0x64, 0x3D, 0x27, 0x44, 0x53, 0x49,  //  id='DSI
                    /* 0A60 */  0x20, 0x49, 0x6E, 0x74, 0x65, 0x72, 0x66, 0x61,  //  Interfa
                    /* 0A68 */  0x63, 0x65, 0x27, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ce'>.   
                    /* 0A70 */  0x20, 0x3C, 0x44, 0x53, 0x49, 0x43, 0x68, 0x61,  //  <DSICha
                    /* 0A78 */  0x6E, 0x6E, 0x65, 0x6C, 0x49, 0x64, 0x3E, 0x31,  // nnelId>1
                    /* 0A80 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x43, 0x68, 0x61,  // </DSICha
                    /* 0A88 */  0x6E, 0x6E, 0x65, 0x6C, 0x49, 0x64, 0x3E, 0x0A,  // nnelId>.
                    /* 0A90 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49,  //     <DSI
                    /* 0A98 */  0x56, 0x69, 0x72, 0x74, 0x75, 0x61, 0x6C, 0x49,  // VirtualI
                    /* 0AA0 */  0x64, 0x3E, 0x30, 0x3C, 0x2F, 0x44, 0x53, 0x49,  // d>0</DSI
                    /* 0AA8 */  0x56, 0x69, 0x72, 0x74, 0x75, 0x61, 0x6C, 0x49,  // VirtualI
                    /* 0AB0 */  0x64, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // d>.    <
                    /* 0AB8 */  0x44, 0x53, 0x49, 0x43, 0x6F, 0x6C, 0x6F, 0x72,  // DSIColor
                    /* 0AC0 */  0x46, 0x6F, 0x72, 0x6D, 0x61, 0x74, 0x3E, 0x33,  // Format>3
                    /* 0AC8 */  0x36, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x43, 0x6F,  // 6</DSICo
                    /* 0AD0 */  0x6C, 0x6F, 0x72, 0x46, 0x6F, 0x72, 0x6D, 0x61,  // lorForma
                    /* 0AD8 */  0x74, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // t>.    <
                    /* 0AE0 */  0x44, 0x53, 0x49, 0x54, 0x72, 0x61, 0x66, 0x66,  // DSITraff
                    /* 0AE8 */  0x69, 0x63, 0x4D, 0x6F, 0x64, 0x65, 0x3E, 0x31,  // icMode>1
                    /* 0AF0 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x54, 0x72, 0x61,  // </DSITra
                    /* 0AF8 */  0x66, 0x66, 0x69, 0x63, 0x4D, 0x6F, 0x64, 0x65,  // fficMode
                    /* 0B00 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44,  // >.    <D
                    /* 0B08 */  0x53, 0x49, 0x44, 0x53, 0x43, 0x45, 0x6E, 0x61,  // SIDSCEna
                    /* 0B10 */  0x62, 0x6C, 0x65, 0x3E, 0x54, 0x72, 0x75, 0x65,  // ble>True
                    /* 0B18 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43,  // </DSIDSC
                    /* 0B20 */  0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x3E, 0x0A,  // Enable>.
                    /* 0B28 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49,  //     <DSI
                    /* 0B30 */  0x44, 0x53, 0x43, 0x4D, 0x61, 0x6A, 0x6F, 0x72,  // DSCMajor
                    /* 0B38 */  0x56, 0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E,  // Version>
                    /* 0B40 */  0x31, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44, 0x53,  // 1</DSIDS
                    /* 0B48 */  0x43, 0x4D, 0x61, 0x6A, 0x6F, 0x72, 0x56, 0x65,  // CMajorVe
                    /* 0B50 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x0A, 0x20,  // rsion>. 
                    /* 0B58 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x44,  //    <DSID
                    /* 0B60 */  0x53, 0x43, 0x4D, 0x69, 0x6E, 0x6F, 0x72, 0x56,  // SCMinorV
                    /* 0B68 */  0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x31,  // ersion>1
                    /* 0B70 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43,  // </DSIDSC
                    /* 0B78 */  0x4D, 0x69, 0x6E, 0x6F, 0x72, 0x56, 0x65, 0x72,  // MinorVer
                    /* 0B80 */  0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x0A, 0x20, 0x20,  // sion>.  
                    /* 0B88 */  0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x44, 0x53,  //   <DSIDS
                    /* 0B90 */  0x43, 0x53, 0x63, 0x72, 0x3E, 0x30, 0x3C, 0x2F,  // CScr>0</
                    /* 0B98 */  0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x53, 0x63,  // DSIDSCSc
                    /* 0BA0 */  0x72, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // r>.    <
                    /* 0BA8 */  0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x50, 0x72,  // DSIDSCPr
                    /* 0BB0 */  0x6F, 0x66, 0x69, 0x6C, 0x65, 0x49, 0x44, 0x3E,  // ofileID>
                    /* 0BB8 */  0x34, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44, 0x53,  // 4</DSIDS
                    /* 0BC0 */  0x43, 0x50, 0x72, 0x6F, 0x66, 0x69, 0x6C, 0x65,  // CProfile
                    /* 0BC8 */  0x49, 0x44, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // ID>.    
                    /* 0BD0 */  0x3C, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x53,  // <DSIDSCS
                    /* 0BD8 */  0x6C, 0x69, 0x63, 0x65, 0x57, 0x69, 0x64, 0x74,  // liceWidt
                    /* 0BE0 */  0x68, 0x3E, 0x31, 0x30, 0x38, 0x30, 0x3C, 0x2F,  // h>1080</
                    /* 0BE8 */  0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x53, 0x6C,  // DSIDSCSl
                    /* 0BF0 */  0x69, 0x63, 0x65, 0x57, 0x69, 0x64, 0x74, 0x68,  // iceWidth
                    /* 0BF8 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44,  // >.    <D
                    /* 0C00 */  0x53, 0x49, 0x44, 0x53, 0x43, 0x53, 0x6C, 0x69,  // SIDSCSli
                    /* 0C08 */  0x63, 0x65, 0x48, 0x65, 0x69, 0x67, 0x68, 0x74,  // ceHeight
                    /* 0C10 */  0x3E, 0x33, 0x32, 0x3C, 0x2F, 0x44, 0x53, 0x49,  // >32</DSI
                    /* 0C18 */  0x44, 0x53, 0x43, 0x53, 0x6C, 0x69, 0x63, 0x65,  // DSCSlice
                    /* 0C20 */  0x48, 0x65, 0x69, 0x67, 0x68, 0x74, 0x3E, 0x0A,  // Height>.
                    /* 0C28 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49,  //     <DSI
                    /* 0C30 */  0x4C, 0x61, 0x6E, 0x65, 0x73, 0x3E, 0x34, 0x3C,  // Lanes>4<
                    /* 0C38 */  0x2F, 0x44, 0x53, 0x49, 0x4C, 0x61, 0x6E, 0x65,  // /DSILane
                    /* 0C40 */  0x73, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // s>.    <
                    /* 0C48 */  0x44, 0x53, 0x49, 0x48, 0x73, 0x61, 0x48, 0x73,  // DSIHsaHs
                    /* 0C50 */  0x65, 0x41, 0x66, 0x74, 0x65, 0x72, 0x56, 0x73,  // eAfterVs
                    /* 0C58 */  0x56, 0x65, 0x3E, 0x46, 0x61, 0x6C, 0x73, 0x65,  // Ve>False
                    /* 0C60 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x48, 0x73, 0x61,  // </DSIHsa
                    /* 0C68 */  0x48, 0x73, 0x65, 0x41, 0x66, 0x74, 0x65, 0x72,  // HseAfter
                    /* 0C70 */  0x56, 0x73, 0x56, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // VsVe>.  
                    /* 0C78 */  0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x4C, 0x6F,  //   <DSILo
                    /* 0C80 */  0x77, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x4D, 0x6F,  // wPowerMo
                    /* 0C88 */  0x64, 0x65, 0x49, 0x6E, 0x48, 0x46, 0x50, 0x3E,  // deInHFP>
                    /* 0C90 */  0x46, 0x61, 0x6C, 0x73, 0x65, 0x3C, 0x2F, 0x44,  // False</D
                    /* 0C98 */  0x53, 0x49, 0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77,  // SILowPow
                    /* 0CA0 */  0x65, 0x72, 0x4D, 0x6F, 0x64, 0x65, 0x49, 0x6E,  // erModeIn
                    /* 0CA8 */  0x48, 0x46, 0x50, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // HFP>.   
                    /* 0CB0 */  0x20, 0x3C, 0x44, 0x53, 0x49, 0x4C, 0x6F, 0x77,  //  <DSILow
                    /* 0CB8 */  0x50, 0x6F, 0x77, 0x65, 0x72, 0x4D, 0x6F, 0x64,  // PowerMod
                    /* 0CC0 */  0x65, 0x49, 0x6E, 0x48, 0x42, 0x50, 0x3E, 0x46,  // eInHBP>F
                    /* 0CC8 */  0x61, 0x6C, 0x73, 0x65, 0x3C, 0x2F, 0x44, 0x53,  // alse</DS
                    /* 0CD0 */  0x49, 0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77, 0x65,  // ILowPowe
                    /* 0CD8 */  0x72, 0x4D, 0x6F, 0x64, 0x65, 0x49, 0x6E, 0x48,  // rModeInH
                    /* 0CE0 */  0x42, 0x50, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // BP>.    
                    /* 0CE8 */  0x3C, 0x44, 0x53, 0x49, 0x4C, 0x6F, 0x77, 0x50,  // <DSILowP
                    /* 0CF0 */  0x6F, 0x77, 0x65, 0x72, 0x4D, 0x6F, 0x64, 0x65,  // owerMode
                    /* 0CF8 */  0x49, 0x6E, 0x48, 0x53, 0x41, 0x3E, 0x46, 0x61,  // InHSA>Fa
                    /* 0D00 */  0x6C, 0x73, 0x65, 0x3C, 0x2F, 0x44, 0x53, 0x49,  // lse</DSI
                    /* 0D08 */  0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77, 0x65, 0x72,  // LowPower
                    /* 0D10 */  0x4D, 0x6F, 0x64, 0x65, 0x49, 0x6E, 0x48, 0x53,  // ModeInHS
                    /* 0D18 */  0x41, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // A>.    <
                    /* 0D20 */  0x44, 0x53, 0x49, 0x4C, 0x6F, 0x77, 0x50, 0x6F,  // DSILowPo
                    /* 0D28 */  0x77, 0x65, 0x72, 0x4D, 0x6F, 0x64, 0x65, 0x49,  // werModeI
                    /* 0D30 */  0x6E, 0x42, 0x4C, 0x4C, 0x50, 0x45, 0x4F, 0x46,  // nBLLPEOF
                    /* 0D38 */  0x3E, 0x54, 0x72, 0x75, 0x65, 0x3C, 0x2F, 0x44,  // >True</D
                    /* 0D40 */  0x53, 0x49, 0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77,  // SILowPow
                    /* 0D48 */  0x65, 0x72, 0x4D, 0x6F, 0x64, 0x65, 0x49, 0x6E,  // erModeIn
                    /* 0D50 */  0x42, 0x4C, 0x4C, 0x50, 0x45, 0x4F, 0x46, 0x3E,  // BLLPEOF>
                    /* 0D58 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0D60 */  0x49, 0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77, 0x65,  // ILowPowe
                    /* 0D68 */  0x72, 0x4D, 0x6F, 0x64, 0x65, 0x49, 0x6E, 0x42,  // rModeInB
                    /* 0D70 */  0x4C, 0x4C, 0x50, 0x3E, 0x54, 0x72, 0x75, 0x65,  // LLP>True
                    /* 0D78 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x4C, 0x6F, 0x77,  // </DSILow
                    /* 0D80 */  0x50, 0x6F, 0x77, 0x65, 0x72, 0x4D, 0x6F, 0x64,  // PowerMod
                    /* 0D88 */  0x65, 0x49, 0x6E, 0x42, 0x4C, 0x4C, 0x50, 0x3E,  // eInBLLP>
                    /* 0D90 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0D98 */  0x49, 0x52, 0x65, 0x66, 0x72, 0x65, 0x73, 0x68,  // IRefresh
                    /* 0DA0 */  0x52, 0x61, 0x74, 0x65, 0x3E, 0x30, 0x78, 0x33,  // Rate>0x3
                    /* 0DA8 */  0x43, 0x30, 0x30, 0x30, 0x30, 0x3C, 0x2F, 0x44,  // C0000</D
                    /* 0DB0 */  0x53, 0x49, 0x52, 0x65, 0x66, 0x72, 0x65, 0x73,  // SIRefres
                    /* 0DB8 */  0x68, 0x52, 0x61, 0x74, 0x65, 0x3E, 0x0A, 0x20,  // hRate>. 
                    /* 0DC0 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x50,  //    <DSIP
                    /* 0DC8 */  0x68, 0x79, 0x44, 0x43, 0x44, 0x43, 0x4D, 0x6F,  // hyDCDCMo
                    /* 0DD0 */  0x64, 0x65, 0x3E, 0x54, 0x72, 0x75, 0x65, 0x3C,  // de>True<
                    /* 0DD8 */  0x2F, 0x44, 0x53, 0x49, 0x50, 0x68, 0x79, 0x44,  // /DSIPhyD
                    /* 0DE0 */  0x43, 0x44, 0x43, 0x4D, 0x6F, 0x64, 0x65, 0x3E,  // CDCMode>
                    /* 0DE8 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0DF0 */  0x49, 0x49, 0x6E, 0x69, 0x74, 0x4D, 0x61, 0x73,  // IInitMas
                    /* 0DF8 */  0x74, 0x65, 0x72, 0x54, 0x69, 0x6D, 0x65, 0x3E,  // terTime>
                    /* 0E00 */  0x31, 0x32, 0x38, 0x3C, 0x2F, 0x44, 0x53, 0x49,  // 128</DSI
                    /* 0E08 */  0x49, 0x6E, 0x69, 0x74, 0x4D, 0x61, 0x73, 0x74,  // InitMast
                    /* 0E10 */  0x65, 0x72, 0x54, 0x69, 0x6D, 0x65, 0x3E, 0x0A,  // erTime>.
                    /* 0E18 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49,  //     <DSI
                    /* 0E20 */  0x43, 0x6F, 0x6E, 0x74, 0x72, 0x6F, 0x6C, 0x6C,  // Controll
                    /* 0E28 */  0x65, 0x72, 0x4D, 0x61, 0x70, 0x70, 0x69, 0x6E,  // erMappin
                    /* 0E30 */  0x67, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x20,  // g>.     
                    /* 0E38 */  0x20, 0x20, 0x20, 0x30, 0x30, 0x20, 0x30, 0x31,  //    00 01
                    /* 0E40 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x2F, 0x44,  // .    </D
                    /* 0E48 */  0x53, 0x49, 0x43, 0x6F, 0x6E, 0x74, 0x72, 0x6F,  // SIContro
                    /* 0E50 */  0x6C, 0x6C, 0x65, 0x72, 0x4D, 0x61, 0x70, 0x70,  // llerMapp
                    /* 0E58 */  0x69, 0x6E, 0x67, 0x3E, 0x0A, 0x3C, 0x2F, 0x47,  // ing>.</G
                    /* 0E60 */  0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A, 0x3C, 0x44,  // roup>.<D
                    /* 0E68 */  0x53, 0x49, 0x49, 0x6E, 0x69, 0x74, 0x53, 0x65,  // SIInitSe
                    /* 0E70 */  0x71, 0x75, 0x65, 0x6E, 0x63, 0x65, 0x3E, 0x0A,  // quence>.
                    /* 0E78 */  0x20, 0x20, 0x20, 0x20, 0x33, 0x39, 0x20, 0x39,  //     39 9
                    /* 0E80 */  0x31, 0x20, 0x30, 0x39, 0x20, 0x32, 0x30, 0x20,  // 1 09 20 
                    /* 0E88 */  0x30, 0x30, 0x20, 0x32, 0x30, 0x20, 0x30, 0x32,  // 00 20 02
                    /* 0E90 */  0x20, 0x30, 0x30, 0x20, 0x30, 0x33, 0x20, 0x31,  //  00 03 1
                    /* 0E98 */  0x63, 0x20, 0x30, 0x34, 0x20, 0x32, 0x31, 0x20,  // c 04 21 
                    /* 0EA0 */  0x30, 0x30, 0x20, 0x30, 0x66, 0x20, 0x30, 0x33,  // 00 0f 03
                    /* 0EA8 */  0x20, 0x31, 0x39, 0x20, 0x30, 0x31, 0x20, 0x39,  //  19 01 9
                    /* 0EB0 */  0x37, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x33, 0x39,  // 7.    39
                    /* 0EB8 */  0x20, 0x39, 0x32, 0x20, 0x31, 0x30, 0x20, 0x66,  //  92 10 f
                    /* 0EC0 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x31, 0x35,  // 0.    15
                    /* 0EC8 */  0x20, 0x39, 0x30, 0x20, 0x30, 0x33, 0x0A, 0x20,  //  90 03. 
                    /* 0ED0 */  0x20, 0x20, 0x20, 0x31, 0x35, 0x20, 0x30, 0x33,  //    15 03
                    /* 0ED8 */  0x20, 0x30, 0x31, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  01.    
                    /* 0EE0 */  0x33, 0x39, 0x20, 0x66, 0x30, 0x20, 0x35, 0x35,  // 39 f0 55
                    /* 0EE8 */  0x20, 0x61, 0x61, 0x20, 0x35, 0x32, 0x20, 0x30,  //  aa 52 0
                    /* 0EF0 */  0x38, 0x20, 0x30, 0x34, 0x0A, 0x20, 0x20, 0x20,  // 8 04.   
                    /* 0EF8 */  0x20, 0x31, 0x35, 0x20, 0x63, 0x30, 0x20, 0x30,  //  15 c0 0
                    /* 0F00 */  0x33, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x33, 0x39,  // 3.    39
                    /* 0F08 */  0x20, 0x66, 0x30, 0x20, 0x35, 0x35, 0x20, 0x61,  //  f0 55 a
                    /* 0F10 */  0x61, 0x20, 0x35, 0x32, 0x20, 0x30, 0x38, 0x20,  // a 52 08 
                    /* 0F18 */  0x30, 0x37, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x31,  // 07.    1
                    /* 0F20 */  0x35, 0x20, 0x65, 0x66, 0x20, 0x30, 0x31, 0x0A,  // 5 ef 01.
                    /* 0F28 */  0x20, 0x20, 0x20, 0x20, 0x33, 0x39, 0x20, 0x66,  //     39 f
                    /* 0F30 */  0x30, 0x20, 0x35, 0x35, 0x20, 0x61, 0x61, 0x20,  // 0 55 aa 
                    /* 0F38 */  0x35, 0x32, 0x20, 0x30, 0x38, 0x20, 0x30, 0x30,  // 52 08 00
                    /* 0F40 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x31, 0x35, 0x20,  // .    15 
                    /* 0F48 */  0x62, 0x34, 0x20, 0x31, 0x30, 0x0A, 0x20, 0x20,  // b4 10.  
                    /* 0F50 */  0x20, 0x20, 0x31, 0x35, 0x20, 0x33, 0x35, 0x20,  //   15 35 
                    /* 0F58 */  0x30, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x33,  // 00.    3
                    /* 0F60 */  0x39, 0x20, 0x66, 0x30, 0x20, 0x35, 0x35, 0x20,  // 9 f0 55 
                    /* 0F68 */  0x61, 0x61, 0x20, 0x35, 0x32, 0x20, 0x30, 0x38,  // aa 52 08
                    /* 0F70 */  0x20, 0x30, 0x31, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  01.    
                    /* 0F78 */  0x33, 0x39, 0x20, 0x66, 0x66, 0x20, 0x61, 0x61,  // 39 ff aa
                    /* 0F80 */  0x20, 0x35, 0x35, 0x20, 0x61, 0x35, 0x20, 0x38,  //  55 a5 8
                    /* 0F88 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x31, 0x35,  // 0.    15
                    /* 0F90 */  0x20, 0x36, 0x66, 0x20, 0x30, 0x31, 0x0A, 0x20,  //  6f 01. 
                    /* 0F98 */  0x20, 0x20, 0x20, 0x31, 0x35, 0x20, 0x66, 0x33,  //    15 f3
                    /* 0FA0 */  0x20, 0x31, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  10.    
                    /* 0FA8 */  0x33, 0x39, 0x20, 0x66, 0x66, 0x20, 0x61, 0x61,  // 39 ff aa
                    /* 0FB0 */  0x20, 0x35, 0x35, 0x20, 0x61, 0x35, 0x20, 0x30,  //  55 a5 0
                    /* 0FB8 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x30, 0x35,  // 0.    05
                    /* 0FC0 */  0x20, 0x31, 0x31, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  11.    
                    /* 0FC8 */  0x66, 0x66, 0x20, 0x37, 0x38, 0x0A, 0x20, 0x20,  // ff 78.  
                    /* 0FD0 */  0x20, 0x20, 0x30, 0x35, 0x20, 0x32, 0x39, 0x0A,  //   05 29.
                    /* 0FD8 */  0x20, 0x20, 0x20, 0x20, 0x66, 0x66, 0x20, 0x37,  //     ff 7
                    /* 0FE0 */  0x38, 0x0A, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x49,  // 8.</DSII
                    /* 0FE8 */  0x6E, 0x69, 0x74, 0x53, 0x65, 0x71, 0x75, 0x65,  // nitSeque
                    /* 0FF0 */  0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x3C, 0x44, 0x53,  // nce>.<DS
                    /* 0FF8 */  0x49, 0x54, 0x65, 0x72, 0x6D, 0x53, 0x65, 0x71,  // ITermSeq
                    /* 1000 */  0x75, 0x65, 0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x20,  // uence>. 
                    /* 1008 */  0x20, 0x20, 0x20, 0x30, 0x35, 0x20, 0x32, 0x38,  //    05 28
                    /* 1010 */  0x20, 0x30, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  00.    
                    /* 1018 */  0x46, 0x46, 0x20, 0x32, 0x30, 0x0A, 0x20, 0x20,  // FF 20.  
                    /* 1020 */  0x20, 0x20, 0x30, 0x35, 0x20, 0x31, 0x30, 0x20,  //   05 10 
                    /* 1028 */  0x30, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x46,  // 00.    F
                    /* 1030 */  0x46, 0x20, 0x38, 0x30, 0x0A, 0x3C, 0x2F, 0x44,  // F 80.</D
                    /* 1038 */  0x53, 0x49, 0x54, 0x65, 0x72, 0x6D, 0x53, 0x65,  // SITermSe
                    /* 1040 */  0x71, 0x75, 0x65, 0x6E, 0x63, 0x65, 0x3E, 0x0A,  // quence>.
                    /* 1048 */  0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69,  // <Group i
                    /* 1050 */  0x64, 0x3D, 0x27, 0x43, 0x6F, 0x6E, 0x6E, 0x65,  // d='Conne
                    /* 1058 */  0x63, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x43, 0x6F,  // ction Co
                    /* 1060 */  0x6E, 0x66, 0x69, 0x67, 0x75, 0x72, 0x61, 0x74,  // nfigurat
                    /* 1068 */  0x69, 0x6F, 0x6E, 0x27, 0x3E, 0x0A, 0x20, 0x20,  // ion'>.  
                    /* 1070 */  0x20, 0x20, 0x3C, 0x44, 0x69, 0x73, 0x70, 0x6C,  //   <Displ
                    /* 1078 */  0x61, 0x79, 0x31, 0x52, 0x65, 0x73, 0x65, 0x74,  // ay1Reset
                    /* 1080 */  0x31, 0x49, 0x6E, 0x66, 0x6F, 0x3E, 0x44, 0x53,  // 1Info>DS
                    /* 1088 */  0x49, 0x5F, 0x50, 0x41, 0x4E, 0x45, 0x4C, 0x5F,  // I_PANEL_
                    /* 1090 */  0x52, 0x45, 0x53, 0x45, 0x54, 0x2C, 0x20, 0x30,  // RESET, 0
                    /* 1098 */  0x2C, 0x20, 0x33, 0x30, 0x3C, 0x2F, 0x44, 0x69,  // , 30</Di
                    /* 10A0 */  0x73, 0x70, 0x6C, 0x61, 0x79, 0x31, 0x52, 0x65,  // splay1Re
                    /* 10A8 */  0x73, 0x65, 0x74, 0x31, 0x49, 0x6E, 0x66, 0x6F,  // set1Info
                    /* 10B0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44,  // >.    <D
                    /* 10B8 */  0x69, 0x73, 0x70, 0x6C, 0x61, 0x79, 0x31, 0x50,  // isplay1P
                    /* 10C0 */  0x6F, 0x77, 0x65, 0x72, 0x31, 0x49, 0x6E, 0x66,  // ower1Inf
                    /* 10C8 */  0x6F, 0x3E, 0x44, 0x53, 0x49, 0x5F, 0x50, 0x41,  // o>DSI_PA
                    /* 10D0 */  0x4E, 0x45, 0x4C, 0x5F, 0x4D, 0x4F, 0x44, 0x45,  // NEL_MODE
                    /* 10D8 */  0x5F, 0x53, 0x45, 0x4C, 0x45, 0x43, 0x54, 0x2C,  // _SELECT,
                    /* 10E0 */  0x20, 0x30, 0x2C, 0x20, 0x30, 0x2C, 0x20, 0x30,  //  0, 0, 0
                    /* 10E8 */  0x2C, 0x20, 0x30, 0x2C, 0x20, 0x54, 0x52, 0x55,  // , 0, TRU
                    /* 10F0 */  0x45, 0x3C, 0x2F, 0x44, 0x69, 0x73, 0x70, 0x6C,  // E</Displ
                    /* 10F8 */  0x61, 0x79, 0x31, 0x50, 0x6F, 0x77, 0x65, 0x72,  // ay1Power
                    /* 1100 */  0x31, 0x49, 0x6E, 0x66, 0x6F, 0x3E, 0x0A, 0x3C,  // 1Info>.<
                    /* 1108 */  0x2F, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A,  // /Group>.
                    /* 1110 */  0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69,  // <Group i
                    /* 1118 */  0x64, 0x3D, 0x27, 0x42, 0x61, 0x63, 0x6B, 0x6C,  // d='Backl
                    /* 1120 */  0x69, 0x67, 0x68, 0x74, 0x20, 0x43, 0x6F, 0x6E,  // ight Con
                    /* 1128 */  0x66, 0x69, 0x67, 0x75, 0x72, 0x61, 0x74, 0x69,  // figurati
                    /* 1130 */  0x6F, 0x6E, 0x27, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // on'>.   
                    /* 1138 */  0x20, 0x3C, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  //  <Backli
                    /* 1140 */  0x67, 0x68, 0x74, 0x54, 0x79, 0x70, 0x65, 0x3E,  // ghtType>
                    /* 1148 */  0x31, 0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C,  // 1</Backl
                    /* 1150 */  0x69, 0x67, 0x68, 0x74, 0x54, 0x79, 0x70, 0x65,  // ightType
                    /* 1158 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x42,  // >.    <B
                    /* 1160 */  0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74,  // acklight
                    /* 1168 */  0x50, 0x6D, 0x69, 0x63, 0x50, 0x57, 0x4D, 0x53,  // PmicPWMS
                    /* 1170 */  0x69, 0x7A, 0x65, 0x69, 0x6E, 0x42, 0x69, 0x74,  // izeinBit
                    /* 1178 */  0x73, 0x3E, 0x39, 0x3C, 0x2F, 0x42, 0x61, 0x63,  // s>9</Bac
                    /* 1180 */  0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x50, 0x6D,  // klightPm
                    /* 1188 */  0x69, 0x63, 0x50, 0x57, 0x4D, 0x53, 0x69, 0x7A,  // icPWMSiz
                    /* 1190 */  0x65, 0x69, 0x6E, 0x42, 0x69, 0x74, 0x73, 0x3E,  // einBits>
                    /* 1198 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x61,  // .    <Ba
                    /* 11A0 */  0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x50,  // cklightP
                    /* 11A8 */  0x6D, 0x69, 0x63, 0x43, 0x6F, 0x6E, 0x74, 0x72,  // micContr
                    /* 11B0 */  0x6F, 0x6C, 0x54, 0x79, 0x70, 0x65, 0x3E, 0x33,  // olType>3
                    /* 11B8 */  0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  // </Backli
                    /* 11C0 */  0x67, 0x68, 0x74, 0x50, 0x6D, 0x69, 0x63, 0x43,  // ghtPmicC
                    /* 11C8 */  0x6F, 0x6E, 0x74, 0x72, 0x6F, 0x6C, 0x54, 0x79,  // ontrolTy
                    /* 11D0 */  0x70, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // pe>.    
                    /* 11D8 */  0x3C, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67,  // <Backlig
                    /* 11E0 */  0x68, 0x74, 0x50, 0x4D, 0x49, 0x43, 0x42, 0x61,  // htPMICBa
                    /* 11E8 */  0x6E, 0x6B, 0x53, 0x65, 0x6C, 0x65, 0x63, 0x74,  // nkSelect
                    /* 11F0 */  0x3E, 0x33, 0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B,  // >3</Back
                    /* 11F8 */  0x6C, 0x69, 0x67, 0x68, 0x74, 0x50, 0x4D, 0x49,  // lightPMI
                    /* 1200 */  0x43, 0x42, 0x61, 0x6E, 0x6B, 0x53, 0x65, 0x6C,  // CBankSel
                    /* 1208 */  0x65, 0x63, 0x74, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ect>.   
                    /* 1210 */  0x20, 0x3C, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  //  <Backli
                    /* 1218 */  0x67, 0x68, 0x74, 0x50, 0x4D, 0x49, 0x43, 0x50,  // ghtPMICP
                    /* 1220 */  0x57, 0x4D, 0x46, 0x72, 0x65, 0x71, 0x75, 0x65,  // WMFreque
                    /* 1228 */  0x6E, 0x63, 0x79, 0x3E, 0x38, 0x30, 0x30, 0x30,  // ncy>8000
                    /* 1230 */  0x30, 0x30, 0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B,  // 00</Back
                    /* 1238 */  0x6C, 0x69, 0x67, 0x68, 0x74, 0x50, 0x4D, 0x49,  // lightPMI
                    /* 1240 */  0x43, 0x50, 0x57, 0x4D, 0x46, 0x72, 0x65, 0x71,  // CPWMFreq
                    /* 1248 */  0x75, 0x65, 0x6E, 0x63, 0x79, 0x3E, 0x0A, 0x20,  // uency>. 
                    /* 1250 */  0x20, 0x20, 0x20, 0x3C, 0x42, 0x61, 0x63, 0x6B,  //    <Back
                    /* 1258 */  0x6C, 0x69, 0x67, 0x68, 0x74, 0x53, 0x74, 0x65,  // lightSte
                    /* 1260 */  0x70, 0x73, 0x3E, 0x31, 0x30, 0x30, 0x3C, 0x2F,  // ps>100</
                    /* 1268 */  0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68,  // Backligh
                    /* 1270 */  0x74, 0x53, 0x74, 0x65, 0x70, 0x73, 0x3E, 0x0A,  // tSteps>.
                    /* 1278 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x61, 0x63,  //     <Bac
                    /* 1280 */  0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x44, 0x65,  // klightDe
                    /* 1288 */  0x66, 0x61, 0x75, 0x6C, 0x74, 0x3E, 0x38, 0x30,  // fault>80
                    /* 1290 */  0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  // </Backli
                    /* 1298 */  0x67, 0x68, 0x74, 0x44, 0x65, 0x66, 0x61, 0x75,  // ghtDefau
                    /* 12A0 */  0x6C, 0x74, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // lt>.    
                    /* 12A8 */  0x3C, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67,  // <Backlig
                    /* 12B0 */  0x68, 0x74, 0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77,  // htLowPow
                    /* 12B8 */  0x65, 0x72, 0x3E, 0x34, 0x30, 0x3C, 0x2F, 0x42,  // er>40</B
                    /* 12C0 */  0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74,  // acklight
                    /* 12C8 */  0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77, 0x65, 0x72,  // LowPower
                    /* 12D0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x50,  // >.    <P
                    /* 12D8 */  0x4D, 0x49, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x50,  // MIPowerP
                    /* 12E0 */  0x6D, 0x69, 0x63, 0x4E, 0x75, 0x6D, 0x3E, 0x32,  // micNum>2
                    /* 12E8 */  0x3C, 0x2F, 0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77,  // </PMIPow
                    /* 12F0 */  0x65, 0x72, 0x50, 0x6D, 0x69, 0x63, 0x4E, 0x75,  // erPmicNu
                    /* 12F8 */  0x6D, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // m>.    <
                    /* 1300 */  0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77, 0x65, 0x72,  // PMIPower
                    /* 1308 */  0x50, 0x6D, 0x69, 0x63, 0x4D, 0x6F, 0x64, 0x65,  // PmicMode
                    /* 1310 */  0x6C, 0x3E, 0x30, 0x78, 0x32, 0x46, 0x3C, 0x2F,  // l>0x2F</
                    /* 1318 */  0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77, 0x65, 0x72,  // PMIPower
                    /* 1320 */  0x50, 0x6D, 0x69, 0x63, 0x4D, 0x6F, 0x64, 0x65,  // PmicMode
                    /* 1328 */  0x6C, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // l>.    <
                    /* 1330 */  0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77, 0x65, 0x72,  // PMIPower
                    /* 1338 */  0x43, 0x6F, 0x6E, 0x66, 0x69, 0x67, 0x3E, 0x31,  // Config>1
                    /* 1340 */  0x3C, 0x2F, 0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77,  // </PMIPow
                    /* 1348 */  0x65, 0x72, 0x43, 0x6F, 0x6E, 0x66, 0x69, 0x67,  // erConfig
                    /* 1350 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x41,  // >.    <A
                    /* 1358 */  0x64, 0x61, 0x70, 0x74, 0x69, 0x76, 0x65, 0x42,  // daptiveB
                    /* 1360 */  0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65, 0x73,  // rightnes
                    /* 1368 */  0x73, 0x46, 0x65, 0x61, 0x74, 0x75, 0x72, 0x65,  // sFeature
                    /* 1370 */  0x3E, 0x31, 0x3C, 0x2F, 0x41, 0x64, 0x61, 0x70,  // >1</Adap
                    /* 1378 */  0x74, 0x69, 0x76, 0x65, 0x42, 0x72, 0x69, 0x67,  // tiveBrig
                    /* 1380 */  0x68, 0x74, 0x6E, 0x65, 0x73, 0x73, 0x46, 0x65,  // htnessFe
                    /* 1388 */  0x61, 0x74, 0x75, 0x72, 0x65, 0x3E, 0x0A, 0x20,  // ature>. 
                    /* 1390 */  0x20, 0x20, 0x20, 0x3C, 0x43, 0x41, 0x42, 0x4C,  //    <CABL
                    /* 1398 */  0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x3E, 0x54,  // Enable>T
                    /* 13A0 */  0x72, 0x75, 0x65, 0x3C, 0x2F, 0x43, 0x41, 0x42,  // rue</CAB
                    /* 13A8 */  0x4C, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x3E,  // LEnable>
                    /* 13B0 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x72,  // .    <Br
                    /* 13B8 */  0x69, 0x67, 0x68, 0x74, 0x6E, 0x65, 0x73, 0x73,  // ightness
                    /* 13C0 */  0x4D, 0x69, 0x6E, 0x4C, 0x75, 0x6D, 0x69, 0x6E,  // MinLumin
                    /* 13C8 */  0x61, 0x6E, 0x63, 0x65, 0x3E, 0x30, 0x3C, 0x2F,  // ance>0</
                    /* 13D0 */  0x42, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65,  // Brightne
                    /* 13D8 */  0x73, 0x73, 0x4D, 0x69, 0x6E, 0x4C, 0x75, 0x6D,  // ssMinLum
                    /* 13E0 */  0x69, 0x6E, 0x61, 0x6E, 0x63, 0x65, 0x3E, 0x0A,  // inance>.
                    /* 13E8 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x72, 0x69,  //     <Bri
                    /* 13F0 */  0x67, 0x68, 0x74, 0x6E, 0x65, 0x73, 0x73, 0x4D,  // ghtnessM
                    /* 13F8 */  0x61, 0x78, 0x4C, 0x75, 0x6D, 0x69, 0x6E, 0x61,  // axLumina
                    /* 1400 */  0x6E, 0x63, 0x65, 0x3E, 0x30, 0x3C, 0x2F, 0x42,  // nce>0</B
                    /* 1408 */  0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65, 0x73,  // rightnes
                    /* 1410 */  0x73, 0x4D, 0x61, 0x78, 0x4C, 0x75, 0x6D, 0x69,  // sMaxLumi
                    /* 1418 */  0x6E, 0x61, 0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x09,  // nance>..
                    /* 1420 */  0x3C, 0x42, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E,  // <Brightn
                    /* 1428 */  0x65, 0x73, 0x73, 0x52, 0x61, 0x6E, 0x67, 0x65,  // essRange
                    /* 1430 */  0x4C, 0x65, 0x76, 0x65, 0x6C, 0x30, 0x3E, 0x35,  // Level0>5
                    /* 1438 */  0x30, 0x30, 0x20, 0x33, 0x31, 0x39, 0x35, 0x30,  // 00 31950
                    /* 1440 */  0x30, 0x20, 0x35, 0x30, 0x30, 0x20, 0x32, 0x3C,  // 0 500 2<
                    /* 1448 */  0x2F, 0x42, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E,  // /Brightn
                    /* 1450 */  0x65, 0x73, 0x73, 0x52, 0x61, 0x6E, 0x67, 0x65,  // essRange
                    /* 1458 */  0x4C, 0x65, 0x76, 0x65, 0x6C, 0x30, 0x3E, 0x0A,  // Level0>.
                    /* 1460 */  0x3C, 0x2F, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x3E,  // </Group>
                    /* 1468 */  0x00                                             // .
                })
                Name (PCF1, Buffer (0x14B7)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69, 0x64,  // Group id
                    /* 0030 */  0x3D, 0x27, 0x4D, 0x61, 0x69, 0x6E, 0x20, 0x50,  // ='Main P
                    /* 0038 */  0x61, 0x6E, 0x65, 0x6C, 0x27, 0x3E, 0x0A, 0x3C,  // anel'>.<
                    /* 0040 */  0x50, 0x61, 0x6E, 0x65, 0x6C, 0x4E, 0x61, 0x6D,  // PanelNam
                    /* 0048 */  0x65, 0x3E, 0x4C, 0x53, 0x30, 0x36, 0x30, 0x52,  // e>LS060R
                    /* 0050 */  0x31, 0x53, 0x58, 0x30, 0x33, 0x3C, 0x2F, 0x50,  // 1SX03</P
                    /* 0058 */  0x61, 0x6E, 0x65, 0x6C, 0x4E, 0x61, 0x6D, 0x65,  // anelName
                    /* 0060 */  0x3E, 0x0A, 0x3C, 0x50, 0x61, 0x6E, 0x65, 0x6C,  // >.<Panel
                    /* 0068 */  0x44, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74,  // Descript
                    /* 0070 */  0x69, 0x6F, 0x6E, 0x3E, 0x53, 0x68, 0x61, 0x72,  // ion>Shar
                    /* 0078 */  0x70, 0x20, 0x44, 0x75, 0x61, 0x6C, 0x20, 0x44,  // p Dual D
                    /* 0080 */  0x53, 0x49, 0x20, 0x43, 0x6F, 0x6D, 0x6D, 0x61,  // SI Comma
                    /* 0088 */  0x6E, 0x64, 0x20, 0x4D, 0x6F, 0x64, 0x65, 0x20,  // nd Mode 
                    /* 0090 */  0x44, 0x53, 0x43, 0x20, 0x50, 0x61, 0x6E, 0x65,  // DSC Pane
                    /* 0098 */  0x6C, 0x20, 0x28, 0x32, 0x31, 0x36, 0x30, 0x78,  // l (2160x
                    /* 00A0 */  0x33, 0x38, 0x34, 0x30, 0x20, 0x32, 0x34, 0x62,  // 3840 24b
                    /* 00A8 */  0x70, 0x70, 0x29, 0x3C, 0x2F, 0x50, 0x61, 0x6E,  // pp)</Pan
                    /* 00B0 */  0x65, 0x6C, 0x44, 0x65, 0x73, 0x63, 0x72, 0x69,  // elDescri
                    /* 00B8 */  0x70, 0x74, 0x69, 0x6F, 0x6E, 0x3E, 0x0A, 0x3C,  // ption>.<
                    /* 00C0 */  0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69, 0x64,  // Group id
                    /* 00C8 */  0x3D, 0x27, 0x45, 0x44, 0x49, 0x44, 0x20, 0x43,  // ='EDID C
                    /* 00D0 */  0x6F, 0x6E, 0x66, 0x69, 0x67, 0x75, 0x72, 0x61,  // onfigura
                    /* 00D8 */  0x74, 0x69, 0x6F, 0x6E, 0x27, 0x3E, 0x0A, 0x20,  // tion'>. 
                    /* 00E0 */  0x20, 0x20, 0x20, 0x3C, 0x4D, 0x61, 0x6E, 0x75,  //    <Manu
                    /* 00E8 */  0x66, 0x61, 0x63, 0x74, 0x75, 0x72, 0x65, 0x49,  // factureI
                    /* 00F0 */  0x44, 0x3E, 0x30, 0x78, 0x31, 0x30, 0x34, 0x44,  // D>0x104D
                    /* 00F8 */  0x3C, 0x2F, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61,  // </Manufa
                    /* 0100 */  0x63, 0x74, 0x75, 0x72, 0x65, 0x49, 0x44, 0x3E,  // ctureID>
                    /* 0108 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x50, 0x72,  // .    <Pr
                    /* 0110 */  0x6F, 0x64, 0x75, 0x63, 0x74, 0x43, 0x6F, 0x64,  // oductCod
                    /* 0118 */  0x65, 0x3E, 0x38, 0x35, 0x30, 0x3C, 0x2F, 0x50,  // e>850</P
                    /* 0120 */  0x72, 0x6F, 0x64, 0x75, 0x63, 0x74, 0x43, 0x6F,  // roductCo
                    /* 0128 */  0x64, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // de>.    
                    /* 0130 */  0x3C, 0x53, 0x65, 0x72, 0x69, 0x61, 0x6C, 0x4E,  // <SerialN
                    /* 0138 */  0x75, 0x6D, 0x62, 0x65, 0x72, 0x3E, 0x30, 0x78,  // umber>0x
                    /* 0140 */  0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x3C, 0x2F,  // 000001</
                    /* 0148 */  0x53, 0x65, 0x72, 0x69, 0x61, 0x6C, 0x4E, 0x75,  // SerialNu
                    /* 0150 */  0x6D, 0x62, 0x65, 0x72, 0x3E, 0x0A, 0x20, 0x20,  // mber>.  
                    /* 0158 */  0x20, 0x20, 0x3C, 0x57, 0x65, 0x65, 0x6B, 0x6F,  //   <Weeko
                    /* 0160 */  0x66, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61, 0x63,  // fManufac
                    /* 0168 */  0x74, 0x75, 0x72, 0x65, 0x3E, 0x30, 0x78, 0x30,  // ture>0x0
                    /* 0170 */  0x31, 0x3C, 0x2F, 0x57, 0x65, 0x65, 0x6B, 0x6F,  // 1</Weeko
                    /* 0178 */  0x66, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61, 0x63,  // fManufac
                    /* 0180 */  0x74, 0x75, 0x72, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // ture>.  
                    /* 0188 */  0x20, 0x20, 0x3C, 0x59, 0x65, 0x61, 0x72, 0x6F,  //   <Yearo
                    /* 0190 */  0x66, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61, 0x63,  // fManufac
                    /* 0198 */  0x74, 0x75, 0x72, 0x65, 0x3E, 0x30, 0x78, 0x31,  // ture>0x1
                    /* 01A0 */  0x42, 0x3C, 0x2F, 0x59, 0x65, 0x61, 0x72, 0x6F,  // B</Yearo
                    /* 01A8 */  0x66, 0x4D, 0x61, 0x6E, 0x75, 0x66, 0x61, 0x63,  // fManufac
                    /* 01B0 */  0x74, 0x75, 0x72, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // ture>.  
                    /* 01B8 */  0x20, 0x20, 0x3C, 0x45, 0x44, 0x49, 0x44, 0x56,  //   <EDIDV
                    /* 01C0 */  0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x31,  // ersion>1
                    /* 01C8 */  0x3C, 0x2F, 0x45, 0x44, 0x49, 0x44, 0x56, 0x65,  // </EDIDVe
                    /* 01D0 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x0A, 0x20,  // rsion>. 
                    /* 01D8 */  0x20, 0x20, 0x20, 0x3C, 0x45, 0x44, 0x49, 0x44,  //    <EDID
                    /* 01E0 */  0x52, 0x65, 0x76, 0x69, 0x73, 0x69, 0x6F, 0x6E,  // Revision
                    /* 01E8 */  0x3E, 0x33, 0x3C, 0x2F, 0x45, 0x44, 0x49, 0x44,  // >3</EDID
                    /* 01F0 */  0x52, 0x65, 0x76, 0x69, 0x73, 0x69, 0x6F, 0x6E,  // Revision
                    /* 01F8 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56,  // >.    <V
                    /* 0200 */  0x69, 0x64, 0x65, 0x6F, 0x49, 0x6E, 0x70, 0x75,  // ideoInpu
                    /* 0208 */  0x74, 0x44, 0x65, 0x66, 0x69, 0x6E, 0x69, 0x74,  // tDefinit
                    /* 0210 */  0x69, 0x6F, 0x6E, 0x3E, 0x30, 0x78, 0x38, 0x30,  // ion>0x80
                    /* 0218 */  0x3C, 0x2F, 0x56, 0x69, 0x64, 0x65, 0x6F, 0x49,  // </VideoI
                    /* 0220 */  0x6E, 0x70, 0x75, 0x74, 0x44, 0x65, 0x66, 0x69,  // nputDefi
                    /* 0228 */  0x6E, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x3E, 0x0A,  // nition>.
                    /* 0230 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72,  //     <Hor
                    /* 0238 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x53,  // izontalS
                    /* 0240 */  0x63, 0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A,  // creenSiz
                    /* 0248 */  0x65, 0x3E, 0x30, 0x78, 0x30, 0x37, 0x3C, 0x2F,  // e>0x07</
                    /* 0250 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 0258 */  0x61, 0x6C, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6E,  // alScreen
                    /* 0260 */  0x53, 0x69, 0x7A, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // Size>.  
                    /* 0268 */  0x20, 0x20, 0x3C, 0x56, 0x65, 0x72, 0x74, 0x69,  //   <Verti
                    /* 0270 */  0x63, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65, 0x65,  // calScree
                    /* 0278 */  0x6E, 0x53, 0x69, 0x7A, 0x65, 0x3E, 0x30, 0x78,  // nSize>0x
                    /* 0280 */  0x30, 0x43, 0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74,  // 0C</Vert
                    /* 0288 */  0x69, 0x63, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65,  // icalScre
                    /* 0290 */  0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x3E, 0x0A,  // enSize>.
                    /* 0298 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x69, 0x73,  //     <Dis
                    /* 02A0 */  0x70, 0x6C, 0x61, 0x79, 0x54, 0x72, 0x61, 0x6E,  // playTran
                    /* 02A8 */  0x73, 0x66, 0x65, 0x72, 0x43, 0x68, 0x61, 0x72,  // sferChar
                    /* 02B0 */  0x61, 0x63, 0x74, 0x65, 0x72, 0x69, 0x73, 0x74,  // acterist
                    /* 02B8 */  0x69, 0x63, 0x73, 0x3E, 0x30, 0x78, 0x37, 0x38,  // ics>0x78
                    /* 02C0 */  0x3C, 0x2F, 0x44, 0x69, 0x73, 0x70, 0x6C, 0x61,  // </Displa
                    /* 02C8 */  0x79, 0x54, 0x72, 0x61, 0x6E, 0x73, 0x66, 0x65,  // yTransfe
                    /* 02D0 */  0x72, 0x43, 0x68, 0x61, 0x72, 0x61, 0x63, 0x74,  // rCharact
                    /* 02D8 */  0x65, 0x72, 0x69, 0x73, 0x74, 0x69, 0x63, 0x73,  // eristics
                    /* 02E0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x46,  // >.    <F
                    /* 02E8 */  0x65, 0x61, 0x74, 0x75, 0x72, 0x65, 0x53, 0x75,  // eatureSu
                    /* 02F0 */  0x70, 0x70, 0x6F, 0x72, 0x74, 0x3E, 0x30, 0x78,  // pport>0x
                    /* 02F8 */  0x32, 0x3C, 0x2F, 0x46, 0x65, 0x61, 0x74, 0x75,  // 2</Featu
                    /* 0300 */  0x72, 0x65, 0x53, 0x75, 0x70, 0x70, 0x6F, 0x72,  // reSuppor
                    /* 0308 */  0x74, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // t>.    <
                    /* 0310 */  0x52, 0x65, 0x64, 0x2E, 0x47, 0x72, 0x65, 0x65,  // Red.Gree
                    /* 0318 */  0x6E, 0x42, 0x69, 0x74, 0x73, 0x3E, 0x30, 0x78,  // nBits>0x
                    /* 0320 */  0x41, 0x35, 0x3C, 0x2F, 0x52, 0x65, 0x64, 0x2E,  // A5</Red.
                    /* 0328 */  0x47, 0x72, 0x65, 0x65, 0x6E, 0x42, 0x69, 0x74,  // GreenBit
                    /* 0330 */  0x73, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // s>.    <
                    /* 0338 */  0x42, 0x6C, 0x75, 0x65, 0x2E, 0x57, 0x68, 0x69,  // Blue.Whi
                    /* 0340 */  0x74, 0x65, 0x42, 0x69, 0x74, 0x73, 0x3E, 0x30,  // teBits>0
                    /* 0348 */  0x78, 0x35, 0x38, 0x3C, 0x2F, 0x42, 0x6C, 0x75,  // x58</Blu
                    /* 0350 */  0x65, 0x2E, 0x57, 0x68, 0x69, 0x74, 0x65, 0x42,  // e.WhiteB
                    /* 0358 */  0x69, 0x74, 0x73, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // its>.   
                    /* 0360 */  0x20, 0x3C, 0x52, 0x65, 0x64, 0x58, 0x3E, 0x30,  //  <RedX>0
                    /* 0368 */  0x78, 0x41, 0x36, 0x3C, 0x2F, 0x52, 0x65, 0x64,  // xA6</Red
                    /* 0370 */  0x58, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // X>.    <
                    /* 0378 */  0x52, 0x65, 0x64, 0x59, 0x3E, 0x30, 0x78, 0x35,  // RedY>0x5
                    /* 0380 */  0x34, 0x3C, 0x2F, 0x52, 0x65, 0x64, 0x59, 0x3E,  // 4</RedY>
                    /* 0388 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x47, 0x72,  // .    <Gr
                    /* 0390 */  0x65, 0x65, 0x6E, 0x58, 0x3E, 0x30, 0x78, 0x33,  // eenX>0x3
                    /* 0398 */  0x33, 0x3C, 0x2F, 0x47, 0x72, 0x65, 0x65, 0x6E,  // 3</Green
                    /* 03A0 */  0x58, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // X>.    <
                    /* 03A8 */  0x47, 0x72, 0x65, 0x65, 0x6E, 0x59, 0x3E, 0x30,  // GreenY>0
                    /* 03B0 */  0x78, 0x42, 0x33, 0x3C, 0x2F, 0x47, 0x72, 0x65,  // xB3</Gre
                    /* 03B8 */  0x65, 0x6E, 0x59, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // enY>.   
                    /* 03C0 */  0x20, 0x3C, 0x42, 0x6C, 0x75, 0x65, 0x58, 0x3E,  //  <BlueX>
                    /* 03C8 */  0x30, 0x78, 0x32, 0x36, 0x3C, 0x2F, 0x42, 0x6C,  // 0x26</Bl
                    /* 03D0 */  0x75, 0x65, 0x58, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ueX>.   
                    /* 03D8 */  0x20, 0x3C, 0x42, 0x6C, 0x75, 0x65, 0x59, 0x3E,  //  <BlueY>
                    /* 03E0 */  0x30, 0x78, 0x31, 0x32, 0x3C, 0x2F, 0x42, 0x6C,  // 0x12</Bl
                    /* 03E8 */  0x75, 0x65, 0x59, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ueY>.   
                    /* 03F0 */  0x20, 0x3C, 0x57, 0x68, 0x69, 0x74, 0x65, 0x58,  //  <WhiteX
                    /* 03F8 */  0x3E, 0x30, 0x78, 0x34, 0x46, 0x3C, 0x2F, 0x57,  // >0x4F</W
                    /* 0400 */  0x68, 0x69, 0x74, 0x65, 0x58, 0x3E, 0x0A, 0x20,  // hiteX>. 
                    /* 0408 */  0x20, 0x20, 0x20, 0x3C, 0x57, 0x68, 0x69, 0x74,  //    <Whit
                    /* 0410 */  0x65, 0x59, 0x3E, 0x30, 0x78, 0x35, 0x34, 0x3C,  // eY>0x54<
                    /* 0418 */  0x2F, 0x57, 0x68, 0x69, 0x74, 0x65, 0x59, 0x3E,  // /WhiteY>
                    /* 0420 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x45, 0x73,  // .    <Es
                    /* 0428 */  0x74, 0x61, 0x62, 0x6C, 0x69, 0x73, 0x68, 0x65,  // tablishe
                    /* 0430 */  0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73,  // dTimings
                    /* 0438 */  0x49, 0x3E, 0x30, 0x78, 0x30, 0x3C, 0x2F, 0x45,  // I>0x0</E
                    /* 0440 */  0x73, 0x74, 0x61, 0x62, 0x6C, 0x69, 0x73, 0x68,  // stablish
                    /* 0448 */  0x65, 0x64, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // edTiming
                    /* 0450 */  0x73, 0x49, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // sI>.    
                    /* 0458 */  0x3C, 0x45, 0x73, 0x74, 0x61, 0x62, 0x6C, 0x69,  // <Establi
                    /* 0460 */  0x73, 0x68, 0x65, 0x64, 0x54, 0x69, 0x6D, 0x69,  // shedTimi
                    /* 0468 */  0x6E, 0x67, 0x73, 0x49, 0x49, 0x3E, 0x30, 0x78,  // ngsII>0x
                    /* 0470 */  0x30, 0x3C, 0x2F, 0x45, 0x73, 0x74, 0x61, 0x62,  // 0</Estab
                    /* 0478 */  0x6C, 0x69, 0x73, 0x68, 0x65, 0x64, 0x54, 0x69,  // lishedTi
                    /* 0480 */  0x6D, 0x69, 0x6E, 0x67, 0x73, 0x49, 0x49, 0x3E,  // mingsII>
                    /* 0488 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x4D, 0x61,  // .    <Ma
                    /* 0490 */  0x6E, 0x75, 0x66, 0x61, 0x63, 0x74, 0x75, 0x72,  // nufactur
                    /* 0498 */  0x65, 0x73, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // esTiming
                    /* 04A0 */  0x3E, 0x30, 0x78, 0x30, 0x3C, 0x2F, 0x4D, 0x61,  // >0x0</Ma
                    /* 04A8 */  0x6E, 0x75, 0x66, 0x61, 0x63, 0x74, 0x75, 0x72,  // nufactur
                    /* 04B0 */  0x65, 0x73, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // esTiming
                    /* 04B8 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 04C0 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 04C8 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x31, 0x2F,  // imings1/
                    /* 04D0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 04D8 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 04E0 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x32, 0x2F,  // imings2/
                    /* 04E8 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 04F0 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 04F8 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x33, 0x2F,  // imings3/
                    /* 0500 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 0508 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 0510 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x34, 0x2F,  // imings4/
                    /* 0518 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 0520 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 0528 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x35, 0x2F,  // imings5/
                    /* 0530 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 0538 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 0540 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x36, 0x2F,  // imings6/
                    /* 0548 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 0550 */  0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x54,  // tandardT
                    /* 0558 */  0x69, 0x6D, 0x69, 0x6E, 0x67, 0x73, 0x37, 0x2F,  // imings7/
                    /* 0560 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x53,  // >.    <S
                    /* 0568 */  0x69, 0x67, 0x6E, 0x61, 0x6C, 0x54, 0x69, 0x6D,  // ignalTim
                    /* 0570 */  0x69, 0x6E, 0x67, 0x49, 0x6E, 0x74, 0x65, 0x72,  // ingInter
                    /* 0578 */  0x66, 0x61, 0x63, 0x65, 0x2F, 0x3E, 0x0A, 0x3C,  // face/>.<
                    /* 0580 */  0x2F, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A,  // /Group>.
                    /* 0588 */  0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69,  // <Group i
                    /* 0590 */  0x64, 0x3D, 0x27, 0x44, 0x65, 0x74, 0x61, 0x69,  // d='Detai
                    /* 0598 */  0x6C, 0x65, 0x64, 0x20, 0x54, 0x69, 0x6D, 0x69,  // led Timi
                    /* 05A0 */  0x6E, 0x67, 0x27, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ng'>.   
                    /* 05A8 */  0x20, 0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  //  <Horizo
                    /* 05B0 */  0x6E, 0x74, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65,  // ntalScre
                    /* 05B8 */  0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x4D, 0x4D,  // enSizeMM
                    /* 05C0 */  0x3E, 0x30, 0x78, 0x34, 0x34, 0x3C, 0x2F, 0x48,  // >0x44</H
                    /* 05C8 */  0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61,  // orizonta
                    /* 05D0 */  0x6C, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6E, 0x53,  // lScreenS
                    /* 05D8 */  0x69, 0x7A, 0x65, 0x4D, 0x4D, 0x3E, 0x0A, 0x20,  // izeMM>. 
                    /* 05E0 */  0x20, 0x20, 0x20, 0x3C, 0x56, 0x65, 0x72, 0x74,  //    <Vert
                    /* 05E8 */  0x69, 0x63, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65,  // icalScre
                    /* 05F0 */  0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x4D, 0x4D,  // enSizeMM
                    /* 05F8 */  0x3E, 0x30, 0x78, 0x37, 0x38, 0x3C, 0x2F, 0x56,  // >0x78</V
                    /* 0600 */  0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x53,  // erticalS
                    /* 0608 */  0x63, 0x72, 0x65, 0x65, 0x6E, 0x53, 0x69, 0x7A,  // creenSiz
                    /* 0610 */  0x65, 0x4D, 0x4D, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // eMM>.   
                    /* 0618 */  0x20, 0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  //  <Horizo
                    /* 0620 */  0x6E, 0x74, 0x61, 0x6C, 0x56, 0x65, 0x72, 0x74,  // ntalVert
                    /* 0628 */  0x69, 0x63, 0x61, 0x6C, 0x53, 0x63, 0x72, 0x65,  // icalScre
                    /* 0630 */  0x65, 0x6E, 0x53, 0x69, 0x7A, 0x65, 0x4D, 0x4D,  // enSizeMM
                    /* 0638 */  0x3E, 0x30, 0x78, 0x30, 0x30, 0x3C, 0x2F, 0x48,  // >0x00</H
                    /* 0640 */  0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61,  // orizonta
                    /* 0648 */  0x6C, 0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61,  // lVertica
                    /* 0650 */  0x6C, 0x53, 0x63, 0x72, 0x65, 0x65, 0x6E, 0x53,  // lScreenS
                    /* 0658 */  0x69, 0x7A, 0x65, 0x4D, 0x4D, 0x3E, 0x0A, 0x3C,  // izeMM>.<
                    /* 0660 */  0x2F, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A,  // /Group>.
                    /* 0668 */  0x3C, 0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69,  // <Group i
                    /* 0670 */  0x64, 0x3D, 0x27, 0x41, 0x63, 0x74, 0x69, 0x76,  // d='Activ
                    /* 0678 */  0x65, 0x20, 0x54, 0x69, 0x6D, 0x69, 0x6E, 0x67,  // e Timing
                    /* 0680 */  0x27, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // '>.    <
                    /* 0688 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 0690 */  0x61, 0x6C, 0x41, 0x63, 0x74, 0x69, 0x76, 0x65,  // alActive
                    /* 0698 */  0x3E, 0x32, 0x31, 0x36, 0x30, 0x3C, 0x2F, 0x48,  // >2160</H
                    /* 06A0 */  0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61,  // orizonta
                    /* 06A8 */  0x6C, 0x41, 0x63, 0x74, 0x69, 0x76, 0x65, 0x3E,  // lActive>
                    /* 06B0 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F,  // .    <Ho
                    /* 06B8 */  0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C,  // rizontal
                    /* 06C0 */  0x46, 0x72, 0x6F, 0x6E, 0x74, 0x50, 0x6F, 0x72,  // FrontPor
                    /* 06C8 */  0x63, 0x68, 0x3E, 0x33, 0x30, 0x3C, 0x2F, 0x48,  // ch>30</H
                    /* 06D0 */  0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61,  // orizonta
                    /* 06D8 */  0x6C, 0x46, 0x72, 0x6F, 0x6E, 0x74, 0x50, 0x6F,  // lFrontPo
                    /* 06E0 */  0x72, 0x63, 0x68, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // rch>.   
                    /* 06E8 */  0x20, 0x3C, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F,  //  <Horizo
                    /* 06F0 */  0x6E, 0x74, 0x61, 0x6C, 0x42, 0x61, 0x63, 0x6B,  // ntalBack
                    /* 06F8 */  0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E, 0x31, 0x30,  // Porch>10
                    /* 0700 */  0x30, 0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A,  // 0</Horiz
                    /* 0708 */  0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x42, 0x61, 0x63,  // ontalBac
                    /* 0710 */  0x6B, 0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E, 0x0A,  // kPorch>.
                    /* 0718 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72,  //     <Hor
                    /* 0720 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x53,  // izontalS
                    /* 0728 */  0x79, 0x6E, 0x63, 0x50, 0x75, 0x6C, 0x73, 0x65,  // yncPulse
                    /* 0730 */  0x3E, 0x34, 0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69,  // >4</Hori
                    /* 0738 */  0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x53, 0x79,  // zontalSy
                    /* 0740 */  0x6E, 0x63, 0x50, 0x75, 0x6C, 0x73, 0x65, 0x3E,  // ncPulse>
                    /* 0748 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F,  // .    <Ho
                    /* 0750 */  0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C,  // rizontal
                    /* 0758 */  0x53, 0x79, 0x6E, 0x63, 0x53, 0x6B, 0x65, 0x77,  // SyncSkew
                    /* 0760 */  0x3E, 0x30, 0x3C, 0x2F, 0x48, 0x6F, 0x72, 0x69,  // >0</Hori
                    /* 0768 */  0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x53, 0x79,  // zontalSy
                    /* 0770 */  0x6E, 0x63, 0x53, 0x6B, 0x65, 0x77, 0x3E, 0x0A,  // ncSkew>.
                    /* 0778 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x48, 0x6F, 0x72,  //     <Hor
                    /* 0780 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x4C,  // izontalL
                    /* 0788 */  0x65, 0x66, 0x74, 0x42, 0x6F, 0x72, 0x64, 0x65,  // eftBorde
                    /* 0790 */  0x72, 0x3E, 0x30, 0x3C, 0x2F, 0x48, 0x6F, 0x72,  // r>0</Hor
                    /* 0798 */  0x69, 0x7A, 0x6F, 0x6E, 0x74, 0x61, 0x6C, 0x4C,  // izontalL
                    /* 07A0 */  0x65, 0x66, 0x74, 0x42, 0x6F, 0x72, 0x64, 0x65,  // eftBorde
                    /* 07A8 */  0x72, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // r>.    <
                    /* 07B0 */  0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E, 0x74,  // Horizont
                    /* 07B8 */  0x61, 0x6C, 0x52, 0x69, 0x67, 0x68, 0x74, 0x42,  // alRightB
                    /* 07C0 */  0x6F, 0x72, 0x64, 0x65, 0x72, 0x3E, 0x30, 0x3C,  // order>0<
                    /* 07C8 */  0x2F, 0x48, 0x6F, 0x72, 0x69, 0x7A, 0x6F, 0x6E,  // /Horizon
                    /* 07D0 */  0x74, 0x61, 0x6C, 0x52, 0x69, 0x67, 0x68, 0x74,  // talRight
                    /* 07D8 */  0x42, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x3E, 0x0A,  // Border>.
                    /* 07E0 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x56, 0x65, 0x72,  //     <Ver
                    /* 07E8 */  0x74, 0x69, 0x63, 0x61, 0x6C, 0x41, 0x63, 0x74,  // ticalAct
                    /* 07F0 */  0x69, 0x76, 0x65, 0x3E, 0x33, 0x38, 0x34, 0x30,  // ive>3840
                    /* 07F8 */  0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74, 0x69, 0x63,  // </Vertic
                    /* 0800 */  0x61, 0x6C, 0x41, 0x63, 0x74, 0x69, 0x76, 0x65,  // alActive
                    /* 0808 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56,  // >.    <V
                    /* 0810 */  0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x46,  // erticalF
                    /* 0818 */  0x72, 0x6F, 0x6E, 0x74, 0x50, 0x6F, 0x72, 0x63,  // rontPorc
                    /* 0820 */  0x68, 0x3E, 0x38, 0x3C, 0x2F, 0x56, 0x65, 0x72,  // h>8</Ver
                    /* 0828 */  0x74, 0x69, 0x63, 0x61, 0x6C, 0x46, 0x72, 0x6F,  // ticalFro
                    /* 0830 */  0x6E, 0x74, 0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E,  // ntPorch>
                    /* 0838 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x56, 0x65,  // .    <Ve
                    /* 0840 */  0x72, 0x74, 0x69, 0x63, 0x61, 0x6C, 0x42, 0x61,  // rticalBa
                    /* 0848 */  0x63, 0x6B, 0x50, 0x6F, 0x72, 0x63, 0x68, 0x3E,  // ckPorch>
                    /* 0850 */  0x37, 0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74, 0x69,  // 7</Verti
                    /* 0858 */  0x63, 0x61, 0x6C, 0x42, 0x61, 0x63, 0x6B, 0x50,  // calBackP
                    /* 0860 */  0x6F, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x20, 0x20,  // orch>.  
                    /* 0868 */  0x20, 0x20, 0x3C, 0x56, 0x65, 0x72, 0x74, 0x69,  //   <Verti
                    /* 0870 */  0x63, 0x61, 0x6C, 0x53, 0x79, 0x6E, 0x63, 0x50,  // calSyncP
                    /* 0878 */  0x75, 0x6C, 0x73, 0x65, 0x3E, 0x31, 0x3C, 0x2F,  // ulse>1</
                    /* 0880 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 0888 */  0x53, 0x79, 0x6E, 0x63, 0x50, 0x75, 0x6C, 0x73,  // SyncPuls
                    /* 0890 */  0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // e>.    <
                    /* 0898 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 08A0 */  0x53, 0x79, 0x6E, 0x63, 0x53, 0x6B, 0x65, 0x77,  // SyncSkew
                    /* 08A8 */  0x3E, 0x30, 0x3C, 0x2F, 0x56, 0x65, 0x72, 0x74,  // >0</Vert
                    /* 08B0 */  0x69, 0x63, 0x61, 0x6C, 0x53, 0x79, 0x6E, 0x63,  // icalSync
                    /* 08B8 */  0x53, 0x6B, 0x65, 0x77, 0x3E, 0x0A, 0x20, 0x20,  // Skew>.  
                    /* 08C0 */  0x20, 0x20, 0x3C, 0x56, 0x65, 0x72, 0x74, 0x69,  //   <Verti
                    /* 08C8 */  0x63, 0x61, 0x6C, 0x54, 0x6F, 0x70, 0x42, 0x6F,  // calTopBo
                    /* 08D0 */  0x72, 0x64, 0x65, 0x72, 0x3E, 0x30, 0x3C, 0x2F,  // rder>0</
                    /* 08D8 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 08E0 */  0x54, 0x6F, 0x70, 0x42, 0x6F, 0x72, 0x64, 0x65,  // TopBorde
                    /* 08E8 */  0x72, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // r>.    <
                    /* 08F0 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 08F8 */  0x42, 0x6F, 0x74, 0x74, 0x6F, 0x6D, 0x42, 0x6F,  // BottomBo
                    /* 0900 */  0x72, 0x64, 0x65, 0x72, 0x3E, 0x30, 0x3C, 0x2F,  // rder>0</
                    /* 0908 */  0x56, 0x65, 0x72, 0x74, 0x69, 0x63, 0x61, 0x6C,  // Vertical
                    /* 0910 */  0x42, 0x6F, 0x74, 0x74, 0x6F, 0x6D, 0x42, 0x6F,  // BottomBo
                    /* 0918 */  0x72, 0x64, 0x65, 0x72, 0x3E, 0x0A, 0x20, 0x20,  // rder>.  
                    /* 0920 */  0x20, 0x20, 0x3C, 0x49, 0x6E, 0x76, 0x65, 0x72,  //   <Inver
                    /* 0928 */  0x74, 0x44, 0x61, 0x74, 0x61, 0x50, 0x6F, 0x6C,  // tDataPol
                    /* 0930 */  0x61, 0x72, 0x69, 0x74, 0x79, 0x3E, 0x46, 0x61,  // arity>Fa
                    /* 0938 */  0x6C, 0x73, 0x65, 0x3C, 0x2F, 0x49, 0x6E, 0x76,  // lse</Inv
                    /* 0940 */  0x65, 0x72, 0x74, 0x44, 0x61, 0x74, 0x61, 0x50,  // ertDataP
                    /* 0948 */  0x6F, 0x6C, 0x61, 0x72, 0x69, 0x74, 0x79, 0x3E,  // olarity>
                    /* 0950 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x49, 0x6E,  // .    <In
                    /* 0958 */  0x76, 0x65, 0x72, 0x74, 0x56, 0x73, 0x79, 0x6E,  // vertVsyn
                    /* 0960 */  0x63, 0x50, 0x6F, 0x6C, 0x61, 0x69, 0x72, 0x74,  // cPolairt
                    /* 0968 */  0x79, 0x3E, 0x46, 0x61, 0x6C, 0x73, 0x65, 0x3C,  // y>False<
                    /* 0970 */  0x2F, 0x49, 0x6E, 0x76, 0x65, 0x72, 0x74, 0x56,  // /InvertV
                    /* 0978 */  0x73, 0x79, 0x6E, 0x63, 0x50, 0x6F, 0x6C, 0x61,  // syncPola
                    /* 0980 */  0x69, 0x72, 0x74, 0x79, 0x3E, 0x0A, 0x20, 0x20,  // irty>.  
                    /* 0988 */  0x20, 0x20, 0x3C, 0x49, 0x6E, 0x76, 0x65, 0x72,  //   <Inver
                    /* 0990 */  0x74, 0x48, 0x73, 0x79, 0x6E, 0x63, 0x50, 0x6F,  // tHsyncPo
                    /* 0998 */  0x6C, 0x61, 0x72, 0x69, 0x74, 0x79, 0x3E, 0x46,  // larity>F
                    /* 09A0 */  0x61, 0x6C, 0x73, 0x65, 0x3C, 0x2F, 0x49, 0x6E,  // alse</In
                    /* 09A8 */  0x76, 0x65, 0x72, 0x74, 0x48, 0x73, 0x79, 0x6E,  // vertHsyn
                    /* 09B0 */  0x63, 0x50, 0x6F, 0x6C, 0x61, 0x72, 0x69, 0x74,  // cPolarit
                    /* 09B8 */  0x79, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // y>.    <
                    /* 09C0 */  0x42, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x43, 0x6F,  // BorderCo
                    /* 09C8 */  0x6C, 0x6F, 0x72, 0x3E, 0x30, 0x78, 0x30, 0x3C,  // lor>0x0<
                    /* 09D0 */  0x2F, 0x42, 0x6F, 0x72, 0x64, 0x65, 0x72, 0x43,  // /BorderC
                    /* 09D8 */  0x6F, 0x6C, 0x6F, 0x72, 0x3E, 0x0A, 0x3C, 0x2F,  // olor>.</
                    /* 09E0 */  0x47, 0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A, 0x3C,  // Group>.<
                    /* 09E8 */  0x47, 0x72, 0x6F, 0x75, 0x70, 0x20, 0x69, 0x64,  // Group id
                    /* 09F0 */  0x3D, 0x27, 0x44, 0x69, 0x73, 0x70, 0x6C, 0x61,  // ='Displa
                    /* 09F8 */  0x79, 0x20, 0x49, 0x6E, 0x74, 0x65, 0x72, 0x66,  // y Interf
                    /* 0A00 */  0x61, 0x63, 0x65, 0x27, 0x3E, 0x0A, 0x20, 0x20,  // ace'>.  
                    /* 0A08 */  0x20, 0x20, 0x3C, 0x49, 0x6E, 0x74, 0x65, 0x72,  //   <Inter
                    /* 0A10 */  0x66, 0x61, 0x63, 0x65, 0x54, 0x79, 0x70, 0x65,  // faceType
                    /* 0A18 */  0x3E, 0x39, 0x3C, 0x2F, 0x49, 0x6E, 0x74, 0x65,  // >9</Inte
                    /* 0A20 */  0x72, 0x66, 0x61, 0x63, 0x65, 0x54, 0x79, 0x70,  // rfaceTyp
                    /* 0A28 */  0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // e>.    <
                    /* 0A30 */  0x49, 0x6E, 0x74, 0x65, 0x72, 0x66, 0x61, 0x63,  // Interfac
                    /* 0A38 */  0x65, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x46, 0x6F,  // eColorFo
                    /* 0A40 */  0x72, 0x6D, 0x61, 0x74, 0x3E, 0x33, 0x3C, 0x2F,  // rmat>3</
                    /* 0A48 */  0x49, 0x6E, 0x74, 0x65, 0x72, 0x66, 0x61, 0x63,  // Interfac
                    /* 0A50 */  0x65, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x46, 0x6F,  // eColorFo
                    /* 0A58 */  0x72, 0x6D, 0x61, 0x74, 0x3E, 0x0A, 0x20, 0x20,  // rmat>.  
                    /* 0A60 */  0x20, 0x20, 0x3C, 0x44, 0x69, 0x73, 0x70, 0x6C,  //   <Displ
                    /* 0A68 */  0x61, 0x79, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x53,  // ayPowerS
                    /* 0A70 */  0x61, 0x76, 0x69, 0x6E, 0x67, 0x4F, 0x76, 0x65,  // avingOve
                    /* 0A78 */  0x72, 0x72, 0x69, 0x64, 0x65, 0x3E, 0x38, 0x3C,  // rride>8<
                    /* 0A80 */  0x2F, 0x44, 0x69, 0x73, 0x70, 0x6C, 0x61, 0x79,  // /Display
                    /* 0A88 */  0x50, 0x6F, 0x77, 0x65, 0x72, 0x53, 0x61, 0x76,  // PowerSav
                    /* 0A90 */  0x69, 0x6E, 0x67, 0x4F, 0x76, 0x65, 0x72, 0x72,  // ingOverr
                    /* 0A98 */  0x69, 0x64, 0x65, 0x3E, 0x0A, 0x3C, 0x2F, 0x47,  // ide>.</G
                    /* 0AA0 */  0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A, 0x3C, 0x47,  // roup>.<G
                    /* 0AA8 */  0x72, 0x6F, 0x75, 0x70, 0x20, 0x69, 0x64, 0x3D,  // roup id=
                    /* 0AB0 */  0x27, 0x44, 0x53, 0x49, 0x20, 0x49, 0x6E, 0x74,  // 'DSI Int
                    /* 0AB8 */  0x65, 0x72, 0x66, 0x61, 0x63, 0x65, 0x27, 0x3E,  // erface'>
                    /* 0AC0 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0AC8 */  0x49, 0x43, 0x68, 0x61, 0x6E, 0x6E, 0x65, 0x6C,  // IChannel
                    /* 0AD0 */  0x49, 0x64, 0x3E, 0x32, 0x3C, 0x2F, 0x44, 0x53,  // Id>2</DS
                    /* 0AD8 */  0x49, 0x43, 0x68, 0x61, 0x6E, 0x6E, 0x65, 0x6C,  // IChannel
                    /* 0AE0 */  0x49, 0x64, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // Id>.    
                    /* 0AE8 */  0x3C, 0x44, 0x53, 0x49, 0x56, 0x69, 0x72, 0x74,  // <DSIVirt
                    /* 0AF0 */  0x75, 0x61, 0x6C, 0x49, 0x64, 0x3E, 0x30, 0x3C,  // ualId>0<
                    /* 0AF8 */  0x2F, 0x44, 0x53, 0x49, 0x56, 0x69, 0x72, 0x74,  // /DSIVirt
                    /* 0B00 */  0x75, 0x61, 0x6C, 0x49, 0x64, 0x3E, 0x0A, 0x20,  // ualId>. 
                    /* 0B08 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x43,  //    <DSIC
                    /* 0B10 */  0x6F, 0x6C, 0x6F, 0x72, 0x46, 0x6F, 0x72, 0x6D,  // olorForm
                    /* 0B18 */  0x61, 0x74, 0x3E, 0x33, 0x36, 0x3C, 0x2F, 0x44,  // at>36</D
                    /* 0B20 */  0x53, 0x49, 0x43, 0x6F, 0x6C, 0x6F, 0x72, 0x46,  // SIColorF
                    /* 0B28 */  0x6F, 0x72, 0x6D, 0x61, 0x74, 0x3E, 0x0A, 0x20,  // ormat>. 
                    /* 0B30 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x54,  //    <DSIT
                    /* 0B38 */  0x72, 0x61, 0x66, 0x66, 0x69, 0x63, 0x4D, 0x6F,  // rafficMo
                    /* 0B40 */  0x64, 0x65, 0x3E, 0x31, 0x3C, 0x2F, 0x44, 0x53,  // de>1</DS
                    /* 0B48 */  0x49, 0x54, 0x72, 0x61, 0x66, 0x66, 0x69, 0x63,  // ITraffic
                    /* 0B50 */  0x4D, 0x6F, 0x64, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // Mode>.  
                    /* 0B58 */  0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x4C, 0x61,  //   <DSILa
                    /* 0B60 */  0x6E, 0x65, 0x73, 0x3E, 0x34, 0x3C, 0x2F, 0x44,  // nes>4</D
                    /* 0B68 */  0x53, 0x49, 0x4C, 0x61, 0x6E, 0x65, 0x73, 0x3E,  // SILanes>
                    /* 0B70 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0B78 */  0x49, 0x52, 0x65, 0x66, 0x72, 0x65, 0x73, 0x68,  // IRefresh
                    /* 0B80 */  0x52, 0x61, 0x74, 0x65, 0x3E, 0x30, 0x78, 0x33,  // Rate>0x3
                    /* 0B88 */  0x43, 0x30, 0x30, 0x30, 0x30, 0x3C, 0x2F, 0x44,  // C0000</D
                    /* 0B90 */  0x53, 0x49, 0x52, 0x65, 0x66, 0x72, 0x65, 0x73,  // SIRefres
                    /* 0B98 */  0x68, 0x52, 0x61, 0x74, 0x65, 0x3E, 0x0A, 0x20,  // hRate>. 
                    /* 0BA0 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x43,  //    <DSIC
                    /* 0BA8 */  0x6D, 0x64, 0x53, 0x77, 0x61, 0x70, 0x49, 0x6E,  // mdSwapIn
                    /* 0BB0 */  0x74, 0x65, 0x72, 0x66, 0x61, 0x63, 0x65, 0x3E,  // terface>
                    /* 0BB8 */  0x46, 0x61, 0x6C, 0x73, 0x65, 0x3C, 0x2F, 0x44,  // False</D
                    /* 0BC0 */  0x53, 0x49, 0x43, 0x6D, 0x64, 0x53, 0x77, 0x61,  // SICmdSwa
                    /* 0BC8 */  0x70, 0x49, 0x6E, 0x74, 0x65, 0x72, 0x66, 0x61,  // pInterfa
                    /* 0BD0 */  0x63, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // ce>.    
                    /* 0BD8 */  0x3C, 0x44, 0x53, 0x49, 0x43, 0x6D, 0x64, 0x55,  // <DSICmdU
                    /* 0BE0 */  0x73, 0x69, 0x6E, 0x67, 0x54, 0x72, 0x69, 0x67,  // singTrig
                    /* 0BE8 */  0x67, 0x65, 0x72, 0x3E, 0x46, 0x61, 0x6C, 0x73,  // ger>Fals
                    /* 0BF0 */  0x65, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x43, 0x6D,  // e</DSICm
                    /* 0BF8 */  0x64, 0x55, 0x73, 0x69, 0x6E, 0x67, 0x54, 0x72,  // dUsingTr
                    /* 0C00 */  0x69, 0x67, 0x67, 0x65, 0x72, 0x3E, 0x0A, 0x20,  // igger>. 
                    /* 0C08 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x54,  //    <DSIT
                    /* 0C10 */  0x45, 0x43, 0x68, 0x65, 0x63, 0x6B, 0x45, 0x6E,  // ECheckEn
                    /* 0C18 */  0x61, 0x62, 0x6C, 0x65, 0x3E, 0x46, 0x61, 0x6C,  // able>Fal
                    /* 0C20 */  0x73, 0x65, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x54,  // se</DSIT
                    /* 0C28 */  0x45, 0x43, 0x68, 0x65, 0x63, 0x6B, 0x45, 0x6E,  // ECheckEn
                    /* 0C30 */  0x61, 0x62, 0x6C, 0x65, 0x3E, 0x0A, 0x20, 0x20,  // able>.  
                    /* 0C38 */  0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x54, 0x45,  //   <DSITE
                    /* 0C40 */  0x55, 0x73, 0x69, 0x6E, 0x67, 0x44, 0x65, 0x64,  // UsingDed
                    /* 0C48 */  0x69, 0x63, 0x61, 0x74, 0x65, 0x64, 0x54, 0x45,  // icatedTE
                    /* 0C50 */  0x50, 0x69, 0x6E, 0x3E, 0x54, 0x72, 0x75, 0x65,  // Pin>True
                    /* 0C58 */  0x3C, 0x2F, 0x44, 0x53, 0x49, 0x54, 0x45, 0x55,  // </DSITEU
                    /* 0C60 */  0x73, 0x69, 0x6E, 0x67, 0x44, 0x65, 0x64, 0x69,  // singDedi
                    /* 0C68 */  0x63, 0x61, 0x74, 0x65, 0x64, 0x54, 0x45, 0x50,  // catedTEP
                    /* 0C70 */  0x69, 0x6E, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // in>.    
                    /* 0C78 */  0x3C, 0x44, 0x53, 0x49, 0x54, 0x45, 0x76, 0x53,  // <DSITEvS
                    /* 0C80 */  0x79, 0x6E, 0x63, 0x49, 0x6E, 0x69, 0x74, 0x56,  // yncInitV
                    /* 0C88 */  0x61, 0x6C, 0x3E, 0x30, 0x3C, 0x2F, 0x44, 0x53,  // al>0</DS
                    /* 0C90 */  0x49, 0x54, 0x45, 0x76, 0x53, 0x79, 0x6E, 0x63,  // ITEvSync
                    /* 0C98 */  0x49, 0x6E, 0x69, 0x74, 0x56, 0x61, 0x6C, 0x3E,  // InitVal>
                    /* 0CA0 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0CA8 */  0x49, 0x54, 0x45, 0x76, 0x53, 0x79, 0x6E, 0x63,  // ITEvSync
                    /* 0CB0 */  0x52, 0x64, 0x50, 0x74, 0x72, 0x49, 0x72, 0x71,  // RdPtrIrq
                    /* 0CB8 */  0x4C, 0x69, 0x6E, 0x65, 0x3E, 0x33, 0x36, 0x30,  // Line>360
                    /* 0CC0 */  0x30, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x54, 0x45,  // 0</DSITE
                    /* 0CC8 */  0x76, 0x53, 0x79, 0x6E, 0x63, 0x52, 0x64, 0x50,  // vSyncRdP
                    /* 0CD0 */  0x74, 0x72, 0x49, 0x72, 0x71, 0x4C, 0x69, 0x6E,  // trIrqLin
                    /* 0CD8 */  0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // e>.    <
                    /* 0CE0 */  0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x45, 0x6E,  // DSIDSCEn
                    /* 0CE8 */  0x61, 0x62, 0x6C, 0x65, 0x3E, 0x54, 0x72, 0x75,  // able>Tru
                    /* 0CF0 */  0x65, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44, 0x53,  // e</DSIDS
                    /* 0CF8 */  0x43, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x3E,  // CEnable>
                    /* 0D00 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0D08 */  0x49, 0x44, 0x53, 0x43, 0x4D, 0x61, 0x6A, 0x6F,  // IDSCMajo
                    /* 0D10 */  0x72, 0x56, 0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E,  // rVersion
                    /* 0D18 */  0x3E, 0x31, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44,  // >1</DSID
                    /* 0D20 */  0x53, 0x43, 0x4D, 0x61, 0x6A, 0x6F, 0x72, 0x56,  // SCMajorV
                    /* 0D28 */  0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x0A,  // ersion>.
                    /* 0D30 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49,  //     <DSI
                    /* 0D38 */  0x44, 0x53, 0x43, 0x4D, 0x69, 0x6E, 0x6F, 0x72,  // DSCMinor
                    /* 0D40 */  0x56, 0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E,  // Version>
                    /* 0D48 */  0x31, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44, 0x53,  // 1</DSIDS
                    /* 0D50 */  0x43, 0x4D, 0x69, 0x6E, 0x6F, 0x72, 0x56, 0x65,  // CMinorVe
                    /* 0D58 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3E, 0x0A, 0x20,  // rsion>. 
                    /* 0D60 */  0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49, 0x44,  //    <DSID
                    /* 0D68 */  0x53, 0x43, 0x53, 0x63, 0x72, 0x3E, 0x30, 0x3C,  // SCScr>0<
                    /* 0D70 */  0x2F, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x53,  // /DSIDSCS
                    /* 0D78 */  0x63, 0x72, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // cr>.    
                    /* 0D80 */  0x3C, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x50,  // <DSIDSCP
                    /* 0D88 */  0x72, 0x6F, 0x66, 0x69, 0x6C, 0x65, 0x49, 0x44,  // rofileID
                    /* 0D90 */  0x3E, 0x34, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x44,  // >4</DSID
                    /* 0D98 */  0x53, 0x43, 0x50, 0x72, 0x6F, 0x66, 0x69, 0x6C,  // SCProfil
                    /* 0DA0 */  0x65, 0x49, 0x44, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // eID>.   
                    /* 0DA8 */  0x20, 0x3C, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43,  //  <DSIDSC
                    /* 0DB0 */  0x53, 0x6C, 0x69, 0x63, 0x65, 0x57, 0x69, 0x64,  // SliceWid
                    /* 0DB8 */  0x74, 0x68, 0x3E, 0x31, 0x30, 0x38, 0x30, 0x3C,  // th>1080<
                    /* 0DC0 */  0x2F, 0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x53,  // /DSIDSCS
                    /* 0DC8 */  0x6C, 0x69, 0x63, 0x65, 0x57, 0x69, 0x64, 0x74,  // liceWidt
                    /* 0DD0 */  0x68, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // h>.    <
                    /* 0DD8 */  0x44, 0x53, 0x49, 0x44, 0x53, 0x43, 0x53, 0x6C,  // DSIDSCSl
                    /* 0DE0 */  0x69, 0x63, 0x65, 0x48, 0x65, 0x69, 0x67, 0x68,  // iceHeigh
                    /* 0DE8 */  0x74, 0x3E, 0x33, 0x32, 0x3C, 0x2F, 0x44, 0x53,  // t>32</DS
                    /* 0DF0 */  0x49, 0x44, 0x53, 0x43, 0x53, 0x6C, 0x69, 0x63,  // IDSCSlic
                    /* 0DF8 */  0x65, 0x48, 0x65, 0x69, 0x67, 0x68, 0x74, 0x3E,  // eHeight>
                    /* 0E00 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53,  // .    <DS
                    /* 0E08 */  0x49, 0x49, 0x6E, 0x69, 0x74, 0x4D, 0x61, 0x73,  // IInitMas
                    /* 0E10 */  0x74, 0x65, 0x72, 0x54, 0x69, 0x6D, 0x65, 0x3E,  // terTime>
                    /* 0E18 */  0x31, 0x32, 0x38, 0x3C, 0x2F, 0x44, 0x53, 0x49,  // 128</DSI
                    /* 0E20 */  0x49, 0x6E, 0x69, 0x74, 0x4D, 0x61, 0x73, 0x74,  // InitMast
                    /* 0E28 */  0x65, 0x72, 0x54, 0x69, 0x6D, 0x65, 0x3E, 0x0A,  // erTime>.
                    /* 0E30 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x53, 0x49,  //     <DSI
                    /* 0E38 */  0x43, 0x6F, 0x6E, 0x74, 0x72, 0x6F, 0x6C, 0x6C,  // Controll
                    /* 0E40 */  0x65, 0x72, 0x4D, 0x61, 0x70, 0x70, 0x69, 0x6E,  // erMappin
                    /* 0E48 */  0x67, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x20,  // g>.     
                    /* 0E50 */  0x20, 0x20, 0x20, 0x30, 0x30, 0x20, 0x30, 0x31,  //    00 01
                    /* 0E58 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x2F, 0x44,  // .    </D
                    /* 0E60 */  0x53, 0x49, 0x43, 0x6F, 0x6E, 0x74, 0x72, 0x6F,  // SIContro
                    /* 0E68 */  0x6C, 0x6C, 0x65, 0x72, 0x4D, 0x61, 0x70, 0x70,  // llerMapp
                    /* 0E70 */  0x69, 0x6E, 0x67, 0x3E, 0x0A, 0x3C, 0x2F, 0x47,  // ing>.</G
                    /* 0E78 */  0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A, 0x3C, 0x44,  // roup>.<D
                    /* 0E80 */  0x53, 0x49, 0x49, 0x6E, 0x69, 0x74, 0x53, 0x65,  // SIInitSe
                    /* 0E88 */  0x71, 0x75, 0x65, 0x6E, 0x63, 0x65, 0x3E, 0x0A,  // quence>.
                    /* 0E90 */  0x20, 0x20, 0x20, 0x20, 0x33, 0x39, 0x20, 0x39,  //     39 9
                    /* 0E98 */  0x31, 0x20, 0x30, 0x39, 0x20, 0x32, 0x30, 0x20,  // 1 09 20 
                    /* 0EA0 */  0x30, 0x30, 0x20, 0x32, 0x30, 0x20, 0x30, 0x32,  // 00 20 02
                    /* 0EA8 */  0x20, 0x30, 0x30, 0x20, 0x30, 0x33, 0x20, 0x31,  //  00 03 1
                    /* 0EB0 */  0x63, 0x20, 0x30, 0x34, 0x20, 0x32, 0x31, 0x20,  // c 04 21 
                    /* 0EB8 */  0x30, 0x30, 0x20, 0x30, 0x66, 0x20, 0x30, 0x33,  // 00 0f 03
                    /* 0EC0 */  0x20, 0x31, 0x39, 0x20, 0x30, 0x31, 0x20, 0x39,  //  19 01 9
                    /* 0EC8 */  0x37, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x33, 0x39,  // 7.    39
                    /* 0ED0 */  0x20, 0x39, 0x32, 0x20, 0x31, 0x30, 0x20, 0x66,  //  92 10 f
                    /* 0ED8 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x31, 0x35,  // 0.    15
                    /* 0EE0 */  0x20, 0x39, 0x30, 0x20, 0x30, 0x33, 0x0A, 0x20,  //  90 03. 
                    /* 0EE8 */  0x20, 0x20, 0x20, 0x31, 0x35, 0x20, 0x30, 0x33,  //    15 03
                    /* 0EF0 */  0x20, 0x30, 0x31, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  01.    
                    /* 0EF8 */  0x33, 0x39, 0x20, 0x66, 0x30, 0x20, 0x35, 0x35,  // 39 f0 55
                    /* 0F00 */  0x20, 0x61, 0x61, 0x20, 0x35, 0x32, 0x20, 0x30,  //  aa 52 0
                    /* 0F08 */  0x38, 0x20, 0x30, 0x34, 0x0A, 0x20, 0x20, 0x20,  // 8 04.   
                    /* 0F10 */  0x20, 0x31, 0x35, 0x20, 0x63, 0x30, 0x20, 0x30,  //  15 c0 0
                    /* 0F18 */  0x33, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x33, 0x39,  // 3.    39
                    /* 0F20 */  0x20, 0x66, 0x30, 0x20, 0x35, 0x35, 0x20, 0x61,  //  f0 55 a
                    /* 0F28 */  0x61, 0x20, 0x35, 0x32, 0x20, 0x30, 0x38, 0x20,  // a 52 08 
                    /* 0F30 */  0x30, 0x37, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x31,  // 07.    1
                    /* 0F38 */  0x35, 0x20, 0x65, 0x66, 0x20, 0x30, 0x31, 0x0A,  // 5 ef 01.
                    /* 0F40 */  0x20, 0x20, 0x20, 0x20, 0x33, 0x39, 0x20, 0x66,  //     39 f
                    /* 0F48 */  0x30, 0x20, 0x35, 0x35, 0x20, 0x61, 0x61, 0x20,  // 0 55 aa 
                    /* 0F50 */  0x35, 0x32, 0x20, 0x30, 0x38, 0x20, 0x30, 0x30,  // 52 08 00
                    /* 0F58 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x31, 0x35, 0x20,  // .    15 
                    /* 0F60 */  0x62, 0x34, 0x20, 0x30, 0x31, 0x0A, 0x20, 0x20,  // b4 01.  
                    /* 0F68 */  0x20, 0x20, 0x31, 0x35, 0x20, 0x33, 0x35, 0x20,  //   15 35 
                    /* 0F70 */  0x30, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x33,  // 00.    3
                    /* 0F78 */  0x39, 0x20, 0x66, 0x30, 0x20, 0x35, 0x35, 0x20,  // 9 f0 55 
                    /* 0F80 */  0x61, 0x61, 0x20, 0x35, 0x32, 0x20, 0x30, 0x38,  // aa 52 08
                    /* 0F88 */  0x20, 0x30, 0x31, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  01.    
                    /* 0F90 */  0x33, 0x39, 0x20, 0x66, 0x66, 0x20, 0x61, 0x61,  // 39 ff aa
                    /* 0F98 */  0x20, 0x35, 0x35, 0x20, 0x61, 0x35, 0x20, 0x38,  //  55 a5 8
                    /* 0FA0 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x31, 0x35,  // 0.    15
                    /* 0FA8 */  0x20, 0x36, 0x66, 0x20, 0x30, 0x31, 0x0A, 0x20,  //  6f 01. 
                    /* 0FB0 */  0x20, 0x20, 0x20, 0x31, 0x35, 0x20, 0x66, 0x33,  //    15 f3
                    /* 0FB8 */  0x20, 0x31, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  10.    
                    /* 0FC0 */  0x33, 0x39, 0x20, 0x66, 0x66, 0x20, 0x61, 0x61,  // 39 ff aa
                    /* 0FC8 */  0x20, 0x35, 0x35, 0x20, 0x61, 0x35, 0x20, 0x30,  //  55 a5 0
                    /* 0FD0 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x30, 0x35,  // 0.    05
                    /* 0FD8 */  0x20, 0x31, 0x31, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  11.    
                    /* 0FE0 */  0x66, 0x66, 0x20, 0x37, 0x38, 0x0A, 0x20, 0x20,  // ff 78.  
                    /* 0FE8 */  0x20, 0x20, 0x30, 0x35, 0x20, 0x32, 0x39, 0x0A,  //   05 29.
                    /* 0FF0 */  0x20, 0x20, 0x20, 0x20, 0x66, 0x66, 0x20, 0x37,  //     ff 7
                    /* 0FF8 */  0x38, 0x0A, 0x3C, 0x2F, 0x44, 0x53, 0x49, 0x49,  // 8.</DSII
                    /* 1000 */  0x6E, 0x69, 0x74, 0x53, 0x65, 0x71, 0x75, 0x65,  // nitSeque
                    /* 1008 */  0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x3C, 0x44, 0x53,  // nce>.<DS
                    /* 1010 */  0x49, 0x53, 0x74, 0x61, 0x74, 0x75, 0x73, 0x53,  // IStatusS
                    /* 1018 */  0x65, 0x71, 0x75, 0x65, 0x6E, 0x63, 0x65, 0x3E,  // equence>
                    /* 1020 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x30, 0x36, 0x20,  // .    06 
                    /* 1028 */  0x30, 0x61, 0x20, 0x39, 0x63, 0x0A, 0x3C, 0x2F,  // 0a 9c.</
                    /* 1030 */  0x44, 0x53, 0x49, 0x53, 0x74, 0x61, 0x74, 0x75,  // DSIStatu
                    /* 1038 */  0x73, 0x53, 0x65, 0x71, 0x75, 0x65, 0x6E, 0x63,  // sSequenc
                    /* 1040 */  0x65, 0x3E, 0x0A, 0x3C, 0x44, 0x53, 0x49, 0x54,  // e>.<DSIT
                    /* 1048 */  0x65, 0x72, 0x6D, 0x53, 0x65, 0x71, 0x75, 0x65,  // ermSeque
                    /* 1050 */  0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // nce>.   
                    /* 1058 */  0x20, 0x30, 0x35, 0x20, 0x32, 0x38, 0x20, 0x30,  //  05 28 0
                    /* 1060 */  0x30, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x46, 0x46,  // 0.    FF
                    /* 1068 */  0x20, 0x32, 0x30, 0x0A, 0x20, 0x20, 0x20, 0x20,  //  20.    
                    /* 1070 */  0x30, 0x35, 0x20, 0x31, 0x30, 0x20, 0x30, 0x30,  // 05 10 00
                    /* 1078 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x46, 0x46, 0x20,  // .    FF 
                    /* 1080 */  0x38, 0x30, 0x0A, 0x3C, 0x2F, 0x44, 0x53, 0x49,  // 80.</DSI
                    /* 1088 */  0x54, 0x65, 0x72, 0x6D, 0x53, 0x65, 0x71, 0x75,  // TermSequ
                    /* 1090 */  0x65, 0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x3C, 0x47,  // ence>.<G
                    /* 1098 */  0x72, 0x6F, 0x75, 0x70, 0x20, 0x69, 0x64, 0x3D,  // roup id=
                    /* 10A0 */  0x27, 0x43, 0x6F, 0x6E, 0x6E, 0x65, 0x63, 0x74,  // 'Connect
                    /* 10A8 */  0x69, 0x6F, 0x6E, 0x20, 0x43, 0x6F, 0x6E, 0x66,  // ion Conf
                    /* 10B0 */  0x69, 0x67, 0x75, 0x72, 0x61, 0x74, 0x69, 0x6F,  // iguratio
                    /* 10B8 */  0x6E, 0x27, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // n'>.    
                    /* 10C0 */  0x3C, 0x44, 0x69, 0x73, 0x70, 0x6C, 0x61, 0x79,  // <Display
                    /* 10C8 */  0x31, 0x52, 0x65, 0x73, 0x65, 0x74, 0x31, 0x49,  // 1Reset1I
                    /* 10D0 */  0x6E, 0x66, 0x6F, 0x3E, 0x44, 0x53, 0x49, 0x5F,  // nfo>DSI_
                    /* 10D8 */  0x50, 0x41, 0x4E, 0x45, 0x4C, 0x5F, 0x52, 0x45,  // PANEL_RE
                    /* 10E0 */  0x53, 0x45, 0x54, 0x2C, 0x20, 0x30, 0x2C, 0x20,  // SET, 0, 
                    /* 10E8 */  0x33, 0x30, 0x3C, 0x2F, 0x44, 0x69, 0x73, 0x70,  // 30</Disp
                    /* 10F0 */  0x6C, 0x61, 0x79, 0x31, 0x52, 0x65, 0x73, 0x65,  // lay1Rese
                    /* 10F8 */  0x74, 0x31, 0x49, 0x6E, 0x66, 0x6F, 0x3E, 0x0A,  // t1Info>.
                    /* 1100 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x44, 0x69, 0x73,  //     <Dis
                    /* 1108 */  0x70, 0x6C, 0x61, 0x79, 0x31, 0x50, 0x6F, 0x77,  // play1Pow
                    /* 1110 */  0x65, 0x72, 0x31, 0x49, 0x6E, 0x66, 0x6F, 0x3E,  // er1Info>
                    /* 1118 */  0x44, 0x53, 0x49, 0x5F, 0x50, 0x41, 0x4E, 0x45,  // DSI_PANE
                    /* 1120 */  0x4C, 0x5F, 0x4D, 0x4F, 0x44, 0x45, 0x5F, 0x53,  // L_MODE_S
                    /* 1128 */  0x45, 0x4C, 0x45, 0x43, 0x54, 0x2C, 0x20, 0x30,  // ELECT, 0
                    /* 1130 */  0x2C, 0x20, 0x30, 0x2C, 0x20, 0x30, 0x2C, 0x20,  // , 0, 0, 
                    /* 1138 */  0x30, 0x2C, 0x20, 0x54, 0x52, 0x55, 0x45, 0x3C,  // 0, TRUE<
                    /* 1140 */  0x2F, 0x44, 0x69, 0x73, 0x70, 0x6C, 0x61, 0x79,  // /Display
                    /* 1148 */  0x31, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x31, 0x49,  // 1Power1I
                    /* 1150 */  0x6E, 0x66, 0x6F, 0x3E, 0x0A, 0x3C, 0x2F, 0x47,  // nfo>.</G
                    /* 1158 */  0x72, 0x6F, 0x75, 0x70, 0x3E, 0x0A, 0x3C, 0x47,  // roup>.<G
                    /* 1160 */  0x72, 0x6F, 0x75, 0x70, 0x20, 0x69, 0x64, 0x3D,  // roup id=
                    /* 1168 */  0x27, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67,  // 'Backlig
                    /* 1170 */  0x68, 0x74, 0x20, 0x43, 0x6F, 0x6E, 0x66, 0x69,  // ht Confi
                    /* 1178 */  0x67, 0x75, 0x72, 0x61, 0x74, 0x69, 0x6F, 0x6E,  // guration
                    /* 1180 */  0x27, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // '>.    <
                    /* 1188 */  0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68,  // Backligh
                    /* 1190 */  0x74, 0x54, 0x79, 0x70, 0x65, 0x3E, 0x31, 0x3C,  // tType>1<
                    /* 1198 */  0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67,  // /Backlig
                    /* 11A0 */  0x68, 0x74, 0x54, 0x79, 0x70, 0x65, 0x3E, 0x0A,  // htType>.
                    /* 11A8 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x61, 0x63,  //     <Bac
                    /* 11B0 */  0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x50, 0x6D,  // klightPm
                    /* 11B8 */  0x69, 0x63, 0x43, 0x6F, 0x6E, 0x74, 0x72, 0x6F,  // icContro
                    /* 11C0 */  0x6C, 0x54, 0x79, 0x70, 0x65, 0x3E, 0x33, 0x3C,  // lType>3<
                    /* 11C8 */  0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67,  // /Backlig
                    /* 11D0 */  0x68, 0x74, 0x50, 0x6D, 0x69, 0x63, 0x43, 0x6F,  // htPmicCo
                    /* 11D8 */  0x6E, 0x74, 0x72, 0x6F, 0x6C, 0x54, 0x79, 0x70,  // ntrolTyp
                    /* 11E0 */  0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // e>.    <
                    /* 11E8 */  0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68,  // Backligh
                    /* 11F0 */  0x74, 0x50, 0x6D, 0x69, 0x63, 0x50, 0x57, 0x4D,  // tPmicPWM
                    /* 11F8 */  0x53, 0x69, 0x7A, 0x65, 0x69, 0x6E, 0x42, 0x69,  // SizeinBi
                    /* 1200 */  0x74, 0x73, 0x3E, 0x39, 0x3C, 0x2F, 0x42, 0x61,  // ts>9</Ba
                    /* 1208 */  0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x50,  // cklightP
                    /* 1210 */  0x6D, 0x69, 0x63, 0x50, 0x57, 0x4D, 0x53, 0x69,  // micPWMSi
                    /* 1218 */  0x7A, 0x65, 0x69, 0x6E, 0x42, 0x69, 0x74, 0x73,  // zeinBits
                    /* 1220 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x42,  // >.    <B
                    /* 1228 */  0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74,  // acklight
                    /* 1230 */  0x50, 0x4D, 0x49, 0x43, 0x42, 0x61, 0x6E, 0x6B,  // PMICBank
                    /* 1238 */  0x53, 0x65, 0x6C, 0x65, 0x63, 0x74, 0x3E, 0x33,  // Select>3
                    /* 1240 */  0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  // </Backli
                    /* 1248 */  0x67, 0x68, 0x74, 0x50, 0x4D, 0x49, 0x43, 0x42,  // ghtPMICB
                    /* 1250 */  0x61, 0x6E, 0x6B, 0x53, 0x65, 0x6C, 0x65, 0x63,  // ankSelec
                    /* 1258 */  0x74, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C,  // t>.    <
                    /* 1260 */  0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68,  // Backligh
                    /* 1268 */  0x74, 0x50, 0x4D, 0x49, 0x43, 0x50, 0x57, 0x4D,  // tPMICPWM
                    /* 1270 */  0x46, 0x72, 0x65, 0x71, 0x75, 0x65, 0x6E, 0x63,  // Frequenc
                    /* 1278 */  0x79, 0x3E, 0x38, 0x30, 0x30, 0x30, 0x30, 0x30,  // y>800000
                    /* 1280 */  0x3C, 0x2F, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  // </Backli
                    /* 1288 */  0x67, 0x68, 0x74, 0x50, 0x4D, 0x49, 0x43, 0x50,  // ghtPMICP
                    /* 1290 */  0x57, 0x4D, 0x46, 0x72, 0x65, 0x71, 0x75, 0x65,  // WMFreque
                    /* 1298 */  0x6E, 0x63, 0x79, 0x3E, 0x0A, 0x20, 0x20, 0x20,  // ncy>.   
                    /* 12A0 */  0x20, 0x3C, 0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69,  //  <Backli
                    /* 12A8 */  0x67, 0x68, 0x74, 0x53, 0x74, 0x65, 0x70, 0x73,  // ghtSteps
                    /* 12B0 */  0x3E, 0x31, 0x30, 0x30, 0x3C, 0x2F, 0x42, 0x61,  // >100</Ba
                    /* 12B8 */  0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x53,  // cklightS
                    /* 12C0 */  0x74, 0x65, 0x70, 0x73, 0x3E, 0x0A, 0x20, 0x20,  // teps>.  
                    /* 12C8 */  0x20, 0x20, 0x3C, 0x42, 0x61, 0x63, 0x6B, 0x6C,  //   <Backl
                    /* 12D0 */  0x69, 0x67, 0x68, 0x74, 0x44, 0x65, 0x66, 0x61,  // ightDefa
                    /* 12D8 */  0x75, 0x6C, 0x74, 0x3E, 0x38, 0x30, 0x3C, 0x2F,  // ult>80</
                    /* 12E0 */  0x42, 0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68,  // Backligh
                    /* 12E8 */  0x74, 0x44, 0x65, 0x66, 0x61, 0x75, 0x6C, 0x74,  // tDefault
                    /* 12F0 */  0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x42,  // >.    <B
                    /* 12F8 */  0x61, 0x63, 0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74,  // acklight
                    /* 1300 */  0x4C, 0x6F, 0x77, 0x50, 0x6F, 0x77, 0x65, 0x72,  // LowPower
                    /* 1308 */  0x3E, 0x34, 0x30, 0x3C, 0x2F, 0x42, 0x61, 0x63,  // >40</Bac
                    /* 1310 */  0x6B, 0x6C, 0x69, 0x67, 0x68, 0x74, 0x4C, 0x6F,  // klightLo
                    /* 1318 */  0x77, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x3E, 0x0A,  // wPower>.
                    /* 1320 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x50, 0x4D, 0x49,  //     <PMI
                    /* 1328 */  0x50, 0x6F, 0x77, 0x65, 0x72, 0x50, 0x6D, 0x69,  // PowerPmi
                    /* 1330 */  0x63, 0x4E, 0x75, 0x6D, 0x3E, 0x32, 0x3C, 0x2F,  // cNum>2</
                    /* 1338 */  0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77, 0x65, 0x72,  // PMIPower
                    /* 1340 */  0x50, 0x6D, 0x69, 0x63, 0x4E, 0x75, 0x6D, 0x3E,  // PmicNum>
                    /* 1348 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x50, 0x4D,  // .    <PM
                    /* 1350 */  0x49, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x50, 0x6D,  // IPowerPm
                    /* 1358 */  0x69, 0x63, 0x4D, 0x6F, 0x64, 0x65, 0x6C, 0x3E,  // icModel>
                    /* 1360 */  0x30, 0x78, 0x32, 0x46, 0x3C, 0x2F, 0x50, 0x4D,  // 0x2F</PM
                    /* 1368 */  0x49, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x50, 0x6D,  // IPowerPm
                    /* 1370 */  0x69, 0x63, 0x4D, 0x6F, 0x64, 0x65, 0x6C, 0x3E,  // icModel>
                    /* 1378 */  0x0A, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x50, 0x4D,  // .    <PM
                    /* 1380 */  0x49, 0x50, 0x6F, 0x77, 0x65, 0x72, 0x43, 0x6F,  // IPowerCo
                    /* 1388 */  0x6E, 0x66, 0x69, 0x67, 0x3E, 0x31, 0x3C, 0x2F,  // nfig>1</
                    /* 1390 */  0x50, 0x4D, 0x49, 0x50, 0x6F, 0x77, 0x65, 0x72,  // PMIPower
                    /* 1398 */  0x43, 0x6F, 0x6E, 0x66, 0x69, 0x67, 0x3E, 0x0A,  // Config>.
                    /* 13A0 */  0x20, 0x20, 0x20, 0x20, 0x3C, 0x42, 0x72, 0x69,  //     <Bri
                    /* 13A8 */  0x67, 0x68, 0x74, 0x6E, 0x65, 0x73, 0x73, 0x4D,  // ghtnessM
                    /* 13B0 */  0x69, 0x6E, 0x4C, 0x75, 0x6D, 0x69, 0x6E, 0x61,  // inLumina
                    /* 13B8 */  0x6E, 0x63, 0x65, 0x3E, 0x30, 0x3C, 0x2F, 0x42,  // nce>0</B
                    /* 13C0 */  0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65, 0x73,  // rightnes
                    /* 13C8 */  0x73, 0x4D, 0x69, 0x6E, 0x4C, 0x75, 0x6D, 0x69,  // sMinLumi
                    /* 13D0 */  0x6E, 0x61, 0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x20,  // nance>. 
                    /* 13D8 */  0x20, 0x20, 0x20, 0x3C, 0x42, 0x72, 0x69, 0x67,  //    <Brig
                    /* 13E0 */  0x68, 0x74, 0x6E, 0x65, 0x73, 0x73, 0x4D, 0x61,  // htnessMa
                    /* 13E8 */  0x78, 0x4C, 0x75, 0x6D, 0x69, 0x6E, 0x61, 0x6E,  // xLuminan
                    /* 13F0 */  0x63, 0x65, 0x3E, 0x30, 0x3C, 0x2F, 0x42, 0x72,  // ce>0</Br
                    /* 13F8 */  0x69, 0x67, 0x68, 0x74, 0x6E, 0x65, 0x73, 0x73,  // ightness
                    /* 1400 */  0x4D, 0x61, 0x78, 0x4C, 0x75, 0x6D, 0x69, 0x6E,  // MaxLumin
                    /* 1408 */  0x61, 0x6E, 0x63, 0x65, 0x3E, 0x0A, 0x09, 0x3C,  // ance>..<
                    /* 1410 */  0x42, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65,  // Brightne
                    /* 1418 */  0x73, 0x73, 0x52, 0x61, 0x6E, 0x67, 0x65, 0x4C,  // ssRangeL
                    /* 1420 */  0x65, 0x76, 0x65, 0x6C, 0x30, 0x3E, 0x35, 0x30,  // evel0>50
                    /* 1428 */  0x30, 0x20, 0x33, 0x31, 0x39, 0x35, 0x30, 0x30,  // 0 319500
                    /* 1430 */  0x20, 0x35, 0x30, 0x30, 0x20, 0x32, 0x3C, 0x2F,  //  500 2</
                    /* 1438 */  0x42, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65,  // Brightne
                    /* 1440 */  0x73, 0x73, 0x52, 0x61, 0x6E, 0x67, 0x65, 0x4C,  // ssRangeL
                    /* 1448 */  0x65, 0x76, 0x65, 0x6C, 0x30, 0x3E, 0x0A, 0x20,  // evel0>. 
                    /* 1450 */  0x20, 0x20, 0x20, 0x3C, 0x41, 0x64, 0x61, 0x70,  //    <Adap
                    /* 1458 */  0x74, 0x69, 0x76, 0x65, 0x42, 0x72, 0x69, 0x67,  // tiveBrig
                    /* 1460 */  0x68, 0x74, 0x6E, 0x65, 0x73, 0x73, 0x46, 0x65,  // htnessFe
                    /* 1468 */  0x61, 0x74, 0x75, 0x72, 0x65, 0x3E, 0x31, 0x3C,  // ature>1<
                    /* 1470 */  0x2F, 0x41, 0x64, 0x61, 0x70, 0x74, 0x69, 0x76,  // /Adaptiv
                    /* 1478 */  0x65, 0x42, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E,  // eBrightn
                    /* 1480 */  0x65, 0x73, 0x73, 0x46, 0x65, 0x61, 0x74, 0x75,  // essFeatu
                    /* 1488 */  0x72, 0x65, 0x3E, 0x0A, 0x20, 0x20, 0x20, 0x20,  // re>.    
                    /* 1490 */  0x3C, 0x43, 0x41, 0x42, 0x4C, 0x45, 0x6E, 0x61,  // <CABLEna
                    /* 1498 */  0x62, 0x6C, 0x65, 0x3E, 0x54, 0x72, 0x75, 0x65,  // ble>True
                    /* 14A0 */  0x3C, 0x2F, 0x43, 0x41, 0x42, 0x4C, 0x45, 0x6E,  // </CABLEn
                    /* 14A8 */  0x61, 0x62, 0x6C, 0x65, 0x3E, 0x0A, 0x3C, 0x2F,  // able>.</
                    /* 14B0 */  0x47, 0x72, 0x6F, 0x75, 0x70, 0x3E, 0x00         // Group>.
                })
                While (One)
                {
                    Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    _T_0 = ToInteger (Arg2)
                    If ((_T_0 == 0x8056))
                    {
                        Local2 = PCFG /* \_SB_.GPU0._ROM.PCFG */
                    }
                    ElseIf ((_T_0 == 0x8000))
                    {
                        Local2 = PCF1 /* \_SB_.GPU0._ROM.PCF1 */
                    }
                    Else
                    {
                        Local2 = PCFG /* \_SB_.GPU0._ROM.PCFG */
                    }

                    Break
                }

                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0._ROM.RBUF */
            }

            Method (PGRT, 2, NotSerialized)
            {
                Name (RBUF, Buffer (One)
                {
                     0x00                                             // .
                })
                Return (RBUF) /* \_SB_.GPU0.PGRT.RBUF */
            }

            Method (DEVT, 1, NotSerialized)
            {
                Notify (\_SB.GPU0, Arg0)
            }

            Method (BLCP, 2, NotSerialized)
            {
                Name (RBUF, Buffer (0x0100){})
                Return (RBUF) /* \_SB_.GPU0.BLCP.RBUF */
            }

            Method (PBRT, 2, NotSerialized)
            {
                Name (RBUF, Buffer (One)
                {
                     0x00                                             // .
                })
                Return (RBUF) /* \_SB_.GPU0.PBRT.RBUF */
            }

            Method (ROE1, 3, NotSerialized)
            {
                Name (PCFG, Buffer (0x45)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x44, 0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65,  // DPEnable
                    /* 0030 */  0x53, 0x53, 0x43, 0x3E, 0x31, 0x3C, 0x2F, 0x44,  // SSC>1</D
                    /* 0038 */  0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x53,  // PEnableS
                    /* 0040 */  0x53, 0x43, 0x3E, 0x0A, 0x00                     // SC>..
                })
                Local2 = PCFG /* \_SB_.GPU0.ROE1.PCFG */
                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0.ROE1.RBUF */
            }

            Method (ROE2, 3, NotSerialized)
            {
                Name (PCFG, Buffer (0x45)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x44, 0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65,  // DPEnable
                    /* 0030 */  0x53, 0x53, 0x43, 0x3E, 0x31, 0x3C, 0x2F, 0x44,  // SSC>1</D
                    /* 0038 */  0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x53,  // PEnableS
                    /* 0040 */  0x53, 0x43, 0x3E, 0x0A, 0x00                     // SC>..
                })
                Local2 = PCFG /* \_SB_.GPU0.ROE2.PCFG */
                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0.ROE2.RBUF */
            }

            Method (ROE3, 3, NotSerialized)
            {
                Name (PCFG, Buffer (0x45)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x44, 0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65,  // DPEnable
                    /* 0030 */  0x53, 0x53, 0x43, 0x3E, 0x31, 0x3C, 0x2F, 0x44,  // SSC>1</D
                    /* 0038 */  0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x53,  // PEnableS
                    /* 0040 */  0x53, 0x43, 0x3E, 0x0A, 0x00                     // SC>..
                })
                Local2 = PCFG /* \_SB_.GPU0.ROE3.PCFG */
                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0.ROE3.RBUF */
            }

            Method (ROE4, 3, NotSerialized)
            {
                Name (PCFG, Buffer (0x45)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x44, 0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65,  // DPEnable
                    /* 0030 */  0x53, 0x53, 0x43, 0x3E, 0x31, 0x3C, 0x2F, 0x44,  // SSC>1</D
                    /* 0038 */  0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x53,  // PEnableS
                    /* 0040 */  0x53, 0x43, 0x3E, 0x0A, 0x00                     // SC>..
                })
                Local2 = PCFG /* \_SB_.GPU0.ROE4.PCFG */
                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0.ROE4.RBUF */
            }

            Method (ROE5, 3, NotSerialized)
            {
                Name (PCFG, Buffer (0x45)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x44, 0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65,  // DPEnable
                    /* 0030 */  0x53, 0x53, 0x43, 0x3E, 0x31, 0x3C, 0x2F, 0x44,  // SSC>1</D
                    /* 0038 */  0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x53,  // PEnableS
                    /* 0040 */  0x53, 0x43, 0x3E, 0x0A, 0x00                     // SC>..
                })
                Local2 = PCFG /* \_SB_.GPU0.ROE5.PCFG */
                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0.ROE5.RBUF */
            }

            Method (ROE6, 3, NotSerialized)
            {
                Name (PCFG, Buffer (0x45)
                {
                    /* 0000 */  0x3C, 0x3F, 0x78, 0x6D, 0x6C, 0x20, 0x76, 0x65,  // <?xml ve
                    /* 0008 */  0x72, 0x73, 0x69, 0x6F, 0x6E, 0x3D, 0x27, 0x31,  // rsion='1
                    /* 0010 */  0x2E, 0x30, 0x27, 0x20, 0x65, 0x6E, 0x63, 0x6F,  // .0' enco
                    /* 0018 */  0x64, 0x69, 0x6E, 0x67, 0x3D, 0x27, 0x75, 0x74,  // ding='ut
                    /* 0020 */  0x66, 0x2D, 0x38, 0x27, 0x3F, 0x3E, 0x0A, 0x3C,  // f-8'?>.<
                    /* 0028 */  0x44, 0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65,  // DPEnable
                    /* 0030 */  0x53, 0x53, 0x43, 0x3E, 0x31, 0x3C, 0x2F, 0x44,  // SSC>1</D
                    /* 0038 */  0x50, 0x45, 0x6E, 0x61, 0x62, 0x6C, 0x65, 0x53,  // PEnableS
                    /* 0040 */  0x53, 0x43, 0x3E, 0x0A, 0x00                     // SC>..
                })
                Local2 = PCFG /* \_SB_.GPU0.ROE6.PCFG */
                If ((Arg0 >= SizeOf (Local2)))
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
                Else
                {
                    Local0 = Arg0
                }

                If ((Arg1 > 0x1000))
                {
                    Local1 = 0x1000
                }
                Else
                {
                    Local1 = Arg1
                }

                If (((Local0 + Local1) > SizeOf (Local2)))
                {
                    Local1 = (SizeOf (Local2) - Local0)
                }

                CreateField (Local2, (0x08 * Local0), (0x08 * Local1), RBUF)
                Return (RBUF) /* \_SB_.GPU0.ROE6.RBUF */
            }

            Name (_DOD, Package (0x01)  // _DOD: Display Output Devices
            {
                0x00024321
            })
            Device (AVS0)
            {
                Name (_ADR, 0x00024321)  // _ADR: Address
                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    Name (RBUF, Buffer (0x02)
                    {
                         0x79, 0x00                                       // y.
                    })
                    Return (RBUF) /* \_SB_.GPU0.AVS0._CRS.RBUF */
                }

                Name (_DEP, Package (0x03)  // _DEP: Dependencies
                {
                    \_SB.MMU0, 
                    \_SB.IMM0, 
                    \_SB.VFE0
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_HRV, 0, NotSerialized)  // _HRV: Hardware Revision
            {
                Name (RESU, Zero)
                Name (TIER, Zero)
                Name (DREV, Zero)
                Name (FAMI, Zero)
                TIER = (\_SB.SIDT & 0x0F)
                DREV = ((\_SB.SJTG >> 0x1C) & 0x0F)
                DREV <<= 0x04
                If ((\_SB.SDFE == 0x69))
                {
                    FAMI = (0x03 << 0x0B)
                }

                RESU |= TIER /* \_SB_.GPU0._HRV.RESU */
                RESU |= DREV /* \_SB_.GPU0._HRV.RESU */
                RESU |= FAMI /* \_SB_.GPU0._HRV.RESU */
                Return (RESU) /* \_SB_.GPU0._HRV.RESU */
            }

            Method (CHDV, 0, NotSerialized)
            {
                Name (CHIF, Package (0x02)
                {
                    One, 
                    Package (0x07)
                    {
                        "CHILDDEV", 
                        Zero, 
                        0x00024321, 
                        "QCOM_AVStream_8350", 
                        Zero, 
                        "Qualcomm Camera AVStream Mini Driver", 
                        Package (0x04)
                        {
                            "COMPATIBLEIDS", 
                            0x02, 
                            "VEN_QCOM&DEV__AVSTREAM", 
                            "QCOM_AVSTREAM"
                        }
                    }
                })
                Return (CHIF) /* \_SB_.GPU0.CHDV.CHIF */
            }

            Method (_LID, 0, NotSerialized)  // _LID: Lid Status
            {
                Return (One)
            }
        }

        Device (SCM0)
        {
            Name (_HID, "QCOM05DD")  // _HID: Hardware ID
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
        }

        Device (TLOG)
        {
            Name (_HID, "QCOM1AE4")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
        }

        Device (TREE)
        {
            Name (_HID, "QCOM05DE")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveLow, Exclusive, PullUp, 0x0000,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0088
                        }
                    Memory32Fixed (ReadWrite,
                        0xDEADBEEF,         // Address Base
                        0xBEEFDEAD,         // Address Length
                        _Y00)
                })
                CreateDWordField (RBUF, \_SB.TREE._CRS._Y00._BAS, TGCA)  // _BAS: Base Address
                CreateDWordField (RBUF, \_SB.TREE._CRS._Y00._LEN, TGCL)  // _LEN: Length
                TGCA = \_SB.TCMA
                TGCL = \_SB.TCML
                Return (RBUF) /* \_SB_.TREE._CRS.RBUF */
            }
        }

        Device (SPMI)
        {
            Name (_HID, "QCOM1A0B")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_CID, "PNP0CA2")  // _CID: Compatible ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0C400000,         // Address Base
                        0x02800000,         // Address Length
                        )
                })
                Return (RBUF) /* \_SB_.SPMI._CRS.RBUF */
            }

            Method (CONF, 0, NotSerialized)
            {
                Name (XBUF, Buffer (0x1A)
                {
                    /* 0000 */  0x00, 0x01, 0x01, 0x01, 0xFF, 0x00, 0x02, 0x00,  // ........
                    /* 0008 */  0x0A, 0x07, 0x04, 0x07, 0x01, 0xFF, 0x10, 0x01,  // ........
                    /* 0010 */  0x00, 0x01, 0x0C, 0x40, 0x00, 0x00, 0x02, 0x80,  // ...@....
                    /* 0018 */  0x00, 0x00                                       // ..
                })
                Return (XBUF) /* \_SB_.SPMI.CONF.XBUF */
            }
        }

        Device (GIO0)
        {
            Name (_HID, "QCOM1A0C")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0F100000,         // Address Base
                        0x00300000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000F0,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000F0,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000F0,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000F0,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000002FC,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x00000228,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002A7,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002AD,
                    }
                })
                Return (RBUF) /* \_SB_.GIO0._CRS.RBUF */
            }

            Method (OFNI, 0, NotSerialized)
            {
                Name (RBUF, Buffer (0x02)
                {
                     0xCB, 0x00                                       // ..
                })
                Return (RBUF) /* \_SB_.GIO0.OFNI.RBUF */
            }

            Name (GABL, Zero)
            Method (_REG, 2, NotSerialized)  // _REG: Region Availability
            {
                If ((Arg0 == 0x08))
                {
                    GABL = Arg1
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == ToUUID ("4f248f40-d5e2-499f-834c-27758ea1cd3f") /* GPIO Controller */))
                {
                    While (One)
                    {
                        Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        _T_0 = Arg2
                        If ((_T_0 == Zero))
                        {
                            Return (Buffer (One)
                            {
                                 0x03                                             // .
                            })
                        }
                        ElseIf ((_T_0 == One))
                        {
                            Return (Package (0x01)
                            {
                                0x0140
                            })
                        }
                        Else
                        {
                            BreakPoint
                        }

                        Break
                    }
                }
                Else
                {
                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
            }
        }

        Device (IPCC)
        {
            Name (_HID, "QCOM1AC2")  // _HID: Hardware ID
            Name (_CID, "QCOMFFE2")  // _CID: Compatible ID
            Name (_UID, Zero)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000105,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000106,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000107,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002EA,
                    }
                })
                Return (RBUF) /* \_SB_.IPCC._CRS.RBUF */
            }
        }

        Device (WWAN)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PM01
            })
            Name (_HID, "QCOM1ADA")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Alias (\_SB.PSUB, _SUB)
            Name (GMDM, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.PM01", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x014D
                    }
            })
            Name (GMDR, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.PM01", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0150
                    }
            })
            Name (GMDS, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.PM01", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0148
                    }
            })
            Scope (\_SB.PM01)
            {
                OperationRegion (MPON, GeneralPurposeIo, Zero, One)
                OperationRegion (PMDR, GeneralPurposeIo, Zero, One)
                OperationRegion (PMON, GeneralPurposeIo, Zero, One)
            }

            Field (\_SB.PM01.MPON, ByteAcc, NoLock, Preserve)
            {
                Connection (\_SB.WWAN.GMDM), 
                MPON,   1
            }

            Field (\_SB.PM01.PMDR, ByteAcc, NoLock, Preserve)
            {
                Connection (\_SB.WWAN.GMDR), 
                PMDR,   1
            }

            Field (\_SB.PM01.PMON, ByteAcc, NoLock, Preserve)
            {
                Connection (\_SB.WWAN.GMDS), 
                PMON,   1
            }

            Method (_MFF, 0, NotSerialized)
            {
                Debug = "Start SDX55 Power OFF Sequence"
                If (((\_SB.PSUB == "MTP08350") || (\_SB.PSUB == "QRD08350")))
                {
                    Sleep (0x0190)
                    Debug = "Set GPIO 6D to Low"
                    \_SB.WWAN.MPON = Zero
                    Debug = "Set GPIO 9D to Low"
                    \_SB.WWAN.PMDR = Zero
                    Sleep (0xD7)
                    Debug = "Set GPIO 1D to Low"
                    \_SB.WWAN.PMON = Zero
                    Sleep (One)
                }
                Else
                {
                    Debug = "SDX55 Power OFF not supported for this form factor"
                }

                Debug = "End SDX55 Power OFF Sequence"
            }

            Method (_MNF, 0, NotSerialized)
            {
                Debug = "Start SDX55 Power OFF Sequence with 3000 ms delay."
                If (((\_SB.PSUB == "MTP08350") || (\_SB.PSUB == "QRD08350")))
                {
                    Sleep (0x0190)
                    Debug = "Set GPIO 6D to Low"
                    \_SB.WWAN.MPON = Zero
                    Debug = "Set GPIO 9D to Low"
                    \_SB.WWAN.PMDR = Zero
                    Sleep (0x0BB8)
                    Debug = "Set GPIO 1D to Low"
                    \_SB.WWAN.PMON = Zero
                    Sleep (One)
                }
                Else
                {
                    Debug = "SDX55 Power OFF not supported for this form factor"
                }

                Debug = "End SDX55 Power OFF Sequence"
            }
        }

        Scope (\_SB.WWAN)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((PRP1 == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Device (PCI0)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_SEG, Zero)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Name (_PRT, Package (0x04)  // _PRT: PCI Routing Table
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    Zero, 
                    0xB5
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    Zero, 
                    0xB6
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    Zero, 
                    0xB7
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    Zero, 
                    0xB8
                }
            })
            Method (_CCA, 0, NotSerialized)  // _CCA: Cache Coherency Attribute
            {
                Return (One)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((PRP0 == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_PSC, 0, NotSerialized)  // _PSC: Power State Current
            {
                Return (Zero)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x60300000,         // Address Base
                        0x01D00000,         // Address Length
                        )
                    WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x0001,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0002,             // Length
                        ,, )
                })
                Return (RBUF) /* \_SB_.PCI0._CRS.RBUF */
            }

            Name (SUPP, Zero)
            Name (CTRL, Zero)
            Method (_DSW, 3, NotSerialized)  // _DSW: Device Sleep Wake
            {
            }

            Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
            {
                If ((Arg0 == ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */))
                {
                    CreateDWordField (Arg3, Zero, CDW1)
                    CreateDWordField (Arg3, 0x04, CDW2)
                    CreateDWordField (Arg3, 0x08, CDW3)
                    SUPP = CDW2 /* \_SB_.PCI0._OSC.CDW2 */
                    CTRL = CDW3 /* \_SB_.PCI0._OSC.CDW3 */
                    If (((SUPP & 0x16) != 0x16))
                    {
                        CTRL &= 0x1E
                    }

                    CTRL &= 0x15
                    If ((Arg1 != One))
                    {
                        CDW1 |= 0x08
                    }

                    If ((CDW3 != CTRL))
                    {
                        CDW1 |= 0x10
                    }

                    CDW3 = CTRL /* \_SB_.PCI0.CTRL */
                    Return (Arg3)
                }
                Else
                {
                    CDW1 |= 0x04
                    Return (Arg3)
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
                {
                    While (One)
                    {
                        Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        _T_0 = ToInteger (Arg2)
                        If ((_T_0 == Zero))
                        {
                            Return (Buffer (0x02)
                            {
                                 0xFF, 0x03                                       // ..
                            })
                        }
                        ElseIf ((_T_0 == One))
                        {
                            Return (Package (0x02)
                            {
                                Package (One)
                                {
                                    One
                                }, 

                                Package (0x03)
                                {
                                    Zero, 
                                    One, 
                                    One
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x02))
                        {
                            Return (Package (One)
                            {
                                Package (0x04)
                                {
                                    One, 
                                    0x03, 
                                    Zero, 
                                    0x07
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x03))
                        {
                            Return (Package (One)
                            {
                                Zero
                            })
                        }
                        ElseIf ((_T_0 == 0x04))
                        {
                            Return (Package (0x02)
                            {
                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (0x04)
                                {
                                    One, 
                                    0x03, 
                                    Zero, 
                                    0x07
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x05))
                        {
                            Return (Package (One)
                            {
                                One
                            })
                        }
                        ElseIf ((_T_0 == 0x06))
                        {
                            Return (Package (0x04)
                            {
                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (One)
                                {
                                    Zero
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x07))
                        {
                            Return (Package (One)
                            {
                                One
                            })
                        }
                        ElseIf ((_T_0 == 0x08))
                        {
                            Return (Package (One)
                            {
                                One
                            })
                        }
                        ElseIf ((_T_0 == 0x09))
                        {
                            Return (Package (0x05)
                            {
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                Zero, 
                                0xFFFFFFFF
                            })
                        }
                        Else
                        {
                        }

                        Break
                    }
                }
            }

            Name (_S0W, 0x04)  // _S0W: S0 Device Wake State
            Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
            {
                \_SB.P0RR
            })
            Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
            {
                \_SB.P0RR
            })
            Device (RP1)
            {
                Method (_ADR, 0, Serialized)  // _ADR: Address
                {
                    Return (Zero)
                }

                Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
                {
                    \_SB.R0RR
                })
                Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
                {
                    \_SB.R0RR
                })
                Name (_PRR, Package (0x01)  // _PRR: Power Resource for Reset
                {
                    \_SB.R0RR
                })
                Name (_S0W, 0x04)  // _S0W: S0 Device Wake State
                Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                {
                    ToUUID ("6211e2c0-58a3-4af3-90e1-927a4e0c55a4") /* Unknown UUID */, 
                    Package (0x01)
                    {
                        Package (0x02)
                        {
                            "HotPlugSupportInD3", 
                            One
                        }
                    }
                })
                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    Name (RBUF, ResourceTemplate ()
                    {
                        GpioInt (Edge, ActiveLow, ExclusiveAndWake, PullUp, 0x0000,
                            "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                            )
                            {   // Pin list
                                0x0060
                            }
                    })
                    Return (RBUF) /* \_SB_.PCI0.RP1_._CRS.RBUF */
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
                    {
                        While (One)
                        {
                            Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_0 = ToInteger (Arg2)
                            If ((_T_0 == Zero))
                            {
                                Return (Buffer (0x02)
                                {
                                     0x01, 0x03                                       // ..
                                })
                            }
                            ElseIf ((_T_0 == 0x08))
                            {
                                Return (Package (One)
                                {
                                    One
                                })
                            }
                            ElseIf ((_T_0 == 0x09))
                            {
                                Return (Package (0x05)
                                {
                                    0xFFFFFFFF, 
                                    0xFFFFFFFF, 
                                    0xFFFFFFFF, 
                                    Zero, 
                                    0xFFFFFFFF
                                })
                            }
                            Else
                            {
                            }

                            Break
                        }
                    }
                }
            }
        }

        PowerResource (P0RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R0RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (QPPX)
        {
            Name (_HID, "QCOM1A96")  // _HID: Hardware ID
            Name (_CID, "QCOMFFE4")  // _CID: Compatible ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x005E
                        }
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x01, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x0061
                        }
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x01, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x02, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x03, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x03, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                })
                Return (RBUF) /* \_SB_.QPPX._CRS.RBUF */
            }

            Method (_QPG, 0, Serialized)
            {
                Return (Package (0x07)
                {
                    One, 
                    One, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero, 
                    Zero
                })
            }

            Method (_HPX, 2, Serialized)  // _HPX: Hot Plug Parameter Extensions
            {
            }

            Method (_HPE, 2, Serialized)
            {
            }

            Name (GWLE, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0040
                    }
            })
            Scope (\_SB.GIO0)
            {
                OperationRegion (WLEN, GeneralPurposeIo, Zero, One)
            }

            Field (\_SB.GIO0.WLEN, ByteAcc, NoLock, Preserve)
            {
                Connection (\_SB.QPPX.GWLE), 
                WLEN,   1
            }

            Method (_RST, 1, Serialized)  // _RST: Device Reset
            {
                While (One)
                {
                    Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    _T_0 = ToInteger (Arg0)
                    If ((_T_0 == Zero))
                    {
                        \_SB.QPPX.WLEN = Zero
                        Sleep (0x05)
                        \_SB.QPPX.WLEN = One
                    }
                    ElseIf ((_T_0 == One))
                    {
                        Debug = "SDX not supported yet"
                    }
                    Else
                    {
                        Debug = "Invalid PCIe port number passed to QPPX reset helper"
                    }

                    Break
                }
            }
        }

        Device (PCI1)
        {
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX, 
                \_SB.WWAN
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_SEG, One)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Name (_PRT, Package (0x04)  // _PRT: PCI Routing Table
            {
                Package (0x04)
                {
                    0xFFFF, 
                    Zero, 
                    Zero, 
                    0x01D2
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    One, 
                    Zero, 
                    0x01D3
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x02, 
                    Zero, 
                    0x01D6
                }, 

                Package (0x04)
                {
                    0xFFFF, 
                    0x03, 
                    Zero, 
                    0x01D7
                }
            })
            Method (_CCA, 0, NotSerialized)  // _CCA: Cache Coherency Attribute
            {
                Return (One)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((PRP1 == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_PSC, 0, NotSerialized)  // _PSC: Power State Current
            {
                Return (Zero)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x40300000,         // Address Base
                        0x01D00000,         // Address Length
                        )
                    WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x0001,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0002,             // Length
                        ,, )
                })
                Return (RBUF) /* \_SB_.PCI1._CRS.RBUF */
            }

            Name (SUPP, Zero)
            Name (CTRL, Zero)
            Method (_DSW, 3, NotSerialized)  // _DSW: Device Sleep Wake
            {
            }

            Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
            {
                If ((Arg0 == ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */))
                {
                    CreateDWordField (Arg3, Zero, CDW1)
                    CreateDWordField (Arg3, 0x04, CDW2)
                    CreateDWordField (Arg3, 0x08, CDW3)
                    SUPP = CDW2 /* \_SB_.PCI1._OSC.CDW2 */
                    CTRL = CDW3 /* \_SB_.PCI1._OSC.CDW3 */
                    If (((SUPP & 0x16) != 0x16))
                    {
                        CTRL &= 0x1E
                    }

                    CTRL &= 0x15
                    If ((Arg1 != One))
                    {
                        CDW1 |= 0x08
                    }

                    If ((CDW3 != CTRL))
                    {
                        CDW1 |= 0x10
                    }

                    CDW3 = CTRL /* \_SB_.PCI1.CTRL */
                    Return (Arg3)
                }
                Else
                {
                    CDW1 |= 0x04
                    Return (Arg3)
                }
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
                {
                    While (One)
                    {
                        Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        _T_0 = ToInteger (Arg2)
                        If ((_T_0 == Zero))
                        {
                            Return (Buffer (0x02)
                            {
                                 0xFF, 0x03                                       // ..
                            })
                        }
                        ElseIf ((_T_0 == One))
                        {
                            Return (Package (0x02)
                            {
                                Package (One)
                                {
                                    One
                                }, 

                                Package (0x03)
                                {
                                    Zero, 
                                    One, 
                                    One
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x02))
                        {
                            Return (Package (One)
                            {
                                Package (0x04)
                                {
                                    One, 
                                    0x03, 
                                    Zero, 
                                    0x07
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x03))
                        {
                            Return (Package (One)
                            {
                                Zero
                            })
                        }
                        ElseIf ((_T_0 == 0x04))
                        {
                            Return (Package (0x02)
                            {
                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (0x04)
                                {
                                    One, 
                                    0x03, 
                                    Zero, 
                                    0x07
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x05))
                        {
                            Return (Package (One)
                            {
                                One
                            })
                        }
                        ElseIf ((_T_0 == 0x06))
                        {
                            Return (Package (0x04)
                            {
                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (One)
                                {
                                    Zero
                                }, 

                                Package (One)
                                {
                                    Zero
                                }
                            })
                        }
                        ElseIf ((_T_0 == 0x07))
                        {
                            Return (Package (One)
                            {
                                0x02
                            })
                        }
                        ElseIf ((_T_0 == 0x08))
                        {
                            Return (Package (One)
                            {
                                One
                            })
                        }
                        ElseIf ((_T_0 == 0x09))
                        {
                            Return (Package (0x05)
                            {
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                0xFFFFFFFF, 
                                Zero, 
                                0xFFFFFFFF
                            })
                        }
                        Else
                        {
                        }

                        Break
                    }
                }
            }

            Name (_S0W, 0x04)  // _S0W: S0 Device Wake State
            Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
            {
                \_SB.P1RR
            })
            Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
            {
                \_SB.P1RR
            })
            Device (RP1)
            {
                Method (_ADR, 0, Serialized)  // _ADR: Address
                {
                    Return (Zero)
                }

                Name (_PR0, Package (0x01)  // _PR0: Power Resources for D0
                {
                    \_SB.R1RR
                })
                Name (_PR3, Package (0x01)  // _PR3: Power Resources for D3hot
                {
                    \_SB.R1RR
                })
                Name (_PRR, Package (0x01)  // _PRR: Power Resource for Reset
                {
                    \_SB.R1RR
                })
                Name (_S0W, 0x04)  // _S0W: S0 Device Wake State
                Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
                {
                    ToUUID ("6211e2c0-58a3-4af3-90e1-927a4e0c55a4") /* Unknown UUID */, 
                    Package (0x01)
                    {
                        Package (0x02)
                        {
                            "HotPlugSupportInD3", 
                            One
                        }
                    }
                })
                Method (_DSW, 3, NotSerialized)  // _DSW: Device Sleep Wake
                {
                }

                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    Name (RBUF, ResourceTemplate ()
                    {
                        GpioInt (Edge, ActiveLow, ExclusiveAndWake, PullUp, 0x0000,
                            "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                            )
                            {   // Pin list
                                0x0063
                            }
                    })
                    Return (RBUF) /* \_SB_.PCI1.RP1_._CRS.RBUF */
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */))
                    {
                        While (One)
                        {
                            Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_0 = ToInteger (Arg2)
                            If ((_T_0 == Zero))
                            {
                                Return (Buffer (0x02)
                                {
                                     0x01, 0x03                                       // ..
                                })
                            }
                            ElseIf ((_T_0 == 0x08))
                            {
                                Return (Package (One)
                                {
                                    One
                                })
                            }
                            ElseIf ((_T_0 == 0x09))
                            {
                                Return (Package (0x05)
                                {
                                    0xFFFFFFFF, 
                                    0xFFFFFFFF, 
                                    0xFFFFFFFF, 
                                    Zero, 
                                    0xFFFFFFFF
                                })
                            }
                            Else
                            {
                            }

                            Break
                        }
                    }
                }
            }
        }

        PowerResource (P1RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R1RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (PCI2)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_SEG, 0x02)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        PowerResource (P2RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R2RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (PCI3)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, 0x03)  // _UID: Unique ID
            Name (_SEG, 0x03)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        PowerResource (P3RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R3RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (PCI4)
        {
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX, 
                \_SB.WWAN
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, 0x04)  // _UID: Unique ID
            Name (_SEG, 0x04)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        PowerResource (P4RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R4RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (PCI5)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, 0x05)  // _UID: Unique ID
            Name (_SEG, 0x05)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        PowerResource (P5RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R5RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (PCI6)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.QPPX
            })
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_UID, 0x06)  // _UID: Unique ID
            Name (_SEG, 0x06)  // _SEG: PCI Segment
            Name (_BBN, Zero)  // _BBN: BIOS Bus Number
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        PowerResource (P6RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }
        }

        PowerResource (R6RR, 0x05, 0x0000)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Method (_ON, 0, NotSerialized)  // _ON_: Power On
            {
            }

            Method (_OFF, 0, NotSerialized)  // _OFF: Power Off
            {
            }

            Method (_RST, 0, NotSerialized)  // _RST: Device Reset
            {
            }
        }

        Device (IPC0)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.GLNK
            })
            Name (_HID, "QCOM1A0D")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (GLNK)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.IPCC, 
                \_SB.RPEN
            })
            Name (_HID, "QCOM1A84")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
        }

        Device (ARPC)
        {
            Name (_DEP, Package (0x04)  // _DEP: Dependencies
            {
                \_SB.MMU0, 
                \_SB.GLNK, 
                \_SB.SCM0, 
                \_SB.IMM0
            })
            Name (_HID, "QCOM1A5C")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (ARPD)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.ADSP, 
                \_SB.ARPC
            })
            Name (_HID, "QCOM1A82")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (RFS0)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.IPC0
            })
            Name (_HID, "QCOM1A15")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x88888888,         // Address Base
                        0x99999999,         // Address Length
                        _Y01)
                    Memory32Fixed (ReadWrite,
                        0x11111111,         // Address Base
                        0x22222222,         // Address Length
                        _Y02)
                    Memory32Fixed (ReadWrite,
                        0x33333333,         // Address Base
                        0x44444444,         // Address Length
                        _Y03)
                })
                CreateDWordField (RBUF, \_SB.RFS0._CRS._Y01._BAS, RMTA)  // _BAS: Base Address
                CreateDWordField (RBUF, \_SB.RFS0._CRS._Y01._LEN, RMTL)  // _LEN: Length
                CreateDWordField (RBUF, \_SB.RFS0._CRS._Y02._BAS, RFMA)  // _BAS: Base Address
                CreateDWordField (RBUF, \_SB.RFS0._CRS._Y02._LEN, RFML)  // _LEN: Length
                CreateDWordField (RBUF, \_SB.RFS0._CRS._Y03._BAS, RFAA)  // _BAS: Base Address
                CreateDWordField (RBUF, \_SB.RFS0._CRS._Y03._LEN, RFAL)  // _LEN: Length
                RMTA = \_SB.RMTB
                RMTL = \_SB.RMTX
                RFMA = \_SB.RFMB
                RFML = \_SB.RFMS
                RFAA = \_SB.RFAB
                RFAL = \_SB.RFAS
                Return (RBUF) /* \_SB_.RFS0._CRS.RBUF */
            }
        }

        Scope (\_SB.RFS0)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (IPA)
        {
            Name (_DEP, Package (0x06)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.RPEN, 
                \_SB.TREE, 
                \_SB.MMU0, 
                \_SB.GLNK, 
                \_SB.IPC0
            })
            Name (_HID, "QCOM1A6A")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x01E40000,         // Address Base
                        0x00060000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002AE,
                    }
                    Memory32Fixed (ReadWrite,
                        0x01E00000,         // Address Base
                        0x00030000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001D0,
                    }
                })
            }

            Device (NTAD)
            {
                Name (_ADR, One)  // _ADR: Address
            }
        }

        Scope (\_SB.IPA)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (QDIG)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.GLNK
            })
            Name (_HID, "QCOM1A13")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (SSM)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.GLNK, 
                \_SB.TREE
            })
            Name (_HID, "QCOM1A14")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (SYSM)
        {
            Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
            Name (_UID, 0x00100000)  // _UID: Unique ID
            Name (_LPI, Package (0x04)  // _LPI: Low Power Idle States
            {
                Zero, 
                0x01000000, 
                One, 
                Package (0x0A)
                {
                    0x251C, 
                    0x1770, 
                    One, 
                    0x20, 
                    Zero, 
                    Zero, 
                    0xC300, 
                    ResourceTemplate ()
                    {
                        Register (SystemMemory, 
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    }, 

                    ResourceTemplate ()
                    {
                        Register (SystemMemory, 
                            0x00,               // Bit Width
                            0x00,               // Bit Offset
                            0x0000000000000000, // Address
                            ,)
                    }, 

                    "platform.DRIPS"
                }
            })
            Device (CLUS)
            {
                Name (_HID, "ACPI0010" /* Processor Container Device */)  // _HID: Hardware ID
                Name (_UID, 0x10)  // _UID: Unique ID
                Name (_LPI, Package (0x05)  // _LPI: Low Power Idle States
                {
                    Zero, 
                    0x01000000, 
                    0x02, 
                    Package (0x0A)
                    {
                        0x170C, 
                        0x0BB8, 
                        Zero, 
                        Zero, 
                        Zero, 
                        Zero, 
                        0x20, 
                        ResourceTemplate ()
                        {
                            Register (SystemMemory, 
                                0x00,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000000000, // Address
                                ,)
                        }, 

                        ResourceTemplate ()
                        {
                            Register (SystemMemory, 
                                0x00,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000000000, // Address
                                ,)
                        }, 

                        "L3Cluster.D2"
                    }, 

                    Package (0x0A)
                    {
                        0x1770, 
                        0x0CE4, 
                        One, 
                        Zero, 
                        Zero, 
                        One, 
                        0x40, 
                        ResourceTemplate ()
                        {
                            Register (SystemMemory, 
                                0x00,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000000000, // Address
                                ,)
                        }, 

                        ResourceTemplate ()
                        {
                            Register (SystemMemory, 
                                0x00,               // Bit Width
                                0x00,               // Bit Offset
                                0x0000000000000000, // Address
                                ,)
                        }, 

                        "L3Cluster.D4"
                    }
                })
                Device (CPU0)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, Zero)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold0.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold0.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F0A, 
                            0x035C, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold0.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x0F6E, 
                            0x038E, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold0.C4"
                        }
                    })
                }

                Device (CPU1)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, One)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold1.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold1.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F0A, 
                            0x035C, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold1.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x0F6E, 
                            0x038E, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold1.C4"
                        }
                    })
                }

                Device (CPU2)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, 0x02)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold2.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold2.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F0A, 
                            0x035C, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold2.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x0F6E, 
                            0x038E, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold2.C4"
                        }
                    })
                }

                Device (CPU3)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, 0x03)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold3.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold3.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F0A, 
                            0x035C, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold3.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x0F6E, 
                            0x038E, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoGold3.C4"
                        }
                    })
                }

                Device (CPU4)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, 0x04)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime0.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime0.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F96, 
                            0x03E8, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime0.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x118A, 
                            0x05DC, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime0.C4"
                        }
                    })
                }

                Device (CPU5)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, 0x05)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime1.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime1.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F96, 
                            0x03E8, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime1.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x118A, 
                            0x05DC, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime1.C4"
                        }
                    })
                }

                Device (CPU6)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, 0x06)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime2.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime2.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F96, 
                            0x03E8, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime2.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x118A, 
                            0x05DC, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime2.C4"
                        }
                    })
                }

                Device (CPU7)
                {
                    Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
                    Name (_UID, 0x07)  // _UID: Unique ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }

                    Name (_LPI, Package (0x07)  // _LPI: Low Power Idle States
                    {
                        Zero, 
                        Zero, 
                        0x04, 
                        Package (0x0A)
                        {
                            Zero, 
                            Zero, 
                            One, 
                            Zero, 
                            Zero, 
                            Zero, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x00000000FFFFFFFF, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime3.C1"
                        }, 

                        Package (0x0A)
                        {
                            0x0190, 
                            0x64, 
                            Zero, 
                            Zero, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000002, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime3.C2"
                        }, 

                        Package (0x0A)
                        {
                            0x0F96, 
                            0x03E8, 
                            One, 
                            One, 
                            Zero, 
                            One, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000003, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime3.C3"
                        }, 

                        Package (0x0A)
                        {
                            0x118A, 
                            0x05DC, 
                            One, 
                            One, 
                            Zero, 
                            0x02, 
                            ResourceTemplate ()
                            {
                                Register (FFixedHW, 
                                    0x20,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000040000004, // Address
                                    0x03,               // Access Size
                                    )
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            ResourceTemplate ()
                            {
                                Register (SystemMemory, 
                                    0x00,               // Bit Width
                                    0x00,               // Bit Offset
                                    0x0000000000000000, // Address
                                    ,)
                            }, 

                            "KryoPrime3.C4"
                        }
                    })
                }
            }
        }

        Device (GPS)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.GLNK
            })
            Name (_HID, "QCOM1A6C")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
        }

        Scope (\_SB.GPS)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (QGP0)
        {
            Name (_HID, "QCOM1A88")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00904000,         // Address Base
                        0x00050000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000117,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000118,
                    }
                })
                Return (RBUF) /* \_SB_.QGP0._CRS.RBUF */
            }
        }

        Device (QGP1)
        {
            Name (_HID, "QCOM1A88")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, One)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00A04000,         // Address Base
                        0x00050000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000013C,
                    }
                })
                Return (RBUF) /* \_SB_.QGP1._CRS.RBUF */
            }
        }

        Device (QGP2)
        {
            Name (_HID, "QCOM1A88")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x00804000,         // Address Base
                        0x00050000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000026D,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000270,
                    }
                })
                Return (RBUF) /* \_SB_.QGP2._CRS.RBUF */
            }
        }

        Device (CSEC)
        {
            Name (_HID, "QCOM1AA8")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (QWPP)
        {
            Name (_DEP, Package (0x01)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Name (_HID, "QCOM1A79")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x09000000,         // Address Base
                        0x00600000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x09680000,         // Address Base
                        0x00070000,         // Address Length
                        )
                })
            }
        }

        Device (NFCD)
        {
            Name (_HID, "NXP1001")  // _HID: Hardware ID
            Name (_CID, "ACPINXP1001")  // _CID: Compatible ID
            Alias (\_SB.PSUB, _SUB)
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                I2cSerialBusV2 (0x0028, ControllerInitiated, 0x000F4240,
                    AddressingMode7Bit, "\\_SB.IC18",
                    0x00, ResourceConsumer, , Exclusive,
                    )
                GpioInt (Level, ActiveHigh, Exclusive, PullDefault, 0x0000,
                    "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0057
                    }
            })
            Name (NFCS, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x003F
                    }
            })
            Name (NFCP, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x003E
                    }
            })
            Scope (GIO0)
            {
                OperationRegion (NFPO, GeneralPurposeIo, Zero, One)
            }

            Field (\_SB.GIO0.NFPO, ByteAcc, NoLock, Preserve)
            {
                Connection (\_SB.NFCD.NFCP), 
                MGPE,   1
            }

            Method (POON, 0, NotSerialized)
            {
                MGPE = One
            }

            Method (POOF, 0, NotSerialized)
            {
                MGPE = Zero
            }

            Name (NFCF, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionNone,
                    "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0056
                    }
            })
            Scope (GIO0)
            {
                OperationRegion (NFFO, GeneralPurposeIo, Zero, One)
            }

            Field (\_SB.GIO0.NFFO, ByteAcc, NoLock, Preserve)
            {
                Connection (\_SB.NFCD.NFCF), 
                MGFE,   1
            }

            Method (FWON, 0, NotSerialized)
            {
                MGFE = One
            }

            Method (FWOF, 0, NotSerialized)
            {
                MGFE = Zero
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Debug = "Method NFC _DSM begin"
                If ((Arg0 == ToUUID ("a2e7f6c4-9638-4485-9f12-6b4e20b60d63") /* Unknown UUID */))
                {
                    If ((Arg2 == Zero))
                    {
                        Debug = "Method NFC _DSM QUERY"
                        If ((Arg1 == One))
                        {
                            \_SB.NFCD.POOF ()
                            Sleep (0x14)
                            Return (Buffer (One)
                            {
                                 0x0F                                             // .
                            })
                        }
                    }

                    If ((Arg2 == 0x02))
                    {
                        Debug = "Method NFC _DSM SETPOWERMODE"
                        If ((Arg3 == One))
                        {
                            \_SB.NFCD.POON ()
                            Sleep (0x14)
                        }

                        If ((Arg3 == Zero))
                        {
                            \_SB.NFCD.POOF ()
                            Sleep (0x14)
                        }
                    }

                    If ((Arg2 == One))
                    {
                        Debug = "Method NFC _DSM SETFWMODE"
                        If ((Arg3 == One))
                        {
                            \_SB.NFCD.FWON ()
                            Sleep (0x14)
                            \_SB.NFCD.POOF ()
                            Sleep (0x14)
                            \_SB.NFCD.POON ()
                            Sleep (0x14)
                        }

                        If ((Arg3 == Zero))
                        {
                            \_SB.NFCD.FWOF ()
                            Sleep (0x14)
                            \_SB.NFCD.POOF ()
                            Sleep (0x14)
                            \_SB.NFCD.POON ()
                            Sleep (0x14)
                        }
                    }

                    If ((Arg2 == 0x03))
                    {
                        Debug = "Method NFC _DSM EEPROM Config"
                        Return (Buffer (0x13)
                        {
                            /* 0000 */  0x9C, 0x1F, 0x38, 0x19, 0xA8, 0xB9, 0x4B, 0xAB,  // ..8...K.
                            /* 0008 */  0xA1, 0xBA, 0xD0, 0x20, 0x76, 0x88, 0x2A, 0xE0,  // ... v.*.
                            /* 0010 */  0x03, 0x01, 0x11                                 // ...
                        })
                    }
                }
            }

            Name (PGID, Buffer (0x0A)
            {
                "\\_SB.NFCD"
            })
            Name (DBUF, Buffer (DBFL){})
            CreateByteField (DBUF, Zero, STAT)
            CreateByteField (DBUF, 0x02, DVAL)
            CreateField (DBUF, 0x18, 0xA0, DEID)
            Method (_S1D, 0, NotSerialized)  // _S1D: S1 Device State
            {
                Return (0x03)
            }

            Method (_S2D, 0, NotSerialized)  // _S2D: S2 Device State
            {
                Return (0x03)
            }

            Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
            {
                Return (0x03)
            }

            Method (_PS0, 0, NotSerialized)  // _PS0: Power State 0
            {
                DEID = Buffer (ESNL){}
                DVAL = Zero
                DEID = PGID /* \_SB_.NFCD.PGID */
                If (\_SB.ABD.AVBL)
                {
                    \_SB.PEP0.FLD0 = DBUF /* \_SB_.NFCD.DBUF */
                }
            }

            Method (_PS3, 0, NotSerialized)  // _PS3: Power State 3
            {
                DEID = Buffer (ESNL){}
                DVAL = 0x03
                DEID = PGID /* \_SB_.NFCD.PGID */
                If (\_SB.ABD.AVBL)
                {
                    \_SB.PEP0.FLD0 = DBUF /* \_SB_.NFCD.DBUF */
                }
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (SOCP)
        {
            Name (_HID, "QCOM1ADD")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Alias (\_SB.STOR, STOR)
        }

        Device (QDSS)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.MMU0
            })
            Name (_HID, "QCOM1A56")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000012E,
                    }
                    Memory32Fixed (ReadWrite,
                        0x06000000,         // Address Base
                        0x0004A000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x16000000,         // Address Base
                        0x01000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x07000000,         // Address Base
                        0x00A00000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000044,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000041,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000042,
                    }
                })
            }
        }

        Device (QCSP)
        {
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.GLNK, 
                \_SB.SOCP, 
                \_SB.SPSS
            })
            Name (_HID, "QCOM1A87")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Alias (\_SB.STOR, STOR)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (QCDB)
        {
            Name (_HID, "QCOM1ADE")  // _HID: Hardware ID
            Method (_SUB, 0, NotSerialized)  // _SUB: Subsystem ID
            {
                Return ("AGN00000")
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (SERB)
        {
            Name (_HID, "QCOM05B2")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (RMNT)
        {
            Name (_HID, "QCOM1A95")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (MBRG)
        {
            Name (_HID, "QCOM1A07")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (RMAT)
        {
            Name (_HID, "QCOM1A08")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (DPLB)
        {
            Name (_HID, "QCOM1A70")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (CCID)
        {
            Name (_HID, "QCOM1AA2")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (DSBY)
        {
            Name (_HID, "QCOM1ACD")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Scope (\_SB.SERB)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((((\_SB.PLST == Zero) || (\_SB.PLST == 0x02)) || (\_SB.PLST == 0x03)))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Scope (\_SB.RMNT)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Scope (\_SB.MBRG)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Scope (\_SB.RMAT)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Scope (\_SB.DPLB)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (SSVC)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.IPC0, 
                \_SB.QDIG
            })
            Name (_HID, "QCOM1ADB")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_CID, "ACPIQCOM1ADB")  // _CID: Compatible ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Name (HWNL, One)
        Device (HWN0)
        {
            Name (_HID, "QCOM1A68")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\_SB.HWNL == Zero))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }

            Method (HWNL, 0, NotSerialized)
            {
                Name (CFG0, Package (0x10)
                {
                    0x02, 
                    0x03, 
                    0x019B, 
                    0x14, 
                    Zero, 
                    Zero, 
                    One, 
                    One, 
                    0x02, 
                    0x02, 
                    One, 
                    One, 
                    One, 
                    0x03, 
                    0x06, 
                    One
                })
                Return (CFG0) /* \_SB_.HWN0.HWNL.CFG0 */
            }
        }

        Scope (\_SB)
        {
            Device (WLTM)
            {
                Name (_HID, "QCOM1AD5")  // _HID: Hardware ID
                Name (_CID, "QCOMFFE0")  // _CID: Compatible ID
                Alias (\_SB.PSUB, _SUB)
                Name (_DEP, Package (0x03)  // _DEP: Dependencies
                {
                    \_SB.PCI0, 
                    \_SB.SBTD, 
                    \_SB.IPC0
                })
            }
        }

        Device (SSGS)
        {
            Name (_HID, "QCOM1AD8")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
        }

        Device (CAMP)
        {
            Name (_DEP, Package (0x06)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.PMIC, 
                \_SB.PML0, 
                \_SB.ARPC, 
                \_SB.NSP0, 
                \_SB.GIO0
            })
            Name (_HID, "QCOM1A32")  // _HID: Hardware ID
            Name (_UID, 0x1B)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0AC40000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC22000,         // Address Base
                        0x0000B400,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC4A000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC4B000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC4C000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC4D000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001EC,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000012F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002AB,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002AA,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001EB,
                    }
                })
                Return (RBUF) /* \_SB_.CAMP._CRS.RBUF */
            }
        }

        Device (CAMS)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.MPCS
            })
            Name (_HID, "QCOM1A26")  // _HID: Hardware ID
            Name (_UID, 0x15)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (CAMF)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.MPCS
            })
            Name (_HID, "QCOM1A06")  // _HID: Hardware ID
            Name (_UID, 0x1A)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (CAMI)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.MPCS
            })
            Name (_HID, "QCOM1A99")  // _HID: Hardware ID
            Name (_UID, 0x1C)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (CAMT)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.MPCS
            })
            Name (_HID, "QCOM1ACE")  // _HID: Hardware ID
            Name (_UID, 0x1D)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (CAMU)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.MPCS
            })
            Name (_HID, "QCOM1ACF")  // _HID: Hardware ID
            Name (_UID, 0x1E)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (FLSH)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.CAMP
            })
            Name (_HID, "QCOM1A27")  // _HID: Hardware ID
            Name (_UID, 0x19)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, Buffer (0x02)
                {
                     0x79, 0x00                                       // y.
                })
                Return (RBUF) /* \_SB_.FLSH._CRS.RBUF */
            }
        }

        Device (MPCS)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.CAMP
            })
            Name (_HID, "QCOM1A98")  // _HID: Hardware ID
            Name (_UID, 0x18)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0AC65000,         // Address Base
                        0x00002000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC67000,         // Address Base
                        0x00002000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC5A000,         // Address Base
                        0x00002000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC5C000,         // Address Base
                        0x00002000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0ACF5000,         // Address Base
                        0x00000200,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0ACF5200,         // Address Base
                        0x00000200,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0ACF5400,         // Address Base
                        0x00000200,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0ACF5600,         // Address Base
                        0x00000200,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001FD,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001FE,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001FF,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001E0,
                    }
                })
                Return (RBUF) /* \_SB_.MPCS._CRS.RBUF */
            }
        }

        Device (JPGE)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.CAMP, 
                \_SB.MMU0
            })
            Name (_HID, "QCOM1A33")  // _HID: Hardware ID
            Name (_UID, 0x17)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x0AC4E000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x0AC52000,         // Address Base
                        0x00004000,         // Address Length
                        )
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001FA,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001FB,
                    }
                })
                Return (RBUF) /* \_SB_.JPGE._CRS.RBUF */
            }
        }

        Device (VFE0)
        {
            Name (_DEP, Package (0x04)  // _DEP: Dependencies
            {
                \_SB.MMU0, 
                \_SB.PEP0, 
                \_SB.CAMP, 
                \_SB.GIO0
            })
            Name (_HID, "QCOM1A25")  // _HID: Hardware ID
            Name (_UID, 0x16)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001ED,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000013F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000360,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000031F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000031E,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001EF,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001F5,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000188,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000319,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000318,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001FC,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001F4,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000187,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000317,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x00000316,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001F1,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001F0,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001F3,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000001F2,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002A1,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x000002A0,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000031C,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000031A,
                    }
                    GpioInt (Edge, ActiveBoth, Shared, PullDown, 0x0000,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0070
                        }
                })
                Return (RBUF) /* \_SB_.VFE0._CRS.RBUF */
            }
        }

        Device (EVA0)
        {
            Name (_DEP, Package (0x06)  // _DEP: Dependencies
            {
                \_SB.IMM0, 
                \_SB.MMU0, 
                \_SB.PEP0, 
                \_SB.PILC, 
                \_SB.TREE, 
                \_SB.PMIC
            })
            Name (_HID, "QCOM0CF1")  // _HID: Hardware ID
            Name (_UID, 0x1E)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive, ,, )
                    {
                        0x0000010A,
                    }
                    Memory32Fixed (ReadWrite,
                        0x0AB00000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x000B0088,         // Address Base
                        0x00000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x00400000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x00110000,         // Address Base
                        0x00040000,         // Address Length
                        )
                })
                Return (RBUF) /* \_SB_.EVA0._CRS.RBUF */
            }
        }

        Device (SEN2)
        {
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.IPC0, 
                \_SB.SCSS, 
                \_SB.ARPC
            })
            Name (_HID, "QCOM1A93")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_CID, "QCOM1A67")  // _CID: Compatible ID
            Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
            {
                ToPLD (
                    PLD_Revision           = 0x2,
                    PLD_IgnoreColor        = 0x1,
                    PLD_Red                = 0x0,
                    PLD_Green              = 0x0,
                    PLD_Blue               = 0x0,
                    PLD_Width              = 0x0,
                    PLD_Height             = 0x0,
                    PLD_UserVisible        = 0x0,
                    PLD_Dock               = 0x0,
                    PLD_Lid                = 0x1,
                    PLD_Panel              = "TOP",
                    PLD_VerticalPosition   = "UPPER",
                    PLD_HorizontalPosition = "LEFT",
                    PLD_Shape              = "UNKNOWN",
                    PLD_GroupOrientation   = 0x0,
                    PLD_GroupToken         = 0x0,
                    PLD_GroupPosition      = 0x0,
                    PLD_Bay                = 0x0,
                    PLD_Ejectable          = 0x0,
                    PLD_EjectRequired      = 0x0,
                    PLD_CabinetNumber      = 0x0,
                    PLD_CardCageNumber     = 0x0,
                    PLD_Reference          = 0x0,
                    PLD_Rotation           = 0x0,
                    PLD_Order              = 0x0,
                    PLD_VerticalOffset     = 0xFFFF,
                    PLD_HorizontalOffset   = 0xFFFF)

            })
        }

        Device (HPS0)
        {
            Name (_HID, "QCOM1AD9")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (ENTP, 0xFF)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((ENTP == 0xFF))
                {
                    If ((\_SB.PLST == 0x04))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Name (HPDB, Zero)
        Name (HPDS, Buffer (One)
        {
             0x00                                             // .
        })
        Name (PINA, Zero)
        Name (DPPN, 0x0D)
        Name (CCST, Buffer (One)
        {
             0x02                                             // .
        })
        Name (CCS2, 0x02)
        Name (PORT, Buffer (One)
        {
             0x02                                             // .
        })
        Name (HIRQ, Buffer (One)
        {
             0x00                                             // .
        })
        Name (USBC, Buffer (One)
        {
             0x0B                                             // .
        })
        Name (MUXC, Buffer (One)
        {
             0x00                                             // .
        })
        Device (URS0)
        {
            Name (_HID, "QCOM1A8B")  // _HID: Hardware ID
            Name (_CID, Package (0x02)  // _CID: Compatible ID
            {
                "PNP0CA1", 
                "QCOMFFE1"
            })
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.UCS0
            })
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x0A600000,         // Address Base
                    0x000FFFFF,         // Address Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Device (USB0)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000A5,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x000000A2,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x00000211,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x0000020F,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x0000020E,
                    }
                })
                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PRT1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            One, 
                            0x09, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
                        {
                            ToPLD (
                                PLD_Revision           = 0x2,
                                PLD_IgnoreColor        = 0x1,
                                PLD_Red                = 0x0,
                                PLD_Green              = 0x0,
                                PLD_Blue               = 0x0,
                                PLD_Width              = 0x0,
                                PLD_Height             = 0x0,
                                PLD_UserVisible        = 0x1,
                                PLD_Dock               = 0x0,
                                PLD_Lid                = 0x0,
                                PLD_Panel              = "BACK",
                                PLD_VerticalPosition   = "CENTER",
                                PLD_HorizontalPosition = "LEFT",
                                PLD_Shape              = "VERTICALRECTANGLE",
                                PLD_GroupOrientation   = 0x0,
                                PLD_GroupToken         = 0x0,
                                PLD_GroupPosition      = 0x0,
                                PLD_Bay                = 0x0,
                                PLD_Ejectable          = 0x0,
                                PLD_EjectRequired      = 0x0,
                                PLD_CabinetNumber      = 0x0,
                                PLD_CardCageNumber     = 0x0,
                                PLD_Reference          = 0x0,
                                PLD_Rotation           = 0x0,
                                PLD_Order              = 0x0,
                                PLD_VerticalOffset     = 0xFFFF,
                                PLD_HorizontalOffset   = 0xFFFF)

                        })
                    }
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }

                Method (CCVL, 0, NotSerialized)
                {
                    Return (\_SB.UCS0.ECC0)
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    While (One)
                    {
                        Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        {
                             0x00                                             // .
                        })
                        CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.URS0.USB0._DSM._T_0 */
                        If ((_T_0 == ToUUID ("ce2ee385-00e6-48cb-9f05-2edb927c4899") /* USB Controller */))
                        {
                            While (One)
                            {
                                Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                _T_1 = ToInteger (Arg2)
                                If ((_T_1 == Zero))
                                {
                                    While (One)
                                    {
                                        Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                        _T_2 = ToInteger (Arg1)
                                        If ((_T_2 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x1D                                             // .
                                            })
                                            Break
                                        }
                                        Else
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x01                                             // .
                                            })
                                            Break
                                        }

                                        Break
                                    }

                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }
                                ElseIf ((_T_1 == 0x02))
                                {
                                    Return (Zero)
                                    Break
                                }
                                ElseIf ((_T_1 == 0x03))
                                {
                                    Return (Zero)
                                    Break
                                }
                                ElseIf ((_T_1 == 0x04))
                                {
                                    Return (0x02)
                                    Break
                                }
                                Else
                                {
                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }

                                Break
                            }
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                 0x00                                             // .
                            })
                            Break
                        }

                        Break
                    }
                }

                Method (PHYC, 0, NotSerialized)
                {
                    Name (CFG0, Package (0x00){})
                    Return (CFG0) /* \_SB_.URS0.USB0.PHYC.CFG0 */
                }
            }

            Device (UFN0)
            {
                Name (_ADR, One)  // _ADR: Address
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PRT1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            One, 
                            0x09, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
                        {
                            ToPLD (
                                PLD_Revision           = 0x2,
                                PLD_IgnoreColor        = 0x1,
                                PLD_Red                = 0x0,
                                PLD_Green              = 0x0,
                                PLD_Blue               = 0x0,
                                PLD_Width              = 0x0,
                                PLD_Height             = 0x0,
                                PLD_UserVisible        = 0x1,
                                PLD_Dock               = 0x0,
                                PLD_Lid                = 0x0,
                                PLD_Panel              = "BACK",
                                PLD_VerticalPosition   = "CENTER",
                                PLD_HorizontalPosition = "LEFT",
                                PLD_Shape              = "VERTICALRECTANGLE",
                                PLD_GroupOrientation   = 0x0,
                                PLD_GroupToken         = 0x0,
                                PLD_GroupPosition      = 0x0,
                                PLD_Bay                = 0x0,
                                PLD_Ejectable          = 0x0,
                                PLD_EjectRequired      = 0x0,
                                PLD_CabinetNumber      = 0x0,
                                PLD_CardCageNumber     = 0x0,
                                PLD_Reference          = 0x0,
                                PLD_Rotation           = 0x0,
                                PLD_Order              = 0x0,
                                PLD_VerticalOffset     = 0xFFFF,
                                PLD_HorizontalOffset   = 0xFFFF)

                        })
                    }
                }

                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000A5,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x000000A2,
                    }
                })
                Method (CCVL, 0, NotSerialized)
                {
                    Return (\_SB.UCS0.ECC0)
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    While (One)
                    {
                        Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        {
                             0x00                                             // .
                        })
                        CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.URS0.UFN0._DSM._T_0 */
                        If ((_T_0 == ToUUID ("fe56cfeb-49d5-4378-a8a2-2978dbe54ad2") /* Unknown UUID */))
                        {
                            While (One)
                            {
                                Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                _T_1 = ToInteger (Arg2)
                                If ((_T_1 == Zero))
                                {
                                    While (One)
                                    {
                                        Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                        _T_2 = ToInteger (Arg1)
                                        If ((_T_2 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x03                                             // .
                                            })
                                            Break
                                        }
                                        Else
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x01                                             // .
                                            })
                                            Break
                                        }

                                        Break
                                    }

                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }
                                ElseIf ((_T_1 == One))
                                {
                                    Return (0x20)
                                    Break
                                }
                                Else
                                {
                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }

                                Break
                            }
                        }
                        ElseIf ((_T_0 == ToUUID ("18de299f-9476-4fc9-b43b-8aeb713ed751") /* Unknown UUID */))
                        {
                            While (One)
                            {
                                Name (_T_3, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                _T_3 = ToInteger (Arg2)
                                If ((_T_3 == Zero))
                                {
                                    While (One)
                                    {
                                        Name (_T_4, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                        _T_4 = ToInteger (Arg1)
                                        If ((_T_4 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x03                                             // .
                                            })
                                            Break
                                        }
                                        Else
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x01                                             // .
                                            })
                                            Break
                                        }

                                        Break
                                    }

                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }
                                ElseIf ((_T_3 == One))
                                {
                                    Return (0x39)
                                    Break
                                }
                                Else
                                {
                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }

                                Break
                            }
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                 0x00                                             // .
                            })
                            Break
                        }

                        Break
                    }
                }

                Method (PHYC, 0, NotSerialized)
                {
                    Name (CFG0, Package (0x00){})
                    Return (CFG0) /* \_SB_.URS0.UFN0.PHYC.CFG0 */
                }
            }
        }

        Device (URS1)
        {
            Name (_HID, "QCOM1A8C")  // _HID: Hardware ID
            Name (_CID, Package (0x02)  // _CID: Compatible ID
            {
                "PNP0CA1", 
                "QCOMFFE1"
            })
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, One)  // _UID: Unique ID
            Name (_CCA, Zero)  // _CCA: Cache Coherency Attribute
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.UCS0
            })
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x0A800000,         // Address Base
                    0x000FFFFF,         // Address Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }

            Device (USB1)
            {
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Name (_ADR, Zero)  // _ADR: Address
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000AA,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x000000A7,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x00000233,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x0000020D,
                    }
                    Interrupt (ResourceConsumer, Edge, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x0000020C,
                    }
                })
                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PRT1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            One, 
                            0x09, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
                        {
                            ToPLD (
                                PLD_Revision           = 0x2,
                                PLD_IgnoreColor        = 0x1,
                                PLD_Red                = 0x0,
                                PLD_Green              = 0x0,
                                PLD_Blue               = 0x0,
                                PLD_Width              = 0x0,
                                PLD_Height             = 0x0,
                                PLD_UserVisible        = 0x1,
                                PLD_Dock               = 0x0,
                                PLD_Lid                = 0x0,
                                PLD_Panel              = "BACK",
                                PLD_VerticalPosition   = "CENTER",
                                PLD_HorizontalPosition = "LEFT",
                                PLD_Shape              = "VERTICALRECTANGLE",
                                PLD_GroupOrientation   = 0x0,
                                PLD_GroupToken         = 0x0,
                                PLD_GroupPosition      = 0x1,
                                PLD_Bay                = 0x0,
                                PLD_Ejectable          = 0x0,
                                PLD_EjectRequired      = 0x0,
                                PLD_CabinetNumber      = 0x0,
                                PLD_CardCageNumber     = 0x0,
                                PLD_Reference          = 0x0,
                                PLD_Rotation           = 0x0,
                                PLD_Order              = 0x0,
                                PLD_VerticalOffset     = 0xFFFF,
                                PLD_HorizontalOffset   = 0xFFFF)

                        })
                    }
                }

                Name (STVL, 0x0F)
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (STVL) /* \_SB_.URS1.USB1.STVL */
                }

                Method (CCVL, 0, NotSerialized)
                {
                    Return (\_SB.UCS0.ECC1)
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    While (One)
                    {
                        Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        {
                             0x00                                             // .
                        })
                        CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.URS1.USB1._DSM._T_0 */
                        If ((_T_0 == ToUUID ("ce2ee385-00e6-48cb-9f05-2edb927c4899") /* USB Controller */))
                        {
                            While (One)
                            {
                                Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                _T_1 = ToInteger (Arg2)
                                If ((_T_1 == Zero))
                                {
                                    While (One)
                                    {
                                        Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                        _T_2 = ToInteger (Arg1)
                                        If ((_T_2 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x1D                                             // .
                                            })
                                            Break
                                        }
                                        Else
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x01                                             // .
                                            })
                                            Break
                                        }

                                        Break
                                    }

                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }
                                ElseIf ((_T_1 == 0x02))
                                {
                                    Return (Zero)
                                    Break
                                }
                                ElseIf ((_T_1 == 0x03))
                                {
                                    Return (Zero)
                                    Break
                                }
                                ElseIf ((_T_1 == 0x04))
                                {
                                    Return (0x02)
                                    Break
                                }
                                Else
                                {
                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }

                                Break
                            }
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                 0x00                                             // .
                            })
                            Break
                        }

                        Break
                    }
                }

                Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
                {
                }

                Method (REMD, 0, NotSerialized)
                {
                    STVL = Zero
                    Notify (\_SB.URS1.USB1, One) // Device Check
                }

                Method (ADDD, 0, NotSerialized)
                {
                    STVL = 0x0F
                    Notify (\_SB.URS1.USB1, One) // Device Check
                }

                Method (PHYC, 0, NotSerialized)
                {
                    Name (CFG0, Package (0x00){})
                    Return (CFG0) /* \_SB_.URS1.USB1.PHYC.CFG0 */
                }
            }

            Device (UFN1)
            {
                Name (_ADR, One)  // _ADR: Address
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PRT1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            One, 
                            0x09, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
                        {
                            ToPLD (
                                PLD_Revision           = 0x2,
                                PLD_IgnoreColor        = 0x1,
                                PLD_Red                = 0x0,
                                PLD_Green              = 0x0,
                                PLD_Blue               = 0x0,
                                PLD_Width              = 0x0,
                                PLD_Height             = 0x0,
                                PLD_UserVisible        = 0x1,
                                PLD_Dock               = 0x0,
                                PLD_Lid                = 0x0,
                                PLD_Panel              = "BACK",
                                PLD_VerticalPosition   = "CENTER",
                                PLD_HorizontalPosition = "LEFT",
                                PLD_Shape              = "VERTICALRECTANGLE",
                                PLD_GroupOrientation   = 0x0,
                                PLD_GroupToken         = 0x0,
                                PLD_GroupPosition      = 0x1,
                                PLD_Bay                = 0x0,
                                PLD_Ejectable          = 0x0,
                                PLD_EjectRequired      = 0x0,
                                PLD_CabinetNumber      = 0x0,
                                PLD_CardCageNumber     = 0x0,
                                PLD_Reference          = 0x0,
                                PLD_Rotation           = 0x0,
                                PLD_Order              = 0x0,
                                PLD_VerticalOffset     = 0xFFFF,
                                PLD_HorizontalOffset   = 0xFFFF)

                        })
                    }
                }

                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                    {
                        0x000000AA,
                    }
                    Interrupt (ResourceConsumer, Level, ActiveHigh, SharedAndWake, ,, )
                    {
                        0x000000A7,
                    }
                })
                Method (CCVL, 0, NotSerialized)
                {
                    Return (\_SB.UCS0.ECC1)
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    While (One)
                    {
                        Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        {
                             0x00                                             // .
                        })
                        CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.URS1.UFN1._DSM._T_0 */
                        If ((_T_0 == ToUUID ("fe56cfeb-49d5-4378-a8a2-2978dbe54ad2") /* Unknown UUID */))
                        {
                            While (One)
                            {
                                Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                _T_1 = ToInteger (Arg2)
                                If ((_T_1 == Zero))
                                {
                                    While (One)
                                    {
                                        Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                        _T_2 = ToInteger (Arg1)
                                        If ((_T_2 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x03                                             // .
                                            })
                                            Break
                                        }
                                        Else
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x01                                             // .
                                            })
                                            Break
                                        }

                                        Break
                                    }

                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }
                                ElseIf ((_T_1 == One))
                                {
                                    Return (0x20)
                                    Break
                                }
                                Else
                                {
                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }

                                Break
                            }
                        }
                        ElseIf ((_T_0 == ToUUID ("18de299f-9476-4fc9-b43b-8aeb713ed751") /* Unknown UUID */))
                        {
                            While (One)
                            {
                                Name (_T_3, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                _T_3 = ToInteger (Arg2)
                                If ((_T_3 == Zero))
                                {
                                    While (One)
                                    {
                                        Name (_T_4, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                        _T_4 = ToInteger (Arg1)
                                        If ((_T_4 == Zero))
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x03                                             // .
                                            })
                                            Break
                                        }
                                        Else
                                        {
                                            Return (Buffer (One)
                                            {
                                                 0x01                                             // .
                                            })
                                            Break
                                        }

                                        Break
                                    }

                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }
                                ElseIf ((_T_3 == One))
                                {
                                    Return (0x39)
                                    Break
                                }
                                Else
                                {
                                    Return (Buffer (One)
                                    {
                                         0x00                                             // .
                                    })
                                    Break
                                }

                                Break
                            }
                        }
                        Else
                        {
                            Return (Buffer (One)
                            {
                                 0x00                                             // .
                            })
                            Break
                        }

                        Break
                    }
                }

                Method (PHYC, 0, NotSerialized)
                {
                    Name (CFG0, Package (0x00){})
                    Return (CFG0) /* \_SB_.URS1.UFN1.PHYC.CFG0 */
                }
            }
        }

        Device (UCSI)
        {
            Name (_HID, EisaId ("USBC000"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0CA0"))  // _CID: Compatible ID
            Name (_UID, 0x03)  // _UID: Unique ID
            Name (_DDN, "USB Type-C")  // _DDN: DOS Device Name
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.ABD, 
                \_SB.PMGK, 
                \_SB.UCS0
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                VERS = 0x0110
                CCI = Zero
                MSGI = Zero
                If ((\_SB.PMGK.LKUP > Zero))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Device (UCN0)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
                {
                    ToPLD (
                        PLD_Revision           = 0x2,
                        PLD_IgnoreColor        = 0x1,
                        PLD_Red                = 0x0,
                        PLD_Green              = 0x0,
                        PLD_Blue               = 0x0,
                        PLD_Width              = 0x0,
                        PLD_Height             = 0x0,
                        PLD_UserVisible        = 0x1,
                        PLD_Dock               = 0x0,
                        PLD_Lid                = 0x0,
                        PLD_Panel              = "BACK",
                        PLD_VerticalPosition   = "CENTER",
                        PLD_HorizontalPosition = "LEFT",
                        PLD_Shape              = "VERTICALRECTANGLE",
                        PLD_GroupOrientation   = 0x0,
                        PLD_GroupToken         = 0x0,
                        PLD_GroupPosition      = 0x0,
                        PLD_Bay                = 0x0,
                        PLD_Ejectable          = 0x0,
                        PLD_EjectRequired      = 0x0,
                        PLD_CabinetNumber      = 0x0,
                        PLD_CardCageNumber     = 0x0,
                        PLD_Reference          = 0x0,
                        PLD_Rotation           = 0x0,
                        PLD_Order              = 0x0,
                        PLD_VerticalOffset     = 0xFFFF,
                        PLD_HorizontalOffset   = 0xFFFF)

                })
                Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                {
                    One, 
                    0x09, 
                    Zero, 
                    Zero
                })
            }

            Device (UCN1)
            {
                Name (_ADR, One)  // _ADR: Address
                Name (_PLD, Package (0x01)  // _PLD: Physical Location of Device
                {
                    ToPLD (
                        PLD_Revision           = 0x2,
                        PLD_IgnoreColor        = 0x1,
                        PLD_Red                = 0x0,
                        PLD_Green              = 0x0,
                        PLD_Blue               = 0x0,
                        PLD_Width              = 0x0,
                        PLD_Height             = 0x0,
                        PLD_UserVisible        = 0x1,
                        PLD_Dock               = 0x0,
                        PLD_Lid                = 0x0,
                        PLD_Panel              = "BACK",
                        PLD_VerticalPosition   = "CENTER",
                        PLD_HorizontalPosition = "LEFT",
                        PLD_Shape              = "VERTICALRECTANGLE",
                        PLD_GroupOrientation   = 0x0,
                        PLD_GroupToken         = 0x0,
                        PLD_GroupPosition      = 0x1,
                        PLD_Bay                = 0x0,
                        PLD_Ejectable          = 0x0,
                        PLD_EjectRequired      = 0x0,
                        PLD_CabinetNumber      = 0x0,
                        PLD_CardCageNumber     = 0x0,
                        PLD_Reference          = 0x0,
                        PLD_Rotation           = 0x0,
                        PLD_Order              = 0x0,
                        PLD_VerticalOffset     = 0xFFFF,
                        PLD_HorizontalOffset   = 0xFFFF)

                })
                Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                {
                    One, 
                    0x09, 
                    Zero, 
                    Zero
                })
            }

            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0x808A0000,         // Address Base
                    0x00000030,         // Address Length
                    )
            })
            OperationRegion (USBC, SystemMemory, 0x808A0000, 0x30)
            Field (USBC, ByteAcc, NoLock, Preserve)
            {
                VERS,   16, 
                RESV,   16, 
                CCI,    32, 
                CTRL,   64, 
                MSGI,   128, 
                MSGO,   128
            }

            Name (BUFF, Buffer (0x32){})
            CreateField (BUFF, Zero, 0x08, BSTA)
            CreateField (BUFF, 0x08, 0x08, BSIZ)
            CreateField (BUFF, 0x10, 0x10, BVER)
            CreateField (BUFF, 0x30, 0x20, BCCI)
            CreateField (BUFF, 0x50, 0x40, BCTL)
            CreateField (BUFF, 0x90, 0x80, BMGI)
            CreateField (BUFF, 0x0110, 0x80, BMGO)
            Method (OPMW, 0, NotSerialized)
            {
                BCTL = CTRL /* \_SB_.UCSI.CTRL */
                BMGO = MSGO /* \_SB_.UCSI.MSGO */
                \_SB.PMGK.UCSI = BUFF /* \_SB_.UCSI.BUFF */
                Return (Zero)
            }

            Method (OPMR, 0, NotSerialized)
            {
                BUFF = \_SB.PMGK.UCSI
                VERS = BVER /* \_SB_.UCSI.BVER */
                CCI = BCCI /* \_SB_.UCSI.BCCI */
                MSGI = BMGI /* \_SB_.UCSI.BMGI */
                Return (Zero)
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == ToUUID ("6f8398c2-7ca4-11e4-ad36-631042b5008f") /* Unknown UUID */))
                {
                    While (One)
                    {
                        Name (_T_0, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                        _T_0 = ToInteger (Arg2)
                        If ((_T_0 == Zero))
                        {
                            Return (Buffer (One)
                            {
                                 0x0F                                             // .
                            })
                        }
                        ElseIf ((_T_0 == One))
                        {
                            Return (OPMW ())
                        }
                        ElseIf ((_T_0 == 0x02))
                        {
                            Return (OPMR ())
                        }
                        ElseIf ((_T_0 == 0x03))
                        {
                            Return (Zero)
                        }
                        ElseIf ((_T_0 == 0x04))
                        {
                            Return (One)
                        }

                        Break
                    }
                }
            }
        }

        Device (UCS0)
        {
            Name (_HID, "QCOM1AA4")  // _HID: Hardware ID
            Name (_CID, "QCOMFFE5")  // _CID: Compatible ID
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PEP0
            })
            Method (_SUB, 0, NotSerialized)  // _SUB: Subsystem ID
            {
                If (((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x03)))
                {
                    Return ("QRDR8350")
                }
                Else
                {
                    Return (\_SB.PSUB)
                }
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (CRS0, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x808A0040,         // Address Base
                        0x00000020,         // Address Length
                        )
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    I2cSerialBusV2 (0x0008, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.IC22",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    I2cSerialBusV2 (0x000C, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.IC22",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                })
                Name (CRS1, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0x808A0040,         // Address Base
                        0x00000020,         // Address Length
                        )
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x00FF
                        }
                })
                If (((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x03)))
                {
                    Return (CRS0) /* \_SB_.UCS0._CRS.CRS0 */
                }
                Else
                {
                    Return (CRS1) /* \_SB_.UCS0._CRS.CRS1 */
                }
            }

            OperationRegion (USBC, SystemMemory, 0x808A0040, 0x20)
            Field (USBC, ByteAcc, NoLock, Preserve)
            {
                INFO,   8, 
                UPDT,   8, 
                CCX0,   8, 
                MUX0,   8, 
                RES0,   8, 
                VID0,   16, 
                SID0,   16, 
                SVS0,   64, 
                CCX1,   8, 
                MUX1,   8, 
                RES1,   8, 
                VID1,   16, 
                SID1,   16, 
                SVS1,   64
            }

            Name (PORT, Buffer (0x20)
            {
                 0x02                                             // .
            })
            CreateByteField (PORT, Zero, EINF)
            CreateByteField (PORT, One, EUPD)
            CreateByteField (PORT, 0x02, ECC0)
            CreateByteField (PORT, 0x03, EMX0)
            CreateWordField (PORT, 0x05, EVI0)
            CreateWordField (PORT, 0x07, ESI0)
            CreateQWordField (PORT, 0x09, ESV0)
            CreateByteField (PORT, 0x11, ECC1)
            CreateByteField (PORT, 0x12, EMX1)
            CreateWordField (PORT, 0x14, EVI1)
            CreateWordField (PORT, 0x16, ESI1)
            CreateQWordField (PORT, 0x18, ESV1)
            Method (USBW, 0, NotSerialized)
            {
                EUPD = UPDT /* \_SB_.UCS0.UPDT */
                Notify (\_SB.PMGK, 0xF0) // Hardware-Specific
                Return (Zero)
            }

            Method (USBR, 0, NotSerialized)
            {
                INFO = EINF /* \_SB_.UCS0.EINF */
                UPDT = EUPD /* \_SB_.UCS0.EUPD */
                CCX0 = ECC0 /* \_SB_.UCS0.ECC0 */
                MUX0 = EMX0 /* \_SB_.UCS0.EMX0 */
                RES0 = Zero
                VID0 = EVI0 /* \_SB_.UCS0.EVI0 */
                SID0 = ESI0 /* \_SB_.UCS0.ESI0 */
                SVS0 = ESV0 /* \_SB_.UCS0.ESV0 */
                CCX1 = ECC1 /* \_SB_.UCS0.ECC1 */
                MUX1 = EMX1 /* \_SB_.UCS0.EMX1 */
                RES1 = Zero
                VID1 = EVI1 /* \_SB_.UCS0.EVI1 */
                SID1 = ESI1 /* \_SB_.UCS0.ESI1 */
                SVS1 = ESV1 /* \_SB_.UCS0.ESV1 */
                Notify (UCS0, 0xA0) // Device-Specific
                \_SB.CCS2 = ECC0 /* \_SB_.UCS0.ECC0 */
                Notify (\_SB.CFSA, \_SB.CCS2)
                Return (Zero)
            }
        }

        Device (CFSA)
        {
            Name (_HID, "FSA04480")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0042, ControllerInitiated, 0x000186A0,
                        AddressingMode7Bit, "\\_SB.IC14",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    GpioIo (Shared, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x01
                        })
                        {   // Pin list
                            0x0026
                        }
                    GpioIo (Exclusive, PullUp, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x001A
                        }
                })
                Return (RBUF) /* \_SB_.CFSA._CRS.RBUF */
            }
        }

        Device (MPA)
        {
            Name (_HID, "QCOM05B4")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((((\_SB.PSUB == "MTP08350") && (\_SB.PLST == One)) || ((
                    \_SB.PSUB == "QRD08350") && (\_SB.PLST == One))) || ((\_SB.PSUB == "CDP08350") && (\_SB.PLST == Zero))))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (MPA1)
        {
            Name (_HID, "QCOM05B5")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (MBJ0)
        {
            Name (_HID, "QCOM05B6")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((((\_SB.PSUB == "MTP08350") && (\_SB.PLST == One)) || ((
                    \_SB.PSUB == "QRD08350") && (\_SB.PLST == One))) || ((\_SB.PSUB == "CDP08350") && (\_SB.PLST == Zero))))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (MBJ1)
        {
            Name (_HID, "QCOM05B7")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (MBJ2)
        {
            Name (_HID, "QCOM05B8")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (MBJ3)
        {
            Name (_HID, "QCOM05B9")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (MBS0)
        {
            Name (_HID, "QCOM05BA")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (MBS1)
        {
            Name (_HID, "QCOM05BB")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((((\_SB.PSUB == "MTP08350") && (\_SB.PLST == One)) || ((
                    \_SB.PSUB == "QRD08350") && (\_SB.PLST == One))) || ((\_SB.PSUB == "CDP08350") && (\_SB.PLST == Zero))))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (MBS2)
        {
            Name (_HID, "QCOM05BC")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((((\_SB.PSUB == "MTP08350") && (\_SB.PLST == One)) || ((
                    \_SB.PSUB == "QRD08350") && (\_SB.PLST == One))) || ((\_SB.PSUB == "CDP08350") && (\_SB.PLST == Zero))))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (MBS3)
        {
            Name (_HID, "QCOM05BD")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        Device (MSKN)
        {
            Name (_HID, "QCOM05BE")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((((\_SB.PSUB == "MTP08350") && (\_SB.PLST == One)) || ((
                    \_SB.PSUB == "QRD08350") && (\_SB.PLST == One))) || ((\_SB.PSUB == "CDP08350") && (\_SB.PLST == Zero))))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (MJCT)
        {
            Name (_HID, "QCOM05BF")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((((\_SB.PSUB == "MTP08350") && (\_SB.PLST == One)) || ((
                    \_SB.PSUB == "QRD08350") && (\_SB.PLST == One))) || ((\_SB.PSUB == "CDP08350") && (\_SB.PLST == Zero))))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Device (MBCL)
        {
            Name (_HID, "QCOM1AD4")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (Zero)
            }
        }

        ThermalZone (TZ51)
        {
            Name (_HID, "QCOM05C0")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.MPA
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ51.TPSV)
            }

            Name (TCRT, 0x0F5A)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ51.TCRT)
            }

            Name (TTC1, One)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ51.TTC1)
            }

            Name (TTC2, 0x02)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ51.TTC2)
            }

            Name (TTSP, 0x0A)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ51.TTSP)
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.MPA
                })
            }
        }

        ThermalZone (TZ58)
        {
            Name (_HID, "QCOM1A63")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.MBS1
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ58.TPSV)
            }

            Name (TCRT, 0x0F5A)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ58.TCRT)
            }

            Name (TTC1, One)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ58.TTC1)
            }

            Name (TTC2, 0x02)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ58.TTC2)
            }

            Name (TTSP, 0x0A)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ58.TTSP)
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.MBS1, 
                    \_SB.ADC1
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)) || ((\_SB.PSUB == 
                    "QRD08350") && (\_SB.PLST == 0x02))))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        ThermalZone (TZ59)
        {
            Name (_HID, "QCOM1A64")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.MBS2
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ59.TPSV)
            }

            Name (TCRT, 0x0F5A)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ59.TCRT)
            }

            Name (TTC1, One)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ59.TTC1)
            }

            Name (TTC2, 0x02)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ59.TTC2)
            }

            Name (TTSP, 0x0A)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ59.TTSP)
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.MBS2, 
                    \_SB.ADC1
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)) || ((\_SB.PSUB == 
                    "QRD08350") && (\_SB.PLST == 0x02))))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        ThermalZone (TZ61)
        {
            Name (_HID, "QCOM1A61")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x03)  // _TZD: Thermal Zone Devices
            {
                \_SB.MSKN, 
                \_SB.MJCT, 
                \_SB.MBJ0
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ61.TPSV)
            }

            Name (TCRT, 0x0F5A)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ61.TCRT)
            }

            Name (TTC1, One)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ61.TTC1)
            }

            Name (TTC2, 0x02)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ61.TTC2)
            }

            Name (TTSP, 0x0A)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ61.TTSP)
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.MSKN, 
                    \_SB.ADC1
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)) || ((\_SB.PSUB == 
                    "QRD08350") && (\_SB.PLST == 0x02))))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }

        Device (AGR0)
        {
            Name (_HID, "ACPI000C" /* Processor Aggregator Device */)  // _HID: Hardware ID
            Name (_PUR, Package (0x02)  // _PUR: Processor Utilization Request
            {
                One, 
                Zero
            })
            Method (_OST, 3, NotSerialized)  // _OST: OSPM Status Indication
            {
                \_SB.PEP0.ROST = Arg2
            }
        }

        ThermalZone (TZ0)
        {
            Name (_HID, "QCOM1A58")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ0.TTSP)
            }
        }

        ThermalZone (TZ1)
        {
            Name (_HID, "QCOM1A58")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0
            })
            Name (TPSV, 0x0EC4)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ1.TPSV)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ1.TTC1)
            }

            Name (TTC2, One)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ1.TTC2)
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ1.TTSP)
            }

            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ2)
        {
            Name (_HID, "QCOM1A59")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ2.TTSP)
            }
        }

        ThermalZone (TZ3)
        {
            Name (_HID, "QCOM1A59")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0
            })
            Name (TPSV, 0x0EC4)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ3.TPSV)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ3.TTC1)
            }

            Name (TTC2, One)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ3.TTC2)
            }

            Name (TTSP, One)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ3.TTSP)
            }

            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ5)
        {
            Name (_HID, "QCOM1A91")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.GPU0
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ5.TPSV)
            }

            Name (TTC1, One)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ5.TTC1)
            }

            Name (TTC2, 0x02)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ5.TTC2)
            }

            Name (TTSP, 0x02)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ5.TTSP)
            }

            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ6)
        {
            Name (_HID, "QCOM1A47")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ6.TTSP)
            }
        }

        ThermalZone (TZ7)
        {
            Name (_HID, "QCOM1AC4")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ7.TTSP)
            }
        }

        ThermalZone (TZ8)
        {
            Name (_HID, "QCOM1AC5")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ8.TTSP)
            }
        }

        ThermalZone (TZ9)
        {
            Name (_HID, "QCOM1AC6")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ9.TTSP)
            }
        }

        ThermalZone (TZ10)
        {
            Name (_HID, "QCOM1A46")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ10.TTSP)
            }
        }

        ThermalZone (TZ11)
        {
            Name (_HID, "QCOM1ABF")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.CSW0
            })
            Name (TPSV, 0x0EC4)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ11.TPSV)
            }

            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ11.TTC1)
            }

            Name (TTC2, One)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ11.TTC2)
            }

            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ11.TTSP)
            }

            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ12)
        {
            Name (_HID, "QCOM1AC0")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (TTSP, 0x32)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ12.TTSP)
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ13)
        {
            Name (_HID, "QCOM1A57")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x04)  // _TZD: Thermal Zone Devices
            {
                \_SB.GPU0, 
                \_SB.WLTM, 
                \_SB.CSW0, 
                \_SB.MBCL
            })
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (0x0DCA)
            }

            Name (_TC1, One)  // _TC1: Thermal Constant 1
            Name (_TC2, 0x05)  // _TC2: Thermal Constant 2
            Name (_TSP, 0x14)  // _TSP: Thermal Sampling Period
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.BCL1
                })
            }
        }

        ThermalZone (TZ14)
        {
            Name (_HID, "QCOM1AD6")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.DMMY
            })
            Name (TPSV, 0x0DCA)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ14.TPSV)
            }

            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ14.TTC1)
            }

            Name (TTC2, One)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ14.TTC2)
            }

            Name (TTSP, 0x0F)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ14.TTSP)
            }

            Method (_TFP, 0, NotSerialized)  // _TFP: Thermal Fast Sampling Period
            {
                Return (\_SB.TZ14.TTSP)
            }

            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ15)
        {
            Name (_HID, "QCOM1AC8")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveHigh, Exclusive, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x00C0
                        }
                })
                Return (RBUF) /* \_SB_.TZ15._CRS.RBUF */
            }

            Name (_TZD, Package (0x04)  // _TZD: Thermal Zone Devices
            {
                \_SB.SYSM.CLUS.CPU0, 
                \_SB.SYSM.CLUS.CPU1, 
                \_SB.SYSM.CLUS.CPU2, 
                \_SB.SYSM.CLUS.CPU3
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ15.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ15.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ15.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ15.TTC2)
            }

            Name (_TSP, One)  // _TSP: Thermal Sampling Period
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                While (One)
                {
                    Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    {
                         0x00                                             // .
                    })
                    CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.TZ15._DSM._T_0 */
                    If ((_T_0 == ToUUID ("c2d42c4b-e25e-471c-8a4e-290aac3a29a3") /* Unknown UUID */))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = Arg2
                            If ((_T_1 == Zero))
                            {
                                While (One)
                                {
                                    Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                    _T_2 = Arg1
                                    If ((_T_2 == Zero))
                                    {
                                        Return (Buffer (One)
                                        {
                                             0x03                                             // .
                                        })
                                    }

                                    Break
                                }

                                Return (Buffer (One)
                                {
                                     0x00                                             // .
                                })
                            }
                            ElseIf ((_T_1 == One))
                            {
                                \_SB.TZ15.TPSV = DerefOf (Arg3 [Zero])
                                \_SB.TZ15.TCRT = DerefOf (Arg3 [One])
                                \_SB.TZ15.TTC2 = DerefOf (Arg3 [0x02])
                                \_SB.TZ15.TTC1 = Zero
                                Notify (\_SB.TZ15, 0x81) // Thermal Trip Point Change
                                Return (\_SB.TZ15.TPSV)
                            }
                            Else
                            {
                                Return (Zero)
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }

                    Break
                }
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.PMIC
                })
            }
        }

        ThermalZone (TZ16)
        {
            Name (_HID, "QCOM1AC9")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0100
                        }
                })
                Return (RBUF) /* \_SB_.TZ16._CRS.RBUF */
            }

            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0
            })
            Name (_MTL, 0x32)  // _MTL: Minimum Throttle Limit
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ16.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ16.TCRT)
            }

            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ16.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ16.TTC2)
            }

            Name (_TSP, One)  // _TSP: Thermal Sampling Period
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                While (One)
                {
                    Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    {
                         0x00                                             // .
                    })
                    CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.TZ16._DSM._T_0 */
                    If ((_T_0 == ToUUID ("c2d42c4b-e25e-471c-8a4e-290aac3a29a3") /* Unknown UUID */))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = Arg2
                            If ((_T_1 == Zero))
                            {
                                While (One)
                                {
                                    Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                    _T_2 = Arg1
                                    If ((_T_2 == Zero))
                                    {
                                        Return (Buffer (One)
                                        {
                                             0x03                                             // .
                                        })
                                    }

                                    Break
                                }

                                Return (Buffer (One)
                                {
                                     0x00                                             // .
                                })
                            }
                            ElseIf ((_T_1 == One))
                            {
                                \_SB.TZ16.TPSV = DerefOf (Arg3 [Zero])
                                \_SB.TZ16.TCRT = DerefOf (Arg3 [One])
                                \_SB.TZ16.TTC2 = DerefOf (Arg3 [0x02])
                                \_SB.TZ16.TTC1 = Zero
                                Notify (\_SB.TZ16, 0x81) // Thermal Trip Point Change
                                Return (\_SB.TZ16.TPSV)
                            }
                            Else
                            {
                                Return (Zero)
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }

                    Break
                }
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.PMIC
                })
            }
        }

        ThermalZone (TZ17)
        {
            Name (_HID, "QCOM1ACA")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0140
                        }
                })
                Return (RBUF) /* \_SB_.TZ17._CRS.RBUF */
            }

            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.GPU0
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ17.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ17.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ17.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ17.TTC2)
            }

            Name (_TSP, One)  // _TSP: Thermal Sampling Period
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                While (One)
                {
                    Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    {
                         0x00                                             // .
                    })
                    CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.TZ17._DSM._T_0 */
                    If ((_T_0 == ToUUID ("c2d42c4b-e25e-471c-8a4e-290aac3a29a3") /* Unknown UUID */))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = Arg2
                            If ((_T_1 == Zero))
                            {
                                While (One)
                                {
                                    Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                    _T_2 = Arg1
                                    If ((_T_2 == Zero))
                                    {
                                        Return (Buffer (One)
                                        {
                                             0x03                                             // .
                                        })
                                    }

                                    Break
                                }

                                Return (Buffer (One)
                                {
                                     0x00                                             // .
                                })
                            }
                            ElseIf ((_T_1 == One))
                            {
                                \_SB.TZ17.TPSV = DerefOf (Arg3 [Zero])
                                \_SB.TZ17.TCRT = DerefOf (Arg3 [One])
                                \_SB.TZ17.TTC2 = DerefOf (Arg3 [0x02])
                                \_SB.TZ17.TTC1 = Zero
                                Notify (\_SB.TZ17, 0x81) // Thermal Trip Point Change
                                Return (\_SB.TZ17.TPSV)
                            }
                            Else
                            {
                                Return (Zero)
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }

                    Break
                }
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.PMIC
                })
            }
        }

        ThermalZone (TZ18)
        {
            Name (_HID, "QCOM1ACB")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveHigh, Shared, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0180
                        }
                })
                Return (RBUF) /* \_SB_.TZ18._CRS.RBUF */
            }

            Name (_TZD, Package (0x02)  // _TZD: Thermal Zone Devices
            {
                \_SB.WLTM, 
                \_SB.CSW0
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ18.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ18.TCRT)
            }

            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ18.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ18.TTC2)
            }

            Name (_TSP, One)  // _TSP: Thermal Sampling Period
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                While (One)
                {
                    Name (_T_0, Buffer (0x01)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                    {
                         0x00                                             // .
                    })
                    CopyObject (ToBuffer (Arg0), _T_0) /* \_SB_.TZ18._DSM._T_0 */
                    If ((_T_0 == ToUUID ("c2d42c4b-e25e-471c-8a4e-290aac3a29a3") /* Unknown UUID */))
                    {
                        While (One)
                        {
                            Name (_T_1, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                            _T_1 = Arg2
                            If ((_T_1 == Zero))
                            {
                                While (One)
                                {
                                    Name (_T_2, 0x00)  // _T_x: Emitted by ASL Compiler, x=0-9, A-Z
                                    _T_2 = Arg1
                                    If ((_T_2 == Zero))
                                    {
                                        Return (Buffer (One)
                                        {
                                             0x03                                             // .
                                        })
                                    }

                                    Break
                                }

                                Return (Buffer (One)
                                {
                                     0x00                                             // .
                                })
                            }
                            ElseIf ((_T_1 == One))
                            {
                                \_SB.TZ18.TPSV = DerefOf (Arg3 [Zero])
                                \_SB.TZ18.TCRT = DerefOf (Arg3 [One])
                                \_SB.TZ18.TTC2 = DerefOf (Arg3 [0x02])
                                \_SB.TZ18.TTC1 = Zero
                                Notify (\_SB.TZ18, 0x81) // Thermal Trip Point Change
                                Return (\_SB.TZ18.TPSV)
                            }
                            Else
                            {
                                Return (Zero)
                            }

                            Break
                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }

                    Break
                }
            }

            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.PMIC
                })
            }
        }

        ThermalZone (TZ20)
        {
            Name (_HID, "QCOM1AD7")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_TZD, Package (0x03)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0, 
                \_SB.GPU0, 
                \_SB.CSW0
            })
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ99)
        {
            Name (_HID, "QCOM1A5A")  // _HID: Hardware ID
            Name (_UID, 0x64)  // _UID: Unique ID
            Name (_TZD, Package (0x0E)  // _TZD: Thermal Zone Devices
            {
                \_SB.SYSM.CLUS.CPU0, 
                \_SB.SYSM.CLUS.CPU1, 
                \_SB.SYSM.CLUS.CPU2, 
                \_SB.SYSM.CLUS.CPU3, 
                \_SB.SYSM.CLUS.CPU4, 
                \_SB.SYSM.CLUS.CPU5, 
                \_SB.SYSM.CLUS.CPU6, 
                \_SB.SYSM.CLUS.CPU7, 
                \_SB.PEP0, 
                \_SB.GPU0.MON0, 
                \_SB.GPU0, 
                \_SB.WLTM, 
                \_SB.PMBM, 
                \_SB.CSW0
            })
            Name (TPSV, 0x0EC4)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ99.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ99.TCRT)
            }

            Name (TTC1, 0x04)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ99.TTC1)
            }

            Name (TTC2, 0x03)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ99.TTC2)
            }

            Name (TTSP, 0x0A)
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ99.TTSP)
            }

            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x01)
                {
                    \_SB.PEP0
                })
            }
        }

        ThermalZone (TZ31)
        {
            Name (_HID, "QCOM1A5D")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.ADC1
                })
            }

            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0
            })
            Name (TPSV, 0x0E2E)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ31.TPSV)
            }

            Name (TCRT, 0x0EF6)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ31.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ31.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ31.TTC2)
            }

            Name (TTSP, 0x1E)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ31.TTSP)
            }
        }

        ThermalZone (TZ32)
        {
            Name (_HID, "QCOM1A5E")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.ADC1
                })
            }

            Name (_TZD, Package (0x02)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0, 
                \_SB.GPU0
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ32.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ32.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ32.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ32.TTC2)
            }

            Name (TTSP, 0x28)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ32.TTSP)
            }
        }

        ThermalZone (TZ33)
        {
            Name (_HID, "QCOM1A5F")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.ADC1
                })
            }

            Name (_TZD, Package (0x02)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0, 
                \_SB.GPU0
            })
            Name (TPSV, 0x0E2E)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ33.TPSV)
            }

            Name (TCRT, 0x0EF6)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ33.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ33.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ33.TTC2)
            }

            Name (TTSP, 0x32)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ33.TTSP)
            }
        }

        ThermalZone (TZ34)
        {
            Name (_HID, "QCOM1A60")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.ADC1
                })
            }

            Name (_TZD, Package (0x02)  // _TZD: Thermal Zone Devices
            {
                \_SB.PEP0, 
                \_SB.GPU0
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ34.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ34.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ34.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ34.TTC2)
            }

            Name (TTSP, 0x1E)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ34.TTSP)
            }
        }

        ThermalZone (TZ35)
        {
            Name (_HID, "QCOM05C6")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.MBS0
                })
            }

            Name (_TZD, Package (0x02)  // _TZD: Thermal Zone Devices
            {
                \_SB.WLTM, 
                \_SB.MSKN
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ35.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ35.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ35.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ35.TTC2)
            }

            Name (TTSP, 0x28)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ35.TTSP)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        ThermalZone (TZ36)
        {
            Name (_HID, "QCOM05C7")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.MBS1
                })
            }

            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.MBS1
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ36.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ36.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ36.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ36.TTC2)
            }

            Name (TTSP, 0x32)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ36.TTSP)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        ThermalZone (TZ37)
        {
            Name (_HID, "QCOM05C8")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.MBS2
                })
            }

            Name (_TZD, Package (0x01)  // _TZD: Thermal Zone Devices
            {
                \_SB.MBS2
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ37.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ37.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ37.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ37.TTC2)
            }

            Name (TTSP, 0x28)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ37.TTSP)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        ThermalZone (TZ38)
        {
            Name (_HID, "QCOM1A64")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_DEP, 0, NotSerialized)  // _DEP: Dependencies
            {
                Return (Package (0x02)
                {
                    \_SB.PEP0, 
                    \_SB.ADC1
                })
            }

            Name (_TZD, Package (0x02)  // _TZD: Thermal Zone Devices
            {
                \_SB.WLTM, 
                \_SB.MSKN
            })
            Name (TPSV, 0x0E60)
            Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
            {
                Return (\_SB.TZ38.TPSV)
            }

            Name (TCRT, 0x0F28)
            Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
            {
                Return (\_SB.TZ38.TCRT)
            }

            Name (_MTL, 0x14)  // _MTL: Minimum Throttle Limit
            Name (TTC1, Zero)
            Method (_TC1, 0, NotSerialized)  // _TC1: Thermal Constant 1
            {
                Return (\_SB.TZ38.TTC1)
            }

            Name (TTC2, 0x14)
            Method (_TC2, 0, NotSerialized)  // _TC2: Thermal Constant 2
            {
                Return (\_SB.TZ38.TTC2)
            }

            Name (TTSP, 0x32)
            Name (_TZP, Zero)  // _TZP: Thermal Zone Polling
            Method (_TSP, 0, NotSerialized)  // _TSP: Thermal Sampling Period
            {
                Return (\_SB.TZ38.TTSP)
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (((\_SB.PSUB == "QRD08350") && (\_SB.PLST == 0x04)))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }
        }

        Name (HWNH, Zero)
        Device (HWN1)
        {
            Name (_HID, "QCOM1A69")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((\_SB.HWNH == Zero))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (0x0F)
                }
            }

            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.PMIC
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, Buffer (0x02)
                {
                     0x79, 0x00                                       // y.
                })
                Return (RBUF) /* \_SB_.HWN1._CRS.RBUF */
            }

            Method (HAPI, 0, NotSerialized)
            {
                Name (CFG0, Package (0x03)
                {
                    One, 
                    One, 
                    One
                })
                Return (CFG0) /* \_SB_.HWN1.HAPI.CFG0 */
            }

            Method (HAPC, 0, NotSerialized)
            {
                Name (CFG0, Package (0x16)
                {
                    Zero, 
                    0x0984, 
                    Zero, 
                    One, 
                    One, 
                    One, 
                    One, 
                    Zero, 
                    0x04, 
                    One, 
                    0x03, 
                    0x14, 
                    One, 
                    0x03, 
                    Zero, 
                    Zero, 
                    0x06, 
                    Zero, 
                    Zero, 
                    0x0535, 
                    0x03, 
                    One
                })
                Return (CFG0) /* \_SB_.HWN1.HAPC.CFG0 */
            }
        }

        Device (TSC5)
        {
            Name (_HID, "FTCH5452")  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.GIO0, 
                \_SB.I2C5
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0038, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.I2C5",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    GpioInt (Edge, ActiveLow, ExclusiveAndWake, PullUp, 0x0000,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0017
                        }
                    GpioIo (Exclusive, PullNone, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0016
                        }
                })
                Return (RBUF) /* \_SB_.TSC5._CRS.RBUF */
            }

            Name (PGID, Buffer (0x0A)
            {
                "\\_SB.TSC5"
            })
            Name (DBUF, Buffer (DBFL){})
            CreateByteField (DBUF, Zero, STAT)
            CreateByteField (DBUF, 0x02, DVAL)
            CreateField (DBUF, 0x18, 0xA0, DEID)
            Method (_S1D, 0, NotSerialized)  // _S1D: S1 Device State
            {
                Return (0x03)
            }

            Method (_S2D, 0, NotSerialized)  // _S2D: S2 Device State
            {
                Return (0x03)
            }

            Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
            {
                Return (0x03)
            }

            Method (_PS0, 0, NotSerialized)  // _PS0: Power State 0
            {
                DEID = Buffer (ESNL){}
                DVAL = Zero
                DEID = PGID /* \_SB_.TSC5.PGID */
                If (\_SB.ABD.AVBL)
                {
                    \_SB.PEP0.FLD0 = DBUF /* \_SB_.TSC5.DBUF */
                }
            }

            Method (_PS3, 0, NotSerialized)  // _PS3: Power State 3
            {
                DEID = Buffer (ESNL){}
                DVAL = 0x03
                DEID = PGID /* \_SB_.TSC5.PGID */
                If (\_SB.ABD.AVBL)
                {
                    \_SB.PEP0.FLD0 = DBUF /* \_SB_.TSC5.DBUF */
                }
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (BTNS)
        {
            Name (_HID, "ACPI0011" /* Generic Buttons Device */)  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveBoth, ExclusiveAndWake, PullDown, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0007
                        }
                    GpioInt (Edge, ActiveBoth, Exclusive, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x00C6
                        }
                    GpioInt (Edge, ActiveBoth, Exclusive, PullDown, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0006
                        }
                })
                Return (RBUF) /* \_SB_.BTNS._CRS.RBUF */
            }

            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("fa6bd625-9ce8-470d-a2c7-b3ca36c4282e") /* Generic Buttons Device */, 
                Package (0x04)
                {
                    Package (0x05)
                    {
                        Zero, 
                        One, 
                        Zero, 
                        One, 
                        0x0D
                    }, 

                    Package (0x05)
                    {
                        One, 
                        Zero, 
                        One, 
                        One, 
                        0x81
                    }, 

                    Package (0x05)
                    {
                        One, 
                        One, 
                        One, 
                        0x0C, 
                        0xE9
                    }, 

                    Package (0x05)
                    {
                        One, 
                        0x02, 
                        One, 
                        0x0C, 
                        0xEA
                    }
                }
            })
        }

        Device (RVRM)
        {
            Name (_HID, "QCOM1AF8")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (DBUS)
        {
            Name (_HID, "QCOM1AFF")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Method (CHLD, 0, NotSerialized)
            {
                Return (Package (0x01)
                {
                    Package (0x04)
                    {
                        "DBUS\\QCOM1AF0", 
                        Zero, 
                        0x09, 
                        One
                    }
                })
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0B)
            }
        }

        Device (NRCX)
        {
            Name (_HID, "QCOM1AF6")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (PSAU)
        {
            Name (_HID, "QCOM1AF1")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Scope (\_SB.RVRM)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Scope (\_SB.CCID)
        {
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (QDCI)
        {
            Name (_DEP, Package (One)  // _DEP: Dependencies
            {
                \_SB.GLNK
            })
            Name (_HID, "QCOM1A12")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
        }

        Device (FMRT)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.IC14
            })
            Name (_HID, "RTC06226")  // _HID: Hardware ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (RBUF, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0064, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.IC14",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    GpioInt (Edge, ActiveLow, Exclusive, PullUp, 0x0000,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0032
                        }
                })
                Return (RBUF) /* \_SB_.FMRT._CRS.RBUF */
            }
        }

        Device (BTH0)
        {
            Name (_HID, "QCOM1A6B")  // _HID: Hardware ID
            Alias (\_SB.PSUB, _SUB)
            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                \_SB.PEP0, 
                \_SB.PMIC, 
                \_SB.UR21
            })
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                Zero, 
                Zero
            })
            Name (_S4W, 0x02)  // _S4W: S4 Device Wake State
            Name (_S0W, 0x02)  // _S0W: S0 Device Wake State
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (PBUF, ResourceTemplate ()
                {
                    UartSerialBusV2 (0x0001C200, DataBitsEight, StopBitsOne,
                        0xC0, LittleEndian, ParityTypeNone, FlowControlHardware,
                        0x0020, 0x0020, "\\_SB.UR21",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    GpioIo (Exclusive, PullDown, 0x0000, 0x0000, IoRestrictionNone,
                        "\\_SB.GIO0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0041
                        }
                })
                Return (PBUF) /* \_SB_.BTH0._CRS.PBUF */
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }

        Device (ADC1)
        {
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                \_SB.SPMI, 
                \_SB.PMIC
            })
            Name (_HID, "QCOM1A11")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Alias (\_SB.PSUB, _SUB)
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (INTB, ResourceTemplate ()
                {
                    GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x02
                        })
                        {   // Pin list
                            0x0020
                        }
                    GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullUp, 0x0000,
                        "\\_SB.PM01", 0x00, ResourceConsumer, ,
                        RawDataBuffer (0x01)  // Vendor Data
                        {
                            0x02
                        })
                        {   // Pin list
                            0x0028
                        }
                })
                Name (NAM, Buffer (0x0A)
                {
                    "\\_SB.SPMI"
                })
                Name (VUSR, Buffer (0x0C)
                {
                    /* 0000 */  0x8E, 0x13, 0x00, 0x01, 0x00, 0xC1, 0x02, 0x00,  // ........
                    /* 0008 */  0x31, 0x01, 0x00, 0x00                           // 1...
                })
                Name (VBTM, Buffer (0x0C)
                {
                    /* 0000 */  0x8E, 0x13, 0x00, 0x01, 0x00, 0xC1, 0x02, 0x00,  // ........
                    /* 0008 */  0x34, 0x01, 0x00, 0x00                           // 4...
                })
                Concatenate (VUSR, NAM, Local1)
                Concatenate (VBTM, NAM, Local2)
                Concatenate (Local1, Local2, Local3)
                Concatenate (Local3, INTB, Local0)
                Return (Local0)
            }
        }
    }
}

