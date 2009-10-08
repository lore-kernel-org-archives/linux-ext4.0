From: Andy Isaacson <adi@hexapodia.org>
Subject: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Thu, 8 Oct 2009 16:56:31 -0700
Message-ID: <20091008235631.GZ30557@hexapodia.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Transfer-Encoding: 8bit
Cc: iommu@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760144AbZJHX53@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm testing DMAR support on 2.6.32 on Intel VT-d laptop platforms.  It
was pretty stable circa 2.6.31-rc5 (we have dozens of machines running
2.6.31-rc8), but in the last two weeks I've had a bunch of instability
on Linus' tip kernels that looked potentially like IOMMU badness.

For example,
<20090928191644.GR12922@hexapodia.org>
http://lkml.org/lkml/2009/9/28/201

Today while running 817b33d38 I got the following (on a Thinkpad X200
I'd replaced the Dell with, just in case it was previously-good hardware
going bad).

[   29.450550] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 79
[   30.022328] DRHD: handling fault status reg 3
[   30.022328] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   30.022328] DMAR:[fault reason 05] PTE Write access is not set
[   30.146136] DRHD: handling fault status reg 3
[   30.248938] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   30.248939] DMAR:[fault reason 05] PTE Write access is not set

I don't know that DMAR is resulting in my repeated filesystem
corruption, but it does seem like a potential cause (and would explain
why I'm seeing this whereas most people aren't, since few people are
using VT-d *and* i915).

