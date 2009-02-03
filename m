From: Alessandro Bono <alessandro.bono@gmail.com>
Subject: 2.6.28.3 ext4 ooops
Date: Tue, 03 Feb 2009 22:58:50 +0100
Message-ID: <1233698330.8029.12.camel@champagne.cantina>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-mguH25Cer81B8WS7OV5V"
To: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751302AbZBCV70@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-mguH25Cer81B8WS7OV5V
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi

On newly formatted ext4 usb disk I noticed data corruption after copying
lots of files form a remote server
to verify which files are compromised I tried to md5sum all files with
this command  

find software/ -type f -exec md5sum '{}' \;

during md5sum calculation this bug occurred


[ 2975.294886] BUG: unable to handle kernel NULL pointer dereference at
000000000000009c                                                                     
[ 2975.294897] IP: [<ffffffff8030b5bf>] radix_tree_insert
+0x11d/0x1a8                                                                                        
[ 2975.294913] PGD 124006067 PUD 1169e1067 PMD
0                                                                                                             
[ 2975.294921] Oops: 0000 [#1]
SMP                                                                                                                           
[ 2975.294927] last sysfs
file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map                                                                     
[ 2975.294932] CPU
0                                                                                                                                         
[ 2975.294936] Modules linked in: ext4 jbd2 crc16 usb_storage libusual
af_packet binfmt_misc rfcomm bridge stp llc bnep sco l2cap acpi_cpufreq
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand
freq_table cpufreq_conservative sbs sbshc pci_slot ipt_LOG xt_limit
ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip6_tables
ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables
x_tables ext3 jbd mbcache hp_wmi coretemp sbp2 loop snd_hda_intel arc4
ecb pcmcia snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc iwlagn iTCO_wdt
snd_mixer_oss lis3lv02d sdhci_pci sdhci iwlcore snd_seq_midi snd_rawmidi
yenta_socket snd_seq_dummy leds_hp_disk rsrc_nonstatic rfkill btusb
parport_pc parport snd_seq_oss snd_seq_midi_event video output psmouse
snd_seq snd_timer snd_seq_device mac80211 bluetooth tpm_infineon tpm
tpm_bios iTCO_vendor_support mmc_core ricoh_mmc led_class pcmcia_core
snd cfg80211 serio_raw pcspkr container evdev battery wmi button ac
soundcore dm_multipath xfs sr_mod cdrom sg sd_mod crc_t10dif ata_piix
ahci ohci1394 libata ieee1394 scsi_mod ehci_hcd uhci_hcd e1000e usbcore
dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal
processor fan thermal_sys hwmon
fuse                                                                                                                    
[ 2975.295137] Pid: 8314, comm: md5sum Not tainted 2.6.28.3
#1                                                                                               
[ 2975.295142] RIP: 0010:[<ffffffff8030b5bf>]  [<ffffffff8030b5bf>]
radix_tree_insert
+0x11d/0x1a8                                                            
[ 2975.295153] RSP: 0018:ffff8801001f78d8  EFLAGS:
00010002                                                                                                  
[ 2975.295158] RAX: 0000000000000010 RBX: 0000000000000004 RCX:
ffff8800379e780c                                                                             
[ 2975.295163] RDX: 0000000000000000 RSI: 0000000000000004 RDI:
ffff8800af1708e0                                                                             
[ 2975.295168] RBP: ffff8800af1708e0 R08: ffff8801388c5870 R09:
ffff88004972a000                                                                             
[ 2975.295174] R10: ffff8800af1708b8 R11: ffffffff80304565 R12:
0000000000000010                                                                             
[ 2975.295179] R13: 0000000000000002 R14: 0000000000000006 R15:
ffff8801058d0600                                                                             
[ 2975.295185] FS:  00007f7d1cb7a6e0(0000) GS:ffffffff80581040(0000)
knlGS:0000000000000000
[ 2975.295191] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2975.295196] CR2: 000000000000009c CR3: 0000000121df5000 CR4:
00000000000006e0
[ 2975.295201] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 2975.295206] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 2975.295212] Process md5sum (pid: 8314, threadinfo ffff8801001f6000,
task ffff8800a485cc50)
[ 2975.295217] Stack:
[ 2975.295220]  ffff880124032150 ffff880124032150 0000000000000000
ffff8800af1708b8
[ 2975.295228]  0000000000000000 ffff8801058d0600 ffff8801240321b8
ffffffff8030468e
[ 2975.295237]  ffffffff804f5f80 00000010804f5f80 ffff88004972a000
ffff8801388c5870
[ 2975.295247] Call Trace:
[ 2975.295251]  [<ffffffff8030468e>] ? cfq_set_request+0x129/0x313
[ 2975.295262]  [<ffffffff802fc1af>] ? get_request+0x1d9/0x287
[ 2975.295270]  [<ffffffff802fc28c>] ? get_request_wait+0x2f/0x147
[ 2975.295277]  [<ffffffff802b8560>] ? bvec_alloc_bs+0x86/0xc3
[ 2975.295285]  [<ffffffff802b860b>] ? bio_alloc_bioset+0x6e/0xc6
[ 2975.295293]  [<ffffffff802fc72f>] ? __make_request+0x38b/0x48b
[ 2975.295299]  [<ffffffff802bb573>] ? mpage_alloc+0x22/0x78
[ 2975.295307]  [<ffffffff802fb21a>] ? generic_make_request+0x27c/0x2bf
[ 2975.295317]  [<ffffffff8030b60c>] ? radix_tree_insert+0x16a/0x1a8
[ 2975.295325]  [<ffffffffa05ad7d3>] ? ext4_get_block+0x0/0xea [ext4]
[ 2975.295355]  [<ffffffff802fb307>] ? submit_bio+0xaa/0xb1
[ 2975.295363]  [<ffffffff802bb5eb>] ? mpage_bio_submit+0x22/0x26
[ 2975.295371]  [<ffffffff802bc157>] ? mpage_readpages+0xe1/0xf5
[ 2975.295379]  [<ffffffffa05ad7d3>] ? ext4_get_block+0x0/0xea [ext4]
[ 2975.295405]  [<ffffffff80276aec>] ? __do_page_cache_readahead
+0x108/0x194
[ 2975.295416]  [<ffffffff80276e59>] ? ondemand_readahead+0x16f/0x17e
[ 2975.295423]  [<ffffffff802713f5>] ? generic_file_aio_read+0x1ff/0x536
[ 2975.295434]  [<ffffffff802999d8>] ? do_sync_read+0xce/0x113
[ 2975.295442]  [<ffffffff80283025>] ? __vma_link+0x58/0x61
[ 2975.295450]  [<ffffffff8028471f>] ? mmap_region+0x3f2/0x51f
[ 2975.295458]  [<ffffffff802461cd>] ? autoremove_wake_function+0x0/0x2e
[ 2975.295468]  [<ffffffff8029a228>] ? vfs_read+0xa2/0xdb
[ 2975.295475]  [<ffffffff8029a31d>] ? sys_read+0x45/0x6e
[ 2975.295482]  [<ffffffff8020b49b>] ? system_call_fastpath+0x16/0x1b
[ 2975.295491] Code: 89 74 c3 18 eb 08 48 83 c8 01 48 89 45 08 44 88 f1
4c 89 f8 48 89 f3 48 d3 e8 41 83 ee 06 41 89 c4 41 ff cd 41 83 e4 3f 49
63 c4 <48> 8b 74 c6 18 45 85 ed 75 a3 b8 ef ff ff ff 48 85 f6 75 6b 48
[ 2975.295556] RIP  [<ffffffff8030b5bf>] radix_tree_insert+0x11d/0x1a8
[ 2975.295565]  RSP <ffff8801001f78d8>
[ 2975.295568] CR2: 000000000000009c
[ 2975.295573] ---[ end trace 171bc727efc84367 ]---


