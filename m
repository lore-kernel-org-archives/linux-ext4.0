From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Date: Wed, 10 Nov 2010 20:43:04 +0100
Message-ID: <1289418184.6530.6.camel@localhost.localdomain>
References: <201011032334.30662.thomas@m3y3r.de>
	 <201011080014.33354.thomas@m3y3r.de>
	 <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
	 <1289242528.11571.8.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1011082039360.2900@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:42739 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab0KJTnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Nov 2010 14:43:23 -0500
In-Reply-To: <alpine.LFD.2.00.1011082039360.2900@localhost6.localdomain6>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag, den 08.11.2010, 20:55 +0100 schrieb Thomas Gleixner:
> On Mon, 8 Nov 2010, Thomas Meyer wrote:
> > First results:
> >=20
> > WARNING: at lib/debugobjects.c:259 debug_print_object+0x5b/0x63()
> > Hardware name: MS-7250
> > ODEBUG: free active (active state 0) object type: timer_list
>=20
> That means that ext4_put_super() is kfree'ing something which has an
> active timer embedded. That explains the crash in cascade() very well=
=2E
>=20
> I leave it to the ext4 experts to solve it for real :)
>=20
> > Modules linked in: floppy radeon ttm drm_kms_helper
> > Pid: 2259, comm: umount Not tainted 2.6.36 #4
> > Call Trace:
> > [<ffffffff810577d2>] warn_slowpath_common+0x80/0x98
> > [<ffffffff8105787e>] warn_slowpath_fmt+0x41/0x43
> > [<ffffffff812cab46>] debug_print_object+0x5b/0x63
> > [<ffffffff812cb024>] debug_check_no_obj_freed+0x94/0x1d3
> > [<ffffffff817032d3>] ? _raw_spin_unlock_irq+0x1f/0x2a
> > [<ffffffff810e4cd7>] kfree+0x75/0xb6
> > [<ffffffff81172c75>] ? ext4_put_super+0x32b/0x33a
> > [<ffffffff81172c75>] ext4_put_super+0x32b/0x33a
> > [<ffffffff810ed276>] generic_shutdown_super+0x51/0xd2
> > [<ffffffff810ed319>] kill_block_super+0x22/0x3a
> > [<ffffffff810ecda6>] deactivate_locked_super+0x21/0x41
> > [<ffffffff810ed220>] deactivate_super+0x40/0x45
> > [<ffffffff811010a5>] mntput_no_expire+0xdd/0x10b
> > [<ffffffff8110161a>] sys_umount+0x2d2/0x2fd
> > [<ffffffff81705f1e>] ? do_page_fault+0x217/0x244
> > [<ffffffff81022a2b>] system_call_fastpath+0x16/0x1b
> >=20

I just booted into 2.6.37-rc1-00166-g814ce25 and I don't see above bug
in this kernel. So it seems as this bug got fixed in between 2.6.36 and
2.6.37-rc1+

