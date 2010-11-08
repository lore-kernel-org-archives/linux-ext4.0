From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Date: Mon, 08 Nov 2010 19:55:28 +0100
Message-ID: <1289242528.11571.8.camel@localhost.localdomain>
References: <201011032334.30662.thomas@m3y3r.de>
	 <201011080014.33354.thomas@m3y3r.de>
	 <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Montag, den 08.11.2010, 10:51 +0100 schrieb Thomas Gleixner:=20
> On Mon, 8 Nov 2010, Thomas Meyer wrote:
> > >=20
> > > [   300.000697] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36 #2 M=
S-7250/MS-7250
> > > [   300.000815] RIP: 0010:[<ffffffff8105faf4>]  [<ffffffff8105faf=
4>] cascade+0x54/0x7a
>=20
> Can you please enable
>=20
> CONFIG_DEBUG_OBJECTS
> CONFIG_DEBUG_OBJECTS_FREE
> CONFIG_DEBUG_OBJECTS_TIMERS
> and set CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT to 1
>=20
> That should give us more useful data.

=46irst results:

WARNING: at lib/debugobjects.c:259 debug_print_object+0x5b/0x63()
Hardware name: MS-7250
ODEBUG: free active (active state 0) object type: timer_list
Modules linked in: floppy radeon ttm drm_kms_helper
Pid: 2259, comm: umount Not tainted 2.6.36 #4
Call Trace:
[<ffffffff810577d2>] warn_slowpath_common+0x80/0x98
[<ffffffff8105787e>] warn_slowpath_fmt+0x41/0x43
[<ffffffff812cab46>] debug_print_object+0x5b/0x63
[<ffffffff812cb024>] debug_check_no_obj_freed+0x94/0x1d3
[<ffffffff817032d3>] ? _raw_spin_unlock_irq+0x1f/0x2a
[<ffffffff810e4cd7>] kfree+0x75/0xb6
[<ffffffff81172c75>] ? ext4_put_super+0x32b/0x33a
[<ffffffff81172c75>] ext4_put_super+0x32b/0x33a
[<ffffffff810ed276>] generic_shutdown_super+0x51/0xd2
[<ffffffff810ed319>] kill_block_super+0x22/0x3a
[<ffffffff810ecda6>] deactivate_locked_super+0x21/0x41
[<ffffffff810ed220>] deactivate_super+0x40/0x45
[<ffffffff811010a5>] mntput_no_expire+0xdd/0x10b
[<ffffffff8110161a>] sys_umount+0x2d2/0x2fd
[<ffffffff81705f1e>] ? do_page_fault+0x217/0x244
[<ffffffff81022a2b>] system_call_fastpath+0x16/0x1b

I didn't encounter a kernel crash with the DEBUG_OBJECT options enabled=
=2E
Uptime is 30 min. now.

$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.36 (thomas@localhost.localdomain) (gcc=
 version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #4 SMP PREEMPT Mon N=
ov 8 19:16:43 CET 2010
[    0.000000] Command line: ro root=3D/dev/mapper/luks-1bda98a6-c825-4=
097-b472-3d8050c1a022 SYSFONT=3Dlatarcyrheb-sun16 LANG=3Dde_DE.UTF-8 KE=
YTABLE=3Dde-latin1-nodeadkeys rhgb kgdboc=3Dkms,kbd quiet
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
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (=
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
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffd0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffd0000 page 4k
[    0.000000] kernel direct mapping tables up to bffd0000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000]  0100000000 - 01c0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1c0000000 @ b000-1300=
0
[    0.000000] RAMDISK: 37909000 - 37ff0000
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
[    0.000000]  [ffffea0000000000-ffffea00061fffff] PMD -> [ffff8800028=
00000-ffff880007bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffd0
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] On node 0 totalpages: 1572718
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3942 pages, LIFO batch:0
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
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
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
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002000000 s81024 r=
8192 d21376 u1048576
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u1048576 alloc=3D1*20971=
52
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  =
Total pages: 1547630
[    0.000000] Kernel command line: ro root=3D/dev/mapper/luks-1bda98a6=
-c825-4097-b472-3d8050c1a022 SYSFONT=3Dlatarcyrheb-sun16 LANG=3Dde_DE.U=
TF-8 KEYTABLE=3Dde-latin1-nodeadkeys rhgb kgdboc=3Dkms,kbd quiet
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
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000=
024000000
[    0.000000] early_res array is doubled to 128 at [e000 - efff]
[    0.000000] Subtract (58 early reservations)
[    0.000000]   #1 [0001000000 - 0001f00f60]   TEXT DATA BSS
[    0.000000]   #2 [0037909000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001f01000 - 0001f0116c]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009fc00 - 00000fcee0]   BIOS reserved
[    0.000000]   #7 [00000fd064 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fcee0 - 00000fd064]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 000000b000]         PGTABLE
[    0.000000]   #12 [000000b000 - 000000e000]         PGTABLE
[    0.000000]   #13 [0001f01180 - 0001f02180]         BOOTMEM
[    0.000000]   #14 [0002302180 - 0002302600]         BOOTMEM
[    0.000000]   #15 [0002703000 - 0002704000]         BOOTMEM
[    0.000000]   #16 [0002704000 - 0002705000]         BOOTMEM
[    0.000000]   #17 [0002800000 - 0007c00000]        MEMMAP 0
[    0.000000]   #18 [0001f02180 - 0001f02300]         BOOTMEM
[    0.000000]   #19 [0001f02300 - 0001f1a300]         BOOTMEM
[    0.000000]   #20 [0001f1a300 - 0001f32300]         BOOTMEM
[    0.000000]   #21 [0001f33000 - 0001f34000]         BOOTMEM
[    0.000000]   #22 [0001f00f80 - 0001f00fc1]         BOOTMEM
[    0.000000]   #23 [0001f32300 - 0001f32343]         BOOTMEM
[    0.000000]   #24 [0001f32380 - 0001f32620]         BOOTMEM
[    0.000000]   #25 [0001f32640 - 0001f326a8]         BOOTMEM
[    0.000000]   #26 [0001f326c0 - 0001f32728]         BOOTMEM
[    0.000000]   #27 [0001f32740 - 0001f327a8]         BOOTMEM
[    0.000000]   #28 [0001f327c0 - 0001f32828]         BOOTMEM
[    0.000000]   #29 [0001f32840 - 0001f328a8]         BOOTMEM
[    0.000000]   #30 [0001f328c0 - 0001f32928]         BOOTMEM
[    0.000000]   #31 [0001f32940 - 0001f329a8]         BOOTMEM
[    0.000000]   #32 [0001f329c0 - 0001f32a28]         BOOTMEM
[    0.000000]   #33 [0001f32a40 - 0001f32aa8]         BOOTMEM
[    0.000000]   #34 [0001f32ac0 - 0001f32b28]         BOOTMEM
[    0.000000]   #35 [0001f32b40 - 0001f32ba8]         BOOTMEM
[    0.000000]   #36 [0001f32bc0 - 0001f32be0]         BOOTMEM
[    0.000000]   #37 [0001f32c00 - 0001f32c20]         BOOTMEM
[    0.000000]   #38 [0001f32c40 - 0001f32ce1]         BOOTMEM
[    0.000000]   #39 [0001f32d00 - 0001f32da1]         BOOTMEM
[    0.000000]   #40 [0002000000 - 000201b000]         BOOTMEM
[    0.000000]   #41 [0002100000 - 000211b000]         BOOTMEM
[    0.000000]   #42 [0001f32dc0 - 0001f32dc8]         BOOTMEM
[    0.000000]   #43 [0001f32e00 - 0001f32e08]         BOOTMEM
[    0.000000]   #44 [0001f32e40 - 0001f32e48]         BOOTMEM
[    0.000000]   #45 [0001f32e80 - 0001f32e90]         BOOTMEM
[    0.000000]   #46 [0001f32ec0 - 0001f33000]         BOOTMEM
[    0.000000]   #47 [0001f36000 - 0001f36060]         BOOTMEM
[    0.000000]   #48 [0001f36080 - 0001f360e0]         BOOTMEM
[    0.000000]   #49 [0001f36100 - 0001f3e100]         BOOTMEM
[    0.000000]   #50 [0007c00000 - 0008400000]         BOOTMEM
[    0.000000]   #51 [0002302600 - 0002702600]         BOOTMEM
[    0.000000]   #52 [0020000000 - 0024000000]         BOOTMEM
[    0.000000]   #53 [0001f34000 - 0001f34020]         BOOTMEM
[    0.000000]   #54 [0008400000 - 000c400000]         BOOTMEM
[    0.000000]   #55 [0001f3e100 - 0001f5e100]         BOOTMEM
[    0.000000]   #56 [0001f5e100 - 0001f9e100]         BOOTMEM
[    0.000000]   #57 [000000f000 - 0000017000]         BOOTMEM
[    0.000000] Memory: 6038128k/7340032k available (7209k kernel code, =
1049160k absent, 252744k reserved, 6209k data, 580k init)
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjec=
ts=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
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
[    0.001010] pid_max: default: 32768 minimum: 301
[    0.001030] Security Framework initialized
[    0.001035] SELinux:  Initializing.
[    0.001042] SELinux:  Starting in permissive mode
[    0.001088] Mount-cache hash table entries: 256
[    0.001225] Initializing cgroup subsys ns
[    0.001229] Initializing cgroup subsys cpuacct
[    0.001253] tseg: 0000000000
[    0.001261] CPU: Physical Processor ID: 0
[    0.001262] CPU: Processor Core ID: 0
[    0.001265] mce: CPU supports 5 MCE banks
[    0.001274] using C1E aware idle routine
[    0.001275] Performance Events: AMD PMU driver.
[    0.001280] ... version:                0
[    0.001281] ... bit width:              48
[    0.001283] ... generic registers:      4
[    0.001284] ... value mask:             0000ffffffffffff
[    0.001286] ... max period:             00007fffffffffff
[    0.001287] ... fixed-purpose events:   0
[    0.001289] ... event mask:             000000000000000f
[    0.001316] ACPI: Core revision 20100702
[    0.007051] Setting APIC routing to flat
[    0.007572] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.017911] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ ste=
pping 02
[    0.019059] NMI watchdog enabled, takes one hw-pmu counter.
[    0.022020] Booting Node   0, Processors  #1 Ok.
[    0.093091] NMI watchdog enabled, takes one hw-pmu counter.
[    0.094004] Brought up 2 CPUs
[    0.094006] Total of 2 processors activated (10399.62 BogoMIPS).
[    0.094178] xor: automatically using best checksumming function: gen=
eric_sse
[    0.099009]    generic_sse:  7924.000 MB/sec
[    0.099011] xor: using function: generic_sse (7924.000 MB/sec)
[    0.099053] NET: Registered protocol family 16
[    0.099076] node 0 link 0: io port [1000, ffffff]
[    0.099076] node 0 link 0: io port [2000, 2fff]
[    0.099076] TOM: 00000000c0000000 aka 3072M
[    0.099076] node 0 link 0: mmio [e0000000, efffffff]
[    0.099076] node 0 link 0: mmio [a0000, bffff]
[    0.099076] node 0 link 0: mmio [c0000000, fe0bffff]
[    0.099076] TOM2: 00000001c0000000 aka 7168M
[    0.099076] bus: [00, ff] on node 0 link 0
[    0.099076] bus: 00 index 0 [io  0x0000-0xffff]
[    0.099076] bus: 00 index 1 [mem 0xc0000000-0xffffffff]
[    0.099076] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.099076] bus: 00 index 3 [mem 0x1c0000000-0xfcffffffff]
[    0.099076] ACPI: bus type pci registered
[    0.099076] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe000=
0000-0xefffffff] (base 0xe0000000)
[    0.099076] PCI: not using MMCONFIG
[    0.099076] PCI: Using configuration type 1 for base access
[    0.110222] bio: create slab <bio-0> at 0
[    0.127014] raid6: int64x1   2312 MB/s
[    0.143976] raid6: int64x2   2574 MB/s
[    0.160982] raid6: int64x4   1941 MB/s
[    0.178015] raid6: int64x8   1437 MB/s
[    0.194975] raid6: sse2x1    3558 MB/s
[    0.211972] raid6: sse2x2    4726 MB/s
[    0.228978] raid6: sse2x4    4953 MB/s
[    0.228980] raid6: using algorithm sse2x4 (4953 MB/s)
[    0.229764] ACPI: EC: Look up EC in DSDT
[    0.230907] ACPI: Executed 1 blocks of module-level executable AML c=
ode
[    0.234447] ACPI: Interpreter enabled
[    0.234449] ACPI: (supports S0 S3 S4 S5)
[    0.234467] ACPI: Using IOAPIC for interrupt routing
[    0.234497] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe000=
0000-0xefffffff] (base 0xe0000000)
[    0.236021] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in=
 ACPI motherboard resources