I see that the BROKEN_GFX_WA code has been removed; do we actually
believe that the relevant code is working?  Could it be corrupting my
AHCI DMAs if not?  At the end of the last thread Ted thought that we'd
lost a write of an inode block; this time the symptoms look different,
in that I don't see one inode block representing a significant data
loss (though I'm by no means an expert).

I've attached some useful info, let me know if I missed anything.

I'll try running with BROKEN_GFX_WA turned back on and see if that
improves things at all.

Thanks,
-andy

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
stepping	: 6
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 4521.62
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
stepping	: 6
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 4521.76
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-rc2 (adi@cvp-loaner-16) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu7) ) #2 SMP Thu Oct 8 13:15:25 PDT 2009
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-rc2 root=UUID=7d90dc78-4581-4744-8886-2b90ef34f948 ro nomodeset=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007b4a1000 (usable)
[    0.000000]  BIOS-e820: 000000007b4a1000 - 000000007b4a7000 (reserved)
[    0.000000]  BIOS-e820: 000000007b4a7000 - 000000007b5b7000 (usable)
[    0.000000]  BIOS-e820: 000000007b5b7000 - 000000007b60f000 (reserved)
[    0.000000]  BIOS-e820: 000000007b60f000 - 000000007b6c6000 (usable)
[    0.000000]  BIOS-e820: 000000007b6c6000 - 000000007b6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007b6d1000 - 000000007b6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007b6d4000 - 000000007b6d8000 (reserved)
[    0.000000]  BIOS-e820: 000000007b6d8000 - 000000007b6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007b6dc000 - 000000007b6df000 (reserved)
[    0.000000]  BIOS-e820: 000000007b6df000 - 000000007b706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007b706000 - 000000007b708000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007b708000 - 000000007b90f000 (reserved)
[    0.000000]  BIOS-e820: 000000007b90f000 - 000000007b99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007b99f000 - 000000007b9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007b9ff000 - 000000007ba00000 (usable)
[    0.000000]  BIOS-e820: 000000007bc00000 - 000000007e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x7ba00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 07C000000 mask FFC000000 uncachable
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 07BE00000 mask FFFE00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007b4a1000 (usable)
[    0.000000]  modified: 000000007b4a1000 - 000000007b4a7000 (reserved)
[    0.000000]  modified: 000000007b4a7000 - 000000007b5b7000 (usable)
[    0.000000]  modified: 000000007b5b7000 - 000000007b60f000 (reserved)
[    0.000000]  modified: 000000007b60f000 - 000000007b6c6000 (usable)
[    0.000000]  modified: 000000007b6c6000 - 000000007b6d1000 (ACPI NVS)
[    0.000000]  modified: 000000007b6d1000 - 000000007b6d4000 (ACPI data)
[    0.000000]  modified: 000000007b6d4000 - 000000007b6d8000 (reserved)
[    0.000000]  modified: 000000007b6d8000 - 000000007b6dc000 (ACPI NVS)
[    0.000000]  modified: 000000007b6dc000 - 000000007b6df000 (reserved)
[    0.000000]  modified: 000000007b6df000 - 000000007b706000 (ACPI NVS)
[    0.000000]  modified: 000000007b706000 - 000000007b708000 (ACPI data)
[    0.000000]  modified: 000000007b708000 - 000000007b90f000 (reserved)
[    0.000000]  modified: 000000007b90f000 - 000000007b99f000 (ACPI NVS)
[    0.000000]  modified: 000000007b99f000 - 000000007b9ff000 (ACPI data)
[    0.000000]  modified: 000000007b9ff000 - 000000007ba00000 (usable)
[    0.000000]  modified: 000000007bc00000 - 000000007e000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007ba00000
[    0.000000]  0000000000 - 007ba00000 page 2M
[    0.000000] kernel direct mapping tables up to 7ba00000 @ 8000-b000
[    0.000000] RAMDISK: 37d92000 - 37fef640
[    0.000000] ACPI: RSDP 00000000000f7380 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 000000007b97bdcc 00094 (v01 LENOVO TP-6D    00002020  LTP 00000000)
[    0.000000] ACPI: FACP 000000007b97bf00 000F4 (v03 LENOVO TP-6D    00002020 LNVO 00000001)
[    0.000000] ACPI: DSDT 000000007b97c2f4 0D889 (v01 LENOVO TP-6D    00002020 MSFT 03000000)
[    0.000000] ACPI: FACS 000000007b98e000 00040
[    0.000000] ACPI: SSDT 000000007b97c0b4 00240 (v01 LENOVO TP-6D    00002020 MSFT 03000000)
[    0.000000] ACPI: ECDT 000000007b989b7d 00052 (v01 LENOVO TP-6D    00002020 LNVO 00000001)
[    0.000000] ACPI: APIC 000000007b989bcf 00078 (v01 LENOVO TP-6D    00002020 LNVO 00000001)
[    0.000000] ACPI: MCFG 000000007b989c47 0003C (v01 LENOVO TP-6D    00002020 LNVO 00000001)
[    0.000000] ACPI: HPET 000000007b989c83 00038 (v01 LENOVO TP-6D    00002020 LNVO 00000001)
[    0.000000] ACPI: SLIC 000000007b989dc2 00176 (v01 LENOVO TP-6D    00002020  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007b989f38 00028 (v01 LENOVO TP-6D    00002020  LTP 00000001)
[    0.000000] ACPI: ASF! 000000007b989f60 000A0 (v16 LENOVO TP-6D    00002020 PTL  00000001)
[    0.000000] ACPI: SSDT 000000007b98d203 0055F (v01 LENOVO TP-6D    00002020 INTL 20050513)
[    0.000000] ACPI: DMAR 000000007b706000 00120 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 000000007b6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 000000007b6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 000000007b6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007ba00000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007ba00000
[    0.000000]   NODE_DATA [0000000000009000 - 000000000000dfff]
[    0.000000]   bootmap [000000000000e000 -  000000000001d73f] pages 10
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 007ba00000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001b70770]    TEXT DATA BSS ==> [0001000000 - 0001b70770]
[    0.000000]   #3 [0037d92000 - 0037fef640]          RAMDISK ==> [0037d92000 - 0037fef640]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0001b71000 - 0001b7114c]              BRK ==> [0001b71000 - 0001b7114c]
[    0.000000]   #6 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
[    0.000000] found SMP MP-table at [ffff8800000f73c0] f73c0
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002000000-ffff880003bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007b4a1
[    0.000000]     0: 0x0007b4a7 -> 0x0007b5b7
[    0.000000]     0: 0x0007b60f -> 0x0007b6c6
[    0.000000]     0: 0x0007b9ff -> 0x0007ba00
[    0.000000] On node 0 totalpages: 505346
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6867 pages used for memmap
[    0.000000]   DMA32 zone: 494486 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007b4a1000 - 000000007b4a7000
[    0.000000] PM: Registered nosave memory: 000000007b5b7000 - 000000007b60f000
[    0.000000] PM: Registered nosave memory: 000000007b6c6000 - 000000007b6d1000
[    0.000000] PM: Registered nosave memory: 000000007b6d1000 - 000000007b6d4000
[    0.000000] PM: Registered nosave memory: 000000007b6d4000 - 000000007b6d8000
[    0.000000] PM: Registered nosave memory: 000000007b6d8000 - 000000007b6dc000
[    0.000000] PM: Registered nosave memory: 000000007b6dc000 - 000000007b6df000
[    0.000000] PM: Registered nosave memory: 000000007b6df000 - 000000007b706000
[    0.000000] PM: Registered nosave memory: 000000007b706000 - 000000007b708000
[    0.000000] PM: Registered nosave memory: 000000007b708000 - 000000007b90f000
[    0.000000] PM: Registered nosave memory: 000000007b90f000 - 000000007b99f000
[    0.000000] PM: Registered nosave memory: 000000007b99f000 - 000000007b9ff000
[    0.000000] Allocating PCI resources starting at 7e000000 (gap: 7e000000:62000000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880001c00000 s83288 r8192 d23208 u524288
[    0.000000] pcpu-alloc: s83288 r8192 d23208 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 498322
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-rc2 root=UUID=7d90dc78-4581-4744-8886-2b90ef34f948 ro nomodeset=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1977944k/2025472k available (5400k kernel code, 4088k absent, 43440k reserved, 4014k data, 828k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.812 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4521.62 BogoMIPS (lpj=2260812)
[    0.001244] Security Framework initialized
[    0.001354] SELinux:  Initializing.
[    0.001466] SELinux:  Starting in permissive mode
[    0.001629] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002874] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003437] Mount-cache hash table entries: 256
[    0.003710] Initializing cgroup subsys ns
[    0.003821] Initializing cgroup subsys cpuacct
[    0.003950] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004106] CPU: L2 cache: 3072K
[    0.004212] CPU 0/0x0 -> Node 0
[    0.004318] CPU: Physical Processor ID: 0
[    0.004425] CPU: Processor Core ID: 0
[    0.004532] using mwait in idle threads.
[    0.004639] Performance Events: Core2 events, Intel PMU driver.
[    0.004831] ... version:                2
[    0.004938] ... bit width:              40
[    0.005001] ... generic registers:      2
[    0.005108] ... value mask:             000000ffffffffff
[    0.005216] ... max period:             000000007fffffff
[    0.005325] ... fixed-purpose events:   3
[    0.005432] ... event mask:             0000000700000003
[    0.005556] ACPI: Core revision 20090903
[    0.024008] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.025002] ftrace: allocating 28213 entries in 111 pages
[    0.026080] DMAR: Host address width 36
[    0.026188] DMAR: DRHD base: 0x000000feb03000 flags: 0x0
[    0.027004] IOMMU feb03000: ver 1:0 cap c9008020e30260 ecap 1000
[    0.027112] DMAR: DRHD base: 0x000000feb01000 flags: 0x0
[    0.027222] IOMMU feb01000: ver 1:0 cap c0000020630260 ecap 1000
[    0.027330] DMAR: DRHD base: 0x000000feb00000 flags: 0x0
[    0.027440] IOMMU feb00000: ver 1:0 cap c0000020630270 ecap 1000
[    0.027549] DMAR: DRHD base: 0x000000feb02000 flags: 0x1
[    0.027663] IOMMU feb02000: ver 1:0 cap c9008020630260 ecap 1000
[    0.027771] DMAR: RMRR base: 0x000000f2826c00 end: 0x000000f28273ff
[    0.027880] DMAR: RMRR base: 0x0000007bc00000 end: 0x0000007dffffff
[    0.027999] DMAR: No ATSR found
[    0.028111] Setting APIC routing to flat
[    0.028651] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.038843] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 06
[    0.039993] Testing tracer nop: PASSED
[    0.039993] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] Calibrating delay using timer specific routine.. 4521.76 BogoMIPS (lpj=2260884)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 3072K
[    0.001999] CPU 1/0x1 -> Node 0
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.110053] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 06
[    0.110988] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.112060] Brought up 2 CPUs
[    0.112164] Total of 2 processors activated (9043.39 BogoMIPS).
[    0.113047] khelper used greatest stack depth: 5824 bytes left
[    0.113148] Time: 22:38:45  Date: 10/08/09
[    0.113169] NET: Registered protocol family 16
[    0.115304] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.115473] ACPI: bus type pci registered
[    0.115590] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.115590] PCI: MCFG area at e0000000 reserved in E820
[    0.119415] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.119522] PCI: Using configuration type 1 for base access
[    0.126029] bio: create slab <bio-0> at 0
[    0.127309] ACPI: EC: EC description table is found, configuring boot EC
[    0.133920] ACPI: BIOS _OSI(Linux) query ignored
[    0.140113] ACPI: Interpreter enabled
[    0.140219] ACPI: (supports S0 S3 S4 S5)
[    0.140507] ACPI: Using IOAPIC for interrupt routing
[    0.140966] ACPI: Enumerating devices from [\]
[    0.153078] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.153164] ACPI: Power Resource [PUBS] (on)
[    0.155321] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.155775] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.156207] DMAR: Forcing write-buffer flush capability
[    0.156207] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.156207] pci 0000:00:02.0: reg 18 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.156207] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.156207] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.156207] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.156207] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.156240] pci 0000:00:03.0: PME# disabled
[    0.156369] pci 0000:00:03.2: reg 10 io port: [0x1828-0x182f]
[    0.156374] pci 0000:00:03.2: reg 14 io port: [0x180c-0x180f]
[    0.156378] pci 0000:00:03.2: reg 18 io port: [0x1820-0x1827]
[    0.156383] pci 0000:00:03.2: reg 1c io port: [0x1808-0x180b]
[    0.156387] pci 0000:00:03.2: reg 20 io port: [0x1810-0x181f]
[    0.156427] pci 0000:00:03.3: reg 10 io port: [0x1830-0x1837]
[    0.156432] pci 0000:00:03.3: reg 14 32bit mmio: [0xf2624000-0xf2624fff]
[    0.156544] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.156552] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.156560] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.156614] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.156725] pci 0000:00:19.0: PME# disabled
[    0.156995] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.157016] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.157018] pci 0000:00:1a.0: Performing full reset
[    0.157107] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.157127] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.157129] pci 0000:00:1a.1: Performing full reset
[    0.157219] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.157239] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.157241] pci 0000:00:1a.2: Performing full reset
[    0.157331] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.157409] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.157521] pci 0000:00:1a.7: PME# disabled
[    0.157680] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.157739] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.157849] pci 0000:00:1b.0: PME# disabled
[    0.158049] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.158159] pci 0000:00:1c.0: PME# disabled
[    0.158355] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.158466] pci 0000:00:1c.1: PME# disabled
[    0.158664] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.158774] pci 0000:00:1c.3: PME# disabled
[    0.158955] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.158978] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.158980] pci 0000:00:1d.0: Performing full reset
[    0.159068] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.159088] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.159090] pci 0000:00:1d.1: Performing full reset
[    0.159180] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.159200] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    0.159202] pci 0000:00:1d.2: Performing full reset
[    0.159291] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.159367] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.159478] pci 0000:00:1d.7: PME# disabled
[    0.159837] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.159844] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.159852] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.159860] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.159868] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.159876] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.159922] pci 0000:00:1f.2: PME# supported from D3hot
[    0.159979] pci 0000:00:1f.2: PME# disabled
[    0.160124] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.160143] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.160326] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.160440] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.160553] pci 0000:03:00.0: PME# disabled
[    0.160740] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.160804] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.160809] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.160816] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29fffff]
[    0.160888] pci 0000:00:1e.0: transparent bridge
[    0.161014] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.161178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.161245] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.161314] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.168181] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169148] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.169832] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.170570] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171284] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.171968] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.172611] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.173325] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.174227] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.174227] vgaarb: loaded
[    0.174340] SCSI subsystem initialized
[    0.174340] libata version 3.00 loaded.
[    0.175006] usbcore: registered new interface driver usbfs
[    0.175006] usbcore: registered new interface driver hub
[    0.175084] usbcore: registered new device driver usb
[    0.175091] PCI: Using ACPI for IRQ routing
[    0.176024] cfg80211: Using static regulatory domain info
[    0.176024] cfg80211: Regulatory domain: US
[    0.176080] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.176248] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.176357] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.176466] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.176576] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.176685] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.176794] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.176908] cfg80211: Calling CRDA for country: US
[    0.177369] NetLabel: Initializing
[    0.177369] NetLabel:  domain hash size = 128
[    0.177369] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.177369] NetLabel:  unlabeled traffic allowed by default
[    0.177477] IOMMU 0xfeb00000: using Register based invalidation
[    0.177584] IOMMU 0xfeb01000: using Register based invalidation
[    0.177692] IOMMU 0xfeb03000: using Register based invalidation
[    0.177799] IOMMU 0xfeb02000: using Register based invalidation
[    0.177974] IOMMU: Setting RMRR:
[    0.178088] IOMMU: Setting identity map for device 0000:00:02.0 [0x7bc00000 - 0x7e000000]
[    0.178434] IOMMU: Setting identity map for device 0000:00:02.1 [0x7bc00000 - 0x7e000000]
[    0.178781] IOMMU: Setting identity map for device 0000:00:1d.0 [0xf2826c00 - 0xf2827400]
[    0.178995] IOMMU: Setting identity map for device 0000:00:1d.1 [0xf2826c00 - 0xf2827400]
[    0.179180] IOMMU: Setting identity map for device 0000:00:1d.2 [0xf2826c00 - 0xf2827400]
[    0.179366] IOMMU: Setting identity map for device 0000:00:1d.7 [0xf2826c00 - 0xf2827400]
[    0.179550] IOMMU: Setting identity map for device 0000:00:1a.0 [0xf2826c00 - 0xf2827400]
[    0.179734] IOMMU: Setting identity map for device 0000:00:1a.1 [0xf2826c00 - 0xf2827400]
[    0.179917] IOMMU: Setting identity map for device 0000:00:1a.2 [0xf2826c00 - 0xf2827400]
[    0.179989] IOMMU: Setting identity map for device 0000:00:1a.7 [0xf2826c00 - 0xf2827400]
[    0.180168] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.180282] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
[    0.182972] DRHD: handling fault status reg 3
[    0.182974] DMAR:[DMA Write] Request device [00:02.0] fault addr f7ffb000 
[    0.182975] DMAR:[fault reason 05] PTE Write access is not set
[    0.182128] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.183997] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.184308] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.186978] Switching to clocksource tsc
[    0.197080] pnp: PnP ACPI init
[    0.197205] ACPI: bus type pnp registered
[    0.260364] pnp: PnP ACPI: found 10 devices
[    0.260470] ACPI: ACPI bus type pnp unregistered
[    0.260607] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.260717] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.260826] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.260935] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.261045] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.261154] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.261264] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.261373] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.261483] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.261597] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.261707] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.263489] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.263600] system 00:00: iomem range 0x100000-0x7dffffff could not be reserved
[    0.263769] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.263939] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.264112] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.264221] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.264330] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.264439] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.264553] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.264661] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.264771] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.264880] system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
[    0.264991] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.265101] system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved
[    0.265211] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.265322] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.265432] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.270656] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.270766] pci 0000:00:1c.0:   IO window: 0x3000-0x3fff
[    0.270877] pci 0000:00:1c.0:   MEM window: 0x7e000000-0x7e1fffff
[    0.270987] pci 0000:00:1c.0:   PREFETCH window: 0x0000007e200000-0x0000007e3fffff
[    0.271162] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.271271] pci 0000:00:1c.1:   IO window: 0x4000-0x4fff
[    0.271381] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.271492] pci 0000:00:1c.1:   PREFETCH window: 0x0000007e400000-0x0000007e5fffff
[    0.271670] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.271779] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.271889] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.272000] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x000000f29fffff
[    0.272174] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.272281] pci 0000:00:1e.0:   IO window: disabled
[    0.272391] pci 0000:00:1e.0:   MEM window: disabled
[    0.272500] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.272624] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.272737] pci 0000:00:1c.0: setting latency timer to 64
[    0.272746] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.272857] pci 0000:00:1c.1: setting latency timer to 64
[    0.272867] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.272978] pci 0000:00:1c.3: setting latency timer to 64
[    0.272986] pci 0000:00:1e.0: setting latency timer to 64
[    0.272990] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.272992] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.272995] pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
[    0.272997] pci_bus 0000:02: resource 1 mem: [0x7e000000-0x7e1fffff]
[    0.272999] pci_bus 0000:02: resource 2 pref mem [0x7e200000-0x7e3fffff]
[    0.273001] pci_bus 0000:03: resource 0 io:  [0x4000-0x4fff]
[    0.273003] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.273006] pci_bus 0000:03: resource 2 pref mem [0x7e400000-0x7e5fffff]
[    0.273008] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.273010] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.273012] pci_bus 0000:05: resource 2 pref mem [0xf2900000-0xf29fffff]
[    0.273014] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.273017] pci_bus 0000:0d: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.273049] NET: Registered protocol family 2
[    0.273275] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.274194] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.276002] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.276592] TCP: Hash tables configured (established 262144 bind 65536)
[    0.276702] TCP reno registered
[    0.276938] NET: Registered protocol family 1
[    0.277184] RPC: Registered udp transport module.
[    0.277291] RPC: Registered tcp transport module.
[    0.277396] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.277568] Trying to unpack rootfs image as initramfs...
[    0.326863] Freeing initrd memory: 2421k freed
[    0.328009] Simple Boot Flag at 0x35 set to 0x1
[    0.328893] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.329006] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.329158] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.329327] Scanning for low memory corruption every 60 seconds
[    0.329730] audit: initializing netlink socket (disabled)
[    0.329850] type=2000 audit(1255041525.329:1): initialized
[    0.339554] Testing tracer sched_switch: PASSED
[    0.451554] Testing tracer function: PASSED
[    0.568052] Testing dynamic ftrace: PASSED
[    0.804944] Warning: could not register the kmem tracer
[    0.805227] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.807903] VFS: Disk quotas dquot_6.5.2
[    0.808088] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.809027] msgmni has been set to 3867
[    0.809241] SELinux:  Registering netfilter hooks
[    0.809678] alg: No test for stdrng (krng)
[    0.809881] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.810050] io scheduler noop registered
[    0.810155] io scheduler anticipatory registered
[    0.810261] io scheduler deadline registered
[    0.810421] io scheduler cfq registered (default)
[    0.810536] pci 0000:00:02.0: Boot video device
[    0.810733] pcieport-driver 0000:00:1c.0: irq 28 for MSI/MSI-X
[    0.810744] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.810970] pcieport-driver 0000:00:1c.1: irq 29 for MSI/MSI-X
[    0.810980] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.811206] pcieport-driver 0000:00:1c.3: irq 30 for MSI/MSI-X
[    0.811216] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.811439] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.812031] ACPI: AC Adapter [AC] (on-line)
[    0.812282] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.812668] ACPI: Lid Switch [LID]
[    0.812839] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.813012] ACPI: Sleep Button [SLPB]
[    0.813196] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.813364] ACPI: Power Button [PWRF]
[    0.814111] ACPI: SSDT 000000007b6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.814969] ACPI: SSDT 000000007b6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.818283] Monitor-Mwait will be used to enter C-1 state
[    0.818306] Monitor-Mwait will be used to enter C-2 state
[    0.818327] Monitor-Mwait will be used to enter C-3 state
[    0.818335] Marking TSC unstable due to TSC halts in idle
[    0.818492] Switching to clocksource hpet
[    0.818580] processor LNXCPU:00: registered as cooling_device0
[    0.818583] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.819094] ACPI: SSDT 000000007b6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.819467] Switched to high resolution mode on CPU 0
[    0.819765] ACPI: SSDT 000000007b6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.819840] Switched to high resolution mode on CPU 1
[    0.820047] 
[    0.821697] processor LNXCPU:01: registered as cooling_device1
[    0.821807] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.865940] thermal LNXTHERM:01: registered as thermal_zone0
[    0.866062] ACPI: Thermal Zone [THM0] (43 C)
[    0.867680] thermal LNXTHERM:02: registered as thermal_zone1
[    0.867793] ACPI: Thermal Zone [THM1] (40 C)
[    0.872946] Non-volatile memory driver v1.3
[    0.873112] Linux agpgart interface v0.103
[    0.873304] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    0.874673] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.876501] ACPI Warning for \_SB_.PCI0.LPC_.EC__.BAT0._BIF: Converted Buffer to expected String at index 9 (20090903/nsrepair-132)
[    0.876857] ACPI Warning for \_SB_.PCI0.LPC_.EC__.BAT0._BIF: Converted Buffer to expected String at index 10 (20090903/nsrepair-132)
[    0.877228] ACPI Warning for \_SB_.PCI0.LPC_.EC__.BAT0._BIF: Converted Buffer to expected String at index 11 (20090903/nsrepair-132)
[    0.877581] ACPI Warning for \_SB_.PCI0.LPC_.EC__.BAT0._BIF: Converted Buffer to expected String at index 12 (20090903/nsrepair-132)
[    0.880214] ACPI: Battery Slot [BAT0] (battery present)
[    0.886638] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.886857] [drm] Initialized drm 1.1.0 20060810
[    0.887093] pci 0000:00:02.0: power state changed by ACPI to D0
[    0.887223] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.887334] pci 0000:00:02.0: setting latency timer to 64
[    0.904823] pci 0000:00:02.0: irq 31 for MSI/MSI-X
[    0.908961] acpi device:01: registered as cooling_device2
[    0.909338] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    0.909513] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.909686] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.909825] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.910429] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.910622] 0000:00:03.3: ttyS0 at I/O 0x1830 (irq = 17) is a 16550A
[    0.912780] brd: module loaded
[    0.913824] loop: module loaded
[    0.913991] input: Macintosh mouse button emulation as /devices/virtual/input/input4
[    0.914268] Loading iSCSI transport class v2.0-870.
[    0.914736] ahci 0000:00:1f.2: version 3.0
[    0.914748] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.914898] ahci 0000:00:1f.2: irq 32 for MSI/MSI-X
[    0.914927] ahci: SSS flag set, parallel bus scan disabled
[    0.915067] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.915245] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    0.915416] ahci 0000:00:1f.2: setting latency timer to 64
[    0.915624] scsi0 : ahci
[    0.915866] scsi1 : ahci
[    0.916165] scsi2 : ahci
[    0.916379] scsi3 : ahci
[    0.917020] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 32
[    0.917199] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 32
[    0.917367] ata3: DUMMY
[    0.917469] ata4: DUMMY
[    0.917838] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    0.917946] Copyright (c) 1999-2006 Intel Corporation.
[    0.918106] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.918221] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.918410] sky2 driver version 1.25
[    0.918644] console [netcon0] enabled
[    0.918748] netconsole: network logging started
[    0.919025] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.919141] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    0.919322] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    0.919436] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.919554] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.919558] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.919681] drivers/usb/core/inode.c: creating file 'devices'
[    0.919685] drivers/usb/core/inode.c: creating file '001'
[    0.919747] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.919921] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.919926] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.919963] ehci_hcd 0000:00:1a.7: debug port 1
[    0.920083] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.924274] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.924276] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    0.924291] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    0.924401] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.928296] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.934136] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.934264] usb usb1: default language 0x0409
[    0.934270] usb usb1: udev 1, busnum 1, minor = 0
[    0.934272] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.934381] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.934549] usb usb1: Product: EHCI Host Controller
[    0.934655] usb usb1: Manufacturer: Linux 2.6.32-rc2 ehci_hcd
[    0.934762] usb usb1: SerialNumber: 0000:00:1a.7
[    0.934901] usb usb1: uevent
[    0.934940] usb usb1: usb_probe_device
[    0.934943] usb usb1: configuration #1 chosen from 1 choice
[    0.935063] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    0.935078] usb 1-0:1.0: uevent
[    0.935115] hub 1-0:1.0: usb_probe_interface
[    0.935117] hub 1-0:1.0: usb_probe_interface - got id
[    0.935119] hub 1-0:1.0: USB hub found
[    0.935239] hub 1-0:1.0: 6 ports detected
[    0.937031] hub 1-0:1.0: standalone hub
[    0.937033] hub 1-0:1.0: no power switching (usb 1.0)
[    0.937034] hub 1-0:1.0: individual port over-current protection
[    0.937036] hub 1-0:1.0: power on to power good time: 20ms
[    0.937040] hub 1-0:1.0: local power source is good
[    0.937042] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    0.937075] drivers/usb/core/inode.c: creating file '001'
[    0.937260] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    0.937376] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.937495] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.937498] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.937609] drivers/usb/core/inode.c: creating file '002'
[    0.937670] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.937844] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    0.937848] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    0.937886] ehci_hcd 0000:00:1d.7: debug port 1
[    0.937995] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.941879] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.941881] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    0.941894] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    0.942012] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    0.945903] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    0.952012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.952135] usb usb2: default language 0x0409
[    0.952141] usb usb2: udev 1, busnum 2, minor = 128
[    0.952143] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.952252] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.952419] usb usb2: Product: EHCI Host Controller
[    0.952526] usb usb2: Manufacturer: Linux 2.6.32-rc2 ehci_hcd
[    0.952633] usb usb2: SerialNumber: 0000:00:1d.7
[    0.952769] usb usb2: uevent
[    0.952813] usb usb2: usb_probe_device
[    0.952816] usb usb2: configuration #1 chosen from 1 choice
[    0.952927] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    0.952943] usb 2-0:1.0: uevent
[    0.952982] hub 2-0:1.0: usb_probe_interface
[    0.952984] hub 2-0:1.0: usb_probe_interface - got id
[    0.952986] hub 2-0:1.0: USB hub found
[    0.953105] hub 2-0:1.0: 6 ports detected
[    0.953215] hub 2-0:1.0: standalone hub
[    0.953217] hub 2-0:1.0: no power switching (usb 1.0)
[    0.953218] hub 2-0:1.0: individual port over-current protection
[    0.953220] hub 2-0:1.0: power on to power good time: 20ms
[    0.953224] hub 2-0:1.0: local power source is good
[    0.953225] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    0.953255] drivers/usb/core/inode.c: creating file '001'
[    0.953311] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.953420] ohci_hcd: block sizes: ed 80 td 96
[    0.953468] uhci_hcd: USB Universal Host Controller Interface driver
[    0.953817] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    0.953929] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.954051] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.954055] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.954174] drivers/usb/core/inode.c: creating file '003'
[    0.954230] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.954404] uhci_hcd 0000:00:1a.0: detected 2 ports
[    0.954514] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.954515] uhci_hcd 0000:00:1a.0: Performing full reset
[    0.954530] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    0.954543] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    0.954692] usb usb3: default language 0x0409
[    0.954698] usb usb3: udev 1, busnum 3, minor = 256
[    0.954700] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.954809] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.954977] usb usb3: Product: UHCI Host Controller
[    0.955088] usb usb3: Manufacturer: Linux 2.6.32-rc2 uhci_hcd
[    0.955214] usb usb3: SerialNumber: 0000:00:1a.0
[    0.955352] usb usb3: uevent
[    0.955388] usb usb3: usb_probe_device
[    0.955390] usb usb3: configuration #1 chosen from 1 choice
[    0.955501] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    0.955516] usb 3-0:1.0: uevent
[    0.955552] hub 3-0:1.0: usb_probe_interface
[    0.955554] hub 3-0:1.0: usb_probe_interface - got id
[    0.955555] hub 3-0:1.0: USB hub found
[    0.955668] hub 3-0:1.0: 2 ports detected
[    0.955772] hub 3-0:1.0: standalone hub
[    0.955774] hub 3-0:1.0: no power switching (usb 1.0)
[    0.955775] hub 3-0:1.0: individual port over-current protection
[    0.955777] hub 3-0:1.0: power on to power good time: 2ms
[    0.955781] hub 3-0:1.0: local power source is good
[    0.955782] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    0.955797] drivers/usb/core/inode.c: creating file '001'
[    0.955830] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.955944] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.955947] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.956063] drivers/usb/core/inode.c: creating file '004'
[    0.956117] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.956299] uhci_hcd 0000:00:1a.1: detected 2 ports
[    0.956409] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.956411] uhci_hcd 0000:00:1a.1: Performing full reset
[    0.956436] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    0.956584] usb usb4: default language 0x0409
[    0.956590] usb usb4: udev 1, busnum 4, minor = 384
[    0.956592] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.956701] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.956870] usb usb4: Product: UHCI Host Controller
[    0.956976] usb usb4: Manufacturer: Linux 2.6.32-rc2 uhci_hcd
[    0.957088] usb usb4: SerialNumber: 0000:00:1a.1
[    0.957235] usb usb4: uevent
[    0.957270] usb usb4: usb_probe_device
[    0.957272] usb usb4: configuration #1 chosen from 1 choice
[    0.957384] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    0.957398] usb 4-0:1.0: uevent
[    0.957434] hub 4-0:1.0: usb_probe_interface
[    0.957436] hub 4-0:1.0: usb_probe_interface - got id
[    0.957437] hub 4-0:1.0: USB hub found
[    0.957549] hub 4-0:1.0: 2 ports detected
[    0.957654] hub 4-0:1.0: standalone hub
[    0.957655] hub 4-0:1.0: no power switching (usb 1.0)
[    0.957657] hub 4-0:1.0: individual port over-current protection
[    0.957659] hub 4-0:1.0: power on to power good time: 2ms
[    0.957662] hub 4-0:1.0: local power source is good
[    0.957664] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    0.957678] drivers/usb/core/inode.c: creating file '001'
[    0.957886] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    0.957999] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.958117] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.958120] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.958243] drivers/usb/core/inode.c: creating file '005'
[    0.958297] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.958471] uhci_hcd 0000:00:1a.2: detected 2 ports
[    0.958580] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.958581] uhci_hcd 0000:00:1a.2: Performing full reset
[    0.958596] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    0.958608] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    0.958757] usb usb5: default language 0x0409
[    0.958763] usb usb5: udev 1, busnum 5, minor = 512
[    0.958765] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.958875] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.959049] usb usb5: Product: UHCI Host Controller
[    0.959166] usb usb5: Manufacturer: Linux 2.6.32-rc2 uhci_hcd
[    0.959273] usb usb5: SerialNumber: 0000:00:1a.2
[    0.959409] usb usb5: uevent
[    0.959447] usb usb5: usb_probe_device
[    0.959449] usb usb5: configuration #1 chosen from 1 choice
[    0.959561] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    0.959575] usb 5-0:1.0: uevent
[    0.959611] hub 5-0:1.0: usb_probe_interface
[    0.959613] hub 5-0:1.0: usb_probe_interface - got id
[    0.959614] hub 5-0:1.0: USB hub found
[    0.959726] hub 5-0:1.0: 2 ports detected
[    0.959831] hub 5-0:1.0: standalone hub
[    0.959832] hub 5-0:1.0: no power switching (usb 1.0)
[    0.959834] hub 5-0:1.0: individual port over-current protection
[    0.959836] hub 5-0:1.0: power on to power good time: 2ms
[    0.959839] hub 5-0:1.0: local power source is good
[    0.959841] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    0.959855] drivers/usb/core/inode.c: creating file '001'
[    0.960057] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    0.960177] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.960291] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.960294] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.960404] drivers/usb/core/inode.c: creating file '006'
[    0.960468] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.960642] uhci_hcd 0000:00:1d.0: detected 2 ports
[    0.960751] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    0.960753] uhci_hcd 0000:00:1d.0: Performing full reset
[    0.960767] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    0.960780] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    0.960929] usb usb6: default language 0x0409
[    0.960935] usb usb6: udev 1, busnum 6, minor = 640
[    0.960937] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.961054] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.961230] usb usb6: Product: UHCI Host Controller
[    0.961336] usb usb6: Manufacturer: Linux 2.6.32-rc2 uhci_hcd
[    0.961443] usb usb6: SerialNumber: 0000:00:1d.0
[    0.961579] usb usb6: uevent
[    0.961619] usb usb6: usb_probe_device
[    0.961621] usb usb6: configuration #1 chosen from 1 choice
[    0.961733] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    0.961750] usb 6-0:1.0: uevent
[    0.961789] hub 6-0:1.0: usb_probe_interface
[    0.961791] hub 6-0:1.0: usb_probe_interface - got id
[    0.961792] hub 6-0:1.0: USB hub found
[    0.961904] hub 6-0:1.0: 2 ports detected
[    0.962012] hub 6-0:1.0: standalone hub
[    0.962013] hub 6-0:1.0: no power switching (usb 1.0)
[    0.962015] hub 6-0:1.0: individual port over-current protection
[    0.962017] hub 6-0:1.0: power on to power good time: 2ms
[    0.962020] hub 6-0:1.0: local power source is good
[    0.962022] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    0.962036] drivers/usb/core/inode.c: creating file '001'
[    0.962067] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.962188] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.962191] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.962301] drivers/usb/core/inode.c: creating file '007'
[    0.962363] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.962537] uhci_hcd 0000:00:1d.1: detected 2 ports
[    0.962646] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    0.962648] uhci_hcd 0000:00:1d.1: Performing full reset
[    0.962673] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    0.962822] usb usb7: default language 0x0409
[    0.962828] usb usb7: udev 1, busnum 7, minor = 768
[    0.962830] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.962939] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.963115] usb usb7: Product: UHCI Host Controller
[    0.963230] usb usb7: Manufacturer: Linux 2.6.32-rc2 uhci_hcd
[    0.963337] usb usb7: SerialNumber: 0000:00:1d.1
[    0.963475] usb usb7: uevent
[    0.963514] usb usb7: usb_probe_device
[    0.963516] usb usb7: configuration #1 chosen from 1 choice
[    0.963627] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    0.963641] usb 7-0:1.0: uevent
[    0.963679] hub 7-0:1.0: usb_probe_interface
[    0.963681] hub 7-0:1.0: usb_probe_interface - got id
[    0.963682] hub 7-0:1.0: USB hub found
[    0.963794] hub 7-0:1.0: 2 ports detected
[    0.963899] hub 7-0:1.0: standalone hub
[    0.963900] hub 7-0:1.0: no power switching (usb 1.0)
[    0.963902] hub 7-0:1.0: individual port over-current protection
[    0.963904] hub 7-0:1.0: power on to power good time: 2ms
[    0.963907] hub 7-0:1.0: local power source is good
[    0.963909] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    0.963925] drivers/usb/core/inode.c: creating file '001'
[    0.963955] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.964078] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.964081] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.964198] drivers/usb/core/inode.c: creating file '008'
[    0.964259] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.964433] uhci_hcd 0000:00:1d.2: detected 2 ports
[    0.964542] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    0.964544] uhci_hcd 0000:00:1d.2: Performing full reset
[    0.964569] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    0.964718] usb usb8: default language 0x0409
[    0.964724] usb usb8: udev 1, busnum 8, minor = 896
[    0.964726] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.964835] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.965004] usb usb8: Product: UHCI Host Controller
[    0.965113] usb usb8: Manufacturer: Linux 2.6.32-rc2 uhci_hcd
[    0.965229] usb usb8: SerialNumber: 0000:00:1d.2
[    0.965366] usb usb8: uevent
[    0.965404] usb usb8: usb_probe_device
[    0.965407] usb usb8: configuration #1 chosen from 1 choice
[    0.965518] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    0.965532] usb 8-0:1.0: uevent
[    0.965570] hub 8-0:1.0: usb_probe_interface
[    0.965572] hub 8-0:1.0: usb_probe_interface - got id
[    0.965573] hub 8-0:1.0: USB hub found
[    0.965685] hub 8-0:1.0: 2 ports detected
[    0.965790] hub 8-0:1.0: standalone hub
[    0.965792] hub 8-0:1.0: no power switching (usb 1.0)
[    0.965793] hub 8-0:1.0: individual port over-current protection
[    0.965795] hub 8-0:1.0: power on to power good time: 2ms
[    0.965798] hub 8-0:1.0: local power source is good
[    0.965800] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    0.965816] drivers/usb/core/inode.c: creating file '001'
[    0.965926] usbcore: registered new interface driver usblp
[    0.966042] Initializing USB Mass Storage driver...
[    0.966219] usbcore: registered new interface driver usb-storage
[    0.966327] USB Mass Storage support registered.
[    0.966495] usbcore: registered new interface driver libusual
[    0.966704] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.977281] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.977390] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.977649] mice: PS/2 mouse device common for all mice
[    0.978104] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.978242] rtc_cmos 00:07: RTC can wake from S4
[    0.978408] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.978543] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.978704] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.979185] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    0.979754] cpuidle: using governor ladder
[    0.980438] cpuidle: using governor menu
[    0.980546] No iBFT detected.
[    0.980914] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    0.981935] usbcore: registered new interface driver hiddev
[    0.982096] usbcore: registered new interface driver usbhid
[    0.982254] usbhid: v2.6:USB HID core driver
[    0.982407] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    0.984269] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.984466] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.017820] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    1.018145] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    1.018480] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    1.018818] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    1.020124] ALSA device list:
[    1.020240]   #0: HDA Intel at 0xf2620000 irq 17
[    1.020395] Netfilter messages via NETLINK v0.30.
[    1.020511] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.020903] ctnetlink v0.93: registering with nfnetlink.
[    1.021603] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.021736] TCP cubic registered
[    1.021839] Initializing XFRM netlink socket
[    1.022247] NET: Registered protocol family 10
[    1.023163] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.023320] IPv6 over IPv4 tunneling driver
[    1.024078] NET: Registered protocol family 17
[    1.025730] PM: Resume from disk failed.
[    1.025743] registered taskstats version 1
[    1.025850] Running tests on trace events:
[    1.025955] Testing event kfree_skb: OK
[    1.030337] Testing event skb_copy_datagram_iovec: OK
[    1.034339] Testing event i915_gem_object_create: 
[    1.038164] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    1.038232] OK
[    1.038234] Testing event i915_gem_object_bind: 
[    1.038425] hub 1-0:1.0: port 3: status 0501 change 0001
[    1.038533] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
[    1.038536] hub 1-0:1.0: port 4: status 0501 change 0001
[    1.038546] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
[    1.038549] hub 1-0:1.0: port 6: status 0501 change 0001
[    1.042234] OK
[    1.042336] Testing event i915_gem_object_clflush: OK
[    1.046291] Testing event i915_gem_object_change_domain: OK
[    1.050334] Testing event i915_gem_object_get_fence: 
[    1.054107] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    1.054224] hub 2-0:1.0: port 3: status 0501 change 0001
[    1.054232] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
[    1.054235] hub 2-0:1.0: port 4: status 0501 change 0001
[    1.054298] OK
[    1.054410] Testing event i915_gem_object_unbind: 
[    1.056166] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.057165] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    1.057178] uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
[    1.058216] OK
[    1.058318] Testing event i915_gem_object_destroy: 
[    1.062173] uhci_hcd 0000:00:1a.2: port 2 portsc 0082,00
[    1.062237] OK
[    1.062239] Testing event i915_gem_request_submit: 
[    1.064159] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.066155] uhci_hcd 0000:00:1d.1: port 1 portsc 0082,00
[    1.066168] uhci_hcd 0000:00:1d.1: port 2 portsc 0082,00
[    1.066196] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    1.066250] OK
[    1.066351] Testing event i915_gem_request_flush: OK
[    1.070345] Testing event i915_gem_request_complete: OK
[    1.074350] Testing event i915_gem_request_retire: OK
[    1.078296] Testing event i915_gem_request_wait_begin: OK
[    1.082305] Testing event i915_gem_request_wait_end: OK
[    1.086358] Testing event i915_ring_wait_begin: OK
[    1.091306] Testing event i915_ring_wait_end: OK
[    1.095346] Testing event block_rq_abort: OK
[    1.100288] Testing event block_rq_insert: OK
[    1.104479] Testing event block_rq_issue: OK
[    1.109288] Testing event block_rq_requeue: OK
[    1.113344] Testing event block_rq_complete: OK
[    1.118299] Testing event block_bio_bounce: OK
[    1.122345] Testing event block_bio_complete: OK
[    1.127295] Testing event block_bio_backmerge: OK
[    1.131309] Testing event block_bio_frontmerge: OK
[    1.135336] Testing event block_bio_queue: 
[    1.138405] hub 1-0:1.0: state 7 ports 6 chg 0058 evt 0000
[    1.138510] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    1.140207] OK
[    1.140309] Testing event block_getrq: OK
[    1.144345] Testing event block_sleeprq: OK
[    1.149288] Testing event block_plug: OK
[    1.153347] Testing event block_unplug_timer: OK
[    1.157296] Testing event block_unplug_io: OK
[    1.161334] Testing event block_split: OK
[    1.166351] Testing event block_remap: OK
[    1.171325] Testing event kmalloc: OK
[    1.175623] Testing event kmem_cache_alloc: OK
[    1.179331] Testing event kmalloc_node: OK
[    1.184295] Testing event kmem_cache_alloc_node: OK
[    1.188306] Testing event kfree: 
[    1.189446] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    1.189549] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
[    1.189553] hub 1-0:1.0: port 3 not reset yet, waiting 50ms
[    1.192193] OK
[    1.192295] Testing event kmem_cache_free: OK
[    1.196291] Testing event mm_page_free_direct: OK
[    1.200804] Testing event mm_pagevec_free: OK
[    1.205306] Testing event mm_page_alloc: OK
[    1.209668] Testing event mm_page_alloc_zone_locked: OK
[    1.214291] Testing event mm_page_pcpu_drain: OK
[    1.219292] Testing event mm_page_alloc_extfrag: 
[    1.223879] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.224183] OK
[    1.224285] Testing event power_start: 
[    1.224857] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.224965] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.225331] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.225337] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.226107] ata1.00: ATA-8: FUJITSU MHZ2160BH G1, 0084000A, max UDMA/100
[    1.226237] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.227298] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.227302] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.227603] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.227607] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.228239] OK
[    1.228349] Testing event power_end: 
[    1.228391] ata1.00: configured for UDMA/100
[    1.233337] OK
[    1.233439] Testing event power_frequency: OK
[    1.237532] Testing event module_load: 
[    1.240154] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[    1.240285] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    1.240620] ata1.00: configured for UDMA/100
[    1.240731] ata1: EH complete
[    1.240934] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B 0084 PQ: 0 ANSI: 5
[    1.241427] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.241602] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.241789] sd 0:0:0:0: [sda] Write Protect is off
[    1.241902] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.241924] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.242200] OK
[    1.242303] Testing event module_free: 
[    1.242483]  sda:OK
[    1.246341] Testing event module_get: OK
[    1.251295] Testing event module_put: OK
[    1.255336] Testing event module_request: OK
[    1.259307] Testing event workqueue_insertion: OK
[    1.263333] Testing event workqueue_execution:  sda1 sda2 <OK
[    1.267293] Testing event workqueue_creation: OK
[    1.271332] Testing event workqueue_destruction: OK
[    1.275253] Testing event timer_init: OK
[    1.279325] Testing event timer_start: OK
[    1.283293] Testing event timer_expire_entry: OK
[    1.287326] Testing event timer_expire_exit:  sda5 >
[    1.289926] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.291144] OK
[    1.291324] ehci_hcd 0000:00:1a.7: port 4 full speed --> companion
[    1.291329] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
[    1.291332] Testing event timer_cancel: 
[    1.291334] hub 1-0:1.0: port 4 not reset yet, waiting 50ms
[    1.295235] OK
[    1.295355] Testing event hrtimer_init: OK
[    1.299306] Testing event hrtimer_start: OK
[    1.303326] Testing event hrtimer_expire_entry: OK
[    1.307292] Testing event hrtimer_expire_exit: OK
[    1.311333] Testing event hrtimer_cancel: OK
[    1.315291] Testing event itimer_state: OK
[    1.319335] Testing event itimer_expire: OK
[    1.323292] Testing event irq_handler_entry: OK
[    1.327354] Testing event irq_handler_exit: OK
[    1.331304] Testing event softirq_entry: OK
[    1.335333] Testing event softirq_exit: OK
[    1.339297] Testing event sched_kthread_stop: 
[    1.342163] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
[    1.342289] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    1.343205] OK
[    1.343307] Testing event sched_kthread_stop_ret: OK
[    1.347327] Testing event sched_wait_task: OK
[    1.352293] Testing event sched_wakeup: OK
[    1.356326] Testing event sched_wakeup_new: OK
[    1.360292] Testing event sched_switch: OK
[    1.364327] Testing event sched_migrate_task: OK
[    1.368292] Testing event sched_process_free: OK
[    1.372336] Testing event sched_process_exit: OK
[    1.376317] Testing event sched_process_wait: OK
[    1.380334] Testing event sched_process_fork: OK
[    1.384383] Testing event sched_signal_send: OK
[    1.388333] Testing event sched_stat_wait: OK
[    1.392292] Testing event sched_stat_runtime: 
[    1.393448] ehci_hcd 0000:00:1a.7: port 6 high speed
[    1.393554] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    1.396234] OK
[    1.396336] Testing event sched_stat_sleep: OK
[    1.400250] Testing event sched_stat_iowait: OK
[    1.404328] Running tests on trace event systems:
[    1.404435] Testing event system skb: OK
[    1.408315] Testing event system i915: OK
[    1.412507] Testing event system block: OK
[    1.416498] Testing event system kmem: OK
[    1.420469] Testing event system power: OK
[    1.424342] Testing event system module: OK
[    1.428385] Testing event system workqueue: OK
[    1.432352] Testing event system timer: OK
[    1.436473] Testing event system irq: OK
[    1.440282] Testing event system sched: 
[    1.444155] usb 1-6: new high speed USB device using ehci_hcd and address 4
[    1.444661] OK
[    1.444764] Testing event system syscalls: OK
[    1.451771] Running tests on all trace events:
[    1.451876] Testing all events: OK
[    1.472574] Running tests again, along with the function tracer
[    1.472723] Running tests on trace events:
[    1.472859] Testing event kfree_skb: OK
[    1.477796] Testing event skb_copy_datagram_iovec: OK
[    1.482542] Testing event i915_gem_object_create: OK
[    1.487569] Testing event i915_gem_object_bind: OK
[    1.492567] Testing event i915_gem_object_clflush: 
[    1.495448] ehci_hcd 0000:00:1a.7: port 6 high speed
[    1.495579] ehci_hcd 0000:00:1a.7: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
[    1.497503] OK
[    1.497631] Testing event i915_gem_object_change_domain: 
[    1.499459] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    1.502491] OK
[    1.502615] Testing event i915_gem_object_get_fence: OK
[    1.507616] Testing event i915_gem_object_unbind: OK
[    1.512539] Testing event i915_gem_object_destroy: OK
[    1.516564] Testing event i915_gem_request_submit: 
[    1.519213] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input10
[    1.521404] OK
[    1.521530] Testing event i915_gem_request_flush: OK
[    1.525612] Testing event i915_gem_request_complete: OK
[    1.530563] Testing event i915_gem_request_retire: OK
[    1.534625] Testing event i915_gem_request_wait_begin: OK
[    1.539548] Testing event i915_gem_request_wait_end: OK
[    1.543601] Testing event i915_ring_wait_begin: OK
[    1.548590] Testing event i915_ring_wait_end: 
[    1.550207] ata2: SATA link down (SStatus 0 SControl 300)
[    1.553466] OK
[    1.553590] Testing event block_rq_abort: OK
[    1.557616] Testing event block_rq_insert: OK
[    1.562535] Testing event block_rq_issue: 
[    1.565268] usb 1-6: skipped 1 descriptor after configuration
[    1.565399] usb 1-6: skipped 4 descriptors after interface
[    1.565418] usb 1-6: skipped 1 descriptor after endpoint
[    1.565436] usb 1-6: skipped 17 descriptors after interface
[    1.565782] usb 1-6: default language 0x0409
[    1.566384] usb 1-6: udev 4, busnum 1, minor = 3
[    1.566399] usb 1-6: New USB device found, idVendor=17ef, idProduct=480c
[    1.566552] usb 1-6: New USB device strings: Mfr=1, Product=0, SerialNumber=0
[    1.566570] OK
[    1.566577] Testing event block_rq_requeue: 
[    1.566894] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    1.567463] usb 1-6: uevent
[    1.567688] usb 1-6: usb_probe_device
[    1.567704] usb 1-6: configuration #1 chosen from 1 choice
[    1.568059] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    1.568682] usb 1-6:1.0: uevent
[    1.569249] usb 1-6: adding 1-6:1.1 (config #1, interface 1)
[    1.569369] usb 1-6:1.1: uevent
[    1.569800] drivers/usb/core/inode.c: creating file '004'
[    1.569929] hub 2-0:1.0: state 7 ports 6 chg 0018 evt 0000
[    1.569963] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    1.571469] OK
[    1.571593] Testing event block_rq_complete: OK
[    1.575610] Testing event block_bio_bounce: OK
[    1.580560] Testing event block_bio_complete: OK
[    1.584615] Testing event block_bio_backmerge: OK
[    1.589582] Testing event block_bio_frontmerge: OK
[    1.593667] Testing event block_bio_queue: OK
[    1.598562] Testing event block_getrq: OK
[    1.602633] Testing event block_sleeprq: OK
[    1.607547] Testing event block_plug: OK
[    1.611669] Testing event block_unplug_timer: OK
[    1.616562] Testing event block_unplug_io: 
[    1.620558] ehci_hcd 0000:00:1d.7: port 3 high speed
[    1.621189] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.622688] OK
[    1.622812] Testing event block_split: OK
[    1.627569] Testing event block_remap: OK
[    1.631616] Testing event kmalloc: OK
[    1.636573] Testing event kmem_cache_alloc: OK
[    1.640677] Testing event kmalloc_node: OK
[    1.646577] Testing event kmem_cache_alloc_node: OK
[    1.651563] Testing event kfree: OK
[    1.655615] Testing event kmem_cache_free: OK
[    1.660563] Testing event mm_page_free_direct: OK
[    1.664679] Testing event mm_pagevec_free: OK
[    1.670568] Testing event mm_page_alloc: 
[    1.673211] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    1.675441] OK
[    1.675566] Testing event mm_page_alloc_zone_locked: OK
[    1.679618] Testing event mm_page_pcpu_drain: OK
[    1.684564] Testing event mm_page_alloc_extfrag: OK
[    1.688673] Testing event power_start: OK
[    1.693551] Testing event power_end: OK
[    1.697600] Testing event power_frequency: OK
[    1.702564] Testing event module_load: OK
[    1.706674] Testing event module_free: OK
[    1.711559] Testing event module_get: OK
[    1.715603] Testing event module_put: OK
[    1.720582] Testing event module_request: 
[    1.724433] ehci_hcd 0000:00:1d.7: port 3 high speed
[    1.724563] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001005 POWER sig=se0 PE CONNECT
[    1.724881] OK
[    1.725030] Testing event workqueue_insertion: OK
[    1.730586] Testing event workqueue_execution: OK
[    1.734600] Testing event workqueue_creation: OK
[    1.739575] Testing event workqueue_destruction: OK
[    1.743676] Testing event timer_init: OK
[    1.749599] Testing event timer_start: OK
[    1.754601] Testing event timer_expire_entry: OK
[    1.759599] Testing event timer_expire_exit: OK
[    1.764570] Testing event timer_cancel: OK
[    1.768569] Testing event hrtimer_init: OK
[    1.772582] Testing event hrtimer_start: OK
[    1.777601] Testing event hrtimer_expire_entry: OK
[    1.781589] Testing event hrtimer_expire_exit: OK
[    1.786612] Testing event hrtimer_cancel: 
[    1.788019] usb 2-3: default language 0x0409
[    1.788630] usb 2-3: udev 2, busnum 2, minor = 129
[    1.788646] usb 2-3: New USB device found, idVendor=8086, idProduct=1405
[    1.788797] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.788950] usb 2-3: Product: Intel(R) WiMAX Link 5350
[    1.789146] usb 2-3: Manufacturer: Intel(R) Corporation
[    1.789512] usb 2-3: uevent
[    1.789749] usb 2-3: usb_probe_device
[    1.789764] usb 2-3: configuration #1 chosen from 1 choice
[    1.790130] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[    1.790258] usb 2-3:1.0: uevent
[    1.790997] drivers/usb/core/inode.c: creating file '002'
[    1.791287] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    1.791598] OK
[    1.791722] Testing event itimer_state: OK
[    1.796604] Testing event itimer_expire: OK
[    1.801567] Testing event irq_handler_entry: OK
[    1.805631] Testing event irq_handler_exit: OK
[    1.810570] Testing event softirq_entry: OK
[    1.814673] Testing event softirq_exit: OK
[    1.819565] Testing event sched_kthread_stop: OK
[    1.823603] Testing event sched_kthread_stop_ret: OK
[    1.828565] Testing event sched_wait_task: OK
[    1.832668] Testing event sched_wakeup: OK
[    1.837567] Testing event sched_wakeup_new: OK
[    1.841604] Testing event sched_switch: 
[    1.842307] ehci_hcd 0000:00:1d.7: port 4 high speed
[    1.842437] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
[    1.846442] OK
[    1.846566] Testing event sched_migrate_task: OK
[    1.850678] Testing event sched_process_free: OK
[    1.856567] Testing event sched_process_exit: OK
[    1.861564] Testing event sched_process_wait: OK
[    1.865606] Testing event sched_process_fork: OK
[    1.870555] Testing event sched_signal_send: OK
[    1.874680] Testing event sched_stat_wait: OK
[    1.880576] Testing event sched_stat_runtime: OK
[    1.885560] Testing event sched_stat_sleep: OK
[    1.889615] Testing event sched_stat_iowait: 
[    1.893172] usb 2-4: new high speed USB device using ehci_hcd and address 3
[    1.894386] OK
[    1.894511] Running tests on trace event systems:
[    1.894652] Testing event system skb: OK
[    1.899675] Testing event system i915: OK
[    1.905281] Testing event system block: OK
[    1.911438] Testing event system kmem: OK
[    1.917193] Testing event system power: OK
[    1.921666] Testing event system module: OK
[    1.926765] Testing event system workqueue: OK
[    1.932749] Testing event system timer: OK
[    1.939204] Testing event system irq: OK
[    1.944741] Testing event system sched: OK
[    1.951404] Testing event system syscalls: OK
[    1.960650] Running tests on all trace events:
[    1.960789] Testing all events: 
[    1.973557] ehci_hcd 0000:00:1d.7: port 4 high speed
[    1.973687] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
[    1.980682] OK
[    1.993302]   Magic number: 13:540:653
[    1.993602] Freeing unused kernel memory: 828k freed
[    1.993962] Write protecting the kernel read-only data: 7852k
[    2.004372] all_generic_ide used greatest stack depth: 5776 bytes left
[    2.014777] exe used greatest stack depth: 5712 bytes left
[    2.075208] usb 2-4: skipped 3 descriptors after interface
[    2.075211] usb 2-4: skipped 4 descriptors after interface
[    2.075215] usb 2-4: skipped 4 descriptors after interface
[    2.075217] usb 2-4: skipped 2 descriptors after interface
[    2.075219] usb 2-4: skipped 2 descriptors after interface
[    2.075222] usb 2-4: skipped 5 descriptors after interface
[    2.075225] usb 2-4: skipped 4 descriptors after interface
[    2.084368] console_setup used greatest stack depth: 5504 bytes left
[    2.096208] usb 2-4: skipped 3 descriptors after interface
[    2.096211] usb 2-4: skipped 4 descriptors after interface
[    2.096214] usb 2-4: skipped 4 descriptors after interface
[    2.096217] usb 2-4: skipped 2 descriptors after interface
[    2.096219] usb 2-4: skipped 2 descriptors after interface
[    2.096221] usb 2-4: skipped 5 descriptors after interface
[    2.096453] usb 2-4: default language 0x0409
[    2.099229] usb usb3: uevent
[    2.099249] usb 3-0:1.0: uevent
[    2.099307] usb usb4: uevent
[    2.099326] usb 4-0:1.0: uevent
[    2.099382] usb usb5: uevent
[    2.099403] usb 5-0:1.0: uevent
[    2.099459] usb usb1: uevent
[    2.099478] usb 1-0:1.0: uevent
[    2.099501] usb 1-6: uevent
[    2.099520] usb 1-6:1.0: uevent
[    2.099541] usb 1-6:1.1: uevent
[    2.100204] usb usb6: uevent
[    2.100224] usb 6-0:1.0: uevent
[    2.100282] usb usb7: uevent
[    2.100301] usb 7-0:1.0: uevent
[    2.100355] usb usb8: uevent
[    2.100375] usb 8-0:1.0: uevent
[    2.100431] usb usb2: uevent
[    2.100450] usb 2-0:1.0: uevent
[    2.100475] usb 2-3: uevent
[    2.100497] usb 2-3:1.0: uevent
[    2.104449] udevadm used greatest stack depth: 4760 bytes left
[    2.107194] usb 2-4: udev 3, busnum 2, minor = 130
[    2.107197] usb 2-4: New USB device found, idVendor=0bdb, idProduct=1900
[    2.107310] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.107420] usb 2-4: Product: Ericsson F3507g Mobile Broadband Minicard Composite Device
[    2.107591] usb 2-4: Manufacturer: Ericsson
[    2.107698] usb 2-4: SerialNumber: 0115650002319190
[    2.107879] usb 2-4: uevent
[    2.107892] usb 2-4: usb_probe_device
[    2.107896] usb 2-4: configuration #1 chosen from 2 choices
[    2.110946] usb 2-4: adding 2-4:1.0 (config #1, interface 0)
[    2.111202] usb 2-4:1.0: uevent
[    2.111224] usb 2-4: adding 2-4:1.1 (config #1, interface 1)
[    2.113176] usb usb1: uevent
[    2.117256] usb usb4: uevent
[    2.117497] usb usb5: uevent
[    2.118196] usb usb3: uevent
[    2.128632] usb usb8: uevent
[    2.128741] usb usb2: uevent
[    2.129529] usb usb7: uevent
[    2.130679] usb usb6: uevent
[    2.138200] usb 1-6: uevent
[    2.148221] usb 2-4:1.1: uevent
[    2.148255] usb 2-4: adding 2-4:1.2 (config #1, interface 2)
[    2.155840] usb 2-4:1.2: uevent
[    2.155883] usb 2-4: adding 2-4:1.3 (config #1, interface 3)
[    2.163712] usb 2-4:1.3: uevent
[    2.163748] usb 2-4: adding 2-4:1.4 (config #1, interface 4)
[    2.170461] usb 2-3: uevent
[    2.171338] usb 2-4:1.4: uevent
[    2.171381] usb 2-4: adding 2-4:1.5 (config #1, interface 5)
[    2.179218] usb 2-4:1.5: uevent
[    2.179256] usb 2-4: adding 2-4:1.6 (config #1, interface 6)
[    2.182590] usb 2-4:1.6: uevent
[    2.182625] usb 2-4: adding 2-4:1.7 (config #1, interface 7)
[    2.187086] usb 2-4:1.7: uevent
[    2.187120] usb 2-4: adding 2-4:1.8 (config #1, interface 8)
[    2.189814] fuse init (API version 7.13)
[    2.191158] usb 2-4: uevent
[    2.192979] usb 2-4:1.8: uevent
[    2.193002] usb 2-4: adding 2-4:1.9 (config #1, interface 9)
[    2.195331] usb 2-4:1.9: uevent
[    2.195363] usb 2-4: adding 2-4:1.10 (config #1, interface 10)
[    2.197830] usb 2-4:1.10: uevent
[    2.197873] drivers/usb/core/inode.c: creating file '003'
[    2.197895] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    2.197905] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    2.197912] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    2.204156] usb usb3: suspend_rh (auto-stop)
[    2.204182] usb usb6: suspend_rh (auto-stop)
[    2.204209] usb usb8: suspend_rh (auto-stop)
[    2.204248] usb usb5: suspend_rh (auto-stop)
[    2.204274] usb usb7: suspend_rh (auto-stop)
[    2.241058] async/0 used greatest stack depth: 4632 bytes left
[    2.302035] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    2.404038] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    2.425749] PM: Starting manual resume from disk
[    2.425858] PM: Resume from partition 8:5
[    2.425860] PM: Checking hibernation image.
[    2.426036] PM: Resume from disk failed.
[    2.446906] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    2.447114] EXT4-fs (sda1): write access will be enabled during recovery
[    2.524026] usb 4-1: ep0 maxpacket = 8
[    2.540840] EXT4-fs (sda1): recovery complete
[    2.541558] EXT4-fs (sda1): mounted filesystem with ordered data mode
[    2.541818] exe used greatest stack depth: 4224 bytes left
[    2.552610] usb 4-1: default language 0x0409
[    2.561613] usb 4-1: udev 2, busnum 4, minor = 385
[    2.561616] usb 4-1: New USB device found, idVendor=08ff, idProduct=2810
[    2.561736] usb 4-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.561846] usb 4-1: Product: Fingerprint Sensor
[    2.562023] usb 4-1: uevent
[    2.562041] usb 4-1: usb_probe_device
[    2.562045] usb 4-1: configuration #1 chosen from 1 choice
[    2.562831] usb 4-1: uevent
[    2.564616] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    2.564643] usb 4-1:1.0: uevent
[    2.564698] drivers/usb/core/inode.c: creating file '002'
[    2.564730] uhci_hcd 0000:00:1a.1: port 2 portsc 0093,00
[    2.564737] hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    2.668104] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[    2.770109] usb 4-2: new full speed USB device using uhci_hcd and address 3
[    2.910626] usb 4-2: skipped 1 descriptor after interface
[    2.913615] usb 4-2: default language 0x0409
[    2.924617] usb 4-2: udev 3, busnum 4, minor = 386
[    2.924620] usb 4-2: New USB device found, idVendor=0a5c, idProduct=2145
[    2.924738] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.924848] usb 4-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    2.924957] usb 4-2: Manufacturer: Lenovo Computer Corp
[    2.925122] usb 4-2: uevent
[    2.925146] usb 4-2: usb_probe_device
[    2.925149] usb 4-2: configuration #1 chosen from 1 choice
[    2.927620] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    2.927647] usb 4-2:1.0: uevent
[    2.927714] usb 4-2: adding 4-2:1.1 (config #1, interface 1)
[    2.927729] usb 4-2:1.1: uevent
[    2.927760] usb 4-2: adding 4-2:1.2 (config #1, interface 2)
[    2.927774] usb 4-2:1.2: uevent
[    2.927806] usb 4-2: adding 4-2:1.3 (config #1, interface 3)
[    2.927821] usb 4-2:1.3: uevent
[    2.927835] drivers/usb/core/inode.c: creating file '003'
[    2.927853] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.927858] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.927861] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    2.927869] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    3.701168] hub 6-0:1.0: hub_suspend
[    3.701176] usb usb6: bus auto-suspend
[    3.701179] usb usb6: suspend_rh
[    3.701198] hub 8-0:1.0: hub_suspend
[    3.701201] usb usb8: bus auto-suspend
[    3.701202] usb usb8: suspend_rh
[    3.705123] hub 3-0:1.0: hub_suspend
[    3.705129] usb usb3: bus auto-suspend
[    3.705131] usb usb3: suspend_rh
[    4.276201] udev: starting version 147
[    4.412149] usb usb3: uevent
[    4.412202] usb 3-0:1.0: uevent
[    4.412338] usb usb4: uevent
[    4.412779] usb 4-0:1.0: uevent
[    4.412867] usb 4-1: uevent
[    4.412955] usb 4-1:1.0: uevent
[    4.413050] usb 4-2: uevent
[    4.413111] usb 4-2:1.0: uevent
[    4.413190] usb 4-2:1.1: uevent
[    4.413274] usb 4-2:1.2: uevent
[    4.413351] usb 4-2:1.3: uevent
[    4.413586] usb usb5: uevent
[    4.413636] usb 5-0:1.0: uevent
[    4.413770] usb usb1: uevent
[    4.414051] usb 1-0:1.0: uevent
[    4.414106] usb 1-6: uevent
[    4.414156] usb 1-6:1.0: uevent
[    4.414204] usb 1-6:1.1: uevent
[    4.417089] usb usb6: uevent
[    4.417140] usb 6-0:1.0: uevent
[    4.418148] usb usb7: uevent
[    4.419828] usb 7-0:1.0: uevent
[    4.419967] usb usb8: uevent
[    4.420039] usb 8-0:1.0: uevent
[    4.420173] usb usb2: uevent
[    4.420223] usb 2-0:1.0: uevent
[    4.420386] usb 2-3: uevent
[    4.420828] usb 2-3:1.0: uevent
[    4.420881] usb 2-4: uevent
[    4.420942] usb 2-4:1.0: uevent
[    4.420998] usb 2-4:1.1: uevent
[    4.421076] usb 2-4:1.10: uevent
[    4.421124] usb 2-4:1.2: uevent
[    4.421172] usb 2-4:1.3: uevent
[    4.421219] usb 2-4:1.4: uevent
[    4.421267] usb 2-4:1.5: uevent
[    4.421313] usb 2-4:1.6: uevent
[    4.421360] usb 2-4:1.7: uevent
[    4.421407] usb 2-4:1.8: uevent
[    4.421454] usb 2-4:1.9: uevent
[    4.456306] usb usb5: uevent
[    4.457266] usb usb3: uevent
[    4.458185] usb usb4: uevent
[    4.459394] usb usb6: uevent
[    4.460586] usb usb2: uevent
[    4.461118] usb usb8: uevent
[    4.462288] usb usb7: uevent
[    4.463453] usb usb1: uevent
[    4.467057] usb 4-1: uevent
[    4.468684] usb 4-2: uevent
[    4.469404] usb 1-6: uevent
[    4.505372] usb 2-3: uevent
[    4.507236] usb 2-4: uevent
[    5.704122] hub 5-0:1.0: hub_suspend
[    5.704139] usb usb5: bus auto-suspend
[    5.704142] usb usb5: suspend_rh
[    5.704160] hub 7-0:1.0: hub_suspend
[    5.704164] usb usb7: bus auto-suspend
[    5.704166] usb usb7: suspend_rh
[    7.925623] Adding 5807456k swap on /dev/sda5.  Priority:-1 extents:1 across:5807456k 
[   14.348997] usb usb3: uevent
[   14.349088] usb 3-0:1.0: uevent
[   14.349258] usb usb4: uevent
[   14.349341] usb 4-0:1.0: uevent
[   14.349396] usb 4-1: uevent
[   14.349492] usb 4-1:1.0: uevent
[   14.349555] usb 4-2: uevent
[   14.349638] usb 4-2:1.0: uevent
[   14.349693] usb 4-2:1.1: uevent
[   14.349747] usb 4-2:1.2: uevent
[   14.349800] usb 4-2:1.3: uevent
[   14.349950] usb usb5: uevent
[   14.350032] usb 5-0:1.0: uevent
[   14.350591] usb usb1: uevent
[   14.350678] usb 1-0:1.0: uevent
[   14.350735] usb 1-6: uevent
[   14.350817] usb 1-6:1.0: uevent
[   14.350872] usb 1-6:1.1: uevent
[   14.352769] usb usb6: uevent
[   14.352866] usb 6-0:1.0: uevent
[   14.353020] usb usb7: uevent
[   14.353103] usb 7-0:1.0: uevent
[   14.353649] usb usb8: uevent
[   14.353732] usb 8-0:1.0: uevent
[   14.354644] usb usb2: uevent
[   14.354729] usb 2-0:1.0: uevent
[   14.354786] usb 2-3: uevent
[   14.354867] usb 2-3:1.0: uevent
[   14.354923] usb 2-4: uevent
[   14.355012] usb 2-4:1.0: uevent
[   14.355066] usb 2-4:1.1: uevent
[   14.355123] usb 2-4:1.10: uevent
[   14.355215] usb 2-4:1.2: uevent
[   14.355270] usb 2-4:1.3: uevent
[   14.355323] usb 2-4:1.4: uevent
[   14.355377] usb 2-4:1.5: uevent
[   14.355431] usb 2-4:1.6: uevent
[   14.355484] usb 2-4:1.7: uevent
[   14.355537] usb 2-4:1.8: uevent
[   14.355590] usb 2-4:1.9: uevent
[   19.607443] usb usb1: uevent
[   19.607535] usb 1-0:1.0: uevent
[   19.607595] usb usb2: uevent
[   19.607680] usb 2-0:1.0: uevent
[   19.607739] usb usb3: uevent
[   19.607823] usb 3-0:1.0: uevent
[   19.607881] usb usb4: uevent
[   19.607965] usb 4-0:1.0: uevent
[   19.608026] usb usb5: uevent
[   19.608110] usb 5-0:1.0: uevent
[   19.608185] usb usb6: uevent
[   19.608692] usb 6-0:1.0: uevent
[   19.608751] usb usb7: uevent
[   19.608835] usb 7-0:1.0: uevent
[   19.608895] usb usb8: uevent
[   19.608979] usb 8-0:1.0: uevent
[   19.609038] usb 1-6: uevent
[   19.609123] usb 1-6:1.0: uevent
[   19.609235] usb 1-6:1.1: uevent
[   19.609294] usb 2-3: uevent
[   19.609378] usb 2-3:1.0: uevent
[   19.609438] usb 2-4: uevent
[   19.609526] usb 2-4:1.0: uevent
[   19.609585] usb 2-4:1.1: uevent
[   19.609643] usb 2-4:1.2: uevent
[   19.609701] usb 2-4:1.3: uevent
[   19.609760] usb 2-4:1.4: uevent
[   19.609818] usb 2-4:1.5: uevent
[   19.609877] usb 2-4:1.6: uevent
[   19.609935] usb 2-4:1.7: uevent
[   19.609993] usb 2-4:1.8: uevent
[   19.610054] usb 2-4:1.9: uevent
[   19.610113] usb 2-4:1.10: uevent
[   19.610572] usb 4-1: uevent
[   19.610660] usb 4-1:1.0: uevent
[   19.610720] usb 4-2: uevent
[   19.610805] usb 4-2:1.0: uevent
[   19.610864] usb 4-2:1.1: uevent
[   19.610923] usb 4-2:1.2: uevent
[   19.610981] usb 4-2:1.3: uevent
[   20.010571] usb usb6: usb auto-resume
[   20.010574] usb usb6: wakeup_rh
[   20.042168] hub 6-0:1.0: hub_resume
[   20.042215] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.042266] usb usb7: usb auto-resume
[   20.042269] usb usb7: wakeup_rh
[   20.074090] hub 7-0:1.0: hub_resume
[   20.074129] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.074292] usb usb8: usb auto-resume
[   20.074295] usb usb8: wakeup_rh
[   20.106098] hub 8-0:1.0: hub_resume
[   20.106142] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.106292] usb usb3: usb auto-resume
[   20.106295] usb usb3: wakeup_rh
[   20.138109] hub 3-0:1.0: hub_resume
[   20.138150] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.138204] usb usb5: usb auto-resume
[   20.138207] usb usb5: wakeup_rh
[   20.170155] hub 5-0:1.0: hub_resume
[   20.170201] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.170324] usb usb3: uevent
[   20.170826] usb 3-0:1.0: uevent
[   20.171580] usb usb4: uevent
[   20.172005] usb 4-0:1.0: uevent
[   20.172412] usb 4-1: uevent
[   20.172828] usb 4-1:1.0: uevent
[   20.173234] usb 4-2: uevent
[   20.173650] usb 4-2:1.0: uevent
[   20.174056] usb 4-2:1.1: uevent
[   20.174479] usb 4-2:1.2: uevent
[   20.174867] usb 4-2:1.3: uevent
[   20.175273] usb usb5: uevent
[   20.175683] usb 5-0:1.0: uevent
[   20.176073] usb usb1: uevent
[   20.176873] usb 1-0:1.0: uevent
[   20.177296] usb 1-6: uevent
[   20.177712] usb 1-6:1.0: uevent
[   20.178098] usb 1-6:1.1: uevent
[   20.178520] usb usb6: uevent
[   20.178942] usb 6-0:1.0: uevent
[   20.179352] usb usb7: uevent
[   20.179764] usb 7-0:1.0: uevent
[   20.180188] usb usb8: uevent
[   20.180603] usb 8-0:1.0: uevent
[   20.180989] usb usb2: uevent
[   20.181418] usb 2-0:1.0: uevent
[   20.181807] usb 2-3: uevent
[   20.182639] usb 2-3:1.0: uevent
[   20.183031] usb 2-4: uevent
[   20.183458] usb 2-4:1.0: uevent
[   20.183838] usb 2-4:1.1: uevent
[   20.184475] usb 2-4:1.10: uevent
[   20.184858] usb 2-4:1.2: uevent
[   20.185260] usb 2-4:1.3: uevent
[   20.185645] usb 2-4:1.4: uevent
[   20.186030] usb 2-4:1.5: uevent
[   20.186429] usb 2-4:1.6: uevent
[   20.186814] usb 2-4:1.7: uevent
[   20.187214] usb 2-4:1.8: uevent
[   20.187598] usb 2-4:1.9: uevent
[   21.064479] DRHD: handling fault status reg 3
[   21.064479] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   21.064479] DMAR:[fault reason 05] PTE Write access is not set
[   21.204152] usb usb6: suspend_rh (auto-stop)
[   21.204175] usb usb7: suspend_rh (auto-stop)
[   21.204198] usb usb8: suspend_rh (auto-stop)
[   21.204220] usb usb3: suspend_rh (auto-stop)
[   21.204242] usb usb5: suspend_rh (auto-stop)
[   22.701159] hub 8-0:1.0: hub_suspend
[   22.701167] usb usb8: bus auto-suspend
[   22.701169] usb usb8: suspend_rh
[   22.701186] hub 3-0:1.0: hub_suspend
[   22.701189] usb usb3: bus auto-suspend
[   22.701191] usb usb3: suspend_rh
[   22.704047] hub 6-0:1.0: hub_suspend
[   22.704053] usb usb6: bus auto-suspend
[   22.704055] usb usb6: suspend_rh
[   22.704073] hub 7-0:1.0: hub_suspend
[   22.704077] usb usb7: bus auto-suspend
[   22.704079] usb usb7: suspend_rh
[   22.704097] hub 5-0:1.0: hub_suspend
[   22.704101] usb usb5: bus auto-suspend
[   22.704103] usb usb5: suspend_rh
[   23.259901] DRHD: handling fault status reg 3
[   23.259909] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   23.259910] DMAR:[fault reason 05] PTE Write access is not set
[   25.571028] DRHD: handling fault status reg 3
[   25.571035] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   25.571037] DMAR:[fault reason 05] PTE Write access is not set
[   26.345407] DRHD: handling fault status reg 3
[   26.345407] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   26.345407] DMAR:[fault reason 05] PTE Write access is not set
[   27.255419] DRHD: handling fault status reg 3
[   27.358042] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   27.358042] DMAR:[fault reason 05] PTE Write access is not set
[   28.100421] DRHD: handling fault status reg 3
[   28.100421] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   28.100421] DMAR:[fault reason 05] PTE Write access is not set
[   28.822313] usb usb1: uevent
[   28.822405] usb 1-0:1.0: uevent
[   28.822465] usb usb2: uevent
[   28.822550] usb 2-0:1.0: uevent
[   28.822609] usb usb3: uevent
[   28.822695] usb 3-0:1.0: uevent
[   28.822754] usb usb4: uevent
[   28.822837] usb 4-0:1.0: uevent
[   28.822897] usb usb5: uevent
[   28.822980] usb 5-0:1.0: uevent
[   28.823055] usb usb6: uevent
[   28.823140] usb 6-0:1.0: uevent
[   28.823199] usb usb7: uevent
[   28.823282] usb 7-0:1.0: uevent
[   28.823341] usb usb8: uevent
[   28.823425] usb 8-0:1.0: uevent
[   28.823485] usb 1-6: uevent
[   28.823570] usb 1-6:1.0: uevent
[   28.823629] usb 1-6:1.1: uevent
[   28.823688] usb 2-3: uevent
[   28.823773] usb 2-3:1.0: uevent
[   28.823833] usb 2-4: uevent
[   28.823922] usb 2-4:1.0: uevent
[   28.823981] usb 2-4:1.1: uevent
[   28.824054] usb 2-4:1.2: uevent
[   28.824116] usb 2-4:1.3: uevent
[   28.824179] usb 2-4:1.4: uevent
[   28.824238] usb 2-4:1.5: uevent
[   28.824299] usb 2-4:1.6: uevent
[   28.824359] usb 2-4:1.7: uevent
[   28.824418] usb 2-4:1.8: uevent
[   28.824478] usb 2-4:1.9: uevent
[   28.824538] usb 2-4:1.10: uevent
[   28.824597] usb 4-1: uevent
[   28.824682] usb 4-1:1.0: uevent
[   28.824743] usb 4-2: uevent
[   28.824829] usb 4-2:1.0: uevent
[   28.824889] usb 4-2:1.1: uevent
[   28.824948] usb 4-2:1.2: uevent
[   28.825019] usb 4-2:1.3: uevent
[   29.040316] usb usb1: uevent
[   29.040413] usb 1-0:1.0: uevent
[   29.040474] usb usb2: uevent
[   29.040558] usb 2-0:1.0: uevent
[   29.040618] usb usb3: uevent
[   29.040702] usb 3-0:1.0: uevent
[   29.040761] usb usb4: uevent
[   29.040845] usb 4-0:1.0: uevent
[   29.040905] usb usb5: uevent
[   29.040988] usb 5-0:1.0: uevent
[   29.041048] usb usb6: uevent
[   29.041265] usb 6-0:1.0: uevent
[   29.041330] usb usb7: uevent
[   29.041415] usb 7-0:1.0: uevent
[   29.041476] usb usb8: uevent
[   29.041561] usb 8-0:1.0: uevent
[   29.041623] usb 1-6: uevent
[   29.041707] usb 1-6:1.0: uevent
[   29.041767] usb 1-6:1.1: uevent
[   29.041827] usb 2-3: uevent
[   29.041913] usb 2-3:1.0: uevent
[   29.041973] usb 2-4: uevent
[   29.042061] usb 2-4:1.0: uevent
[   29.042121] usb 2-4:1.1: uevent
[   29.042287] usb 2-4:1.2: uevent
[   29.042348] usb 2-4:1.3: uevent
[   29.042408] usb 2-4:1.4: uevent
[   29.042469] usb 2-4:1.5: uevent
[   29.042529] usb 2-4:1.6: uevent
[   29.042590] usb 2-4:1.7: uevent
[   29.042649] usb 2-4:1.8: uevent
[   29.042708] usb 2-4:1.9: uevent
[   29.042767] usb 2-4:1.10: uevent
[   29.042827] usb 4-1: uevent
[   29.042912] usb 4-1:1.0: uevent
[   29.042972] usb 4-2: uevent
[   29.043057] usb 4-2:1.0: uevent
[   29.043116] usb 4-2:1.1: uevent
[   29.043272] usb 4-2:1.2: uevent
[   29.043333] usb 4-2:1.3: uevent
[   29.067919] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 70
[   29.067925] Aborting journal on device sda1-8.
[   29.068236] EXT4-fs (sda1): Remounting filesystem read-only
[   29.069001] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 70
[   29.069238] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 79
[   29.427601] usb usb1: uevent
[   29.427692] usb 1-0:1.0: uevent
[   29.427752] usb usb2: uevent
[   29.427837] usb 2-0:1.0: uevent
[   29.427896] usb usb3: uevent
[   29.427981] usb 3-0:1.0: uevent
[   29.428043] usb usb4: uevent
[   29.428235] usb 4-0:1.0: uevent
[   29.428300] usb usb5: uevent
[   29.428385] usb 5-0:1.0: uevent
[   29.428444] usb usb6: uevent
[   29.428528] usb 6-0:1.0: uevent
[   29.428587] usb usb7: uevent
[   29.428671] usb 7-0:1.0: uevent
[   29.428730] usb usb8: uevent
[   29.428814] usb 8-0:1.0: uevent
[   29.428874] usb 1-6: uevent
[   29.428959] usb 1-6:1.0: uevent
[   29.429019] usb 1-6:1.1: uevent
[   29.429078] usb 2-3: uevent
[   29.429283] usb 2-3:1.0: uevent
[   29.429345] usb 2-4: uevent
[   29.429437] usb 2-4:1.0: uevent
[   29.429497] usb 2-4:1.1: uevent
[   29.429556] usb 2-4:1.2: uevent
[   29.429616] usb 2-4:1.3: uevent
[   29.429675] usb 2-4:1.4: uevent
[   29.429735] usb 2-4:1.5: uevent
[   29.429795] usb 2-4:1.6: uevent
[   29.429854] usb 2-4:1.7: uevent
[   29.429913] usb 2-4:1.8: uevent
[   29.429972] usb 2-4:1.9: uevent
[   29.430036] usb 2-4:1.10: uevent
[   29.430095] usb 4-1: uevent
[   29.430278] usb 4-1:1.0: uevent
[   29.430339] usb 4-2: uevent
[   29.430425] usb 4-2:1.0: uevent
[   29.430486] usb 4-2:1.1: uevent
[   29.430545] usb 4-2:1.2: uevent
[   29.430605] usb 4-2:1.3: uevent
[   29.450550] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 79
[   30.022328] DRHD: handling fault status reg 3
[   30.022328] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   30.022328] DMAR:[fault reason 05] PTE Write access is not set
[   30.146136] DRHD: handling fault status reg 3
[   30.248938] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   30.248939] DMAR:[fault reason 05] PTE Write access is not set
[   56.440632] usb usb1: uevent
[   56.440724] usb 1-0:1.0: uevent
[   56.440784] usb usb2: uevent
[   56.440869] usb 2-0:1.0: uevent
[   56.440929] usb usb3: uevent
[   56.441016] usb 3-0:1.0: uevent
[   56.441075] usb usb4: uevent
[   56.441202] usb 4-0:1.0: uevent
[   56.441262] usb usb5: uevent
[   56.441345] usb 5-0:1.0: uevent
[   56.441404] usb usb6: uevent
[   56.441487] usb 6-0:1.0: uevent
[   56.441546] usb usb7: uevent
[   56.441628] usb 7-0:1.0: uevent
[   56.441687] usb usb8: uevent
[   56.441770] usb 8-0:1.0: uevent
[   56.441829] usb 1-6: uevent
[   56.441914] usb 1-6:1.0: uevent
[   56.441972] usb 1-6:1.1: uevent
[   56.442032] usb 2-3: uevent
[   56.442116] usb 2-3:1.0: uevent
[   56.442467] usb 2-4: uevent
[   56.442556] usb 2-4:1.0: uevent
[   56.442616] usb 2-4:1.1: uevent
[   56.442674] usb 2-4:1.2: uevent
[   56.442733] usb 2-4:1.3: uevent
[   56.442792] usb 2-4:1.4: uevent
[   56.442851] usb 2-4:1.5: uevent
[   56.442910] usb 2-4:1.6: uevent
[   56.442969] usb 2-4:1.7: uevent
[   56.443030] usb 2-4:1.8: uevent
[   56.443089] usb 2-4:1.9: uevent
[   56.443475] usb 2-4:1.10: uevent
[   56.443537] usb 4-1: uevent
[   56.443623] usb 4-1:1.0: uevent
[   56.443683] usb 4-2: uevent
[   56.443768] usb 4-2:1.0: uevent
[   56.443828] usb 4-2:1.1: uevent
[   56.443886] usb 4-2:1.2: uevent
[   56.443945] usb 4-2:1.3: uevent
[ 1242.562931] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
[ 1242.562953] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[ 1242.562970] hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
[ 1242.666137] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
[ 1242.717358] ehci_hcd 0000:00:1a.7: port 1 high speed
[ 1242.717369] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[ 1242.768149] usb 1-1: new high speed USB device using ehci_hcd and address 5
[ 1242.852360] ehci_hcd 0000:00:1a.7: port 1 high speed
[ 1242.852372] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[ 1243.059547] usb 1-1: default language 0x0409
[ 1243.060908] usb 1-1: udev 5, busnum 1, minor = 4
[ 1243.060914] usb 1-1: New USB device found, idVendor=058f, idProduct=6387
[ 1243.060920] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1243.060926] usb 1-1: Product: Mass Storage
[ 1243.060931] usb 1-1: Manufacturer: Generic
[ 1243.060935] usb 1-1: SerialNumber: I0904000000000006415
[ 1243.061086] usb 1-1: uevent
[ 1243.061296] usb 1-1: usb_probe_device
[ 1243.061304] usb 1-1: configuration #1 chosen from 1 choice
[ 1243.061537] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[ 1243.061589] usb 1-1:1.0: uevent
[ 1243.061705] usb-storage 1-1:1.0: usb_probe_interface
[ 1243.061719] usb-storage 1-1:1.0: usb_probe_interface - got id
[ 1243.061845] scsi4 : SCSI emulation for USB Mass Storage devices
[ 1243.062847] usb-storage: device found at 5
[ 1243.062852] usb-storage: waiting for device to settle before scanning
[ 1243.062899] drivers/usb/core/inode.c: creating file '005'
[ 1243.063776] usb 1-1: uevent
[ 1243.067070] usb usb6: usb auto-resume
[ 1243.067078] usb usb6: wakeup_rh
[ 1243.098057] hub 6-0:1.0: hub_resume
[ 1243.098104] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1243.098159] usb usb7: usb auto-resume
[ 1243.098163] usb usb7: wakeup_rh
[ 1243.130100] hub 7-0:1.0: hub_resume
[ 1243.130159] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1243.130472] usb usb8: usb auto-resume
[ 1243.130478] usb usb8: wakeup_rh
[ 1243.162119] hub 8-0:1.0: hub_resume
[ 1243.162178] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1243.162456] usb usb3: usb auto-resume
[ 1243.162462] usb usb3: wakeup_rh
[ 1243.194118] hub 3-0:1.0: hub_resume
[ 1243.194178] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1243.194239] usb usb5: usb auto-resume
[ 1243.194245] usb usb5: wakeup_rh
[ 1243.226101] hub 5-0:1.0: hub_resume
[ 1243.226160] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[ 1244.204081] usb usb6: suspend_rh (auto-stop)
[ 1244.204111] usb usb7: suspend_rh (auto-stop)
[ 1244.204139] usb usb8: suspend_rh (auto-stop)
[ 1244.204166] usb usb3: suspend_rh (auto-stop)
[ 1244.454142] usb usb5: suspend_rh (auto-stop)
[ 1245.701151] hub 6-0:1.0: hub_suspend
[ 1245.701166] usb usb6: bus auto-suspend
[ 1245.701172] usb usb6: suspend_rh
[ 1245.701197] hub 7-0:1.0: hub_suspend
[ 1245.701204] usb usb7: bus auto-suspend
[ 1245.701208] usb usb7: suspend_rh
[ 1245.701230] hub 8-0:1.0: hub_suspend
[ 1245.701237] usb usb8: bus auto-suspend
[ 1245.701242] usb usb8: suspend_rh
[ 1245.701265] hub 3-0:1.0: hub_suspend
[ 1245.701271] usb usb3: bus auto-suspend
[ 1245.701276] usb usb3: suspend_rh
[ 1245.701298] hub 5-0:1.0: hub_suspend
[ 1245.701305] usb usb5: bus auto-suspend
[ 1245.701309] usb usb5: suspend_rh
[ 1248.063102] scsi 4:0:0:0: Direct-Access     FLASH    Drive AU_USB20   8.07 PQ: 0 ANSI: 2
[ 1248.063506] sd 4:0:0:0: Attached scsi generic sg1 type 0
[ 1248.064857] usb-storage: device scan complete
[ 1248.069783] sd 4:0:0:0: [sdb] 4098048 512-byte logical blocks: (2.09 GB/1.95 GiB)
[ 1248.071147] sd 4:0:0:0: [sdb] Write Protect is off
[ 1248.071156] sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
[ 1248.071162] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1248.074452] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1248.074599]  sdb: sdb1
[ 1248.386413] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[ 1248.386432] usb 1-1:1.0: uevent
[ 1248.386564] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[ 1248.386703] usb 1-1: uevent
[ 1248.390040] usb 1-1:1.0: uevent

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=git-id