$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.37-rc1-00166-g814ce25 (thomas@localhos=
t.localdomain) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #=
95 SMP PREEMPT Tue Nov 9 21:37:58 CET 2010
[    0.000000] Command line: ro root=3D/dev/mapper/luks-1bda98a6-c825-4=
097-b472-3d8050c1a022 SYSFONT=3Dlatarcyrheb-sun16 LANG=3Dde_DE.UTF-8 KE=
YTABLE=3Dde-latin1-nodeadkeys rhgb
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffd0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffd0000 - 00000000bffde000 (ACPI da=
ta)
[    0.000000]  BIOS-e820: 00000000bffde000 - 00000000c0000000 (ACPI NV=
S)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: MS-7250/MS-7250, BIOS V1.11 04/07/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (=
usable) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (=
usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x1c0000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 0100000000 mask FF80000000 write-back
[    0.000000]   3 base 0180000000 mask FFC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 00000001c0000000 aka 7168M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x70106=
00070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (=
usable) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbffd0 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffd0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffd0000 page 4k
[    0.000000] kernel direct mapping tables up to bffd0000 @ 1fffb000-2=
0000000
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000]  0100000000 - 01c0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1c0000000 @ bffc8000-=
bffd0000
[    0.000000] RAMDISK: 37904000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f98b0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bffd0000 0003C (v01 MSIISM OEMRSDT  0=
4000807 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bffd0200 00084 (v02 MSIISM OEMFACP  0=
4000807 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bffd0440 05045 (v01  1ADGH 1ADGH013 0=
0000013 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bffde000 00040
[    0.000000] ACPI: APIC 00000000bffd0390 00070 (v01 MSIISM OEMAPIC  0=
4000807 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bffd0400 0003C (v01 MSIISM OEMMCFG  0=
4000807 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bffde040 00061 (v01 MSIISM AMI_OEM  0=
4000807 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bffd5490 00038 (v01 MSIISM OEMHPET0 0=
4000807 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bffd54d0 0028A (v01 A M I  POWERNOW 0=
0000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00061fffff] PMD -> [ffff8800ae0=
00000-ffff8800b33fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffd0
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] On node 0 totalpages: 1572703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 768008 pages, LIFO batch:31
[    0.000000]   Normal zone: 10752 pages used for memmap
[    0.000000]   Normal zone: 775680 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GS=
I 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high e=
dge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high e=
dge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 0000000=
0000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000=
0000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000=
000100000
[    0.000000] PM: Registered nosave memory: 00000000bffd0000 - 0000000=
0bffde000
[    0.000000] PM: Registered nosave memory: 00000000bffde000 - 0000000=
0c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 0000000=
0d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 0000000=
0e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 0000000=
0fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000=
0fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 0000000=
0fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 0000000=
0fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 0000000=
0ff780000
[    0.000000] PM: Registered nosave memory: 00000000ff780000 - 0000000=
100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e000=
0000:1ec00000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2=
 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bfc00000 s76544 r=
8192 d21760 u1048576
[    0.000000] pcpu-alloc: s76544 r8192 d21760 u1048576 alloc=3D1*20971=
52
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  =
Total pages: 1547609
[    0.000000] Kernel command line: ro root=3D/dev/mapper/luks-1bda98a6=
-c825-4097-b472-3d8050c1a022 SYSFONT=3Dlatarcyrheb-sun16 LANG=3Dde_DE.U=
TF-8 KEYTABLE=3Dde-latin1-nodeadkeys rhgb
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 838=
8608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 41943=
04 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ b4000000
[    0.000000] PM: Registered nosave memory: 00000000b4000000 - 0000000=
0b8000000
[    0.000000] Memory: 6038028k/7340032k available (7269k kernel code, =
1049220k absent, 252784k reserved, 6180k data, 580k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjec=
ts=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2599.982 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using=
 timer frequency.. 5199.96 BogoMIPS (lpj=3D2599982)
[    0.002002] pid_max: default: 32768 minimum: 301
[    0.002123] Security Framework initialized
[    0.002226] SELinux:  Initializing.
[    0.002332] SELinux:  Starting in permissive mode
[    0.002380] Mount-cache hash table entries: 256
[    0.002623] Initializing cgroup subsys ns
[    0.002726] ns_cgroup deprecated: consider using the 'clone_children=
' flag without the ns_cgroup.
[    0.002909] Initializing cgroup subsys cpuacct
[    0.003028] tseg: 0000000000
[    0.003035] CPU: Physical Processor ID: 0
[    0.003136] CPU: Processor Core ID: 0
[    0.003237] mce: CPU supports 5 MCE banks
[    0.003345] using C1E aware idle routine
[    0.003445] Performance Events: AMD PMU driver.
[    0.003567] ... version:                0
[    0.003667] ... bit width:              48
[    0.003767] ... generic registers:      4
[    0.003868] ... value mask:             0000ffffffffffff
[    0.004002] ... max period:             00007fffffffffff
[    0.004102] ... fixed-purpose events:   0
[    0.004203] ... event mask:             000000000000000f
[    0.004333] ACPI: Core revision 20101013
[    0.010054] Setting APIC routing to flat
[    0.010580] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.020698] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ ste=
pping 02
[    0.023014] NMI watchdog enabled, takes one hw-pmu counter.
[    0.027019] Booting Node   0, Processors  #1 Ok.
[    0.098102] NMI watchdog enabled, takes one hw-pmu counter.
[    0.099004] Brought up 2 CPUs
[    0.099105] Total of 2 processors activated (10399.62 BogoMIPS).
[    0.099372] xor: automatically using best checksumming function: gen=
eric_sse
[    0.103969]    generic_sse:  7928.000 MB/sec
[    0.104002] xor: using function: generic_sse (7928.000 MB/sec)
[    0.104137] NET: Registered protocol family 16
[    0.104256] node 0 link 0: io port [1000, ffffff]
[    0.104256] node 0 link 0: io port [2000, 2fff]
[    0.104256] TOM: 00000000c0000000 aka 3072M
[    0.104256] node 0 link 0: mmio [e0000000, efffffff]
[    0.104256] node 0 link 0: mmio [a0000, bffff]
[    0.104256] node 0 link 0: mmio [c0000000, fe0bffff]
[    0.104256] TOM2: 00000001c0000000 aka 7168M
[    0.104256] bus: [00, ff] on node 0 link 0
[    0.104256] bus: 00 index 0 [io  0x0000-0xffff]
[    0.104256] bus: 00 index 1 [mem 0xc0000000-0xffffffff]
[    0.104256] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.105006] bus: 00 index 3 [mem 0x1c0000000-0xfcffffffff]
[    0.105013] ACPI: bus type pci registered
[    0.105123] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe000=
0000-0xefffffff] (base 0xe0000000)
[    0.105228] PCI: not using MMCONFIG
[    0.105329] PCI: Using configuration type 1 for base access
[    0.117118] bio: create slab <bio-0> at 0
[    0.133973] raid6: int64x1   2253 MB/s
[    0.150992] raid6: int64x2   2531 MB/s
[    0.167969] raid6: int64x4   2035 MB/s
[    0.184996] raid6: int64x8   1472 MB/s
[    0.201774] raid6: sse2x1    3535 MB/s
[    0.218976] raid6: sse2x2    4835 MB/s
[    0.235974] raid6: sse2x4    4847 MB/s
[    0.236001] raid6: using algorithm sse2x4 (4847 MB/s)
[    0.237086] ACPI: EC: Look up EC in DSDT
[    0.238211] ACPI: Executed 1 blocks of module-level executable AML c=
ode
[    0.241768] ACPI: Interpreter enabled
[    0.241871] ACPI: (supports S0 S3 S4 S5)
[    0.242004] ACPI: Using IOAPIC for interrupt routing
[    0.242137] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe000=
0000-0xefffffff] (base 0xe0000000)
[    0.243943] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in=
 ACPI motherboard resources
[    0.276176] ACPI: No dock devices found.
[    0.276260] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug
[    0.276544] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.277181] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0c=
f7]
[    0.277285] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xff=
ff]
[    0.277388] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-=
0x000bffff]
[    0.277569] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-=
0x000dffff]
[    0.277751] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-=
0xfebfffff]
[    0.277953] pci 0000:00:00.0: [10de:0369] type 0 class 0x000500
[    0.278155] pci 0000:00:01.0: [10de:0360] type 0 class 0x000601
[    0.278158] Rewriting irq routing register on MCP55
[    0.278264] pci 0000:00:01.0: reg 10: [io  0x2f00-0x2f7f]
[    0.278292] pci 0000:00:01.1: [10de:0368] type 0 class 0x000c05
[    0.278303] pci 0000:00:01.1: reg 10: [io  0x2900-0x293f]
[    0.278319] pci 0000:00:01.1: reg 20: [io  0x2d00-0x2d3f]
[    0.278325] pci 0000:00:01.1: reg 24: [io  0x2e00-0x2e3f]
[    0.278346] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.278351] pci 0000:00:01.1: PME# disabled
[    0.278367] pci 0000:00:02.0: [10de:036c] type 0 class 0x000c03
[    0.278375] pci 0000:00:02.0: reg 10: [mem 0xfe9fb000-0xfe9fbfff]
[    0.278399] pci 0000:00:02.0: supports D1 D2
[    0.278401] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278404] pci 0000:00:02.0: PME# disabled
[    0.278414] pci 0000:00:02.1: [10de:036d] type 0 class 0x000c03
[    0.278422] pci 0000:00:02.1: reg 10: [mem 0xfe9fac00-0xfe9facff]
[    0.278445] pci 0000:00:02.1: supports D1 D2
[    0.278447] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278449] pci 0000:00:02.1: PME# disabled
[    0.278464] pci 0000:00:04.0: [10de:036e] type 0 class 0x000101
[    0.278478] pci 0000:00:04.0: reg 20: [io  0xffa0-0xffaf]
[    0.278498] pci 0000:00:05.0: [10de:037f] type 0 class 0x000101
[    0.278506] pci 0000:00:05.0: reg 10: [io  0xc480-0xc487]
[    0.278510] pci 0000:00:05.0: reg 14: [io  0xc400-0xc403]
[    0.278514] pci 0000:00:05.0: reg 18: [io  0xc080-0xc087]
[    0.278518] pci 0000:00:05.0: reg 1c: [io  0xc000-0xc003]
[    0.278522] pci 0000:00:05.0: reg 20: [io  0xbc00-0xbc0f]
[    0.278526] pci 0000:00:05.0: reg 24: [mem 0xfe9f9000-0xfe9f9fff]
[    0.278548] pci 0000:00:05.1: [10de:037f] type 0 class 0x000101
[    0.278555] pci 0000:00:05.1: reg 10: [io  0xb880-0xb887]
[    0.278559] pci 0000:00:05.1: reg 14: [io  0xb800-0xb803]
[    0.278563] pci 0000:00:05.1: reg 18: [io  0xb480-0xb487]
[    0.278568] pci 0000:00:05.1: reg 1c: [io  0xb400-0xb403]
[    0.278572] pci 0000:00:05.1: reg 20: [io  0xb080-0xb08f]
[    0.278576] pci 0000:00:05.1: reg 24: [mem 0xfe9f8000-0xfe9f8fff]
[    0.278597] pci 0000:00:05.2: [10de:037f] type 0 class 0x000101
[    0.278605] pci 0000:00:05.2: reg 10: [io  0xb000-0xb007]
[    0.278609] pci 0000:00:05.2: reg 14: [io  0xac00-0xac03]
[    0.278613] pci 0000:00:05.2: reg 18: [io  0xa880-0xa887]
[    0.278617] pci 0000:00:05.2: reg 1c: [io  0xa800-0xa803]
[    0.278622] pci 0000:00:05.2: reg 20: [io  0xa480-0xa48f]
[    0.278626] pci 0000:00:05.2: reg 24: [mem 0xfe9f7000-0xfe9f7fff]
[    0.278650] pci 0000:00:06.0: [10de:0370] type 1 class 0x000604
[    0.278676] pci 0000:00:06.1: [10de:0371] type 0 class 0x000403
[    0.278685] pci 0000:00:06.1: reg 10: [mem 0xfe9f0000-0xfe9f3fff]
[    0.278712] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.278715] pci 0000:00:06.1: PME# disabled
[    0.278733] pci 0000:00:08.0: [10de:0373] type 0 class 0x000680
[    0.278744] pci 0000:00:08.0: reg 10: [mem 0xfe9f6000-0xfe9f6fff]
[    0.278748] pci 0000:00:08.0: reg 14: [io  0xa400-0xa407]
[    0.278753] pci 0000:00:08.0: reg 18: [mem 0xfe9fa800-0xfe9fa8ff]
[    0.278757] pci 0000:00:08.0: reg 1c: [mem 0xfe9fa400-0xfe9fa40f]
[    0.278778] pci 0000:00:08.0: supports D1 D2
[    0.278780] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278784] pci 0000:00:08.0: PME# disabled
[    0.278799] pci 0000:00:09.0: [10de:0373] type 0 class 0x000680
[    0.278810] pci 0000:00:09.0: reg 10: [mem 0xfe9f5000-0xfe9f5fff]
[    0.278814] pci 0000:00:09.0: reg 14: [io  0xa080-0xa087]
[    0.278818] pci 0000:00:09.0: reg 18: [mem 0xfe9fa000-0xfe9fa0ff]
[    0.278822] pci 0000:00:09.0: reg 1c: [mem 0xfe9f4c00-0xfe9f4c0f]
[    0.278844] pci 0000:00:09.0: supports D1 D2
[    0.278845] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278849] pci 0000:00:09.0: PME# disabled
[    0.278863] pci 0000:00:0a.0: [10de:0376] type 1 class 0x000604
[    0.278881] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278884] pci 0000:00:0a.0: PME# disabled
[    0.278895] pci 0000:00:0b.0: [10de:0374] type 1 class 0x000604
[    0.278913] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278915] pci 0000:00:0b.0: PME# disabled
[    0.278927] pci 0000:00:0c.0: [10de:0374] type 1 class 0x000604
[    0.278944] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278947] pci 0000:00:0c.0: PME# disabled
[    0.278959] pci 0000:00:0d.0: [10de:0378] type 1 class 0x000604
[    0.278976] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.278979] pci 0000:00:0d.0: PME# disabled
[    0.278991] pci 0000:00:0e.0: [10de:0375] type 1 class 0x000604
[    0.279048] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.279051] pci 0000:00:0e.0: PME# disabled
[    0.279063] pci 0000:00:0f.0: [10de:0377] type 1 class 0x000604
[    0.279081] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.279083] pci 0000:00:0f.0: PME# disabled
[    0.279097] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.279113] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.279126] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.279139] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.279171] pci 0000:01:00.0: [1014:003e] type 0 class 0x000201
[    0.279179] pci 0000:01:00.0: reg 10: [io  0xd800-0xd8ff]
[    0.279185] pci 0000:01:00.0: reg 14: [mem 0xfeaffc00-0xfeaffcff]
[    0.279191] pci 0000:01:00.0: reg 18: [mem 0xfeaff000-0xfeaff7ff]
[    0.279208] pci 0000:01:00.0: reg 30: [mem 0xfeae0000-0xfeae3fff pre=
f]
[    0.279224] pci 0000:01:04.0: [1106:3044] type 0 class 0x000c00
[    0.279235] pci 0000:01:04.0: reg 10: [mem 0xfeafe800-0xfeafefff]
[    0.279242] pci 0000:01:04.0: reg 14: [io  0xdc00-0xdc7f]
[    0.279276] pci 0000:01:04.0: supports D2
[    0.279278] pci 0000:01:04.0: PME# supported from D2 D3hot D3cold
[    0.279281] pci 0000:01:04.0: PME# disabled
[    0.279304] pci 0000:00:06.0: PCI bridge to [bus 01-01] (subtractive=
 decode)