[    0.270101] ACPI Warning: Incorrect checksum in table [OEMB] - 0x5D,=
 should be 0x4E (20100702/tbutils-314)
[    0.270201] ACPI: No dock devices found.
[    0.270205] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug
[    0.270305] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.271181] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0c=
f7]
[    0.271183] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xff=
ff]
[    0.271186] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-=
0x000bffff]
[    0.271189] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-=
0x000dffff]
[    0.271192] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-=
0xfebfffff]
[    0.271358] pci 0000:00:01.0: reg 10: [io  0x2f00-0x2f7f]
[    0.271395] pci 0000:00:01.1: reg 10: [io  0x2900-0x293f]
[    0.271411] pci 0000:00:01.1: reg 20: [io  0x2d00-0x2d3f]
[    0.271416] pci 0000:00:01.1: reg 24: [io  0x2e00-0x2e3f]
[    0.271437] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.271442] pci 0000:00:01.1: PME# disabled
[    0.271463] pci 0000:00:02.0: reg 10: [mem 0xfe9fb000-0xfe9fbfff]
[    0.271487] pci 0000:00:02.0: supports D1 D2
[    0.271490] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.271493] pci 0000:00:02.0: PME# disabled
[    0.271508] pci 0000:00:02.1: reg 10: [mem 0xfe9fac00-0xfe9facff]
[    0.271532] pci 0000:00:02.1: supports D1 D2
[    0.271534] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.271537] pci 0000:00:02.1: PME# disabled
[    0.271563] pci 0000:00:04.0: reg 20: [io  0xffa0-0xffaf]
[    0.271588] pci 0000:00:05.0: reg 10: [io  0xc480-0xc487]
[    0.271592] pci 0000:00:05.0: reg 14: [io  0xc400-0xc403]
[    0.271597] pci 0000:00:05.0: reg 18: [io  0xc080-0xc087]
[    0.271601] pci 0000:00:05.0: reg 1c: [io  0xc000-0xc003]
[    0.271605] pci 0000:00:05.0: reg 20: [io  0xbc00-0xbc0f]
[    0.271610] pci 0000:00:05.0: reg 24: [mem 0xfe9f9000-0xfe9f9fff]
[    0.271636] pci 0000:00:05.1: reg 10: [io  0xb880-0xb887]
[    0.271640] pci 0000:00:05.1: reg 14: [io  0xb800-0xb803]
[    0.271645] pci 0000:00:05.1: reg 18: [io  0xb480-0xb487]
[    0.271649] pci 0000:00:05.1: reg 1c: [io  0xb400-0xb403]
[    0.271653] pci 0000:00:05.1: reg 20: [io  0xb080-0xb08f]
[    0.271658] pci 0000:00:05.1: reg 24: [mem 0xfe9f8000-0xfe9f8fff]
[    0.271684] pci 0000:00:05.2: reg 10: [io  0xb000-0xb007]
[    0.271688] pci 0000:00:05.2: reg 14: [io  0xac00-0xac03]
[    0.271693] pci 0000:00:05.2: reg 18: [io  0xa880-0xa887]
[    0.271697] pci 0000:00:05.2: reg 1c: [io  0xa800-0xa803]
[    0.271701] pci 0000:00:05.2: reg 20: [io  0xa480-0xa48f]
[    0.271706] pci 0000:00:05.2: reg 24: [mem 0xfe9f7000-0xfe9f7fff]
[    0.271757] pci 0000:00:06.1: reg 10: [mem 0xfe9f0000-0xfe9f3fff]
[    0.271784] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.271787] pci 0000:00:06.1: PME# disabled
[    0.271814] pci 0000:00:08.0: reg 10: [mem 0xfe9f6000-0xfe9f6fff]
[    0.271819] pci 0000:00:08.0: reg 14: [io  0xa400-0xa407]
[    0.271824] pci 0000:00:08.0: reg 18: [mem 0xfe9fa800-0xfe9fa8ff]
[    0.271828] pci 0000:00:08.0: reg 1c: [mem 0xfe9fa400-0xfe9fa40f]
[    0.271850] pci 0000:00:08.0: supports D1 D2
[    0.271852] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.271856] pci 0000:00:08.0: PME# disabled
[    0.271882] pci 0000:00:09.0: reg 10: [mem 0xfe9f5000-0xfe9f5fff]
[    0.271887] pci 0000:00:09.0: reg 14: [io  0xa080-0xa087]
[    0.271891] pci 0000:00:09.0: reg 18: [mem 0xfe9fa000-0xfe9fa0ff]
[    0.271896] pci 0000:00:09.0: reg 1c: [mem 0xfe9f4c00-0xfe9f4c0f]
[    0.271917] pci 0000:00:09.0: supports D1 D2
[    0.271919] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.271924] pci 0000:00:09.0: PME# disabled
[    0.271953] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.271956] pci 0000:00:0a.0: PME# disabled
[    0.271983] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.271986] pci 0000:00:0b.0: PME# disabled
[    0.272063] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.272066] pci 0000:00:0c.0: PME# disabled
[    0.272093] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.272095] pci 0000:00:0d.0: PME# disabled
[    0.272122] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.272125] pci 0000:00:0e.0: PME# disabled
[    0.272152] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.272155] pci 0000:00:0f.0: PME# disabled
[    0.272240] pci 0000:01:00.0: reg 10: [io  0xd800-0xd8ff]
[    0.272246] pci 0000:01:00.0: reg 14: [mem 0xfeaffc00-0xfeaffcff]
[    0.272252] pci 0000:01:00.0: reg 18: [mem 0xfeaff000-0xfeaff7ff]
[    0.272270] pci 0000:01:00.0: reg 30: [mem 0xfeae0000-0xfeae3fff pre=
f]
[    0.272294] pci 0000:01:04.0: reg 10: [mem 0xfeafe800-0xfeafefff]
[    0.272301] pci 0000:01:04.0: reg 14: [io  0xdc00-0xdc7f]
[    0.272335] pci 0000:01:04.0: supports D2
[    0.272337] pci 0000:01:04.0: PME# supported from D2 D3hot D3cold
[    0.272340] pci 0000:01:04.0: PME# disabled
[    0.272363] pci 0000:00:06.0: PCI bridge to [bus 01-01] (subtractive=
 decode)