commit 817b33d38f81c8736d39283c35c886ae4668f1af
Merge: 84d88d5 8c185ab
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Sep 30 17:36:45 2009 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6:
      ax25: Fix possible oops in ax25_make_new
      net: restore tx timestamping for accelerated vlans
      Phonet: fix mutex imbalance
      sit: fix off-by-one in ipip6_tunnel_get_prl
      net: Fix sock_wfree() race
      net: Make setsockopt() optlen be unsigned.

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=iomem

00000000-00000fff : System RAM
00001000-00005fff : reserved
00006000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000c0000-000c3fff : pnp 00:00
000c4000-000c7fff : pnp 00:00
000c8000-000cbfff : pnp 00:00
000cc000-000cffff : pnp 00:00
000d0000-000d3fff : pnp 00:00
000dc000-000fffff : reserved
00100000-7b4a0fff : System RAM
  01000000-015462db : Kernel code
  015462dc-01931b77 : Kernel data
  01a0d000-01b7076f : Kernel bss
7b4a1000-7b4a6fff : reserved
7b4a7000-7b5b6fff : System RAM
7b5b7000-7b60efff : reserved
7b60f000-7b6c5fff : System RAM
7b6c6000-7b6d0fff : ACPI Non-volatile Storage
7b6d1000-7b6d3fff : ACPI Tables
7b6d4000-7b6d7fff : reserved
7b6d8000-7b6dbfff : ACPI Non-volatile Storage
7b6dc000-7b6defff : reserved
7b6df000-7b705fff : ACPI Non-volatile Storage
7b706000-7b707fff : ACPI Tables
7b708000-7b90efff : reserved
7b90f000-7b99efff : ACPI Non-volatile Storage
7b99f000-7b9fefff : ACPI Tables
7b9ff000-7b9fffff : System RAM
7ba00000-7bbfffff : RAM buffer
7bc00000-7dffffff : reserved
7e000000-7e1fffff : PCI Bus 0000:02
7e200000-7e3fffff : PCI Bus 0000:02
7e400000-7e5fffff : PCI Bus 0000:03
7e600000-7e600fff : Intel Flush Page
d0000000-dfffffff : 0000:00:02.0
e0000000-efffffff : reserved
  e0000000-efffffff : pnp 00:02
    e0000000-e3ffffff : PCI MMCONFIG 0 [00-3f]
