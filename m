From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: ext4 2.6.35-rc2 regression (ext4: Make sure the MOVE_EXT ioctl
 can't overwrite append-only files)
Date: Sun, 6 Jun 2010 10:16:01 +0200
Message-ID: <20100606081601.GA1807@arch.tripp.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Cc: torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-194.synserver.de ([212.40.180.194]:1056 "HELO
	smtp-out-192.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752260Ab0FFIWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jun 2010 04:22:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72
"ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files"
causes the following kernel BUG on my machine (x86_64):

BUG: Bad page map in process mpd  pte:720072000000000 pmd:11d2f7067
addr:00007f6b09f82000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:132
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Not tainted 2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b8c9b>] unmap_vmas+0x50c/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Disabling lock debugging due to kernel taint

Full dmesg is attached.
-- 
Markus

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg_ext4

7d900 - 000197d968]         BOOTMEM
  #22 [000197d980 - 000197d9e8]         BOOTMEM
  #23 [000197da00 - 000197da68]         BOOTMEM
  #24 [000197da80 - 000197dae8]         BOOTMEM
  #25 [000197db00 - 000197db68]         BOOTMEM
  #26 [000197db80 - 000197dbe8]         BOOTMEM
  #27 [000197dc00 - 000197dc68]         BOOTMEM
  #28 [000197dc80 - 000197dcbe]         BOOTMEM
  #29 [000197dcc0 - 000197dcfe]         BOOTMEM
  #30 [0001a00000 - 0001a19000]         BOOTMEM
  #31 [0001a80000 - 0001a99000]         BOOTMEM
  #32 [0001b00000 - 0001b19000]         BOOTMEM
  #33 [0001b80000 - 0001b99000]         BOOTMEM
  #34 [000197dd00 - 000197dd08]         BOOTMEM
  #35 [000197dd40 - 000197dd48]         BOOTMEM
  #36 [000197dd80 - 000197dd90]         BOOTMEM
  #37 [000197ddc0 - 000197dde0]         BOOTMEM
  #38 [000197de00 - 000197df30]         BOOTMEM
  #39 [000197df40 - 000197df90]         BOOTMEM
  #40 [000199c000 - 00019a4000]         BOOTMEM
  #41 [0001b99000 - 0001f99000]         BOOTMEM
  #42 [0005c00000 - 0005e00000]         BOOTMEM
  #43 [0005e00000 - 0009e00000]         BOOTMEM
  #44 [00019a4000 - 00019c4000]         BOOTMEM
  #45 [0001a19000 - 0001a59000]         BOOTMEM
  #46 [000000b000 - 0000013000]         BOOTMEM