[    0.279407] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.279410] pci 0000:00:06.0:   bridge window [mem 0xfea00000-0xfeaf=
ffff]
[    0.279413] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.279416] pci 0000:00:06.0:   bridge window [io  0x0000-0x0cf7] (s=
ubtractive decode)
[    0.279418] pci 0000:00:06.0:   bridge window [io  0x0d00-0xffff] (s=
ubtractive decode)
[    0.279421] pci 0000:00:06.0:   bridge window [mem 0x000a0000-0x000b=
ffff] (subtractive decode)
[    0.279424] pci 0000:00:06.0:   bridge window [mem 0x000d0000-0x000d=
ffff] (subtractive decode)
[    0.279427] pci 0000:00:06.0:   bridge window [mem 0xc0000000-0xfebf=
ffff] (subtractive decode)
[    0.279445] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.279548] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.279551] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.279554] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.279572] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.279675] pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.279678] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.279682] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.279700] pci 0000:00:0c.0: PCI bridge to [bus 04-04]
[    0.279802] pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.279805] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.279809] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.279827] pci 0000:00:0d.0: PCI bridge to [bus 05-05]
[    0.279930] pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.279932] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.279936] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.279954] pci 0000:00:0e.0: PCI bridge to [bus 06-06]
[    0.280034] pci 0000:00:0e.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.280036] pci 0000:00:0e.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.280040] pci 0000:00:0e.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.280065] pci 0000:07:00.0: [1002:68d9] type 0 class 0x000300
[    0.280075] pci 0000:07:00.0: reg 10: [mem 0xc0000000-0xcfffffff 64b=
it pref]
[    0.280084] pci 0000:07:00.0: reg 18: [mem 0xfebe0000-0xfebfffff 64b=
it]
[    0.280090] pci 0000:07:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.280100] pci 0000:07:00.0: reg 30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.280114] pci 0000:07:00.0: supports D1 D2
[    0.280131] pci 0000:07:00.1: [1002:aa60] type 0 class 0x000403
[    0.280141] pci 0000:07:00.1: reg 10: [mem 0xfebbc000-0xfebbffff 64b=
it]
[    0.280173] pci 0000:07:00.1: supports D1 D2
[    0.282009] pci 0000:00:0f.0: PCI bridge to [bus 07-07]
[    0.282112] pci 0000:00:0f.0:   bridge window [io  0xe000-0xefff]
[    0.282115] pci 0000:00:0f.0:   bridge window [mem 0xfeb00000-0xfebf=
ffff]
[    0.282118] pci 0000:00:0f.0:   bridge window [mem 0xc0000000-0xcfff=
ffff 64bit pref]
[    0.282128] pci_bus 0000:00: on NUMA node 0
[    0.282131] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.282378] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.282492] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.282533] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.282574] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.282615] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.282656] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.282697] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[    0.292141] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.292488] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.293086] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.293452] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[    0.295120] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.295485] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.295835] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *5
[    0.296132] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.296497] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *10
[    0.296825] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *10
[    0.297117] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *11
[    0.297445] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *5
[    0.297734] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *11
[    0.298130] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.298456] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.298785] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *5
[    0.299117] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *10
[    0.299463] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disa=
bled.
[    0.299810] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.300032] HEST: Table is not found!
[    0.300128] vgaarb: device added: PCI:0000:07:00.0,decodes=3Dio+mem,=
owns=3Dio+mem,locks=3Dnone
[    0.300217] vgaarb: loaded
[    0.300339] SCSI subsystem initialized
[    0.301026] libata version 3.00 loaded.
[    0.301043] usbcore: registered new interface driver usbfs
[    0.301137] usbcore: registered new interface driver hub
[    0.301137] usbcore: registered new device driver usb
[    0.302034] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.302126] PCI: Using ACPI for IRQ routing
[    0.302228] PCI: pci_cache_line_size set to 64 bytes
[    0.302294] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.302297] reserve RAM buffer: 00000000bffd0000 - 00000000bfffffff=20
[    0.302315] Bluetooth: Core ver 2.15
[    0.302315] NET: Registered protocol family 31
[    0.302315] Bluetooth: HCI device and connection manager initialized
[    0.303025] Bluetooth: HCI socket layer initialized
[    0.303140] cfg80211: Calling CRDA to update world regulatory domain
[    0.303156] NetLabel: Initializing
[    0.303257] NetLabel:  domain hash size =3D 128
[    0.303358] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.303473] NetLabel:  unlabeled traffic allowed by default
[    0.303578] HPET: 3 timers in total, 0 timers will be used for per-c=
pu timer
[    0.304011] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.304188] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.308035] Switching to clocksource hpet
[    0.308177] pnp: PnP ACPI init
[    0.308289] ACPI: bus type pnp registered
[    0.308513] pnp 00:00: [bus 00-ff]
[    0.308515] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.308517] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.308519] pnp 00:00: [io  0x0d00-0xffff window]
[    0.308522] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.308524] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.308526] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    0.308599] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (activ=
e)
[    0.308599] pnp 00:01: [dma 4]
[    0.308599] pnp 00:01: [io  0x0000-0x000f]
[    0.308599] pnp 00:01: [io  0x0081-0x0083]
[    0.308599] pnp 00:01: [io  0x0087]
[    0.308599] pnp 00:01: [io  0x0089-0x008b]
[    0.308599] pnp 00:01: [io  0x008f]
[    0.308599] pnp 00:01: [io  0x00c0-0x00df]
[    0.308599] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (activ=
e)
[    0.308599] pnp 00:02: [io  0x0070-0x0071]
[    0.308605] pnp 00:02: [irq 8]
[    0.308665] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (activ=
e)
[    0.308674] pnp 00:03: [io  0x0061]
[    0.308732] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (activ=
e)
[    0.308742] pnp 00:04: [io  0x00f0-0x00ff]
[    0.308749] pnp 00:04: [irq 13]
[    0.308812] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (activ=
e)
[    0.309169] pnp 00:05: [io  0x03f8-0x03ff]
[    0.309177] pnp 00:05: [irq 4]
[    0.309178] pnp 00:05: [dma 0 disabled]
[    0.309283] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (activ=
e)
[    0.309602] pnp 00:06: [io  0x02f8-0x02ff]
[    0.309610] pnp 00:06: [irq 3]
[    0.309612] pnp 00:06: [dma 0 disabled]
[    0.309733] pnp 00:06: Plug and Play ACPI device, IDs PNP0510 (activ=
e)
[    0.310129] pnp 00:07: [io  0x03f0-0x03f5]
[    0.310131] pnp 00:07: [io  0x03f7]
[    0.310138] pnp 00:07: [irq 6]
[    0.310139] pnp 00:07: [dma 2]
[    0.310236] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (activ=
e)
[    0.310650] pnp 00:08: [io  0x0378-0x037f]
[    0.310657] pnp 00:08: [irq 7]
[    0.310659] pnp 00:08: [dma 0 disabled]
[    0.310841] pnp 00:08: Plug and Play ACPI device, IDs PNP0400 (activ=
e)
[    0.311656] pnp 00:09: [mem 0x000d0000-0x000d3fff window]
[    0.311658] pnp 00:09: [mem 0x000d4000-0x000d7fff window]
[    0.311660] pnp 00:09: [mem 0x000de000-0x000dffff window]
[    0.311662] pnp 00:09: [io  0x0010-0x001f]
[    0.311664] pnp 00:09: [io  0x0022-0x003f]
[    0.311666] pnp 00:09: [io  0x0044-0x005f]
[    0.311668] pnp 00:09: [io  0x0062-0x0063]
[    0.311670] pnp 00:09: [io  0x0065-0x006f]
[    0.311672] pnp 00:09: [io  0x0072-0x007f]
[    0.311674] pnp 00:09: [io  0x0080]
[    0.311675] pnp 00:09: [io  0x0084-0x0086]
[    0.311677] pnp 00:09: [io  0x0088]
[    0.311679] pnp 00:09: [io  0x008c-0x008e]
[    0.311681] pnp 00:09: [io  0x0090-0x009f]
[    0.311683] pnp 00:09: [io  0x00a2-0x00bf]
[    0.311684] pnp 00:09: [io  0x00e0-0x00ef]
[    0.311686] pnp 00:09: [io  0x04d0-0x04d1]
[    0.311688] pnp 00:09: [io  0x0800-0x080f]
[    0.311690] pnp 00:09: [io  0x2000-0x207f]
[    0.311692] pnp 00:09: [io  0x2080-0x20ff]
[    0.311694] pnp 00:09: [io  0x2400-0x247f]
[    0.311696] pnp 00:09: [io  0x2480-0x24ff]
[    0.311697] pnp 00:09: [io  0x2800-0x287f]
[    0.311699] pnp 00:09: [io  0x2880-0x28ff]
[    0.311701] pnp 00:09: [io  0x2c00-0x2c7f]
[    0.311703] pnp 00:09: [io  0x2c80-0x2cff]
[    0.311705] pnp 00:09: [mem 0xfe980000-0xfe9bffff]
[    0.311707] pnp 00:09: [mem 0xfee01000-0xfeefffff]
[    0.311850] pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (activ=
e)
[    0.311934] pnp 00:0a: [mem 0xfed00000-0xfed00fff]
[    0.312013] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (activ=
e)
[    0.312082] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.312087] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.312175] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (activ=
e)
[    0.312212] pnp 00:0c: [io  0x0060]
[    0.312215] pnp 00:0c: [io  0x0064]
[    0.312222] pnp 00:0c: [irq 1]
[    0.312289] pnp 00:0c: Plug and Play ACPI device, IDs PNP0303 PNP030=
b (active)
[    0.312327] pnp 00:0d: [irq 12]
[    0.312399] pnp 00:0d: Plug and Play ACPI device, IDs PNP0f03 PNP0f1=
3 (active)
[    0.312536] pnp 00:0e: [io  0x0000-0xffffffffffffffff disabled]
[    0.312539] pnp 00:0e: [io  0x0a00-0x0a0f]
[    0.312541] pnp 00:0e: [io  0x0a10-0x0a1f]
[    0.312628] pnp 00:0e: Plug and Play ACPI device, IDs PNP0c02 (activ=
e)
[    0.312693] pnp 00:0f: [mem 0xe0000000-0xefffffff]
[    0.312783] pnp 00:0f: Plug and Play ACPI device, IDs PNP0c02 (activ=
e)
[    0.312887] pnp 00:10: [mem 0xd0000000-0xdfffffff]
[    0.312985] pnp 00:10: Plug and Play ACPI device, IDs PNP0c02 (activ=
e)
[    0.313202] pnp 00:11: [mem 0x00000000-0x0009ffff]
[    0.313204] pnp 00:11: [mem 0x000c0000-0x000cffff]
[    0.313206] pnp 00:11: [mem 0x000e0000-0x000fffff]
[    0.313208] pnp 00:11: [mem 0x00100000-0xbfffffff]
[    0.313210] pnp 00:11: [mem 0xfec00000-0xffffffff]
[    0.313311] pnp 00:11: Plug and Play ACPI device, IDs PNP0c01 (activ=
e)
[    0.313704] pnp: PnP ACPI: found 18 devices
[    0.313807] ACPI: ACPI bus type pnp unregistered
[    0.313920] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.314033] system 00:09: [io  0x0800-0x080f] has been reserved
[    0.314136] system 00:09: [io  0x2000-0x207f] has been reserved
[    0.314238] system 00:09: [io  0x2080-0x20ff] has been reserved
[    0.314340] system 00:09: [io  0x2400-0x247f] has been reserved
[    0.314442] system 00:09: [io  0x2480-0x24ff] has been reserved
[    0.314545] system 00:09: [io  0x2800-0x287f] has been reserved
[    0.314647] system 00:09: [io  0x2880-0x28ff] has been reserved
[    0.314749] system 00:09: [io  0x2c00-0x2c7f] has been reserved
[    0.314852] system 00:09: [io  0x2c80-0x2cff] has been reserved
[    0.314954] system 00:09: [mem 0x000d0000-0x000d3fff window] has bee=
n reserved
[    0.315146] system 00:09: [mem 0x000d4000-0x000d7fff window] has bee=
n reserved
[    0.315328] system 00:09: [mem 0x000de000-0x000dffff window] has bee=
n reserved
[    0.315510] system 00:09: [mem 0xfe980000-0xfe9bffff] has been reser=
ved
[    0.315613] system 00:09: [mem 0xfee01000-0xfeefffff] has been reser=
ved
[    0.315719] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be r=
eserved
[    0.315822] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reser=
ved
[    0.315927] system 00:0e: [io  0x0a00-0x0a0f] has been reserved
[    0.316039] system 00:0e: [io  0x0a10-0x0a1f] has been reserved
[    0.316144] system 00:0f: [mem 0xe0000000-0xefffffff] has been reser=
ved
[    0.316248] system 00:10: [mem 0xd0000000-0xdfffffff] has been reser=
ved
[    0.316353] system 00:11: [mem 0x00000000-0x0009ffff] could not be r=
eserved
[    0.316456] system 00:11: [mem 0x000c0000-0x000cffff] has been reser=
ved
[    0.316559] system 00:11: [mem 0x000e0000-0x000fffff] could not be r=
eserved
[    0.316663] system 00:11: [mem 0x00100000-0xbfffffff] could not be r=
eserved
[    0.316766] system 00:11: [mem 0xfec00000-0xffffffff] could not be r=
eserved
[    0.326578] pci 0000:00:06.0: PCI bridge to [bus 01-01]
[    0.326682] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.326785] pci 0000:00:06.0:   bridge window [mem 0xfea00000-0xfeaf=
ffff]
[    0.326888] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.326991] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.327105] pci 0000:00:0a.0:   bridge window [io  disabled]
[    0.327208] pci 0000:00:0a.0:   bridge window [mem disabled]
[    0.327309] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    0.327413] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.327514] pci 0000:00:0b.0:   bridge window [io  disabled]
[    0.327616] pci 0000:00:0b.0:   bridge window [mem disabled]
[    0.327718] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    0.327821] pci 0000:00:0c.0: PCI bridge to [bus 04-04]
[    0.328152] pci 0000:00:0c.0:   bridge window [io  disabled]
[    0.328254] pci 0000:00:0c.0:   bridge window [mem disabled]
[    0.328356] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    0.328459] pci 0000:00:0d.0: PCI bridge to [bus 05-05]
[    0.328560] pci 0000:00:0d.0:   bridge window [io  disabled]
[    0.328662] pci 0000:00:0d.0:   bridge window [mem disabled]
[    0.328764] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    0.328866] pci 0000:00:0e.0: PCI bridge to [bus 06-06]
[    0.328967] pci 0000:00:0e.0:   bridge window [io  disabled]
[    0.329085] pci 0000:00:0e.0:   bridge window [mem disabled]
[    0.329187] pci 0000:00:0e.0:   bridge window [mem pref disabled]
[    0.329290] pci 0000:00:0f.0: PCI bridge to [bus 07-07]
[    0.329392] pci 0000:00:0f.0:   bridge window [io  0xe000-0xefff]
[    0.329495] pci 0000:00:0f.0:   bridge window [mem 0xfeb00000-0xfebf=
ffff]
[    0.329598] pci 0000:00:0f.0:   bridge window [mem 0xc0000000-0xcfff=
ffff 64bit pref]
[    0.329786] pci 0000:00:06.0: setting latency timer to 64
[    0.329791] pci 0000:00:0a.0: setting latency timer to 64
[    0.329795] pci 0000:00:0b.0: setting latency timer to 64
[    0.329799] pci 0000:00:0c.0: setting latency timer to 64
[    0.329804] pci 0000:00:0d.0: setting latency timer to 64
[    0.329808] pci 0000:00:0e.0: setting latency timer to 64
[    0.329813] pci 0000:00:0f.0: setting latency timer to 64
[    0.329816] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.329818] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.329820] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.329823] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.329826] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.329828] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.329831] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.329833] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.329835] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.329837] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.329840] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.329842] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.329845] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    0.329847] pci_bus 0000:07: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.329849] pci_bus 0000:07: resource 2 [mem 0xc0000000-0xcfffffff 6=
4bit pref]
[    0.329879] NET: Registered protocol family 2
[    0.330038] IP route cache hash table entries: 262144 (order: 9, 209=
7152 bytes)
[    0.331861] TCP established hash table entries: 262144 (order: 10, 4=
194304 bytes)
[    0.334576] TCP bind hash table entries: 65536 (order: 8, 1048576 by=
tes)
[    0.335286] TCP: Hash tables configured (established 262144 bind 655=
36)
[    0.335389] TCP reno registered
[    0.335492] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.335673] UDP-Lite hash table entries: 4096 (order: 5, 131072 byte=
s)
[    0.335949] NET: Registered protocol family 1
[    0.358076] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.358212] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.358348] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.358484] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.358621] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.358765] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.358914] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359076] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359229] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359386] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359546] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359709] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359876] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.359991] pci 0000:07:00.0: Boot video device
[    0.359996] PCI: CLS 64 bytes, default 64
[    0.360066] Trying to unpack rootfs image as initramfs...
[    0.519547] Freeing initrd memory: 7088k freed
[    0.524156] PCI-DMA: Disabling AGP.
[    0.524425] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.524526] PCI-DMA: using GART IOMMU.
[    0.524629] PCI-DMA: Reserving 64MB of IOMMU area in the AGP apertur=
e
[    0.529344] kvm: Nested Virtualization enabled
[    0.529464] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.529567] Modules linked in:
[    0.529687] Pid: 1, comm: swapper Not tainted 2.6.37-rc1-00166-g814c=
e25 #95
[    0.529789] Call Trace:
[    0.529894]  [<ffffffff81054ea5>] __schedule_bug+0x57/0x5b
[    0.529998]  [<ffffffff81710549>] schedule+0xf0/0x5bd
[    0.530118]  [<ffffffff810401e3>] ? flat_send_IPI_mask+0xc/0xe
[    0.530222]  [<ffffffff81054e04>] ? ttwu_post_activation+0xa8/0xb1
[    0.530325]  [<ffffffff81710c2c>] schedule_timeout+0x31/0xe6
[    0.530428]  [<ffffffff810575e6>] ? wake_up_process+0x10/0x12
[    0.530531]  [<ffffffff8171028a>] wait_for_common+0x9e/0x10b
[    0.530633]  [<ffffffff810575ba>] ? default_wake_function+0x0/0xf
[    0.530736]  [<ffffffff81710391>] wait_for_completion+0x18/0x1a
[    0.530840]  [<ffffffff8106b6ec>] call_usermodehelper_exec+0x76/0xc0
[    0.530944]  [<ffffffff812cbb65>] kobject_uevent_env+0x3c1/0x402
[    0.531062]  [<ffffffff812cbbb1>] kobject_uevent+0xb/0xd
[    0.531164]  [<ffffffff812caf9e>] kset_register+0x35/0x3c
[    0.531267]  [<ffffffff813982c2>] sysdev_class_register+0x62/0x7c
[    0.531370]  [<ffffffff81001b23>] kvm_init+0x186/0x30c
[    0.531473]  [<ffffffff81d3ccca>] ? pci_iommu_init+0x0/0x41
[    0.531575]  [<ffffffff81d3a68f>] ? svm_init+0x0/0x1e
[    0.531678]  [<ffffffff81d3a6ab>] svm_init+0x1c/0x1e
[    0.531780]  [<ffffffff81000210>] do_one_initcall+0x7a/0x129
[    0.531882]  [<ffffffff81d376b6>] kernel_init+0x15d/0x1e7
[    0.531986]  [<ffffffff81026854>] kernel_thread_helper+0x4/0x10
[    0.532103]  [<ffffffff81d37559>] ? kernel_init+0x0/0x1e7
[    0.532206]  [<ffffffff81026850>] ? kernel_thread_helper+0x0/0x10
[    0.532317] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.532420] Modules linked in:
[    0.532540] Pid: 1, comm: swapper Not tainted 2.6.37-rc1-00166-g814c=
e25 #95
[    0.532641] Call Trace:
[    0.532742]  [<ffffffff81054ea5>] __schedule_bug+0x57/0x5b
[    0.532845]  [<ffffffff81710549>] schedule+0xf0/0x5bd
[    0.532948]  [<ffffffff810401e3>] ? flat_send_IPI_mask+0xc/0xe
[    0.533066]  [<ffffffff81054e04>] ? ttwu_post_activation+0xa8/0xb1
[    0.533169]  [<ffffffff81710c2c>] schedule_timeout+0x31/0xe6
[    0.533272]  [<ffffffff810575e6>] ? wake_up_process+0x10/0x12
[    0.533375]  [<ffffffff8171028a>] wait_for_common+0x9e/0x10b
[    0.533477]  [<ffffffff810575ba>] ? default_wake_function+0x0/0xf
[    0.533580]  [<ffffffff81710391>] wait_for_completion+0x18/0x1a
[    0.533683]  [<ffffffff8106b6ec>] call_usermodehelper_exec+0x76/0xc0
[    0.533786]  [<ffffffff812cbb65>] kobject_uevent_env+0x3c1/0x402
[    0.533889]  [<ffffffff812cbbb1>] kobject_uevent+0xb/0xd
[    0.533991]  [<ffffffff8139810d>] sysdev_register+0xb2/0xc1
[    0.534108]  [<ffffffff81001b3a>] kvm_init+0x19d/0x30c
[    0.534211]  [<ffffffff81d3ccca>] ? pci_iommu_init+0x0/0x41
[    0.534313]  [<ffffffff81d3a68f>] ? svm_init+0x0/0x1e
[    0.534415]  [<ffffffff81d3a6ab>] svm_init+0x1c/0x1e
[    0.534517]  [<ffffffff81000210>] do_one_initcall+0x7a/0x129
[    0.536857]  [<ffffffff81d376b6>] kernel_init+0x15d/0x1e7
[    0.536960]  [<ffffffff81026854>] kernel_thread_helper+0x4/0x10
[    0.537076]  [<ffffffff81d37559>] ? kernel_init+0x0/0x1e7
[    0.537179]  [<ffffffff81026850>] ? kernel_thread_helper+0x0/0x10
[    0.537311] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.537414] Modules linked in:
[    0.537532] Pid: 1, comm: swapper Not tainted 2.6.37-rc1-00166-g814c=
e25 #95
[    0.537634] Call Trace:
[    0.537735]  [<ffffffff81054ea5>] __schedule_bug+0x57/0x5b
[    0.537837]  [<ffffffff81710549>] schedule+0xf0/0x5bd
[    0.537940]  [<ffffffff810401e3>] ? flat_send_IPI_mask+0xc/0xe
[    0.538059]  [<ffffffff81054e04>] ? ttwu_post_activation+0xa8/0xb1
[    0.538162]  [<ffffffff81710c2c>] schedule_timeout+0x31/0xe6
[    0.538265]  [<ffffffff810575e6>] ? wake_up_process+0x10/0x12
[    0.538367]  [<ffffffff8171028a>] wait_for_common+0x9e/0x10b
[    0.538470]  [<ffffffff810575ba>] ? default_wake_function+0x0/0xf
[    0.538573]  [<ffffffff81710391>] wait_for_completion+0x18/0x1a
[    0.538676]  [<ffffffff8106b6ec>] call_usermodehelper_exec+0x76/0xc0
[    0.538778]  [<ffffffff812cbb65>] kobject_uevent_env+0x3c1/0x402
[    0.538881]  [<ffffffff812cbbb1>] kobject_uevent+0xb/0xd
[    0.538983]  [<ffffffff81397623>] device_add+0x390/0x526
[    0.539101]  [<ffffffff813977d2>] device_register+0x19/0x1e
[    0.539203]  [<ffffffff81397868>] device_create_vargs+0x91/0xc2
[    0.539306]  [<ffffffff813978c5>] device_create+0x2c/0x2e
[    0.539410]  [<ffffffff810edd0c>] ? kmem_cache_create+0x24b/0x2a9
[    0.539514]  [<ffffffff8135f3c5>] misc_register+0xba/0x115
[    0.539616]  [<ffffffff81001b9e>] kvm_init+0x201/0x30c
[    0.539718]  [<ffffffff81d3ccca>] ? pci_iommu_init+0x0/0x41
[    0.539821]  [<ffffffff81d3a68f>] ? svm_init+0x0/0x1e
[    0.539923]  [<ffffffff81d3a6ab>] svm_init+0x1c/0x1e
[    0.540039]  [<ffffffff81000210>] do_one_initcall+0x7a/0x129
[    0.540142]  [<ffffffff81d376b6>] kernel_init+0x15d/0x1e7
[    0.540245]  [<ffffffff81026854>] kernel_thread_helper+0x4/0x10
[    0.540347]  [<ffffffff81d37559>] ? kernel_init+0x0/0x1e7
[    0.540451]  [<ffffffff81026850>] ? kernel_thread_helper+0x0/0x10
[    0.540629] initcall svm_init+0x0/0x1e returned with preemption imba=
lance=20
[    0.542245] Intel PCLMULQDQ-NI instructions are not detected.
[    0.542646] audit: initializing netlink socket (disabled)
[    0.542759] type=3D2000 audit(1289416453.541:1): initialized
[    0.557747] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.562739] VFS: Disk quotas dquot_6.5.2
[    0.562938] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    0.564588] NTFS driver 2.1.29 [Flags: R/O].
[    0.564923] fuse init (API version 7.15)
[    0.565562] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.569252] SGI XFS with ACLs, security attributes, large block/inod=
e numbers, no debug enabled
[    0.570356] SGI XFS Quota Management subsystem
[    0.570471] msgmni has been set to 11935
[    0.570707] SELinux:  Registering netfilter hooks
[    0.570919] alg: No test for cipher_null (cipher_null-generic)
[    0.571131] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.571269] alg: No test for digest_null (digest_null-generic)
[    0.571402] alg: No test for compress_null (compress_null-generic)
[    0.572750] alg: No test for fcrypt (fcrypt-generic)
[    0.575508] alg: No test for stdrng (krng)
[    0.575801] Block layer SCSI generic (bsg) driver version 0.4 loaded=
 (major 253)