f0000000-f1ffffff : PCI Bus 0000:05
f2000000-f23fffff : 0000:00:02.0
f2400000-f24fffff : 0000:00:02.1
f2500000-f25fffff : PCI Bus 0000:03
  f2500000-f2501fff : 0000:03:00.0
f2600000-f261ffff : 0000:00:19.0
f2620000-f2623fff : 0000:00:1b.0
  f2620000-f2623fff : ICH HD audio
f2624000-f2624fff : 0000:00:03.3
f2625000-f2625fff : 0000:00:19.0
f2826000-f28267ff : 0000:00:1f.2
  f2826000-f28267ff : ahci
f2826800-f282680f : 0000:00:03.0
f2826c00-f2826fff : 0000:00:1a.7
  f2826c00-f2826fff : ehci_hcd
f2827000-f28273ff : 0000:00:1d.7
  f2827000-f28273ff : ehci_hcd
f2827400-f28274ff : 0000:00:1f.3
f2900000-f29fffff : PCI Bus 0000:05
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed10000-fed13fff : reserved
  fed10000-fed13fff : pnp 00:02
fed18000-fed19fff : reserved
  fed18000-fed18fff : pnp 00:02
  fed19000-fed19fff : pnp 00:02
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:02
  fed45000-fed4bfff : pnp 00:02
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff800000-ffffffff : reserved

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ioports

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vga+
0800-080f : pnp 00:02
0cf8-0cff : PCI conf1
1000-107f : pnp 00:02
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  1010-1015 : ACPI CPU throttle
  1020-102f : ACPI GPE0_BLK
  1050-1050 : ACPI PM2_CNT_BLK