Memory: 4050652k/4718592k available (4290k kernel code, 526152k absent, 141788k reserved, 4410k data, 424k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:384
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3210.273 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6420.53 BogoMIPS (lpj=3210266)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20100428
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Booting Node   0, Processors  #1 #2
System has AMD C1E enabled
Switch to broadcast mode on CPU1
 #3 Ok.
Switch to broadcast mode on CPU2
Brought up 4 CPUs
Total of 4 processors activated (25686.58 BogoMIPS).
Switch to broadcast mode on CPU3
Switch to broadcast mode on CPU0
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000e0000000 aka 3584M
Fam 10h mmconf [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, fbcfffff]
node 0 link 0: mmio [fbd00000, fbefffff]
node 0 link 0: mmio [fbf00000, ffefffff]
TOM2: 0000000120000000 aka 4608M
bus: [00, 07] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x000a0000-0x000bffff]
bus: 00 index 2 [mem 0xf0000000-0xffffffff]
bus: 00 index 3 [mem 0x120000000-0xfcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 3 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xdfffffff]
pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
pci 0000:00:11.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
pci 0000:00:12.0: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
pci 0000:00:12.1: reg 10: [mem 0xfbcfe000-0xfbcfefff]
pci 0000:00:12.2: reg 10: [mem 0xfbcff800-0xfbcff8ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
pci 0000:00:13.1: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
pci 0000:00:13.2: reg 10: [mem 0xfbcff400-0xfbcff4ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
pci 0000:00:14.5: reg 10: [mem 0xfbcfa000-0xfbcfafff]
pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
pci 0000:01:05.0: reg 18: [mem 0xfbee0000-0xfbeeffff]
pci 0000:01:05.0: reg 24: [mem 0xfbd00000-0xfbdfffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: reg 10: [mem 0xfbefc000-0xfbefffff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:02:05.0: reg 10: [io  0xe800-0xe8ff]
pci 0000:02:05.0: reg 14: [mem 0xfbfffc00-0xfbfffcff]
pci 0000:02:05.0: reg 30: [mem 0xfbfc0000-0xfbfdffff pref]
pci 0000:02:05.0: supports D1 D2
pci 0000:02:05.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:02:05.0: PME# disabled
pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
pci 0000:00:14.4:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.23.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 00000000dfe90000 - 00000000dfffffff 
cfg80211: Calling CRDA to update world regulatory domain
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: [io  0x040b] has been reserved
system 00:08: [io  0x04d6] has been reserved
system 00:08: [io  0x0c00-0x0c01] has been reserved
system 00:08: [io  0x0c14] has been reserved
system 00:08: [io  0x0c50-0x0c51] has been reserved
system 00:08: [io  0x0c52] has been reserved
system 00:08: [io  0x0c6c] has been reserved
system 00:08: [io  0x0c6f] has been reserved
system 00:08: [io  0x0cd0-0x0cd1] has been reserved
system 00:08: [io  0x0cd2-0x0cd3] has been reserved
system 00:08: [io  0x0cd4-0x0cd5] has been reserved
system 00:08: [io  0x0cd6-0x0cd7] has been reserved
system 00:08: [io  0x0cd8-0x0cdf] has been reserved
system 00:08: [io  0x0b00-0x0b3f] has been reserved
system 00:08: [io  0x0800-0x089f] has been reserved
system 00:08: [io  0x0b00-0x0b0f] has been reserved
system 00:08: [io  0x0b20-0x0b3f] has been reserved
system 00:08: [io  0x0900-0x090f] has been reserved
system 00:08: [io  0x0910-0x091f] has been reserved
system 00:08: [io  0xfe00-0xfefe] has been reserved
system 00:08: [mem 0xdff00000-0xdfffffff] has been reserved
system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
system 00:09: [io  0x0230-0x023f] has been reserved
system 00:09: [io  0x0290-0x029f] has been reserved
system 00:09: [io  0x0f40-0x0f4f] has been reserved
system 00:09: [io  0x0a30-0x0a3f] has been reserved
system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0b: [mem 0x00100000-0xdfefffff] could not be reserved
system 00:0b: [mem 0xfec00000-0xffffffff] could not be reserved
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
pci 0000:00:14.4: PCI bridge to [bus 02-02]
pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
pci 0000:00:14.4:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:14.4:   bridge window [mem pref disabled]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:02: resource 8 [mem 0xdff00000-0xdfffffff]
pci_bus 0000:02: resource 9 [mem 0xf0000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
pci 0000:01:05.0: Boot video device
PCI: CLS mismatch (64 != 32), using 64 bytes
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880005e00000 - ffff880009e00000
software IO TLB at phys 0x5e00000 - 0x9e00000
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
msgmni has been set to 7911
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
radeon 0000:01:05.0: setting latency timer to 64
[drm] initializing kernel modesetting (RS780 0x1002:0x9614).
[drm] register mmio base: 0xFBEE0000
[drm] register mmio size: 65536
ATOM BIOS: 113
[drm] Clocks initialized !
radeon 0000:01:05.0: VRAM: 128M 0xC0000000 - 0xC7FFFFFF (128M used)
radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
[drm] Detected VRAM RAM=128M, BAR=128M
[drm] RAM width 32bits DDR
[TTM] Zone  kernel: Available graphics memory: 2025334 kiB.
[TTM] Initializing pool allocator.
[drm] radeon: 128M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] radeon: irq initialized.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] Loading RS780 Microcode
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Enabling audio support
[drm] Unknown TV standard; defaulting to NTSC
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm] Connector 1:
[drm]   DVI-D
[drm]   HPD2
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[drm] radeon: power management initialized
[drm] fb mappable at 0xF0141000
[drm] vram apper at 0xF0000000
[drm] size 7258112
[drm] fb depth is 24
[drm]    pitch is 6912
Console: switching to colour frame buffer device 131x105
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] Initialized radeon 2.4.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
PPP generic driver version 2.4.2
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
r8169 0000:02:05.0: (unregistered net_device): no PCI Express capability
r8169 0000:02:05.0: eth0: RTL8110s at 0xffffc90000458c00, 00:08:54:36:f2:2f, XID 04000000 IRQ 20
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
ata5.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
ata5.00: configured for UDMA/66
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
ata4: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata3.00: ATA-8: OCZ-VERTEX, 1.5, max UDMA/133
ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
usb 3-1: new full speed USB device using ohci_hcd and address 2
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.5  PQ: 0 ANSI: 5
 sda:
sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
 sdb1 sdb2
sd 2:0:0:0: [sdb] Attached SCSI disk
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg2 type 5
 sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb 4-1: new full speed USB device using ohci_hcd and address 2
usb 4-3: new low speed USB device using ohci_hcd and address 3
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input2
generic-usb 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-1/input0
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.1/input/input3
generic-usb 0003:046D:C52B.0002: input,hiddev96,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-1/input1
generic-usb 0003:046D:C52B.0003: hiddev97,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-1/input2
input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input4
generic-usb 0003:0D8C:000C.0004: input,hidraw3: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5
generic-usb 0003:046A:0011.0005: input,hidraw4: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.1-3/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: C-Media USB Headphone Set   at usb-0000:00:12.1-1, full speed
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (3200 MHz)
powernow-k8:    1 : pstate 1 (2500 MHz)
powernow-k8:    2 : pstate 2 (2100 MHz)
powernow-k8:    3 : pstate 3 (800 MHz)
registered taskstats version 1
EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
Freeing unused kernel memory: 424k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1844k freed
Freeing unused kernel memory: 304k freed
udev: starting version 157
EXT4-fs (sdb2): re-mounted. Opts: discard
EXT4-fs (sdb2): re-mounted. Opts: discard
EXT4-fs (sdb2): re-mounted. Opts: discard
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
Adding 200808k swap on /dev/sda3.  Priority:-1 extents:1 across:200808k 
r8169 0000:02:05.0: eth0: link up
r8169: WARNING! Changing of MTU on this NIC may lead to frame reception errors!
swap_free: Bad swap offset entry 3900390000000
BUG: Bad page map in process mpd  pte:720072000000000 pmd:11d2f7067
addr:00007f6b09f82000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:132
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Not tainted 2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b8c9b>] unmap_vmas+0x50c/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Disabling lock debugging due to kernel taint
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f83000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:133
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f84000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:134
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f85000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:135
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f86000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:136
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f87000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:137
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f88000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:138
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f89000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:139
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f8a000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:13a
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f8b000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:13b
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f8c000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:13c
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f8d000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:13d
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f8e000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:13e
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f8f000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:13f
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f90000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:140
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f91000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:141
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f92000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:142
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f93000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:143
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f94000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:144
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f95000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:145
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f96000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:146
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f97000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:147
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f98000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:148
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f99000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:149
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f9a000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:14a
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f9b000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:14b
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f9c000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:14c
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f9d000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:14d
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f9e000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:14e
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09f9f000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:14f
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa0000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:150
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa1000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:151
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa2000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:152
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa3000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:153
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa4000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:154
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa5000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:155
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa6000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:156
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa7000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:157
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa8000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:158
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fa9000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:159
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09faa000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:15a
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fab000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:15b
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fac000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:15c
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:720072007200720 pmd:11d2f7067
addr:00007f6b09fad000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:15d
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
BUG: Bad page map in process mpd  pte:00000720 pmd:11d2f7067
addr:00007f6b09fae000 vm_flags:08000070 anon_vma:(null) mapping:ffff88011b1cec18 index:15e
vma->vm_ops->fault: filemap_fault+0x0/0x31e
vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x54
Pid: 1672, comm: mpd Tainted: G    B       2.6.35-rc2-00032-g78a5aa2 #45
Call Trace:
 [<ffffffff810b7a35>] print_bad_pte+0x1d0/0x1e9
 [<ffffffff810b80c1>] vm_normal_page+0x3a/0x68
 [<ffffffff810b8aba>] unmap_vmas+0x32b/0x803
 [<ffffffff810be003>] exit_mmap+0xc4/0x14a
 [<ffffffff81057bc6>] mmput+0x2d/0xb9
 [<ffffffff8105b57f>] exit_mm+0x100/0x10d
 [<ffffffff81082165>] ? acct_collect+0x9f/0x180
 [<ffffffff8105cc6f>] do_exit+0x1fd/0x689
 [<ffffffff8105d1aa>] do_group_exit+0x75/0x9d
 [<ffffffff8105d1e9>] sys_exit_group+0x17/0x1b
 [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b

--gKMricLos+KVdGMg--
