From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Thu, 19 Apr 2007 11:31:40 +0200
Message-ID: <462736FC.3090902@bull.net>
References: <462622F8.10107@bull.net> <20070419090346.GE20928@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060808010809040907060001"
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51068 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161482AbXDSJcg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2007 05:32:36 -0400
In-Reply-To: <20070419090346.GE20928@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------060808010809040907060001
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Jens Axboe wrote:
> Please tell me how you are running ffsb, and also please include a
> dmessg from a booted system.
> 
Hi,
our mails crossed! please see my response to Andrew.
You could reproduce the problem with dd command as suggested, it's more 
easy.
I'm sending you the dmesg info. For my tests I used the scsci sdc device.

Hope this help,

   Valérie


--------------060808010809040907060001
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="dmesg"
Content-Disposition: inline;
 filename="dmesg"

Linux version 2.6.21-rc7 (clementv@ext1) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Wed Apr 18 11:39:56 CEST 2007
Command line: console=ttyS0,57600n8 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
 BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff70000 (usable)
 BIOS-e820: 000000007ff70000 - 000000007ff7b000 (ACPI data)
 BIOS-e820: 000000007ff7b000 - 000000007ff80000 (ACPI NVS)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524144) 1 entries of 3200 used
end_pfn_map = 1047552
DMI 2.3 present.
ACPI: RSDP 000F6940, 0014 (r0 PTLTD )
ACPI: RSDT 7FF766C5, 0034 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FF7AE94, 0074 (r1 INTEL  LINDHRST  6040000 PTL         3)
ACPI: DSDT 7FF766F9, 479B (r1  Intel LINDHRST  6040000 MSFT  100000E)
ACPI: FACS 7FF7BFC0, 0040
ACPI: MCFG 7FF7AF08, 0040 (r1 PTLTD  	 MCFG    6040000  LTP        0)
ACPI: APIC 7FF7AF48, 0090 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 7FF7AFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
No NUMA configuration found
Faking a node at 0000000000000000-000000007ff70000
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524144) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007ff70000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      155
    0:      256 ->   524144
On node 0 totalpages: 524043
  DMA zone: 56 pages used for memmap
  DMA zone: 1829 pages reserved
  DMA zone: 2110 pages, LIFO batch:0
  DMA32 zone: 7110 pages used for memmap
  DMA32 zone: 512938 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 3, address 0xfec10000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009b000 - 000000000009c000
Nosave address range: 000000000009c000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000cc000
Nosave address range: 00000000000cc000 - 00000000000d8000
Nosave address range: 00000000000d8000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37760 bytes of per cpu data
Built 1 zonelists.  Total pages: 515048
Kernel command line: console=ttyS0,57600n8 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2793.059 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Memory: 2056596k/2096576k available (3816k kernel code, 39576k reserved, 2214k data, 336k init)
Calibrating delay using timer specific routine.. 5590.47 BogoMIPS (lpj=11180941)
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12468955
Detected 12.468 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x6
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.51 BogoMIPS (lpj=11173033)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 1/6 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5586.49 BogoMIPS (lpj=11172997)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x7
Initializing CPU#3
Calibrating delay using timer specific routine.. 5586.39 BogoMIPS (lpj=11172786)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU 3/7 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
migration_cost=3,906
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG support.
PCI: Using MMCONFIG at e0000000 - efffffff
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
0000:00:1f.1: trying to change BAR2 from 0000 to 0170
0000:00:1f.1: trying to change BAR3 from 0000 to 0374
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
Boot video device is 0000:08:01.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE1A._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE1A.PXHA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE1A.PXHB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2A._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE2B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE3A._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE3B._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIX._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs *9)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 *10 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
pnp: 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
Time: tsc clocksource has been installed.
pnp: 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
pnp: 00:01: iomem range 0xfec81000-0xfec81fff has been reserved
pnp: 00:01: iomem range 0xfec81400-0xfec823ff could not be reserved
PCI: Bridge: 0000:01:00.0
  IO window: 2000-3fff
  MEM window: d0100000-d01fffff
  PREFETCH window: 88000000-881fffff
PCI: Bridge: 0000:01:00.2
  IO window: 4000-4fff
  MEM window: d0200000-d02fffff
  PREFETCH window: 88200000-882fffff