[    0.272366] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.272369] pci 0000:00:06.0:   bridge window [mem 0xfea00000-0xfeaf=
ffff]
[    0.272372] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.272375] pci 0000:00:06.0:   bridge window [io  0x0000-0x0cf7] (s=
ubtractive decode)
[    0.272378] pci 0000:00:06.0:   bridge window [io  0x0d00-0xffff] (s=
ubtractive decode)
[    0.272380] pci 0000:00:06.0:   bridge window [mem 0x000a0000-0x000b=
ffff] (subtractive decode)
[    0.272383] pci 0000:00:06.0:   bridge window [mem 0x000d0000-0x000d=
ffff] (subtractive decode)
[    0.272386] pci 0000:00:06.0:   bridge window [mem 0xc0000000-0xfebf=
ffff] (subtractive decode)
[    0.272405] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.272408] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.272411] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.272415] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.272433] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.272437] pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.272440] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.272443] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.272462] pci 0000:00:0c.0: PCI bridge to [bus 04-04]
[    0.272465] pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.272468] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.272471] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.272490] pci 0000:00:0d.0: PCI bridge to [bus 05-05]
[    0.272493] pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.272496] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.272500] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.272518] pci 0000:00:0e.0: PCI bridge to [bus 06-06]
[    0.272522] pci 0000:00:0e.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.272525] pci 0000:00:0e.0:   bridge window [mem 0xfff00000-0x000f=
ffff] (disabled)
[    0.272529] pci 0000:00:0e.0:   bridge window [mem 0xfff00000-0x000f=
ffff pref] (disabled)
[    0.272562] pci 0000:07:00.0: reg 10: [mem 0xc0000000-0xcfffffff 64b=
it pref]
[    0.272571] pci 0000:07:00.0: reg 18: [mem 0xfebe0000-0xfebfffff 64b=
it]
[    0.272577] pci 0000:07:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.272587] pci 0000:07:00.0: reg 30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.272601] pci 0000:07:00.0: supports D1 D2
[    0.272624] pci 0000:07:00.1: reg 10: [mem 0xfebbc000-0xfebbffff 64b=
it]
[    0.272657] pci 0000:07:00.1: supports D1 D2
[    0.274017] pci 0000:00:0f.0: PCI bridge to [bus 07-07]
[    0.274020] pci 0000:00:0f.0:   bridge window [io  0xe000-0xefff]
[    0.274023] pci 0000:00:0f.0:   bridge window [mem 0xfeb00000-0xfebf=
ffff]
[    0.274027] pci 0000:00:0f.0:   bridge window [mem 0xc0000000-0xcfff=
ffff 64bit pref]
[    0.274037] pci_bus 0000:00: on NUMA node 0
[    0.274040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.274276] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.274387] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.274427] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.274467] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.274507] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.274547] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.274587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[    0.283133] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.283245] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.283355] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.283464] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[    0.283573] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.283690] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.284060] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *5
[    0.284169] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, d=
isabled.
[    0.284279] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *10
[    0.284388] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *10
[    0.284497] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *11
[    0.284606] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *5
[    0.284716] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *11
[    0.284825] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.284945] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.285101] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *5
[    0.285216] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *10
[    0.285343] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disa=
bled.
[    0.285453] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.285486] HEST: Table is not found!
[    0.285486] vgaarb: device added: PCI:0000:07:00.0,decodes=3Dio+mem,=
owns=3Dio+mem,locks=3Dnone
[    0.285486] vgaarb: loaded
[    0.285486] SCSI subsystem initialized
[    0.286005] libata version 3.00 loaded.
[    0.286039] usbcore: registered new interface driver usbfs
[    0.286039] usbcore: registered new interface driver hub
[    0.286039] usbcore: registered new device driver usb
[    0.286039] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.286039] PCI: Using ACPI for IRQ routing
[    0.286039] PCI: pci_cache_line_size set to 64 bytes
[    0.286103] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.286106] reserve RAM buffer: 00000000bffd0000 - 00000000bfffffff=20
[    0.286125] Bluetooth: Core ver 2.15
[    0.287012] NET: Registered protocol family 31
[    0.287014] Bluetooth: HCI device and connection manager initialized
[    0.287017] Bluetooth: HCI socket layer initialized
[    0.287055] cfg80211: Calling CRDA to update world regulatory domain
[    0.287160] NetLabel: Initializing
[    0.287162] NetLabel:  domain hash size =3D 128
[    0.287164] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.287183] NetLabel:  unlabeled traffic allowed by default
[    0.287189] HPET: 3 timers in total, 0 timers will be used for per-c=
pu timer
[    0.287195] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.287199] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.291032] Switching to clocksource hpet
[    0.291080] pnp: PnP ACPI init
[    0.291089] ACPI: bus type pnp registered
[    0.296112] pnp: PnP ACPI: found 18 devices
[    0.296115] ACPI: ACPI bus type pnp unregistered
[    0.296129] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.296132] system 00:09: [io  0x0800-0x080f] has been reserved
[    0.296135] system 00:09: [io  0x2000-0x207f] has been reserved
[    0.296138] system 00:09: [io  0x2080-0x20ff] has been reserved
[    0.296141] system 00:09: [io  0x2400-0x247f] has been reserved
[    0.296144] system 00:09: [io  0x2480-0x24ff] has been reserved
[    0.296146] system 00:09: [io  0x2800-0x287f] has been reserved
[    0.296149] system 00:09: [io  0x2880-0x28ff] has been reserved
[    0.296152] system 00:09: [io  0x2c00-0x2c7f] has been reserved
[    0.296155] system 00:09: [io  0x2c80-0x2cff] has been reserved
[    0.296158] system 00:09: [mem 0x000d0000-0x000d3fff window] has bee=
n reserved
[    0.296162] system 00:09: [mem 0x000d4000-0x000d7fff window] has bee=
n reserved
[    0.296165] system 00:09: [mem 0x000de000-0x000dffff window] has bee=
n reserved
[    0.296168] system 00:09: [mem 0xfe980000-0xfe9bffff] has been reser=
ved
[    0.296171] system 00:09: [mem 0xfee01000-0xfeefffff] has been reser=
ved
[    0.296177] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be r=
eserved
[    0.296180] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reser=
ved
[    0.296185] system 00:0e: [io  0x0a00-0x0a0f] has been reserved
[    0.296188] system 00:0e: [io  0x0a10-0x0a1f] has been reserved
[    0.296193] system 00:0f: [mem 0xe0000000-0xefffffff] has been reser=
ved
[    0.296200] system 00:10: [mem 0xd0000000-0xdfffffff] has been reser=
ved
[    0.296205] system 00:11: [mem 0x00000000-0x0009ffff] could not be r=
eserved
[    0.296208] system 00:11: [mem 0x000c0000-0x000cffff] has been reser=
ved
[    0.296211] system 00:11: [mem 0x000e0000-0x000fffff] could not be r=
eserved
[    0.296214] system 00:11: [mem 0x00100000-0xbfffffff] could not be r=
eserved
[    0.296217] system 00:11: [mem 0xfec00000-0xffffffff] could not be r=
eserved
[    0.305675] pci 0000:00:06.0: PCI bridge to [bus 01-01]
[    0.305679] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.305682] pci 0000:00:06.0:   bridge window [mem 0xfea00000-0xfeaf=
ffff]
[    0.305685] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.305688] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.305690] pci 0000:00:0a.0:   bridge window [io  disabled]
[    0.305693] pci 0000:00:0a.0:   bridge window [mem disabled]
[    0.305695] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    0.305698] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.305700] pci 0000:00:0b.0:   bridge window [io  disabled]
[    0.305703] pci 0000:00:0b.0:   bridge window [mem disabled]
[    0.305705] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    0.305708] pci 0000:00:0c.0: PCI bridge to [bus 04-04]
[    0.305710] pci 0000:00:0c.0:   bridge window [io  disabled]
[    0.305713] pci 0000:00:0c.0:   bridge window [mem disabled]
[    0.305715] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    0.305718] pci 0000:00:0d.0: PCI bridge to [bus 05-05]
[    0.305720] pci 0000:00:0d.0:   bridge window [io  disabled]
[    0.305723] pci 0000:00:0d.0:   bridge window [mem disabled]
[    0.305725] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    0.305728] pci 0000:00:0e.0: PCI bridge to [bus 06-06]
[    0.305730] pci 0000:00:0e.0:   bridge window [io  disabled]
[    0.305732] pci 0000:00:0e.0:   bridge window [mem disabled]
[    0.305735] pci 0000:00:0e.0:   bridge window [mem pref disabled]
[    0.305739] pci 0000:00:0f.0: PCI bridge to [bus 07-07]
[    0.305741] pci 0000:00:0f.0:   bridge window [io  0xe000-0xefff]
[    0.305744] pci 0000:00:0f.0:   bridge window [mem 0xfeb00000-0xfebf=
ffff]
[    0.305747] pci 0000:00:0f.0:   bridge window [mem 0xc0000000-0xcfff=
ffff 64bit pref]
[    0.305756] pci 0000:00:06.0: setting latency timer to 64
[    0.305761] pci 0000:00:0a.0: setting latency timer to 64
[    0.305766] pci 0000:00:0b.0: setting latency timer to 64
[    0.305770] pci 0000:00:0c.0: setting latency timer to 64
[    0.305774] pci 0000:00:0d.0: setting latency timer to 64
[    0.305779] pci 0000:00:0e.0: setting latency timer to 64
[    0.305783] pci 0000:00:0f.0: setting latency timer to 64
[    0.305786] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.305789] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.305791] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.305793] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.305796] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.305798] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.305801] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.305803] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.305806] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.305808] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.305811] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.305813] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xfebfffff]
[    0.305816] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    0.305818] pci_bus 0000:07: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.305821] pci_bus 0000:07: resource 2 [mem 0xc0000000-0xcfffffff 6=
4bit pref]
[    0.305851] NET: Registered protocol family 2
[    0.305894] IP route cache hash table entries: 262144 (order: 9, 209=
7152 bytes)
[    0.307548] TCP established hash table entries: 262144 (order: 10, 4=
194304 bytes)
[    0.310105] TCP bind hash table entries: 65536 (order: 8, 1048576 by=
tes)
[    0.310706] TCP: Hash tables configured (established 262144 bind 655=
36)
[    0.310709] TCP reno registered
[    0.310714] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.310801] UDP-Lite hash table entries: 4096 (order: 5, 131072 byte=
s)
[    0.310971] NET: Registered protocol family 1
[    0.333076] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333113] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333149] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333185] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333224] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333269] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333319] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333370] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333424] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333482] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333542] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333607] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333674] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.333690] pci 0000:07:00.0: Boot video device
[    0.333694] PCI: CLS 64 bytes, default 64
[    0.333758] Trying to unpack rootfs image as initramfs...
[    0.491463] Freeing initrd memory: 7068k freed
[    0.495964] PCI-DMA: Disabling AGP.
[    0.496150] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.496152] PCI-DMA: using GART IOMMU.
[    0.496156] PCI-DMA: Reserving 64MB of IOMMU area in the AGP apertur=
e
[    0.500749] kvm: Nested Virtualization enabled
[    0.502441] Intel PCLMULQDQ-NI instructions are not detected.
[    0.502725] audit: initializing netlink socket (disabled)
[    0.502738] type=3D2000 audit(1289240615.501:1): initialized
[    0.516277] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.519646] VFS: Disk quotas dquot_6.5.2
[    0.519736] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    0.521294] NTFS driver 2.1.29 [Flags: R/O].
[    0.521445] fuse init (API version 7.15)
[    0.521958] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.525475] SGI XFS with ACLs, security attributes, large block/inod=
e numbers, no debug enabled
[    0.526453] SGI XFS Quota Management subsystem
[    0.526461] msgmni has been set to 11935
[    0.526577] SELinux:  Registering netfilter hooks
[    0.526759] alg: No test for cipher_null (cipher_null-generic)
[    0.526803] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.526840] alg: No test for digest_null (digest_null-generic)
[    0.526875] alg: No test for compress_null (compress_null-generic)
[    0.528173] alg: No test for fcrypt (fcrypt-generic)
[    0.530772] alg: No test for stdrng (krng)
[    0.530968] Block layer SCSI generic (bsg) driver version 0.4 loaded=
 (major 253)
