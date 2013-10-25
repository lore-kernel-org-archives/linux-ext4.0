From: Jakob Haufe <sur5r@sur5r.net>
Subject: online resize of ext4 hung (3.2.51 / 1.42.5)
Date: Fri, 25 Oct 2013 22:06:32 +0200
Message-ID: <20131025220632.62b4f9b3@samsa>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512; protocol="application/pgp-signature"; boundary="=_libri-12416-1382731601-0001-2"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:35477 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3JYULp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Oct 2013 16:11:45 -0400
Received: from samsa (localhost [127.0.0.1])
	by samsa (Postfix) with ESMTP id D4265B0855C
	for <linux-ext4@vger.kernel.org>; Fri, 25 Oct 2013 22:06:37 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_libri-12416-1382731601-0001-2
Content-Type: multipart/mixed; boundary="MP_/O1Sw4S.Ysl3sXUM0i3_VQb9"

--MP_/O1Sw4S.Ysl3sXUM0i3_VQb9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

after a short discussion on IRC, Eric Sandeen recommended me to send this to
the list:

I've got a stuck online resize of an ext4 FS.
Kernel is Debian 3.2.0-4-amd64 (3.2.51), e2fsprogs 1.42.5.

History is as follows: The FS was 5.46T in size. I had to shrink it to 3T in
order to remove a disk from the underlying LVM VG. At that point, about 2.8T
were in use. After removing the disk, i extended the LV again to take up the
then available space (3.64T). I then mounted the FS and started the online
resize. In parallel, more data got written to the FS.
It's now stuck at this point (df -m):

Filesystem                       1M-blocks    Used Available Use% Mounted on
/dev/mapper/backupserver-backups   3481020 3043818    437203 88% /mnt/lvmba=
ckups

Kernel log is attached, CPU is idle.

I can leave the machine sitting around for another day or maybe two, so if
it's necessary to extract more information from somewhere, please tell me.

Please CC me on replies as I'm not subscribed to the list.

Thanks in advance,
Jakob Haufe