PCI: Bridge: 0000:00:02.0
  IO window: 2000-4fff
  MEM window: d0100000-d02fffff
  PREFETCH window: 88000000-882fffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: 5000-5fff
  MEM window: d0300000-d03fffff
  PREFETCH window: d8000000-dfffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:01:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x3a set to 0x1
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:04.0 to 64
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
PCI: Setting latency timer of device 0000:00:05.0 to 64
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
PCI: Setting latency timer of device 0000:00:06.0 to 64
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
PCI: Setting latency timer of device 0000:00:07.0 to 64
Allocate Port Service[0000:00:07.0:pcie00]
Allocate Port Service[0000:00:07.0:pcie01]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:02.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:04.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:05.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:06.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:07.0:pcie01 failed with error 2
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: Processor [CPU3] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 16 (level, low) -> IRQ 16
e1000: 0000:02:01.0: e1000_probe: (PCI-X:100MHz:64-bit) 00:0e:0c:6d:b2:98
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 16 (level, low) -> IRQ 16
e1000: 0000:03:01.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:0e:0c:6d:b2:3f
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:08:02.0[A] -> GSI 25 (level, low) -> IRQ 25
e1000: 0000:08:02.0: e1000_probe: (PCI:66MHz:32-bit) 00:11:09:ab:d0:12
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:08:03.0[A] -> GSI 26 (level, low) -> IRQ 26
e1000: 0000:08:03.0: e1000_probe: (PCI:66MHz:32-bit) 00:11:09:ab:d0:13
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH5: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1460-0x1467, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1468-0x146f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: LITE-ON COMBO SOHC-4832K, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide0...
hdc: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 18 (level, low) -> IRQ 18
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
scsi 0:0:0:0: Direct-Access     MAXTOR   ATLAS10K5_73SCA  JNZ3 PQ: 0 ANSI: 3
 target0:0:0: asynchronous
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous
 target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI (6.25 ns, offset 127)
 target0:0:0: Ending Domain Validation
scsi 0:0:1:0: Direct-Access     MAXTOR   ATLAS10K5_73SCA  JNZ3 PQ: 0 ANSI: 3
 target0:0:1: asynchronous
scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
 target0:0:1: Beginning Domain Validation
 target0:0:1: wide asynchronous
 target0:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI (6.25 ns, offset 127)
 target0:0:1: Ending Domain Validation
scsi 0:0:2:0: Direct-Access     MAXTOR   ATLAS10K4_73SCA  DFV0 PQ: 0 ANSI: 3
 target0:0:2: asynchronous
scsi0:A:2:0: Tagged Queuing enabled.  Depth 32
 target0:0:2: Beginning Domain Validation
 target0:0:2: wide asynchronous
 target0:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI (6.25 ns, offset 127)
 target0:0:2: Ending Domain Validation
scsi 0:0:3:0: Direct-Access     MAXTOR   ATLAS10K5_73SCA  JNZ3 PQ: 0 ANSI: 3
 target0:0:3: asynchronous
scsi0:A:3:0: Tagged Queuing enabled.  Depth 32
 target0:0:3: Beginning Domain Validation
 target0:0:3: wide asynchronous
 target0:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI (6.25 ns, offset 127)
 target0:0:3: Ending Domain Validation
scsi 0:0:8:0: Processor         NEC      GEM318           0    PQ: 0 ANSI: 2
 target0:0:8: asynchronous
 target0:0:8: Beginning Domain Validation
 target0:0:8: Ending Domain Validation
ACPI: PCI Interrupt 0000:02:03.1[B] -> GSI 19 (level, low) -> IRQ 19
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc1 Wed Feb 14 10:14:25 PST 2007
SCSI device sda: 142969680 512-byte hdwr sectors (73200 MB)
sda: Write Protect is off
sda: Mode Sense: bf 00 10 08
SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sda: 142969680 512-byte hdwr sectors (73200 MB)
sda: Write Protect is off
sda: Mode Sense: bf 00 10 08
SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 142969680 512-byte hdwr sectors (73200 MB)
sdb: Write Protect is off
sdb: Mode Sense: bf 00 10 08
SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sdb: 142969680 512-byte hdwr sectors (73200 MB)
sdb: Write Protect is off
sdb: Mode Sense: bf 00 10 08
SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 0:0:1:0: Attached scsi disk sdb
SCSI device sdc: 142969680 512-byte hdwr sectors (73200 MB)
sdc: Write Protect is off
sdc: Mode Sense: fd 00 10 08
SCSI device sdc: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sdc: 142969680 512-byte hdwr sectors (73200 MB)
sdc: Write Protect is off
sdc: Mode Sense: fd 00 10 08
SCSI device sdc: write cache: disabled, read cache: enabled, supports DPO and FUA
 sdc: unknown partition table