[    0.530972] io scheduler noop registered
[    0.530974] io scheduler deadline registered (default)
[    0.531137] io scheduler cfq registered
[    0.531512] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.531650] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    0.531652] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.=
5
[    0.534281] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace faile=
d
[    0.535140] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/=
PNP0C0C:00/input/input0
[    0.535145] ACPI: Power Button [PWRB]
[    0.535243] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/=
input/input1
[    0.535246] ACPI: Power Button [PWRF]
[    0.535514] ACPI: acpi_idle registered with cpuidle
[    0.538546] ERST: Table is not found!
[    0.538548] GHES: HEST is not enabled!
[    0.538550] EINJ: Table is not found!
[    0.539786] lp: driver loaded but no devices found
[    0.540172] Non-volatile memory driver v1.3
[    0.541133] ppdev: user-space parallel port driver
[    0.541137] Linux agpgart interface v0.103
[    0.541282] ipmi message handler version 39.2
[    0.541297] ipmi device interface
[    0.541394] IPMI System Interface driver.
[    0.541505] ipmi_si: Adding default-specified kcs state machine
[    0.541509] ipmi_si: Trying default-specified kcs state machine at i=
/o address 0xca2, slave address 0x0, irq 0
[    0.541515] ipmi_si: Interface detection failed
[    0.545039] ipmi_si: Adding default-specified smic state machine
[    0.545042] ipmi_si: Trying default-specified smic state machine at =
i/o address 0xca9, slave address 0x0, irq 0
[    0.545046] ipmi_si: Interface detection failed
[    0.548020] ipmi_si: Adding default-specified bt state machine
[    0.548023] ipmi_si: Trying default-specified bt state machine at i/=
o address 0xe4, slave address 0x0, irq 0
[    0.548030] ipmi_si: Interface detection failed
[    0.553119] ipmi_si: Unable to find any System Interface(s)
[    0.553122] IPMI Watchdog: driver initialized
[    0.553124] Copyright (C) 2004 MontaVista Software - IPMI Powerdown =
via sys_reboot.
[    0.553131] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 s=
econds, margin is 60 seconds).
[    0.553133] Hangcheck: Using getrawmonotonic().
[    0.553197] [drm] Initialized drm 1.1.0 20060810
[    0.553200] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.817188] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.081186] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.102013] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.102371] parport_pc 00:08: reported by Plug and Play ACPI
[    1.102413] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    1.184154] lp0: using parport0 (interrupt-driven).
[    1.184157] lp0: console ready
[    1.187031] brd: module loaded
[    1.188224] loop: module loaded
[    1.188528] nbd: registered device at major 43
[    1.191512] Loading iSCSI transport class v2.0-870.
[    1.192179] rdac: device handler registered
[    1.192214] hp_sw: device handler registered
[    1.192216] emc: device handler registered
[    1.192219] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    1.192328] osst :I: Tape driver with OnStream support version 0.99.=
4
[    1.192329] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede E=
xp $
[    1.192676] SCSI Media Changer driver v0.25=20
[    1.192968] sata_nv 0000:00:05.0: version 3.5
[    1.193224] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    1.193235] sata_nv 0000:00:05.0: PCI INT A -> Link[LSA0] -> GSI 23 =
(level, low) -> IRQ 23
[    1.193238] sata_nv 0000:00:05.0: Using SWNCQ mode
[    1.193471] sata_nv 0000:00:05.0: setting latency timer to 64
[    1.193604] scsi0 : sata_nv
[    1.193800] scsi1 : sata_nv
[    1.194140] ata1: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xbc=
00 irq 23
[    1.194143] ata2: SATA max UDMA/133 cmd 0xc080 ctl 0xc000 bmdma 0xbc=
08 irq 23
[    1.194365] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    1.194374] sata_nv 0000:00:05.1: PCI INT B -> Link[LSA1] -> GSI 22 =
(level, low) -> IRQ 22
[    1.194377] sata_nv 0000:00:05.1: Using SWNCQ mode
[    1.194596] sata_nv 0000:00:05.1: setting latency timer to 64
[    1.194720] scsi2 : sata_nv
[    1.194962] scsi3 : sata_nv
[    1.195225] ata3: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb0=
80 irq 22
[    1.195227] ata4: SATA max UDMA/133 cmd 0xb480 ctl 0xb400 bmdma 0xb0=
88 irq 22
[    1.195437] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 21
[    1.195446] sata_nv 0000:00:05.2: PCI INT C -> Link[LSA2] -> GSI 21 =
(level, low) -> IRQ 21
[    1.195449] sata_nv 0000:00:05.2: Using SWNCQ mode
[    1.195660] sata_nv 0000:00:05.2: setting latency timer to 64
[    1.195783] scsi4 : sata_nv
[    1.195967] scsi5 : sata_nv
[    1.196256] ata5: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa4=
80 irq 21
[    1.196259] ata6: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa4=
88 irq 21
[    1.196404] pata_amd 0000:00:04.0: version 0.4.1
[    1.196446] pata_amd 0000:00:04.0: setting latency timer to 64
[    1.196527] scsi6 : pata_amd
[    1.196692] scsi7 : pata_amd
[    1.198040] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0=
 irq 14
