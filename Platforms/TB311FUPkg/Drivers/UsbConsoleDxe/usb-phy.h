/* SPDX-License-Identifier: GPL-2.0-only
 * Single CPU, masked interrupts, no DMA. Started automatically with the menu.
 * Engine adapted from ipadOs-port-steps/usb-console/musb-cdc.h.
 */
#pragma once
#include "musb-cdc.h"
static uint32_t usb_reg(uintptr_t address) {
 uint32_t v=*(volatile uint32_t *)address;
 __asm__ volatile("dsb sy" ::: "memory");
 return v;
}
/* Resume sequence from phy-mtk-tphy.c u2_phy_instance_power_on(),
 * device role from u2_phy_instance_set_mode(). Keep LK's trim/calibration.
 */
static void usb_write(uintptr_t a,uint32_t v) {
 *(volatile uint32_t *)a=v;
 __asm__ volatile("dsb sy" ::: "memory");
}
static void usb_phy_change(unsigned offset,uint32_t clear,uint32_t set) {
 uintptr_t a=0x11cc0800UL+offset;
 usb_write(a,(usb_reg(a)&~clear)|set);
}
static void usb_delay(unsigned us) {
 uint64_t hz,start,now;
 __asm__ volatile("mrs %0,cntfrq_el0":"=r"(hz));
 __asm__ volatile("mrs %0,cntpct_el0":"=r"(start));
 do {__asm__ volatile("mrs %0,cntpct_el0":"=r"(now));}while(now-start<hz*us/1000000);
}
static void usb_phy_resume(void) {
 usb_phy_change(0x00,0,1U<<5); /* analog bandgap/interrupt enable */
 usb_phy_change(0x14,1U<<11,0);
 usb_phy_change(0x68,0,1U<<18);
 usb_phy_change(0x68,1U<<3,0);
 usb_phy_change(0x68,0,1U<<3);
 usb_delay(30);
 usb_phy_change(0x68,1U<<18,0);
 usb_phy_change(0x68,(1U<<3)|(1U<<26),0);
 usb_phy_change(0x6c,1U<<16,0);
 usb_phy_change(0x20,3U<<8,0);
 usb_phy_change(0x68,(0xfU<<10)|(3U<<4)|(1U<<23)|(3U<<20)|
     (7U<<17)|(3U<<6)|(1U<<2),0);
 usb_phy_change(0x18,1U<<23,1U<<20); /* retain board REV6/trim */
 usb_phy_change(0x6c,1U<<4,(1U<<5)|(1U<<2)|(1U<<9)|(1U<<1));
 usb_delay(800);
}
static const unsigned usb_phy_offsets[]={0x00,0x14,0x18,0x20,0x68,0x6c};
static uint32_t usb_phy_state[6] __attribute__((section(".data")))={0};
static int usb_service_start(void) {
 if(tbusb.active)return 1;
 if((usb_reg(0x10001090UL)&(1U<<8)) ||
    (usb_reg(0x10000090UL)&(1U<<23)))return 0;
 if(!tbusb_init_locked(0x11200000UL))return 0;
 for(unsigned i=0;i<6;i++)usb_phy_state[i]=usb_reg(0x11cc0800UL+usb_phy_offsets[i]);
 usb_phy_resume();return 1;
}
static void usb_service_stop(void) {
 if(!tbusb.active)return;
 tbusb_stop_locked();
 for(unsigned i=0;i<6;i++)usb_write(0x11cc0800UL+usb_phy_offsets[i],usb_phy_state[i]);
}