1180-11ff : pnp 00:02
15e0-15ef : pnp 00:02
1600-1641 : pnp 00:02
  1600-161b : pnp 00:02
164e-164f : pnp 00:02
1800-1807 : 0000:00:02.0
1808-180b : 0000:00:03.2
180c-180f : 0000:00:03.2
1810-181f : 0000:00:03.2
1820-1827 : 0000:00:03.2
1828-182f : 0000:00:03.2
1830-1837 : 0000:00:03.3
  1830-1837 : serial
1838-183b : 0000:00:1f.2
  1838-183b : ahci
183c-183f : 0000:00:1f.2
  183c-183f : ahci
1840-185f : 0000:00:19.0
1860-187f : 0000:00:1a.0
  1860-187f : uhci_hcd
1880-189f : 0000:00:1a.1
  1880-189f : uhci_hcd
18a0-18bf : 0000:00:1a.2
  18a0-18bf : uhci_hcd
18c0-18df : 0000:00:1d.0
  18c0-18df : uhci_hcd
18e0-18ff : 0000:00:1d.1
  18e0-18ff : uhci_hcd
1c00-1c1f : 0000:00:1d.2
  1c00-1c1f : uhci_hcd
1c20-1c3f : 0000:00:1f.2
  1c20-1c3f : ahci
