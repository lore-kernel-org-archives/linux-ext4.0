From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: corruption on 3.1.0-rc9-next-20111011+
Date: Mon, 17 Oct 2011 09:57:00 +0300
Message-ID: <20111017065700.GO18470@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37552 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1JQHAH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 03:00:07 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id p9H703JJ000729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 07:00:05 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id p9H6q2jx026696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 06:52:03 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id p9H6xvks024616
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 01:59:57 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

I hit a sanity check in ext4_ext_insert_index() and my filesystem
went read only.

[187987.257628] EXT4-fs error (device md0): ext4_ext_insert_index:783: inode #1047511: comm flush-9:0: ix > EXT_LAST_INDEX!
[187987.257635] Aborting journal on device md0-8.
[187987.257887] EXT4-fs (md0): Remounting filesystem read-only
[187987.257892] EXT4-fs error (device md0) in ext4_free_blocks:4750: Journal has aborted
[187987.258101] EXT4-fs error (device md0) in ext4_free_blocks:4750:Journal has aborted
[187987.258387] EXT4-fs (md0): ext4_da_writepages: jbd2_start: 1024 pages, ino 1047511; err -30
[274435.321954] EXT4-fs (md0): error count: 3
[274435.321958] EXT4-fs (md0): initial error at 1318599257: ext4_ext_insert_index:783: inode 1047511
[274435.321962] EXT4-fs (md0): last error at 1318599257: ext4_free_blocks:4750: inode 1047511
[360839.012173] EXT4-fs (md0): error count: 3
[360839.012177] EXT4-fs (md0): initial error at 1318599257: ext4_ext_insert_index:783: inode 1047511
[360839.012181] EXT4-fs (md0): last error at 1318599257: ext4_free_blocks:4750: inode 1047511
[387258.434490] flush-9:1 used greatest stack depth: 3152 bytes left

The computer was basically sitting idle when I hit the bug.  I'm on a
software RAID1 array and there weren't any warnings about drive
problems.

Reboot 1) After I rebooted, I had to run fsck -y /dev/md0 and reboot
          again.
Reboot 2) When I rebooted the second time I hit the check again
          during boot (I'll include that dmesg at the end).
Reboot 3) After that, I booted to 2.6.39-2-amd64 and was able to boot
          successfully.
Reboot 4) So then I rebooted back to 3.1.0-rc9-next-20111011+ and
          that boot succeeded as well.

regards,
dan carpenter