[    0.575985] io scheduler noop registered
[    0.576136] io scheduler deadline registered (default)
[    0.576322] io scheduler cfq registered
[    0.576810] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.577077] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    0.577180] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.=
5
[    0.580118] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace faile=
d
[    0.581052] input: Power Button as /devices/LNXSYSTM:00/device:00/PN=
P0C0C:00/input/input0
[    0.581237] ACPI: Power Button [PWRB]
[    0.581447] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/=
input/input1
[    0.581629] ACPI: Power Button [PWRF]
[    0.582017] ACPI: acpi_idle registered with cpuidle
[    0.585137] ERST: Table is not found!
[    0.585240] GHES: HEST is not enabled!
[    0.585340] EINJ: Table is not found!
[    0.586705] lp: driver loaded but no devices found
[    0.587212] Non-volatile memory driver v1.3
[    0.588288] ppdev: user-space parallel port driver
[    0.588393] Linux agpgart interface v0.103
[    0.588626] ipmi message handler version 39.2
[    0.588742] ipmi device interface
[    0.588940] IPMI System Interface driver.
[    0.589182] ipmi_si: Adding default-specified kcs state machine
[    0.589304] ipmi_si: Trying default-specified kcs state machine at i=
/o address 0xca2, slave address 0x0, irq 0
[    0.589490] ipmi_si: Interface detection failed
[    0.592048] ipmi_si: Adding default-specified smic state machine
[    0.592169] ipmi_si: Trying default-specified smic state machine at =
i/o address 0xca9, slave address 0x0, irq 0
[    0.592353] ipmi_si: Interface detection failed
[    0.595024] ipmi_si: Adding default-specified bt state machine
[    0.595144] ipmi_si: Trying default-specified bt state machine at i/=
o address 0xe4, slave address 0x0, irq 0
[    0.595331] ipmi_si: Interface detection failed
[    0.599119] ipmi_si: Unable to find any System Interface(s)
[    0.599222] IPMI Watchdog: driver initialized
[    0.599322] Copyright (C) 2004 MontaVista Software - IPMI Powerdown =
via sys_reboot.
[    0.599508] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 s=
econds, margin is 60 seconds).
[    0.599689] Hangcheck: Using getrawmonotonic().
[    0.599858] [drm] Initialized drm 1.1.0 20060810
[    0.599960] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.864191] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.144188] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.212642] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.228302] parport_pc 00:08: reported by Plug and Play ACPI
[    1.228444] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    1.310160] lp0: using parport0 (interrupt-driven).
[    1.310262] lp0: console ready
[    1.313430] brd: module loaded
[    1.314859] loop: module loaded
[    1.315279] nbd: registered device at major 43
[    1.318746] Loading iSCSI transport class v2.0-870.
[    1.319531] rdac: device handler registered
[    1.319666] hp_sw: device handler registered
[    1.319768] emc: device handler registered
[    1.319869] st: Version 20100829, fixed bufsize 32768, s/g segs 256
[    1.320297] osst :I: Tape driver with OnStream support version 0.99.=
4
[    1.320298] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede E=
xp $
[    1.320839] SCSI Media Changer driver v0.25=20
[    1.321282] sata_nv 0000:00:05.0: version 3.5
[    1.321514] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    1.321626] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 =
(level, low) -> IRQ 23
[    1.321809] sata_nv 0000:00:05.0: Using SWNCQ mode
[    1.322149] sata_nv 0000:00:05.0: setting latency timer to 64
[    1.322723] scsi0 : sata_nv
[    1.323113] scsi1 : sata_nv
[    1.323442] ata1: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xbc=
00 irq 23
[    1.323546] ata2: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xbc=
08 irq 23
[    1.323872] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    1.323985] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 =
(level, low) -> IRQ 22
[    1.324226] sata_nv 0000:00:05.1: Using SWNCQ mode
[    1.324547] sata_nv 0000:00:05.1: setting latency timer to 64
[    1.325180] scsi2 : sata_nv
[    1.325462] scsi3 : sata_nv
[    1.325803] ata3: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb0=
80 irq 22
[    1.325907] ata4: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xb0=
88 irq 22
[    1.326248] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    1.326359] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 =
(level, low) -> IRQ 21
[    1.326542] sata_nv 0000:00:05.2: Using SWNCQ mode
[    1.326857] sata_nv 0000:00:05.2: setting latency timer to 64
[    1.327485] scsi4 : sata_nv
[    1.327756] scsi5 : sata_nv
[    1.328110] ata5: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa4=
80 irq 21
[    1.328213] ata6: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa4=
88 irq 21
[    1.328456] pata_amd 0000:00:04.0: version 0.4.1
[    1.328495] pata_amd 0000:00:04.0: setting latency timer to 64
[    1.329273] scsi6 : pata_amd
[    1.329543] scsi7 : pata_amd
[    1.331371] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0=
 irq 14
