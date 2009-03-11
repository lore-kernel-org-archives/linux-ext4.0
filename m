From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 15:57:16 +1030
Message-ID: <1236749236.16191.45.camel@kulgan.wumi.org.au>
References: <1236655451.30280.29.camel@kulgan.wumi.org.au>
	 <49B5EDFE.8060405@redhat.com>
	 <1236661371.30280.33.camel@kulgan.wumi.org.au>
	 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
	 <1236719691.16191.9.camel@kulgan.wumi.org.au>
	 <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int>
	 <1236735808.16191.23.camel@kulgan.wumi.org.au>
	 <1236736137.16191.25.camel@kulgan.wumi.org.au>
	 <20090311045051.GA13698@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:36363 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZCKF1W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2009 01:27:22 -0400
In-Reply-To: <20090311045051.GA13698@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-03-11 at 00:50 -0400, Theodore Tso wrote:
> Can you tell us something about the hardware that is behind this
> filesystem?  What sort of disks, raid controller if any, etc. are you
> using?

Sure.

This is a Xeon X3350 quad-core system on an Intel 3210SHLC motherboard,
with 8GB ECC RAM. The filesystem is on top of LVM which is on top of
RAID6 using the md driver. The RAID is comprised of 9 1TB SATA drives, a
mix of Samsung and WDC, using the on-board Intel AHCI SATA controller
and an additional Silicon Image 3132 PCI-e controller and a 5:1 port
multiplier (Sil3726, I think).

Below is the full dmesg after 14 days uptime. Includes bringing the RAID
up from 7/9 to 9/9 and various messing around with the ext4 filesystems.

Cheers,
Kevin.
--

Linux version 2.6.29-rc6 (kmshanah@ucwb-kvm-10) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Tue Feb 24 22:24:06 CST 2009
Command line: BOOT_IMAGE=/vmlinuz-2.6.29-rc6 root=/dev/md1 ro
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
 BIOS-e820: 000000000009c800 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfcf0000 (usable)
 BIOS-e820: 00000000dfcf0000 - 00000000dfd96000 (ACPI NVS)
 BIOS-e820: 00000000dfd96000 - 00000000dfdfa000 (usable)
 BIOS-e820: 00000000dfdfa000 - 00000000dfe5f000 (reserved)
 BIOS-e820: 00000000dfe5f000 - 00000000dfe69000 (usable)
 BIOS-e820: 00000000dfe69000 - 00000000dfedf000 (ACPI NVS)
 BIOS-e820: 00000000dfedf000 - 00000000dfee6000 (usable)
 BIOS-e820: 00000000dfee6000 - 00000000dfeff000 (ACPI data)
 BIOS-e820: 00000000dfeff000 - 00000000dff00000 (usable)
 BIOS-e820: 00000000dff00000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fff80000 - 00000000fff8c000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
DMI 2.5 present.
last_pfn = 0x220000 max_arch_pfn = 0x100000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3GB, range: 512MB, type WB
reg 3, base: 3583MB, range: 1MB, type UC
reg 4, base: 4GB, range: 4GB, type WB
reg 5, base: 8GB, range: 512MB, type WB
total RAM coverred: 8191M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 2M 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3GB, range: 512MB, type WB
reg 3, base: 3583MB, range: 1MB, type UC
reg 4, base: 4GB, range: 4GB, type WB
reg 5, base: 8GB, range: 512MB, type WB
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xdff00 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000dff00000
 0000000000 - 00dfe00000 page 2M
 00dfe00000 - 00dff00000 page 4k
kernel direct mapping tables up to dff00000 @ 8000-e000
last_map_addr: dff00000 end: dff00000
init_memory_mapping: 0000000100000000-0000000220000000
 0100000000 - 0220000000 page 2M