Here is the dmesg from the Reboot #2 that failed.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-rc9-next-20111011+ (dcarpenter@elgon) (gcc version 4.6.1 (Debian 4.6.1-4) ) #134 SMP Wed Oct 12 05:37:51 EAT 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc9-next-20111011+ root=UUID=5c13a945-614f-46f7-911a-0d57afbec863 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
[    0.000000]  BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cef76000 (usable)
[    0.000000]  BIOS-e820: 00000000cef76000 - 00000000cefd1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cefd1000 - 00000000cf358000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf358000 - 00000000cf35b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf35b000 - 00000000cf5a1000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf5a1000 - 00000000cf5b2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5b2000 - 00000000cf5c9000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf5c9000 - 00000000cf5cb000 (usable)
[    0.000000]  BIOS-e820: 00000000cf5cb000 - 00000000cf5cc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5cc000 - 00000000cf5d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf5d4000 - 00000000cf5de000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf5de000 - 00000000cf63a000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf63a000 - 00000000cf67d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf67d000 - 00000000cf800000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000042f800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/P8Z68-V PRO, BIOS 0501 05/09/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x42f800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FC0000000 write-back
[    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 base 42F800000 mask FFF800000 uncachable
[    0.000000]   5 base 430000000 mask FF0000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcee0] fcee0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cf800000
[    0.000000]  0000000000 - 00cf800000 page 2M
[    0.000000] kernel direct mapping tables up to cf800000 @ cf7fd000-cf800000
[    0.000000] init_memory_mapping: 0000000100000000-000000042f800000
[    0.000000]  0100000000 - 042f800000 page 2M
[    0.000000] kernel direct mapping tables up to 42f800000 @ 42f7f3000-42f800000
[    0.000000] RAMDISK: 37494000 - 37a42000
[    0.000000] ACPI: RSDP 00000000000f0420 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000cefc6068 0004C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000cefd0318 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000cefc6140 0A1D6 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cf5d5f80 00040
[    0.000000] ACPI: APIC 00000000cefd0410 00092 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000cefd04a8 001D6 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000cefd0680 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cefd06c0 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000042f800000
[    0.000000] Initmem setup node 0 0000000000000000-000000042f800000
[    0.000000]   NODE_DATA [000000042f7ee000 - 000000042f7f2fff]
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041ee00000-ffff88042edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0042f800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000cef76
[    0.000000]     0: 0x000cf5c9 -> 0x000cf5cb
[    0.000000]     0: 0x000cf67d -> 0x000cf800
[    0.000000]     0: 0x00100000 -> 0x0042f800
[    0.000000] On node 0 totalpages: 4188294
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 827707 pages, LIFO batch:31
[    0.000000]   Normal zone: 52192 pages used for memmap
[    0.000000]   Normal zone: 3288096 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cef76000 - 00000000cefd1000
[    0.000000] PM: Registered nosave memory: 00000000cefd1000 - 00000000cf358000
[    0.000000] PM: Registered nosave memory: 00000000cf358000 - 00000000cf35b000
[    0.000000] PM: Registered nosave memory: 00000000cf35b000 - 00000000cf5a1000
[    0.000000] PM: Registered nosave memory: 00000000cf5a1000 - 00000000cf5b2000
[    0.000000] PM: Registered nosave memory: 00000000cf5b2000 - 00000000cf5c9000
[    0.000000] PM: Registered nosave memory: 00000000cf5cb000 - 00000000cf5cc000
[    0.000000] PM: Registered nosave memory: 00000000cf5cc000 - 00000000cf5d4000
[    0.000000] PM: Registered nosave memory: 00000000cf5d4000 - 00000000cf5de000
[    0.000000] PM: Registered nosave memory: 00000000cf5de000 - 00000000cf63a000
[    0.000000] PM: Registered nosave memory: 00000000cf63a000 - 00000000cf67d000
[    0.000000] PM: Registered nosave memory: 00000000cf800000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cf800000 (gap: cf800000:2f51c000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88042f400000 s76032 r8192 d22272 u262144
[    0.000000] pcpu-alloc: s76032 r8192 d22272 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4119713
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-rc9-next-20111011+ root=UUID=5c13a945-614f-46f7-911a-0d57afbec863 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16403536k/17555456k available (7247k kernel code, 802280k absent, 349640k reserved, 5652k data, 644k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 3502.686 MHz processor.
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 7005.37 BogoMIPS (lpj=3502686)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000015] Security Framework initialized
[    0.000870] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.003197] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.004147] Mount-cache hash table entries: 256
[    0.004214] Initializing cgroup subsys cpuacct
[    0.004217] Initializing cgroup subsys freezer
[    0.004232] CPU: Physical Processor ID: 0
[    0.004233] CPU: Processor Core ID: 0
[    0.004235] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.004236] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.004238] mce: CPU supports 9 MCE banks
[    0.004247] CPU0: Thermal monitoring enabled (TM1)
[    0.004251] using mwait in idle threads.
[    0.004304] ACPI: Core revision 20110623
[    0.108011] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.118001] CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz stepping 07
[    0.219125] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.219129] ... version:                3
[    0.219130] ... bit width:              48
[    0.219131] ... generic registers:      4
[    0.219131] ... value mask:             0000ffffffffffff
[    0.219132] ... max period:             000000007fffffff
[    0.219133] ... fixed-purpose events:   3
[    0.219134] ... event mask:             000000070000000f
[    0.219217] Booting Node   0, Processors  #1
[    0.219218] smpboot cpu 1: start_ip = 96000
[    0.310137]  #2
[    0.310138] smpboot cpu 2: start_ip = 96000
[    0.401059]  #3
[    0.401060] smpboot cpu 3: start_ip = 96000
[    0.491878]  #4
[    0.491879] smpboot cpu 4: start_ip = 96000
[    0.582738]  #5
[    0.582739] smpboot cpu 5: start_ip = 96000
[    0.673660]  #6
[    0.673661] smpboot cpu 6: start_ip = 96000
[    0.764583]  #7 Ok.
[    0.764584] smpboot cpu 7: start_ip = 96000
[    0.855368] Brought up 8 CPUs
[    0.855370] Total of 8 processors activated (56037.42 BogoMIPS).
[    0.858647] devtmpfs: initialized
[    0.858719] PM: Registering ACPI NVS region at cef76000 (372736 bytes)
[    0.858723] PM: Registering ACPI NVS region at cf358000 (12288 bytes)
[    0.858724] PM: Registering ACPI NVS region at cf5a1000 (69632 bytes)
[    0.858727] PM: Registering ACPI NVS region at cf5cb000 (4096 bytes)
[    0.858728] PM: Registering ACPI NVS region at cf5d4000 (40960 bytes)
[    0.858729] PM: Registering ACPI NVS region at cf63a000 (274432 bytes)
[    0.858787] RTC time:  6:04:03, date: 10/17/11
[    0.858805] NET: Registered protocol family 16
[    0.858843] kworker/u:0 used greatest stack depth: 6536 bytes left
[    0.858987] kworker/u:0 used greatest stack depth: 6368 bytes left
[    0.858996] ACPI: bus type pci registered
[    0.859044] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.859046] PCI: not using MMCONFIG
[    0.859047] PCI: Using configuration type 1 for base access
[    0.859154] kworker/u:0 used greatest stack depth: 5600 bytes left
[    0.862777] bio: create slab <bio-0> at 0
[    0.862829] ACPI: Added _OSI(Module Device)
[    0.862830] ACPI: Added _OSI(Processor Device)
[    0.862831] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.862832] ACPI: Added _OSI(Processor Aggregator Device)
[    0.863536] ACPI: EC: Look up EC in DSDT
[    0.864192] ACPI: Executed 1 blocks of module-level executable AML code
[    0.865569] ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    0.865572] ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110623/nsinit-349)
[    0.865736] ACPI: SSDT 00000000cf5d4818 0079C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.865982] ACPI: Dynamic OEM Table Load:
[    0.865984] ACPI: SSDT           (null) 0079C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.866009] ACPI: SSDT 00000000cf5dba18 0021C (v01    AMI      CST 00000001 MSFT 03000001)
[    0.866201] ACPI: Dynamic OEM Table Load:
[    0.866203] ACPI: SSDT           (null) 0021C (v01    AMI      CST 00000001 MSFT 03000001)
[    0.866662] ACPI: Interpreter enabled
[    0.866664] ACPI: (supports S0 S1 S3 S4 S5)
[    0.866676] ACPI: Using IOAPIC for interrupt routing
[    0.866689] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.866721] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.876384] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.878388] kworker/u:0 used greatest stack depth: 5592 bytes left
[    0.880301] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.880410] ACPI: No dock devices found.
[    0.880412] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.880514] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.880641] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.880642] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.880644] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.880645] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000dffff]
[    0.880646] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xffffffff]
[    0.880649] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cf3ff])
[    0.880655] pci 0000:00:00.0: [8086:0100] type 0 class 0x000600
[    0.880678] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.880694] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.880696] pci 0000:00:01.0: PME# disabled
[    0.880732] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.880752] pci 0000:00:16.0: reg 10: [mem 0xfe729000-0xfe72900f 64bit]
[    0.880807] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.880811] pci 0000:00:16.0: PME# disabled
[    0.880836] pci 0000:00:19.0: [8086:1503] type 0 class 0x000200
[    0.880851] pci 0000:00:19.0: reg 10: [mem 0xfe700000-0xfe71ffff]
[    0.880858] pci 0000:00:19.0: reg 14: [mem 0xfe728000-0xfe728fff]
[    0.880866] pci 0000:00:19.0: reg 18: [io  0xf040-0xf05f]
[    0.880910] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.880913] pci 0000:00:19.0: PME# disabled
[    0.880933] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.880952] pci 0000:00:1a.0: reg 10: [mem 0xfe727000-0xfe7273ff]
[    0.881017] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.881021] pci 0000:00:1a.0: PME# disabled
[    0.881042] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.881055] pci 0000:00:1b.0: reg 10: [mem 0xfe720000-0xfe723fff 64bit]
[    0.881103] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.881106] pci 0000:00:1b.0: PME# disabled
[    0.881124] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.881179] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.881183] pci 0000:00:1c.0: PME# disabled
[    0.881203] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    0.881258] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.881264] pci 0000:00:1c.1: PME# disabled
[    0.881284] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    0.881340] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.881343] pci 0000:00:1c.2: PME# disabled
[    0.881364] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    0.881420] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.881422] pci 0000:00:1c.3: PME# disabled
[    0.881442] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    0.881498] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.881501] pci 0000:00:1c.4: PME# disabled
[    0.881522] pci 0000:00:1c.6: [8086:244e] type 1 class 0x000604
[    0.881577] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.881580] pci 0000:00:1c.6: PME# disabled
[    0.881600] pci 0000:00:1c.7: [8086:1c1e] type 1 class 0x000604
[    0.881656] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.881659] pci 0000:00:1c.7: PME# disabled
[    0.881683] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.881702] pci 0000:00:1d.0: reg 10: [mem 0xfe726000-0xfe7263ff]
[    0.881767] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.881771] pci 0000:00:1d.0: PME# disabled
[    0.881791] pci 0000:00:1f.0: [8086:1c44] type 0 class 0x000601
[    0.881894] pci 0000:00:1f.2: [8086:1c02] type 0 class 0x000106
[    0.881910] pci 0000:00:1f.2: reg 10: [io  0xf090-0xf097]
[    0.881917] pci 0000:00:1f.2: reg 14: [io  0xf080-0xf083]
[    0.881924] pci 0000:00:1f.2: reg 18: [io  0xf070-0xf077]
[    0.881930] pci 0000:00:1f.2: reg 1c: [io  0xf060-0xf063]
[    0.881937] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.881944] pci 0000:00:1f.2: reg 24: [mem 0xfe725000-0xfe7257ff]
[    0.881972] pci 0000:00:1f.2: PME# supported from D3hot
[    0.881975] pci 0000:00:1f.2: PME# disabled
[    0.881988] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.882001] pci 0000:00:1f.3: reg 10: [mem 0xfe724000-0xfe7240ff 64bit]
[    0.882020] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.882062] pci 0000:01:00.0: [1002:9490] type 0 class 0x000300
[    0.882072] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.882079] pci 0000:01:00.0: reg 18: [mem 0xfe620000-0xfe62ffff 64bit]
[    0.882085] pci 0000:01:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.882094] pci 0000:01:00.0: reg 30: [mem 0xfe600000-0xfe61ffff pref]
[    0.882107] pci 0000:01:00.0: supports D1 D2
[    0.882121] pci 0000:01:00.1: [1002:aa38] type 0 class 0x000403
[    0.882131] pci 0000:01:00.1: reg 10: [mem 0xfe630000-0xfe633fff 64bit]
[    0.882164] pci 0000:01:00.1: supports D1 D2
[    0.883269] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.883272] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.883276] pci 0000:00:01.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.883281] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.883347] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.883430] pci 0000:03:00.0: [1b21:1042] type 0 class 0x000c03
[    0.883457] pci 0000:03:00.0: reg 10: [mem 0xfe500000-0xfe507fff 64bit]
[    0.883575] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.883580] pci 0000:03:00.0: PME# disabled
[    0.885273] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.885281] pci 0000:00:1c.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.885361] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.885428] pci 0000:05:00.0: [197b:2362] type 0 class 0x000101
[    0.885461] pci 0000:05:00.0: reg 10: [io  0xd040-0xd047]
[    0.885476] pci 0000:05:00.0: reg 14: [io  0xd030-0xd033]
[    0.885492] pci 0000:05:00.0: reg 18: [io  0xd020-0xd027]
[    0.885507] pci 0000:05:00.0: reg 1c: [io  0xd010-0xd013]
[    0.885522] pci 0000:05:00.0: reg 20: [io  0xd000-0xd00f]
[    0.885537] pci 0000:05:00.0: reg 24: [mem 0xfe410000-0xfe4101ff]
[    0.885553] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.885588] pci 0000:05:00.0: PME# supported from D3hot
[    0.885594] pci 0000:05:00.0: PME# disabled
[    0.887270] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.887275] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.887281] pci 0000:00:1c.3:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.887385] pci 0000:06:00.0: [1b21:1042] type 0 class 0x000c03
[    0.887412] pci 0000:06:00.0: reg 10: [mem 0xfe300000-0xfe307fff 64bit]
[    0.887530] pci 0000:06:00.0: PME# supported from D3hot D3cold
[    0.887535] pci 0000:06:00.0: PME# disabled
[    0.889267] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.889276] pci 0000:00:1c.4:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.889367] pci 0000:07:00.0: [1b21:1080] type 1 class 0x000604
[    0.889468] pci 0000:00:1c.6: PCI bridge to [bus 07-08] (subtractive decode)
[    0.889471] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.889475] pci 0000:00:1c.6:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.889480] pci 0000:00:1c.6:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.889482] pci 0000:00:1c.6:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.889483] pci 0000:00:1c.6:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.889484] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xffffffff] (subtractive decode)
[    0.889551] pci 0000:08:01.0: [8086:1010] type 0 class 0x000200
[    0.889594] pci 0000:08:01.0: reg 10: [mem 0xfe220000-0xfe23ffff 64bit]
[    0.889642] pci 0000:08:01.0: reg 20: [io  0xc0c0-0xc0ff]
[    0.889716] pci 0000:08:01.0: PME# supported from D0 D3hot D3cold
[    0.889722] pci 0000:08:01.0: PME# disabled
[    0.889766] pci 0000:08:01.1: [8086:1010] type 0 class 0x000200
[    0.889809] pci 0000:08:01.1: reg 10: [mem 0xfe200000-0xfe21ffff 64bit]
[    0.889856] pci 0000:08:01.1: reg 20: [io  0xc080-0xc0bf]
[    0.889930] pci 0000:08:01.1: PME# supported from D0 D3hot D3cold
[    0.889936] pci 0000:08:01.1: PME# disabled
[    0.889986] pci 0000:08:02.0: [1106:3044] type 0 class 0x000c00
[    0.890016] pci 0000:08:02.0: reg 10: [mem 0xfe240000-0xfe2407ff]
[    0.890033] pci 0000:08:02.0: reg 14: [io  0xc000-0xc07f]
[    0.890143] pci 0000:08:02.0: supports D2
[    0.890144] pci 0000:08:02.0: PME# supported from D2 D3hot D3cold
[    0.890150] pci 0000:08:02.0: PME# disabled
[    0.890223] pci 0000:07:00.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.890233] pci 0000:07:00.0:   bridge window [io  0xc000-0xcfff]
[    0.890238] pci 0000:07:00.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.890249] pci 0000:07:00.0:   bridge window [io  0xc000-0xcfff] (subtractive decode)
[    0.890250] pci 0000:07:00.0:   bridge window [mem 0xfe200000-0xfe2fffff] (subtractive decode)
[    0.890252] pci 0000:07:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.890253] pci 0000:07:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.890254] pci 0000:07:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.890255] pci 0000:07:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.890257] pci 0000:07:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.890258] pci 0000:07:00.0:   bridge window [mem 0xd0000000-0xffffffff] (subtractive decode)
[    0.890325] pci 0000:09:00.0: [1b4b:9172] type 0 class 0x000106
[    0.890342] pci 0000:09:00.0: reg 10: [io  0xb040-0xb047]
[    0.890353] pci 0000:09:00.0: reg 14: [io  0xb030-0xb033]
[    0.890365] pci 0000:09:00.0: reg 18: [io  0xb020-0xb027]
[    0.890377] pci 0000:09:00.0: reg 1c: [io  0xb010-0xb013]
[    0.890389] pci 0000:09:00.0: reg 20: [io  0xb000-0xb00f]
[    0.890401] pci 0000:09:00.0: reg 24: [mem 0xfe110000-0xfe1101ff]
[    0.890413] pci 0000:09:00.0: reg 30: [mem 0xfe100000-0xfe10ffff pref]
[    0.890446] pci 0000:09:00.0: PME# supported from D3hot
[    0.890450] pci 0000:09:00.0: PME# disabled
[    0.892262] pci 0000:00:1c.7: PCI bridge to [bus 09-09]
[    0.892267] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.892272] pci 0000:00:1c.7:   bridge window [mem 0xfe100000-0xfe1fffff]
[    0.892327] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.892394] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.892409] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.892422] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.892435] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.892448] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.892470] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.892484] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.892498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6.BR24._PRT]
[    0.892523] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7._PRT]
[    0.892586]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.892695]  pci0000:00: ACPI _OSC control (0x1c) granted
[    0.895419] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.895445] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.895470] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.895494] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.895518] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.895542] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.895566] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.895591] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.895675] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.895678] vgaarb: loaded
[    0.895679] vgaarb: bridge control possible 0000:01:00.0
[    0.895741] SCSI subsystem initialized
[    0.895788] libata version 3.00 loaded.
[    0.895873] usbcore: registered new interface driver usbfs
[    0.895891] usbcore: registered new interface driver hub
[    0.895911] usbcore: registered new device driver usb
[    0.896019] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.896020] PCI: Using ACPI for IRQ routing
[    0.897303] PCI: pci_cache_line_size set to 64 bytes
[    0.897393] reserve RAM buffer: 000000000009b400 - 000000000009ffff 
[    0.897394] reserve RAM buffer: 00000000cef76000 - 00000000cfffffff 
[    0.897397] reserve RAM buffer: 00000000cf5cb000 - 00000000cfffffff 
[    0.897398] reserve RAM buffer: 00000000cf800000 - 00000000cfffffff 
[    0.897399] reserve RAM buffer: 000000042f800000 - 000000042fffffff 
[    0.897531] cfg80211: Calling CRDA to update world regulatory domain
[    0.897613] NetLabel: Initializing
[    0.897615] NetLabel:  domain hash size = 128
[    0.897615] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.897628] NetLabel:  unlabeled traffic allowed by default
[    0.897683] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.897686] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.900700] Switching to clocksource hpet
[    0.901904] pnp: PnP ACPI init
[    0.901909] ACPI: bus type pnp registered
[    0.901985] pnp 00:00: [bus 00-ff]
[    0.901986] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.901987] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.901988] pnp 00:00: [io  0x0d00-0xffff window]
[    0.901989] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.901991] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.901992] pnp 00:00: [mem 0xd0000000-0xffffffff window]
[    0.901993] pnp 00:00: [mem 0x00000000 window]
[    0.902038] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.902069] pnp 00:01: [mem 0xfed10000-0xfed19fff]
[    0.902070] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    0.902071] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.902072] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.902073] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.902116] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.902118] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.902119] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.902120] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.902122] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.902123] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.902159] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.902160] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.902161] pnp 00:02: [io  0x0290-0x029f]
[    0.902162] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.902200] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.902202] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.902209] pnp 00:03: [dma 4]
[    0.902210] pnp 00:03: [io  0x0000-0x000f]
[    0.902211] pnp 00:03: [io  0x0081-0x0083]
[    0.902212] pnp 00:03: [io  0x0087]
[    0.902213] pnp 00:03: [io  0x0089-0x008b]
[    0.902214] pnp 00:03: [io  0x008f]
[    0.902215] pnp 00:03: [io  0x00c0-0x00df]
[    0.902243] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.902249] pnp 00:04: [io  0x0070-0x0071]
[    0.902255] pnp 00:04: [irq 8]
[    0.902282] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.902287] pnp 00:05: [io  0x0061]
[    0.902314] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.902323] pnp 00:06: [io  0x0010-0x001f]
[    0.902324] pnp 00:06: [io  0x0022-0x003f]
[    0.902325] pnp 00:06: [io  0x0044-0x005f]
[    0.902326] pnp 00:06: [io  0x0063]
[    0.902327] pnp 00:06: [io  0x0065]
[    0.902328] pnp 00:06: [io  0x0067-0x006f]
[    0.902329] pnp 00:06: [io  0x0072-0x007f]
[    0.902330] pnp 00:06: [io  0x0080]
[    0.902331] pnp 00:06: [io  0x0084-0x0086]
[    0.902331] pnp 00:06: [io  0x0088]
[    0.902332] pnp 00:06: [io  0x008c-0x008e]
[    0.902333] pnp 00:06: [io  0x0090-0x009f]
[    0.902334] pnp 00:06: [io  0x00a2-0x00bf]
[    0.902335] pnp 00:06: [io  0x00e0-0x00ef]
[    0.902337] pnp 00:06: [io  0x04d0-0x04d1]
[    0.902380] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.902382] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.902387] pnp 00:07: [io  0x00f0-0x00ff]
[    0.902391] pnp 00:07: [irq 13]
[    0.902419] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.902568] pnp 00:08: [io  0x0400-0x0453]
[    0.902569] pnp 00:08: [io  0x0458-0x047f]
[    0.902570] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.902571] pnp 00:08: [io  0x0500-0x057f]
[    0.902572] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.902573] pnp 00:08: [mem 0xfec00000-0xfecfffff]
[    0.902574] pnp 00:08: [mem 0xfed08000-0xfed08fff]
[    0.902575] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.902616] system 00:08: [io  0x0400-0x0453] has been reserved
[    0.902618] system 00:08: [io  0x0458-0x047f] has been reserved
[    0.902619] system 00:08: [io  0x0500-0x057f] has been reserved
[    0.902622] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.902624] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.902625] system 00:08: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.902627] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.902628] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.902648] pnp 00:09: [io  0x0454-0x0457]
[    0.902687] system 00:09: [io  0x0454-0x0457] has been reserved
[    0.902689] system 00:09: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.902754] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.902800] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.902884] pnp: PnP ACPI: found 11 devices
[    0.902885] ACPI: ACPI bus type pnp unregistered
[    0.909890] PCI: max bus depth: 2 pci_try_num: 3
[    0.909954] pci 0000:00:1c.3: BAR 15: assigned [mem 0xe4000000-0xe40fffff pref]
[    0.909956] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.909958] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.909959] pci 0000:00:01.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.909961] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.909964] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.909974] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.909978] pci 0000:00:1c.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.909985] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.909996] pci 0000:05:00.0: BAR 6: assigned [mem 0xe4000000-0xe400ffff pref]
[    0.909997] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.909999] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.910004] pci 0000:00:1c.3:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.910007] pci 0000:00:1c.3:   bridge window [mem 0xe4000000-0xe40fffff pref]
[    0.910012] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.910017] pci 0000:00:1c.4:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.910024] pci 0000:07:00.0: PCI bridge to [bus 08-08]
[    0.910028] pci 0000:07:00.0:   bridge window [io  0xc000-0xcfff]
[    0.910035] pci 0000:07:00.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.910048] pci 0000:00:1c.6: PCI bridge to [bus 07-08]
[    0.910050] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.910054] pci 0000:00:1c.6:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.910062] pci 0000:00:1c.7: PCI bridge to [bus 09-09]
[    0.910064] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.910069] pci 0000:00:1c.7:   bridge window [mem 0xfe100000-0xfe1fffff]
[    0.910082] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.910084] pci 0000:00:01.0: setting latency timer to 64
[    0.910091] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.910094] pci 0000:00:1c.0: setting latency timer to 64
[    0.910100] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.910103] pci 0000:00:1c.1: setting latency timer to 64
[    0.910110] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.910113] pci 0000:00:1c.2: setting latency timer to 64
[    0.910120] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.910123] pci 0000:00:1c.3: setting latency timer to 64
[    0.910128] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.910132] pci 0000:00:1c.4: setting latency timer to 64
[    0.910137] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.910139] pci 0000:00:1c.6: setting latency timer to 64
[    0.910145] pci 0000:07:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.910150] pci 0000:07:00.0: setting latency timer to 64
[    0.910156] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.910160] pci 0000:00:1c.7: setting latency timer to 64
[    0.910163] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.910164] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.910165] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.910166] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xffffffff]
[    0.910167] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.910169] pci_bus 0000:01: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.910170] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.910171] pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.910172] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.910174] pci_bus 0000:05: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.910175] pci_bus 0000:05: resource 2 [mem 0xe4000000-0xe40fffff pref]
[    0.910176] pci_bus 0000:06: resource 1 [mem 0xfe300000-0xfe3fffff]
[    0.910177] pci_bus 0000:07: resource 0 [io  0xc000-0xcfff]
[    0.910178] pci_bus 0000:07: resource 1 [mem 0xfe200000-0xfe2fffff]
[    0.910179] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.910180] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.910182] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.910183] pci_bus 0000:07: resource 7 [mem 0xd0000000-0xffffffff]
[    0.910184] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.910185] pci_bus 0000:08: resource 1 [mem 0xfe200000-0xfe2fffff]
[    0.910186] pci_bus 0000:08: resource 4 [io  0xc000-0xcfff]
[    0.910187] pci_bus 0000:08: resource 5 [mem 0xfe200000-0xfe2fffff]
[    0.910188] pci_bus 0000:08: resource 8 [io  0x0000-0x0cf7]
[    0.910190] pci_bus 0000:08: resource 9 [io  0x0d00-0xffff]
[    0.910191] pci_bus 0000:08: resource 10 [mem 0x000a0000-0x000bffff]
[    0.910192] pci_bus 0000:08: resource 11 [mem 0xd0000000-0xffffffff]
[    0.910193] pci_bus 0000:09: resource 0 [io  0xb000-0xbfff]
[    0.910194] pci_bus 0000:09: resource 1 [mem 0xfe100000-0xfe1fffff]
[    0.910211] NET: Registered protocol family 2
[    0.910452] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.911129] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.911987] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.912082] TCP: Hash tables configured (established 524288 bind 65536)
[    0.912083] TCP reno registered
[    0.912099] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.912143] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.912214] NET: Registered protocol family 1
[    0.912273] RPC: Registered named UNIX socket transport module.
[    0.912274] RPC: Registered udp transport module.
[    0.912275] RPC: Registered tcp transport module.
[    0.912276] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.912306] pci 0000:00:1a.0: EHCI: BIOS handoff
[    1.035700] pci 0000:00:1d.0: EHCI: BIOS handoff
[    1.158501] pci 0000:01:00.0: Boot video device
[    1.158619] PCI: CLS 64 bytes, default 64
[    1.158648] Trying to unpack rootfs image as initramfs...
[    1.226439] Freeing initrd memory: 5816k freed
[    1.226875] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.226877] Placing 64MB software IO TLB between ffff8800caf76000 - ffff8800cef76000
[    1.226878] software IO TLB at phys 0xcaf76000 - 0xcef76000
[    1.228708] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x14
[    1.228712] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x14
[    1.228717] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x14
[    1.228722] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x14
[    1.228726] microcode: CPU4 sig=0x206a7, pf=0x2, revision=0x14
[    1.228731] microcode: CPU5 sig=0x206a7, pf=0x2, revision=0x14
[    1.228735] microcode: CPU6 sig=0x206a7, pf=0x2, revision=0x14
[    1.228739] microcode: CPU7 sig=0x206a7, pf=0x2, revision=0x14
[    1.228773] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.228933] audit: initializing netlink socket (disabled)
[    1.228939] type=2000 audit(1318831442.892:1): initialized
[    1.255750] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.257886] VFS: Disk quotas dquot_6.5.2
[    1.257934] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.258536] msgmni has been set to 32049
[    1.258781] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.258783] io scheduler noop registered
[    1.258784] io scheduler deadline registered
[    1.258816] io scheduler cfq registered (default)
[    1.258878] pcieport 0000:00:01.0: setting latency timer to 64
[    1.258895] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    1.258962] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.258998] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    1.259065] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.259100] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    1.259166] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.259202] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    1.259269] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.259304] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    1.259385] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.259421] pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
[    1.259488] pcieport 0000:00:1c.7: setting latency timer to 64
[    1.259524] pcieport 0000:00:1c.7: irq 46 for MSI/MSI-X
[    1.259650] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.259776] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.259779] ACPI: Power Button [PWRB]
[    1.259817] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.259819] ACPI: Power Button [PWRF]
[    1.259923] ACPI: acpi_idle registered with cpuidle
[    1.260038] Monitor-Mwait will be used to enter C-1 state
[    1.260056] Monitor-Mwait will be used to enter C-2 state
[    1.260074] Monitor-Mwait will be used to enter C-3 state
[    1.262307] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.306627] Non-volatile memory driver v1.3
[    1.306628] Linux agpgart interface v0.103
[    1.306771] [drm] Initialized drm 1.1.0 20060810
[    1.306773] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.307952] brd: module loaded
[    1.308553] loop: module loaded
[    1.308690] ahci 0000:00:1f.2: version 3.0
[    1.308701] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.308737] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
[    1.319308] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x30 impl SATA mode
[    1.319313] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    1.319318] ahci 0000:00:1f.2: setting latency timer to 64
[    1.321791] scsi0 : ahci
[    1.321858] scsi1 : ahci
[    1.321918] scsi2 : ahci
[    1.321977] scsi3 : ahci
[    1.322037] scsi4 : ahci
[    1.322096] scsi5 : ahci
[    1.322192] ata1: DUMMY
[    1.322193] ata2: DUMMY
[    1.322194] ata3: DUMMY
[    1.322194] ata4: DUMMY
[    1.322197] ata5: SATA max UDMA/133 abar m2048@0xfe725000 port 0xfe725300 irq 47
[    1.322199] ata6: SATA max UDMA/133 abar m2048@0xfe725000 port 0xfe725380 irq 47
[    1.322215] ahci 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.322323] ahci 0000:05:00.0: AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    1.322325] ahci 0000:05:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    1.322330] ahci 0000:05:00.0: setting latency timer to 64
[    1.322570] scsi6 : ahci
[    1.322635] scsi7 : ahci
[    1.322689] ata7: SATA max UDMA/133 abar m512@0xfe410000 port 0xfe410100 irq 19
[    1.322693] ata8: SATA max UDMA/133 abar m512@0xfe410000 port 0xfe410180 irq 19
[    1.322706] ahci 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.322763] ahci 0000:09:00.0: irq 48 for MSI/MSI-X
[    1.322813] ahci 0000:09:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    1.322815] ahci 0000:09:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    1.322819] ahci 0000:09:00.0: setting latency timer to 64
[    1.323061] scsi8 : ahci
[    1.323123] scsi9 : ahci
[    1.323177] ata9: SATA max UDMA/133 abar m512@0xfe110000 port 0xfe110100 irq 48
[    1.323180] ata10: SATA max UDMA/133 abar m512@0xfe110000 port 0xfe110180 irq 48
[    1.323389] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.323390] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.323417] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.323418] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.323431] e1000 0000:08:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.625939] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.625955] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.626472] e1000 0000:08:01.0: eth0: (PCI:33MHz:32-bit) 00:04:23:ac:e7:30
[    1.626475] e1000 0000:08:01.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.626487] e1000 0000:08:01.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.626591] ata6.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.626593] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.626666] ata5.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.626669] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.626976] ata8: SATA link down (SStatus 0 SControl 300)
[    1.626979] ata9: SATA link down (SStatus 0 SControl 300)
[    1.627053] ata7: SATA link down (SStatus 0 SControl 300)
[    1.627323] ata6.00: configured for UDMA/133
[    1.627469] ata5.00: configured for UDMA/133
[    1.627581] scsi 4:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    1.627696] sd 4:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    1.627728] sd 4:0:0:0: [sda] Write Protect is off
[    1.627730] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.627744] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.627759] sd 4:0:0:0: Attached scsi generic sg0 type 0
[    1.627857] scsi 5:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    1.627980] sd 5:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    1.628017] sd 5:0:0:0: [sdb] Write Protect is off
[    1.628019] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.628021] sd 5:0:0:0: Attached scsi generic sg1 type 0
[    1.628037] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.670916]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.671200] sd 5:0:0:0: [sdb] Attached SCSI disk
[    1.676888]  sda: sda1 sda2 sda3 sda4
[    1.677130] sd 4:0:0:0: [sda] Attached SCSI disk
[    1.782749] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.783100] ata10.00: ATAPI: ATAPI   iHAS424   B, GL1A, max UDMA/100
[    1.783993] ata10.00: configured for UDMA/100
[    1.786207] scsi 9:0:0:0: CD-ROM            ATAPI    iHAS424   B      GL1A PQ: 0 ANSI: 5
[    1.791304] sr0: scsi3-mmc drive: 47x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.791306] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.791396] sr 9:0:0:0: Attached scsi CD-ROM sr0
[    1.791459] sr 9:0:0:0: Attached scsi generic sg2 type 5
[    1.929096] e1000 0000:08:01.1: eth1: (PCI:33MHz:32-bit) 00:04:23:ac:e7:31
[    1.929098] e1000 0000:08:01.1: eth1: Intel(R) PRO/1000 Network Connection
[    1.929122] sky2: driver version 1.29
[    1.929272] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.929273] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    1.929288] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.929297] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.929299] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.929309] drivers/usb/core/inode.c: creating file 'devices'
[    1.929311] drivers/usb/core/inode.c: creating file '001'
[    1.929347] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.929353] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
[    1.929355] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
[    1.929366] ehci_hcd 0000:00:1a.0: support lpm
[    1.929374] ehci_hcd 0000:00:1a.0: debug port 2
[    1.929378] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.933252] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.933254] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
[    1.933263] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xfe727000
[    1.933266] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.937151] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.942548] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.942572] usb usb1: default language 0x0409
[    1.942579] usb usb1: udev 1, busnum 1, minor = 0
[    1.942581] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.942584] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.942586] usb usb1: Product: EHCI Host Controller
[    1.942588] usb usb1: Manufacturer: Linux 3.1.0-rc9-next-20111011+ ehci_hcd
[    1.942591] usb usb1: SerialNumber: 0000:00:1a.0
[    1.942668] usb usb1: usb_probe_device
[    1.942670] usb usb1: configuration #1 chosen from 1 choice
[    1.942673] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.942699] hub 1-0:1.0: usb_probe_interface
[    1.942700] hub 1-0:1.0: usb_probe_interface - got id
[    1.942701] hub 1-0:1.0: USB hub found
[    1.942704] hub 1-0:1.0: 2 ports detected
[    1.942705] hub 1-0:1.0: standalone hub
[    1.942706] hub 1-0:1.0: no power switching (usb 1.0)
[    1.942707] hub 1-0:1.0: individual port over-current protection
[    1.942708] hub 1-0:1.0: power on to power good time: 20ms
[    1.942710] hub 1-0:1.0: local power source is good
[    1.942711] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    1.942722] drivers/usb/core/inode.c: creating file '001'
[    1.942741] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.942749] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.942752] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.942754] drivers/usb/core/inode.c: creating file '002'
[    1.942787] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.942792] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
[    1.942795] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
[    1.942803] ehci_hcd 0000:00:1d.0: support lpm
[    1.942811] ehci_hcd 0000:00:1d.0: debug port 2
[    1.942814] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.946694] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.946695] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
[    1.946698] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfe726000
[    1.946701] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    1.950562] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    1.956528] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.956543] usb usb2: default language 0x0409
[    1.956549] usb usb2: udev 1, busnum 2, minor = 128
[    1.956552] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.956554] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.956557] usb usb2: Product: EHCI Host Controller
[    1.956559] usb usb2: Manufacturer: Linux 3.1.0-rc9-next-20111011+ ehci_hcd
[    1.956561] usb usb2: SerialNumber: 0000:00:1d.0
[    1.956642] usb usb2: usb_probe_device
[    1.956643] usb usb2: configuration #1 chosen from 1 choice
[    1.956646] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.956672] hub 2-0:1.0: usb_probe_interface
[    1.956673] hub 2-0:1.0: usb_probe_interface - got id
[    1.956674] hub 2-0:1.0: USB hub found
[    1.956675] hub 2-0:1.0: 2 ports detected
[    1.956676] hub 2-0:1.0: standalone hub
[    1.956677] hub 2-0:1.0: no power switching (usb 1.0)
[    1.956678] hub 2-0:1.0: individual port over-current protection
[    1.956679] hub 2-0:1.0: power on to power good time: 20ms
[    1.956681] hub 2-0:1.0: local power source is good
[    1.956682] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    1.956692] drivers/usb/core/inode.c: creating file '001'
[    1.956725] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.956727] ohci_hcd: block sizes: ed 80 td 96
[    1.956749] uhci_hcd: USB Universal Host Controller Interface driver
[    1.956798] usbcore: registered new interface driver usblp
[    1.956799] Initializing USB Mass Storage driver...
[    1.956823] usbcore: registered new interface driver usb-storage
[    1.956824] USB Mass Storage support registered.
[    1.956850] usbcore: registered new interface driver libusual
[    1.956939] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.959725] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.959728] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.959813] mousedev: PS/2 mouse device common for all mice
[    1.959955] rtc_cmos 00:04: RTC can wake from S4
[    1.960050] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.960074] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.960105] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.960163] md: raid1 personality registered for level 1
[    1.960240] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    1.960907] cpuidle: using governor ladder
[    1.962115] cpuidle: using governor menu
[    1.962117] EFI Variables Facility v0.08 2004-May-17
[    1.962692] usbcore: registered new interface driver usbhid
[    1.962693] usbhid: USB HID core driver
[    1.963452] modprobe used greatest stack depth: 5560 bytes left
[    1.963499] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.963559] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    1.963576] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    1.982685] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.982717] snd_hda_intel 0000:01:00.1: irq 50 for MSI/MSI-X
[    1.982729] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[    1.986923] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[    1.987315] ALSA device list:
[    1.987316]   #0: HDA Intel PCH at 0xfe720000 irq 49
[    1.987317]   #1: HDA ATI HDMI at 0xfe630000 irq 50
[    1.987371] Netfilter messages via NETLINK v0.30.
[    1.987380] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.987516] ctnetlink v0.93: registering with nfnetlink.
[    1.987753] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.987779] TCP cubic registered
[    1.987780] Initializing XFRM netlink socket
[    1.987996] NET: Registered protocol family 10
[    1.988379] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.988405] IPv6 over IPv4 tunneling driver
[    1.988694] NET: Registered protocol family 17
[    1.988701] Registering the dns_resolver key type
[    1.988882] PM: Hibernation image not present or could not be loaded.
[    1.988887] registered taskstats version 1
[    1.989264]   Magic number: 15:448:64
[    1.989300] console [netcon0] enabled
[    1.989300] netconsole: network logging started
[    1.990816] Freeing unused kernel memory: 644k freed
[    1.990860] Write protecting the kernel read-only data: 12288k
[    1.992498] Freeing unused kernel memory: 924k freed
[    1.995233] Freeing unused kernel memory: 1756k freed
[    1.999680] all_generic_ide used greatest stack depth: 5496 bytes left
[    2.001305] udevd[1283]: starting version 172
[    2.012851] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[    2.012852] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.012870] e1000e 0000:00:19.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.012876] e1000e 0000:00:19.0: setting latency timer to 64
[    2.012963] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    2.015846] ata_id used greatest stack depth: 5440 bytes left
[    2.030979] ata_id used greatest stack depth: 4672 bytes left
[    2.042457] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.042464] hub 1-0:1.0: port 1: status 0501 change 0001
[    2.056433] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.056439] hub 2-0:1.0: port 1: status 0501 change 0001
[    2.145485] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    2.145490] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    2.196490] ehci_hcd 0000:00:1a.0: port 1 high speed
[    2.196492] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.226251] Refined TSC clocksource calibration: 3502.640 MHz.
[    2.226257] Switching to clocksource tsc
[    2.247222] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.298367] ehci_hcd 0000:00:1a.0: port 1 high speed
[    2.298370] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.310432] e1000e 0000:00:19.0: eth2: (PCI Express:2.5GT/s:Width x1) 14:da:e9:1f:c3:cb
[    2.310433] e1000e 0000:00:19.0: eth2: Intel(R) PRO/1000 Network Connection
[    2.310463] e1000e 0000:00:19.0: eth2: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    2.361216] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
[    2.361223] ehci_hcd 0000:00:1a.0: LPM: no device attached
[    2.361467] usb 1-1: udev 2, busnum 1, minor = 1
[    2.361472] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.361474] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.361565] usb 1-1: usb_probe_device
[    2.361567] usb 1-1: configuration #1 chosen from 1 choice
[    2.361694] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    2.361708] hub 1-1:1.0: usb_probe_interface
[    2.361709] hub 1-1:1.0: usb_probe_interface - got id
[    2.361710] hub 1-1:1.0: USB hub found
[    2.361797] hub 1-1:1.0: 6 ports detected
[    2.361799] hub 1-1:1.0: standalone hub
[    2.361800] hub 1-1:1.0: individual port power switching
[    2.361801] hub 1-1:1.0: individual port over-current protection
[    2.361802] hub 1-1:1.0: Single TT
[    2.361804] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.361805] hub 1-1:1.0: power on to power good time: 100ms
[    2.362053] hub 1-1:1.0: local power source is good
[    2.362055] hub 1-1:1.0: enabling power on all ports
[    2.362813] drivers/usb/core/inode.c: creating file '002'
[    2.362831] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    2.362838] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    2.413228] ehci_hcd 0000:00:1d.0: port 1 high speed
[    2.413230] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.462704] usb 1-1: link qh256-0001/ffff88041a31d580 start 1 [1/0 us]
[    2.463961] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.515105] ehci_hcd 0000:00:1d.0: port 1 high speed
[    2.515108] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.524420] md: md0 stopped.
[    2.525602] md: bind<sdb2>
[    2.525769] md: bind<sda2>
[    2.526480] bio: create slab <bio-1> at 1
[    2.526541] md/raid1:md0: active with 2 out of 2 mirrors
[    2.526550] md0: detected capacity change from 0 to 32898877440
[    2.529186]  md0: unknown partition table
[    2.548610] md: md1 stopped.
[    2.566187] md: bind<sdb4>
[    2.566352] md: bind<sda4>
[    2.566883] md/raid1:md1: active with 2 out of 2 mirrors
[    2.566892] md1: detected capacity change from 0 to 1934596702208
[    2.578952] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
[    2.578958] ehci_hcd 0000:00:1d.0: LPM: no device attached
[    2.579204] usb 2-1: udev 2, busnum 2, minor = 129
[    2.579209] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    2.579211] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.579290] usb 2-1: usb_probe_device
[    2.579293] usb 2-1: configuration #1 chosen from 1 choice
[    2.579430] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    2.579441] hub 2-1:1.0: usb_probe_interface
[    2.579442] hub 2-1:1.0: usb_probe_interface - got id
[    2.579443] hub 2-1:1.0: USB hub found
[    2.579531] hub 2-1:1.0: 8 ports detected
[    2.579532] hub 2-1:1.0: standalone hub
[    2.579533] hub 2-1:1.0: individual port power switching
[    2.579534] hub 2-1:1.0: individual port over-current protection
[    2.579534] hub 2-1:1.0: Single TT
[    2.579535] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.579536] hub 2-1:1.0: power on to power good time: 100ms
[    2.579790] hub 2-1:1.0: local power source is good
[    2.579791] hub 2-1:1.0: enabling power on all ports
[    2.580738]  md1: unknown partition table
[    2.580812] drivers/usb/core/inode.c: creating file '002'
[    2.580831] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0000
[    2.681081] hub 2-1:1.0: port 3: status 0101 change 0001
[    2.681331] hub 2-1:1.0: port 4: status 0101 change 0001
[    2.681829] hub 2-1:1.0: port 7: status 0101 change 0001
[    2.722522] PM: Starting manual resume from disk
[    2.722524] PM: Hibernation image partition 8:3 present
[    2.722524] PM: Looking for hibernation image.
[    2.723012] PM: Image not found (code -22)
[    2.723015] PM: Hibernation image not present or could not be loaded.
[    2.744644] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
[    2.781561] usb 2-1: link qh256-0001/ffff880419002f00 start 1 [1/0 us]
[    2.781579] hub 2-1:1.0: state 7 ports 8 chg 0098 evt 0000
[    2.781697] hub 2-1:1.0: port 3, status 0101, change 0000, 12 Mb/s
[    2.792706] hub 2-1:1.0: port 3 not reset yet, waiting 10ms
[    2.854589] usb 2-1.3: new low-speed USB device number 3 using ehci_hcd
[    2.866579] hub 2-1:1.0: port 3 not reset yet, waiting 10ms
[    2.943795] usb 2-1.3: skipped 1 descriptor after interface
[    2.943800] usb 2-1.3: skipped 1 descriptor after interface
[    2.944364] usb 2-1.3: default language 0x0409
[    2.945886] usb 2-1.3: udev 3, busnum 2, minor = 130
[    2.945890] usb 2-1.3: New USB device found, idVendor=0e8f, idProduct=0022
[    2.945893] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.945896] usb 2-1.3: Product: USB KB V11
[    2.945898] usb 2-1.3: Manufacturer: GASIA
[    2.945986] usb 2-1.3: usb_probe_device
[    2.945988] usb 2-1.3: configuration #1 chosen from 1 choice
[    2.946229] usb 2-1.3: adding 2-1.3:1.0 (config #1, interface 0)
[    2.946263] usbhid 2-1.3:1.0: usb_probe_interface
[    2.946265] usbhid 2-1.3:1.0: usb_probe_interface - got id
[    2.948659] input: GASIA USB KB V11 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input2
[    2.948666] usb 2-1.3: link qh8-0601/ffff88041a4f6a80 start 2 [1/2 us]
[    2.948701] generic-usb 0003:0E8F:0022.0001: input,hidraw0: USB HID v1.10 Keyboard [GASIA USB KB V11] on usb-0000:00:1d.0-1.3/input0
[    2.948707] usb 2-1.3: adding 2-1.3:1.1 (config #1, interface 1)
[    2.949662] usbhid 2-1.3:1.1: usb_probe_interface
[    2.949666] usbhid 2-1.3:1.1: usb_probe_interface - got id
[    2.953295] input: GASIA USB KB V11 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/input/input3
[    2.953310] usb 2-1.3: link qh8-0601/ffff88041a4f6f80 start 3 [1/2 us]
[    2.953368] generic-usb 0003:0E8F:0022.0002: input,hidraw1: USB HID v1.10 Device [GASIA USB KB V11] on usb-0000:00:1d.0-1.3/input1
[    2.953374] drivers/usb/core/inode.c: creating file '003'
[    2.953461] hub 2-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    2.964448] hub 2-1:1.0: port 4 not reset yet, waiting 10ms
[    3.026420] usb 2-1.4: new low-speed USB device number 4 using ehci_hcd
[    3.038359] hub 2-1:1.0: port 4 not reset yet, waiting 10ms
[    3.114891] usb 2-1.4: skipped 1 descriptor after interface
[    3.115263] usb 2-1.4: default language 0x0409
[    3.116513] usb 2-1.4: udev 4, busnum 2, minor = 131
[    3.116515] usb 2-1.4: New USB device found, idVendor=04f3, idProduct=0230
[    3.116518] usb 2-1.4: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    3.116521] usb 2-1.4: Product: USB+PS/2 Optical Mouse
[    3.116593] usb 2-1.4: usb_probe_device
[    3.116596] usb 2-1.4: configuration #1 chosen from 1 choice
[    3.117021] usb 2-1.4: adding 2-1.4:1.0 (config #1, interface 0)
[    3.117053] usbhid 2-1.4:1.0: usb_probe_interface
[    3.117055] usbhid 2-1.4:1.0: usb_probe_interface - got id
[    3.118875] input: USB+PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input4
[    3.118913] generic-usb 0003:04F3:0230.0003: input,hidraw2: USB HID v1.11 Mouse [USB+PS/2 Optical Mouse] on usb-0000:00:1d.0-1.4/input0
[    3.118919] drivers/usb/core/inode.c: creating file '004'
[    3.119011] hub 2-1:1.0: port 7, status 0101, change 0000, 12 Mb/s
[    3.181193] usb 2-1.7: new full-speed USB device number 5 using ehci_hcd
[    3.192174] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    3.266334] usb 2-1.7: udev 5, busnum 2, minor = 132
[    3.266339] usb 2-1.7: New USB device found, idVendor=0cf3, idProduct=3000
[    3.266341] usb 2-1.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.266414] usb 2-1.7: usb_probe_device
[    3.266417] usb 2-1.7: configuration #1 chosen from 1 choice
[    3.266583] usb 2-1.7: adding 2-1.7:1.0 (config #1, interface 0)
[    3.266623] drivers/usb/core/inode.c: creating file '005'
[    3.266707] hub 2-1:1.0: state 7 ports 8 chg 0000 evt fe80
[    3.917909] udevd[1505]: starting version 172
[    4.884292] udevd[1539]: renamed network interface eth1 to rename3
[    4.966122] [drm] radeon kernel modesetting enabled.
[    4.966147] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.966150] radeon 0000:01:00.0: setting latency timer to 64
[    4.966391] [drm] initializing kernel modesetting (RV730 0x1002:0x9490 0x1787:0x2009).
[    4.966413] [drm] register mmio base: 0xFE620000
[    4.966414] [drm] register mmio size: 65536
[    4.966476] ATOM BIOS: RV730XT
[    4.966486] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    4.966488] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    4.966491] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    4.966492] [drm] Detected VRAM RAM=1024M, BAR=256M
[    4.966493] [drm] RAM width 128bits DDR
[    4.966515] [TTM] Zone  kernel: Available graphics memory: 8206338 kiB.
[    4.966516] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[    4.966517] [TTM] Initializing pool allocator.
[    4.966527] [drm] radeon: 1024M of VRAM memory ready
[    4.966527] [drm] radeon: 512M of GTT memory ready.
[    4.966532] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.966533] [drm] Driver supports precise vblank timestamp query.
[    4.966556] radeon 0000:01:00.0: irq 52 for MSI/MSI-X
[    4.966560] radeon 0000:01:00.0: radeon: using MSI.
[    4.966578] [drm] radeon: irq initialized.
[    4.966579] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    4.966812] [drm] Loading RV730 Microcode
[    5.125306] radeon 0000:01:00.0: WB enabled
[    5.171485] [drm] ring test succeeded in 1 usecs
[    5.171543] [drm] radeon: ib pool ready.
[    5.171580] [drm] ib test succeeded in 0 usecs
[    5.171584] failed to evaluate ATIF got AE_BAD_PARAMETER
[    5.171689] [drm] Radeon Display Connectors
[    5.171690] [drm] Connector 0:
[    5.171691] [drm]   HDMI-A
[    5.171692] [drm]   HPD2
[    5.171693] [drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[    5.171694] [drm]   Encoders:
[    5.171695] [drm]     DFP2: INTERNAL_UNIPHY1
[    5.171696] [drm] Connector 1:
[    5.171697] [drm]   VGA
[    5.171699] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    5.171700] [drm]   Encoders:
[    5.171701] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    5.171702] [drm] Connector 2:
[    5.171702] [drm]   DVI-I
[    5.171703] [drm]   HPD1
[    5.171705] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[    5.171706] [drm]   Encoders:
[    5.171706] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.171707] [drm]     DFP1: INTERNAL_UNIPHY
[    5.181478] [drm] Radeon display connector HDMI-A-1: No monitor connected or invalid EDID
[    5.233944] [drm] Radeon display connector VGA-1: Found valid EDID
[    5.243719] [drm] Radeon display connector DVI-I-1: No monitor connected or invalid EDID
[    5.243733] [drm] Internal thermal controller without fan control
[    5.243752] [drm] radeon: power management initialized
[    5.319438] [drm] fb mappable at 0xD0142000
[    5.319439] [drm] vram apper at 0xD0000000
[    5.319440] [drm] size 5787648
[    5.319440] [drm] fb depth is 24
[    5.319441] [drm]    pitch is 6400
[    5.319469] fbcon: radeondrmfb (fb0) is primary device
[    5.725157] Console: switching to colour frame buffer device 200x56
[    5.727152] fb0: radeondrmfb frame buffer device
[    5.727153] drm: registered panic notifier
[    5.727159] [drm] Initialized radeon 2.11.0 20080528 for 0000:01:00.0 on minor 0
[    5.727432] modprobe used greatest stack depth: 3264 bytes left
[   95.396091] Adding 32128900k swap on /dev/sda3.  Priority:-1 extents:1 across:32128900k 
[   95.432992] Adding 32128900k swap on /dev/sdb3.  Priority:-2 extents:1 across:32128900k 
[   95.434929] EXT4-fs (md0): re-mounted. Opts: (null)
[   95.697295] EXT4-fs (md0): re-mounted. Opts: errors=remount-ro
[   97.625499] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[   99.052883] fuse init (API version 7.17)
[  100.762034] EXT4-fs error (device md0): ext4_ext_insert_index:783: inode #1047511: comm flush-9:0: ix > EXT_LAST_INDEX!
[  100.762729] Aborting journal on device md0-8.
[  100.763598] EXT4-fs (md0): Remounting filesystem read-only
[  100.764316] EXT4-fs error (device md0): ext4_journal_start_sb:326: 
[  100.764319] EXT4-fs error (device md0) in ext4_free_blocks:4750: Journal has aborted
[  100.765623] Detected aborted journal
[  100.765881] EXT4-fs error (device md0) in ext4_free_blocks:4750: Journal has aborted
[  100.766754] EXT4-fs (md0): ext4_da_writepages: jbd2_start: 1024 pages, ino 1047511; err -30
[  101.387312] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  101.389445] ADDRCONF(NETDEV_UP): rename3: link is not ready
[  364.272237] e1000e 0000:00:19.0: PCI INT A disabled
[  370.249642] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
[  370.249643] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[  370.249660] e1000e 0000:00:19.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  370.249668] e1000e 0000:00:19.0: setting latency timer to 64
[  370.249820] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[  370.564134] e1000e 0000:00:19.0: eth1: (PCI Express:2.5GT/s:Width x1) 14:da:e9:1f:c3:cb
[  370.564136] e1000e 0000:00:19.0: eth1: Intel(R) PRO/1000 Network Connection
[  370.564168] e1000e 0000:00:19.0: eth1: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[  370.729312] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[  370.779414] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[  370.781296] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  372.312390] e1000e: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[  372.312395] e1000e 0000:00:19.0: eth1: 10/100 speed: disabling TSO
[  372.313747] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  382.870853] eth1: no IPv6 routers present