disk is mounted with this options: rw,nosuid,nodev,noatime
dmesg and .config attached
distribution is an ubuntu intrepid
tell me if you need other info

-- 
---
Cordiali Saluti
Alessandro Bono

--=-mguH25Cer81B8WS7OV5V
Content-Disposition: attachment; filename="dmesg-2.6.28.3"
Content-Type: text/plain; name="dmesg-2.6.28.3"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.28.3 (root@champagne) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #1 SMP Mon Feb 2 20:08:21 CET 2009
[    0.000000] Command line: root=/dev/mapper/vol00-root ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc5400 (reserved)
[    0.000000]  BIOS-e820: 00000000bffc5400 - 00000000bffe7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bffe7fb8 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbffb0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping: 0000000000000000-00000000bffb0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bffb0000 page 4k
[    0.000000] kernel direct mapping tables up to bffb0000 @ 8000-d000
[    0.000000] last_map_addr: bffb0000 end: bffb0000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ b000-11000
[    0.000000] last_map_addr: 13c000000 end: 13c000000
[    0.000000] RAMDISK: 37a08000 - 37fef38b
[    0.000000] ACPI: RSDP 000F7D10, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT BFFC81CC, 0084 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP BFFC8084, 00F4 (r4 HP     30C5            3 HP          1)
[    0.000000] ACPI: DSDT BFFC8544, 12EAD (r1 HP        8510x    10000 MSFT  3000001)
[    0.000000] ACPI: FACS BFFE7D80, 0040
[    0.000000] ACPI: SLIC BFFC8250, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: HPET BFFC83C8, 0038 (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: APIC BFFC8400, 0068 (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: MCFG BFFC8468, 003C (r1 HP     30C5            1 HP          1)
[    0.000000] ACPI: TCPA BFFC84A4, 0032 (r2 HP     30C5            1 HP          1)
[    0.000000] ACPI: ASF! BFFC84D8, 0069 (r16 HP     CHIMAYU         1 HP          0)
[    0.000000] ACPI: SSDT BFFDB3F1, 0328 (r1 HP       HPQSAT        1 MSFT  3000001)
[    0.000000] ACPI: SSDT BFFDB719, 017C (r1 HP       HPQMRM        1 MSFT  3000001)
[    0.000000] ACPI: SSDT BFFDC29D, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT BFFDC4FC, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT BFFDC5A2, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00005f42c8]    TEXT DATA BSS ==> [0000200000 - 00005f42c8]
[    0.000000]   #3 [0037a08000 - 0037fef38b]          RAMDISK ==> [0037a08000 - 0037fef38b]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bffb0
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1032015
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1115 pages reserved
[    0.000000]   DMA zone: 2828 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767976 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bffb0000 - 00000000bffc5000
[    0.000000] PM: Registered nosave memory: 00000000bffc5000 - 00000000bffc6000
[    0.000000] PM: Registered nosave memory: 00000000bffc6000 - 00000000bffe7000
[    0.000000] PM: Registered nosave memory: 00000000bffe7000 - 00000000bffe8000
[    0.000000] PM: Registered nosave memory: 00000000bffe8000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed9a000
[    0.000000] PM: Registered nosave memory: 00000000fed9a000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fedc0000
[    0.000000] PM: Registered nosave memory: 00000000fedc0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
[    0.000000] PERCPU: Allocating 53248 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013204
[    0.000000] Kernel command line: root=/dev/mapper/vol00-root ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.821 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] allocated 52428800 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 3921656k/5177344k available (2026k kernel code, 1049284k absent, 205412k reserved, 1029k data, 316k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.64 BogoMIPS (lpj=9575284)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys devices
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring handled by SMI
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.024048] Setting APIC routing to flat
[    0.024424] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066228] CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4787.95 BogoMIPS (lpj=9575919)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.153225] CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0b
[    0.153245] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156020] Brought up 2 CPUs
[    0.156022] Total of 2 processors activated (9575.60 BogoMIPS).
[    0.156095] net_namespace: 1352 bytes
[    0.156136] NET: Registered protocol family 16
[    0.156136] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.156136] ACPI: bus type pci registered
[    0.156136] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.156136] PCI: Not using MMCONFIG.
[    0.156136] PCI: Using configuration type 1 for base access
[    0.156803] ACPI: EC: Look up EC in DSDT
[    0.160019] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.217736] ACPI: Interpreter enabled
[    0.217738] ACPI: (supports S0 S3 S4 S5)
[    0.217752] ACPI: Using IOAPIC for interrupt routing
[    0.217813] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.225865] PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
[    0.228405] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.240278] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.240278] ACPI: EC: driver started in interrupt mode
[    0.240278] ACPI: No dock devices found.
[    0.240278] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.240278] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.240278] pci 0000:00:01.0: PME# disabled
[    0.240278] pci 0000:00:03.0: reg 10 64bit mmio: [0xe4500000-0xe450000f]
[    0.240278] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.240278] pci 0000:00:03.0: PME# disabled
[    0.240278] pci 0000:00:03.2: reg 10 io port: [0x5000-0x5007]
[    0.240278] pci 0000:00:03.2: reg 14 io port: [0x5008-0x500b]
[    0.240278] pci 0000:00:03.2: reg 18 io port: [0x5010-0x5017]
[    0.240278] pci 0000:00:03.2: reg 1c io port: [0x5018-0x501b]
[    0.240278] pci 0000:00:03.2: reg 20 io port: [0x5020-0x502f]
[    0.240278] pci 0000:00:03.3: reg 10 io port: [0x5030-0x5037]
[    0.240278] pci 0000:00:03.3: reg 14 32bit mmio: [0xe4501000-0xe4501fff]
[    0.240294] pci 0000:00:19.0: reg 10 32bit mmio: [0xe4520000-0xe453ffff]
[    0.240302] pci 0000:00:19.0: reg 14 32bit mmio: [0xe4540000-0xe4540fff]
[    0.240309] pci 0000:00:19.0: reg 18 io port: [0x5040-0x505f]
[    0.240341] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.240345] pci 0000:00:19.0: PME# disabled
[    0.240394] pci 0000:00:1a.0: reg 20 io port: [0x5060-0x507f]
[    0.240452] pci 0000:00:1a.1: reg 20 io port: [0x5080-0x509f]
[    0.240517] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe4541000-0xe45413ff]
[    0.240561] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.240566] pci 0000:00:1a.7: PME# disabled
[    0.240617] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe4544000-0xe4547fff]
[    0.240654] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.240659] pci 0000:00:1b.0: PME# disabled
[    0.240721] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.240725] pci 0000:00:1c.0: PME# disabled
[    0.240790] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.240794] pci 0000:00:1c.1: PME# disabled
[    0.240863] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.244005] pci 0000:00:1c.4: PME# disabled
[    0.244065] pci 0000:00:1d.0: reg 20 io port: [0x50a0-0x50bf]
[    0.244122] pci 0000:00:1d.1: reg 20 io port: [0x50c0-0x50df]
[    0.244180] pci 0000:00:1d.2: reg 20 io port: [0x50e0-0x50ff]
[    0.244244] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe4548000-0xe45483ff]
[    0.244287] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.244292] pci 0000:00:1d.7: PME# disabled
[    0.244443] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.244447] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
[    0.244481] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.244488] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.244495] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.244502] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.244509] pci 0000:00:1f.1: reg 20 io port: [0x5100-0x510f]
[    0.244576] pci 0000:00:1f.2: reg 10 io port: [0x13f0-0x13f7]
[    0.244583] pci 0000:00:1f.2: reg 14 io port: [0x15f4-0x15f7]
[    0.244590] pci 0000:00:1f.2: reg 18 io port: [0x1370-0x1377]
[    0.244597] pci 0000:00:1f.2: reg 1c io port: [0x1574-0x1577]
[    0.244604] pci 0000:00:1f.2: reg 20 io port: [0x5140-0x515f]
[    0.244611] pci 0000:00:1f.2: reg 24 32bit mmio: [0xe4549000-0xe45497ff]
[    0.244630] pci 0000:00:1f.2: PME# supported from D3hot
[    0.244634] pci 0000:00:1f.2: PME# disabled
[    0.244686] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    0.244693] pci 0000:01:00.0: reg 14 io port: [0x4000-0x40ff]
[    0.244700] pci 0000:01:00.0: reg 18 32bit mmio: [0xe4400000-0xe440ffff]
[    0.244723] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.244733] pci 0000:01:00.0: supports D1 D2
[    0.244774] pci 0000:01:00.1: reg 10 32bit mmio: [0xe4410000-0xe4413fff]
[    0.244816] pci 0000:01:00.1: supports D1 D2
[    0.244881] pci 0000:00:01.0: bridge io port: [0x4000-0x4fff]
[    0.244883] pci 0000:00:01.0: bridge 32bit mmio: [0xe4400000-0xe44fffff]
[    0.244887] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.245063] pci 0000:10:00.0: reg 10 64bit mmio: [0xe4000000-0xe4001fff]
[    0.245148] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    0.245161] pci 0000:10:00.0: PME# disabled
[    0.245244] pci 0000:00:1c.1: bridge 32bit mmio: [0xe4000000-0xe40fffff]
[    0.245306] pci 0000:00:1c.4: bridge io port: [0x2000-0x3fff]
[    0.245310] pci 0000:00:1c.4: bridge 32bit mmio: [0xe0000000-0xe3ffffff]
[    0.245368] pci 0000:02:06.0: reg 10 32bit mmio: [0xe4100000-0xe4100fff]
[    0.245380] pci 0000:02:06.0: supports D1 D2
[    0.245381] pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.245386] pci 0000:02:06.0: PME# disabled
[    0.245426] pci 0000:02:06.1: reg 10 32bit mmio: [0xe4101000-0xe4101fff]
[    0.245437] pci 0000:02:06.1: supports D1 D2
[    0.245438] pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.245442] pci 0000:02:06.1: PME# disabled
[    0.245483] pci 0000:02:06.2: reg 10 32bit mmio: [0xe4102000-0xe41027ff]
[    0.245529] pci 0000:02:06.2: supports D1 D2
[    0.245530] pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.245535] pci 0000:02:06.2: PME# disabled
[    0.245575] pci 0000:02:06.3: reg 10 32bit mmio: [0xe4103000-0xe41030ff]
[    0.245620] pci 0000:02:06.3: supports D1 D2
[    0.245621] pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.245625] pci 0000:02:06.3: PME# disabled
[    0.245667] pci 0000:02:06.4: reg 10 32bit mmio: [0xe4104000-0xe41040ff]
[    0.245712] pci 0000:02:06.4: supports D1 D2
[    0.245714] pci 0000:02:06.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.245718] pci 0000:02:06.4: PME# disabled
[    0.245775] pci 0000:00:1e.0: transparent bridge
[    0.245783] pci 0000:00:1e.0: bridge 32bit mmio: [0xe4100000-0xe43fffff]
[    0.245850] bus 00 -> node 0
[    0.245855] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.246350] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C096._PRT]
[    0.246474] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B0._PRT]
[    0.246660] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11D._PRT]
[    0.246810] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C131._PRT]
[    0.246961] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C134._PRT]
[    0.296533] ACPI: PCI Interrupt Link [C12D] (IRQs *10 11)
[    0.296533] ACPI: PCI Interrupt Link [C12E] (IRQs *10 11)
[    0.296604] ACPI: PCI Interrupt Link [C12F] (IRQs 10 *11)
[    0.296831] ACPI: PCI Interrupt Link [C130] (IRQs 10 11) *5
[    0.297059] ACPI: PCI Interrupt Link [C140] (IRQs *10 11)
[    0.297285] ACPI: PCI Interrupt Link [C141] (IRQs 10 11) *5
[    0.297512] ACPI: PCI Interrupt Link [C142] (IRQs 10 *11)
[    0.297616] ACPI Exception (pci_link-0189): AE_NOT_FOUND, Evaluating _PRS [20080926]
[    0.297730] ACPI: Power Resource [C22B] (on)
[    0.297730] ACPI: Power Resource [C238] (on)
[    0.297730] ACPI: Power Resource [C254] (on)
[    0.297730] ACPI: Power Resource [C17C] (off)
[    0.297730] ACPI: Power Resource [C363] (off)
[    0.297730] ACPI: Power Resource [C366] (off)
[    0.297730] ACPI: Power Resource [C367] (off)
[    0.297730] ACPI: Power Resource [C368] (off)
[    0.297730] ACPI: Power Resource [C369] (off)
[    0.297730] ACPI: Power Resource [C36A] (off)
[    0.297730] ACPI: Power Resource [C383] (off)
[    0.300043] ACPI: Power Resource [C384] (off)
[    0.300144] ACPI: Power Resource [C385] (off)
[    0.300246] ACPI: Power Resource [C386] (off)
[    0.300347] ACPI: Power Resource [C387] (off)
[    0.300358] PCI: Using ACPI for IRQ routing
[    0.320028] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.320031] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.336007] pnp: PnP ACPI init
[    0.336012] ACPI: bus type pnp registered
[    0.347619] pnp: PnP ACPI: found 16 devices
[    0.347621] ACPI: ACPI bus type pnp unregistered
[    0.347627] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.347629] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.347632] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.347639] system 00:0c: ioport range 0x500-0x55f has been reserved
[    0.347641] system 00:0c: ioport range 0x800-0x80f has been reserved
[    0.347643] system 00:0c: iomem range 0xffb00000-0xffbfffff has been reserved
[    0.347645] system 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
[    0.347650] system 00:0e: ioport range 0x4d0-0x4d1 has been reserved
[    0.347652] system 00:0e: ioport range 0x1000-0x107f has been reserved
[    0.347654] system 00:0e: ioport range 0x1100-0x113f has been reserved
[    0.347656] system 00:0e: ioport range 0x1200-0x121f has been reserved
[    0.347658] system 00:0e: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.347660] system 00:0e: iomem range 0xfec00000-0xfec000ff has been reserved
[    0.347662] system 00:0e: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.347664] system 00:0e: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.347667] system 00:0e: iomem range 0xfed90000-0xfed99fff has been reserved
[    0.347671] system 00:0f: iomem range 0xcf400-0xcffff has been reserved
[    0.347673] system 00:0f: iomem range 0xfeda0000-0xfedbffff has been reserved
[    0.347675] system 00:0f: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.352529] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.352532] pci 0000:00:01.0:   IO window: 0x4000-0x4fff
[    0.352535] pci 0000:00:01.0:   MEM window: 0xe4400000-0xe44fffff
[    0.352538] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.352542] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    0.352544] pci 0000:00:1c.0:   IO window: disabled
[    0.352549] pci 0000:00:1c.0:   MEM window: disabled
[    0.352553] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.352560] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
[    0.352561] pci 0000:00:1c.1:   IO window: disabled
[    0.352567] pci 0000:00:1c.1:   MEM window: 0xe4000000-0xe40fffff
[    0.352571] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.352578] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:28
[    0.352581] pci 0000:00:1c.4:   IO window: 0x2000-0x3fff
[    0.352586] pci 0000:00:1c.4:   MEM window: 0xe0000000-0xe3ffffff
[    0.352591] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.352601] pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
[    0.352602] pci 0000:02:06.0:   IO window: 0x006000-0x0060ff
[    0.352607] pci 0000:02:06.0:   IO window: 0x006400-0x0064ff
[    0.352611] pci 0000:02:06.0:   PREFETCH window: 0xc4000000-0xc7ffffff
[    0.352616] pci 0000:02:06.0:   MEM window: 0xcc000000-0xcfffffff
[    0.352620] pci 0000:02:06.1: CardBus bridge, secondary bus 0000:04
[    0.352621] pci 0000:02:06.1:   IO window: 0x006800-0x0068ff
[    0.352626] pci 0000:02:06.1:   IO window: 0x006c00-0x006cff
[    0.352630] pci 0000:02:06.1:   PREFETCH window: 0xc8000000-0xcbffffff
[    0.352635] pci 0000:02:06.1:   MEM window: 0xe8000000-0xebffffff
[    0.352639] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.352642] pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
[    0.352647] pci 0000:00:1e.0:   MEM window: 0xe4100000-0xe43fffff
[    0.352652] pci 0000:00:1e.0:   PREFETCH window: 0x000000c4000000-0x000000cbffffff
[    0.352664] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.352667] pci 0000:00:01.0: setting latency timer to 64
[    0.352674] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.352678] pci 0000:00:1c.0: setting latency timer to 64
[    0.352687] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.352691] pci 0000:00:1c.1: setting latency timer to 64
[    0.352699] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.352703] pci 0000:00:1c.4: setting latency timer to 64
[    0.352711] pci 0000:00:1e.0: setting latency timer to 64
[    0.352718] pci 0000:02:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.352728] pci 0000:02:06.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.352733] bus: 00 index 0 io port: [0x00-0xffff]
[    0.352735] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.352737] bus: 01 index 0 io port: [0x4000-0x4fff]
[    0.352739] bus: 01 index 1 mmio: [0xe4400000-0xe44fffff]
[    0.352740] bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
[    0.352742] bus: 01 index 3 mmio: [0x0-0x0]
[    0.352743] bus: 08 index 0 mmio: [0x0-0x0]
[    0.352744] bus: 08 index 1 mmio: [0x0-0x0]
[    0.352746] bus: 08 index 2 mmio: [0x0-0x0]
[    0.352747] bus: 08 index 3 mmio: [0x0-0x0]
[    0.352748] bus: 10 index 0 mmio: [0x0-0x0]
[    0.352750] bus: 10 index 1 mmio: [0xe4000000-0xe40fffff]
[    0.352751] bus: 10 index 2 mmio: [0x0-0x0]
[    0.352753] bus: 10 index 3 mmio: [0x0-0x0]
[    0.352754] bus: 28 index 0 io port: [0x2000-0x3fff]
[    0.352756] bus: 28 index 1 mmio: [0xe0000000-0xe3ffffff]
[    0.352757] bus: 28 index 2 mmio: [0x0-0x0]
[    0.352759] bus: 28 index 3 mmio: [0x0-0x0]
[    0.352760] bus: 02 index 0 io port: [0x6000-0x6fff]
[    0.352762] bus: 02 index 1 mmio: [0xe4100000-0xe43fffff]
[    0.352763] bus: 02 index 2 mmio: [0xc4000000-0xcbffffff]
[    0.352765] bus: 02 index 3 io port: [0x00-0xffff]
[    0.352766] bus: 02 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.352768] bus: 03 index 0 io port: [0x6000-0x60ff]
[    0.352769] bus: 03 index 1 io port: [0x6400-0x64ff]
[    0.352771] bus: 03 index 2 mmio: [0xc4000000-0xc7ffffff]
[    0.352773] bus: 03 index 3 mmio: [0xcc000000-0xcfffffff]
[    0.352774] bus: 04 index 0 io port: [0x6800-0x68ff]
[    0.352776] bus: 04 index 1 io port: [0x6c00-0x6cff]
[    0.352777] bus: 04 index 2 mmio: [0xc8000000-0xcbffffff]
[    0.352779] bus: 04 index 3 mmio: [0xe8000000-0xebffffff]
[    0.352786] NET: Registered protocol family 2
[    0.392041] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.392456] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.394261] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.394886] TCP: Hash tables configured (established 262144 bind 65536)
[    0.394889] TCP reno registered
[    0.404094] NET: Registered protocol family 1
[    0.404192] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.504013] Switched to high resolution mode on CPU 0
[    0.604670]  it is
[    0.818142] Freeing initrd memory: 6044k freed
[    0.821280] alg: cipher: Test 1 failed on encryption for aes-asm
[    0.821346] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
[    0.821513] audit: initializing netlink socket (disabled)
[    0.821531] type=2000 audit(1233697011.821:1): initialized
[    0.821877] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.823597] msgmni has been set to 7673
[    0.823796] alg: No test for stdrng (krng)
[    0.823867] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.823869] io scheduler noop registered
[    0.823909] io scheduler cfq registered (default)
[    0.824055] pci 0000:01:00.0: Boot video device
[    0.831935] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.831962] pcieport-driver 0000:00:01.0: found MSI capability
[    0.831982] pcieport-driver 0000:00:01.0: irq 511 for MSI/MSI-X
[    0.831990] pci_express 0000:00:01.0:pcie00: allocate port service
[    0.832020] pci_express 0000:00:01.0:pcie03: allocate port service
[    0.832081] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.832124] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.832155] pcieport-driver 0000:00:1c.0: irq 510 for MSI/MSI-X
[    0.832169] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.832197] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.832283] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.832328] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.832359] pcieport-driver 0000:00:1c.1: irq 509 for MSI/MSI-X
[    0.832374] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.832405] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.832439] pci_express 0000:00:1c.1:pcie03: allocate port service
[    0.832527] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.832572] pcieport-driver 0000:00:1c.4: found MSI capability
[    0.832603] pcieport-driver 0000:00:1c.4: irq 508 for MSI/MSI-X
[    0.832618] pci_express 0000:00:1c.4:pcie00: allocate port service
[    0.832647] pci_express 0000:00:1c.4:pcie02: allocate port service
[    0.832674] pci_express 0000:00:1c.4:pcie03: allocate port service
[    0.851498] Linux agpgart interface v0.103
[    0.851501] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    0.851641] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.852265] 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.852471] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.852577] 0000:00:03.3: ttyS1 at I/O 0x5030 (irq = 17) is a 16550A
[    0.853816] brd: module loaded
[    0.853889] PNP: PS/2 Controller [PNP0303:C251,PNP0f13:C252] at 0x60,0x64 irq 1,12
[    0.855706] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.856407] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.856411] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.856413] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.856414] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.856416] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.856538] mice: PS/2 mouse device common for all mice
[    0.856582] cpuidle: using governor ladder
[    0.856583] cpuidle: using governor menu
[    0.856830] TCP cubic registered
[    0.857127] Freeing unused kernel memory: 316k freed
[    0.857253] Write protecting the kernel read-only data: 2772k
[    0.929035] fuse init (API version 7.10)
[    0.933527] fan PNP0C0B:00: registered as cooling_device0
[    0.933532] ACPI: Fan [C36B] (off)
[    0.933761] fan PNP0C0B:01: registered as cooling_device1
[    0.933766] ACPI: Fan [C36C] (off)
[    0.933992] fan PNP0C0B:02: registered as cooling_device2
[    0.933996] ACPI: Fan [C36D] (off)
[    0.934223] fan PNP0C0B:03: registered as cooling_device3
[    0.934228] ACPI: Fan [C36E] (off)
[    0.934452] fan PNP0C0B:04: registered as cooling_device4
[    0.934457] ACPI: Fan [C36F] (off)
[    0.934568] fan PNP0C0B:05: registered as cooling_device5
[    0.934573] ACPI: Fan [C370] (off)
[    0.934800] fan PNP0C0B:06: registered as cooling_device6
[    0.934805] ACPI: Fan [C388] (off)
[    0.935033] fan PNP0C0B:07: registered as cooling_device7
[    0.935037] ACPI: Fan [C389] (off)
[    0.935261] fan PNP0C0B:08: registered as cooling_device8
[    0.935266] ACPI: Fan [C38A] (off)
[    0.935490] fan PNP0C0B:09: registered as cooling_device9
[    0.935495] ACPI: Fan [C38B] (off)
[    0.935720] fan PNP0C0B:0a: registered as cooling_device10
[    0.935725] ACPI: Fan [C38C] (off)
[    0.939816] ACPI: SSDT BFFDB95D, 02C1 (r1 HP      Cpu0Ist     3000 INTL 20060317)
[    0.940254] ACPI: SSDT BFFDBCA3, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
[    0.952618] Monitor-Mwait will be used to enter C-1 state
[    0.952621] Monitor-Mwait will be used to enter C-2 state
[    0.952725] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    0.952756] processor ACPI_CPU:00: registered as cooling_device11
[    0.952759] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.953081] ACPI: SSDT BFFDB895, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
[    0.953394] ACPI: SSDT BFFDBC1E, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
[    0.954342] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    0.954371] processor ACPI_CPU:01: registered as cooling_device12
[    0.954374] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.961154] thermal LNXTHERM:01: registered as thermal_zone0
[    0.965020] Marking TSC unstable due to TSC halts in idle
[    0.975356] ACPI: Thermal Zone [TZ2] (64 C)
[    0.978580] thermal LNXTHERM:02: registered as thermal_zone1
[    0.980250] ACPI: Thermal Zone [TZ3] (61 C)
[    0.987549] thermal LNXTHERM:03: registered as thermal_zone2
[    0.999583] ACPI: Thermal Zone [TZ4] (34 C)
[    1.002345] thermal LNXTHERM:04: registered as thermal_zone3
[    1.008330] ACPI: Thermal Zone [TZ5] (72 C)
[    1.026392] thermal LNXTHERM:05: registered as thermal_zone4
[    1.043536] ACPI: Thermal Zone [TZ0] (69 C)
[    1.046612] thermal LNXTHERM:06: registered as thermal_zone5
[    1.048432] ACPI: Thermal Zone [TZ1] (80 C)
[    1.054854] device-mapper: uevent: version 1.0.3
[    1.054987] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.396755] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.436808] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    1.436811] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.436852] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.436861] e1000e 0000:00:19.0: setting latency timer to 64
[    1.436972] e1000e 0000:00:19.0: irq 507 for MSI/MSI-X
[    1.437588] usbcore: registered new interface driver usbfs
[    1.437613] usbcore: registered new interface driver hub
[    1.438008] usbcore: registered new device driver usb
[    1.438887] uhci_hcd: USB Universal Host Controller Interface driver
[    1.442755] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.442757] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    1.479980] SCSI subsystem initialized
[    1.490386] ohci1394 0000:02:06.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.529077] libata version 3.00 loaded.
[    1.543112] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[e4102000-e41027ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    1.670402] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:4b:7a:9d:98
[    1.670404] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.670432] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
[    1.670459] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.670467] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.670470] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.670498] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.670531] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00005060
[    1.670657] usb usb1: configuration #1 chosen from 1 choice
[    1.670678] hub 1-0:1.0: USB hub found
[    1.670683] hub 1-0:1.0: 2 ports detected
[    1.670795] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.670839] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.670843] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.670861] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[    1.674780] ehci_hcd 0000:00:1a.7: debug port 1
[    1.674786] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.674790] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe4541000
[    1.689056] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.689130] usb usb2: configuration #1 chosen from 1 choice
[    1.689155] hub 2-0:1.0: USB hub found
[    1.689161] hub 2-0:1.0: 4 ports detected
[    1.689259] ata_piix 0000:00:1f.1: version 2.12
[    1.689266] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.689300] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.689366] scsi0 : ata_piix
[    1.689427] scsi1 : ata_piix
[    1.689967] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x5100 irq 14
[    1.689969] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5108 irq 15
[    1.853515] ata1.00: ATAPI: MATSHITADVD-RAM UJ-860H, 1.02, max MWDMA2
[    1.868403] ata1.00: configured for MWDMA2
[    1.868876] ata2: port disabled. ignoring.
[    1.874108] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-860H  1.02 PQ: 0 ANSI: 5
[    1.874421] ahci 0000:00:1f.2: version 3.0
[    1.874433] ahci 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    1.874472] ahci 0000:00:1f.2: irq 506 for MSI/MSI-X
[    1.874524] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x1 impl SATA mode
[    1.874526] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    1.874531] ahci 0000:00:1f.2: setting latency timer to 64
[    1.874616] scsi2 : ahci
[    1.874658] scsi3 : ahci
[    1.874693] scsi4 : ahci
[    1.874739] ata3: SATA max UDMA/133 abar m2048@0xe4549000 port 0xe4549100 irq 506
[    1.874741] ata4: DUMMY
[    1.874741] ata5: DUMMY
[    1.878801] Driver 'sr' needs updating - please use bus_type methods
[    1.883545] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.883547] Uniform CD-ROM driver Revision: 3.20
[    1.883610] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.886502] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.000079] Clocksource tsc unstable (delta = -383892934 ns)
[    2.113067] usb 2-2: new high speed USB device using ehci_hcd and address 3
[    2.192091] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.194484] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.194486] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
[    2.194720] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[    2.194722] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.195439] ata3.00: ATA-8: Hitachi HTS722012K9SA00, DCCOC60A, max UDMA/100
[    2.195442] ata3.00: 234441648 sectors, multi 16: LBA48 
[    2.198002] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.198004] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
[    2.198228] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[    2.198230] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.199002] ata3.00: configured for UDMA/100
[    2.213847] ata3.00: configured for UDMA/100
[    2.213849] ata3: EH complete
[    2.213949] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72201 DCCO PQ: 0 ANSI: 5
[    2.214052] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[    2.214504] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.214513] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.214516] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.214538] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    2.214574] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00005080
[    2.214645] usb usb3: configuration #1 chosen from 1 choice
[    2.214666] hub 3-0:1.0: USB hub found
[    2.214671] hub 3-0:1.0: 2 ports detected
[    2.214774] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.214821] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.214824] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.214847] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    2.218745] ehci_hcd 0000:00:1d.7: debug port 1
[    2.218751] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.218761] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe4548000
[    2.224266] Driver 'sd' needs updating - please use bus_type methods
[    2.224327] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.224338] sd 2:0:0:0: [sda] Write Protect is off
[    2.224340] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.224356] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.224397] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.224406] sd 2:0:0:0: [sda] Write Protect is off
[    2.224408] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.224425] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.224427]  sda:<6>ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.237156] usb usb4: configuration #1 chosen from 1 choice
[    2.237189] hub 4-0:1.0: USB hub found
[    2.237195] hub 4-0:1.0: 6 ports detected
[    2.237651] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.237659] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.237662] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.237682] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.237712] uhci_hcd 0000:00:1d.0: irq 20, io base 0x000050a0
[    2.237785] usb usb5: configuration #1 chosen from 1 choice
[    2.237806] hub 5-0:1.0: USB hub found
[    2.237811] hub 5-0:1.0: 2 ports detected
[    2.237908] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    2.237914] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.237917] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.237934] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.237970] uhci_hcd 0000:00:1d.1: irq 22, io base 0x000050c0
[    2.238037] usb usb6: configuration #1 chosen from 1 choice
[    2.238058] hub 6-0:1.0: USB hub found
[    2.238063] hub 6-0:1.0: 2 ports detected
[    2.238162] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.238168] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.238171] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.238188] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.238212] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000050e0
[    2.238281] usb usb7: configuration #1 chosen from 1 choice
[    2.238301] hub 7-0:1.0: USB hub found
[    2.238306] hub 7-0:1.0: 2 ports detected
[    2.244321]  sda1 sda2
[    2.244415] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.246438] usb 2-2: configuration #1 chosen from 1 choice
[    2.246774] hub 2-2:1.0: USB hub found
[    2.246840] hub 2-2:1.0: 4 ports detected
[    2.360061] usb 2-4: new high speed USB device using ehci_hcd and address 4
[    2.496974] usb 2-4: configuration #1 chosen from 1 choice
[    2.497196] hub 2-4:1.0: USB hub found
[    2.497348] hub 2-4:1.0: 4 ports detected
[    2.740057] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    2.816343] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929ed5e0e]
[    2.909663] usb 1-1: configuration #1 chosen from 1 choice
[    3.368158] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    3.529854] usb 5-2: configuration #1 chosen from 1 choice
[   16.320842] PM: Starting manual resume from disk
[   16.320844] PM: Resume from partition 254:1
[   16.320846] PM: Checking hibernation image.
[   16.321028] PM: Resume from disk failed.
[   16.325401] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   16.332326] Filesystem "dm-2": Disabling barriers, trial barrier write failed
[   16.336282] XFS mounting filesystem dm-2
[   16.563627] Starting XFS recovery on filesystem: dm-2 (logdev: internal)
[   19.456846] Ending XFS recovery on filesystem: dm-2 (logdev: internal)
[   31.008978] udevd version 124 started
[   31.320473] ata3.00: configured for UDMA/100
[   31.320478] ata3: EH complete
[   31.334783] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[   31.342553] sd 2:0:0:0: [sda] Write Protect is off
[   31.342555] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   31.356690] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   31.622088] device-mapper: multipath: version 1.0.5 loaded
[   31.829795] input: PC Speaker as /class/input/input1
[   32.106100] iTCO_vendor_support: vendor-support=0
[   32.536707] ACPI: AC Adapter [C1F2] (on-line)
[   32.625166] input: Power Button (FF) as /class/input/input2
[   32.657187] ACPI: Power Button (FF) [PWRF]
[   32.660568] ACPI: Battery Slot [C1F4] (battery present)
[   32.660654] input: Sleep Button (CM) as /class/input/input3
[   32.685173] ACPI: Sleep Button (CM) [C274]
[   32.685437] ACPI: Battery Slot [C1F3] (battery absent)
[   32.685518] input: Lid Switch as /class/input/input4
[   32.697163] ACPI: Lid Switch [C26E]
[   32.734237] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
[   32.734416] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[   32.734503] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   32.797107] cfg80211: Calling CRDA to update world regulatory domain
[   32.825985] ricoh-mmc: Ricoh MMC Controller disabling driver
[   32.825987] ricoh-mmc: Copyright(c) Philip Langdale
[   32.826010] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.4 [1180:0843] (rev 10)
[   32.826025] ricoh-mmc: Controller is now disabled.
[   32.856676] ACPI: WMI: Mapper loaded
[   32.923557] acpi device:03: registered as cooling_device13
[   32.924559] input: Video Bus as /class/input/input5
[   32.933265] logips2pp: Detected unknown logitech mouse model 62
[   32.953167] ACPI: Video Device [C14B] (multi-head: yes  rom: no  post: no)
[   33.033696] tpm_inf_pnp 00:04: Found C239 with ID IFX0102
[   33.033749] tpm_inf_pnp 00:04: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   33.117710] Bluetooth: Core ver 2.13
[   33.122343] NET: Registered protocol family 31
[   33.122346] Bluetooth: HCI device and connection manager initialized
[   33.122348] Bluetooth: HCI socket layer initialized
[   33.363658] parport_pc 00:03: reported by Plug and Play ACPI
[   33.363739] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   33.446112] sdhci: Secure Digital Host Controller Interface driver
[   33.446114] sdhci: Copyright(c) Pierre Ossman
[   33.472820] sdhci-pci 0000:02:06.3: SDHCI controller found [1180:0822] (rev 20)
[   33.472838] sdhci-pci 0000:02:06.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   33.474957] mmc0: SDHCI controller on PCI [0000:02:06.3] using PIO
[   33.486548] input: ImExPS/2 Logitech Explorer Mouse as /class/input/input6
[   33.589959] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   33.590046] usbcore: registered new interface driver btusb
[   33.612551] yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c5]
[   33.743508] yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0c38, PCI irq 16
[   33.743511] yenta_cardbus 0000:02:06.0: Socket status: 30000006
[   33.743516] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[   33.743518] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
[   33.743520] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
[   33.743920] yenta_cardbus 0000:02:06.1: CardBus bridge found [103c:30c5]
[   33.749244] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   33.749251] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   33.749267] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   33.754155] Registered led device: hp:red:hddprotection
[   33.754176] leds-hp-disk driver loaded.
[   33.807236] lis3lv02d driver loaded.
[   33.844627] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   33.844669] HDA Intel 0000:01:00.1: setting latency timer to 64
[   33.872775] yenta_cardbus 0000:02:06.1: ISA IRQ mask 0x0000, PCI irq 17
[   33.872779] yenta_cardbus 0000:02:06.1: Socket status: 30000810
[   33.872782] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #04 to #07
[   33.872789] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[   33.872791] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
[   33.872794] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
[   33.946779] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[   33.946782] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   33.946896] iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   33.946923] iwlagn 0000:10:00.0: setting latency timer to 64
[   33.946988] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[   33.997029] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
[   33.997297] iwlagn 0000:10:00.0: PCI INT A disabled
[   33.997717] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   34.106998] cfg80211: Calling CRDA for country: IT
[   34.512082] pcmcia_socket pcmcia_socket1: pccard: PCMCIA card inserted into slot 1
[   34.512114] pcmcia_socket pcmcia_socket1: cs: memory probe 0xc4000000-0xcbffffff: excluding 0xc4000000-0xcbffffff
[   34.512131] pcmcia_socket pcmcia_socket1: cs: memory probe 0xe4100000-0xe43fffff: excluding 0xe4100000-0xe412ffff
[   34.517056] pcmcia 1.0: pcmcia: registering new device pcmcia1.0
[   34.686091] loop: module loaded
[   34.835418] input: HP WMI hotkeys as /class/input/input7
[   34.988256] Adding 8388600k swap on /dev/mapper/vol00-swap.  Priority:-1 extents:1 across:8388600k
[   36.087053] kjournald starting.  Commit interval 5 seconds
[   36.102974] EXT3 FS on sda1, internal journal
[   36.102983] EXT3-fs: mounted filesystem with ordered data mode.
[   36.769016] ip_tables: (C) 2000-2006 Netfilter Core Team
[   36.818576] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   36.818713] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   36.818715] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   36.818717] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   36.939901] NET: Registered protocol family 10
[   36.940277] lo: Disabled Privacy Extensions
[   36.977672] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   39.484069] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   53.955959] Bluetooth: L2CAP ver 2.11
[   53.955964] Bluetooth: L2CAP socket layer initialized
[   53.982772] Bluetooth: SCO (Voice Link) ver 0.6
[   53.982778] Bluetooth: SCO socket layer initialized
[   54.020329] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   54.020334] Bluetooth: BNEP filters: protocol multicast
[   54.126385] Bridge firewalling registered
[   54.293110] Bluetooth: RFCOMM socket layer initialized
[   54.293129] Bluetooth: RFCOMM TTY layer initialized
[   54.293133] Bluetooth: RFCOMM ver 1.10
[   56.729113] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   58.748386] e1000e 0000:00:19.0: irq 507 for MSI/MSI-X
[   58.804117] e1000e 0000:00:19.0: irq 507 for MSI/MSI-X
[   58.806642] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   58.808592] iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   58.808730] iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
[   58.808898] iwlagn 0000:10:00.0: irq 505 for MSI/MSI-X
[   58.809009] iwlagn 0000:10:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   59.132597] Registered led device: iwl-phy0:radio
[   59.132641] Registered led device: iwl-phy0:assoc
[   59.132681] Registered led device: iwl-phy0:RX
[   59.132720] Registered led device: iwl-phy0:TX
[   59.237761] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   59.408570] NET: Registered protocol family 17
[   61.709629] 0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   61.710428] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   72.236053] eth0: no IPv6 routers present
[  182.300114] usb 4-6: new high speed USB device using ehci_hcd and address 3
[  182.433594] usb 4-6: configuration #1 chosen from 1 choice
[  182.548351] usbcore: registered new interface driver libusual
[  182.595085] Initializing USB Mass Storage driver...
[  182.596393] scsi5 : SCSI emulation for USB Mass Storage devices
[  182.598478] usbcore: registered new interface driver usb-storage
[  182.598486] USB Mass Storage support registered.
[  182.598744] usb-storage: device found at 3
[  182.598748] usb-storage: waiting for device to settle before scanning
[  187.596350] usb-storage: device scan complete
[  187.596916] scsi 5:0:0:0: Direct-Access     Maxtor   OneTouch         0125 PQ: 0 ANSI: 4
[  187.617616] sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[  187.618227] sd 5:0:0:0: [sdb] Write Protect is off
[  187.618234] sd 5:0:0:0: [sdb] Mode Sense: 2d 08 00 00
[  187.618239] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[  187.619365] sd 5:0:0:0: [sdb] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
[  187.619961] sd 5:0:0:0: [sdb] Write Protect is off
[  187.619967] sd 5:0:0:0: [sdb] Mode Sense: 2d 08 00 00
[  187.619972] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[  187.619980]  sdb: sdb1
[  187.632964] sd 5:0:0:0: [sdb] Attached SCSI disk
[  187.634113] sd 5:0:0:0: Attached scsi generic sg2 type 0
[  188.708354] EXT4-fs: barriers enabled
[  188.730942] kjournald2 starting.  Commit interval 5 seconds
[  188.731657] EXT4 FS on sdb1, internal journal on sdb1:8
[  188.731662] EXT4-fs: delayed allocation enabled
[  188.731665] EXT4-fs: file extents enabled
[  188.733920] EXT4-fs: mballoc enabled
[  188.733924] EXT4-fs: recovery complete.
[  188.734534] EXT4-fs: mounted filesystem with ordered data mode.
[  199.528074] usb 4-5: new high speed USB device using ehci_hcd and address 4
[  199.670895] usb 4-5: configuration #1 chosen from 1 choice
[  199.671547] scsi6 : SCSI emulation for USB Mass Storage devices
[  199.673525] usb-storage: device found at 4
[  199.673530] usb-storage: waiting for device to settle before scanning
[  204.672505] usb-storage: device scan complete
[  204.673703] scsi 6:0:0:0: Direct-Access     USB      Driver           0.00 PQ: 0 ANSI: 0 CCS
[  204.948321] sd 6:0:0:0: [sdc] 31318016 512-byte hardware sectors: (16.0 GB/14.9 GiB)
[  204.948930] sd 6:0:0:0: [sdc] Write Protect is off
[  204.948935] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  204.948940] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  204.955053] sd 6:0:0:0: [sdc] 31318016 512-byte hardware sectors: (16.0 GB/14.9 GiB)
[  204.955671] sd 6:0:0:0: [sdc] Write Protect is off
[  204.955677] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  204.955682] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  204.955690]  sdc: sdc1
[  204.956527] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[  204.956735] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  208.752496] [UFW BLOCK INPUT]: IN=eth0 OUT= MAC=00:1a:4b:7a:9d:98:00:17:a4:93:66:ec:08:00 SRC=10.151.1.5 DST=10.151.1.19 LEN=91 TOS=0x00 PREC=0x00 TTL=64 ID=38146 PROTO=UDP SPT=161 DPT=37991 LEN=71 
[  208.784324] [UFW BLOCK INPUT]: IN=eth0 OUT= MAC=00:1a:4b:7a:9d:98:00:0f:66:c7:99:59:08:00 SRC=10.151.1.253 DST=10.151.1.19 LEN=74 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=37991 LEN=54 
[  250.914462] EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
[  250.914469] EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
[  250.914474] EXT4-fs: mballoc: 0 generated and it took 0
[  250.914478] EXT4-fs: mballoc: 0 preallocated, 0 discarded