kernel direct mapping tables up to 220000000 @ c000-16000
last_map_addr: 220000000 end: 220000000
ACPI: RSDP 000F03C0, 0024 (r2 INTEL )
ACPI: XSDT DFEFE120, 00A4 (r1 INTEL  S3200SHC        0 INTL  1000013)
ACPI: SLIC DFEFC000, 0176 (r1 INTEL  S3200SHC        2 INTL  1000013)
ACPI: FACP DFEFA000, 00F4 (r3 INTEL  S3200SHC        0 MSFT  1000013)
ACPI Warning (tbfadt-0568): 32/64X length mismatch in PmTimerBlock: 32/24 [20081204]
ACPI Warning (tbfadt-0412): Invalid length for PmTimerBlock: 24, using default 32 [20081204]
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT DFEF4000, 568D (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: FACS DFE69000, 0040
ACPI: APIC DFEF3000, 0084 (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: WDDT DFEF2000, 0040 (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: MCFG DFEF1000, 003C (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: HPET DFEF0000, 0038 (r1 INTEL  S3200SHC        1 MSFT  1000013)
ACPI: SPCR DFEEF000, 0050 (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: SSDT DFEEE000, 0175 (r1 INTEL   Cpu0Ist       10 MSFT  1000013)
ACPI: SSDT DFEED000, 0175 (r1 INTEL   Cpu1Ist       10 MSFT  1000013)
ACPI: SSDT DFEEC000, 0175 (r1 INTEL   Cpu2Ist       10 MSFT  1000013)
ACPI: SSDT DFEEB000, 0175 (r1 INTEL   Cpu3Ist       10 MSFT  1000013)
ACPI: SSDT DFEEA000, 01BC (r1 INTEL     CpuPm       10 MSFT  1000013)
ACPI: HEST DFEE9000, 00A8 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: BERT DFEE8000, 0030 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: ERST DFEE7000, 0230 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: EINJ DFEE6000, 0130 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 0220000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00007df9c4]    TEXT DATA BSS ==> [0000200000 - 00007df9c4]
  #3 [000009c800 - 0000100000]    BIOS reserved ==> [000009c800 - 0000100000]
  #4 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #5 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
found SMP MP-table at [ffff8800000fd270] 000fd270
 [ffffe20000000000-ffffe200077fffff] PMD -> [ffff880028200000-ffff88002f9fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00220000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000009c
    0: 0x00000100 -> 0x000dfcf0
    0: 0x000dfd96 -> 0x000dfdfa
    0: 0x000dfe5f -> 0x000dfe69
    0: 0x000dfedf -> 0x000dfee6
    0: 0x000dfeff -> 0x000dff00
    0: 0x00100000 -> 0x00220000
On node 0 totalpages: 2096386
  DMA zone: 56 pages used for memmap
  DMA zone: 1616 pages reserved
  DMA zone: 2324 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 898462 pages, LIFO batch:31
  Normal zone: 16128 pages used for memmap
  Normal zone: 1163520 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: IOAPIC (id[0x05] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 5, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at e1000000 (gap: e0000000:10000000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 45056 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064306
Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.29-rc6 root=/dev/md1 ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 2659.997 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 8176948k/8912896k available (3452k kernel code, 527352k absent, 207624k reserved, 1566k data, 400k init)
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 5322.66 BogoMIPS (lpj=8866656)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Freeing SMP alternatives: 33k freed
ACPI: Core revision 20081204
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X3350  @ 2.66GHz stepping 07
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5322.67 BogoMIPS (lpj=8866675)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(R) CPU           X3350  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x1 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5322.64 BogoMIPS (lpj=8866633)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(R) CPU           X3350  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5322.66 BogoMIPS (lpj=8866661)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
[ds] using Core 2/Atom configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(R) CPU           X3350  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (21288.64 BogoMIPS).
net_namespace: 1344 bytes
xor: automatically using best checksumming function: generic_sse
   generic_sse:  9922.800 MB/sec
xor: using function: generic_sse (9922.800 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:19.0: reg 10 32bit mmio: [0xe1d00000-0xe1d1ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xe1d20000-0xe1d20fff]
pci 0000:00:19.0: reg 18 io port: [0x40e0-0x40ff]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x40c0-0x40df]
pci 0000:00:1a.1: reg 20 io port: [0x40a0-0x40bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xe1d21c00-0xe1d21fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xe1d21800-0xe1d21bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0680 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0800 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0600 (mask 007f)
pci 0000:00:1f.2: reg 10 io port: [0x4408-0x440f]
pci 0000:00:1f.2: reg 14 io port: [0x4414-0x4417]
pci 0000:00:1f.2: reg 18 io port: [0x4400-0x4407]
pci 0000:00:1f.2: reg 1c io port: [0x4410-0x4413]
pci 0000:00:1f.2: reg 20 io port: [0x4020-0x403f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xe1d21000-0xe1d217ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 64bit mmio: [0xe1d22000-0xe1d220ff]
pci 0000:00:1f.3: reg 20 io port: [0x4000-0x401f]
pci 0000:01:00.0: reg 10 32bit mmio: [0xe1c00000-0xe1c01fff]
pci 0000:01:00.0: PME# supported from D0 D3hot
pci 0000:01:00.0: PME# disabled
pci 0000:00:06.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:06.0: bridge 32bit mmio: [0xe1b00000-0xe1cfffff]
pci 0000:02:08.0: reg 10 io port: [0x3000-0x30ff]
pci 0000:02:08.0: reg 14 64bit mmio: [0xe1b00000-0xe1b1ffff]
pci 0000:02:08.0: reg 1c 64bit mmio: [0xe1b20000-0xe1b3ffff]
pci 0000:02:08.0: reg 30 32bit mmio: [0xfff00000-0xffffffff]
pci 0000:02:08.0: supports D1 D2
pci 0000:01:00.0: bridge io port: [0x3000-0x3fff]
pci 0000:01:00.0: bridge 32bit mmio: [0xe1b00000-0xe1bfffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xe1a04000-0xe1a0407f]
pci 0000:03:00.0: reg 18 64bit mmio: [0xe1a00000-0xe1a03fff]
pci 0000:03:00.0: reg 20 io port: [0x2000-0x207f]
pci 0000:03:00.0: reg 30 32bit mmio: [0xfff80000-0xffffffff]
pci 0000:03:00.0: supports D1 D2
pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xe1a00000-0xe1afffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xe0000000-0xe0ffffff]
pci 0000:04:00.0: reg 14 32bit mmio: [0xe1800000-0xe1803fff]
pci 0000:04:00.0: reg 18 32bit mmio: [0xe1000000-0xe17fffff]
pci 0000:04:00.0: reg 30 32bit mmio: [0xffff0000-0xffffffff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xe1000000-0xe18fffff]
pci 0000:00:1c.4: bridge 64bit mmio pref: [0xe0000000-0xe0ffffff]
pci 0000:05:02.0: reg 10 32bit mmio: [0xe1920000-0xe193ffff]
pci 0000:05:02.0: reg 14 32bit mmio: [0xe1900000-0xe191ffff]
pci 0000:05:02.0: reg 18 io port: [0x1000-0x103f]
pci 0000:05:02.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:05:02.0: PME# supported from D0 D3hot D3cold
pci 0000:05:02.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xe1900000-0xe19fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff could not be reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0xca0-0xcaf has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
system 00:06: ioport range 0x800-0x87f has been reserved
system 00:06: ioport range 0x600-0x61f has been reserved
pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
pci 0000:01:00.0:   IO window: 0x3000-0x3fff
pci 0000:01:00.0:   MEM window: 0xe1b00000-0xe1bfffff
pci 0000:01:00.0:   PREFETCH window: 0x000000e1e00000-0x000000e1efffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
pci 0000:00:06.0:   IO window: 0x3000-0x3fff
pci 0000:00:06.0:   MEM window: 0xe1b00000-0xe1cfffff
pci 0000:00:06.0:   PREFETCH window: 0x000000e1e00000-0x000000e1efffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xe1a00000-0xe1afffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000e1f00000-0x000000e1ffffff
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: 0xe1000000-0xe18fffff
pci 0000:00:1c.4:   PREFETCH window: 0x000000e0000000-0x000000e0ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0xe1900000-0xe19fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: setting latency timer to 64
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:01:00.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:01: resource 1 mem: [0xe1b00000-0xe1cfffff]
pci_bus 0000:01: resource 2 mem: [0xe1e00000-0xe1efffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:02: resource 1 mem: [0xe1b00000-0xe1bfffff]
pci_bus 0000:02: resource 2 mem: [0xe1e00000-0xe1efffff]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:03: resource 1 mem: [0xe1a00000-0xe1afffff]
pci_bus 0000:03: resource 2 mem: [0xe1f00000-0xe1ffffff]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 mem: [0x0-0x0]
pci_bus 0000:04: resource 1 mem: [0xe1000000-0xe18fffff]
pci_bus 0000:04: resource 2 mem: [0xe0000000-0xe0ffffff]
pci_bus 0000:04: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:05: resource 1 mem: [0xe1900000-0xe19fffff]
pci_bus 0000:05: resource 2 mem: [0x0-0x0]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
kvm: disabled by bios
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 15972
alg: No test for fcrypt (fcrypt-generic)
alg: No test for stdrng (krng)
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:04:00.0: Boot video device
pcieport-driver 0000:00:06.0: setting latency timer to 64
pcieport-driver 0000:00:06.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
processor ACPI_CPU:02: registered as cooling_device2
processor ACPI_CPU:03: registered as cooling_device3
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ipmi message handler version 39.2
ipmi device interface
IPMI System Interface driver.
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
ipmi: Found new BMC (man_id: 0x000157,  prod_id: 0x003a, dev_id: 0x21)
IPMI kcs interface initialized
IPMI Watchdog: driver initialized
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
IPMI poweroff: ATCA Detect mfg 0x157 prod 0x3A
IPMI poweroff: Found a chassis style poweroff function
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
e1000: 0000:05:02.0: e1000_probe: (PCI:33MHz:32-bit) 00:15:17:26:b1:c7
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
0000:00:19.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:15:17:26:b1:c9
0000:00:19.0: eth1: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth1: MAC: 6, PHY: 6, PBA No: 0070ff-0ff
Linux video capture interface: v2.00
3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
st: Version 20081215, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 28
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors: (300 GB/279 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors: (300 GB/279 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
ata2.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors: (300 GB/279 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors: (300 GB/279 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: SAMSUNG HD103UJ, 1AA01112, max UDMA7
ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD1002FBYS-01A6B0, 03.00C05, max UDMA/133
ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-8: WDC WD1002FBYS-01A6B0, 03.00C05, max UDMA/133
ata5.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sde] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg4 type 0
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-8: WDC WD1002FBYS-01A6B0, 03.00C05, max UDMA/133
ata6.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      WDC WD1002FBYS-0 03.0 PQ: 0 ANSI: 5
sd 5:0:0:0: [sdf] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdf] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1 sdf2 sdf3
sd 5:0:0:0: [sdf] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg5 type 0
sata_sil24 0000:03:00.0: version 1.1
sata_sil24 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sata_sil24 0000:03:00.0: setting latency timer to 64
scsi6 : sata_sil24
scsi7 : sata_sil24
ata7: SATA max UDMA/100 host m128@0xe1a04000 port 0xe1a00000 irq 16
ata8: SATA max UDMA/100 host m128@0xe1a04000 port 0xe1a02000 irq 16
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
ata7.00: hard resetting link
ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
ata7.01: hard resetting link
ata7.01: SATA link down (SStatus 0 SControl 320)
ata7.02: hard resetting link
ata7.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.03: hard resetting link
ata7.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.04: hard resetting link
ata7.04: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.05: hard resetting link
ata7.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
ata7.00: ATA-7: SAMSUNG HD103UJ, 1AA01112, max UDMA7
ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata7.00: configured for UDMA/100
ata7.02: ATA-7: SAMSUNG HD103UJ, 1AA01112, max UDMA7
ata7.02: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata7.02: configured for UDMA/100
ata7.03: ATA-7: SAMSUNG HD103UJ, 1AA01112, max UDMA7
ata7.03: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata7.03: configured for UDMA/100
ata7.04: ATA-7: SAMSUNG HD103UJ, 1AA01112, max UDMA7
ata7.04: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata7.04: configured for UDMA/100
ata7: EH complete
scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 6:0:0:0: [sdg] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdg] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdg: sdg1
sd 6:0:0:0: [sdg] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg6 type 0
scsi 6:2:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 6:2:0:0: [sdh] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:2:0:0: [sdh] Write Protect is off
sd 6:2:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 6:2:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:2:0:0: [sdh] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:2:0:0: [sdh] Write Protect is off
sd 6:2:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 6:2:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdh: sdh1
sd 6:2:0:0: [sdh] Attached SCSI disk
sd 6:2:0:0: Attached scsi generic sg7 type 0
scsi 6:3:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 6:3:0:0: [sdi] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:3:0:0: [sdi] Write Protect is off
sd 6:3:0:0: [sdi] Mode Sense: 00 3a 00 00
sd 6:3:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:3:0:0: [sdi] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:3:0:0: [sdi] Write Protect is off
sd 6:3:0:0: [sdi] Mode Sense: 00 3a 00 00
sd 6:3:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdi: sdi1
sd 6:3:0:0: [sdi] Attached SCSI disk
sd 6:3:0:0: Attached scsi generic sg8 type 0
scsi 6:4:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 6:4:0:0: [sdj] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:4:0:0: [sdj] Write Protect is off
sd 6:4:0:0: [sdj] Mode Sense: 00 3a 00 00
sd 6:4:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:4:0:0: [sdj] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 6:4:0:0: [sdj] Write Protect is off
sd 6:4:0:0: [sdj] Mode Sense: 00 3a 00 00
sd 6:4:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdj: sdj1
sd 6:4:0:0: [sdj] Attached SCSI disk
sd 6:4:0:0: Attached scsi generic sg9 type 0
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata8.00: ATA-7: SAMSUNG HD103UJ, 1AA01112, max UDMA7
ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata8.00: configured for UDMA/100
scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdk] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 7:0:0:0: [sdk] Write Protect is off
sd 7:0:0:0: [sdk] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sdk] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 7:0:0:0: [sdk] Write Protect is off
sd 7:0:0:0: [sdk] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdk: sdk1
sd 7:0:0:0: [sdk] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg10 type 0
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
mptspi 0000:02:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1020A A1: Capabilities={Initiator,Target}
scsi8 : ioc0: LSI53C1020A A1, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
scsi 8:0:0:0: Sequential-Access HP       Ultrium 3-SCSI   D22D PQ: 0 ANSI: 3
 target8:0:0: Beginning Domain Validation
 target8:0:0: Ending Domain Validation
 target8:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI PCOMP (6.25 ns, offset 64)
st 8:0:0:0: Attached scsi tape st0
st 8:0:0:0: st0: try direct i/o: yes (alignment 4 B)
st 8:0:0:0: Attached scsi generic sg11 type 1
Fusion MPT misc device (ioctl) driver 3.04.07
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 17, io mem 0xe1d21c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe1d21800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 18, io base 0x000040c0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000040a0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
iTCO_wdt: No card detected
md: raid1 personality registered for level 1
input: AT Translated Set 2 keyboard as /class/input/input3
raid6: int64x1   2579 MB/s
raid6: int64x2   3291 MB/s
raid6: int64x4   2736 MB/s
raid6: int64x8   2310 MB/s
raid6: sse2x1    4541 MB/s
raid6: sse2x2    5122 MB/s
raid6: sse2x4    7993 MB/s
raid6: using algorithm sse2x4 (7993 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Feb 24 2009
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
Ebtables v2.0 registered
ebt_ulog: out of memory trying to call netlink_kernel_create
NET: Registered protocol family 33
RxRPC: Registered security type 2 'rxkad'
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
input: ImExPS/2 Generic Explorer Mouse as /class/input/input4
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 16 and added 16 devices.
md: autorun ...
md: considering sdk1 ...
md:  adding sdk1 ...
md:  adding sdj1 ...
md:  adding sdi1 ...
md:  adding sdh1 ...
md:  adding sdg1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md: sdb4 has different UUID to sdk1
md: sdb3 has different UUID to sdk1
md: sdb2 has different UUID to sdk1
md: sdb1 has different UUID to sdk1
md: sda4 has different UUID to sdk1
md: sda3 has different UUID to sdk1
md: sda2 has different UUID to sdk1
md: sda1 has different UUID to sdk1
md: created md5
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdi1>
md: bind<sdj1>
md: bind<sdk1>
md: running: <sdk1><sdj1><sdi1><sdh1><sdg1><sde1><sdd1><sdc1>
raid5: device sdj1 operational as raid disk 6
raid5: device sdi1 operational as raid disk 5
raid5: device sdh1 operational as raid disk 4
raid5: device sdg1 operational as raid disk 3
raid5: device sde1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: device sdc1 operational as raid disk 0
raid5: allocated 9518kB for md5
raid5: raid level 6 set md5 active with 7 out of 9 devices, algorithm 2
RAID5 conf printout:
 --- rd:9 wd:7
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdg1
 disk 4, o:1, dev:sdh1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdj1
md5: bitmap initialized from disk: read 15/15 pages, set 3 bits
created bitmap (233 pages) for device md5
md: considering sdb4 ...
RAID5 conf printout:
 --- rd:9 wd:7
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdg1
 disk 4, o:1, dev:sdh1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdj1
 disk 7, o:1, dev:sdk1
md:  adding sdb4 ...
md: sdb3 has different UUID to sdb4
md: sdb2 has different UUID to sdb4
md: sdb1 has different UUID to sdb4
md: recovery of RAID array md5
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759936 blocks.
md:  adding sda4 ...
md: sda3 has different UUID to sdb4
md: sda2 has different UUID to sdb4
md: sda1 has different UUID to sdb4
md: created md3
md: bind<sda4>
md: bind<sdb4>
md: running: <sdb4><sda4>
raid1: raid set md3 active with 2 out of 2 mirrors
md3: bitmap initialized from disk: read 15/15 pages, set 0 bits
created bitmap (235 pages) for device md3
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb2 has different UUID to sdb3
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda2 has different UUID to sdb3
md: sda1 has different UUID to sdb3
md: created md2
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md2: bitmap initialized from disk: read 9/9 pages, set 0 bits
created bitmap (130 pages) for device md2
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md1: bitmap initialized from disk: read 10/10 pages, set 108 bits
created bitmap (150 pages) for device md1
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md0: bitmap initialized from disk: read 1/1 pages, set 0 bits
created bitmap (12 pages) for device md0
md: ... autorun DONE.
 md1: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 9:1.
Freeing unused kernel memory: 400k freed
 md2:<6> md0: unknown partition table
 unknown partition table
 md5:<6> md3: unknown partition table
 unknown partition table
st0: Block limits 1 - 16777215 bytes.
Adding 1919672k swap on /dev/md3.  Priority:-1 extents:1 across:1919672k 
EXT3 FS on md1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
EXT4-fs: barriers enabled
kjournald2 starting: pid 3427, dev dm-2:8, commit interval 5 seconds
EXT4 FS on dm-2, internal journal on dm-2:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-2 with ordered data mode
JBD: barrier-based sync failed on dm-2:8 - disabling barriers
md: md5: recovery done.
RAID5 conf printout:
 --- rd:9 wd:8
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdg1
 disk 4, o:1, dev:sdh1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdj1
 disk 7, o:1, dev:sdk1
EXT4-fs: barriers enabled
kjournald2 starting: pid 11990, dev dm-1:8, commit interval 5 seconds
EXT4 FS on dm-1, internal journal on dm-1:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-1 with ordered data mode
JBD: barrier-based sync failed on dm-1:8 - disabling barriers
EXT4-fs: mballoc: 5944357 blocks 16104 reqs (9609 success)
EXT4-fs: mballoc: 7150 extents scanned, 5731 goal hits, 5869 2^N hits, 0 breaks, 0 lost
EXT4-fs: mballoc: 806 generated and it took 1646776
EXT4-fs: mballoc: 3952320 preallocated, 943658 discarded
EXT3-fs: dm-1: couldn't mount because of unsupported optional features (240).
EXT4-fs: barriers enabled
kjournald2 starting: pid 12054, dev dm-1:8, commit interval 5 seconds
EXT4 FS on dm-1, internal journal on dm-1:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-1 with ordered data mode
EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
EXT4-fs: mballoc: 0 generated and it took 0
EXT4-fs: mballoc: 0 preallocated, 0 discarded
EXT4-fs: barriers enabled
kjournald2 starting: pid 12059, dev dm-1:8, commit interval 5 seconds
EXT4 FS on dm-1, internal journal on dm-1:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-1 with ordered data mode
EXT4-fs: barriers enabled
kjournald2 starting: pid 12063, dev dm-0:8, commit interval 5 seconds
EXT4 FS on dm-0, internal journal on dm-0:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-0 with ordered data mode
JBD: barrier-based sync failed on dm-0:8 - disabling barriers
EXT4-fs: mballoc: 36014838 blocks 245875 reqs (164335 success)
EXT4-fs: mballoc: 89077 extents scanned, 34866 goal hits, 81378 2^N hits, 0 breaks, 0 lost
EXT4-fs: mballoc: 6927 generated and it took 18103832
EXT4-fs: mballoc: 23427120 preallocated, 6893492 discarded
EXT4-fs: barriers enabled
kjournald2 starting: pid 12382, dev dm-0:8, commit interval 5 seconds
EXT4 FS on dm-0, internal journal on dm-0:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-0 with ordered data mode
JBD: barrier-based sync failed on dm-1:8 - disabling barriers
JBD: barrier-based sync failed on dm-0:8 - disabling barriers
sd 5:0:0:0: [sdf] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1 sdf2 sdf3
sd 5:0:0:0: [sdf] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1
md: bind<sdf1>
RAID5 conf printout:
 --- rd:9 wd:8
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdg1
 disk 4, o:1, dev:sdh1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdj1
 disk 7, o:1, dev:sdk1
 disk 8, o:1, dev:sdf1
md: recovery of RAID array md5
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 976759936 blocks.
md: md5: recovery done.
RAID5 conf printout:
 --- rd:9 wd:9
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdg1
 disk 4, o:1, dev:sdh1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdj1
 disk 7, o:1, dev:sdk1
 disk 8, o:1, dev:sdf1
md: data-check of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 96256 blocks.
md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
md: delaying data-check of md3 until md1 has finished (they share one or more physical units)
md: data-check of RAID array md5
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 976759936 blocks.
md: md0: data-check done.
md: delaying data-check of md3 until md1 has finished (they share one or more physical units)
md: delaying data-check of md1 until md3 has finished (they share one or more physical units)
md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
md: data-check of RAID array md3
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 1919680 blocks.
md: md3: data-check done.
md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
md: data-check of RAID array md1
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 19534976 blocks.
md: md1: data-check done.
md: data-check of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
md: using 128k window, over a total of 271482368 blocks.
md: md2: data-check done.
md: md5: data-check done.
init_special_inode: bogus i_mode (53253)
attempt to access beyond end of device
dm-0: rw=0, want=1312475392770056, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=1312475392770056, limit=2147483648
init_special_inode: bogus i_mode (53253)
init_special_inode: bogus i_mode (53253)
init_special_inode: bogus i_mode (53253)
EXT4-fs: mballoc: 22367576 blocks 135958 reqs (123393 success)
EXT4-fs: mballoc: 13766 extents scanned, 132082 goal hits, 2742 2^N hits, 0 breaks, 0 lost
EXT4-fs: mballoc: 6665 generated and it took 32913144
EXT4-fs: mballoc: 16501501 preallocated, 257247 discarded
EXT4-fs: barriers enabled
kjournald2 starting: pid 26165, dev dm-0:8, commit interval 5 seconds
EXT4 FS on dm-0, internal journal on dm-0:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-0 with ordered data mode
JBD: barrier-based sync failed on dm-0:8 - disabling barriers
attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=946232834916360, limit=2147483648