[    1.198043] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8=
 irq 15
[    1.198472] SSFDC read-only Flash Translation layer
[    1.198527] slram: not enough parameters.
[    1.198530] bonding: Ethernet Channel Bonding Driver: v3.7.0 (June 2=
, 2010)
[    1.198534] bonding: Warning: either miimon or arp_interval and arp_=
ip_target module parameters must be specified, otherwise bonding will n=
ot detect link failures! see bonding.txt for details.
[    1.199456] PPP generic driver version 2.4.2
[    1.199585] PPP Deflate Compression module registered
[    1.201804] PPP MPPE Compression module registered
[    1.201806] NET: Registered protocol family 24
[    1.202298] Equalizer2002: Simon Janes (simon@ncm.com) and David S. =
Miller (davem@redhat.com)
[    1.202437] tun: Universal TUN/TAP device driver, 1.6
[    1.202439] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.202518] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maro=
on.tc.umn.edu>
[    1.202658] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson =
<johns393@maroon.tc.umn.edu>
[    1.202717] usbcore: registered new interface driver cdc_ether
[    1.202766] usbcore: registered new interface driver cdc_eem
[    1.202815] usbcore: registered new interface driver rndis_host
[    1.202841] console [netcon0] enabled
[    1.202843] netconsole: network logging started
[    1.203221] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 19
[    1.203232] firewire_ohci 0000:01:04.0: PCI INT A -> Link[LNKD] -> G=
SI 19 (level, low) -> IRQ 19
[    1.254071] firewire_ohci: Added fw-ohci device 0000:01:04.0, OHCI v=
1.10, 4 IR + 8 IT contexts, quirks 0x1
[    1.254410] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    1.254652] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    1.254657] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23=
 (level, low) -> IRQ 23
[    1.254681] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    1.254684] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    1.254712] ehci_hcd 0000:00:02.1: new USB bus registered, assigned =
bus number 1
[    1.254738] ehci_hcd 0000:00:02.1: debug port 1
[    1.254743] ehci_hcd 0000:00:02.1: cache line size of 64 is not supp=
orted
[    1.254751] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe9fac00
[    1.260021] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    1.260224] hub 1-0:1.0: USB hub found
[    1.260230] hub 1-0:1.0: 10 ports detected
[    1.260355] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.260556] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    1.260559] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22=
 (level, low) -> IRQ 22
[    1.260573] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    1.260575] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    1.260584] ohci_hcd 0000:00:02.0: new USB bus registered, assigned =
bus number 2
[    1.260597] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe9fb000
[    1.313216] hub 2-0:1.0: USB hub found
[    1.313222] hub 2-0:1.0: 10 ports detected
[    1.313348] uhci_hcd: USB Universal Host Controller Interface driver
[    1.313505] usbcore: registered new interface driver cdc_acm
[    1.313507] cdc_acm: v0.26:USB Abstract Control Model driver for USB=
 modems and ISDN adapters
[    1.313564] usbcore: registered new interface driver usblp
[    1.313620] usbcore: registered new interface driver cdc_wdm
[    1.313622] Initializing USB Mass Storage driver...
[    1.313685] usbcore: registered new interface driver usb-storage
[    1.313686] USB Mass Storage support registered.
[    1.313744] usbcore: registered new interface driver ums-alauda
[    1.313798] usbcore: registered new interface driver ums-cypress
[    1.313853] usbcore: registered new interface driver ums-datafab
[    1.313912] usbcore: registered new interface driver ums-freecom
[    1.313967] usbcore: registered new interface driver ums-isd200
[    1.314032] usbcore: registered new interface driver ums-jumpshot
[    1.314087] usbcore: registered new interface driver ums-karma
[    1.314143] usbcore: registered new interface driver ums-onetouch
[    1.314200] usbcore: registered new interface driver ums-sddr09
[    1.314257] usbcore: registered new interface driver ums-sddr55
[    1.314312] usbcore: registered new interface driver ums-usbat
[    1.314456] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60=
,0x64 irq 1,12
[    1.317192] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.317198] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.317358] mice: PS/2 mouse device common for all mice
[    1.317631] input: PC Speaker as /devices/platform/pcspkr/input/inpu=
t2
[    1.317759] rtc_cmos 00:02: RTC can wake from S4
[    1.317839] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.317873] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet =
irqs
[    1.317923] i2c /dev entries driver
[    1.318330] i2c i2c-0: nForce2 SMBus adapter at 0x2d00
[    1.318449] i2c i2c-1: nForce2 SMBus adapter at 0x2e00
[    1.318557] k8temp 0000:00:18.3: Temperature readouts might be wrong=
 - check erratum #141
[    1.318775] w83627ehf: Found W83627EHG chip at 0xa10
[    1.319180] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O=
 chip initialising.
[    1.319202] w83627hf/thf/hg WDT: Watchdog already running. Resetting=
 timeout to 60 sec