--MP_/O1Sw4S.Ysl3sXUM0i3_VQb9
Content-Type: text/x-log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=kern.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org)=
 (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.51-1
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.2.0-4-amd64 root=
=3DUUID=3D407e2400-4013-47fa-a5e8-5bb2d01931dd ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000008db2b000 (usable)
[    0.000000]  BIOS-e820: 000000008db2b000 - 000000008db5b000 (reserved)
[    0.000000]  BIOS-e820: 000000008db5b000 - 000000008de1c000 (usable)
[    0.000000]  BIOS-e820: 000000008de1c000 - 000000008deba000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008deba000 - 000000008ea2a000 (reserved)
[    0.000000]  BIOS-e820: 000000008ea2a000 - 000000008ea2b000 (usable)
[    0.000000]  BIOS-e820: 000000008ea2b000 - 000000008ec31000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008ec31000 - 000000008f072000 (usable)
[    0.000000]  BIOS-e820: 000000008f072000 - 000000008f7f3000 (reserved)
[    0.000000]  BIOS-e820: 000000008f7f3000 - 000000008f800000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed40000 - 00000000fed45000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100001000 - 000000013f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: MSI MS-7721/FM2-A75MA-P33 (MS-7721), BIOS V11.1 05/02/2=
013
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x13f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFF0000000 write-back
[    0.000000]   2 base 00008F800000 mask FFFFFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000013f000000 aka 5104M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 000000008f800000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x8f800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fd790] fd790
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-000000008f800000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 008f800000 page 2M
[    0.000000] kernel direct mapping tables up to 8f800000 @ 1fffe000-20000=
000
[    0.000000] init_memory_mapping: 0000000100001000-000000013f000000
[    0.000000]  0100001000 - 0100200000 page 4k
[    0.000000]  0100200000 - 013f000000 page 2M
[    0.000000] kernel direct mapping tables up to 13f000000 @ 8f7fd000-8f80=
0000
[    0.000000] RAMDISK: 36a1a000 - 37505000
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 000000008dea7078 0006C (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FACP 000000008dead220 0010C (v05 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI Warning: FADT (revision 5) is longer than ACPI 2.0 vers=
ion, truncating length 268 to 244 (20110623/tbfadt-288)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero addres=
s or length: 0x0000000000000000/0x1 (20110623/tbfadt-560)
[    0.000000] ACPI: DSDT 000000008dea7178 060A8 (v02 ALASKA    A M I 00000=
000 INTL 20051117)
[    0.000000] ACPI: FACS 000000008deaf080 00040
[    0.000000] ACPI: APIC 000000008dead330 00072 (v03 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FPDT 000000008dead3a8 00044 (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: MCFG 000000008dead3f0 0003C (v01 ALASKA    A M I 01072=
009 MSFT 00010013)
[    0.000000] ACPI: HPET 000000008dead430 00038 (v01 ALASKA    A M I 01072=
009 AMI  00000005)
[    0.000000] ACPI: IVRS 000000008dead468 00070 (v02    AMD ANNAPURN 00000=
001 AMD  00000000)
[    0.000000] ACPI: SSDT 000000008dead4d8 006B2 (v01    AMD ANNAPURN 00000=
001 AMD  00000001)
[    0.000000] ACPI: SSDT 000000008deadb90 004B7 (v02    AMD ANNAPURN 00000=
001 MSFT 04000000)
[    0.000000] ACPI: CRAT 000000008deae048 001A8 (v01    AMD ANNAPURN 00000=
001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013f000000
[    0.000000]   NODE_DATA [000000013effb000 - 000000013effffff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013b20000=
0-ffff88013dffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0008db2b
[    0.000000]     0: 0x0008db5b -> 0x0008de1c
[    0.000000]     0: 0x0008ea2a -> 0x0008ea2b
[    0.000000]     0: 0x0008ec31 -> 0x0008f072
[    0.000000]     0: 0x0008f7f3 -> 0x0008f800
[    0.000000]     0: 0x00100001 -> 0x0013f000
[    0.000000] On node 0 totalpages: 840136
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 563827 pages, LIFO batch:31
[    0.000000]   Normal zone: 3528 pages used for memmap
[    0.000000]   Normal zone: 254519 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 33, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 000000008db2b000 - 000000008db=
5b000
[    0.000000] PM: Registered nosave memory: 000000008de1c000 - 000000008de=
ba000
[    0.000000] PM: Registered nosave memory: 000000008deba000 - 000000008ea=
2a000
[    0.000000] PM: Registered nosave memory: 000000008ea2b000 - 000000008ec=
31000
[    0.000000] PM: Registered nosave memory: 000000008f072000 - 000000008f7=
f3000
[    0.000000] PM: Registered nosave memory: 000000008f800000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec=
01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec=
10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec=
11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed=
01000
[    0.000000] PM: Registered nosave memory: 00000000fed01000 - 00000000fed=
40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000fed=
45000
[    0.000000] PM: Registered nosave memory: 00000000fed45000 - 00000000fed=
80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 00000000fed=
90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000ff0=
00000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 00000001000=
00000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 00000001000=
01000
[    0.000000] Allocating PCI resources starting at 8f800000 (gap: 8f800000=
:6f400000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88013ec00000 s82944 r8192=
 d23552 u524288
[    0.000000] pcpu-alloc: s82944 r8192 d23552 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 822267
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.2.0-4-amd6=
4 root=3DUUID=3D407e2400-4013-47fa-a5e8-5bb2d01931dd ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3227232k/5226496k available (3426k kernel code, 1865=
952k absent, 133312k reserved, 3312k data, 576k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2994.176 MHz processor.
[    0.004003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5988.35 BogoMIPS (lpj=3D11976704)
[    0.004006] pid_max: default: 32768 minimum: 301
[    0.004040] Security Framework initialized
[    0.004044] AppArmor: AppArmor disabled by boot time parameter
[    0.004316] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.005498] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.006051] Mount-cache hash table entries: 256
[    0.006153] Initializing cgroup subsys cpuacct
[    0.006157] Initializing cgroup subsys memory
[    0.006168] Initializing cgroup subsys devices
[    0.006171] Initializing cgroup subsys freezer
[    0.006172] Initializing cgroup subsys net_cls
[    0.006174] Initializing cgroup subsys blkio
[    0.006179] Initializing cgroup subsys perf_event
[    0.006205] tseg: 008f800000
[    0.006207] CPU: Physical Processor ID: 0
[    0.006208] CPU: Processor Core ID: 0
[    0.006210] mce: CPU supports 7 MCE banks
[    0.006513] ACPI: Core revision 20110623
[    0.012714] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.053382] CPU0: AMD A4-4000 APU with Radeon(tm) HD Graphics     steppi=
ng 01
[    0.056003] Performance Events: AMD Family 15h PMU driver.
[    0.056003] ... version:                0
[    0.056003] ... bit width:              48
[    0.056003] ... generic registers:      6
[    0.056003] ... value mask:             0000ffffffffffff
[    0.056003] ... max period:             00007fffffffffff
[    0.056003] ... fixed-purpose events:   0
[    0.056003] ... event mask:             000000000000003f
[    0.056003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.056003] Booting Node   0, Processors  #1
[    0.056003] smpboot cpu 1: start_ip =3D 99000
[    0.144031] NMI watchdog enabled, takes one hw-pmu counter.
[    0.144060] Brought up 2 CPUs
[    0.144062] Total of 2 processors activated (11976.87 BogoMIPS).
[    0.144380] devtmpfs: initialized
[    0.146059] PM: Registering ACPI NVS region at 8de1c000 (647168 bytes)
[    0.146059] PM: Registering ACPI NVS region at 8ea2b000 (2121728 bytes)
[    0.146059] print_constraints: dummy:=20
[    0.146059] NET: Registered protocol family 16
[    0.146059] Extended Config Space enabled on 0 nodes
[    0.146059] ACPI: bus type pci registered
[    0.146059] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.146059] PCI: not using MMCONFIG
[    0.146059] PCI: Using configuration type 1 for base access
[    0.146059] PCI: Using configuration type 1 for extended access
[    0.146059] bio: create slab <bio-0> at 0
[    0.146059] ACPI: Added _OSI(Module Device)
[    0.146059] ACPI: Added _OSI(Processor Device)
[    0.146059] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.146059] ACPI: Added _OSI(Processor Aggregator Device)
[    0.148508] ACPI: EC: Look up EC in DSDT
[    0.149346] ACPI: Executed 1 blocks of module-level executable AML code
[    0.152113] ACPI: Interpreter enabled
[    0.152116] ACPI: (supports S0 S3 S4 S5)
[    0.152137] ACPI: Using IOAPIC for interrupt routing
[    0.152155] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.152190] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACP=
I motherboard resources
[    0.197907] ACPI: No dock devices found.
[    0.197910] HEST: Table not found.
[    0.197913] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.198157] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.198406] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af]
[    0.198408] pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0cf7]
[    0.198410] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03df]
[    0.198412] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.198414] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.198416] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x00=
0dffff]
[    0.198418] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xff=
ffffff]
[    0.198428] pci 0000:00:00.0: [1022:1410] type 0 class 0x000600
[    0.198457] pci 0000:00:00.2: [1022:1419] type 0 class 0x000806
[    0.198512] pci 0000:00:01.0: [1002:9993] type 0 class 0x000300
[    0.198519] pci 0000:00:01.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.198525] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.198529] pci 0000:00:01.0: reg 18: [mem 0xfef00000-0xfef3ffff]
[    0.198562] pci 0000:00:01.0: supports D1 D2
[    0.198576] pci 0000:00:01.1: [1002:9902] type 0 class 0x000403
[    0.198583] pci 0000:00:01.1: reg 10: [mem 0xfef44000-0xfef47fff]
[    0.198621] pci 0000:00:01.1: supports D1 D2
[    0.198639] pci 0000:00:04.0: [1022:1414] type 1 class 0x000604
[    0.198677] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.198709] pci 0000:00:11.0: [1022:7801] type 0 class 0x000106
[    0.198725] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
[    0.198733] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
[    0.198741] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
[    0.198749] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
[    0.198756] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
[    0.198764] pci 0000:00:11.0: reg 24: [mem 0xfef4f000-0xfef4f7ff]
[    0.198813] pci 0000:00:12.0: [1022:7807] type 0 class 0x000c03
[    0.198824] pci 0000:00:12.0: reg 10: [mem 0xfef4e000-0xfef4efff]
[    0.198883] pci 0000:00:12.2: [1022:7808] type 0 class 0x000c03
[    0.198899] pci 0000:00:12.2: reg 10: [mem 0xfef4d000-0xfef4d0ff]
[    0.198966] pci 0000:00:12.2: supports D1 D2
[    0.198967] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.198988] pci 0000:00:13.0: [1022:7807] type 0 class 0x000c03
[    0.198999] pci 0000:00:13.0: reg 10: [mem 0xfef4c000-0xfef4cfff]
[    0.199058] pci 0000:00:13.2: [1022:7808] type 0 class 0x000c03
[    0.199074] pci 0000:00:13.2: reg 10: [mem 0xfef4b000-0xfef4b0ff]
[    0.199141] pci 0000:00:13.2: supports D1 D2
[    0.199142] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.199162] pci 0000:00:14.0: [1022:780b] type 0 class 0x000c05
[    0.199227] pci 0000:00:14.2: [1022:780d] type 0 class 0x000403
[    0.199245] pci 0000:00:14.2: reg 10: [mem 0xfef40000-0xfef43fff 64bit]
[    0.199299] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.199312] pci 0000:00:14.3: [1022:780e] type 0 class 0x000601
[    0.199375] pci 0000:00:14.4: [1022:780f] type 1 class 0x000604
[    0.199410] pci 0000:00:14.5: [1022:7809] type 0 class 0x000c03
[    0.199421] pci 0000:00:14.5: reg 10: [mem 0xfef4a000-0xfef4afff]
[    0.199478] pci 0000:00:16.0: [1022:7807] type 0 class 0x000c03
[    0.199489] pci 0000:00:16.0: reg 10: [mem 0xfef49000-0xfef49fff]
[    0.199548] pci 0000:00:16.2: [1022:7808] type 0 class 0x000c03
[    0.199563] pci 0000:00:16.2: reg 10: [mem 0xfef48000-0xfef480ff]
[    0.199630] pci 0000:00:16.2: supports D1 D2
[    0.199632] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.199651] pci 0000:00:18.0: [1022:1400] type 0 class 0x000600
[    0.199668] pci 0000:00:18.1: [1022:1401] type 0 class 0x000600
[    0.199684] pci 0000:00:18.2: [1022:1402] type 0 class 0x000600
[    0.199700] pci 0000:00:18.3: [1022:1403] type 0 class 0x000600
[    0.199720] pci 0000:00:18.4: [1022:1404] type 0 class 0x000600
[    0.199735] pci 0000:00:18.5: [1022:1405] type 0 class 0x000600
[    0.199794] pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
[    0.199806] pci 0000:01:00.0: reg 10: [io  0xe000-0xe0ff]
[    0.199826] pci 0000:01:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit p=
ref]
[    0.199839] pci 0000:01:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit p=
ref]
[    0.199892] pci 0000:01:00.0: supports D1 D2
[    0.199894] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.204060] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.204066] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.204071] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff=
 64bit pref]
[    0.204131] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive dec=
ode)
[    0.204139] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtr=
active decode)
[    0.204145] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtr=
active decode)
[    0.204148] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtr=
active decode)
[    0.204150] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.204152] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.204154] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff=
] (subtractive decode)
[    0.204156] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xffffffff=
] (subtractive decode)
[    0.204170] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.204375] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.204438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.204557]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.204717]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned=
 control mask: 0x0d