--=-mguH25Cer81B8WS7OV5V
Content-Disposition: attachment; filename="config-2.6.28.3"
Content-Type: text/plain; name="config-2.6.28.3"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28.3
# Mon Feb  2 19:54:50 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
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
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
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
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
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
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_PHONET=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_HP_WMI=m
# CONFIG_ICS932S401 is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
# CONFIG_C2PORT is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=m
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=m
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
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
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
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=m
# CONFIG_CYCLADES_SYNC is not set
# CONFIG_SBNI is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
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
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

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
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
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
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8591=m
CONFIG_TPS65010=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
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
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SN9C102=m
CONFIG_USB_ZC0301=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
CONFIG_USB_DSBR=m
# CONFIG_USB_SI470X is not set
CONFIG_USB_MR800=m
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_DVB_SIANO_SMS1XXX=m
CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS=y

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRX397XD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_LGS8GL5=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
CONFIG_DVB_AF9013=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
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
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=m
CONFIG_BACKLIGHT_PROGEAR=m
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
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
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
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
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BRIGHT=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DELL=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=m
CONFIG_UWB_I1480U_WLP=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_HP_DISK=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_SMX is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_OCFS2_COMPAT_JBD is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_REGISTER_V4=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--=-mguH25Cer81B8WS7OV5V--