[    1.319279] w83627hf/thf/hg WDT: initialized. timeout=3D60 sec (nowa=
yout=3D0)
[    1.319281] md: linear personality registered for level -1
[    1.319283] md: raid0 personality registered for level 0
[    1.319285] md: raid1 personality registered for level 1
[    1.319287] md: raid10 personality registered for level 10
[    1.319289] md: raid6 personality registered for level 6
[    1.319291] md: raid5 personality registered for level 5
[    1.319293] md: raid4 personality registered for level 4
[    1.319295] md: multipath personality registered for level -4
[    1.319297] md: faulty personality registered for level -5
[    1.319494] device-mapper: uevent: version 1.0.3
[    1.319657] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initiali=
sed: dm-devel@redhat.com
[    1.319882] Bluetooth: Virtual HCI driver ver 1.3
[    1.319943] Bluetooth: HCI UART driver ver 2.2
[    1.319946] Bluetooth: HCI H4 protocol initialized
[    1.319947] Bluetooth: HCI BCSP protocol initialized
[    1.319949] Bluetooth: HCILL protocol initialized
[    1.319951] Bluetooth: Broadcom Blutonium firmware driver ver 1.2
[    1.320040] usbcore: registered new interface driver bcm203x
[    1.320042] Bluetooth: Digianswer Bluetooth USB driver ver 0.10
[    1.320092] usbcore: registered new interface driver bpa10x
[    1.320094] Bluetooth: BlueFRITZ! USB driver ver 1.2
[    1.320143] usbcore: registered new interface driver bfusb
[    1.320145] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    1.320196] usbcore: registered new interface driver btusb
[    1.320198] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    1.320290] cpuidle: using governor ladder
[    1.320292] cpuidle: using governor menu
[    1.320447] sdhci: Secure Digital Host Controller Interface driver
[    1.320448] sdhci: Copyright(c) Pierre Ossman
[    1.320521] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    1.320523] wbsd: Copyright(c) Pierre Ossman
[    1.322083] usbcore: registered new interface driver hiddev
[    1.322136] usbcore: registered new interface driver usbhid
[    1.322138] usbhid: USB HID core driver
[    1.323660] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    1.323666] HDA Intel 0000:00:06.1: PCI INT B -> Link[LAZA] -> GSI 2=
1 (level, low) -> IRQ 21
[    1.323670] hda_intel: Disable MSI for Nvidia chipset
[    1.323700] HDA Intel 0000:00:06.1: setting latency timer to 64
[    1.371528] ata7.00: ATA-6: HDS722516VLAT80, V34OA6MA, max UDMA/100
[    1.371531] ata7.00: 321672960 sectors, multi 16: LBA48=20
[    1.371540] ata7: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=3D0=
x3f000 (0xc6000000) ACPI=3D0x3f01f (20:900:0x11)
[    1.380449] ata7.00: configured for UDMA/100
[    1.498016] ata3: SATA link down (SStatus 0 SControl 300)
[    1.499017] ata5: SATA link down (SStatus 0 SControl 300)
[    1.562026] usb 1-3: new high speed USB device using ehci_hcd and ad=
dress 2
[    1.625920] ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 18
[    1.625932] HDA Intel 0000:07:00.1: PCI INT B -> Link[LNEC] -> GSI 1=
8 (level, low) -> IRQ 18
[    1.625976] HDA Intel 0000:07:00.1: irq 40 for MSI/MSI-X
[    1.625998] HDA Intel 0000:07:00.1: setting latency timer to 64
[    1.630686] ALSA device list:
[    1.630688]   #0: Dummy 1
[    1.630689]   #1: Virtual MIDI Card 1
[    1.630691]   #2: HDA NVidia at 0xfe9f0000 irq 21
[    1.630693]   #3: HD-Audio Generic at 0xfebbc000 irq 40
[    1.630786] oprofile: using NMI interrupt.
[    1.630864] GACT probability on
[    1.630868] Mirror/redirect action on
[    1.630870] Simple TC action Loaded
[    1.631062] netem: version 1.2
[    1.631064] u32 classifier
[    1.631065]     Performance counters on
[    1.631066]     input device check on
[    1.631068]     Actions configured
[    1.631071] Netfilter messages via NETLINK v0.30.
[    1.631091] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.631512] xt_time: kernel timezone is -0000
[    1.631534] IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
[    1.631559] IPVS: Connection hash table configured (size=3D4096, mem=
ory=3D64Kbytes)
[    1.631598] IPVS: ipvs loaded.
[    1.631600] IPVS: [rr] scheduler registered.
[    1.631602] IPVS: [wrr] scheduler registered.
[    1.631604] IPVS: [lc] scheduler registered.
[    1.631605] IPVS: [wlc] scheduler registered.
[    1.631610] IPVS: [lblc] scheduler registered.
[    1.631613] IPVS: [lblcr] scheduler registered.
[    1.631615] IPVS: [dh] scheduler registered.
[    1.631617] IPVS: [sh] scheduler registered.
[    1.631619] IPVS: [sed] scheduler registered.
[    1.631620] IPVS: [nq] scheduler registered.
[    1.631623] IPVS: ftp: loaded support on port[0] =3D 21
[    1.631634] IPv4 over IPv4 tunneling driver
[    1.631792] GRE over IPv4 tunneling driver
[    1.632078] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.632118] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    1.632145] arp_tables: (C) 2002 David S. Miller
[    1.632167] TCP bic registered
[    1.632169] TCP cubic registered
[    1.632170] TCP westwood registered
[    1.632172] TCP highspeed registered
[    1.632173] TCP hybla registered
[    1.632175] TCP htcp registered
[    1.632176] TCP vegas registered
[    1.632178] TCP veno registered
[    1.632179] TCP scalable registered
[    1.632181] TCP lp registered
[    1.632182] TCP yeah registered
[    1.632184] TCP illinois registered
[    1.632185] Initializing XFRM netlink socket
[    1.632507] NET: Registered protocol family 10
[    1.632703] lo: Disabled Privacy Extensions
[    1.632969] tunl0: Disabled Privacy Extensions
[    1.633155] Mobile IPv6
[    1.633169] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.633227] IPv6 over IPv4 tunneling driver
[    1.633457] sit0: Disabled Privacy Extensions
[    1.633666] ip6tnl0: Disabled Privacy Extensions
[    1.633692] NET: Registered protocol family 17
[    1.633701] NET: Registered protocol family 15
[    1.633732] Bridge firewalling registered
[    1.633736] Ebtables v2.0 registered
[    1.633782] NET: Registered protocol family 5
[    1.641076] Bluetooth: L2CAP ver 2.15
[    1.641077] Bluetooth: L2CAP socket layer initialized
[    1.641082] Bluetooth: SCO (Voice Link) ver 0.6
[    1.641084] Bluetooth: SCO socket layer initialized
[    1.641142] Bluetooth: RFCOMM TTY layer initialized
[    1.641147] Bluetooth: RFCOMM socket layer initialized
[    1.641149] Bluetooth: RFCOMM ver 1.11
[    1.641151] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.641153] Bluetooth: BNEP filters: protocol multicast
[    1.641155] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.641233] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech=
=2Ecom>
[    1.641235] All bugs added by David S. Miller <davem@redhat.com>
[    1.644651] CCID: Activated CCID 2 (TCP-like)
[    1.644670] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[    1.646266] SCTP: Hash tables configured (established 65536 bind 655=
36)
[    1.648029] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.648097] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.649287] ata2.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max U=
DMA/133
[    1.649289] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 3=
1/32)
[    1.650446] SCTP probe registered (port=3D0)
[    1.650450] TIPC: Activated (version 2.0.0 compiled Nov  8 2010 19:1=
6:14)
[    1.650670] NET: Registered protocol family 30
[    1.650672] TIPC: Started in single node mode
[    1.650674] Registering the dns_resolver key type
[    1.650702] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Proc=
essor 5000+ (2 cpu cores) (version 2.20.00)
[    1.650751] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    1.650753] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    1.650755] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    1.650757] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    1.650759] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    1.650761] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    1.651121] ata1.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/=
66
[    1.651237] PM: Resume from disk failed.
[    1.651247] registered taskstats version 1
[    1.651560] rtc_cmos 00:02: setting system clock to 2010-11-08 18:23=
:37 UTC (1289240617)
[    1.651563] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    1.653283] ata2.00: configured for UDMA/133
[    1.653412] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT7250=
3 V54O PQ: 0 ANSI: 5
[    1.653659] sd 1:0:0:0: [sda] 625142448 512-byte logical blocks: (32=
0 GB/298 GiB)
[    1.653798] sd 1:0:0:0: [sda] Write Protect is off
[    1.653801] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.653825] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    1.653864] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    1.657114] ata1.00: configured for UDMA/66
[    1.669579] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215=
  1.18 PQ: 0 ANSI: 5
[    1.678462] hub 1-3:1.0: USB hub found
[    1.678771] hub 1-3:1.0: 4 ports detected
[    1.688939]  sda: sda1 sda2 sda3 sda4
[    1.689575] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.711606] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/fo=
rm2 cdda tray
[    1.711609] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.711793] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.711940] sr 0:0:0:0: Attached scsi generic sg1 type 5
[    1.755129] firewire_core: created device fw0: GUID 0010dc0000cf25c6=
, S400
[    1.782014] usb 1-4: new high speed USB device using ehci_hcd and ad=
dress 3
[    1.897467] hub 1-4:1.0: USB hub found
[    1.897520] hub 1-4:1.0: 4 ports detected
[    1.898416] hub 1-0:1.0: over-current change on port 1
[    1.999013] hub 1-0:1.0: over-current change on port 2
[    2.015019] ata4: SATA link down (SStatus 0 SControl 300)
[    2.164028] usb 1-3.3: new low speed USB device using ehci_hcd and a=
ddress 4
[    2.267020] input: Microsoft Microsoft IntelliMouse=C2=AE Optical as=
 /devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3.3/1-3.3:1.0/input/input3