[    1.331475] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8=
 irq 15
[    1.332074] SSFDC read-only Flash Translation layer
[    1.332236] slram: not enough parameters.
[    1.332337] bonding: Ethernet Channel Bonding Driver: v3.7.0 (June 2=
, 2010)
[    1.332441] bonding: Warning: either miimon or arp_interval and arp_=
ip_target module parameters must be specified, otherwise bonding will n=
ot detect link failures! see bonding.txt for details.
[    1.333692] PPP generic driver version 2.4.2
[    1.333932] PPP Deflate Compression module registered
[    1.336173] PPP MPPE Compression module registered
[    1.336275] NET: Registered protocol family 24
[    1.336876] Equalizer2002: Simon Janes (simon@ncm.com) and David S. =
Miller (davem@redhat.com)
[    1.337233] tun: Universal TUN/TAP device driver, 1.6
[    1.337334] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.337516] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maro=
on.tc.umn.edu>
[    1.337850] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson =
<johns393@maroon.tc.umn.edu>
[    1.338107] usbcore: registered new interface driver cdc_ether
[    1.338256] usbcore: registered new interface driver cdc_eem
[    1.338405] usbcore: registered new interface driver rndis_host
[    1.338531] console [netcon0] enabled
[    1.338632] netconsole: network logging started
[    1.339068] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 19
[    1.339180] firewire_ohci 0000:01:04.0: PCI INT A -> Link[LNKD] -> G=
SI 19 (level, low) -> IRQ 19
[    1.390068] firewire_ohci: Added fw-ohci device 0000:01:04.0, OHCI v=
1.10, 4 IR + 8 IT contexts, quirks 0x1
[    1.390638] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    1.390973] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    1.391097] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23=
 (level, low) -> IRQ 23