[    0.204719] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.209928] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 *11 14 15)
[    0.209986] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 *10 11 14 15)
[    0.210045] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 *11 14 15)
[    0.210101] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 *10 11 14 15)
[    0.210147] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.210182] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.210216] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.210250] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.210330] vgaarb: device added: PCI:0000:00:01.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.210330] vgaarb: loaded
[    0.210330] vgaarb: bridge control possible 0000:00:01.0
[    0.210330] PCI: Using ACPI for IRQ routing
[    0.217372] PCI: pci_cache_line_size set to 64 bytes
[    0.217436] reserve RAM buffer: 000000000009e800 - 000000000009ffff=20
[    0.217438] reserve RAM buffer: 000000008db2b000 - 000000008fffffff=20
[    0.217441] reserve RAM buffer: 000000008de1c000 - 000000008fffffff=20
[    0.217443] reserve RAM buffer: 000000008ea2b000 - 000000008fffffff=20
[    0.217444] reserve RAM buffer: 000000008f072000 - 000000008fffffff=20
[    0.217446] reserve RAM buffer: 000000008f800000 - 000000008fffffff=20
[    0.217448] reserve RAM buffer: 000000013f000000 - 000000013fffffff=20
[    0.217544] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.217548] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.219563] Switching to clocksource hpet
[    0.219571] pnp: PnP ACPI init
[    0.219571] ACPI: bus type pnp registered
[    0.219571] pnp 00:00: [bus 00-ff]
[    0.219571] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.219571] pnp 00:00: [io  0x0000-0x03af window]
[    0.219571] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    0.219571] pnp 00:00: [io  0x03b0-0x03df window]
[    0.219571] pnp 00:00: [io  0x0d00-0xffff window]
[    0.219571] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.219571] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.219571] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    0.219571] pnp 00:00: [mem 0x00000000 window]
[    0.219571] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.219571] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.219571] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.219571] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.219571] pnp 00:02: [mem 0x90000000-0xbfffffff]
[    0.219571] system 00:02: [mem 0x90000000-0xbfffffff] has been reserved
[    0.219571] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.219571] pnp 00:03: [mem 0xfeb80000-0xfebfffff]
[    0.219571] system 00:03: [mem 0xfeb80000-0xfebfffff] has been reserved
[    0.219571] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.219571] pnp 00:04: [io  0x0000-0xffffffffffffffff disabled]
[    0.219571] pnp 00:04: [io  0x0a00-0x0a1f]
[    0.219571] pnp 00:04: [io  0x0600-0x060f]
[    0.219571] system 00:04: [io  0x0a00-0x0a1f] has been reserved
[    0.219571] system 00:04: [io  0x0600-0x060f] has been reserved
[    0.219571] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.219571] pnp 00:05: [io  0x03f8-0x03ff]
[    0.219571] pnp 00:05: [irq 4]
[    0.219571] pnp 00:05: [dma 0 disabled]
[    0.219571] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.219571] pnp 00:06: [io  0x0378-0x037f]
[    0.219571] pnp 00:06: [irq 5]
[    0.219571] pnp 00:06: [dma 3]
[    0.219571] pnp 00:06: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.219571] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.219571] pnp 00:08: [dma 4]
[    0.219571] pnp 00:08: [io  0x0000-0x000f]
[    0.219571] pnp 00:08: [io  0x0081-0x0083]
[    0.219571] pnp 00:08: [io  0x0087]
[    0.219571] pnp 00:08: [io  0x0089-0x008b]
[    0.219571] pnp 00:08: [io  0x008f]
[    0.219571] pnp 00:08: [io  0x00c0-0x00df]
[    0.219571] pnp 00:08: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.219571] pnp 00:09: [io  0x0070-0x0071]
[    0.219571] pnp 00:09: [irq 8]
[    0.219571] pnp 00:09: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.219571] pnp 00:0a: [io  0x0061]
[    0.219571] pnp 00:0a: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.219571] pnp 00:0b: [io  0x0010-0x001f]
[    0.219571] pnp 00:0b: [io  0x0022-0x003f]
[    0.219571] pnp 00:0b: [io  0x0044-0x005f]
[    0.219571] pnp 00:0b: [io  0x0072-0x007f]
[    0.219571] pnp 00:0b: [io  0x0080]
[    0.219571] pnp 00:0b: [io  0x0084-0x0086]
[    0.219571] pnp 00:0b: [io  0x0088]
[    0.219571] pnp 00:0b: [io  0x008c-0x008e]
[    0.219571] pnp 00:0b: [io  0x0090-0x009f]
[    0.219571] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.219571] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.219571] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.219571] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.219571] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.219571] pnp 00:0c: [io  0x00f0-0x00ff]
[    0.219571] pnp 00:0c: [irq 13]
[    0.219571] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.219571] pnp 00:0d: [io  0x0010-0x001f]
[    0.219571] pnp 00:0d: [io  0x0022-0x003f]
[    0.219571] pnp 00:0d: [io  0x0063]
[    0.219571] pnp 00:0d: [io  0x0065]
[    0.219571] pnp 00:0d: [io  0x0067-0x006f]
[    0.219571] pnp 00:0d: [io  0x0072-0x007f]
[    0.219571] pnp 00:0d: [io  0x0080]
[    0.219571] pnp 00:0d: [io  0x0084-0x0086]
[    0.219571] pnp 00:0d: [io  0x0088]
[    0.219571] pnp 00:0d: [io  0x008c-0x008e]
[    0.219571] pnp 00:0d: [io  0x0090-0x009f]
[    0.219571] pnp 00:0d: [io  0x00a2-0x00bf]
[    0.219571] pnp 00:0d: [io  0x00b1]
[    0.219571] pnp 00:0d: [io  0x00e0-0x00ef]
[    0.219571] pnp 00:0d: [io  0x04d0-0x04d1]
[    0.219571] pnp 00:0d: [io  0x040b]
[    0.219571] pnp 00:0d: [io  0x04d6]
[    0.219571] pnp 00:0d: [io  0x0c00-0x0c01]
[    0.219571] pnp 00:0d: [io  0x0c14]
[    0.219571] pnp 00:0d: [io  0x0c50-0x0c51]
[    0.219571] pnp 00:0d: [io  0x0c52]
[    0.219571] pnp 00:0d: [io  0x0c6c]
[    0.219571] pnp 00:0d: [io  0x0c6f]
[    0.219571] pnp 00:0d: [io  0x0cd0-0x0cd1]
[    0.219571] pnp 00:0d: [io  0x0cd2-0x0cd3]
[    0.219571] pnp 00:0d: [io  0x0cd4-0x0cd5]
[    0.219571] pnp 00:0d: [io  0x0cd6-0x0cd7]
[    0.219571] pnp 00:0d: [io  0x0cd8-0x0cdf]
[    0.219571] pnp 00:0d: [io  0x0800-0x089f]
[    0.219571] pnp 00:0d: [io  0x0000-0xffffffffffffffff disabled]
[    0.219571] pnp 00:0d: [io  0x0000-0x000f]
[    0.219571] pnp 00:0d: [io  0x0b20-0x0b3f]
[    0.219571] pnp 00:0d: [io  0x0900-0x090f]
[    0.219571] pnp 00:0d: [io  0x0910-0x091f]
[    0.219571] pnp 00:0d: [io  0xfe00-0xfefe]
[    0.219571] pnp 00:0d: [io  0x0060-0x005f disabled]
[    0.219571] pnp 00:0d: [io  0x0064-0x0063 disabled]
[    0.219571] pnp 00:0d: [mem 0xfec00000-0xfec00fff]
[    0.219571] pnp 00:0d: [mem 0xfee00000-0xfee00fff]
[    0.219571] pnp 00:0d: [mem 0xfed80000-0xfed8ffff]
[    0.219571] pnp 00:0d: [mem 0xfed61000-0xfed70fff]
[    0.219571] pnp 00:0d: [mem 0xfec10000-0xfec10fff]
[    0.219571] pnp 00:0d: [mem 0xfed00000-0xfed00fff]
[    0.219571] pnp 00:0d: [mem 0xff000000-0xffffffff]
[    0.219571] system 00:0d: [io  0x04d0-0x04d1] has been reserved
[    0.219571] system 00:0d: [io  0x040b] has been reserved
[    0.219571] system 00:0d: [io  0x04d6] has been reserved
[    0.219571] system 00:0d: [io  0x0c00-0x0c01] has been reserved
[    0.219571] system 00:0d: [io  0x0c14] has been reserved
[    0.219571] system 00:0d: [io  0x0c50-0x0c51] has been reserved
[    0.219571] system 00:0d: [io  0x0c52] has been reserved
[    0.219571] system 00:0d: [io  0x0c6c] has been reserved
[    0.219571] system 00:0d: [io  0x0c6f] has been reserved
[    0.219571] system 00:0d: [io  0x0cd0-0x0cd1] has been reserved
[    0.219571] system 00:0d: [io  0x0cd2-0x0cd3] has been reserved
[    0.219571] system 00:0d: [io  0x0cd4-0x0cd5] has been reserved
[    0.219571] system 00:0d: [io  0x0cd6-0x0cd7] has been reserved
[    0.219571] system 00:0d: [io  0x0cd8-0x0cdf] has been reserved
[    0.219571] system 00:0d: [io  0x0800-0x089f] has been reserved
[    0.219571] system 00:0d: [io  0x0b20-0x0b3f] has been reserved
[    0.219571] system 00:0d: [io  0x0900-0x090f] has been reserved
[    0.219571] system 00:0d: [io  0x0910-0x091f] has been reserved
[    0.219571] system 00:0d: [io  0xfe00-0xfefe] has been reserved
[    0.219571] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reser=
ved
[    0.219571] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.219571] system 00:0d: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.219571] system 00:0d: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.219571] system 00:0d: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.219571] system 00:0d: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.219571] system 00:0d: [mem 0xff000000-0xffffffff] has been reserved
[    0.219571] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.219726] pnp 00:0e: Plug and Play ACPI device, IDs PNP0103 (disabled)
[    0.219730] pnp: PnP ACPI: found 15 devices
[    0.219731] ACPI: ACPI bus type pnp unregistered
[    0.226564] PCI: max bus depth: 1 pci_try_num: 2
[    0.226577] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.226580] pci 0000:00:04.0:   bridge window [io  0xe000-0xefff]
[    0.226584] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff=
 64bit pref]