1c40-1c47 : 0000:00:1f.2
  1c40-1c47 : ahci
1c48-1c4f : 0000:00:1f.2
  1c48-1c4f : ahci
1c60-1c7f : 0000:00:1f.3
  1c60-1c7f : i801_smbus
2000-2fff : PCI Bus 0000:05
3000-3fff : PCI Bus 0000:02
4000-4fff : PCI Bus 0000:03

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kconfig

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.32-rc2
# Thu Oct  8 13:15:14 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_EVENT_PROFILE=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEFAULT_PS_VALUE=1
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set
CONFIG_WLAN=y
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
CONFIG_IWLWIFI_DEBUG=y
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set
# CONFIG_HERMES is not set
# CONFIG_WL12XX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_PCMCIA_IBMTR is not set
# CONFIG_WAN is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_WINBOND_CIR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_IMA is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=meminfo

MemTotal:        1981196 kB
MemFree:         1784124 kB
Buffers:           24808 kB
Cached:           106808 kB
SwapCached:            0 kB
Active:            59732 kB
Inactive:          90088 kB
Active(anon):      18648 kB
Inactive(anon):        0 kB
Active(file):      41084 kB
Inactive(file):    90088 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       5807456 kB
SwapFree:        5807456 kB
Dirty:              1004 kB
Writeback:             0 kB
AnonPages:         18352 kB
Mapped:            13420 kB
Shmem:               448 kB
Slab:              21368 kB
SReclaimable:      12888 kB
SUnreclaim:         8480 kB
KernelStack:        1304 kB
PageTables:         3216 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6798052 kB
Committed_AS:      81272 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      352740 kB
VmallocChunk:   34359381728 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       12288 kB
DirectMap2M:     2013184 kB

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fsck.out"