[    1.391299] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    1.391302] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    1.393734] ehci_hcd 0000:00:02.1: new USB bus registered, assigned =
bus number 1
[    1.396043] ehci_hcd 0000:00:02.1: debug port 1
[    1.396147] ehci_hcd 0000:00:02.1: cache line size of 64 is not supp=
orted
[    1.396155] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe9fac00
[    1.402020] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    1.402352] hub 1-0:1.0: USB hub found
[    1.402457] hub 1-0:1.0: 10 ports detected
[    1.402694] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.402992] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    1.403108] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22=
 (level, low) -> IRQ 22
[    1.403304] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    1.403306] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    1.403414] ohci_hcd 0000:00:02.0: new USB bus registered, assigned =
bus number 2
[    1.411021] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe9fb000
[    1.464211] hub 2-0:1.0: USB hub found
[    1.464317] hub 2-0:1.0: 10 ports detected
[    1.464552] uhci_hcd: USB Universal Host Controller Interface driver
[    1.464812] usbcore: registered new interface driver cdc_acm
[    1.464914] cdc_acm: v0.26:USB Abstract Control Model driver for USB=
 modems and ISDN adapters
[    1.465169] usbcore: registered new interface driver usblp
[    1.465325] usbcore: registered new interface driver cdc_wdm
[    1.465427] Initializing USB Mass Storage driver...
[    1.465590] usbcore: registered new interface driver usb-storage
[    1.465692] USB Mass Storage support registered.
[    1.465848] usbcore: registered new interface driver ums-alauda
[    1.466018] usbcore: registered new interface driver ums-cypress
[    1.466177] usbcore: registered new interface driver ums-datafab
[    1.466334] usbcore: registered new interface driver ums-freecom
[    1.466491] usbcore: registered new interface driver ums-isd200
[    1.466648] usbcore: registered new interface driver ums-jumpshot
[    1.466805] usbcore: registered new interface driver ums-karma
[    1.466963] usbcore: registered new interface driver ums-onetouch
[    1.467131] usbcore: registered new interface driver ums-sddr09
[    1.467288] usbcore: registered new interface driver ums-sddr55
[    1.467447] usbcore: registered new interface driver ums-usbat
[    1.472228] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60=
,0x64 irq 1,12
[    1.475328] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.475435] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.475682] mice: PS/2 mouse device common for all mice
[    1.476081] input: PC Speaker as /devices/platform/pcspkr/input/inpu=
t2
[    1.476315] rtc_cmos 00:02: RTC can wake from S4
[    1.480113] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.480246] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet =
irqs
[    1.480399] i2c /dev entries driver
[    1.480801] i2c i2c-0: nForce2 SMBus adapter at 0x2d00
[    1.481043] i2c i2c-1: nForce2 SMBus adapter at 0x2e00
[    1.481252] k8temp 0000:00:18.3: Temperature readouts might be wrong=
 - check erratum #141
[    1.481664] w83627ehf: Found W83627EHG chip at 0xa10
[    1.482165] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O=
 chip initialising.
[    1.482370] w83627hf/thf/hg WDT: Watchdog already running. Resetting=
 timeout to 60 sec
[    1.482641] w83627hf/thf/hg WDT: initialized. timeout=3D60 sec (nowa=
yout=3D0)
[    1.482744] md: linear personality registered for level -1
[    1.482845] md: raid0 personality registered for level 0
[    1.482947] md: raid1 personality registered for level 1
[    1.483102] md: raid10 personality registered for level 10
[    1.483204] md: raid6 personality registered for level 6
[    1.483305] md: raid5 personality registered for level 5
[    1.483406] md: raid4 personality registered for level 4
[    1.483507] md: multipath personality registered for level -4
[    1.483610] md: faulty personality registered for level -5
[    1.483918] device-mapper: uevent: version 1.0.3
[    1.484300] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initiali=
sed: dm-devel@redhat.com
[    1.484707] Bluetooth: Virtual HCI driver ver 1.3
[    1.484877] Bluetooth: HCI UART driver ver 2.2
[    1.484979] Bluetooth: HCI H4 protocol initialized
[    1.485120] Bluetooth: HCI BCSP protocol initialized
[    1.485221] Bluetooth: HCILL protocol initialized
[    1.485322] Bluetooth: Broadcom Blutonium firmware driver ver 1.2
[    1.485489] usbcore: registered new interface driver bcm203x
[    1.485591] Bluetooth: Digianswer Bluetooth USB driver ver 0.10
[    1.485741] usbcore: registered new interface driver bpa10x
[    1.485843] Bluetooth: BlueFRITZ! USB driver ver 1.2
[    1.485993] usbcore: registered new interface driver bfusb
[    1.486113] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    1.486265] usbcore: registered new interface driver btusb
[    1.486367] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    1.486556] cpuidle: using governor ladder
[    1.486659] cpuidle: using governor menu
[    1.486914] sdhci: Secure Digital Host Controller Interface driver
[    1.487042] sdhci: Copyright(c) Pierre Ossman
[    1.487218] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    1.487320] wbsd: Copyright(c) Pierre Ossman
[    1.488875] usbcore: registered new interface driver usbhid
[    1.488977] usbhid: USB HID core driver
[    1.490523] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    1.490630] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 2=
1 (level, low) -> IRQ 21
[    1.490813] hda_intel: Disable MSI for Nvidia chipset
[    1.490940] HDA Intel 0000:00:06.1: setting latency timer to 64
[    1.505531] ata7.00: ATA-6: HDS722516VLAT80, V34OA6MA, max UDMA/100
[    1.505635] ata7.00: 321672960 sectors, multi 16: LBA48=20
[    1.505743] ata7: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=3D0=
x3f000 (0xc6000000) ACPI=3D0x3f01f (20:900:0x11)
[    1.514444] ata7.00: configured for UDMA/100
[    1.629020] ata3: SATA link down (SStatus 0 SControl 300)
[    1.631020] ata5: SATA link down (SStatus 0 SControl 300)
[    1.704021] usb 1-3: new high speed USB device using ehci_hcd and ad=
dress 2
[    1.777031] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.778022] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.780123] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/=
66
[    1.781302] ata2.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max U=
DMA/133
[    1.781406] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 3=
1/32)
[    1.784114] ata1.00: configured for UDMA/66
[    1.787290] ata2.00: configured for UDMA/133
[    1.787506] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT7250=
3 V54O PQ: 0 ANSI: 5
[    1.788021] sd 1:0:0:0: [sda] 625142448 512-byte logical blocks: (32=
0 GB/298 GiB)
[    1.788165] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    1.788403] sd 1:0:0:0: [sda] Write Protect is off
[    1.788507] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.788547] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    1.792878] ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 18
[    1.792993] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 1=
8 (level, low) -> IRQ 18
[    1.793237] HDA Intel 0000:07:00.1: irq 40 for MSI/MSI-X
[    1.793258] HDA Intel 0000:07:00.1: setting latency timer to 64
[    1.796337] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215=
  1.18 PQ: 0 ANSI: 5