[    0.226588] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.226610] pci 0000:00:04.0: setting latency timer to 64
[    0.226617] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.226619] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.226621] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.226622] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.226624] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.226626] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.226628] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.226630] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.226631] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd00fffff 64bit=
 pref]
[    0.226633] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.226635] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.226637] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.226638] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.226640] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.226641] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.226643] pci_bus 0000:02: resource 10 [mem 0xc0000000-0xffffffff]
[    0.226708] NET: Registered protocol family 2
[    0.226836] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.227762] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.229855] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.230098] TCP: Hash tables configured (established 524288 bind 65536)
[    0.230101] TCP reno registered
[    0.230113] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.230136] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.230246] NET: Registered protocol family 1
[    0.230261] pci 0000:00:01.0: Boot video device
[    0.552156] PCI: CLS 64 bytes, default 64
[    0.552205] Unpacking initramfs...
[    0.762992] Freeing initrd memory: 11180k freed
[    0.766981] pci 0000:00:00.2: irq 40 for MSI/MSI-X
[    0.767065] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40 extended fea=
tures:  PreF PPR GT IA
[    0.775380] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.775383] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.775386] Placing 64MB software IO TLB between ffff880089b2b000 - ffff=
88008db2b000
[    0.775388] software IO TLB at phys 0x89b2b000 - 0x8db2b000
[    0.775707] [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for=
 vector 0x10400, but the register is already in use for vector 0xf9 on anot=
her cpu
[    0.775746] [Firmware Bug]: cpu 1, IBS interrupt offset 0 not available =
(MSRC001103A=3D0x0000000000000100)
[    0.775779] Failed to setup IBS, -22
[    0.775987] audit: initializing netlink socket (disabled)
[    0.775997] type=3D2000 audit(1381938858.768:1): initialized
[    0.788366] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.788941] VFS: Disk quotas dquot_6.5.2
[    0.788970] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.789026] msgmni has been set to 6325
[    0.789179] alg: No test for stdrng (krng)
[    0.789206] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.789209] io scheduler noop registered
[    0.789210] io scheduler deadline registered
[    0.789227] io scheduler cfq registered (default)
[    0.789343] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.789360] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.789362] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.789626] ERST: Table is not found!
[    0.789628] GHES: HEST is not enabled!
[    0.789682] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.810043] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.888671] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.900366] Linux agpgart interface v0.103
[    0.900475] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.900796] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.900802] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.900920] mousedev: PS/2 mouse device common for all mice
[    0.900954] rtc_cmos 00:09: RTC can wake from S4
[    0.901045] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[    0.901065] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.901073] cpuidle: using governor ladder
[    0.901075] cpuidle: using governor menu
[    0.901228] TCP cubic registered
[    0.901281] NET: Registered protocol family 10
[    0.901659] Mobile IPv6
[    0.901661] NET: Registered protocol family 17
[    0.901664] Registering the dns_resolver key type
[    0.901790] PM: Hibernation image not present or could not be loaded.
[    0.901798] registered taskstats version 1
[    0.902178] rtc_cmos 00:09: setting system clock to 2013-10-16 15:54:19 =
UTC (1381938859)
[    0.902230] Initializing network drop monitor service
[    0.903236] Freeing unused kernel memory: 576k freed
[    0.903358] Write protecting the kernel read-only data: 6144k
[    0.905476] Freeing unused kernel memory: 652k freed
[    0.907772] Freeing unused kernel memory: 688k freed
[    0.917702] udevd[50]: starting version 175
[    0.939807] usbcore: registered new interface driver usbfs
[    0.939831] usbcore: registered new interface driver hub
[    0.941956] SCSI subsystem initialized
[    0.952097] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.952147] r8169 0000:01:00.0: setting latency timer to 64
[    0.952206] r8169 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.952694] r8169 0000:01:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000=
616000, d4:3d:7e:93:70:9c, XID 0c900800 IRQ 41
[    0.952699] r8169 0000:01:00.0: eth0: jumbo features [frames: 9200 bytes=
, tx checksumming: ko]
[    0.965890] usbcore: registered new device driver usb
[    0.966322] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.966364] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.966388] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus =
number 1
[    0.966396] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround
[    0.966419] QUIRK: Enable AMD PLL fix
[    0.966429] ehci_hcd 0000:00:12.2: debug port 1
[    0.966453] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfef4d000
[    0.971516] libata version 3.00 loaded.
[    0.976029] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.976076] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.976079] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.976081] usb usb1: Product: EHCI Host Controller
[    0.976083] usb usb1: Manufacturer: Linux 3.2.0-4-amd64 ehci_hcd
[    0.976085] usb usb1: SerialNumber: 0000:00:12.2
[    0.976209] hub 1-0:1.0: USB hub found
[    0.976216] hub 1-0:1.0: 5 ports detected
[    0.976336] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.976347] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus =
number 2
[    0.976356] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround
[    0.976377] ehci_hcd 0000:00:13.2: debug port 1
[    0.976391] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfef4b000
[    0.980656] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.988056] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.988086] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.988089] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.988092] usb usb2: Product: EHCI Host Controller
[    0.988095] usb usb2: Manufacturer: Linux 3.2.0-4-amd64 ehci_hcd
[    0.988098] usb usb2: SerialNumber: 0000:00:13.2
[    0.988753] hub 2-0:1.0: USB hub found
[    0.988759] hub 2-0:1.0: 5 ports detected
[    0.988878] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    0.988890] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus =
number 3
[    0.988899] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround
[    0.988920] ehci_hcd 0000:00:16.2: debug port 1
[    0.988936] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfef48000
[    1.000034] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.000066] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.000068] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.000071] usb usb3: Product: EHCI Host Controller
[    1.000073] usb usb3: Manufacturer: Linux 3.2.0-4-amd64 ehci_hcd
[    1.000075] usb usb3: SerialNumber: 0000:00:16.2
[    1.000198] hub 3-0:1.0: USB hub found
[    1.000205] hub 3-0:1.0: 4 ports detected
[    1.000545] ahci 0000:00:11.0: version 3.0
[    1.000611] ahci 0000:00:11.0: irq 42 for MSI/MSI-X
[    1.000701] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3f impl SATA mode
[    1.000705] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp=
 pio slum part=20
