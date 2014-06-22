From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78721] VFS: brelse: Trying to free free buffer
Date: Sun, 22 Jun 2014 21:27:32 +0000
Message-ID: <bug-78721-13602-Lo8mzKUw7p@https.bugzilla.kernel.org/>
References: <bug-78721-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44350 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaFVV1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jun 2014 17:27:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DE57D2024F
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 21:27:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5451F2021B
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 21:27:32 +0000 (UTC)
In-Reply-To: <bug-78721-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78721

--- Comment #1 from Deweloper <deweloper@wp.pl> ---
Comment on attachment 140641
  --> https://bugzilla.kernel.org/attachment.cgi?id=140641
dmesg

>[    0.000000] Linux version 3.15.1 (olek@lapciok) (gcc version 4.6.3 (Buildroot 2012.05) ) #6 Sun Jun 22 13:12:40 CEST 2014
>[    0.000000] KERNEL supported cpus:
>[    0.000000]   Intel GenuineIntel
>[    0.000000]   AMD AuthenticAMD
>[    0.000000]   Transmeta GenuineTMx86
>[    0.000000]   Transmeta TransmetaCPU
>[    0.000000] e820: BIOS-provided physical RAM map:
>[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
>[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
>[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000003ffffff] usable
>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>[    0.000000] BIOS-e820: [mem 0x00000000fffe0000-0x00000000ffffffff] reserved
>[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
>[    0.000000] DMI not present or invalid.
>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>[    0.000000] e820: last_pfn = 0x4000 max_arch_pfn = 0x100000
>[    0.000000] initial memory mapped: [mem 0x00000000-0x00ffffff]
>[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>[    0.000000] init_memory_mapping: [mem 0x03c00000-0x03ffffff]
>[    0.000000]  [mem 0x03c00000-0x03ffffff] page 2M
>[    0.000000] init_memory_mapping: [mem 0x00100000-0x03bfffff]
>[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
>[    0.000000]  [mem 0x00400000-0x03bfffff] page 2M
>[    0.000000] ACPI BIOS Error (bug): A valid RSDP was not found (20140214/tbxfroot-211)
>[    0.000000] 64MB LOWMEM available.
>[    0.000000]   mapped low ram: 0 - 04000000
>[    0.000000]   low ram: 0 - 04000000
>[    0.000000] Zone ranges:
>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
>[    0.000000]   Normal   [mem 0x01000000-0x03ffffff]
>[    0.000000] Movable zone start for each node
>[    0.000000] Early memory node ranges
>[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
>[    0.000000]   node   0: [mem 0x00100000-0x03ffffff]
>[    0.000000] On node 0 totalpages: 16286
>[    0.000000] free_area_init_node: node 0, pgdat c03e99a0, node_mem_map c3f80020
>[    0.000000]   DMA zone: 32 pages used for memmap
>[    0.000000]   DMA zone: 0 pages reserved
>[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
>[    0.000000]   Normal zone: 96 pages used for memmap
>[    0.000000]   Normal zone: 12288 pages, LIFO batch:1
>[    0.000000] Using APIC driver default
>[    0.000000] No local APIC present or hardware disabled
>[    0.000000] APIC: disable apic facility
>[    0.000000] APIC: switched to apic NOOP
>[    0.000000] e820: [mem 0x04000000-0xfebfffff] available for PCI devices
>[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
>[    0.000000] pcpu-alloc: [0] 0 
>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16158
>[    0.000000] Kernel command line: panic=30 consoleblank=0 console=tty0 console=ttyS1,57600n8 ieee80211_regdom=PL DDNS=system-ns SYSTEM_NS_DOMAIN=xxxxxxxxx SYSTEM_NS_TOKEN=xxxxxxxxx BOOT_IMAGE=/boot/kernel.img 
>[    0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
>[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
>[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
>[    0.000000] Initializing CPU#0
>[    0.000000] Memory: 54500K/65144K available (2145K kernel code, 194K rwdata, 652K rodata, 6752K init, 172K bss, 10644K reserved)
>[    0.000000] virtual kernel memory layout:
>[    0.000000]     fixmap  : 0xfffe3000 - 0xfffff000   ( 112 kB)
>[    0.000000]     vmalloc : 0xc4800000 - 0xfffe1000   ( 951 MB)
>[    0.000000]     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
>[    0.000000]       .init : 0xc03ef000 - 0xc0a87000   (6752 kB)
>[    0.000000]       .data : 0xc0318816 - 0xc03edae0   ( 852 kB)
>[    0.000000]       .text : 0xc0100000 - 0xc0318816   (2146 kB)
>[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
>[    0.000000] NR_IRQS:16 nr_irqs:16 16
>[    0.000000] CPU 0 irqstacks, hard=c3802000 soft=c3804000
>[    0.000000] Console: colour dummy device 80x25
>[    0.000000] console [tty0] enabled
>[    0.000000] console [ttyS1] enabled
>[    0.000000] tsc: Fast TSC calibration using PIT
>[    0.000000] tsc: Detected 99.662 MHz processor
>[    0.030048] Calibrating delay loop (skipped), value calculated using timer frequency.. 199.32 BogoMIPS (lpj=996620)
>[    0.045390] pid_max: default: 32768 minimum: 301
>[    0.050620] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
>[    0.060093] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
>[    0.082101] Intel Pentium with F0 0F bug - workaround enabled.
>[    0.090177] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
>[    0.090177] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
>[    0.090177] tlb_flushall_shift: -1
>[    0.100038] CPU: Intel Pentium 75 - 200 (fam: 05, model: 02, stepping: 0c)
>[    0.118091] Performance Events: no PMU driver, software events only.
>[    0.135680] NMI watchdog: disabled (cpu0): hardware events not enabled
>[    0.160518] NET: Registered protocol family 16
>[    0.175873] cpuidle: using governor ladder
>[    0.180067] cpuidle: using governor menu
>[    0.217716] PCI: PCI BIOS revision 2.10 entry at 0xfdb91, last bus=0
>[    0.220061] PCI: Using configuration type 1 for base access
>[    0.288580] ACPI: Interpreter disabled.
>[    0.301312] PCI: Probing PCI hardware
>[    0.308810] PCI: root bus 00: using default resources
>[    0.308898] PCI: Probing PCI hardware (bus 00)
>[    0.312361] PCI host bridge to bus 0000:00
>[    0.320155] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
>[    0.330121] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
>[    0.340098] pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
>[    0.350305] pci 0000:00:00.0: [8086:7030] type 00 class 0x060000
>[    0.354050] pci 0000:00:07.0: [8086:7000] type 00 class 0x060100
>[    0.361692] pci 0000:00:07.1: [8086:7010] type 00 class 0x010180
>[    0.361915] pci 0000:00:07.1: reg 0x20: [io  0xffa0-0xffaf]
>[    0.362051] pci 0000:00:07.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
>[    0.370113] pci 0000:00:07.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
>[    0.380106] pci 0000:00:07.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
>[    0.390101] pci 0000:00:07.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
>[    0.411657] pci 0000:00:07.2: [8086:7020] type 00 class 0x0c0300
>[    0.411865] pci 0000:00:07.2: reg 0x20: [io  0x7f80-0x7f9f]
>[    0.415788] pci 0000:00:08.0: [1131:7134] type 00 class 0x048000
>[    0.415947] pci 0000:00:08.0: reg 0x10: [mem 0xffaffc00-0xffafffff]
>[    0.416212] pci 0000:00:08.0: supports D1 D2
>[    0.420332] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
>[    0.421519] PCI: pci_cache_line_size set to 32 bytes
>[    0.421682] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
>[    0.431906] Switched to clocksource pit
>[    0.441569] pnp: PnP ACPI: disabled
>[    0.448809] PnPBIOS: Scanning system for PnP BIOS support...
>[    0.460731] PnPBIOS: Found PnP BIOS installation structure at 0xc00f5cf0
>[    0.474382] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x57ac, dseg 0xf0000
>[    0.480127] pnp 00:00: [mem 0x00000000-0x0009ffff]
>[    0.480240] pnp 00:00: [mem 0x000e0000-0x000fffff]
>[    0.482629] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
>[    0.496969] system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
>[    0.501204] system 00:00: Plug and Play BIOS device, IDs PNP0c01 (active)
>[    0.501482] pnp 00:01: [io  0x0020-0x0021]
>[    0.501599] pnp 00:01: [io  0x00a0-0x00a1]
>[    0.501714] pnp 00:01: [irq 2]
>[    0.503980] pnp 00:01: Plug and Play BIOS device, IDs PNP0000 (active)
>[    0.504206] pnp 00:02: [dma 4]
>[    0.504306] pnp 00:02: [io  0x0000-0x000f]
>[    0.504407] pnp 00:02: [io  0x0080-0x0090]
>[    0.504506] pnp 00:02: [io  0x0094-0x009f]
>[    0.504604] pnp 00:02: [io  0x00c0-0x00de]
>[    0.506461] pnp 00:02: Plug and Play BIOS device, IDs PNP0200 (active)
>[    0.506708] pnp 00:03: [irq 0]
>[    0.506820] pnp 00:03: [io  0x0040-0x0043]
>[    0.508968] pnp 00:03: Plug and Play BIOS device, IDs PNP0100 (active)
>[    0.509250] pnp 00:04: [irq 8]
>[    0.509371] pnp 00:04: [io  0x0070-0x0071]
>[    0.511669] pnp 00:04: Plug and Play BIOS device, IDs PNP0b00 (active)
>[    0.511921] pnp 00:05: [irq 1]
>[    0.512019] pnp 00:05: [io  0x0060]
>[    0.512116] pnp 00:05: [io  0x0064]
>[    0.513963] pnp 00:05: Plug and Play BIOS device, IDs PNP0303 (active)
>[    0.514214] pnp 00:06: [io  0x0061]
>[    0.516229] pnp 00:06: Plug and Play BIOS device, IDs PNP0800 (active)
>[    0.516509] pnp 00:07: [irq 13]
>[    0.516629] pnp 00:07: [io  0x00f0-0x00ff]
>[    0.519121] pnp 00:07: Plug and Play BIOS device, IDs PNP0c04 (active)
>[    0.521074] pnp 00:08: Plug and Play BIOS device, IDs PNP0a03 (disabled)
>[    0.521366] pnp 00:09: [io  0x03f0-0x03f5]
>[    0.521472] pnp 00:09: [irq 6]
>[    0.521575] pnp 00:09: [dma 2]
>[    0.523811] pnp 00:09: Plug and Play BIOS device, IDs PNP0700 (active)
>[    0.524178] pnp 00:0a: [io  0x03f8-0x03ff]
>[    0.524294] pnp 00:0a: [irq 4]
>[    0.527343] pnp 00:0a: Plug and Play BIOS device, IDs PNP0501 (active)
>[    0.527674] pnp 00:0b: [io  0x02f8-0x02ff]
>[    0.527775] pnp 00:0b: [irq 3]
>[    0.530398] pnp 00:0b: Plug and Play BIOS device, IDs PNP0501 (active)
>[    0.530822] pnp 00:0c: [io  0x0378-0x037f]
>[    0.530941] pnp 00:0c: [io  0x0000-0xffffffff disabled]
>[    0.531054] pnp 00:0c: [irq 7]
>[    0.531173] pnp 00:0c: [dma 4294967295 disabled]
>[    0.534371] pnp 00:0c: Plug and Play BIOS device, IDs PNP0400 (active)
>[    0.534661] pnp 00:0d: [io  0x04d0-0x04d1]
>[    0.534762] pnp 00:0d: [io  0x0cf8-0x0cff]
>[    0.534857] pnp 00:0d: [io  0x03f7]
>[    0.534962] pnp 00:0d: [mem 0xfffe0000-0xffffffff]
>[    0.535065] pnp 00:0d: [mem 0x00100000-0x03ffffff]
>[    0.535170] pnp 00:0d: [io  0x0000-0xffffffff disabled]
>[    0.537477] system 00:0d: [io  0x04d0-0x04d1] has been reserved
>[    0.539737] system 00:0d: [io  0x0cf8-0x0cff] could not be reserved
>[    0.552606] system 00:0d: [io  0x03f7] has been reserved
>[    0.563563] system 00:0d: [mem 0xfffe0000-0xffffffff] has been reserved
>[    0.577167] system 00:0d: [mem 0x00100000-0x03ffffff] could not be reserved
>[    0.581388] system 00:0d: Plug and Play BIOS device, IDs PNP0c02 (active)
>[    0.581487] PnPBIOS: 14 nodes reported by PnP BIOS; 14 recorded by driver
>[    0.767089] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
>[    0.767196] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
>[    0.767813] NET: Registered protocol family 2
>[    0.782604] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
>[    0.796913] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
>[    0.799934] TCP: Hash tables configured (established 1024 bind 1024)
>[    0.813584] TCP: reno registered
>[    0.820307] UDP hash table entries: 256 (order: 0, 4096 bytes)
>[    0.832284] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
>[    0.848325] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
>[    0.860514] pci 0000:00:07.0: Activating ISA DMA hang workarounds
>[    0.873150] PCI: CLS 0 bytes, default 32
>[    6.992791] futex hash table entries: 256 (order: -1, 3072 bytes)
>[    7.023809] msgmni has been set to 106
>[    7.113411] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
>[    7.118582] io scheduler noop registered
>[    7.126571] io scheduler deadline registered (default)
>[    7.159690] isapnp: Scanning for PnP cards...
>[    7.267024]  01:01: card '3Com 3C509B EtherLink III'
>[    7.277232] isapnp: 1 Plug & Play card detected total
>[    7.292485] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>[    7.319172] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>[    7.349717] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
>[    7.567564] brd: module loaded
>[    7.579578] i8042: PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
>[    7.592552] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
>[    7.605766] serio: i8042 KBD port at 0x60,0x64 irq 1
>[    7.618943] TCP: cubic registered
>[    7.626320] Using IPI Shortcut mode
>[    8.273295] Switched to clocksource tsc
>[    9.662110] input: PC Speaker as /devices/platform/pcspkr/input/input2
>[   10.214886] Freeing unused kernel memory: 6752K (c03ef000 - c0a87000)
>[   10.229220] Write protecting the kernel text: 2148k
>[   10.239548] Write protecting the kernel read-only data: 656k
>[   10.464110] NET: Registered protocol family 1
>[   11.801101] usbcore: registered new interface driver usbfs
>[   11.813764] usbcore: registered new interface driver hub
>[   11.879473] usbcore: registered new device driver usb
>[   11.904621] usbcore: registered new interface driver usbkbd
>[   12.034697] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
>[   12.047655] rtc_cmos 00:04: alarms up to one day, 114 bytes nvram
>[   12.087783] Non-volatile memory driver v1.3
>[   12.450302] 3c509 01:01.00: [irq 5]
>[   12.450513] 3c509 01:01.00: [io  0x0220-0x022f]
>[   12.452814] 3c509 01:01.00: activated
>[   12.477655] eth0: 3c5x9 found at 0x220, 10baseT port, address 00:20:af:e9:70:79, IRQ 5.
>[   12.493965] 3c509.c:1.20 04Feb2008 becker@scyld.com
>[   13.310397] eth0: Setting 3c5x9/3c5x9B half-duplex mode if_port: 0, sw_info: bff1
>[   13.419063] 8139too: 8139too Fast Ethernet driver 0.9.28
>[   13.734771] via_rhine: v1.10-LK1.5.1 2010-10-09 Written by Donald Becker
>[   14.204121] SCSI subsystem initialized
>[   14.405284] libata version 3.00 loaded.
>[   14.420664] ata_piix 0000:00:07.1: version 2.13
>[   14.533621] scsi0 : ata_piix
>[   14.734318] scsi1 : ata_piix
>[   14.749259] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
>[   14.763133] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
>[   14.998609] ata2.00: ATA-4: SAMSUNG SV0431D, MA100-31, max UDMA/66
>[   15.011301] ata2.00: 8421840 sectors, multi 16: LBA 
>[   15.038470] ata2.00: configured for MWDMA2
>[   15.048989] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SV0431D  MA10 PQ: 0 ANSI: 5
>[   15.603536] uhci_hcd: USB Universal Host Controller Interface driver
>[   15.617598] uhci_hcd 0000:00:07.2: UHCI Host Controller
>[   15.628609] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
>[   15.643984] uhci_hcd 0000:00:07.2: irq 9, io base 0x00007f80
>[   15.679025] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
>[   15.692934] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>[   15.707643] usb usb1: Product: UHCI Host Controller
>[   15.717633] usb usb1: Manufacturer: Linux 3.15.1 uhci_hcd
>[   15.728658] usb usb1: SerialNumber: 0000:00:07.2
>[   15.897613] sd 1:0:0:0: [sda] 8421840 512-byte logical blocks: (4.31 GB/4.01 GiB)
>[   15.924080] hub 1-0:1.0: USB hub found
>[   15.932173] hub 1-0:1.0: 2 ports detected
>[   16.028118] sd 1:0:0:0: [sda] Write Protect is off
>[   16.038057] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
>[   16.148175] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>[   16.429937] Linux video capture interface: v2.00
>[   16.442609]  sda: unknown partition table
>[   16.622688] sd 1:0:0:0: [sda] Attached SCSI disk
>[   16.786795] saa7130/34: v4l2 driver version 0, 2, 17 loaded
>[   16.799227] saa7134[0]: quirk: PCIPCI_TRITON
>[   16.808041] saa7134[0]: found at 0000:00:08.0, rev: 1, irq: 10, latency: 32, mmio: 0xffaffc00
>[   16.825388] saa7134[0]: subsystem: 1894:a006, board: KNC One TV-Station DVR [card=24,autodetected]
>[   16.843720] saa7134[0]: board init: gpio is 830000
>[   17.133509] saa7134[0]: i2c eeprom 00: 94 18 06 a0 06 80 00 01 00 00 00 00 00 00 01 00
>[   17.150775] saa7134[0]: i2c eeprom 10: 00 ff 86 0e ff 20 ff ff ff ff ff ff ff ff ff ff
>[   17.167772] saa7134[0]: i2c eeprom 20: 01 40 01 02 02 03 01 03 06 ff 01 df ff ff ff ff
>[   17.184681] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.201647] saa7134[0]: i2c eeprom 40: ff 05 00 c0 86 ff ff ff ff ff ff ff ff ff ff ff
>[   17.218628] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.235510] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.252474] saa7134[0]: i2c eeprom 70: 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.269444] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.286351] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.303300] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.320282] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.337179] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.354163] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.371126] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.388095] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>[   17.969895] EXT4-fs (sda): mounting ext3 file system using the ext4 subsystem
>[   18.104730] EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
>[   18.516300] tda9887 0-0043: creating new instance
>[   18.526065] tda9887 0-0043: tda988[5/6/7] found
>[   18.554940] tuner 0-0043: Tuner 74 found with type(s) Radio TV.
>[   19.234658] TUNER: Unable to find symbol tea5767_autodetection()
>[   19.247038] tuner 0-0060: Tuner -1 found with type(s) Radio TV.
>[   19.407764] tuner-simple 0-0060: creating new instance
>[   19.418372] tuner-simple 0-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
>[   19.816157] saa6752hs 0-0020: chip found @ 0x40 (saa7134[0])
>[   19.890419] saa7134[0]: registered device video0 [v4l2]
>[   19.907690] saa7134[0]: registered device vbi0
>[   19.928509] saa7134[0]: registered device radio0
>[   20.332922] saa7134[0]: registered device video1 [mpeg]
>[   23.052771] random: lighttpd urandom read with 67 bits of entropy available
>[   24.481213] NET: Registered protocol family 17
>[   43.076381] random: nonblocking pool is initialized
>[ 3052.726802] capability: warning: `vsftpd' uses 32-bit capabilities (legacy support in use)
>[ 5188.946855] ------------[ cut here ]------------
>[ 5188.956366] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5188.971168] VFS: brelse: Trying to free free buffer
>[ 5188.981113] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5189.076610] CPU: 0 PID: 6949 Comm: record Not tainted 3.15.1 #6
>[ 5189.088652]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5189.104729]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5189.120931]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5189.137091] Call Trace:
>[ 5189.142177]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5189.151503]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5189.162740]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5189.171894]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5189.181165]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5189.192079]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5189.201536]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5189.214409]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5189.226614]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5189.238418]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5189.249321]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5189.260918]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5189.273283]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5189.285943]  [<c49c9520>] ? ext4_write_end+0x200/0x350 [ext4]
>[ 5189.297750]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5189.309382]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5189.321704]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5189.333631]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5189.345479]  [<c4b7638d>] ? __videobuf_copy_to_user.isra.2+0x3d/0x50 [videobuf_core]
>[ 5189.361315]  [<c4b77e1f>] ? videobuf_read_stream+0x25f/0x2b0 [videobuf_core]
>[ 5189.375728]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5189.385772]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5189.397018]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5189.406529]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5189.415810]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5189.425310] ---[ end trace 9de2bd6272909976 ]---
>[ 5189.464211] ------------[ cut here ]------------
>[ 5189.473867] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5189.488541] VFS: brelse: Trying to free free buffer
>[ 5189.498485] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5189.593940] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5189.608057]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5189.624118]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5189.640247]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5189.656400] Call Trace:
>[ 5189.661498]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5189.670848]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5189.682113]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5189.691251]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5189.700396]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5189.711138]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5189.720576]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5189.733447]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5189.745592]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5189.757387]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5189.768290]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5189.779885]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5189.792218]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5189.804877]  [<c49c9520>] ? ext4_write_end+0x200/0x350 [ext4]
>[ 5189.816687]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5189.828326]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5189.840641]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5189.852567]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5189.864418]  [<c4b7638d>] ? __videobuf_copy_to_user.isra.2+0x3d/0x50 [videobuf_core]
>[ 5189.880253]  [<c4b77e1f>] ? videobuf_read_stream+0x25f/0x2b0 [videobuf_core]
>[ 5189.894676]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5189.904742]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5189.915990]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5189.925497]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5189.935016]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5189.944615] ---[ end trace 9de2bd6272909977 ]---
>[ 5189.996070] ------------[ cut here ]------------
>[ 5190.005689] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5190.020370] VFS: brelse: Trying to free free buffer
>[ 5190.030312] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5190.125675] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5190.139802]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5190.155857]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5190.172008]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5190.188165] Call Trace:
>[ 5190.193248]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5190.202557]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5190.213802]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5190.222959]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5190.232109]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5190.242823]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5190.252238]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5190.265106]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5190.277269]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5190.289079]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5190.299984]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5190.311581]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5190.323905]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5190.336573]  [<c49c9520>] ? ext4_write_end+0x200/0x350 [ext4]
>[ 5190.348379]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5190.360010]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5190.372342]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5190.384284]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5190.396126]  [<c4b7638d>] ? __videobuf_copy_to_user.isra.2+0x3d/0x50 [videobuf_core]
>[ 5190.411964]  [<c4b77e1f>] ? videobuf_read_stream+0x25f/0x2b0 [videobuf_core]
>[ 5190.426384]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5190.436439]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5190.447683]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5190.457216]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5190.466574]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5190.475959] ---[ end trace 9de2bd6272909978 ]---
>[ 5190.574966] ------------[ cut here ]------------
>[ 5190.584560] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5190.599223] VFS: brelse: Trying to free free buffer
>[ 5190.609164] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5190.704518] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5190.718635]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5190.734700]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5190.750829]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5190.766987] Call Trace:
>[ 5190.772061]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5190.781411]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5190.792658]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5190.801810]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5190.810947]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5190.821668]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5190.831052]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5190.843923]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5190.856072]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5190.867864]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5190.878766]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5190.890362]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5190.902672]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5190.915339]  [<c49c9520>] ? ext4_write_end+0x200/0x350 [ext4]
>[ 5190.927145]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5190.938775]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5190.951079]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5190.963043]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5190.974893]  [<c4b7638d>] ? __videobuf_copy_to_user.isra.2+0x3d/0x50 [videobuf_core]
>[ 5190.990729]  [<c4b77e1f>] ? videobuf_read_stream+0x25f/0x2b0 [videobuf_core]
>[ 5191.005133]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5191.015185]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5191.026429]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5191.035860]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5191.045207]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5191.054692] ---[ end trace 9de2bd6272909979 ]---
>[ 5191.488018] ------------[ cut here ]------------
>[ 5191.497703] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5191.512375] VFS: brelse: Trying to free free buffer
>[ 5191.522315] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5191.617844] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5191.632003]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5191.648122]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5191.664203]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5191.680335] Call Trace:
>[ 5191.685431]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5191.694756]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5191.706086]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5191.715160]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5191.724291]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5191.735015]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5191.744456]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5191.757431]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5191.769632]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5191.781475]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5191.792394]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5191.803998]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5191.816322]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5191.829030]  [<c49e5adc>] ? __ext4_journal_start_sb+0x4c/0x70 [ext4]
>[ 5191.842076]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5191.853778]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5191.866123]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5191.877923]  [<c016d9b9>] ? __alloc_pages_nodemask+0xd9/0x6e0
>[ 5191.889867]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5191.901674]  [<c014356d>] ? sched_clock_cpu+0xad/0xf0
>[ 5191.912059]  [<c018635f>] ? page_add_new_anon_rmap+0x3f/0x90
>[ 5191.923695]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5191.933783]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5191.945028]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5191.954530]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5191.963895]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5191.973365] ---[ end trace 9de2bd627290997a ]---
>[ 5192.011924] ------------[ cut here ]------------
>[ 5192.021538] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5192.036214] VFS: brelse: Trying to free free buffer
>[ 5192.046154] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5192.141663] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5192.155826]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5192.171945]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5192.188078]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5192.204141] Call Trace:
>[ 5192.209307]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5192.218634]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5192.229866]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5192.239002]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5192.248153]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5192.258870]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5192.268282]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5192.281153]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5192.293298]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5192.305090]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5192.316048]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5192.327648]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5192.339970]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5192.352668]  [<c49e5adc>] ? __ext4_journal_start_sb+0x4c/0x70 [ext4]
>[ 5192.365700]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5192.377322]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5192.389629]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5192.401398]  [<c016d9b9>] ? __alloc_pages_nodemask+0xd9/0x6e0
>[ 5192.413344]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5192.425145]  [<c014356d>] ? sched_clock_cpu+0xad/0xf0
>[ 5192.435529]  [<c018635f>] ? page_add_new_anon_rmap+0x3f/0x90
>[ 5192.447147]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5192.457196]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5192.468441]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5192.477951]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5192.487301]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5192.496769] ---[ end trace 9de2bd627290997b ]---
>[ 5192.613448] ------------[ cut here ]------------
>[ 5192.623104] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5192.637790] VFS: brelse: Trying to free free buffer
>[ 5192.647759] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5192.743135] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5192.757253]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5192.773349]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5192.789495]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5192.805578] Call Trace:
>[ 5192.810741]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5192.820076]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5192.831330]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5192.840462]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5192.849609]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5192.860321]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5192.869746]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5192.882609]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5192.894806]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5192.906624]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5192.917523]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5192.929117]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5192.941423]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5192.954116]  [<c49e5adc>] ? __ext4_journal_start_sb+0x4c/0x70 [ext4]
>[ 5192.967133]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5192.978758]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5192.991065]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5193.002879]  [<c016d9b9>] ? __alloc_pages_nodemask+0xd9/0x6e0
>[ 5193.014815]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5193.026620]  [<c014356d>] ? sched_clock_cpu+0xad/0xf0
>[ 5193.036998]  [<c018635f>] ? page_add_new_anon_rmap+0x3f/0x90
>[ 5193.048619]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5193.058668]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5193.069914]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5193.079421]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5193.088771]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5193.098242] ---[ end trace 9de2bd627290997c ]---
>[ 5193.137192] ------------[ cut here ]------------
>[ 5193.146771] WARNING: CPU: 0 PID: 6949 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5193.161459] VFS: brelse: Trying to free free buffer
>[ 5193.171395] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5193.266891] CPU: 0 PID: 6949 Comm: record Tainted: G        W     3.15.1 #6
>[ 5193.281046]  c0314842 c0126df6 c0385d24 c22afbcc 00001b25 c0384b22 000004b6 c01b3ca4
>[ 5193.297198]  c01b3ca4 c22afc14 c1b028f8 00000003 c22afc38 c0126ea3 00000009 c22afbb4
>[ 5193.313267]  c0385d24 c22afbcc c01b3ca4 c0384b22 000004b6 c0385d24 c49f2c6c 00000001
>[ 5193.329417] Call Trace:
>[ 5193.334503]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5193.343819]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5193.355063]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5193.364215]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5193.373368]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5193.384083]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5193.393517]  [<c49f2c6c>] ? ext4_ind_map_blocks+0x31c/0x5b0 [ext4]
>[ 5193.406380]  [<c49c5984>] ? ext4_map_blocks+0x2a4/0x560 [ext4]
>[ 5193.418544]  [<c49c7216>] ? _ext4_get_block+0x76/0x180 [ext4]
>[ 5193.430351]  [<c01b381b>] ? alloc_page_buffers+0x4b/0x90
>[ 5193.441254]  [<c01b5130>] ? __block_write_begin+0x160/0x380
>[ 5193.452850]  [<c49c849f>] ? ext4_write_begin+0x17f/0x3e0 [ext4]
>[ 5193.465161]  [<c49c7340>] ? ext4_get_block_write+0x10/0x10 [ext4]
>[ 5193.477855]  [<c49e5adc>] ? __ext4_journal_start_sb+0x4c/0x70 [ext4]
>[ 5193.490869]  [<c0167b0e>] ? generic_perform_write+0xbe/0x1c0
>[ 5193.502497]  [<c016955d>] ? __generic_file_aio_write+0x1ed/0x470
>[ 5193.514825]  [<c016982a>] ? generic_file_aio_write+0x4a/0x100
>[ 5193.526629]  [<c016d9b9>] ? __alloc_pages_nodemask+0xd9/0x6e0
>[ 5193.538568]  [<c49c1042>] ? ext4_file_write+0xc2/0x4f0 [ext4]
>[ 5193.550369]  [<c014356d>] ? sched_clock_cpu+0xad/0xf0
>[ 5193.560749]  [<c018635f>] ? page_add_new_anon_rmap+0x3f/0x90
>[ 5193.572369]  [<c01907db>] ? do_sync_write+0x5b/0x90
>[ 5193.582418]  [<c0190780>] ? do_sync_readv_writev+0x90/0x90
>[ 5193.593666]  [<c01912f7>] ? vfs_write+0x97/0x190
>[ 5193.603176]  [<c019171c>] ? SyS_write+0x4c/0xb0
>[ 5193.612542]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5193.622014] ---[ end trace 9de2bd627290997d ]---
>[ 5193.709251] ------------[ cut here ]------------
>[ 5193.718950] WARNING: CPU: 0 PID: 6953 at fs/buffer.c:1206 __brelse+0x34/0x40()
>[ 5193.733632] VFS: brelse: Trying to free free buffer
>[ 5193.743581] Modules linked in: af_packet snd_via82xx snd_mpu401_uart snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore eeprom i2c_viapro vt8231 saa7134_empress via686a hwmon saa6752hs tuner_simple tuner_types tda9887 tda8290 tuner saa7134 tveeprom videobuf_dma_sg videobuf_core v4l2_common videodev i2c_core sd_mod uhci_hcd sata_nv pata_amd pata_via ata_piix libata scsi_mod ext4 crc16 mbcache jbd2 vfat fat via_rhine forcedeth 8139too 3c59x mii 3c509 nvram rtc_cmos usbkbd usbcore usb_common unix pcspkr
>[ 5193.839040] CPU: 0 PID: 6953 Comm: record Tainted: G        W     3.15.1 #6
>[ 5193.853154]  c0314842 c0126df6 c0385d24 c0dc3bfc 00001b29 c0384b22 000004b6 c01b3ca4
>[ 5193.869268]  c01b3ca4 c193c728 c0dc3c24 c03db8c0 c0fb9630 c0126ea3 00000009 c0dc3be4
>[ 5193.885347]  c0385d24 c0dc3bfc c01b3ca4 c0384b22 000004b6 c0385d24 c01b4338 00000000
>[ 5193.901498] Call Trace:
>[ 5193.906663]  [<c0314842>] ? dump_stack+0xa/0x13
>[ 5193.916003]  [<c0126df6>] ? warn_slowpath_common+0x76/0x90
>[ 5193.927247]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5193.936398]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5193.945472]  [<c0126ea3>] ? warn_slowpath_fmt+0x33/0x40
>[ 5193.956204]  [<c01b3ca4>] ? __brelse+0x34/0x40
>[ 5193.965282]  [<c01b4338>] ? __find_get_block+0x128/0x140
>[ 5193.976183]  [<c01b436b>] ? __getblk+0x1b/0x2e0
>[ 5193.985548]  [<c49425a2>] ? jbd2_journal_dirty_metadata+0x92/0x1f0 [jbd2]
>[ 5193.999629]  [<c49c7f6d>] ? ext4_mark_inode_dirty+0x4d/0x160 [ext4]
>[ 5194.012639]  [<c49beedd>] ? ext4_read_block_bitmap_nowait+0x3d/0x1b0 [ext4]
>[ 5194.027078]  [<c49e5b48>] ? __ext4_journal_stop+0x48/0x80 [ext4]
>[ 5194.039573]  [<c49cac58>] ? ext4_dirty_inode+0x38/0x60 [ext4]
>[ 5194.051530]  [<c49bf05c>] ? ext4_read_block_bitmap+0xc/0x30 [ext4]
>[ 5194.064399]  [<c49ecc6c>] ? ext4_free_blocks+0x26c/0xb30 [ext4]
>[ 5194.076571]  [<c01447e9>] ? dequeue_task_fair+0x29/0x190
>[ 5194.087689]  [<c49f1fc9>] ? ext4_clear_blocks+0x1a9/0x290 [ext4]
>[ 5194.100096]  [<c4942b41>] ? jbd2_journal_get_write_access+0x21/0x30 [jbd2]
>[ 5194.114345]  [<c49e5c86>] ? __ext4_journal_get_write_access+0x26/0x70 [ext4]
>[ 5194.128984]  [<c49f2268>] ? ext4_free_data+0x1b8/0x210 [ext4]
>[ 5194.141000]  [<c49f2618>] ? ext4_free_branches+0xf8/0x2f0 [ext4]
>[ 5194.153547]  [<c49f3848>] ? ext4_ind_truncate+0x3c8/0x430 [ext4]
>[ 5194.166060]  [<c49c7c63>] ? ext4_mark_iloc_dirty+0x393/0x5e0 [ext4]
>[ 5194.179106]  [<c49e5adc>] ? __ext4_journal_start_sb+0x4c/0x70 [ext4]
>[ 5194.192308]  [<c49c82e5>] ? ext4_truncate+0x265/0x2a0 [ext4]
>[ 5194.204116]  [<c49cab57>] ? ext4_evict_inode+0x347/0x410 [ext4]
>[ 5194.216310]  [<c01a4860>] ? evict+0x70/0x130
>[ 5194.225066]  [<c019b02b>] ? do_unlinkat+0x12b/0x210
>[ 5194.235125]  [<c014f025>] ? getnstimeofday+0x5/0x20
>[ 5194.245173]  [<c014f07d>] ? do_gettimeofday+0xd/0x30
>[ 5194.255378]  [<c019d15e>] ? SyS_unlink+0xe/0x10
>[ 5194.264725]  [<c03171fa>] ? syscall_call+0x7/0xb
>[ 5194.274202] ---[ end trace 9de2bd627290997e ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