[    1.797701] ALSA device list:
[    1.797804]   #0: Dummy 1
[    1.797904]   #1: Virtual MIDI Card 1
[    1.798022]   #2: HDA NVidia at 0xfe9f0000 irq 21
[    1.798123]   #3: HD-Audio Generic at 0xfebbc000 irq 40
[    1.798320] oprofile: using NMI interrupt.
[    1.798506] GACT probability on
[    1.798609] Mirror/redirect action on
[    1.798710] Simple TC action Loaded
[    1.798989] netem: version 1.2
[    1.799105] u32 classifier
[    1.799204]     Performance counters on
[    1.799304]     input device check on
[    1.799404]     Actions configured
[    1.799506] Netfilter messages via NETLINK v0.30.
[    1.799626] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.800167] xt_time: kernel timezone is -0000
[    1.800290] IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
[    1.800415] IPVS: Connection hash table configured (size=3D4096, mem=
ory=3D64Kbytes)
[    1.800636] IPVS: ipvs loaded.
[    1.800737] IPVS: [rr] scheduler registered.
[    1.800837] IPVS: [wrr] scheduler registered.
[    1.800938] IPVS: [lc] scheduler registered.
[    1.801107] IPVS: [wlc] scheduler registered.
[    1.801211] IPVS: [lblc] scheduler registered.
[    1.801313] IPVS: [lblcr] scheduler registered.
[    1.801413] IPVS: [dh] scheduler registered.
[    1.801514] IPVS: [sh] scheduler registered.
[    1.801614] IPVS: [sed] scheduler registered.
[    1.801715] IPVS: [nq] scheduler registered.
[    1.801817] IPVS: ftp: loaded support on port[0] =3D 21
[    1.801918] IPVS: [sip] pe registered.
[    1.802042] IPv4 over IPv4 tunneling driver
[    1.802444] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.802590] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    1.802734] arp_tables: (C) 2002 David S. Miller
[    1.802871] TCP bic registered
[    1.802986] TCP cubic registered
[    1.803143] TCP westwood registered
[    1.803255] TCP highspeed registered
[    1.803366] TCP hybla registered
[    1.803474] TCP htcp registered
[    1.803574] TCP vegas registered
[    1.803673] TCP veno registered
[    1.803773] TCP scalable registered
[    1.803874] TCP lp registered
[    1.803973] TCP yeah registered
[    1.804100] TCP illinois registered
[    1.804201] Initializing XFRM netlink socket
[    1.804649] NET: Registered protocol family 10
[    1.804946] lo: Disabled Privacy Extensions
[    1.805331] tunl0: Disabled Privacy Extensions
[    1.805504] Mobile IPv6
[    1.805614] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.805769] IPv6 over IPv4 tunneling driver
[    1.806133] sit0: Disabled Privacy Extensions
[    1.806442] ip6tnl0: Disabled Privacy Extensions
[    1.806566] NET: Registered protocol family 17
[    1.809032] NET: Registered protocol family 15
[    1.809173] Bridge firewalling registered
[    1.809276] Ebtables v2.0 registered
[    1.809421] NET: Registered protocol family 5
[    1.821971] hub 1-3:1.0: USB hub found
[    1.822398] hub 1-3:1.0: 4 ports detected
[    1.824072] Bluetooth: L2CAP ver 2.15
[    1.824172] Bluetooth: L2CAP socket layer initialized
[    1.824277] Bluetooth: SCO (Voice Link) ver 0.6
[    1.824377] Bluetooth: SCO socket layer initialized
[    1.824524] Bluetooth: RFCOMM TTY layer initialized
[    1.824629] Bluetooth: RFCOMM socket layer initialized
[    1.824730] Bluetooth: RFCOMM ver 1.11
[    1.824831] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.824932] Bluetooth: BNEP filters: protocol multicast
[    1.825050] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.825230] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech=
=2Ecom>
[    1.825332] All bugs added by David S. Miller <davem@redhat.com>
[    1.828627]  sda: sda1 sda2 sda3 sda4
[    1.828925] CCID: Activated CCID 2 (TCP-like)
[    1.829069] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[    1.829259] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.830770] sctp: Hash tables configured (established 65536 bind 655=
36)
[    1.835492] sctp_probe: probe registered (port=3D0)
[    1.835596] TIPC: Activated (version 2.0.0 compiled Nov  9 2010 21:3=
7:27)
[    1.835927] NET: Registered protocol family 30
[    1.836053] TIPC: Started in single node mode
[    1.836155] Registering the dns_resolver key type
[    1.836278] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Proc=
essor 5000+ (2 cpu cores) (version 2.20.00)
[    1.836505] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    1.836606] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    1.836708] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    1.836809] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    1.836911] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    1.837029] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    1.837448] PM: Hibernation image not present or could not be loaded=
=2E
[    1.837463] registered taskstats version 1
[    1.837869] rtc_cmos 00:02: setting system clock to 2010-11-10 19:14=
:15 UTC (1289416455)
[    1.838074] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    1.838348] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/fo=
rm2 cdda tray
[    1.838533] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.838696] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.838865] sr 0:0:0:0: Attached scsi generic sg1 type 5
[    1.891139] firewire_core: created device fw0: GUID 0010dc0000cf25c6=
, S400
[    1.925016] usb 1-4: new high speed USB device using ehci_hcd and ad=
dress 3
[    2.039976] hub 1-4:1.0: USB hub found
[    2.040148] hub 1-4:1.0: 4 ports detected
[    2.041175] hub 1-0:1.0: over-current change on port 1
[    2.142018] hub 1-0:1.0: over-current change on port 2
[    2.142030] ata4: SATA link down (SStatus 0 SControl 300)
[    2.316529] usb 1-3.3: new low speed USB device using ehci_hcd and a=
ddress 4
[    2.418791] input: Microsoft Microsoft IntelliMouse=C2=AE Optical as=
 /devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3.3/1-3.3:1.0/input/input3
[    2.419259] generic-usb 0003:045E:0029.0001: input,hidraw0: USB HID =
v1.00 Mouse [Microsoft Microsoft IntelliMouse=C2=AE Optical] on usb-000=
0:00:02.1-3.3/input0
[    2.445022] ata6: SATA link down (SStatus 0 SControl 300)
[    2.445287] scsi 6:0:0:0: Direct-Access     ATA      HDS722516VLAT80=
  V34O PQ: 0 ANSI: 5
[    2.445818] sd 6:0:0:0: [sdb] 321672960 512-byte logical blocks: (16=
4 GB/153 GiB)
[    2.445929] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    2.446058] ata8: port disabled. ignoring.
[    2.446235] sd 6:0:0:0: [sdb] Write Protect is off
[    2.446343] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.446390] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    2.459043]  sdb: sdb1
[    2.459536] sd 6:0:0:0: [sdb] Attached SCSI disk
[    2.459671] Freeing unused kernel memory: 580k freed
[    2.460119] Write protecting the kernel read-only data: 12288k
[    2.460499] Freeing unused kernel memory: 900k freed
[    2.461311] Freeing unused kernel memory: 1092k freed
[    2.483542] usb 1-3.4: new low speed USB device using ehci_hcd and a=
ddress 5
[    2.491800] dracut: dracut-005-5.fc13
[    2.501021] Clocksource tsc unstable (delta =3D -76682387 ns)
[    2.507683] udev: starting version 153
[    2.507871] udevd (1371): /proc/1371/oom_adj is deprecated, please u=
se /proc/1371/oom_score_adj instead.
[    2.587388] input: DELL DELL USB Keyboard as /devices/pci0000:00/000=
0:00:02.1/usb1/1-3/1-3.4/1-3.4:1.0/input/input4
[    2.588570] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID =
v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-3.4/input0
[    2.598451] [drm] radeon defaulting to kernel modesetting.
[    2.598584] [drm] radeon kernel modesetting enabled.
[    2.599213] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 17
[    2.599416] radeon 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 17 (=
level, low) -> IRQ 17
[    2.599627] radeon 0000:07:00.0: setting latency timer to 64
[    2.604344] [drm] initializing kernel modesetting (REDWOOD 0x1002:0x=
68D9).
[    2.604583] [drm] register mmio base: 0xFEBE0000
[    2.604697] [drm] register mmio size: 131072
[    2.606812] input: DELL DELL USB Keyboard as /devices/pci0000:00/000=
0:00:02.1/usb1/1-3/1-3.4/1-3.4:1.1/input/input5
[    2.607957] generic-usb 0003:413C:2003.0003: input,hidraw2: USB HID =
v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-3.4/input1
[    2.609340] ATOM BIOS: REDWOOD
[    2.609490] radeon 0000:07:00.0: VRAM: 1024M 0x00000000 - 0x3FFFFFFF=
 (1024M used)
[    2.609679] radeon 0000:07:00.0: GTT: 512M 0x40000000 - 0x5FFFFFFF
[    2.609998] [drm] Detected VRAM RAM=3D1024M, BAR=3D256M
[    2.610146] [drm] RAM width 128bits DDR
[    2.610341] [TTM] Zone  kernel: Available graphics memory: 3056820 k=
iB.
[    2.610452] [TTM] Zone   dma32: Available graphics memory: 2097152 k=
iB.
[    2.610559] [TTM] Initializing pool allocator.
[    2.610698] [drm] radeon: 1024M of VRAM memory ready
[    2.610804] [drm] radeon: 512M of GTT memory ready.
[    2.610975] radeon 0000:07:00.0: irq 41 for MSI/MSI-X
[    2.610981] radeon 0000:07:00.0: radeon: using MSI.
[    2.611184] [drm] radeon: irq initialized.
[    2.611291] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.613846] [drm] Loading REDWOOD Microcode
[    2.624201] radeon 0000:07:00.0: WB enabled
[    2.642253] [drm] ring test succeeded in 0 usecs
[    2.642599] [drm] radeon: ib pool ready.
[    2.642839] [drm] ib test succeeded in 0 usecs
[    2.642950] failed to evaluate ATIF got AE_BAD_PARAMETER
[    2.646183] [drm] Radeon Display Connectors
[    2.646294] [drm] Connector 0:
[    2.646398] [drm]   DisplayPort
[    2.646502] [drm]   HPD4
[    2.646606] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0=
x645c 0x645c
[    2.646793] [drm]   Encoders:
[    2.646897] [drm]     DFP1: INTERNAL_UNIPHY2
[    2.647062] [drm] Connector 1:
[    2.647165] [drm]   DVI-I
[    2.647268] [drm]   HPD1
[    2.647373] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0=
x646c 0x646c
[    2.647560] [drm]   Encoders:
[    2.647663] [drm]     DFP2: INTERNAL_UNIPHY1
[    2.647768] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.647873] [drm] Connector 2:
[    2.647976] [drm]   VGA
[    2.648097] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0=
x643c 0x643c
[    2.648285] [drm]   Encoders:
[    2.648388] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    2.670427] usb 1-4.1: new high speed USB device using ehci_hcd and =
address 6
[    2.727357] [drm] Internal thermal controller with fan control
[    2.727611] [drm] radeon: power management initialized
[    2.808741] [drm] fb mappable at 0xC0141000
[    2.808846] [drm] vram apper at 0xC0000000
[    2.808950] [drm] size 8294400
[    2.809060] [drm] fb depth is 24
[    2.809163] [drm]    pitch is 7680
[    2.809386] fbcon: radeondrmfb (fb0) is primary device
[    2.819415] usb 1-4.4: new high speed USB device using ehci_hcd and =
address 7
[    3.245522] Console: switching to colour frame buffer device 240x67
[    3.257820] fb0: radeondrmfb frame buffer device
[    3.257871] drm: registered panic notifier
[    3.257922] [drm] Initialized radeon 2.7.0 20080528 for 0000:07:00.0=
 on minor 0