[    1.003649] scsi0 : ahci
[    1.003768] scsi1 : ahci
[    1.003835] scsi2 : ahci
[    1.003899] scsi3 : ahci
[    1.003964] scsi4 : ahci
[    1.004064] scsi5 : ahci
[    1.004472] ata1: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f10=
0 irq 42
[    1.004476] ata2: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f18=
0 irq 42
[    1.004479] ata3: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f20=
0 irq 42
[    1.004483] ata4: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f28=
0 irq 42
[    1.004486] ata5: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f30=
0 irq 42
[    1.004489] ata6: SATA max UDMA/133 abar m2048@0xfef4f000 port 0xfef4f38=
0 irq 42
[    1.004585] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.004597] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus =
number 4
[    1.004628] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfef4e000
[    1.064104] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.064108] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.064110] usb usb4: Product: OHCI Host Controller
[    1.064112] usb usb4: Manufacturer: Linux 3.2.0-4-amd64 ohci_hcd
[    1.064113] usb usb4: SerialNumber: 0000:00:12.0
[    1.064253] hub 4-0:1.0: USB hub found
[    1.064260] hub 4-0:1.0: 5 ports detected
[    1.064845] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.064859] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus =
number 5
[    1.064882] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfef4c000
[    1.124106] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.124109] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.124111] usb usb5: Product: OHCI Host Controller
[    1.124113] usb usb5: Manufacturer: Linux 3.2.0-4-amd64 ohci_hcd
[    1.124114] usb usb5: SerialNumber: 0000:00:13.0
[    1.124258] hub 5-0:1.0: USB hub found
[    1.124264] hub 5-0:1.0: 5 ports detected
[    1.124834] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.124848] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus =
number 6
[    1.124870] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfef4a000
[    1.184113] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.184116] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.184119] usb usb6: Product: OHCI Host Controller
[    1.184120] usb usb6: Manufacturer: Linux 3.2.0-4-amd64 ohci_hcd
[    1.184122] usb usb6: SerialNumber: 0000:00:14.5
[    1.184270] hub 6-0:1.0: USB hub found
[    1.184277] hub 6-0:1.0: 2 ports detected
[    1.184850] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    1.184863] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus =
number 7
[    1.184887] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfef49000
[    1.244121] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.244124] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.244126] usb usb7: Product: OHCI Host Controller
[    1.244128] usb usb7: Manufacturer: Linux 3.2.0-4-amd64 ohci_hcd
[    1.244129] usb usb7: SerialNumber: 0000:00:16.0
[    1.244269] hub 7-0:1.0: USB hub found
[    1.244276] hub 7-0:1.0: 4 ports detected
[    1.288114] usb 1-2: new high-speed USB device number 2 using ehci_hcd
[    1.324168] ata3: SATA link down (SStatus 0 SControl 300)
[    1.324192] ata6: SATA link down (SStatus 0 SControl 300)
[    1.425886] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0723
[    1.425890] usb 1-2: New USB device strings: Mfr=3D3, Product=3D4, Seria=
lNumber=3D2
[    1.425892] usb 1-2: Product: USB Storage
[    1.425893] usb 1-2: Manufacturer: Generic=20
[    1.425895] usb 1-2: SerialNumber: 000000009451
[    1.428570] Initializing USB Mass Storage driver...
[    1.428659] usb-storage 1-2:1.0: Quirks match for vid 05e3 pid 0723: 8000
[    1.428678] scsi6 : usb-storage 1-2:1.0
[    1.428749] usbcore: registered new interface driver usb-storage
[    1.428751] USB Mass Storage support registered.
[    1.496115] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.496138] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.496153] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.496170] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.496689] ata4.00: ATA-9: WDC WD20EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.496693] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.496702] ata5.00: ATA-9: WDC WD20EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.496705] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.497411] ata1.00: ATA-8: ST500DM002-1BD142, KC45, max UDMA/133
[    1.497415] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.497921] ata5.00: configured for UDMA/133
[    1.498131] ata4.00: configured for UDMA/133
[    1.498966] ata1.00: configured for UDMA/133
[    1.499078] scsi 0:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 KC=
45 PQ: 0 ANSI: 5
[    1.499908] ata2.00: ATA-8: WDC WD20EARS-00MVWB0, 50.0AB50, max UDMA/133
[    1.499911] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.503918] ata2.00: configured for UDMA/133
[    1.504044] scsi 1:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 50=
.0 PQ: 0 ANSI: 5
[    1.504258] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EZRX-00D 80=
.0 PQ: 0 ANSI: 5
[    1.504429] scsi 4:0:0:0: Direct-Access     ATA      WDC WD20EZRX-00D 80=
.0 PQ: 0 ANSI: 5
[    1.510934] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    1.510938] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.510981] sd 0:0:0:0: [sda] Write Protect is off
[    1.510985] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.511005] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.511359] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    1.511400] sd 1:0:0:0: [sdb] Write Protect is off
[    1.511404] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.511425] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.511730] sd 3:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    1.511734] sd 3:0:0:0: [sdc] 4096-byte physical blocks
[    1.511773] sd 3:0:0:0: [sdc] Write Protect is off
[    1.511776] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.511793] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.511894] sd 4:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    1.511897] sd 4:0:0:0: [sdd] 4096-byte physical blocks
[    1.511939] sd 4:0:0:0: [sdd] Write Protect is off
[    1.511942] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.512020] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.513891] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.513963] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.514007] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.514053] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    1.560140]  sda: sda1 sda2 < sda5 >
[    1.560485] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.772093] Refined TSC clocksource calibration: 2994.403 MHz.
[    1.772100] Switching to clocksource tsc
[    1.935151]  sdb: sdb1
[    1.935414] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.083375]  sdc: sdc1
[    2.083618] sd 3:0:0:0: [sdc] Attached SCSI disk
[    2.111562]  sdd: sdd1
[    2.111810] sd 4:0:0:0: [sdd] Attached SCSI disk
[    2.429570] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   94=
51 PQ: 0 ANSI: 0
[    2.430066] sd 6:0:0:0: Attached scsi generic sg4 type 0
[    2.435678] sd 6:0:0:0: [sde] Attached SCSI removable disk
[    2.546679] md: md127 stopped.
[    2.547574] md: bind<sdb1>
[    2.616031] raid6: int64x1   1687 MB/s
[    2.684016] raid6: int64x2   2090 MB/s
[    2.752027] raid6: int64x4   2050 MB/s
[    2.820015] raid6: int64x8   1955 MB/s
[    2.888010] raid6: sse2x1    5571 MB/s
[    2.956010] raid6: sse2x2    8752 MB/s
[    3.024009] raid6: sse2x4   10515 MB/s
[    3.024011] raid6: using algorithm sse2x4 (10515 MB/s)
[    3.024191] async_tx: api initialized (async)
[    3.024379] xor: automatically using best checksumming function: generic=
_sse
[    3.044005]    generic_sse:  8649.000 MB/sec
[    3.044007] xor: using function: generic_sse (8649.000 MB/sec)
[    3.044903] md: raid6 personality registered for level 6
[    3.044906] md: raid5 personality registered for level 5
[    3.044908] md: raid4 personality registered for level 4
[    3.045107] bio: create slab <bio-1> at 1
[    3.045113] md/raid:md127: reshape will continue
[    3.045121] md/raid:md127: device sdb1 operational as raid disk 3
[    3.045387] md/raid:md127: allocated 4280kB
[    3.045417] md/raid:md127: not enough operational devices (3/4 failed)
[    3.045460] RAID conf printout:
[    3.045462]  --- level:5 rd:4 wd:1
[    3.045464]  disk 3, o:1, dev:sdb1
[    3.045629] md/raid:md127: failed to run raid set.
[    3.045661] md: pers->run() failed ...
[    3.045855] md: md127 stopped.
[    3.045862] md: unbind<sdb1>
[    3.056113] md: export_rdev(sdb1)
[    3.060604] device-mapper: uevent: version 1.0.3
[    3.060667] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[    3.139871] PM: Starting manual resume from disk
[    3.139874] PM: Hibernation image partition 8:5 present
[    3.139876] PM: Looking for hibernation image.
[    3.140109] PM: Image not found (code -22)
[    3.140111] PM: Hibernation image not present or could not be loaded.
[    3.190906] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    5.181278] udevd[384]: starting version 175
[    5.477475] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    5.477482] ACPI: Power Button [PWRB]
[    5.477529] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    5.477532] ACPI: Power Button [PWRF]
[    5.478177] ACPI: acpi_idle registered with cpuidle
[    5.560362] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.670487] wmi: Mapper loaded
[    5.755295] parport_pc 00:06: reported by Plug and Play ACPI
[    5.755340] parport0: PC-style at 0x378, irq 5 [PCSPP]
[    5.781374] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    5.900761] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, re=
vision 0
[    5.999029] [drm] Initialized drm 1.1.0 20060810
[    6.184881] powernow-k8: Found 1 AMD A4-4000 APU with Radeon(tm) HD Grap=
hics     (2 cpu cores) (version 2.20.00)
[    6.184891] powernow-k8: Core Performance Boosting: on.
[    6.184957] powernow-k8:    0 : pstate 0 (3000 MHz)
[    6.184959] powernow-k8:    1 : pstate 1 (2800 MHz)
[    6.184961] powernow-k8:    2 : pstate 2 (2500 MHz)
[    6.184963] powernow-k8:    3 : pstate 3 (2200 MHz)
[    6.184964] powernow-k8:    4 : pstate 4 (1800 MHz)
[    6.184966] powernow-k8:    5 : pstate 5 (1400 MHz)
[    6.281510] [drm] radeon defaulting to kernel modesetting.
[    6.281516] [drm] radeon kernel modesetting enabled.
[    6.286758] Error: Driver 'pcspkr' is already registered, aborting...
[    6.290989] [drm:radeon_pci_probe] *ERROR* radeon kernel modesetting for=
 R600 or later requires firmware-linux-nonfree.