sd 0:0:2:0: Attached scsi disk sdc
SCSI device sdd: 142969680 512-byte hdwr sectors (73200 MB)
sdd: Write Protect is off
sdd: Mode Sense: bf 00 10 08
SCSI device sdd: write cache: disabled, read cache: enabled, supports DPO and FUA
SCSI device sdd: 142969680 512-byte hdwr sectors (73200 MB)
sdd: Write Protect is off
sdd: Mode Sense: bf 00 10 08
SCSI device sdd: write cache: disabled, read cache: enabled, supports DPO and FUA
 sdd: unknown partition table
sd 0:0:3:0: Attached scsi disk sdd
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:2:0: Attached scsi generic sg2 type 0
sd 0:0:3:0: Attached scsi generic sg3 type 0
scsi 0:0:8:0: Attached scsi generic sg4 type 3
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd0001400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001420
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
/home/clementv/src/linux-2.6.21-rc7/drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
/home/clementv/src/linux-2.6.21-rc7/drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: linear personality registered for level -1
md: raid0 personality registered for level 0
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Intel 810 + AC97 Audio, version 1.01, 11:37:55 Apr 18 2007
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 336k freed
Adding 6024332k swap on /dev/sda7.  Priority:-1 extents:1 across:6024332k
md: md0 stopped.
QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 16 (level, low) -> IRQ 16
qla2xxx 0000:02:02.0: Found an ISP2312, irq 16, iobase 0xffffc20000016000
qla2xxx 0000:02:02.0: Configuring PCI space...
qla2xxx 0000:02:02.0: Configure NVRAM parameters...
qla2xxx 0000:02:02.0: Verifying loaded RISC code...
qla2xxx 0000:02:02.0: Allocated (412 KB) for firmware dump...
scsi2 : qla2xxx
qla2xxx 0000:02:02.0: LIP reset occured (f8f7).
qla2xxx 0000:02:02.0: LIP occured (f8f7).
qla2xxx 0000:02:02.0: LOOP UP detected (2 Gbps).
scsi 2:0:0:0: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
SCSI device sde: 4269790986 512-byte hdwr sectors (2186133 MB)
qla2xxx 0000:02:02.0: 
 QLogic Fibre Channel HBA Driver: 8.01.07-k5
  QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
  ISP2312: PCI-X (100 MHz) @ 0000:02:02.0 hdma-, host#=2, fw=3.03.20 IPX
sde: Write Protect is off
sde: Mode Sense: 77 00 10 08
SCSI device sde: write cache: enabled, read cache: enabled, supports DPO and FUA
SCSI device sde: 4269790986 512-byte hdwr sectors (2186133 MB)
sde: Write Protect is off
sde: Mode Sense: 77 00 10 08
SCSI device sde: write cache: enabled, read cache: enabled, supports DPO and FUA
 sde: unknown partition table
sd 2:0:0:0: Attached scsi disk sde
sd 2:0:0:0: Attached scsi generic sg5 type 0
scsi 2:0:0:1: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
SCSI device sdf: 4269790986 512-byte hdwr sectors (2186133 MB)
sdf: Write Protect is off
sdf: Mode Sense: 77 00 10 08
SCSI device sdf: write cache: enabled, read cache: enabled, supports DPO and FUA
SCSI device sdf: 4269790986 512-byte hdwr sectors (2186133 MB)
sdf: Write Protect is off
sdf: Mode Sense: 77 00 10 08
SCSI device sdf: write cache: enabled, read cache: enabled, supports DPO and FUA
 sdf: unknown partition table
sd 2:0:0:1: Attached scsi disk sdf
sd 2:0:0:1: Attached scsi generic sg6 type 0
scsi 2:0:0:2: Direct-Access     IBM      1724-100  FAStT  0542 PQ: 0 ANSI: 3
SCSI device sdg: 2385539072 512-byte hdwr sectors (1221396 MB)
sdg: Write Protect is off
sdg: Mode Sense: 77 00 10 08
SCSI device sdg: write cache: enabled, read cache: enabled, supports DPO and FUA
SCSI device sdg: 2385539072 512-byte hdwr sectors (1221396 MB)
sdg: Write Protect is off
sdg: Mode Sense: 77 00 10 08
SCSI device sdg: write cache: enabled, read cache: enabled, supports DPO and FUA
 sdg: unknown partition table
sd 2:0:0:2: Attached scsi disk sdg
sd 2:0:0:2: Attached scsi generic sg7 type 0
scsi 2:0:0:31: Direct-Access     IBM      Universal Xport  0542 PQ: 0 ANSI: 3
scsi 2:0:0:31: Attached scsi generic sg8 type 0
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
XFS mounting filesystem sdc
Ending clean XFS mount for filesystem: sdc

--------------060808010809040907060001--