[    3.309619] dracut: Starting plymouth daemon
[    3.533260] Floppy drive(s): fd0 is 1.44M
[    3.547801] FDC 0 is a post-1991 82077
[   12.298249] EXT4-fs (dm-1): mounted filesystem with ordered data mod=
e. Opts: (null)
[   12.339758] dracut: Remounting /dev/mapper/luks-1bda98a6-c825-4097-b=
472-3d8050c1a022 with -o noatime,data=3Dwriteback,ro
[   12.409161] EXT4-fs (dm-1): mounted filesystem with writeback data m=
ode. Opts: data=3Dwriteback
[   12.437310] dracut: Mounted root filesystem /dev/mapper/luks-1bda98a=
6-c825-4097-b472-3d8050c1a022
[   12.620918] dracut: Loading SELinux policy
[   12.999294] type=3D1404 audit(1289416466.661:2): enforcing=3D1 old_e=
nforcing=3D0 auid=3D4294967295 ses=3D4294967295
[   13.181186] SELinux: 2048 avtab hash slots, 203933 rules.
[   13.253215] SELinux: 2048 avtab hash slots, 203933 rules.
[   13.766914] SELinux:  9 users, 13 roles, 3435 types, 172 bools, 1 se=
ns, 1024 cats
[   13.766919] SELinux:  77 classes, 203933 rules
[   13.771395] SELinux:  Permission read_policy in class security not d=
efined in policy.
[   13.771425] SELinux:  Permission audit_access in class file not defi=
ned in policy.
[   13.771433] SELinux:  Permission audit_access in class dir not defin=
ed in policy.
[   13.771436] SELinux:  Permission execmod in class dir not defined in=
 policy.
[   13.771444] SELinux:  Permission audit_access in class lnk_file not =
defined in policy.
[   13.771446] SELinux:  Permission open in class lnk_file not defined =
in policy.
[   13.771449] SELinux:  Permission execmod in class lnk_file not defin=
ed in policy.
[   13.771454] SELinux:  Permission audit_access in class chr_file not =
defined in policy.
[   13.771460] SELinux:  Permission audit_access in class blk_file not =
defined in policy.
[   13.771463] SELinux:  Permission execmod in class blk_file not defin=
ed in policy.
[   13.771469] SELinux:  Permission audit_access in class sock_file not=
 defined in policy.
[   13.771472] SELinux:  Permission execmod in class sock_file not defi=
ned in policy.
[   13.771478] SELinux:  Permission audit_access in class fifo_file not=
 defined in policy.
[   13.771481] SELinux:  Permission execmod in class fifo_file not defi=
ned in policy.
[   13.771613] SELinux: the above unknown classes and permissions will =
be allowed
[   13.771624] SELinux:  Completing initialization.
[   13.771625] SELinux:  Setting up existing superblocks.
[   13.771637] SELinux: initialized (dev sysfs, type sysfs), uses genfs=
_contexts
[   13.771644] SELinux: initialized (dev rootfs, type rootfs), uses gen=
fs_contexts
[   13.772064] SELinux: initialized (dev bdev, type bdev), uses genfs_c=
ontexts
[   13.772072] SELinux: initialized (dev proc, type proc), uses genfs_c=
ontexts
[   13.772081] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
[   13.772095] SELinux: initialized (dev sockfs, type sockfs), uses tas=
k SIDs
[   13.772101] SELinux: initialized (dev debugfs, type debugfs), uses g=
enfs_contexts
[   13.772197] SELinux: initialized (dev pipefs, type pipefs), uses tas=
k SIDs
[   13.772203] SELinux: initialized (dev anon_inodefs, type anon_inodef=
s), uses genfs_contexts
[   13.772208] SELinux: initialized (dev devpts, type devpts), uses tra=
nsition SIDs
[   13.772238] SELinux: initialized (dev hugetlbfs, type hugetlbfs), us=
es transition SIDs
[   13.772249] SELinux: initialized (dev mqueue, type mqueue), uses tra=
nsition SIDs
[   13.772256] SELinux: initialized (dev selinuxfs, type selinuxfs), us=
es genfs_contexts
[   13.772281] SELinux: initialized (dev mtd_inodefs, type mtd_inodefs)=
, not configured for labeling
[   13.772287] SELinux: initialized (dev configfs, type configfs), uses=
 genfs_contexts
[   13.772293] SELinux: initialized (dev usbfs, type usbfs), uses genfs=
_contexts
[   13.772301] SELinux: initialized (dev sysfs, type sysfs), uses genfs=
_contexts
[   13.773297] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
[   13.774703] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
[   13.774717] SELinux: initialized (dev dm-1, type ext4), uses xattr
[   13.796666] type=3D1403 audit(1289416467.458:3): policy loaded auid=3D=
4294967295 ses=3D4294967295
[   13.799446] dracut:=20
[   14.493801] dracut: Switching root
[   15.446358] readahead: starting
[   18.421170] udev: starting version 153
[   20.029882] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
[   20.029898] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 =
(level, low) -> IRQ 16
[   20.030023] Olympic.c v1.0.5 6/04/02 - Peter De Schrijver & Mike Phi=
llips
[   20.030027] 0000:01:00.0. I/O at d800, MMIO at ffffc90011d26c00, LAP=
 at ffffc900106ce000, using irq 16
[   20.050153] forcedeth: Reverse Engineered nForce ethernet driver. Ve=
rsion 0.64.
[   20.050440] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[   20.050454] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 2=
0 (level, low) -> IRQ 20
[   20.050460] forcedeth 0000:00:08.0: setting latency timer to 64
[   20.050528] nv_probe: set workaround bit for reversed mac addr
[   20.349119] type=3D1400 audit(1289416474.010:4): avc:  denied  { mma=
p_zero } for  pid=3D2720 comm=3D"vbetool" scontext=3Dsystem_u:system_r:=
vbetool_t:s0-s0:c0.c1023 tcontext=3Dsystem_u:system_r:vbetool_t:s0-s0:c=
0.c1023 tclass=3Dmemprotect
[   20.364383] rndis_wlan 1-4.1:1.0: wlan0: register 'rndis_wlan' at us=
b-0000:00:02.1-4.1, Wireless RNDIS device, BCM4320b based, 00:16:01:cf:=
56:29
[   20.364415] usbcore: registered new interface driver rndis_wlan
[   20.568498] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, =
addr 60:50:40:30:20:10
[   20.568502] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gb=
it lnktim msi desc-v3
[   20.568769] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[   20.568775] forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 2=
0 (level, low) -> IRQ 20
[   20.568779] forcedeth 0000:00:09.0: setting latency timer to 64
[   20.568853] nv_probe: set workaround bit for reversed mac addr
[   21.087661] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, =
addr 60:50:40:30:20:11
[   21.087666] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt gb=
it lnktim msi desc-v3
[   21.090244] cfg80211: Calling CRDA for country: DE
[   21.329619] cfg80211: Regulatory domain changed to country: DE
[   21.329623]     (start_freq - end_freq @ bandwidth), (max_antenna_ga=
in, max_eirp)
[   21.329626]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 =
mBm)
[   21.329629]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 =
mBm)
[   21.329631]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 =
mBm)
[   23.772175] Olympic: 0000:01:00.0 registered as: tr0
[   31.480995] EXT4-fs (dm-1): re-mounted. Opts: data=3Dwriteback
[   31.982267] SELinux: initialized (dev sda1, type ext2), uses xattr
[   33.884334] Adding 6386492k swap on /dev/mapper/luks-swap.  Priority=
:-1 extents:1 across:6386492k=20
[   33.887086] SELinux: initialized (dev binfmt_misc, type binfmt_misc)=
, uses genfs_contexts
[   36.169559] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   36.173905] forcedeth 0000:00:08.0: irq 42 for MSI/MSI-X
[   36.174011] eth0: no link during initialization.
[   36.175725] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.187050] forcedeth 0000:00:09.0: irq 43 for MSI/MSI-X
[   36.187243] eth1: no link during initialization.
[   36.188880] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   44.943284] hda-intel: IRQ timing workaround is activated for card #=
3. Suggest a bigger bdl_pos_adj.
[   58.038947] SELinux: initialized (dev fuse, type fuse), uses genfs_c=
ontexts
[   60.039031] end_request: I/O error, dev fd0, sector 0
[   60.096033] end_request: I/O error, dev fd0, sector 0
[   71.704922] rndis_wlan 1-4.1:1.0: wlan0: media connect
[   71.732952] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   82.330013] wlan0: no IPv6 routers present
[  313.312019] EXT4-fs (dm-1): error count: 50
[  313.312026] EXT4-fs (dm-1): initial error at 1288599125: ext4_mb_gen=
erate_buddy:718
[  313.312030] EXT4-fs (dm-1): last error at 1288723194: mb_free_blocks=
:1303: inode 15034661: block 60114723


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