[    6.423530] snd_hda_intel 0000:00:01.1: irq 43 for MSI/MSI-X
[    6.423564] snd_hda_intel 0000:00:01.1: setting latency timer to 64
[    6.966172] Too many HDMI devices
[    6.966177] Too many HDMI devices
[    6.966180] Too many HDMI devices
[    6.966182] Too many HDMI devices
[    6.966185] Too many HDMI devices
[    6.966187] Too many HDMI devices
[    6.966287] hda-codec: out of range cmd 0:0:ee5c:707:40
[    6.966328] hda-codec: out of range cmd 0:0:ee5c:708:eedc
[    6.966513] HDMI status: Codec=3D0 Pin=3D2 Presence_Detect=3D0 ELD_Valid=
=3D0
[    6.966538] hda-codec: out of range cmd 0:0:e0:f0d:0
[    6.966602] HDMI status: Codec=3D0 Pin=3D0 Presence_Detect=3D0 ELD_Valid=
=3D0
[    6.966653] HDMI status: Codec=3D0 Pin=3D0 Presence_Detect=3D0 ELD_Valid=
=3D0
[    6.966716] HDMI status: Codec=3D0 Pin=3D0 Presence_Detect=3D0 ELD_Valid=
=3D0
[    6.966784] hda-codec: out of range cmd 0:0:ee5c:f00:c
[    6.966822] hda-codec: out of range cmd 0:0:ee5c:709:0
[    6.966861] hda-codec: out of range cmd 0:0:ee5c:f09:0
[    6.966901] HDMI status: Codec=3D0 Pin=3D61020 Presence_Detect=3D1 ELD_V=
alid=3D1
[    6.966905] hda-codec: out of range cmd 0:0:ee5c:f2e:8
[    6.966944] hda-codec: out of range cmd 0:0:ee5c:709:0
[    6.966983] hda-codec: out of range cmd 0:0:ee5c:f09:0
[    6.967069] HDMI status: Codec=3D0 Pin=3D0 Presence_Detect=3D0 ELD_Valid=
=3D0
[    6.967169] HDMI status: Codec=3D0 Pin=3D0 Presence_Detect=3D0 ELD_Valid=
=3D0
[    6.967274] hda_codec: cannot build controls for #0 (error -16)
[    6.967314] hda_codec: cannot revert codec
[    6.967774] snd_hda_intel: probe of 0000:00:01.1 failed with error -16
[    7.029137] hda_codec: ALC887-VD: BIOS auto-probing.
[    7.037868] input: HD-Audio Generic Headphone as /devices/pci0000:00/000=
0:00:14.2/sound/card0/input3
[    7.970730] md: md127 stopped.
[    7.972291] md: bind<sdb1>
[    7.972391] md: md127 stopped.
[    7.972401] md: unbind<sdb1>
[    7.992114] md: export_rdev(sdb1)
[    8.288632] Adding 6719484k swap on /dev/sda5.  Priority:-1 extents:1 ac=
ross:6719484k=20
[    8.339997] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.770374] EXT4-fs (sda1): re-mounted. Opts: errors=3Dremount-ro
[    9.010754] loop: module loaded
[   10.106150] EXT4-fs (dm-0): mounted filesystem with ordered data mode. O=
pts: (null)
[   11.183705] RPC: Registered named UNIX socket transport module.
[   11.183711] RPC: Registered udp transport module.
[   11.183715] RPC: Registered tcp transport module.
[   11.183718] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   11.240311] FS-Cache: Loaded
[   11.287246] FS-Cache: Netfs 'nfs' registered for caching
[   11.299567] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   11.769648] r8169 0000:01:00.0: firmware: agent loaded rtl_nic/rtl8168e-=
3.fw into memory
[   11.897177] r8169 0000:01:00.0: eth0: link down
[   11.897190] r8169 0000:01:00.0: eth0: link down
[   11.898027] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.144933] r8169 0000:01:00.0: eth0: link up
[   14.145745] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  282.764071] md: md127 stopped.
[  282.766355] md: bind<sdb1>
[  282.766651] md: md127 stopped.
[  282.766662] md: unbind<sdb1>
[  282.780114] md: export_rdev(sdb1)
[  421.683615]  sdb: sdb1
[710556.443263] EXT4-fs (dm-0): mounted filesystem with ordered data mode. =
Opts: (null)
[711960.788119] INFO: task flush-253:0:10098 blocked for more than 120 seco=
nds.
[711960.788132] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[711960.788142] flush-253:0     D ffff880137e82ea0     0 10098      2 0x000=
00000
[711960.788151]  ffff880137e82ea0 0000000000000046 ffff880000000001 ffff880=
1399b87b0
[711960.788158]  0000000000013780 ffff88010eb3bfd8 ffff88010eb3bfd8 ffff880=
137e82ea0
[711960.788164]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[711960.788171] Call Trace:
[711960.788197]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[711960.788207]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[711960.788219]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[711960.788238]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[711960.788259]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[711960.788275]  [<ffffffffa016b227>] ? ext4_meta_trans_blocks+0x41/0x8e [e=
xt4]
[711960.788291]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[711960.788300]  [<ffffffff811183f3>] ? writeback_single_inode+0x11d/0x2cc
[711960.788307]  [<ffffffff81118873>] ? writeback_sb_inodes+0x16b/0x204
[711960.788313]  [<ffffffff81118979>] ? __writeback_inodes_wb+0x6d/0xab
[711960.788319]  [<ffffffff81118adf>] ? wb_writeback+0x128/0x21f
[711960.788325]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
[711960.788331]  [<ffffffff81118f96>] ? wb_do_writeback+0x146/0x1a8
[711960.788337]  [<ffffffff8111907d>] ? bdi_writeback_thread+0x85/0x1e6
[711960.788343]  [<ffffffff81118ff8>] ? wb_do_writeback+0x1a8/0x1a8
[711960.788349]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
[711960.788355]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
[711960.788361]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
[711960.788366]  [<ffffffff81356370>] ? gs_change+0x13/0x13
[711960.788371] INFO: task bacula-sd:10119 blocked for more than 120 second=
s.
[711960.788380] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[711960.788389] bacula-sd       D ffff88013ec13780     0 10119      1 0x000=
00000
[711960.788396]  ffff8801399b87b0 0000000000000082 ffff880100000000 fffffff=
f8160d020
[711960.788402]  0000000000013780 ffff880136c65fd8 ffff880136c65fd8 ffff880=
1399b87b0
[711960.788408]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[711960.788414] Call Trace:
[711960.788425]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[711960.788442]  [<ffffffffa016eabc>] ? ext4_mark_iloc_dirty+0x4a9/0x514 [e=
xt4]
[711960.788448]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[711960.788459]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[711960.788475]  [<ffffffffa016d8ce>] ? ext4_da_write_begin+0xd4/0x1be [ext=
4]
[711960.788495]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[711960.788513]  [<ffffffffa016d8ce>] ? ext4_da_write_begin+0xd4/0x1be [ext=
4]
[711960.788529]  [<ffffffffa016f7ac>] ? ext4_da_write_end+0x1f1/0x232 [ext4]
[711960.788536]  [<ffffffff810b4f8b>] ? generic_file_buffered_write+0x10f/0=
x259
[711960.788547]  [<ffffffff810b5dc8>] ? __generic_file_aio_write+0x248/0x278
[711960.788553]  [<ffffffff81036628>] ? should_resched+0x5/0x23
[711960.788559]  [<ffffffff810b5e55>] ? generic_file_aio_write+0x5d/0xb5
[711960.788573]  [<ffffffffa0168a1e>] ? ext4_file_write+0x2b/0x235 [ext4]
[711960.788587]  [<ffffffffa0168bd4>] ? ext4_file_write+0x1e1/0x235 [ext4]
[711960.788602]  [<ffffffffa01689ff>] ? ext4_file_write+0xc/0x235 [ext4]
[711960.788609]  [<ffffffff810fa054>] ? do_sync_write+0xb4/0xec
[711960.788615]  [<ffffffff81164649>] ? security_file_permission+0x16/0x2d
[711960.788620]  [<ffffffff810fa745>] ? vfs_write+0xa2/0xe9
[711960.788625]  [<ffffffff810fa922>] ? sys_write+0x45/0x6b
[711960.788630]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
[711960.788635] INFO: task resize2fs:10124 blocked for more than 120 second=
s.
[711960.788644] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[711960.788652] resize2fs       D ffff88013ec13780     0 10124   9269 0x000=
00000
[711960.788659]  ffff88013aac87b0 0000000000000086 ffffffff8134f247 fffffff=
f8160d020
[711960.788665]  0000000000013780 ffff88010aa1dfd8 ffff88010aa1dfd8 ffff880=
13aac87b0
[711960.788670]  0000000000000246 ffffffff8134f209 ffff88012e0fe8e0 ffff880=
12e0fe800
[711960.788676] Call Trace:
[711960.788682]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[711960.788687]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
[711960.788698]  [<ffffffffa0156930>] ? jbd2_journal_lock_updates+0xa5/0xda=
 [jbd2]