[    2.267249] generic-usb 0003:045E:0029.0001: input,hidraw0: USB HID =
v1.00 Mouse [Microsoft Microsoft IntelliMouse=C2=AE Optical] on usb-000=
0:00:02.1-3.3/input0
[    2.318020] ata6: SATA link down (SStatus 0 SControl 300)
[    2.318165] scsi 6:0:0:0: Direct-Access     ATA      HDS722516VLAT80=
  V34O PQ: 0 ANSI: 5
[    2.318456] sd 6:0:0:0: [sdb] 321672960 512-byte logical blocks: (16=
4 GB/153 GiB)
[    2.318516] sd 6:0:0:0: [sdb] Write Protect is off
[    2.318520] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.318549] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    2.318554] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    2.318677] ata8: port disabled. ignoring.
[    2.332030] usb 1-3.4: new low speed USB device using ehci_hcd and a=
ddress 5
[    2.332974]  sdb: sdb1
[    2.333461] sd 6:0:0:0: [sdb] Attached SCSI disk
[    2.333492] Freeing unused kernel memory: 580k freed
[    2.333800] Write protecting the kernel read-only data: 12288k
[    2.334122] Freeing unused kernel memory: 960k freed
[    2.334893] Freeing unused kernel memory: 1108k freed
[    2.362418] dracut: dracut-005-5.fc13
[    2.376578] udev: starting version 153
[    2.376647] udevd (1325): /proc/1325/oom_adj is deprecated, please u=
se /proc/1325/oom_score_adj instead.
[    2.442475] input: DELL DELL USB Keyboard as /devices/pci0000:00/000=
0:00:02.1/usb1/1-3/1-3.4/1-3.4:1.0/input/input4
[    2.443565] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID =
v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-3.4/input0
[    2.450501] [drm] radeon defaulting to kernel modesetting.
[    2.450504] [drm] radeon kernel modesetting enabled.
[    2.450936] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 17
[    2.450949] radeon 0000:07:00.0: PCI INT A -> Link[LNEB] -> GSI 17 (=
level, low) -> IRQ 17
[    2.450955] radeon 0000:07:00.0: setting latency timer to 64
[    2.455725] input: DELL DELL USB Keyboard as /devices/pci0000:00/000=
0:00:02.1/usb1/1-3/1-3.4/1-3.4:1.1/input/input5
[    2.457665] [drm] initializing kernel modesetting (REDWOOD 0x1002:0x=
68D9).
[    2.457700] generic-usb 0003:413C:2003.0003: input,hidraw2: USB HID =
v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-3.4/input1
[    2.457837] [drm] register mmio base: 0xFEBE0000
[    2.457839] [drm] register mmio size: 131072
[    2.461884] ATOM BIOS: REDWOOD
[    2.461921] radeon 0000:07:00.0: VRAM: 1024M 0x00000000 - 0x3FFFFFFF=
 (1024M used)
[    2.461924] radeon 0000:07:00.0: GTT: 512M 0x40000000 - 0x5FFFFFFF
[    2.462194] [drm] Detected VRAM RAM=3D1024M, BAR=3D256M
[    2.462197] [drm] RAM width 128bits DDR
[    2.462279] [TTM] Zone  kernel: Available graphics memory: 3056894 k=
iB.
[    2.462282] [TTM] Zone   dma32: Available graphics memory: 2097152 k=
iB.
[    2.462285] [TTM] Initializing pool allocator.
[    2.462310] [drm] radeon: 1024M of VRAM memory ready
[    2.462313] [drm] radeon: 512M of GTT memory ready.
[    2.462364] radeon 0000:07:00.0: irq 41 for MSI/MSI-X
[    2.462370] radeon 0000:07:00.0: radeon: using MSI.
[    2.462421] [drm] radeon: irq initialized.
[    2.462424] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.464727] [drm] Loading REDWOOD Microcode
[    2.490569] [drm] ring test succeeded in 0 usecs
[    2.490758] [drm] radeon: ib pool ready.
[    2.490863] [drm] ib test succeeded in 0 usecs
[    2.490870] failed to evaluate ATIF got AE_BAD_PARAMETER
[    2.493206] [drm] Radeon Display Connectors
[    2.493209] [drm] Connector 0:
[    2.493211] [drm]   DisplayPort
[    2.493212] [drm]   HPD4
[    2.493215] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0=
x645c 0x645c
[    2.493217] [drm]   Encoders:
[    2.493219] [drm]     DFP1: INTERNAL_UNIPHY2
[    2.493220] [drm] Connector 1:
[    2.493222] [drm]   DVI-I
[    2.493223] [drm]   HPD1
[    2.493225] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0=
x646c 0x646c
[    2.493227] [drm]   Encoders:
[    2.493229] [drm]     DFP2: INTERNAL_UNIPHY1
[    2.493231] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.493232] [drm] Connector 2:
[    2.493234] [drm]   VGA
[    2.493236] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0=
x643c 0x643c
[    2.493238] [drm]   Encoders:
[    2.493239] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    2.521915] usb 1-4.1: new high speed USB device using ehci_hcd and =
address 6
[    2.572224] [drm] Internal thermal controller with fan control
[    2.572329] [drm] radeon: power management initialized
[    2.656961] [drm] fb mappable at 0xC0140000
[    2.656963] [drm] vram apper at 0xC0000000
[    2.656965] [drm] size 8294400
[    2.656967] [drm] fb depth is 24
[    2.656968] [drm]    pitch is 7680
[    2.657099] fbcon: radeondrmfb (fb0) is primary device
[    2.677914] usb 1-4.4: new high speed USB device using ehci_hcd and =
address 7
[    3.091243] Console: switching to colour frame buffer device 240x67
[    3.102210] fb0: radeondrmfb frame buffer device
[    3.102213] drm: registered panic notifier
[    3.102221] [drm] Initialized radeon 2.6.0 20080528 for 0000:07:00.0=
 on minor 0
[    3.112452] dracut: Starting plymouth daemon
[    3.332978] Floppy drive(s): fd0 is 1.44M
[    3.348735] FDC 0 is a post-1991 82077
[    3.501019] Clocksource tsc unstable (delta =3D -93402253 ns)
[   10.333495] EXT4-fs (dm-0): mounted filesystem with ordered data mod=
e. Opts: (null)
[   10.374970] ------------[ cut here ]------------
[   10.374979] WARNING: at lib/debugobjects.c:259 debug_print_object+0x=
5b/0x63()
[   10.374982] Hardware name: MS-7250
[   10.374984] ODEBUG: free active (active state 0) object type: timer_=
list
[   10.374987] Modules linked in: floppy radeon ttm drm_kms_helper
[   10.374993] Pid: 2259, comm: umount Not tainted 2.6.36 #4
[   10.374995] Call Trace:
[   10.375001]  [<ffffffff810577d2>] warn_slowpath_common+0x80/0x98
[   10.375005]  [<ffffffff8105787e>] warn_slowpath_fmt+0x41/0x43
[   10.375008]  [<ffffffff812cab46>] debug_print_object+0x5b/0x63
[   10.375012]  [<ffffffff812cb024>] debug_check_no_obj_freed+0x94/0x1d=
3
[   10.375016]  [<ffffffff817032d3>] ? _raw_spin_unlock_irq+0x1f/0x2a
[   10.375019]  [<ffffffff810e4cd7>] kfree+0x75/0xb6
[   10.375024]  [<ffffffff81172c75>] ? ext4_put_super+0x32b/0x33a
[   10.375027]  [<ffffffff81172c75>] ext4_put_super+0x32b/0x33a
[   10.375031]  [<ffffffff810ed276>] generic_shutdown_super+0x51/0xd2
[   10.375034]  [<ffffffff810ed319>] kill_block_super+0x22/0x3a
[   10.375038]  [<ffffffff810ecda6>] deactivate_locked_super+0x21/0x41
[   10.375038]  [<ffffffff810ed220>] deactivate_super+0x40/0x45
[   10.375038]  [<ffffffff811010a5>] mntput_no_expire+0xdd/0x10b
[   10.375038]  [<ffffffff8110161a>] sys_umount+0x2d2/0x2fd
[   10.375038]  [<ffffffff81705f1e>] ? do_page_fault+0x217/0x244
[   10.375038]  [<ffffffff81022a2b>] system_call_fastpath+0x16/0x1b
[   10.375038] ---[ end trace 92659487046e8136 ]---
[   10.375471] dracut: Remounting /dev/mapper/luks-1bda98a6-c825-4097-b=
472-3d8050c1a022 with -o noatime,data=3Dwriteback,ro
[   10.441331] EXT4-fs (dm-0): mounted filesystem with writeback data m=
ode. Opts: data=3Dwriteback
[   10.472697] dracut: Mounted root filesystem /dev/mapper/luks-1bda98a=
6-c825-4097-b472-3d8050c1a022
[   10.614682] dracut: Loading SELinux policy
[   10.965262] type=3D1404 audit(1289240626.813:2): enforcing=3D1 old_e=
nforcing=3D0 auid=3D4294967295 ses=3D4294967295
[   11.141293] SELinux: 2048 avtab hash slots, 203933 rules.
[   11.226175] SELinux: 2048 avtab hash slots, 203933 rules.
[   11.704279] SELinux:  9 users, 13 roles, 3435 types, 172 bools, 1 se=
ns, 1024 cats
[   11.704284] SELinux:  77 classes, 203933 rules
[   11.708787] SELinux:  Permission audit_access in class file not defi=
ned in policy.
[   11.708797] SELinux:  Permission audit_access in class dir not defin=
ed in policy.
[   11.708800] SELinux:  Permission execmod in class dir not defined in=
 policy.
