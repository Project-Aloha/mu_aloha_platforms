/* TB311FU early USB console, experimental menu service.
 * Register definitions follow Linux drivers/usb/musb/musb_regs.h (GPL-2.0).
 * SPDX-License-Identifier: GPL-2.0-only
 * Full-speed CDC ACM, polled PIO. Caller owns power/clock/PHY and serializes
 * calls with local DAIF masked; this is deliberately single-CPU bring-up code.
 */
#ifndef TB311FU_MUSB_CDC_H
#define TB311FU_MUSB_CDC_H
typedef UINT8 uint8_t;
typedef UINT16 uint16_t;
typedef UINT32 uint32_t;
typedef UINT64 uint64_t;
typedef UINTN uintptr_t;
static void ConsoleReceive(uint8_t c);
#define TBUSB_RING_SIZE 32768U
struct tbusb_state {
 uintptr_t base;
 uint64_t connect_at;
 uint32_t head, tail, dropped, resets, packets;
 uint16_t hwvers, control_left, control_pos;
 uint8_t active, connected, configured, address_pending, address, control_out;
 uint8_t control_zlp, bulk_zlp, status_pending, control_data[128];
 uint8_t ring[TBUSB_RING_SIZE];
};
static struct tbusb_state tbusb __attribute__((section(".data"))) = {0};
static uint8_t tbusb_r8(unsigned r) { return *(volatile uint8_t *)(tbusb.base+r); }
static uint16_t tbusb_r16(unsigned r) { return *(volatile uint16_t *)(tbusb.base+r); }
static void tbusb_w8(unsigned r,uint8_t v) { *(volatile uint8_t *)(tbusb.base+r)=v; }
static void tbusb_w16(unsigned r,uint16_t v) { *(volatile uint16_t *)(tbusb.base+r)=v; }
static void tbusb_barrier(void) { __asm__ volatile("dsb oshst" ::: "memory"); }
static const uint8_t tbusb_device[] = {
 18,1,0,2,2,0,0,64, 0x09,0x12,0x01,0x00, 0,1,1,2,3,1
};
/* Experimental VID/PID 1209:0001, not an allocated production identity. */
static const uint8_t tbusb_config[] = {
 9,2,67,0,2,1,0,0x80,50,
 9,4,0,0,1,2,2,1,0,
 5,0x24,0,0x10,1, 5,0x24,1,0,1, 4,0x24,2,2, 5,0x24,6,0,1,
 7,5,0x81,3,8,0,16,
 9,4,1,0,2,0x0a,0,0,0,
 7,5,0x02,2,64,0,0, 7,5,0x82,2,64,0,0,
};
static const uint8_t tbusb_line[] = {0,0xc2,1,0,0,0,8}; /* 115200 8N1 */
static void tbusb_endpoints(void)
{
 tbusb_w8(0x0e,1); tbusb_w8(0x62,3); tbusb_w16(0x64,8);
 tbusb_w16(0x10,8); tbusb_w16(0x12,0x2048);
 tbusb_w8(0x0e,2);
 tbusb_w8(0x62,3); tbusb_w16(0x64,16);
 tbusb_w8(0x63,3); tbusb_w16(0x66,24);
 tbusb_w16(0x10,64); tbusb_w16(0x14,64);
 tbusb_w16(0x12,0x2048); tbusb_w16(0x16,0x90);
 tbusb_w8(0x0e,3);
 tbusb_w8(0x62,3);tbusb_w16(0x64,32);
 tbusb_w8(0x63,3);tbusb_w16(0x66,40);
 tbusb_w16(0x10,64);tbusb_w16(0x14,64);
 tbusb_w16(0x12,0x2048);tbusb_w16(0x16,0x90);
 tbusb_w8(0x0e,0);
}
static void tbusb_control_send(void)
{
 unsigned n=tbusb.control_left;
 if(n>64) n=64;
 for(unsigned i=0;i<n;i++) tbusb_w8(0x20,tbusb.control_data[tbusb.control_pos++]);
 tbusb.control_left=(uint16_t)(tbusb.control_left-n);
 uint16_t csr=2;
 if(!tbusb.control_left && !tbusb.control_zlp) csr|=8;
 if(!n) { csr|=8; tbusb.control_zlp=0; }
 tbusb_w16(0x12,csr);
}
static void tbusb_control_reply(const uint8_t *data,unsigned count,unsigned requested)
{
 if(count>requested) count=requested;
 if(count>sizeof(tbusb.control_data)) count=sizeof(tbusb.control_data);
 for(unsigned i=0;i<count;i++) tbusb.control_data[i]=data[i];
 tbusb.control_pos=0; tbusb.control_left=(uint16_t)count;
 tbusb.control_zlp=(uint8_t)(count && !(count%64) && count<requested);
 tbusb_w16(0x12,0x40); /* service SETUP before filling the TX FIFO */
}
static unsigned tbusb_string(uint8_t *out,const char *s)
{
 unsigned i=2;
 while(*s && i<126) {out[i++]=(uint8_t)*s++;out[i++]=0;}
 out[0]=(uint8_t)i;out[1]=3;return i;
}
static void tbusb_setup(const uint8_t *s)
{
 unsigned value=s[2]|((unsigned)s[3]<<8), index=s[4]|((unsigned)s[5]<<8);
 unsigned length=s[6]|((unsigned)s[7]<<8);
 uint8_t reply[128]; unsigned n=0;
 reply[0]=0;reply[1]=0;
 tbusb.control_left=0;tbusb.control_zlp=0;tbusb.control_out=0;
 tbusb.address_pending=0;tbusb.status_pending=0;
 if(s[0]==0x80 && s[1]==6) {
  if((value>>8)==1 && !(value&255)) {tbusb_control_reply(tbusb_device,sizeof(tbusb_device),length);return;}
  if((value>>8)==2 && !(value&255)) {tbusb_control_reply(tbusb_config,sizeof(tbusb_config),length);return;}
  if((value>>8)==3) {
   switch(value&255) {
   case 0: reply[0]=4;reply[1]=3;reply[2]=9;reply[3]=4;n=4;break;
   case 1:n=tbusb_string(reply,"Lenovo UEFI");break;
   case 2:n=tbusb_string(reply,"TB311FU UEFI console");break;
   case 3:n=tbusb_string(reply,"TB311FU-UEFI");break;
   default:break;
   }
   if(n) {tbusb_control_reply(reply,n,length);return;}
  }
 } else if(s[0]==0 && s[1]==5 && !index && !length && value<128) {
  tbusb.address=(uint8_t)value;tbusb.address_pending=1;tbusb.status_pending=1;
  tbusb_w16(0x12,0x48);return;
 } else if(s[0]==0 && s[1]==9 && !index && !length && value<=1) {
  tbusb.configured=(uint8_t)value;tbusb_endpoints();tbusb_w16(0x12,0x48);return;
 } else if(s[0]==0x80 && s[1]==8 && !value && !index) {
  reply[0]=tbusb.configured;tbusb_control_reply(reply,1,length);return;
 } else if((s[0]==0x80 || s[0]==0x81 || s[0]==0x82) && s[1]==0 && !value) {
  tbusb_control_reply(reply,2,length);return;
 } else if(s[0]==0x81 && s[1]==10 && !value && index<3) {
  tbusb_control_reply(reply,1,length);return;
 } else if(s[0]==1 && s[1]==11 && !value && index<3 && !length) {
  tbusb_w16(0x12,0x48);return;
 } else if(s[0]==0x21 && s[1]==0x20 && !value && !index && length==7) {
  tbusb.control_out=1;tbusb_w16(0x12,0x40);return;
 } else if(s[0]==0xa1 && s[1]==0x21 && !value && !index) {
  tbusb_control_reply(tbusb_line,sizeof(tbusb_line),length);return;
 } else if(s[0]==0x21 && s[1]==0x22 && !index && !length) {
  tbusb_w16(0x12,0x48);return; /* DTR is optional: boot must not wait for host. */
 } else if(s[0]==2 && s[1]==1 && !value && !length && (index==0x82 || index==2 || index==0x81 || index==3 || index==0x83)) {
  tbusb_w8(0x0e,index&15);
  if(index&0x80) tbusb_w16(0x12,0x2048); else tbusb_w16(0x16,0x90);
  tbusb_w8(0x0e,0);tbusb_w16(0x12,0x48);return;
 }
 tbusb_w16(0x12,0x60); /* unsupported request: service RX and STALL */
}
static void tbusb_queue_locked(char c);
/* No spin/poll waits: one control packet and one 64-byte bulk packet per call. */
static void tbusb_poll_locked(void)
{
 if(!tbusb.active) return;
 if(!tbusb.connected) {
  uint64_t now; __asm__ volatile("mrs %0, cntpct_el0" : "=r"(now));
  if(now<tbusb.connect_at) return;
  tbusb_w8(1,0x40);tbusb.connected=1;
 }
 uint8_t saved=tbusb_r8(0x0e);
 uint8_t intr=tbusb_r8(0x0a);
 uint16_t txintr=tbusb_r16(0x02),rxintr=tbusb_r16(0x04);
 /* MediaTek's MUSB is W1C, unlike the Mentor read-clear variant.
  * Without these writes RESET remains set and every poll resets FADDR. */
 tbusb_w8(0x0a,intr);tbusb_w16(0x02,txintr);tbusb_w16(0x04,rxintr);
 if(intr&4) {
  tbusb.resets++;tbusb.configured=0;tbusb.address_pending=0;tbusb.status_pending=0;
  tbusb.control_left=0;tbusb.control_zlp=0;tbusb.control_out=0;tbusb.bulk_zlp=0;
  tbusb_w8(0,0);tbusb_endpoints();
 }
 tbusb_w8(0x0e,0);
 uint16_t csr=tbusb_r16(0x12);
 if(csr&4) {tbusb_w16(0x12,0);csr=tbusb_r16(0x12);}
 if(csr&0x10) {
  tbusb_w16(0x12,0x80);tbusb.control_left=0;tbusb.control_zlp=0;tbusb.control_out=0;
  tbusb.address_pending=0;tbusb.status_pending=0;csr=tbusb_r16(0x12);
 }
 if(tbusb.status_pending && (txintr&1) && !(csr&0x0a)) {
  if(tbusb.address_pending) {tbusb_w8(0,tbusb.address);tbusb.address_pending=0;}
  tbusb.status_pending=0;
 }
 if(csr&1) {
  unsigned count=tbusb_r16(0x18);uint8_t setup[8]={0};
  if(count>64) {tbusb_w16(0x12,0x160);goto out;}
  for(unsigned i=0;i<count;i++) {uint8_t b=tbusb_r8(0x20);if(i<8) setup[i]=b;}
  if(tbusb.control_out) {
   tbusb.control_out=0;tbusb_w16(0x12,count==7?0x48:0x60);
  } else if(count==8) tbusb_setup(setup);
  else tbusb_w16(0x12,0x40); /* zero-length status OUT */
 } else if(!(csr&3) && (tbusb.control_left || tbusb.control_zlp)) tbusb_control_send();
 if(tbusb.configured) {
  tbusb_w8(0x0e,2);
  csr=tbusb_r16(0x16);
  if(csr&1) {
   unsigned count=tbusb_r16(0x18);if(count>64) count=64;
   for(unsigned i=0;i<count;i++) {
    uint8_t c=tbusb_r8(0x28);
    ConsoleReceive(c);
   }
   tbusb_w16(0x16,(uint16_t)(csr&~1U)); /* echo received bytes */
  }
  if((tbusb.head!=tbusb.tail || tbusb.bulk_zlp) && !(tbusb_r16(0x12)&3)) {
   unsigned n=tbusb.head-tbusb.tail;if(n>64)n=64;
   for(unsigned i=0;i<n;i++) tbusb_w8(0x28,tbusb.ring[tbusb.tail++&(TBUSB_RING_SIZE-1)]);
   tbusb.bulk_zlp=(uint8_t)(n==64);
   tbusb_barrier();tbusb_w16(0x12,0x2001);tbusb.packets++;
  }
 }
out:
 tbusb_barrier();tbusb_w8(0x0e,saved);
}
/* Called only after the MMIO mapping exists and its clocked state is verified. */
static int tbusb_init_locked(uintptr_t base)
{
 tbusb.base=base;
 tbusb.hwvers=tbusb_r16(0x6c);
 uint8_t epinfo=tbusb_r8(0x78),devctl=tbusb_r8(0x60);
 if(tbusb.hwvers==0 || tbusb.hwvers==0xffff || (epinfo&15)<3 || (epinfo>>4)<3 || (devctl&4)) {
  tbusb.base=0;return 0;
 }
 tbusb_w8(0x0e,0);
 if(!(tbusb_r8(0x1f)&4)) {tbusb.base=0;return 0;} /* dynamic FIFO required */
 tbusb_w8(1,0); /* disconnect and force full-speed (HSENAB clear) */
 tbusb_w16(6,0);tbusb_w16(8,0);tbusb_w8(0x0b,0); /* no GIC interrupts */
 /* Disable all inherited DMA channels before taking over their endpoint FIFO. */
 for(unsigned i=0;i<8;i++) tbusb_w16(0x204+16*i,0);
 tbusb_w8(0,0);tbusb_endpoints();
 tbusb_w8(0x0a,tbusb_r8(0x0a));tbusb_w16(2,tbusb_r16(2));tbusb_w16(4,tbusb_r16(4));
 uint64_t now,hz;
 __asm__ volatile("mrs %0, cntpct_el0" : "=r"(now));
 __asm__ volatile("mrs %0, cntfrq_el0" : "=r"(hz));
 tbusb.connect_at=now+hz/100; /* 10 ms disconnect, without waiting */
 tbusb.configured=0;tbusb.address_pending=0;tbusb.status_pending=0;
 tbusb.control_left=0;tbusb.control_zlp=0;tbusb.control_out=0;tbusb.bulk_zlp=0;
 tbusb.head=tbusb.tail=0;
 tbusb.active=1;tbusb.connected=0;tbusb_barrier();
 return 1;
}
static void tbusb_queue_locked(char c)
{
 if(tbusb.head-tbusb.tail>=TBUSB_RING_SIZE) {tbusb.tail++;tbusb.dropped++;}
 tbusb.ring[tbusb.head++&(TBUSB_RING_SIZE-1)]=(uint8_t)c;
}
static void tbusb_stop_locked(void)
{
 if(tbusb.active) {tbusb_w8(1,0);tbusb_w16(6,0);tbusb_w16(8,0);tbusb_w8(0x0b,0);}
 tbusb.active=0;
}
#endif