[711960.788705]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[711960.788722]  [<ffffffffa01719e4>] ? ext4_ioctl+0x66b/0x83d [ext4]
[711960.788727]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[711960.788734]  [<ffffffff8122a734>] ? n_tty_write+0x311/0x344
[711960.788740]  [<ffffffff810380d3>] ? set_next_entity+0x32/0x55
[711960.788746]  [<ffffffff81107b11>] ? do_vfs_ioctl+0x459/0x49a
[711960.788752]  [<ffffffff81039a88>] ? finish_task_switch+0x4e/0xb9
[711960.788757]  [<ffffffff8134de91>] ? __schedule+0x5f9/0x610
[711960.788762]  [<ffffffff81107b9d>] ? sys_ioctl+0x4b/0x72
[711960.788769]  [<ffffffff8100ee82>] ? math_state_restore+0x4b/0x55
[711960.788774]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
[712080.788119] INFO: task flush-253:0:10098 blocked for more than 120 seco=
nds.
[712080.788132] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712080.788142] flush-253:0     D ffff880137e82ea0     0 10098      2 0x000=
00000
[712080.788151]  ffff880137e82ea0 0000000000000046 ffff880000000001 ffff880=
1399b87b0
[712080.788158]  0000000000013780 ffff88010eb3bfd8 ffff88010eb3bfd8 ffff880=
137e82ea0
[712080.788164]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[712080.788171] Call Trace:
[712080.788196]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[712080.788207]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712080.788219]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[712080.788238]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[712080.788259]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[712080.788275]  [<ffffffffa016b227>] ? ext4_meta_trans_blocks+0x41/0x8e [e=
xt4]
[712080.788292]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[712080.788301]  [<ffffffff811183f3>] ? writeback_single_inode+0x11d/0x2cc
[712080.788307]  [<ffffffff81118873>] ? writeback_sb_inodes+0x16b/0x204
[712080.788313]  [<ffffffff81118979>] ? __writeback_inodes_wb+0x6d/0xab
[712080.788319]  [<ffffffff81118adf>] ? wb_writeback+0x128/0x21f
[712080.788325]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
[712080.788331]  [<ffffffff81118f96>] ? wb_do_writeback+0x146/0x1a8
[712080.788337]  [<ffffffff8111907d>] ? bdi_writeback_thread+0x85/0x1e6
[712080.788342]  [<ffffffff81118ff8>] ? wb_do_writeback+0x1a8/0x1a8
[712080.788348]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
[712080.788355]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
[712080.788361]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
[712080.788366]  [<ffffffff81356370>] ? gs_change+0x13/0x13
[712080.788371] INFO: task bacula-sd:10119 blocked for more than 120 second=
s.
[712080.788379] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712080.788388] bacula-sd       D ffff88013ec13780     0 10119      1 0x000=
00000
[712080.788395]  ffff8801399b87b0 0000000000000082 ffff880100000000 fffffff=
f8160d020
[712080.788401]  0000000000013780 ffff880136c65fd8 ffff880136c65fd8 ffff880=
1399b87b0
[712080.788407]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[712080.788413] Call Trace:
[712080.788424]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[712080.788440]  [<ffffffffa016eabc>] ? ext4_mark_iloc_dirty+0x4a9/0x514 [e=
xt4]
[712080.788447]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712080.788458]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[712080.788474]  [<ffffffffa016d8ce>] ? ext4_da_write_begin+0xd4/0x1be [ext=
4]
[712080.788493]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[712080.788510]  [<ffffffffa016d8ce>] ? ext4_da_write_begin+0xd4/0x1be [ext=
4]
[712080.788526]  [<ffffffffa016f7ac>] ? ext4_da_write_end+0x1f1/0x232 [ext4]
[712080.788534]  [<ffffffff810b4f8b>] ? generic_file_buffered_write+0x10f/0=
x259
[712080.788545]  [<ffffffff810b5dc8>] ? __generic_file_aio_write+0x248/0x278
[712080.788551]  [<ffffffff81036628>] ? should_resched+0x5/0x23
[712080.788556]  [<ffffffff810b5e55>] ? generic_file_aio_write+0x5d/0xb5
[712080.788571]  [<ffffffffa0168a1e>] ? ext4_file_write+0x2b/0x235 [ext4]
[712080.788586]  [<ffffffffa0168bd4>] ? ext4_file_write+0x1e1/0x235 [ext4]
[712080.788601]  [<ffffffffa01689ff>] ? ext4_file_write+0xc/0x235 [ext4]
[712080.788608]  [<ffffffff810fa054>] ? do_sync_write+0xb4/0xec
[712080.788615]  [<ffffffff81164649>] ? security_file_permission+0x16/0x2d
[712080.788621]  [<ffffffff810fa745>] ? vfs_write+0xa2/0xe9
[712080.788626]  [<ffffffff810fa922>] ? sys_write+0x45/0x6b
[712080.788632]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
[712080.788637] INFO: task resize2fs:10124 blocked for more than 120 second=
s.
[712080.788646] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712080.788655] resize2fs       D ffff88013ec13780     0 10124   9269 0x000=
00000
[712080.788662]  ffff88013aac87b0 0000000000000086 ffffffff8134f247 fffffff=
f8160d020
[712080.788668]  0000000000013780 ffff88010aa1dfd8 ffff88010aa1dfd8 ffff880=
13aac87b0
[712080.788674]  0000000000000246 ffffffff8134f209 ffff88012e0fe8e0 ffff880=
12e0fe800
[712080.788680] Call Trace:
[712080.788686]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[712080.788692]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
[712080.788703]  [<ffffffffa0156930>] ? jbd2_journal_lock_updates+0xa5/0xda=
 [jbd2]