fsck from util-linux-ng 2.16
e2fsck 1.41.9 (22-Aug-2009)
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Entry '.xsession-errors' in /home/adi (40963) has deleted/unused inode 70.  Clear? no

Entry '.dmrc' in /home/adi (40963) has deleted/unused inode 79.  Clear? no

Entry 'move.pb' in /home/adi/.cache/compizconfig (41028) has deleted/unused inode 127.  Clear? no

Entry 'move.pb' in /home/adi/.cache/compizconfig (41028) has an incorrect filetype (was 1, should be 6).
Fix? no

Entry 'mtab' in /var/lib/DeviceKit-disks (592342) has deleted/unused inode 568791.  Clear? no

Entry 'dmrc' in /var/cache/gdm/adi (729221) has an incorrect filetype (was 1, should be 7).
Fix? no

Pass 3: Checking directory connectivity
Unconnected directory inode 131825 (/tmp/???)
Connect to /lost+found? no

'..' in ... (131825) is /tmp (81922), should be <The NULL inode> (0).
Fix? no

Unconnected directory inode 131828 (/tmp/???)
Connect to /lost+found? no

'..' in ... (131828) is /tmp (81922), should be <The NULL inode> (0).
Fix? no

Unconnected directory inode 131855 (/tmp/???)
Connect to /lost+found? no