[   11.708809] SELinux:  Permission audit_access in class lnk_file not =
defined in policy.
[   11.708812] SELinux:  Permission open in class lnk_file not defined =
in policy.
[   11.708814] SELinux:  Permission execmod in class lnk_file not defin=
ed in policy.
[   11.708820] SELinux:  Permission audit_access in class chr_file not =
defined in policy.
[   11.708828] SELinux:  Permission audit_access in class blk_file not =
defined in policy.
[   11.708831] SELinux:  Permission execmod in class blk_file not defin=
ed in policy.
[   11.708837] SELinux:  Permission audit_access in class sock_file not=
 defined in policy.
[   11.708840] SELinux:  Permission execmod in class sock_file not defi=
ned in policy.
[   11.708847] SELinux:  Permission audit_access in class fifo_file not=
 defined in policy.
[   11.708850] SELinux:  Permission execmod in class fifo_file not defi=
ned in policy.
[   11.708994] SELinux: the above unknown classes and permissions will =
be allowed
[   11.709018] SELinux:  Completing initialization.
[   11.709020] SELinux:  Setting up existing superblocks.
[   11.709031] SELinux: initialized (dev sysfs, type sysfs), uses genfs=
_contexts
[   11.709038] SELinux: initialized (dev rootfs, type rootfs), uses gen=
fs_contexts
[   11.709480] SELinux: initialized (dev bdev, type bdev), uses genfs_c=
ontexts
[   11.709489] SELinux: initialized (dev proc, type proc), uses genfs_c=
ontexts
[   11.709498] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
[   11.709513] SELinux: initialized (dev sockfs, type sockfs), uses tas=
k SIDs
[   11.709519] SELinux: initialized (dev debugfs, type debugfs), uses g=
enfs_contexts
[   11.709618] SELinux: initialized (dev pipefs, type pipefs), uses tas=
k SIDs
[   11.709625] SELinux: initialized (dev anon_inodefs, type anon_inodef=
s), uses genfs_contexts
[   11.709630] SELinux: initialized (dev devpts, type devpts), uses tra=
nsition SIDs
[   11.709659] SELinux: initialized (dev hugetlbfs, type hugetlbfs), us=
es transition SIDs
[   11.709670] SELinux: initialized (dev mqueue, type mqueue), uses tra=
nsition SIDs
[   11.709676] SELinux: initialized (dev selinuxfs, type selinuxfs), us=
es genfs_contexts
[   11.709701] SELinux: initialized (dev mtd_inodefs, type mtd_inodefs)=
, not configured for labeling
[   11.709707] SELinux: initialized (dev configfs, type configfs), uses=
 genfs_contexts
[   11.709713] SELinux: initialized (dev usbfs, type usbfs), uses genfs=
_contexts
[   11.709723] SELinux: initialized (dev sysfs, type sysfs), uses genfs=
_contexts
[   11.710594] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
[   11.712048] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
[   11.712062] SELinux: initialized (dev dm-0, type ext4), uses xattr
[   11.738557] type=3D1403 audit(1289240627.586:3): policy loaded auid=3D=
4294967295 ses=3D4294967295
[   11.741510] dracut:=20
[   12.467660] dracut: Switching root
[   13.406748] readahead: starting
[   16.331780] udev: starting version 153
[   17.734516] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
[   17.734530] olympic 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 16 =
(level, low) -> IRQ 16
[   17.734617] Olympic.c v1.0.5 6/04/02 - Peter De Schrijver & Mike Phi=
llips
[   17.734620] 0000:01:00.0. I/O at d800, MMIO at ffffc90010ee8c00, LAP=
 at ffffc900107fc000, using irq 16
[   17.743867] forcedeth: Reverse Engineered nForce ethernet driver. Ve=
rsion 0.64.
[   17.744149] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[   17.744161] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 2=
0 (level, low) -> IRQ 20
[   17.744166] forcedeth 0000:00:08.0: setting latency timer to 64
[   17.744232] nv_probe: set workaround bit for reversed mac addr
[   17.975381] rndis_wlan 1-4.1:1.0: wlan0: register 'rndis_wlan' at us=
b-0000:00:02.1-4.1, Wireless RNDIS device, BCM4320b based, 00:16:01:cf:=
56:29
[   17.975408] usbcore: registered new interface driver rndis_wlan
[   18.090186] type=3D1400 audit(1289240633.937:4): avc:  denied  { mma=
p_zero } for  pid=3D2636 comm=3D"vbetool" scontext=3Dsystem_u:system_r:=
vbetool_t:s0-s0:c0.c1023 tcontext=3Dsystem_u:system_r:vbetool_t:s0-s0:c=
0.c1023 tclass=3Dmemprotect
[   18.259569] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, =
addr 60:50:40:30:20:10
[   18.259573] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gb=
it lnktim msi desc-v3
[   18.259859] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[   18.259864] forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 2=
0 (level, low) -> IRQ 20
[   18.259869] forcedeth 0000:00:09.0: setting latency timer to 64
[   18.259941] nv_probe: set workaround bit for reversed mac addr
[   18.739801] cfg80211: Calling CRDA for country: DE
[   18.774031] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, =
addr 60:50:40:30:20:11
[   18.774036] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt gb=
it lnktim msi desc-v3
[   19.031742] cfg80211: Regulatory domain changed to country: DE
[   19.031745]     (start_freq - end_freq @ bandwidth), (max_antenna_ga=
in, max_eirp)
[   19.031748]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 =
mBm)
[   19.031751]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 =
mBm)
[   19.031753]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 =
mBm)
[   21.476636] Olympic: 0000:01:00.0 registered as: tr0
[   29.484055] EXT4-fs (dm-0): re-mounted. Opts: data=3Dwriteback
[   29.967691] SELinux: initialized (dev sda1, type ext2), uses xattr
[   32.070787] Adding 6386492k swap on /dev/mapper/luks-swap.  Priority=
:-1 extents:1 across:6386492k=20
[   32.073363] SELinux: initialized (dev binfmt_misc, type binfmt_misc)=
, uses genfs_contexts
[   34.438635] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   34.452144] forcedeth 0000:00:08.0: irq 42 for MSI/MSI-X
[   34.452336] eth0: no link during initialization.
[   34.453978] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.460858] forcedeth 0000:00:09.0: irq 43 for MSI/MSI-X
[   34.461010] eth1: no link during initialization.
[   34.465338] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   43.497868] hda-intel: IRQ timing workaround is activated for card #=
3. Suggest a bigger bdl_pos_adj.
[  103.111563] SELinux: initialized (dev fuse, type fuse), uses genfs_c=
ontexts
[  104.333024] end_request: I/O error, dev fd0, sector 0
[  104.383025] end_request: I/O error, dev fd0, sector 0
[  121.707689] rndis_wlan 1-4.1:1.0: wlan0: media connect
[  121.734333] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  131.786019] wlan0: no IPv6 routers present
[  311.264021] EXT4-fs (dm-0): error count: 50
[  311.264026] EXT4-fs (dm-0): initial error at 1288599125: ext4_mb_gen=
erate_buddy:718
[  311.264030] EXT4-fs (dm-0): last error at 1288723194: mb_free_blocks=
:1303: inode 15034661: block 60114723