[712080.788710]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712080.788727]  [<ffffffffa01719e4>] ? ext4_ioctl+0x66b/0x83d [ext4]
[712080.788733]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[712080.788740]  [<ffffffff8122a734>] ? n_tty_write+0x311/0x344
[712080.788746]  [<ffffffff810380d3>] ? set_next_entity+0x32/0x55
[712080.788752]  [<ffffffff81107b11>] ? do_vfs_ioctl+0x459/0x49a
[712080.788758]  [<ffffffff81039a88>] ? finish_task_switch+0x4e/0xb9
[712080.788763]  [<ffffffff8134de91>] ? __schedule+0x5f9/0x610
[712080.788768]  [<ffffffff81107b9d>] ? sys_ioctl+0x4b/0x72
[712080.788775]  [<ffffffff8100ee82>] ? math_state_restore+0x4b/0x55
[712080.788780]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
[712200.788118] INFO: task flush-253:0:10098 blocked for more than 120 seco=
nds.
[712200.788131] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712200.788144] flush-253:0     D ffff880137e82ea0     0 10098      2 0x000=
00000
[712200.788152]  ffff880137e82ea0 0000000000000046 ffff880000000001 ffff880=
1399b87b0
[712200.788160]  0000000000013780 ffff88010eb3bfd8 ffff88010eb3bfd8 ffff880=
137e82ea0
[712200.788166]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[712200.788173] Call Trace:
[712200.788199]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[712200.788209]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712200.788221]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[712200.788240]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[712200.788260]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[712200.788276]  [<ffffffffa016b227>] ? ext4_meta_trans_blocks+0x41/0x8e [e=
xt4]
[712200.788293]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[712200.788302]  [<ffffffff811183f3>] ? writeback_single_inode+0x11d/0x2cc
[712200.788308]  [<ffffffff81118873>] ? writeback_sb_inodes+0x16b/0x204
[712200.788314]  [<ffffffff81118979>] ? __writeback_inodes_wb+0x6d/0xab
[712200.788320]  [<ffffffff81118adf>] ? wb_writeback+0x128/0x21f
[712200.788326]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
[712200.788332]  [<ffffffff81118f96>] ? wb_do_writeback+0x146/0x1a8
[712200.788338]  [<ffffffff8111907d>] ? bdi_writeback_thread+0x85/0x1e6
[712200.788344]  [<ffffffff81118ff8>] ? wb_do_writeback+0x1a8/0x1a8
[712200.788350]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
[712200.788356]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
[712200.788363]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
[712200.788368]  [<ffffffff81356370>] ? gs_change+0x13/0x13
[712200.788373] INFO: task bacula-sd:10119 blocked for more than 120 second=
s.
[712200.788384] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712200.788398] bacula-sd       D ffff88013ec13780     0 10119      1 0x000=
00000
[712200.788405]  ffff8801399b87b0 0000000000000082 ffff880100000000 fffffff=
f8160d020
[712200.788412]  0000000000013780 ffff880136c65fd8 ffff880136c65fd8 ffff880=
1399b87b0
[712200.788418]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[712200.788424] Call Trace:
[712200.788435]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[712200.788451]  [<ffffffffa016eabc>] ? ext4_mark_iloc_dirty+0x4a9/0x514 [e=
xt4]
[712200.788458]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712200.788469]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[712200.788485]  [<ffffffffa016d8ce>] ? ext4_da_write_begin+0xd4/0x1be [ext=
4]
[712200.788505]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[712200.788522]  [<ffffffffa016d8ce>] ? ext4_da_write_begin+0xd4/0x1be [ext=
4]
[712200.788538]  [<ffffffffa016f7ac>] ? ext4_da_write_end+0x1f1/0x232 [ext4]
[712200.788546]  [<ffffffff810b4f8b>] ? generic_file_buffered_write+0x10f/0=
x259
[712200.788557]  [<ffffffff810b5dc8>] ? __generic_file_aio_write+0x248/0x278
[712200.788563]  [<ffffffff81036628>] ? should_resched+0x5/0x23
[712200.788569]  [<ffffffff810b5e55>] ? generic_file_aio_write+0x5d/0xb5
[712200.788583]  [<ffffffffa0168a1e>] ? ext4_file_write+0x2b/0x235 [ext4]
[712200.788598]  [<ffffffffa0168bd4>] ? ext4_file_write+0x1e1/0x235 [ext4]
[712200.788612]  [<ffffffffa01689ff>] ? ext4_file_write+0xc/0x235 [ext4]
[712200.788618]  [<ffffffff810fa054>] ? do_sync_write+0xb4/0xec
[712200.788625]  [<ffffffff81164649>] ? security_file_permission+0x16/0x2d
[712200.788630]  [<ffffffff810fa745>] ? vfs_write+0xa2/0xe9
[712200.788635]  [<ffffffff810fa922>] ? sys_write+0x45/0x6b
[712200.788641]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
[712200.788645] INFO: task resize2fs:10124 blocked for more than 120 second=
s.
[712200.788656] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712200.788671] resize2fs       D ffff88013ec13780     0 10124   9269 0x000=
00000
[712200.788677]  ffff88013aac87b0 0000000000000086 ffffffff8134f247 fffffff=
f8160d020
[712200.788683]  0000000000013780 ffff88010aa1dfd8 ffff88010aa1dfd8 ffff880=
13aac87b0
[712200.788689]  0000000000000246 ffffffff8134f209 ffff88012e0fe8e0 ffff880=
12e0fe800
[712200.788695] Call Trace:
[712200.788701]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[712200.788706]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
[712200.788717]  [<ffffffffa0156930>] ? jbd2_journal_lock_updates+0xa5/0xda=
 [jbd2]
[712200.788723]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712200.788740]  [<ffffffffa01719e4>] ? ext4_ioctl+0x66b/0x83d [ext4]
[712200.788746]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[712200.788752]  [<ffffffff8122a734>] ? n_tty_write+0x311/0x344
[712200.788758]  [<ffffffff810380d3>] ? set_next_entity+0x32/0x55
[712200.788765]  [<ffffffff81107b11>] ? do_vfs_ioctl+0x459/0x49a
[712200.788770]  [<ffffffff81039a88>] ? finish_task_switch+0x4e/0xb9
[712200.788775]  [<ffffffff8134de91>] ? __schedule+0x5f9/0x610
[712200.788781]  [<ffffffff81107b9d>] ? sys_ioctl+0x4b/0x72
[712200.788787]  [<ffffffff8100ee82>] ? math_state_restore+0x4b/0x55
[712200.788792]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
[712320.788119] INFO: task flush-253:0:10098 blocked for more than 120 seco=
nds.
[712320.788134] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
 this message.
[712320.788150] flush-253:0     D ffff880137e82ea0     0 10098      2 0x000=
00000
[712320.788158]  ffff880137e82ea0 0000000000000046 ffff880000000001 ffff880=
1399b87b0
[712320.788166]  0000000000013780 ffff88010eb3bfd8 ffff88010eb3bfd8 ffff880=
137e82ea0
[712320.788172]  0000000000000246 000000018134f209 ffff88012e0fe868 ffff880=
12e0fe800
[712320.788178] Call Trace:
[712320.788204]  [<ffffffffa0156235>] ? start_this_handle+0x16c/0x448 [jbd2]
[712320.788214]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
[712320.788226]  [<ffffffffa015679c>] ? jbd2__journal_start+0x8a/0xce [jbd2]
[712320.788245]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[712320.788266]  [<ffffffffa01856d8>] ? ext4_journal_start_sb+0x139/0x14f [=
ext4]
[712320.788282]  [<ffffffffa016b227>] ? ext4_meta_trans_blocks+0x41/0x8e [e=
xt4]
[712320.788299]  [<ffffffffa01700b7>] ? ext4_da_writepages+0x239/0x45d [ext=
4]
[712320.788308]  [<ffffffff811183f3>] ? writeback_single_inode+0x11d/0x2cc
[712320.788314]  [<ffffffff81118873>] ? writeback_sb_inodes+0x16b/0x204
[712320.788320]  [<ffffffff81118979>] ? __writeback_inodes_wb+0x6d/0xab
[712320.788326]  [<ffffffff81118adf>] ? wb_writeback+0x128/0x21f
[712320.788332]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
[712320.788338]  [<ffffffff81118f96>] ? wb_do_writeback+0x146/0x1a8
[712320.788344]  [<ffffffff8111907d>] ? bdi_writeback_thread+0x85/0x1e6
[712320.788349]  [<ffffffff81118ff8>] ? wb_do_writeback+0x1a8/0x1a8
[712320.788355]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
[712320.788361]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
[712320.788368]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
[712320.788373]  [<ffffffff81356370>] ? gs_change+0x13/0x13

--MP_/O1Sw4S.Ysl3sXUM0i3_VQb9--

--=_libri-12416-1382731601-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCgAGBQJSas9LAAoJEEzyshj1Ta49Fx4QAMDg/F85VdfFtzP5pXovMrU2
LEf2uZj5CyA1o5pof/Twhhdgpv6VnM1BgREpFBEkSlv5bSNz39Bj6Kw30gmTGiTs
h6bYYAiEmL6kzv0HmBoRT29h5zKxynBashNoGdM9Dv2+d3NW/yRNDTl9/oNzdVmi
NgHCkvpwmKP/E5bGRK0PKbHKtOspXm+QTMhdzLftzsHmJRWmCDNkxpKZydWUNKH/
jGcUe3wumMXHFSPoiKHyksn9lu2uGWQzdJCGvY36GN0WjY7QtS17inGnU2ujOYZ/
wz7E1daFojaLLiSZJDDTovwS4FctIFOvg5jWHsxz6uFRAyzHChhxv98KMtcv77Nx
+RoxW9zzAcBnxrL8eH8B3/ccFfEHXZm/utrOKeD/QeO9YO7OxBD08P42IKAfw61i
x9hTXJN/Mbcpb2nn7XEnCHSP91D5SuYZZ8ToYHVOMgz9H9SdwqC0FtWP5y+JsjQD
cauGm6FV/kHqIAEoryUAf1PHuMK6xlqtL23rRdYL01irGCBE1MA/WHpZ5CjW9us8
MrnZpq0vtgRdLz6eCkjaa7+VdFs0X8xEECYMtyKYCLp1abbXdZvM8OxNEnTd8aXP
rNCihyLiiO+77/A5coYrAAuYffVzPq+0UllQ86TPRFk2tVel2OfjF8l0df6xp4Y7
arqLMn9nQoPr/N+Bb5MR
=Eby+
-----END PGP SIGNATURE-----

--=_libri-12416-1382731601-0001-2--