'..' in ... (131855) is /tmp (81922), should be <The NULL inode> (0).
Fix? no

Pass 4: Checking reference counts
Unattached inode 148
Connect to /lost+found? no

Unattached inode 149
Connect to /lost+found? no

Inode 81922 ref count is 8, should be 11.  Fix? no

Inode 131825 ref count is 2, should be 1.  Fix? no

Unattached inode 131827
Connect to /lost+found? no

Inode 131828 ref count is 2, should be 1.  Fix? no

Unattached inode 131833
Connect to /lost+found? no

Unattached inode 131834
Connect to /lost+found? no

Inode 131855 ref count is 2, should be 1.  Fix? no

Inode 656243 ref count is 1, should be 2.  Fix? no

Pass 5: Checking group summary information
Block bitmap differences:  -92255 -92329 -(233487--233488) -234008 -(234031--234033) +310815 +(532878--532881) +(2319375--2319378)
Fix? no

Free blocks count wrong (35983722, counted=35983987).
Fix? no

Inode bitmap differences:  +82 +137 -657 -817 -819 +(131825--131856) -524522 -655904
Fix? no


/dev/sda1: ********** WARNING: Filesystem still has errors **********

/dev/sda1: 192749/9412608 files (0.2% non-contiguous), 1636483/37620205 blocks

--IJpNTDwzlM2Ie8A6--
