From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Thu, 16 Aug 2012 17:00:46 +0800
Message-ID: <20120816090046.GA12778@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Marti Raudsepp <marti@juffo.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 15, 2012 at 09:33:29PM +0300, Marti Raudsepp wrote:
> Hi list,
> 
> I was moving and deleting some files between two of my ext4 partitions
> when it suddenly crashed and dropped me into an kernel oops screen
> (below). I'm using ext4 on kernel 3.5.1 (Arch Linux). Both likely
> suspect file systems are stored on LVM2, mounted with
> data=writeback,errors=remount-ro,noatime
> 
> EXT4-fs (sda3): mounted filesystem with writeback data mode. Opts: (null)
> EXT4-fs (dm-1): mounted filesystem with writeback data mode. Opts:
> errors=remount-ro
> EXT4-fs (dm-0): mounted filesystem with writeback data mode. Opts:
> errors=remount-ro
> 
> I can't be bothered to transcribe all those 64-bit pointer values, but
> here's the human-readable parts (screen shot links below):
> 
> BUG: unable to handle kernel NULL pointer dereference at 000...00028
> IP: [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]

I run into the same issue on 3.6-rc1. Ted, I'll try your debug patch.

Thanks,
Fengguang
---
% dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1 (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #1 SMP Wed Aug 15 13:38:07 CST 2012
[    0.000000] Command line: BOOT_IMAGE=x86_64/vmlinuz-3.5.0 run=/home/wfg/ioless-balance_dirty_pages/main-loop.sh log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal netconsole=6667@192.168.1.58:/eth1,6666@192.168.1.1/00:1b:21:11:78:3e ip=192.168.1.58:192.168.1.1:192.168.1.1:255.255.255.0:lkp-st02-x8664:eth1:none nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cff00000-0x00000000cff0bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cff0c000-0x00000000cff0cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff0d000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X7DW3/X7DWN, BIOS 6.00 09/28/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3E00000000 write-back
[    0.000000]   3 base 0200000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0220000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xcff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f65f0-0x000f65ff] mapped at [ffff8800000f65f0]
[    0.000000]   mpc: 9e431-9e66d
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcfefffff]
[    0.000000]  [mem 0x00000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfefffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcfefffff @ [mem 0x1f97b000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x22fffffff]
[    0.000000]  [mem 0x100000000-0x22fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x22fffffff @ [mem 0xcfef6000-0xcfefffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 257736(98%)
[    0.000000] ACPI: RSDP 00000000000f65c0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cff05c78 00074 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000cff0bc4a 000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 00000000cff073f6 047E0 (v01  Intel SEABURG  06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000cff0cfc0 00040
[    0.000000] ACPI: TCPA 00000000cff0bd3e 00032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
[    0.000000] ACPI: DMAR 00000000cff0bd70 00108 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
[    0.000000] ACPI: APIC 00000000cff0be78 000D4 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000cff0bf4c 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000cff0bf88 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000cff0bfb0 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000cff07197 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff070f1 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff05cec 01405 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22f7fb000-0x22f7fffff]
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff880226e00000-ffff88022edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0xcfefffff]
[    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
[    0.000000] On node 0 totalpages: 2096779
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 831296 pages, LIFO batch:31
[    0.000000]   Normal zone: 19456 pages used for memmap
[    0.000000]   Normal zone: 1225728 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec86000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec86000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec89000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec86000)
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec89000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 00000000000d8000
[    0.000000] PM: Registered nosave memory: 00000000000d8000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 00000000cff0c000
[    0.000000] PM: Registered nosave memory: 00000000cff0c000 - 00000000cff0d000
[    0.000000] PM: Registered nosave memory: 00000000cff0d000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88022f400000 s80704 r8192 d21696 u262144
[    0.000000] pcpu-alloc: s80704 r8192 d21696 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2060933
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=x86_64/vmlinuz-3.5.0 run=/home/wfg/ioless-balance_dirty_pages/main-loop.sh log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal netconsole=6667@192.168.1.58:/eth1,6666@192.168.1.1/00:1b:21:11:78:3e ip=192.168.1.58:192.168.1.1:192.168.1.1:255.255.255.0:lkp-st02-x8664:eth1:none nfsroot=192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8162428k/9175040k available (9770k kernel code, 787924k absent, 224688k reserved, 6054k data, 976k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:1560 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2666.537 MHz processor
[    0.003004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.07 BogoMIPS (lpj=2666537)
[    0.005002] pid_max: default: 32768 minimum: 301
[    0.007295] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.012103] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.015341] Mount-cache hash table entries: 256
[    0.016311] Initializing cgroup subsys debug
[    0.017002] Initializing cgroup subsys cpuacct
[    0.018000] Initializing cgroup subsys memory
[    0.019011] Initializing cgroup subsys devices
[    0.020000] Initializing cgroup subsys freezer
[    0.021000] Initializing cgroup subsys blkio
[    0.022040] CPU: Physical Processor ID: 0
[    0.022999] CPU: Processor Core ID: 0
[    0.023999] mce: CPU supports 6 MCE banks
[    0.025003] CPU0: Thermal LVT vector (0xfa) already installed
[    0.026002] process: using mwait in idle threads
[    0.027002] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.027002] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.027002] tlb_flushall_shift is 0xffffffff
[    0.029826] ACPI: Core revision 20120711
[    0.034479] ftrace: allocating 38449 entries in 151 pages
[    0.044078] Getting VERSION: 50014
[    0.044997] Getting VERSION: 50014
[    0.045995] Getting ID: 0
[    0.046995] Getting ID: 0
[    0.047997] enabled ExtINT on CPU#0
[    0.050043] ENABLING IO-APIC IRQs
[    0.050994] init IO_APIC IRQs
[    0.051995]  apic 8 pin 0 not connected
[    0.052999] IOAPIC[0]: Set routing entry (8-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.053999] IOAPIC[0]: Set routing entry (8-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.054997] IOAPIC[0]: Set routing entry (8-3 -> 0x61 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.056001] IOAPIC[0]: Set routing entry (8-4 -> 0x71 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.056996] IOAPIC[0]: Set routing entry (8-5 -> 0x81 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.057996] IOAPIC[0]: Set routing entry (8-6 -> 0x91 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.058996] IOAPIC[0]: Set routing entry (8-7 -> 0xa1 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.059995] IOAPIC[0]: Set routing entry (8-8 -> 0xb1 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.060995] IOAPIC[0]: Set routing entry (8-9 -> 0xc1 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.061995] IOAPIC[0]: Set routing entry (8-10 -> 0xd1 -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.062995] IOAPIC[0]: Set routing entry (8-11 -> 0xe1 -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.063996] IOAPIC[0]: Set routing entry (8-12 -> 0x22 -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.064995] IOAPIC[0]: Set routing entry (8-13 -> 0x42 -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.065995] IOAPIC[0]: Set routing entry (8-14 -> 0x52 -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.066994] IOAPIC[0]: Set routing entry (8-15 -> 0x62 -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.067993]  apic 8 pin 16 not connected
[    0.068991]  apic 8 pin 17 not connected
[    0.069991]  apic 8 pin 18 not connected
[    0.070990]  apic 8 pin 19 not connected
[    0.071990]  apic 8 pin 20 not connected
[    0.072990]  apic 8 pin 21 not connected
[    0.073990]  apic 8 pin 22 not connected
[    0.074990]  apic 8 pin 23 not connected
[    0.075990]  apic 9 pin 0 not connected
[    0.076989]  apic 9 pin 1 not connected
[    0.077989]  apic 9 pin 2 not connected
[    0.078989]  apic 9 pin 3 not connected
[    0.079989]  apic 9 pin 4 not connected
[    0.080989]  apic 9 pin 5 not connected
[    0.081989]  apic 9 pin 6 not connected
[    0.082988]  apic 9 pin 7 not connected
[    0.083988]  apic 9 pin 8 not connected
[    0.084988]  apic 9 pin 9 not connected
[    0.085988]  apic 9 pin 10 not connected
[    0.086988]  apic 9 pin 11 not connected
[    0.087988]  apic 9 pin 12 not connected
[    0.088987]  apic 9 pin 13 not connected
[    0.089987]  apic 9 pin 14 not connected
[    0.090987]  apic 9 pin 15 not connected
[    0.091987]  apic 9 pin 16 not connected
[    0.092987]  apic 9 pin 17 not connected
[    0.093987]  apic 9 pin 18 not connected
[    0.094987]  apic 9 pin 19 not connected
[    0.095986]  apic 9 pin 20 not connected
[    0.096986]  apic 9 pin 21 not connected
[    0.097986]  apic 9 pin 22 not connected
[    0.098986]  apic 9 pin 23 not connected
[    0.099986]  apic 10 pin 0 not connected
[    0.100986]  apic 10 pin 1 not connected
[    0.101985]  apic 10 pin 2 not connected
[    0.102985]  apic 10 pin 3 not connected
[    0.103985]  apic 10 pin 4 not connected
[    0.104985]  apic 10 pin 5 not connected
[    0.105985]  apic 10 pin 6 not connected
[    0.106985]  apic 10 pin 7 not connected
[    0.107985]  apic 10 pin 8 not connected
[    0.108984]  apic 10 pin 9 not connected
[    0.109984]  apic 10 pin 10 not connected
[    0.110984]  apic 10 pin 11 not connected
[    0.111984]  apic 10 pin 12 not connected
[    0.112984]  apic 10 pin 13 not connected
[    0.113984]  apic 10 pin 14 not connected
[    0.114984]  apic 10 pin 15 not connected
[    0.115983]  apic 10 pin 16 not connected
[    0.116983]  apic 10 pin 17 not connected
[    0.117983]  apic 10 pin 18 not connected
[    0.118983]  apic 10 pin 19 not connected
[    0.119983]  apic 10 pin 20 not connected
[    0.120983]  apic 10 pin 21 not connected
[    0.121982]  apic 10 pin 22 not connected
[    0.122982]  apic 10 pin 23 not connected
[    0.124113] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.135554] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.66GHz stepping 0b
[    0.137980] Using local APIC timer interrupts.
[    0.137980] calibrating APIC timer ...
[    0.139978] ... lapic delta = 2083095
[    0.139978] ... PM-Timer delta = 357901
[    0.139978] ... PM-Timer result ok
[    0.139978] ..... delta 2083095
[    0.139978] ..... mult: 89481850
[    0.139978] ..... calibration result: 333295
[    0.139978] ..... CPU clock speed is 2666.0362 MHz.
[    0.139978] ..... host bus clock speed is 333.0295 MHz.
[    0.139992] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.144979] perf_event_intel: PEBS disabled due to CPU errata
[    0.145979] ... version:                2
[    0.146978] ... bit width:              40
[    0.147978] ... generic registers:      2
[    0.148978] ... value mask:             000000ffffffffff
[    0.149978] ... max period:             000000007fffffff
[    0.150978] ... fixed-purpose events:   3
[    0.151978] ... event mask:             0000000700000003
[    0.154240] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.003999] masked ExtINT on CPU#1
[    0.003999] CPU1: Thermal LVT vector (0xfa) already installed
[    0.003999] masked ExtINT on CPU#2
[    0.003999] CPU2: Thermal LVT vector (0xfa) already installed
[    0.003999] masked ExtINT on CPU#3
[    0.003999] CPU3: Thermal LVT vector (0xfa) already installed
[    0.003999] masked ExtINT on CPU#4
[    0.003999] CPU4: Thermal LVT vector (0xfa) already installed
[    0.003999] masked ExtINT on CPU#5
[    0.003999] CPU5: Thermal LVT vector (0xfa) already installed
[    0.003999] masked ExtINT on CPU#6
[    0.003999] CPU6: Thermal LVT vector (0xfa) already installed
[    0.155142] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.003999] masked ExtINT on CPU#7
[    0.003999] CPU7: Thermal LVT vector (0xfa) already installed
[    0.368995] Brought up 8 CPUs
[    0.369946] smpboot: Total of 8 processors activated (42662.72 BogoMIPS)
[    0.372020] CPU0 attaching sched-domain:
[    0.372950]  domain 0: span 0,2 level MC
[    0.374944]   groups: 0 (cpu_power = 1023) 2
[    0.377625]   domain 1: span 0-7 level CPU
[    0.378943]    groups: 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048)
[    0.387386] CPU1 attaching sched-domain:
[    0.387942]  domain 0: span 1,3 level MC
[    0.389941]   groups: 1 3
[    0.391942]   domain 1: span 0-7 level CPU
[    0.393941]    groups: 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047)
[    0.400942] CPU2 attaching sched-domain:
[    0.401940]  domain 0: span 0,2 level MC
[    0.403939]   groups: 2 0 (cpu_power = 1023)
[    0.407939]   domain 1: span 0-7 level CPU
[    0.409938]    groups: 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048)
[    0.416939] CPU3 attaching sched-domain:
[    0.417938]  domain 0: span 1,3 level MC
[    0.419937]   groups: 3 1
[    0.422621]   domain 1: span 0-7 level CPU
[    0.423936]    groups: 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047)
[    0.431377] CPU4 attaching sched-domain:
[    0.431935]  domain 0: span 4,6 level MC
[    0.433935]   groups: 4 6
[    0.435935]   domain 1: span 0-7 level CPU
[    0.437934]    groups: 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048)
[    0.446385] CPU5 attaching sched-domain:
[    0.446933]  domain 0: span 5,7 level MC
[    0.448933]   groups: 5 7
[    0.450932]   domain 1: span 0-7 level CPU
[    0.452933]    groups: 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048)
[    0.459932] CPU6 attaching sched-domain:
[    0.460932]  domain 0: span 4,6 level MC
[    0.462930]   groups: 6 4
[    0.465612]   domain 1: span 0-7 level CPU
[    0.466930]    groups: 4,6 (cpu_power = 2048) 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048)
[    0.474377] CPU7 attaching sched-domain:
[    0.474929]  domain 0: span 5,7 level MC
[    0.476929]   groups: 7 5
[    0.478928]   domain 1: span 0-7 level CPU
[    0.480929]    groups: 5,7 (cpu_power = 2048) 0,2 (cpu_power = 2047) 1,3 (cpu_power = 2048) 4,6 (cpu_power = 2048)
[    0.490046] devtmpfs: initialized
[    0.494494] PM: Registering ACPI NVS region [mem 0xcff0c000-0xcff0cfff] (4096 bytes)
[    0.496338] xor: automatically using best checksumming function:
[    0.506925]    generic_sse:  9888.000 MB/sec
[    0.507953] RTC time: 14:14:27, date: 08/15/12
[    0.508982] NET: Registered protocol family 16
[    0.511510] ACPI: bus type pci registered
[    0.511954] dca service started, version 1.12.1
[    0.512939] PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base 0xe0000000)
[    0.513926] PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
[    0.516335] PCI: Using configuration type 1 for base access
[    0.537956] bio: create slab <bio-0> at 0
[    0.555922] raid6: sse2x1    3882 MB/s
[    0.573917] raid6: sse2x2    7347 MB/s
[    0.591917] raid6: sse2x4    8316 MB/s
[    0.592911] raid6: using algorithm sse2x4 (8316 MB/s)
[    0.593911] raid6: using ssse3x2 recovery algorithm
[    0.594928] ACPI: Added _OSI(Module Device)
[    0.595913] ACPI: Added _OSI(Processor Device)
[    0.596911] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.597910] ACPI: Added _OSI(Processor Aggregator Device)
[    0.600130] ACPI: EC: Look up EC in DSDT
[    0.606805] ACPI: Interpreter enabled
[    0.606912] ACPI: (supports S0 S1 S4 S5)
[    0.609911] ACPI: Using IOAPIC for interrupt routing
[    0.618040] ACPI: No dock devices found.
[    0.618911] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.621960] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.625597] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.625910] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.626908] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.627907] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.628907] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
[    0.629909] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff] (ignored)
[    0.630907] PCI: root bus 00: using default resources
[    0.631908] pci_root PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-09] only partially covers this bridge
[    0.632932] PCI host bridge to bus 0000:00
[    0.633910] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.634906] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.635906] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.636906] pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffffff]
[    0.637919] pci 0000:00:00.0: [8086:4003] type 00 class 0x060000
[    0.638952] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.639922] pci 0000:00:01.0: [8086:4021] type 01 class 0x060400
[    0.640951] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.641924] pci 0000:00:03.0: [8086:4023] type 01 class 0x060400
[    0.642951] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.643927] pci 0000:00:05.0: [8086:4025] type 01 class 0x060400
[    0.644950] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.645923] pci 0000:00:07.0: [8086:4027] type 01 class 0x060400
[    0.646949] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.647921] pci 0000:00:09.0: [8086:4029] type 01 class 0x060400
[    0.648949] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.649923] pci 0000:00:0f.0: [8086:402f] type 00 class 0x088000
[    0.650911] pci 0000:00:0f.0: reg 10: [mem 0xfe700000-0xfe703fff 64bit]
[    0.651945] pci 0000:00:10.0: [8086:4030] type 00 class 0x060000
[    0.652927] pci 0000:00:10.1: [8086:4030] type 00 class 0x060000
[    0.653927] pci 0000:00:10.2: [8086:4030] type 00 class 0x060000
[    0.654926] pci 0000:00:10.3: [8086:4030] type 00 class 0x060000
[    0.655926] pci 0000:00:10.4: [8086:4030] type 00 class 0x060000
[    0.657912] pci 0000:00:11.0: [8086:4031] type 00 class 0x060000
[    0.658928] pci 0000:00:15.0: [8086:4035] type 00 class 0x060000
[    0.659926] pci 0000:00:15.1: [8086:4035] type 00 class 0x060000
[    0.660931] pci 0000:00:16.0: [8086:4036] type 00 class 0x060000
[    0.661925] pci 0000:00:16.1: [8086:4036] type 00 class 0x060000
[    0.662941] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.663969] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.664925] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.665937] pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
[    0.666933] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.667937] pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
[    0.668929] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.669936] pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
[    0.670939] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.671916] pci 0000:00:1d.7: reg 10: [mem 0xd8704000-0xd87043ff]
[    0.672980] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.673917] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.674956] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.675973] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.676916] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.677909] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.678906] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.679906] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.680905] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.681905] pci 0000:00:1f.1: reg 20: [io  0x1860-0x186f]
[    0.682933] pci 0000:00:1f.2: [8086:2681] type 00 class 0x010601
[    0.683910] pci 0000:00:1f.2: reg 10: [io  0x18b0-0x18b7]
[    0.684904] pci 0000:00:1f.2: reg 14: [io  0x18a8-0x18ab]
[    0.685904] pci 0000:00:1f.2: reg 18: [io  0x18a0-0x18a7]
[    0.686903] pci 0000:00:1f.2: reg 1c: [io  0x1874-0x1877]
[    0.687903] pci 0000:00:1f.2: reg 20: [io  0x1880-0x189f]
[    0.688903] pci 0000:00:1f.2: reg 24: [mem 0xd8704400-0xd87047ff]
[    0.689930] pci 0000:00:1f.2: PME# supported from D3hot
[    0.690911] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.691943] pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
[    0.692959] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    0.693907] pci 0000:01:00.0: [1000:0058] type 00 class 0x010000
[    0.694905] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
[    0.695906] pci 0000:01:00.0: reg 14: [mem 0xd8510000-0xd8513fff 64bit]
[    0.696906] pci 0000:01:00.0: reg 1c: [mem 0xd8500000-0xd850ffff 64bit]
[    0.697909] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x001fffff pref]
[    0.698934] pci 0000:01:00.0: supports D1 D2
[    0.699906] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.700897] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.701897] pci 0000:00:01.0:   bridge window [mem 0xd8500000-0xd85fffff]
[    0.702898] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xd81fffff 64bit pref]
[    0.703922] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.704896] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.705927] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
[    0.706896] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.707926] pci_bus 0000:04: busn_res: [bus 04-07] is inserted under [bus 00-ff]
[    0.708903] pci 0000:04:00.0: [8086:3500] type 01 class 0x060400
[    0.709952] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.710913] pci 0000:04:00.3: [8086:350c] type 01 class 0x060400
[    0.712952] pci 0000:04:00.3: PME# supported from D0 D3hot D3cold
[    0.713907] pci 0000:00:07.0: PCI bridge to [bus 04-07]
[    0.714895] pci 0000:00:07.0:   bridge window [io  0x3000-0x3fff]
[    0.715894] pci 0000:00:07.0:   bridge window [mem 0xd8200000-0xd83fffff]
[    0.716896] pci 0000:00:07.0:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    0.717922] pci_bus 0000:05: busn_res: [bus 05-06] is inserted under [bus 04-07]
[    0.718901] pci 0000:05:00.0: [8086:3510] type 01 class 0x060400
[    0.719956] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.720929] pci 0000:04:00.0: PCI bridge to [bus 05-06]
[    0.721933] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 05-06]
[    0.722893] pci 0000:05:00.0: PCI bridge to [bus 06]
[    0.723932] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 04-07]
[    0.724903] pci 0000:07:01.0: [8086:107c] type 00 class 0x020000
[    0.726892] pci 0000:07:01.0: reg 10: [mem 0xd8220000-0xd823ffff]
[    0.727898] pci 0000:07:01.0: reg 14: [mem 0xd8200000-0xd821ffff]
[    0.728898] pci 0000:07:01.0: reg 18: [io  0x3000-0x303f]
[    0.729918] pci 0000:07:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.730921] pci 0000:07:01.0: PME# supported from D0 D3hot D3cold
[    0.731929] pci 0000:04:00.3: PCI bridge to [bus 07]
[    0.732892] pci 0000:04:00.3:   bridge window [io  0x3000-0x3fff]
[    0.733892] pci 0000:04:00.3:   bridge window [mem 0xd8200000-0xd82fffff]
[    0.734894] pci 0000:04:00.3:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    0.735925] pci_bus 0000:08: busn_res: [bus 08] is inserted under [bus 00-ff]
[    0.736906] pci 0000:08:00.0: [8086:10a7] type 00 class 0x020000
[    0.737899] pci 0000:08:00.0: reg 10: [mem 0xd8420000-0xd843ffff]
[    0.738897] pci 0000:08:00.0: reg 14: [mem 0xd8400000-0xd841ffff]
[    0.739897] pci 0000:08:00.0: reg 18: [io  0x4000-0x401f]
[    0.740897] pci 0000:08:00.0: reg 1c: [mem 0xd8480000-0xd8483fff]
[    0.741911] pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.742934] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.743920] pci 0000:08:00.1: [8086:10a7] type 00 class 0x020000
[    0.744898] pci 0000:08:00.1: reg 10: [mem 0xd8460000-0xd847ffff]
[    0.745896] pci 0000:08:00.1: reg 14: [mem 0xd8440000-0xd845ffff]
[    0.746896] pci 0000:08:00.1: reg 18: [io  0x4020-0x403f]
[    0.747896] pci 0000:08:00.1: reg 1c: [mem 0xd8484000-0xd8487fff]
[    0.748910] pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.750905] pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
[    0.751907] pci 0000:00:09.0: PCI bridge to [bus 08]
[    0.752889] pci 0000:00:09.0:   bridge window [io  0x4000-0x4fff]
[    0.753889] pci 0000:00:09.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    0.754890] pci 0000:00:09.0:   bridge window [mem 0xd8900000-0xd89fffff 64bit pref]
[    0.755923] pci_bus 0000:09: busn_res: [bus 09] is inserted under [bus 00-ff]
[    0.756888] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    0.757889] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.758888] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff]
[    0.759890] pci 0000:00:1c.0:   bridge window [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    0.760906] pci_bus 0000:0a: busn_res: [bus 0a] is inserted under [bus 00-ff]
[    0.761898] pci 0000:0a:01.0: [1002:515e] type 00 class 0x030000
[    0.762901] pci 0000:0a:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    0.763894] pci 0000:0a:01.0: reg 14: [io  0x5000-0x50ff]
[    0.764894] pci 0000:0a:01.0: reg 18: [mem 0xd8600000-0xd860ffff]
[    0.765919] pci 0000:0a:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.766914] pci 0000:0a:01.0: supports D1 D2
[    0.767927] pci 0000:00:1e.0: PCI bridge to [bus 0a] (subtractive decode)
[    0.768887] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.769887] pci 0000:00:1e.0:   bridge window [mem 0xd8600000-0xd86fffff]
[    0.770888] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.771885] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.772885] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0x3fffffffff] (subtractive decode)
[    0.773907] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.775102] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.775954] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.776953] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.777953] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.778926] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.BMD0._PRT]
[    0.779928] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.BMD0.BPD0._PRT]
[    0.780955] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.BMF3._PRT]
[    0.781994] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.782932] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.784914] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.785956]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
[    0.797953] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    0.803400] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15), disabled.
[    0.808406] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    0.813411] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.818956] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
[    0.824962] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15), disabled.
[    0.830956] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15), disabled.
[    0.836952] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 *11 14 15), disabled.
[    0.842896] vgaarb: device added: PCI:0000:0a:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.843874] vgaarb: loaded
[    0.844872] vgaarb: bridge control possible 0000:0a:01.0
[    0.845947] SCSI subsystem initialized
[    0.846876] ACPI: bus type scsi registered
[    0.847892] libata version 3.00 loaded.
[    0.848892] ACPI: bus type usb registered
[    0.849894] usbcore: registered new interface driver usbfs
[    0.850886] usbcore: registered new interface driver hub
[    0.851885] usbcore: registered new device driver usb
[    0.852892] wmi: Mapper loaded
[    0.853883] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.854873] PCI: Using ACPI for IRQ routing
[    0.855874] PCI: pci_cache_line_size set to 64 bytes
[    0.856973] e820: reserve RAM buffer [mem 0x0009b400-0x0009ffff]
[    0.857871] e820: reserve RAM buffer [mem 0xcff00000-0xcfffffff]
[    0.860572] hpet clockevent registered
[    0.860873] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.861872] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.864311] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.871893] Switching to clocksource hpet
[    0.885923] pnp: PnP ACPI init
[    0.889270] ACPI: bus type pnp registered
[    0.894768] pnp 00:00: [bus 00-ff]
[    0.898441] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.903406] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.907764] pnp 00:00: [io  0x0d00-0xffff window]
[    0.912730] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.918389] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.924048] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.929709] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.935369] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.941027] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.946689] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.952346] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.958007] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.963664] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.969324] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.974983] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.980642] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.986302] pnp 00:00: [mem 0xd0000000-0xfebfffff window]
[    0.992071] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.999063] pnp 00:01: [io  0x0010-0x001f]
[    1.003423] pnp 00:01: [io  0x0024-0x0025]
[    1.007777] pnp 00:01: [io  0x0028-0x0029]
[    1.012137] pnp 00:01: [io  0x002c-0x002d]
[    1.016498] pnp 00:01: [io  0x002e-0x002f]
[    1.020854] pnp 00:01: [io  0x0030-0x0031]
[    1.025216] pnp 00:01: [io  0x0034-0x0035]
[    1.029574] pnp 00:01: [io  0x0038-0x0039]
[    1.033934] pnp 00:01: [io  0x003c-0x003d]
[    1.038291] pnp 00:01: [io  0x004e-0x004f]
[    1.042652] pnp 00:01: [io  0x0050-0x0053]
[    1.047008] pnp 00:01: [io  0x0063]
[    1.050755] pnp 00:01: [io  0x0065]
[    1.054498] pnp 00:01: [io  0x0067]
[    1.058243] pnp 00:01: [io  0x0072-0x0077]
[    1.062603] pnp 00:01: [io  0x0080]
[    1.066346] pnp 00:01: [io  0x0090-0x009f]
[    1.070707] pnp 00:01: [io  0x00a4-0x00a5]
[    1.075066] pnp 00:01: [io  0x00a8-0x00a9]
[    1.079425] pnp 00:01: [io  0x00ac-0x00ad]
[    1.083783] pnp 00:01: [io  0x00b0-0x00b5]
[    1.088144] pnp 00:01: [io  0x00b8-0x00b9]
[    1.092502] pnp 00:01: [io  0x00bc-0x00bd]
[    1.096852] pnp 00:01: [io  0x04d0-0x04d1]
[    1.101213] pnp 00:01: [io  0x0295-0x0296]
[    1.105572] pnp 00:01: [io  0x0ca2-0x0ca3]
[    1.109930] pnp 00:01: [io  0x0ca8-0x0caf]
[    1.114282] pnp 00:01: [io  0x0800-0x080f]
[    1.118640] pnp 00:01: [io  0x1000-0x107f]
[    1.122991] pnp 00:01: [io  0x1180-0x11bf]
[    1.127352] pnp 00:01: [io  0xfe00]
[    1.137405] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    1.142457] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    1.147510] pnp 00:01: [mem 0xfec86000-0xfec86fff]
[    1.152566] pnp 00:01: [mem 0xfec89000-0xfec89fff]
[    1.157614] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    1.162669] pnp 00:01: [mem 0xfe000000-0xfe01ffff]
[    1.167721] pnp 00:01: [mem 0xfe600000-0xfe6fffff]
[    1.172773] pnp 00:01: [mem 0xfed20000-0xfed44fff]
[    1.177826] pnp 00:01: [mem 0xfed45000-0xfed8ffff]
[    1.183066] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    1.189243] system 00:01: [io  0x0295-0x0296] has been reserved
[    1.195421] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[    1.201601] system 00:01: [io  0x0ca8-0x0caf] has been reserved
[    1.207778] system 00:01: [io  0x0800-0x080f] has been reserved
[    1.213959] system 00:01: [io  0x1000-0x107f] has been reserved
[    1.220137] system 00:01: [io  0x1180-0x11bf] has been reserved
[    1.226317] system 00:01: [io  0xfe00] has been reserved
[    1.231890] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    1.238765] system 00:01: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    1.245990] system 00:01: [mem 0xfec86000-0xfec86fff] could not be reserved
[    1.253218] system 00:01: [mem 0xfec89000-0xfec89fff] could not be reserved
[    1.260438] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.267319] system 00:01: [mem 0xfe000000-0xfe01ffff] has been reserved
[    1.274193] system 00:01: [mem 0xfe600000-0xfe6fffff] has been reserved
[    1.281072] system 00:01: [mem 0xfed20000-0xfed44fff] has been reserved
[    1.287946] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.294827] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.301893] pnp 00:02: [io  0x0000-0x001f]
[    1.306249] pnp 00:02: [io  0x0081-0x0091]
[    1.310607] pnp 00:02: [io  0x0093-0x009f]
[    1.314968] pnp 00:02: [io  0x00c0-0x00df]
[    1.319328] pnp 00:02: [dma 4]
[    1.322710] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.329514] pnp 00:03: [io  0x00f0-0x00fe]
[    1.333884] pnp 00:03: [irq 13]
[    1.337353] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.344260] pnp 00:04: [irq 0 disabled]
[    1.348361] pnp 00:04: [irq 8]
[    1.351681] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    1.356806] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.363643] pnp 00:05: [io  0x0070-0x0071]
[    1.368077] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.374883] pnp 00:06: [io  0x0061]
[    1.378705] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.385713] pnp 00:07: [mem 0xff000000-0xffffffff]
[    1.390846] pnp 00:07: Plug and Play ACPI device, IDs INT0800 (active)
[    1.397646] pnp 00:08: [io  0x0060]
[    1.401400] pnp 00:08: [io  0x0064]
[    1.405154] pnp 00:08: [irq 1]
[    1.408545] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.416252] pnp 00:09: [irq 12]
[    1.419736] pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.426837] pnp 00:0a: [io  0x03f8-0x03ff]
[    1.431199] pnp 00:0a: [irq 4]
[    1.434638] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.441735] pnp 00:0b: [io  0x02f8-0x02ff]
[    1.446100] pnp 00:0b: [irq 3]
[    1.449538] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.456747] pnp 00:0c: [io  0x03f0-0x03f5]
[    1.461105] pnp 00:0c: [io  0x03f7]
[    1.464852] pnp 00:0c: [irq 6]
[    1.468169] pnp 00:0c: [dma 2]
[    1.471589] pnp 00:0c: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.478528] pnp: PnP ACPI: found 13 devices
[    1.482972] ACPI: ACPI bus type pnp unregistered
[    1.498907] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd81fffff pref]
[    1.506600] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.511823] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    1.518177] pci 0000:00:01.0:   bridge window [mem 0xd8500000-0xd85fffff]
[    1.525223] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xd81fffff 64bit pref]
[    1.533440] pci 0000:00:03.0: PCI bridge to [bus 02]
[    1.538668] pci 0000:00:05.0: PCI bridge to [bus 03]
[    1.543904] pci 0000:05:00.0: PCI bridge to [bus 06]
[    1.549139] pci 0000:04:00.0: PCI bridge to [bus 05-06]
[    1.554637] pci 0000:07:01.0: BAR 6: assigned [mem 0xd8800000-0xd881ffff pref]
[    1.562332] pci 0000:04:00.3: PCI bridge to [bus 07]
[    1.567559] pci 0000:04:00.3:   bridge window [io  0x3000-0x3fff]
[    1.573911] pci 0000:04:00.3:   bridge window [mem 0xd8200000-0xd82fffff]
[    1.580957] pci 0000:04:00.3:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.589175] pci 0000:00:07.0: PCI bridge to [bus 04-07]
[    1.594660] pci 0000:00:07.0:   bridge window [io  0x3000-0x3fff]
[    1.601013] pci 0000:00:07.0:   bridge window [mem 0xd8200000-0xd83fffff]
[    1.608057] pci 0000:00:07.0:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.616268] pci 0000:08:00.0: BAR 6: assigned [mem 0xd8900000-0xd891ffff pref]
[    1.623962] pci 0000:08:00.1: BAR 6: assigned [mem 0xd8920000-0xd893ffff pref]
[    1.631648] pci 0000:00:09.0: PCI bridge to [bus 08]
[    1.636874] pci 0000:00:09.0:   bridge window [io  0x4000-0x4fff]
[    1.643227] pci 0000:00:09.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    1.650275] pci 0000:00:09.0:   bridge window [mem 0xd8900000-0xd89fffff 64bit pref]
[    1.658481] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    1.663705] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.670061] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff]
[    1.677115] pci 0000:00:1c.0:   bridge window [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    1.685326] pci 0000:0a:01.0: BAR 6: assigned [mem 0xd8620000-0xd863ffff pref]
[    1.693018] pci 0000:00:1e.0: PCI bridge to [bus 0a]
[    1.698242] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    1.704597] pci 0000:00:1e.0:   bridge window [mem 0xd8600000-0xd86fffff]
[    1.711643] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.719872] IOAPIC[2]: Set routing entry (10-0 -> 0x72 -> IRQ 48 Mode:1 Active:1 Dest:255)
[    1.728610] IOAPIC[2]: Set routing entry (10-2 -> 0x82 -> IRQ 50 Mode:1 Active:1 Dest:255)
[    1.737354] IOAPIC[2]: Set routing entry (10-4 -> 0x92 -> IRQ 52 Mode:1 Active:1 Dest:255)
[    1.746102] IOAPIC[2]: Set routing entry (10-6 -> 0xa2 -> IRQ 54 Mode:1 Active:1 Dest:255)
[    1.754855] IOAPIC[2]: Set routing entry (10-8 -> 0xb2 -> IRQ 56 Mode:1 Active:1 Dest:255)
[    1.763597] IOAPIC[0]: Set routing entry (8-16 -> 0xc2 -> IRQ 16 Mode:1 Active:1 Dest:255)
[    1.772333] pci 0000:00:1e.0: setting latency timer to 64
[    1.777995] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.783825] pci_bus 0000:00: resource 5 [mem 0x00000000-0x3fffffffff]
[    1.790533] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.796366] pci_bus 0000:01: resource 1 [mem 0xd8500000-0xd85fffff]
[    1.802893] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xd81fffff 64bit pref]
[    1.810588] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    1.816422] pci_bus 0000:04: resource 1 [mem 0xd8200000-0xd83fffff]
[    1.822948] pci_bus 0000:04: resource 2 [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.830644] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    1.836476] pci_bus 0000:07: resource 1 [mem 0xd8200000-0xd82fffff]
[    1.843007] pci_bus 0000:07: resource 2 [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.850697] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    1.856531] pci_bus 0000:08: resource 1 [mem 0xd8400000-0xd84fffff]
[    1.863056] pci_bus 0000:08: resource 2 [mem 0xd8900000-0xd89fffff 64bit pref]
[    1.870744] pci_bus 0000:09: resource 0 [io  0x6000-0x6fff]
[    1.876576] pci_bus 0000:09: resource 1 [mem 0xd8a00000-0xd8bfffff]
[    1.883102] pci_bus 0000:09: resource 2 [mem 0xd8c00000-0xd8dfffff 64bit pref]
[    1.890790] pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
[    1.896622] pci_bus 0000:0a: resource 1 [mem 0xd8600000-0xd86fffff]
[    1.903148] pci_bus 0000:0a: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.910836] pci_bus 0000:0a: resource 4 [io  0x0000-0xffff]
[    1.916668] pci_bus 0000:0a: resource 5 [mem 0x00000000-0x3fffffffff]
[    1.923412] NET: Registered protocol family 2
[    1.928819] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.940517] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.948477] TCP: Hash tables configured (established 524288 bind 65536)
[    1.955415] TCP: reno registered
[    1.958952] UDP hash table entries: 4096 (order: 6, 393216 bytes)
[    1.965516] UDP-Lite hash table entries: 4096 (order: 6, 393216 bytes)
[    1.972590] NET: Registered protocol family 1
[    1.977342] RPC: Registered named UNIX socket transport module.
[    1.983526] RPC: Registered udp transport module.
[    1.988490] RPC: Registered tcp transport module.
[    1.993456] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.000241] IOAPIC[0]: Set routing entry (8-20 -> 0xd2 -> IRQ 20 Mode:1 Active:1 Dest:255)
[    2.008989] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    2.015512] pci 0000:00:1d.0: Performing full reset
[    2.020674] IOAPIC[0]: Set routing entry (8-21 -> 0xe2 -> IRQ 21 Mode:1 Active:1 Dest:255)
[    2.029409] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    2.035940] pci 0000:00:1d.1: Performing full reset
[    2.041100] IOAPIC[0]: Set routing entry (8-22 -> 0x23 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    2.049836] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    2.056368] pci 0000:00:1d.2: Performing full reset
[    2.061526] IOAPIC[0]: Set routing entry (8-23 -> 0x43 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    2.070302] PCI: CLS mismatch (32 != 64), using 64 bytes
[    2.075881] pci 0000:08:00.0: Disabling L0s
[    2.086651] pci 0000:08:00.1: Disabling L0s
[    2.091099] pci 0000:0a:01.0: Boot video device
[    2.095961] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.102668] software IO TLB [mem 0xcbef6000-0xcfef5fff] (64MB) mapped at [ffff8800cbef6000-ffff8800cfef5fff]
[    2.113891] Simple Boot Flag at 0x41 set to 0x80
[    2.119028] Machine check injector initialized
[    2.125276] microcode: CPU0 sig=0x6fb, pf=0x40, revision=0xb4
[    2.131286] microcode: CPU1 sig=0x6fb, pf=0x40, revision=0xb4
[    2.137295] microcode: CPU2 sig=0x6fb, pf=0x40, revision=0xb4
[    2.143308] microcode: CPU3 sig=0x6fb, pf=0x40, revision=0xb4
[    2.149323] microcode: CPU4 sig=0x6fb, pf=0x40, revision=0xb4
[    2.155345] microcode: CPU5 sig=0x6fb, pf=0x40, revision=0xb4
[    2.161358] microcode: CPU6 sig=0x6fb, pf=0x40, revision=0xb4
[    2.167371] microcode: CPU7 sig=0x6fb, pf=0x40, revision=0xb4
[    2.173459] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.183103] audit: initializing netlink socket (disabled)
[    2.188781] type=2000 audit(1345040067.187:1): initialized
[    2.228406] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.242148] NFS: Registering the id_resolver key type
[    2.247483] Key type id_resolver registered
[    2.251922] Key type id_legacy registered
[    2.256198] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.263363] fuse init (API version 7.19)
[    2.267785] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.277925] NILFS version 2 loaded
[    2.282202] Btrfs loaded
[    2.285013] msgmni has been set to 15942
[    2.290216] async_tx: api initialized (async)
[    2.294963] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.302868] io scheduler noop registered
[    2.307051] io scheduler deadline registered
[    2.311589] io scheduler cfq registered (default)
[    2.316889] pcieport 0000:00:1c.0: irq 88 for MSI/MSI-X
[    2.322706] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.329118] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input0
[    2.338725] ACPI: Power Button [PWRB]
[    2.342749] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.350611] ACPI: Power Button [PWRF]
[    2.363118] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.369272] IOAPIC[2]: Set routing entry (10-9 -> 0x63 -> IRQ 57 Mode:1 Active:1 Dest:255)
[    2.378066] ioatdma 0000:00:0f.0: channel enumeration error
[    2.383903] ioatdma 0000:00:0f.0: Intel(R) I/OAT DMA Engine init failed
[    2.431867] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.458972] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.485813] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.513172] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.539729] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.545803] Initializing Nozomi driver 2.1d
[    2.550864] Non-volatile memory driver v1.3
[    2.555408] intel_rng: FWH not detected
[    2.559630] Linux agpgart interface v0.103
[    2.564091] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.573516] Hangcheck: Using getrawmonotonic().
[    2.578408] [drm] Initialized drm 1.1.0 20060810
[    2.586905] brd: module loaded
[    2.588627] loop: module loaded
[    2.583971] Floppy drive(s): fd0 is 1.44M
[    2.588878] ACPI Warning: 0x00000000fed1f410-0x00000000fed1f414 SystemMemory conflicts with Region \RCRB 1 (20120711/utaddress-251)
[    2.588883] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.588884] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[    2.589417] Loading iSCSI transport class v2.0-870.
[    2.590262] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    2.590263] Detecting Adaptec I2O RAID controllers...
[    2.590414] Adaptec aacraid driver 1.2-0[29800]-ms
[    2.590594] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    2.590671] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.590816] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.03-k.
[    2.590942] iscsi: registered transport (qla4xxx)
[    2.591013] QLogic iSCSI HBA Driver
[    2.591087] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    2.591173] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.591236] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    2.591310] mpt2sas version 13.100.00.00 loaded
[    2.591478] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    2.591763] ahci 0000:00:1f.2: version 3.0
[    2.591782] IOAPIC[0]: Set routing entry (8-17 -> 0x73 -> IRQ 17 Mode:1 Active:1 Dest:255)
[    2.722292]
[    2.722415] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.722418] ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part
[    2.722424] ahci 0000:00:1f.2: setting latency timer to 64
[    2.724065] scsi0 : ahci
[    2.724243] scsi1 : ahci
[    2.724409] scsi2 : ahci
[    2.724575] scsi3 : ahci
[    2.724754] scsi4 : ahci
[    2.724933] scsi5 : ahci
[    2.725093] ata1: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704500 irq 17
[    2.725096] ata2: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704580 irq 17
[    2.725098] ata3: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704600 irq 17
[    2.725100] ata4: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704680 irq 17
[    2.725103] ata5: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704700 irq 17
[    2.725105] ata6: SATA max UDMA/133 abar m1024@0xd8704400 port 0xd8704780 irq 17
[    2.725445] ata_piix 0000:00:1f.1: version 2.13
[    2.725491] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.726127] scsi6 : ata_piix
[    2.726332] scsi7 : ata_piix
[    2.726472] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
[    2.726473] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
[    2.726646] ata8: port disabled--ignoring
[    2.729659] tun: Universal TUN/TAP device driver, 1.6
[    2.729660] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.730060] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    2.730199] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    2.730200] Copyright (c) 2007 Atheros Corporation.
[    2.730491] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.12 (June 29, 2012)
[    2.730606] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    2.730676] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    2.730676]   http://www.scyld.com/network/drivers.html
[    2.730883] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    2.731037] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.731038] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.731063] IOAPIC[1]: Set routing entry (9-0 -> 0x83 -> IRQ 24 Mode:1 Active:1 Dest:255)
[    2.896482] ata7.00: ATAPI: LITE-ON COMBO SOHC-5236V, R$0G, max UDMA/44
[    2.896486] ata7.00: limited to UDMA/33 due to 40-wire cable
[    2.918291] ata7.00: configured for UDMA/33
[    2.960452] FDC 0 is a post-1991 82077
[    3.030029] ata5: SATA link down (SStatus 0 SControl 300)
[    3.035728] ata3: SATA link down (SStatus 0 SControl 300)
[    3.041424] ata6: SATA link down (SStatus 0 SControl 300)
[    3.047120] ata2: SATA link down (SStatus 0 SControl 300)
[    3.052838] ata4: SATA link down (SStatus 0 SControl 300)
[    3.120021] tsc: Refined TSC clocksource calibration: 2666.761 MHz
[    3.126473] Switching to clocksource tsc
[    3.137183] e1000 0000:07:01.0: eth0: (PCI:66MHz:32-bit) 00:0e:0c:c3:8f:a8
[    3.144325] e1000 0000:07:01.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.151526] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    3.157623] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    3.163871] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.0.1-k
[    3.171089] igb: Copyright (c) 2007-2012 Intel Corporation.
[    3.177199] igb 0000:08:00.0: irq 89 for MSI/MSI-X
[    3.182249] igb 0000:08:00.0: irq 90 for MSI/MSI-X
[    3.187310] igb 0000:08:00.0: irq 91 for MSI/MSI-X
[    3.192362] igb 0000:08:00.0: irq 92 for MSI/MSI-X
[    3.197415] igb 0000:08:00.0: irq 93 for MSI/MSI-X
[    3.202468] igb 0000:08:00.0: irq 94 for MSI/MSI-X
[    3.207529] igb 0000:08:00.0: irq 95 for MSI/MSI-X
[    3.211022] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.219033] ata1.00: ATA-7: Hitachi HDS721616PLA380, P22OAB3A, max UDMA/133
[    3.219036] igb 0000:08:00.0: irq 96 for MSI/MSI-X
[    3.219043] igb 0000:08:00.0: irq 97 for MSI/MSI-X
[    3.236353] ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.244862] ata1.00: configured for UDMA/133
[    3.249543] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72161 P22O PQ: 0 ANSI: 5
[    3.258412] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
[    3.259973] scsi 6:0:0:0: CD-ROM            LITE-ON  COMBO SOHC-5236V R$0G PQ: 0 ANSI: 5
[    3.274983] sd 0:0:0:0: [sda] Write Protect is off
[    3.280042] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.285372] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.345496]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.351271] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.396680] igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network Connection
[    3.403820] igb 0000:08:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:7c:cf:72
[    3.411292] igb 0000:08:00.0: eth1: PBA No: FFFFFF-0FF
[    3.416685] igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    3.431077] IOAPIC[2]: Set routing entry (10-22 -> 0x64 -> IRQ 70 Mode:1 Active:1 Dest:255)
[    3.440149] igb 0000:08:00.1: irq 98 for MSI/MSI-X
[    3.445206] igb 0000:08:00.1: irq 99 for MSI/MSI-X
[    3.450265] igb 0000:08:00.1: irq 100 for MSI/MSI-X
[    3.455405] igb 0000:08:00.1: irq 101 for MSI/MSI-X
[    3.460545] igb 0000:08:00.1: irq 102 for MSI/MSI-X
[    3.465686] igb 0000:08:00.1: irq 103 for MSI/MSI-X
[    3.470824] igb 0000:08:00.1: irq 104 for MSI/MSI-X
[    3.475961] igb 0000:08:00.1: irq 105 for MSI/MSI-X
[    3.481101] igb 0000:08:00.1: irq 106 for MSI/MSI-X
[    3.651658] igb 0000:08:00.1: Intel(R) Gigabit Ethernet Network Connection
[    3.658794] igb 0000:08:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:30:48:7c:cf:73
[    3.666265] igb 0000:08:00.1: eth2: PBA No: FFFFFF-0FF
[    3.671659] igb 0000:08:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    3.679754] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[    3.688048] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.694302] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.9.15-k
[    3.702513] ixgbe: Copyright (c) 1999-2012 Intel Corporation.
[    3.708586] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    3.715980] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    3.722017] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    3.728150] sky2: driver version 1.30
[    3.732204] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    3.739529] usbcore: registered new interface driver catc
[    3.745245] usbcore: registered new interface driver kaweth
[    3.751080] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    3.759083] usbcore: registered new interface driver pegasus
[    3.765062] usbcore: registered new interface driver rtl8150
[    3.771043] usbcore: registered new interface driver asix
[    3.776755] usbcore: registered new interface driver cdc_ether
[    3.782900] usbcore: registered new interface driver cdc_eem
[    3.788872] usbcore: registered new interface driver dm9601
[    3.794774] usbcore: registered new interface driver smsc75xx
[    3.800834] usbcore: registered new interface driver smsc95xx
[    3.806899] usbcore: registered new interface driver gl620a
[    3.812784] usbcore: registered new interface driver net1080
[    3.818759] usbcore: registered new interface driver plusb
[    3.824563] usbcore: registered new interface driver rndis_host
[    3.830800] usbcore: registered new interface driver cdc_subset
[    3.837038] usbcore: registered new interface driver zaurus
[    3.842928] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    3.850859] usbcore: registered new interface driver int51x1
[    3.856826] usbcore: registered new interface driver ipheth
[    3.862716] usbcore: registered new interface driver sierra_net
[    3.868951] usbcore: registered new interface driver cdc_ncm
[    3.874877] Fusion MPT base driver 3.04.20
[    3.879234] Copyright (c) 1999-2008 LSI Corporation
[    3.884383] Fusion MPT SPI Host driver 3.04.20
[    3.889156] Fusion MPT FC Host driver 3.04.20
[    3.893838] Fusion MPT SAS Host driver 3.04.20
[    3.898626] mptbase: ioc0: Initiating bringup
[    4.181006] ACPI: Invalid Power Resource to register!
[    4.181006] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[   21.491923] scsi8 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=478, IRQ=48
[   21.536235] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x50000d102db8057f)
[   21.645793] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19, phy 4, sas_addr 0x5000c50005811519
[   21.657115] scsi 8:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.670304] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 20, phy 5, sas_addr 0x5000c500064a81a1
[   21.672819] sd 8:0:0:0: [sdb] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.674887] sd 8:0:0:0: [sdb] Write Protect is off
[   21.674889] sd 8:0:0:0: [sdb] Mode Sense: b3 00 10 08
[   21.676573] sd 8:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.710997] scsi 8:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.724165] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 21, phy 6, sas_addr 0x5000c500064a80a9
[   21.726401]  sdb: sdb1 sdb2
[   21.726695] sd 8:0:1:0: [sdc] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.746496] sd 8:0:1:0: [sdc] Write Protect is off
[   21.746614] scsi 8:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.760118] sd 8:0:0:0: [sdb] Attached SCSI disk
[   21.760121] sd 8:0:1:0: [sdc] Mode Sense: b3 00 10 08
[   21.761333] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 22, phy 7, sas_addr 0x5000c500064a8145
[   21.761336] sd 8:0:2:0: [sdd] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.788575] sd 8:0:1:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.788590] scsi 8:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.789579] sd 8:0:2:0: [sdd] Write Protect is off
[   21.789581] sd 8:0:2:0: [sdd] Mode Sense: b3 00 10 08
[   21.817932] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 23, phy 8, sas_addr 0x5000c500064a3b79
[   21.820153] sd 8:0:2:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.822781] sd 8:0:3:0: [sde] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.846321] sd 8:0:3:0: [sde] Write Protect is off
[   21.846358] scsi 8:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.859975] sd 8:0:3:0: [sde] Mode Sense: b3 00 10 08
[   21.861439] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 25, phy 9, sas_addr 0x5000c500058131f9
[   21.863955] sd 8:0:4:0: [sdf] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.864251]  sdd: sdd1 sdd2
[   21.886589] scsi 8:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.886595]  sdc: sdc1 sdc2
[   21.889264] sd 8:0:4:0: [sdf] Write Protect is off
[   21.889267] sd 8:0:4:0: [sdf] Mode Sense: b3 00 10 08
[   21.908585] sd 8:0:3:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.917609] sd 8:0:4:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.926648] sd 8:0:2:0: [sdd] Attached SCSI disk
[   21.928082] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 26, phy 10, sas_addr 0x5000c5000647bd39
[   21.930775] sd 8:0:5:0: [sdg] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.949879] sd 8:0:1:0: [sdc] Attached SCSI disk
[   21.950683] scsi 8:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   21.963365] sd 8:0:5:0: [sdg] Write Protect is off
[   21.968454] sd 8:0:5:0: [sdg] Mode Sense: b3 00 10 08
[   21.969670] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 27, phy 11, sas_addr 0x5000c50005813305
[   21.969673] sd 8:0:6:0: [sdh] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   21.970835] scsi 8:0:7:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.000658] sd 8:0:6:0: [sdh] Write Protect is off
[   22.000663]  sde: sde1 sde2
[   22.000674]  sdf: sdf1 sdf2
[   22.011846] sd 8:0:6:0: [sdh] Mode Sense: b3 00 10 08
[   22.016940] sd 8:0:5:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.026148] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28, phy 12, sas_addr 0x5000c500064abf99
[   22.026180] sd 8:0:7:0: [sdi] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.044518] sd 8:0:6:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.045531] sd 8:0:7:0: [sdi] Write Protect is off
[   22.045534] sd 8:0:7:0: [sdi] Mode Sense: b3 00 10 08
[   22.045963] scsi 8:0:8:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.072449] sd 8:0:3:0: [sde] Attached SCSI disk
[   22.072456] sd 8:0:4:0: [sdf] Attached SCSI disk
[   22.072462] sd 8:0:7:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.098583] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 29, phy 13, sas_addr 0x5000c500064a7f1d
[   22.100964]  sdg: sdg1 sdg2
[   22.101244] sd 8:0:8:0: [sdj] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.123233] scsi 8:0:9:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.123791] sd 8:0:8:0: [sdj] Write Protect is off
[   22.123793] sd 8:0:8:0: [sdj] Mode Sense: b3 00 10 08
[   22.142166]  sdi: sdi1 sdi2
[   22.142169]  sdh: sdh1 sdh2
[   22.142171] sd 8:0:8:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.157285] sd 8:0:5:0: [sdg] Attached SCSI disk
[   22.166716] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30, phy 14, sas_addr 0x5000c5000647ecd9
[   22.169373] sd 8:0:9:0: [sdk] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.186084] sd 8:0:9:0: [sdk] Write Protect is off
[   22.186267] scsi 8:0:10:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.186718] sd 8:0:6:0: [sdh] Attached SCSI disk
[   22.211008] sd 8:0:9:0: [sdk] Mode Sense: b3 00 10 08
[   22.211011] sd 8:0:7:0: [sdi] Attached SCSI disk
[   22.211012]  sdj: sdj1 sdj2
[   22.216506] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31, phy 15, sas_addr 0x5000c500064a7935
[   22.234775] sd 8:0:10:0: [sdl] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.234989] scsi 8:0:11:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   22.236505] sd 8:0:9:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.262070] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32, phy 24, sas_addr 0x50000d102db8057e
[   22.266717] sd 8:0:8:0: [sdj] Attached SCSI disk
[   22.267155] sd 8:0:11:0: [sdm] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   22.285385] sd 8:0:10:0: [sdl] Write Protect is off
[   22.287046] sd 8:0:11:0: [sdm] Write Protect is off
[   22.287049] sd 8:0:11:0: [sdm] Mode Sense: b3 00 10 08
[   22.301085] sd 8:0:10:0: [sdl] Mode Sense: b3 00 10 08
[   22.301091] sd 8:0:11:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.304140] scsi 8:0:12:0: Enclosure         ADAPTEC  SANbloc S50      T016 PQ: 0 ANSI: 5
[   22.324220]  sdk: sdk1 sdk2
[   22.326390] sd 8:0:10:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   22.336379]  sdm: sdm1 sdm2
[   22.340568] Fusion MPT misc device (ioctl) driver 3.04.20
[   22.346323] mptctl: Registered with Fusion MPT base driver
[   22.352097] mptctl: /dev/mptctl @ (major,minor=10,220)
[   22.352892] sd 8:0:9:0: [sdk] Attached SCSI disk
[   22.353724] sd 8:0:11:0: [sdm] Attached SCSI disk
[   22.358940]  sdl: sdl1 sdl2
[   22.370447] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   22.373561] sd 8:0:10:0: [sdl] Attached SCSI disk
[   22.382191] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   22.388521] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   22.394611] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   22.400100] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   22.407971] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   22.417396] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[   22.426145] ehci_hcd 0000:00:1d.7: reset command 0010002 (park)=0 ithresh=1 period=1024 Reset HALT
[   22.439459] ehci_hcd 0000:00:1d.7: debug port 1
[   22.444247] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   22.451298] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   22.457320] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8704000
[   22.463245] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   22.477010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   22.483044] usb usb1: default language 0x0409
[   22.487670] usb usb1: udev 1, busnum 1, minor = 0
[   22.492631] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   22.499674] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.507363] usb usb1: Product: EHCI Host Controller
[   22.512502] usb usb1: Manufacturer: Linux 3.6.0-rc1 ehci_hcd
[   22.518420] usb usb1: SerialNumber: 0000:00:1d.7
[   22.523429] usb usb1: usb_probe_device
[   22.527446] usb usb1: configuration #1 chosen from 1 choice
[   22.533287] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   22.539365] hub 1-0:1.0: usb_probe_interface
[   22.543894] hub 1-0:1.0: usb_probe_interface - got id
[   22.549207] hub 1-0:1.0: USB hub found
[   22.553212] hub 1-0:1.0: 6 ports detected
[   22.557482] hub 1-0:1.0: standalone hub
[   22.561580] hub 1-0:1.0: no power switching (usb 1.0)
[   22.566894] hub 1-0:1.0: individual port over-current protection
[   22.573161] hub 1-0:1.0: power on to power good time: 20ms
[   22.578908] hub 1-0:1.0: local power source is good
[   22.584045] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   22.591312] uhci_hcd: USB Universal Host Controller Interface driver
[   22.597969] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   22.604057] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   22.609546] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   22.617408] uhci_hcd 0000:00:1d.0: detected 2 ports
[   22.622546] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   22.629501] uhci_hcd 0000:00:1d.0: Performing full reset
[   22.635085] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   22.641101] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[   22.647132] usb usb2: default language 0x0409
[   22.651755] usb usb2: udev 1, busnum 2, minor = 128
[   22.656897] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   22.663944] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.671630] usb usb2: Product: UHCI Host Controller
[   22.676760] usb usb2: Manufacturer: Linux 3.6.0-rc1 uhci_hcd
[   22.682680] usb usb2: SerialNumber: 0000:00:1d.0
[   22.687685] usb usb2: usb_probe_device
[   22.691698] usb usb2: configuration #1 chosen from 1 choice
[   22.697537] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 001803 0  ACK POWER sig=j CSC CONNECT
[   22.698015] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   22.698086] hub 2-0:1.0: usb_probe_interface
[   22.698087] hub 2-0:1.0: usb_probe_interface - got id
[   22.698089] hub 2-0:1.0: USB hub found
[   22.698093] hub 2-0:1.0: 2 ports detected
[   22.698094] hub 2-0:1.0: standalone hub
[   22.698096] hub 2-0:1.0: no power switching (usb 1.0)
[   22.698097] hub 2-0:1.0: individual port over-current protection
[   22.698098] hub 2-0:1.0: power on to power good time: 2ms
[   22.698101] hub 2-0:1.0: local power source is good
[   22.698103] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   22.698153] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[   22.698172] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   22.698174] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   22.698180] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   22.698186] uhci_hcd 0000:00:1d.1: detected 2 ports
[   22.698190] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   22.698191] uhci_hcd 0000:00:1d.1: Performing full reset
[   22.698206] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   22.698219] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[   22.698256] usb usb3: default language 0x0409
[   22.698261] usb usb3: udev 1, busnum 3, minor = 256
[   22.698263] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   22.698264] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.698266] usb usb3: Product: UHCI Host Controller
[   22.698267] usb usb3: Manufacturer: Linux 3.6.0-rc1 uhci_hcd
[   22.698269] usb usb3: SerialNumber: 0000:00:1d.1
[   22.698378] usb usb3: usb_probe_device
[   22.698380] usb usb3: configuration #1 chosen from 1 choice
[   22.698386] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   22.698455] hub 3-0:1.0: usb_probe_interface
[   22.698457] hub 3-0:1.0: usb_probe_interface - got id
[   22.698459] hub 3-0:1.0: USB hub found
[   22.698462] hub 3-0:1.0: 2 ports detected
[   22.698463] hub 3-0:1.0: standalone hub
[   22.698464] hub 3-0:1.0: no power switching (usb 1.0)
[   22.698466] hub 3-0:1.0: individual port over-current protection
[   22.698467] hub 3-0:1.0: power on to power good time: 2ms
[   22.698470] hub 3-0:1.0: local power source is good
[   22.698472] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   22.698516] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[   22.698536] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   22.698538] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   22.698544] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   22.698551] uhci_hcd 0000:00:1d.2: detected 2 ports
[   22.698555] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   22.698556] uhci_hcd 0000:00:1d.2: Performing full reset
[   22.698571] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   22.698585] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[   22.698614] usb usb4: default language 0x0409
[   22.698619] usb usb4: udev 1, busnum 4, minor = 384
[   22.698620] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   22.698622] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   22.698624] usb usb4: Product: UHCI Host Controller
[   22.698625] usb usb4: Manufacturer: Linux 3.6.0-rc1 uhci_hcd
[   22.698627] usb usb4: SerialNumber: 0000:00:1d.2
[   22.698735] usb usb4: usb_probe_device
[   22.698737] usb usb4: configuration #1 chosen from 1 choice
[   22.698742] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   22.698807] hub 4-0:1.0: usb_probe_interface
[   22.698809] hub 4-0:1.0: usb_probe_interface - got id
[   22.698810] hub 4-0:1.0: USB hub found
[   22.698814] hub 4-0:1.0: 2 ports detected
[   22.698815] hub 4-0:1.0: standalone hub
[   22.698816] hub 4-0:1.0: no power switching (usb 1.0)
[   22.698818] hub 4-0:1.0: individual port over-current protection
[   22.698819] hub 4-0:1.0: power on to power good time: 2ms
[   22.698822] hub 4-0:1.0: local power source is good
[   22.698823] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   22.698871] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[   22.698939] Initializing USB Mass Storage driver...
[   22.699016] usbcore: registered new interface driver usb-storage
[   22.699017] USB Mass Storage support registered.
[   22.699088] usbcore: registered new interface driver libusual
[   22.699147] usbcore: registered new interface driver ums-alauda
[   22.699203] usbcore: registered new interface driver ums-cypress
[   22.699258] usbcore: registered new interface driver ums-datafab
[   22.699311] usbcore: registered new interface driver ums-freecom
[   22.699367] usbcore: registered new interface driver ums-isd200
[   22.699422] usbcore: registered new interface driver ums-jumpshot
[   22.699476] usbcore: registered new interface driver ums-karma
[   22.699540] usbcore: registered new interface driver ums-onetouch
[   22.699595] usbcore: registered new interface driver ums-sddr09
[   22.699650] usbcore: registered new interface driver ums-sddr55
[   22.699709] usbcore: registered new interface driver ums-usbat
[   22.699838] usbcore: registered new interface driver usbserial
[   22.699895] usbcore: registered new interface driver usbserial_generic
[   22.699955] USB Serial support registered for generic
[   22.699957] usbserial: USB Serial Driver core
[   22.700015] usbcore: registered new interface driver belkin_sa
[   22.700075] USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   22.700134] usbcore: registered new interface driver mct_u232
[   22.700185] USB Serial support registered for MCT U232
[   22.700326] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[   22.700746] i8042: Warning: Keylock active
[   22.798017] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[   22.798051] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   22.798053] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   22.898009] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   22.951301] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.951553] mousedev: PS/2 mouse device common for all mice
[   22.952087] rtc_cmos 00:05: RTC can wake from S4
[   22.952274] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   22.952303] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   22.952416] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   22.952468] iTCO_vendor_support: vendor-support=0
[   22.952612] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   22.952614] md: linear personality registered for level -1
[   22.952615] md: raid0 personality registered for level 0
[   22.952616] md: raid1 personality registered for level 1
[   22.952617] md: raid10 personality registered for level 10
[   22.952618] md: raid6 personality registered for level 6
[   22.952619] md: raid5 personality registered for level 5
[   22.952619] md: raid4 personality registered for level 4
[   22.952620] md: multipath personality registered for level -4
[   22.952621] md: faulty personality registered for level -5
[   22.952802] device-mapper: uevent: version 1.0.3
[   22.952960] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   22.953072] device-mapper: multipath: version 1.5.0 loaded
[   22.953074] device-mapper: multipath round-robin: version 1.0.0 loaded
[   22.953075] device-mapper: multipath queue-length: version 0.1.0 loaded
[   22.953076] device-mapper: multipath service-time: version 0.2.0 loaded
[   22.953251] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   22.953259] cpuidle: using governor ladder
[   22.953260] cpuidle: using governor menu
[   22.953435] usbcore: registered new interface driver usbhid
[   22.953436] usbhid: USB HID core driver
[   22.953737] dell_wmi: No known WMI GUID found
[   22.953738] acer_wmi: Acer Laptop ACPI-WMI Extras
[   22.953745] acer_wmi: No or unsupported WMI interface, unable to load
[   22.953991] oprofile: using NMI interrupt.
[   22.954130] TCP: bic registered
[   22.954131] TCP: cubic registered
[   22.954132] TCP: westwood registered
[   22.954132] TCP: highspeed registered
[   22.954133] TCP: hybla registered
[   22.954134] TCP: htcp registered
[   22.954135] TCP: vegas registered
[   22.954135] TCP: veno registered
[   22.954136] TCP: scalable registered
[   22.954137] TCP: lp registered
[   22.954138] TCP: yeah registered
[   22.954138] TCP: illinois registered
[   22.954139] Initializing XFRM netlink socket
[   22.954144] NET: Registered protocol family 17
[   22.954155] NET: Registered protocol family 15
[   22.954180] Bridge firewalling registered
[   22.954201] Key type dns_resolver registered
[   22.955448]
[   22.955448] printing PIC contents
[   22.955452] ... PIC  IMR: ffff
[   22.955455] ... PIC  IRR: 0ca0
[   22.955464] ... PIC  ISR: 0000
[   22.955466] ... PIC ELCR: 0ea0
[   22.955472] printing local APIC contents on CPU#0/0:
[   22.955473] ... APIC ID:      00000000 (0)
[   22.955474] ... APIC VERSION: 00050014
[   22.955475] ... APIC TASKPRI: 00000000 (00)
[   22.955475] ... APIC PROCPRI: 00000000
[   22.955476] ... APIC LDR: 01000000
[   22.955476] ... APIC DFR: ffffffff
[   22.955477] ... APIC SPIV: 000001ff
[   22.955477] ... APIC ISR field:
[   22.955481] 0000000000000000000000000000000000000000000000000000000000000000
[   22.955482] ... APIC TMR field:
[   22.955485] 000000000000020000000000000c020002000000000000000004000000000000
[   22.955485] ... APIC IRR field:
[   22.955488] 0000000000000000000000000000000000000000000000000000000000000000
[   22.955489] ... APIC ESR: 00000000
[   22.955489] ... APIC ICR: 00000820
[   22.955490] ... APIC ICR2: 01000000
[   22.955490] ... APIC LVTT: 000000ef
[   22.955491] ... APIC LVTPC: 00000400
[   22.955491] ... APIC LVT0: 00010700
[   22.955492] ... APIC LVT1: 00000400
[   22.955492] ... APIC LVTERR: 000000fe
[   22.955493] ... APIC TMICT: 00f144b1
[   22.955494] ... APIC TMCCT: 00f07ef5
[   22.955494] ... APIC TDCR: 00000003
[   22.955495]
[   22.955496] number of MP IRQ sources: 15.
[   22.955497] number of IO-APIC #8 registers: 24.
[   22.955498] number of IO-APIC #9 registers: 24.
[   22.955499] number of IO-APIC #10 registers: 24.
[   22.955499] testing the IO APIC.......................
[   22.955506] IO APIC #8......
[   22.955507] .... register #00: 08000000
[   22.955508] .......    : physical APIC id: 08
[   22.955508] .......    : Delivery Type: 0
[   22.955509] .......    : LTS          : 0
[   22.955509] .... register #01: 00170020
[   22.955510] .......     : max redirection entries: 17
[   22.955511] .......     : PRQ implemented: 0
[   22.955511] .......     : IO APIC version: 20
[   22.955512] .... IRQ redirection table:
[   22.955512]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   22.955518]  00 00  1    0    0   0   0    0    0    00
[   22.955523]  01 01  0    0    0   0   0    1    1    41
[   22.955528]  02 FF  0    0    0   0   0    1    1    51
[   22.955532]  03 01  0    0    0   0   0    1    1    61
[   22.955537]  04 01  0    0    0   0   0    1    1    71
[   22.955542]  05 01  0    0    0   0   0    1    1    81
[   22.955547]  06 01  0    0    0   0   0    1    1    91
[   22.955552]  07 01  0    0    0   0   0    1    1    A1
[   22.955556]  08 01  0    0    0   0   0    1    1    B1
[   22.955561]  09 01  0    1    0   0   0    1    1    C1
[   22.955566]  0a 01  0    0    0   0   0    1    1    D1
[   22.955571]  0b 01  0    0    0   0   0    1    1    E1
[   22.955576]  0c 01  1    0    0   0   0    1    1    22
[   22.955580]  0d 01  0    0    0   0   0    1    1    42
[   22.955585]  0e FF  0    0    0   0   0    1    1    52
[   22.955589]  0f 01  0    0    0   0   0    1    1    62
[   22.955594]  10 FF  1    1    0   1   0    1    1    C2
[   22.955599]  11 FF  0    1    0   1   0    1    1    73
[   22.955604]  12 00  1    0    0   0   0    0    0    00
[   22.955609]  13 00  1    0    0   0   0    0    0    00
[   22.955613]  14 FF  0    1    0   1   0    1    1    D2
[   22.955619]  15 FF  0    1    0   1   0    1    1    E2
[   22.955623]  16 FF  0    1    0   1   0    1    1    23
[   22.955628]  17 FF  0    1    0   1   0    1    1    43
[   22.955631] IO APIC #9......
[   22.955631] .... register #00: 09000000
[   22.955632] .......    : physical APIC id: 09
[   22.955633] .......    : Delivery Type: 0
[   22.955633] .......    : LTS          : 0
[   22.955634] .... register #01: 00178020
[   22.955634] .......     : max redirection entries: 17
[   22.955635] .......     : PRQ implemented: 1
[   22.955635] .......     : IO APIC version: 20
[   22.955636] .... register #02: 09000000
[   22.955636] .......     : arbitration: 09
[   22.955637] .... register #03: 00000001
[   22.955638] .......     : Boot DT    : 1
[   22.955638] .... IRQ redirection table:
[   22.955639]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   22.955641]  00 FF  1    1    0   1   0    1    1    83
[   22.955644]  01 00  1    0    0   0   0    0    0    00
[   22.955647]  02 00  1    0    0   0   0    0    0    00
[   22.955650]  03 00  1    0    0   0   0    0    0    00
[   22.955652]  04 00  1    0    0   0   0    0    0    00
[   22.955655]  05 00  1    0    0   0   0    0    0    00
[   22.955658]  06 00  1    0    0   0   0    0    0    00
[   22.955660]  07 00  1    0    0   0   0    0    0    00
[   22.955663]  08 00  1    0    0   0   0    0    0    00
[   22.955666]  09 00  1    0    0   0   0    0    0    00
[   22.955668]  0a 00  1    0    0   0   0    0    0    00
[   22.955671]  0b 00  1    0    0   0   0    0    0    00
[   22.955674]  0c 00  1    0    0   0   0    0    0    00
[   22.955676]  0d 00  1    0    0   0   0    0    0    00
[   22.955679]  0e 00  1    0    0   0   0    0    0    00
[   22.955682]  0f 00  1    0    0   0   0    0    0    00
[   22.955684]  10 00  1    0    0   0   0    0    0    00
[   22.955687]  11 00  1    0    0   0   0    0    0    00
[   22.955690]  12 00  1    0    0   0   0    0    0    00
[   22.955692]  13 00  1    0    0   0   0    0    0    00
[   22.955695]  14 00  1    0    0   0   0    0    0    00
[   22.955698]  15 00  1    0    0   0   0    0    0    00
[   22.955700]  16 00  1    0    0   0   0    0    0    00
[   22.955703]  17 00  1    0    0   0   0    0    0    00
[   22.955705] IO APIC #10......
[   22.955706] .... register #00: 0A000000
[   22.955706] .......    : physical APIC id: 0A
[   22.955707] .......    : Delivery Type: 0
[   22.955707] .......    : LTS          : 0
[   22.955708] .... register #01: 00170020
[   22.955709] .......     : max redirection entries: 17
[   22.955709] .......     : PRQ implemented: 0
[   22.955710] .......     : IO APIC version: 20
[   22.955710] .... register #02: 00000000
[   22.955711] .......     : arbitration: 00
[   22.955711] .... register #03: 00000001
[   22.955712] .......     : Boot DT    : 1
[   22.955712] .... IRQ redirection table:
[   22.955713]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[   22.955715]  00 FF  0    1    0   1   0    1    1    72
[   22.955718]  01 00  1    0    0   0   0    0    0    00
[   22.955721]  02 FF  1    1    0   1   0    1    1    82
[   22.955723]  03 00  1    0    0   0   0    0    0    00
[   22.955726]  04 FF  1    1    0   1   0    1    1    92
[   22.955728]  05 00  1    0    0   0   0    0    0    00
[   22.955731]  06 FF  1    1    0   1   0    1    1    A2
[   22.955734]  07 00  1    0    0   0   0    0    0    00
[   22.955736]  08 FF  1    1    0   1   0    1    1    B2
[   22.955739]  09 FF  1    1    0   1   0    1    1    63
[   22.955741]  0a 00  1    0    0   0   0    0    0    00
[   22.955744]  0b 00  1    0    0   0   0    0    0    00
[   22.955746]  0c 00  1    0    0   0   0    0    0    00
[   22.955749]  0d 00  1    0    0   0   0    0    0    00
[   22.955752]  0e 00  1    0    0   0   0    0    0    00
[   22.955754]  0f 00  1    0    0   0   0    0    0    00
[   22.955757]  10 00  1    0    0   0   0    0    0    00
[   22.955759]  11 00  1    0    0   0   0    0    0    00
[   22.955762]  12 00  1    0    0   0   0    0    0    00
[   22.955764]  13 00  1    0    0   0   0    0    0    00
[   22.955767]  14 00  1    0    0   0   0    0    0    00
[   22.955770]  15 00  1    0    0   0   0    0    0    00
[   22.955772]  16 FF  1    1    0   1   0    1    1    64
[   22.955775]  17 00  1    0    0   0   0    0    0    00
[   22.955775] IRQ to pin mappings:
[   22.955777] IRQ0 -> 0:2
[   22.955778] IRQ1 -> 0:1
[   22.955780] IRQ3 -> 0:3
[   22.955781] IRQ4 -> 0:4
[   22.955782] IRQ5 -> 0:5
[   22.955783] IRQ6 -> 0:6
[   22.955785] IRQ7 -> 0:7
[   22.955786] IRQ8 -> 0:8
[   22.955787] IRQ9 -> 0:9
[   22.955788] IRQ10 -> 0:10
[   22.955790] IRQ11 -> 0:11
[   22.955791] IRQ12 -> 0:12
[   22.955792] IRQ13 -> 0:13
[   22.955793] IRQ14 -> 0:14
[   22.955795] IRQ15 -> 0:15
[   22.955796] IRQ16 -> 0:16
[   22.955797] IRQ17 -> 0:17
[   22.955799] IRQ20 -> 0:20
[   22.955800] IRQ21 -> 0:21
[   22.955801] IRQ22 -> 0:22
[   22.955802] IRQ23 -> 0:23
[   22.955804] IRQ24 -> 1:0
[   22.955805] IRQ48 -> 2:0
[   22.955806] IRQ50 -> 2:2
[   22.955808] IRQ52 -> 2:4
[   22.955809] IRQ54 -> 2:6
[   22.955810] IRQ56 -> 2:8
[   22.955812] IRQ57 -> 2:9
[   22.955813] IRQ70 -> 2:22
[   22.955816] .................................... done.
[   22.956030] PM: Hibernation image not present or could not be loaded.
[   22.956044] registered taskstats version 1
[   22.956499]   Magic number: 8:790:232
[   22.956634] tty ttyv2: hash matches
[   22.956762] netpoll: netconsole: local port 6667
[   22.956764] netpoll: netconsole: local IP 192.168.3.78
[   22.956764] netpoll: netconsole: interface 'eth1'
[   22.956765] netpoll: netconsole: remote port 6666
[   22.956766] netpoll: netconsole: remote IP 192.168.1.1
[   22.956767] netpoll: netconsole: remote ethernet address 00:1b:21:11:78:3e
[   22.956768] netpoll: netconsole: device eth1 not up yet, forcing it
[   23.704018] usb usb3: suspend_rh (auto-stop)
[   23.704046] usb usb4: suspend_rh (auto-stop)
[   23.954024] usb usb2: suspend_rh (auto-stop)
[   24.425305] hub 1-0:1.0: port 2: status 0501 change 0001
[   24.530016] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[   24.535773] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   24.593272] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[   24.594002] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003801 0  ACK POWER OWNER sig=j CONNECT
[   24.609128] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[   24.665011] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   24.674272] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[   24.680025] ehci_hcd 0000:00:1d.7: GetStatus port:2 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   24.689271] hub 1-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[   24.704017] usb usb2: wakeup_rh (auto-start)
[   24.799010] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[   24.806875] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   24.812625] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[   24.818196] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   24.928010] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[   25.004483] igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   25.016607] console [netcon0] enabled
[   25.020539] netconsole: network logging started
[   25.025357] rtc_cmos 00:05: setting system clock to 2012-08-15 14:14:53 UTC (1345040093)
[   25.037015] usb 2-2: new full-speed USB device number 2 using uhci_hcd
[   25.045037] IP-Config: Complete:
[   25.048531]      device=eth1, addr=192.168.1.58, mask=255.255.255.0, gw=192.168.1.1
[   25.056667]      host=lkp-st02-x8664, domain=, nis-domain=(none)
[   25.062933]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   25.070141] ALSA device list:
[   25.073374]   No soundcards found.
[   25.077093] md: Waiting for all devices to be available before autodetect
[   25.084141] md: If you don't use raid, use raid=noautodetect
[   25.090331] md: Autodetecting RAID arrays.
[   25.094691] md: Scanned 0 and added 0 devices.
[   25.099392] md: autorun ...
[   25.102445] md: ... autorun DONE.
[   25.164016] usb 2-2: ep0 maxpacket = 8
[   25.185570] usb 2-2: udev 2, busnum 2, minor = 129
[   25.190630] usb 2-2: New USB device found, idVendor=0557, idProduct=8021
[   25.197586] usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   25.205091] usb 2-2: usb_probe_device
[   25.209009] usb 2-2: configuration #1 chosen from 1 choice
[   25.217563] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[   25.223555] hub 2-2:1.0: usb_probe_interface
[   25.228085] hub 2-2:1.0: usb_probe_interface - got id
[   25.233397] hub 2-2:1.0: USB hub found
[   25.238563] hub 2-2:1.0: 4 ports detected
[   25.242836] hub 2-2:1.0: standalone hub
[   25.246934] hub 2-2:1.0: individual port power switching
[   25.252507] hub 2-2:1.0: individual port over-current protection
[   25.258772] hub 2-2:1.0: power on to power good time: 100ms
[   25.267562] hub 2-2:1.0: local power source is good
[   25.272702] hub 2-2:1.0: enabling power on all ports
[   25.382559] hub 2-2:1.0: port 1: status 0301 change 0001
[   25.491012] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   25.499315] hub 2-2:1.0: state 7 ports 4 chg 0002 evt 0000
[   25.506565] hub 2-2:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[   25.577564] usb 2-2.1: new low-speed USB device number 3 using uhci_hcd
[   26.111519] VFS: Mounted root (nfs filesystem) on device 0:14.
[   26.117885] devtmpfs: mounted
[   26.121761] Freeing unused kernel memory: 976k freed
[   26.543060] udevd[2221]: starting version 175
[   30.585573] usb 2-2.1: khubd timed out on ep0in len=0/64
[   30.594556] usb 2-2.1: uhci_result_common: failed with status 440000
[   30.604555] usb 2-2.1: uhci_result_common: failed with status 440000
[   30.676575] usb 2-2.1: device descriptor read/64, error -71
[   31.228114] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   31.237804] NFSD: starting 90-second grace period
[   32.412143] md: md0 stopped.
[   32.643458] md: bind<sdb1>
[   32.647422] md: bind<sdc1>
[   32.650630] md: bind<sdd1>
[   32.653835] md: bind<sde1>
[   32.657028] md: bind<sdf1>
[   32.660221] md: bind<sdg1>
[   32.663406] md: bind<sdh1>
[   32.666598] md: bind<sdi1>
[   32.669792] md: bind<sdj1>
[   32.672991] md: bind<sdk1>
[   32.676190] md: bind<sdl1>
[   32.679364] md: bind<sdm1>
[   32.690820] bio: create slab <bio-1> at 1
[   32.695106] md/raid0:md0: md_size is 1054752768 sectors.
[   32.700682] md: RAID0 configuration for md0 - 1 zone
[   32.705906] md: zone0=[sdb1/sdc1/sdd1/sde1/sdf1/sdg1/sdh1/sdi1/sdj1/sdk1/sdl1/sdm1]
[   32.714943]       zone-offset=         0KB, device-offset=         0KB, size= 527376384KB
[   32.723586]
[   32.725368] md0: detected capacity change from 0 to 540033417216
[   32.733571]  md0: unknown partition table
[   35.784573] usb 2-2.1: khubd timed out on ep0in len=0/64
[   35.793575] usb 2-2.1: uhci_result_common: failed with status 440000
[   35.803567] usb 2-2.1: uhci_result_common: failed with status 440000
[   35.875566] usb 2-2.1: device descriptor read/64, error -71
[   36.048574] usb 2-2.1: new low-speed USB device number 4 using uhci_hcd
[   36.293247] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
[   41.056588] usb 2-2.1: khubd timed out on ep0in len=0/64
[   41.066568] usb 2-2.1: uhci_result_common: failed with status 440000
[   41.076573] usb 2-2.1: uhci_result_common: failed with status 440000
[   41.148589] usb 2-2.1: device descriptor read/64, error -71
[   46.257220] usb 2-2.1: khubd timed out on ep0in len=0/64
[   46.266210] usb 2-2.1: uhci_result_common: failed with status 440000
[   46.277197] usb 2-2.1: uhci_result_common: failed with status 440000
[   46.349171] usb 2-2.1: device descriptor read/64, error -71
[   46.522091] usb 2-2.1: new low-speed USB device number 5 using uhci_hcd
[   51.529590] usb 2-2.1: khubd timed out on ep0out len=0/0
[   51.739477] usb 2-2.1: uhci_result_common: failed with status 440000
[   51.947012] usb 2-2.1: device not accepting address 5, error -71
[   52.018346] usb 2-2.1: new low-speed USB device number 6 using uhci_hcd
[   57.026864] usb 2-2.1: khubd timed out on ep0out len=0/0
[   57.237727] usb 2-2.1: uhci_result_common: failed with status 440000
[   57.445012] usb 2-2.1: device not accepting address 6, error -71
[   57.452630] hub 2-2:1.0: unable to enumerate USB device on port 1
[   57.459632] hub 2-2:1.0: state 7 ports 4 chg 0000 evt 0002
[  642.237856] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  642.238831] IP: [<ffffffff811f8937>] ext4_ext_remove_space+0x825/0xba3
[  642.238831] PGD 218b13067 PUD 2202d8067 PMD 0
[  642.238831] Oops: 0000 [#1] SMP
[  642.238831] Modules linked in:
[  642.238831] CPU 0
[  642.238831] Pid: 4077, comm: rm Not tainted 3.6.0-rc1 #1 Supermicro X7DW3/X7DWN
[  642.238831] RIP: 0010:[<ffffffff811f8937>]  [<ffffffff811f8937>] ext4_ext_remove_space+0x825/0xba3
[  642.238831] RSP: 0018:ffff880204eb3cb8  EFLAGS: 00010246
[  642.238831] RAX: 0000000000000000 RBX: ffff880220fb00d0 RCX: 0000000000000000
[  642.238831] RDX: 0000000000008402 RSI: 0000000000008402 RDI: 0000000007dbc800
[  642.238831] RBP: ffff880204eb3d98 R08: 0000000007dbc800 R09: ffff880220fb0018
[  642.238831] R10: ffff88021a544000 R11: ffffffff811f8b4d R12: ffff88008c6cee40
[  642.238831] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88008c6cee70
[  642.238831] FS:  00007ff87f860700(0000) GS:ffff88022f400000(0000) knlGS:0000000000000000
[  642.238831] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  642.238831] CR2: 0000000000000028 CR3: 000000021e418000 CR4: 00000000000007f0
[  642.238831] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  642.238831] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  642.238831] Process rm (pid: 4077, threadinfo ffff880204eb2000, task ffff880221921740)
[  642.238831] Stack:
[  642.238831]  ffffffff819caec0 ffff880211147dc8 ffff880220fb00d0 ffff880211147dc8
[  642.238831]  ffff880220ace0d0 0000000001258000 ffff880204eb3d38 ffffffff811d6b05
[  642.238831]  8000880200000000 ffff880220fb0000 ffff8802227fc800 ffff88008c6ceea0
[  642.238831] Call Trace:
[  642.238831]  [<ffffffff811d6b05>] ? ext4_mark_iloc_dirty+0x47a/0x557
[  642.238831]  [<ffffffff811fa660>] ext4_ext_truncate+0xd8/0x176
[  642.238831]  [<ffffffff811d6de8>] ? ext4_mark_inode_dirty+0x17e/0x1c0
[  642.238831]  [<ffffffff811d4934>] ext4_truncate+0x7a/0xca
[  642.238831]  [<ffffffff811d8aa2>] ext4_evict_inode+0x2e9/0x422
[  642.238831]  [<ffffffff81163e17>] evict+0xae/0x163
[  642.238831]  [<ffffffff811640c4>] iput+0x1bb/0x1c3
[  642.238831]  [<ffffffff8115a2ca>] do_unlinkat+0x102/0x157
[  642.238831]  [<ffffffff813d54ce>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  642.238831]  [<ffffffff8115bf97>] sys_unlinkat+0x22/0x2d
[  642.238831]  [<ffffffff819851e9>] system_call_fastpath+0x16/0x1b
[  642.238831] Code: ff ff 44 8b 4d b0 48 c7 40 28 00 00 00 00 41 ff c9 e9 e8 00 00 00 4d 63 f5 4d 6b fe 30 4d 01 e7 49 83 7f 20 00 75 0c 49 8b 47 28 <48> 8b 40 28 49 89 47 20 49 8b 47 18 48 85 c0 75 1f 49 8b 47 20
[  642.238831] RIP  [<ffffffff811f8937>] ext4_ext_remove_space+0x825/0xba3
[  642.238831]  RSP <ffff880204eb3cb8>
[  642.238831] CR2: 0000000000000028
[  642.504923] ---[ end trace a98ae0f411f1be74 ]---
w
