// Get Macros for parent map
#include <Library/PlatformMemoryMapLib.h>

static ARM_MEMORY_REGION_DESCRIPTOR_EX gExtendedMemoryDescriptorEx[] = {
    /* Name               Address     Length      HobOption        ResourceAttribute    ArmAttributes
                                                          ResourceType          MemoryType */
#if FixedPcdGet64(PcdMLVMBase) != 0
        {"MLVM", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Reserv, WRITE_BACK_XN},
#endif
        // RAM without this DXE: 4GB mapped region
        // MAX supported RAM Partitions: 8
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
        {"RAM Partition", 0x00000000, 0x00, NoHob, SYS_MEM, SYS_MEM_CAP, Conv, WRITE_BACK_XN},
};
