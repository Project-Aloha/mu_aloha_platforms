Method (_ROM, 3, NotSerialized)  // _ROM: Read-Only Memory
{

Name (PCFG, Buffer() {"
<?xml version='1.0' encoding='utf-8'?>
<PanelName>HX83112a</PanelName>
<PanelDescription>JDI FHD Video Mode Panel (1080x2160 24bpp)</PanelDescription>
<DisplayPrimaryFlags>0x40000</DisplayPrimaryFlags>
<Group id='Active Timing'>
 <HorizontalActive units='Dot Clocks'>1080</HorizontalActive>
 <HorizontalFrontPorch units='Dot Clocks'>32</HorizontalFrontPorch>
 <HorizontalBackPorch units='Dot Clocks'>16</HorizontalBackPorch>
 <HorizontalSyncPulse units='Dot Clocks'>2</HorizontalSyncPulse>
 <HorizontalSyncSkew units='Dot Clocks'>0</HorizontalSyncSkew>
 <HorizontalLeftBorder units='Dot Clocks'>0</HorizontalLeftBorder>
 <HorizontalRightBorder units='Dot Clocks'>0</HorizontalRightBorder>
 <VerticalActive units='Dot Clocks'>2160</VerticalActive>
 <VerticalFrontPorch units='Lines'>32</VerticalFrontPorch>
 <VerticalBackPorch units='Lines'>2</VerticalBackPorch>
 <VerticalSyncPulse units='Lines'>2</VerticalSyncPulse>
 <VerticalSyncSkew units='Lines'>0</VerticalSyncSkew>
 <VerticalTopBorder units='Lines'>0</VerticalTopBorder>
 <VerticalBottomBorder units='Lines'>0</VerticalBottomBorder>
 <InvertDataPolarity>False</InvertDataPolarity>
 <InvertVsyncPolairty>False</InvertVsyncPolairty>
 <InvertHsyncPolarity>False</InvertHsyncPolarity>
 <BorderColor>0x0</BorderColor>
</Group>
<Group id='Display Interface'>
 <InterfaceType units='QDI_DisplayConnectType'>8</InterfaceType>
 <InterfaceColorFormat units='QDI_PixelFormatType'>3</InterfaceColorFormat>
</Group>
<Group id='DSI Interface'>
 <DSIChannelId units='DSI_Channel_IDType'>1</DSIChannelId>
 <DSIVirtualId units='DSI_Display_VCType'>0</DSIVirtualId>
 <DSIColorFormat units='DSI_ColorFormatType'>36</DSIColorFormat>
 <DSITrafficMode units='DSI_TrafficModeType'>1</DSITrafficMode>
 <DSILanes units='integer'>4</DSILanes>
   <DSIHsaHseAfterVsVe units='Bool'>False</DSIHsaHseAfterVsVe>
   <DSILowPowerModeInHFP units='Bool'>False</DSILowPowerModeInHFP>
   <DSILowPowerModeInHBP units='Bool'>False</DSILowPowerModeInHBP>
   <DSILowPowerModeInHSA units='Bool'>False</DSILowPowerModeInHSA>
 <DSILowPowerModeInBLLPEOF units='Bool'>True</DSILowPowerModeInBLLPEOF>
   <DSILowPowerModeInBLLP units='Bool'>True</DSILowPowerModeInBLLP>
   <DSIRefreshRate units='integer Q16.16'>0x3C0000</DSIRefreshRate>
   <DSIPhyDCDCMode units='Bool'>True</DSIPhyDCDCMode>
 <DSIControllerMapping>
  00
 </DSIControllerMapping>
</Group>
<DSIInitSequence>
 29 b9 83 11 2a
 29 b1 08 27 27 83 83 4c 4e cc
 29 bd 01
 29 b1 64 01 09 20 50 00 00
 29 bd 00
 29 b2 00 02 00 80 70 00 02 1e fe 11 11 00 15 a3 87 00 0f d5
 29 bd 02
 29 b2 35
 29 bd 00
 29 d2 2c 2c
 29 b4 02 60 b0 70 b0 70 37 cb 01 01 0a c7 00 ff 00 ff 06 01 03 04 00 39 03 08 09 00 83
 29 bd 02
 29 b4 00 92 12 11 88 12 12 00 53
 29 bd 00
 29 b6 7f 7f e3
 29 C1 01
 29 BD 01
 29 C1 FF FB F6 F0 EB E5 E0 D7 D3 CF C9 C4 BF BA B5 B0 AB A6 A1 98 8E 86 7D 75 6D 64 5D 56 4E 47 41 3A 34 2D 26 20 1A 14 0E 08 05 04 02 01 00 25 3E 4E 88 50 8D 7D BF 0A AB DC 00
 29 BD 02
 29 C1 FF FB F6 F0 EB E6 E2 D9 D5 D1 CC C7 C3 BE B9 B5 B0 AB A7 9D 94 8C 83 7C 74 6B 63 5C 54 4D 46 40 39 31 2A 23 1D 17 10 0A 06 05 03 01 00 26 F3 AF 54 22 D8 17 C9 3B 49 D9 00
 29 BD 03
 29 C1 FF FC F7 F1 EC E7 E2 D9 D5 D1 CC C7 C3 BE B9 B4 AF AB A6 9D 94 8C 83 7C 74 6C 63 5D 56 4E 47 41 3A 33 2B 25 1E 18 12 0B 08 06 05 03 01 01 AA 06 12 8D 89 4D 09 5E E2 60 80
 29 bd 00
 29 c0 23 23
 29 cc 08
 29 d3 40 00 00 00 00 01 01 04 00 01 23 33 34 03 03 05 05 32 10 03 00 03 32 10 07 00 07 32 10 01 00 01 00 00 00 00 00 00 00 04 08 75
 29 bd 01
 29 d3 00 00 19 00 00 4a 00 a1
 29 bd 00
 29 d5 18 18 19 18 18 20 18 18 18 10 10 18 18 00 00 18 18 01 01 18 18 18 18 18 18 18 18 18 2f 2f 30 30 31 31 35 35 36 36 37 37
 29 d6 18 18 19 18 18 20 19 18 18 10 10 18 18 01 01 18 18 00 00 18 18 18 18 18 18 18 18 18 2f 2f 30 30 31 31 35 35 36 36 37 37
 29 d8 aa aa aa af ea aa aa aa aa af ea aa aa aa ab af ea aa aa aa ae af ea aa
 29 bd 01
 29 d8 aa aa ab af ea aa aa aa ae af ea aa aa aa aa af ea aa aa aa aa af ea aa
 29 bd 02
 29 d8 aa aa aa af ea aa aa aa aa af ea aa
 29 bd 03
 29 d8 ba aa aa aa bf aa aa aa aa aa bf aa aa aa aa af ea aa aa aa aa af ea aa
 29 bd 00
 29 e7 0e 0e 1e 6e 1e 6e 30 32 02 02 00 00 02 02 02 05 14 14 32 b9 23 b9 08 03
 29 bd 01
 29 e7 02 00 90 01 9c 0d 93 0e 03 03
 29 bd 02
 29 e7 00 00 08 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 8c 00 00 00 00 22 20
 29 bd 00
 29 bf 0f 00 00 83
 29 c7 70 00 04 e0 33 00
 29 cb 11 10 91 fc 00 02
 29 bd 01
 29 cb 25 11
 29 bd 00
 29 cd 01
 29 ba 73 03 64 33 31 00 00 01 10 00 00 10 08 3d 02 77 04 00 1e
 15 e4 2d
 39 b9 83 11 2a
 39 51 0f ff
 39 5e 00 00
 15 55 00
 15 53 24
 15 35 00
 05 11
 ff 78
 05 29
 ff 32
</DSIInitSequence>
<DSITermSequence>
 05 28
 ff 20
 05 10
 ff 02
</DSITermSequence>
<TLMMGPIODefaultLow>07</TLMMGPIODefaultLow>
<Group id='Backlight Configuration'>
 <BacklightType units='MDP_Panel_BacklightType'>1</BacklightType>
 <BacklightPmicControlType units='MDP_PmicBacklightControlType'>2</BacklightPmicControlType>
 <DisplayResetInfo>0 10 1000 10000 0</DisplayResetInfo>
</Group>
"})

    // There was some panel selection logic here, but we only have one panel rn
    Local2 = PCFG

    If ((Arg0 >= SizeOf (Local2)))
    {
        Return (Buffer() { 0x00 })
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