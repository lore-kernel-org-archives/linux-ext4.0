From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12478] Infinite loop printing "__find_get_block_slow() failed." on accessing intentionally corrupted ext4 fs
Date: Sun, 18 Jan 2009 09:14:44 -0800 (PST)
Message-ID: <20090118171444.49E86108040@picon.linux-foundation.org>
References: <bug-12478-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760613AbZARROs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 12:14:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0IHEibn015795
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 09:14:45 -0800
In-Reply-To: <bug-12478-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12478





------- Comment #2 from sliedes@cc.hut.fi  2009-01-18 09:14 -------
Dmesg output:

------------------------------------------------------------
Linux version 2.6.29-rc2 (sliedes@lh) (gcc version 4.3.2 (Debian 4.3.2-1.1) )
#2 SMP Sun Jan 18 04:01:48 UTC 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
 BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7ff0 max_arch_pfn = 0x100000
Scanning 2 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000002000 (usable)
 modified: 0000000000002000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 0000000000007000 (usable)
 modified: 0000000000007000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 0000000000092c00 (usable)
 modified: 000000000009fc00 - 00000000000a0000 (reserved)
 modified: 00000000000e8000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 0000000007ff0000 (usable)
 modified: 0000000007ff0000 - 0000000008000000 (ACPI data)
 modified: 00000000fffc0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
127MB LOWMEM available.
  mapped low ram: 0 - 07ff0000
  low ram: 00000000 - 07ff0000
  bootmap 0001c000 - 0001d000
(8 early reservations) ==> bootmem [0000000000 - 0007ff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000200000 - 0000d234a8]    TEXT DATA BSS ==> [0000200000 - 0000d234a8]
  #4 [0000d24000 - 0000d39000]    INIT_PG_TABLE ==> [0000d24000 - 0000d39000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000010000 - 000001c000]          PGTABLE ==> [0000010000 - 000001c000]
  #7 [000001c000 - 000001d000]          BOOTMAP ==> [000001c000 - 000001d000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00007ff0
  HighMem  0x00007ff0 -> 0x00007ff0
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x00000002
    0: 0x00000006 -> 0x00000007
    0: 0x00000010 -> 0x00000092
    0: 0x00000100 -> 0x00007ff0
SMP: Allowing 1 CPUs, 0 hotplug CPUs
Found and enabled local APIC!
Allocating PCI resources starting at 10000000 (gap: 8000000:f7fc0000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Allocating 28672 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32213
Kernel command line: root=/dev/hda console=ttyS0,115200n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Fast TSC calibration using PIT
Detected 2404.770 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 2335 kB
 per task-struct memory footprint: 1152 bytes
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 116752k/131008k available (3884k kernel code, 13616k reserved, 1240k
data, 256k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff52000 - 0xfffff000   ( 692 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc87f0000 - 0xff7fe000   ( 880 MB)
    lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
      .init : 0xc0708000 - 0xc0748000   ( 256 kB)
      .data : 0xc05cb037 - 0xc0701384   (1240 kB)
      .text : 0xc0200000 - 0xc05cb037   (3884 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency..
4809.54 BogoMIPS (lpj=24047700)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
debug: unmapping init memory c0703000..c0708000
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (4809.54 BogoMIPS).
net_namespace: 388 bytes
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb200, last bus=0
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
SCSI subsystem initialized
PCI: Probing PCI hardware
pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
NET: Registered protocol family 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
Scanning for low memory corruption every 60 seconds
HugeTLB registered 4 MB page size, pre-allocated 0 pages
DLM (built Jan 18 2009 04:00:42) installed
squashfs: version 4.0 (2009/01/03) Phillip Lougher
NTFS driver 2.1.29 [Flags: R/W].
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
QNX4 filesystem 0.2.3 registered.
JFS: nTxBlock = 913, nTxLock = 7306
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no
debug enabled
SGI XFS Quota Management subsystem
BeFS version: 0.9.3
Btrfs loaded
msgmni has been set to 228
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
loop: module loaded
ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
ne2k-pci 0000:00:03.0: found PCI INT A -> IRQ 11
eth0: RealTek RTL-8029 found at 0xc100, IRQ 11, 52:54:00:12:34:56.
Uniform Multi-Platform E-IDE driver
piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
piix 0000:00:01.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xc000-0xc007
    ide1: BM-DMA at 0xc008-0xc00f
hda: QEMU HARDDISK, ATA DISK drive
hdb: QEMU HARDDISK, ATA DISK drive
hda: MWDMA2 mode selected
hdb: MWDMA2 mode selected
hdc: QEMU HARDDISK, ATA DISK drive
hdc: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all
legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 1024000 sectors (524 MB) w/256KiB Cache, CHS=1015/255/63
hda: cache flushes supported
 hda:
hdb: max request size: 512KiB
hdb: 20480 sectors (10 MB) w/256KiB Cache, CHS=20/255/63
hdb: cache flushes supported
 hdb: unknown partition table
hdc: max request size: 512KiB
hdc: 20480 sectors (10 MB) w/256KiB Cache, CHS=20/255/63
hdc: cache flushes supported
 hdc: unknown partition table
Loading iSCSI transport class v2.0-870.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
TCP cubic registered
NET: Registered protocol family 17
SCTP: Hash tables configured (established 1024 bind 1024)
IO APIC resources could be not be allocated.
Using IPI Shortcut mode
registered taskstats version 1
rtc_cmos rtc_cmos: setting system clock to 2009-01-18 16:55:11 UTC (1232297711)
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 3:0.
debug: unmapping init memory c0708000..c0748000
Write protecting the kernel text: 3888k
Write protecting the kernel read-only data: 952k

INIT: version 2.86 booting

Setting the system clock.
Activating swap...done.
EXT3 FS on hda, internal journal
Setting the system clock.
Cleaning up ifupdown....
Checking file systems...fsck 1.41.3 (12-Oct-2008)
done.
Setting kernel variables (/etc/sysctl.conf)...done.
Mounting local filesystems...done.
Activating swapfile swap...done.
Setting up networking....
Configuring network interfaces...done.

INIT: Entering runlevel: 2

Starting system log daemon....
Starting kernel log daemon....
Starting periodic command scheduler: crond.

Debian GNU/Linux 5.0 fstest ttyS0

fstest login: root
Last login: Sun Jan 18 16:53:09 UTC 2009 on ttyS0
Linux fstest 2.6.29-rc2 #2 SMP Sun Jan 18 04:01:48 UTC 2009 i686

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
fstest:~# zzuf -r 0:0.03 -s 153 </dev/hdc >/dev/hdb
fstest:~# [   54.833991] Clocksource tsc unstable (delta = 380257462 ns)
mount /dev/hdb /mnt -t ext4 -o errors=continue
EXT4-fs: barriers enabled
kjournald2 starting: pid 732, dev hdb:8, commit interval 5 seconds
EXT4 FS on hdb, internal journal on hdb:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem hdb with ordered data mode
fstest:~# rm -rf /mnt/* >&/dev/null
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#1279: inode out of bounds - offset=24, inode=16778496, rec_len=24, name_len=16
EXT4-fs error (device hdb): empty_dir: bad entry in directory #1279: inode out
of bounds - offset=24, inode=16778496, rec_len=24, name_len=16
EXT4-fs warning (device hdb): ext4_rmdir: empty directory has too many links
(16)
EXT4-fs error (device hdb): ext4_mb_generate_buddy: EXT4-fs: group 0: 6073
blocks in bitmap, 6075 in gd
EXT4-fs error (device hdb): ext4_mb_generate_buddy: EXT4-fs: group 1: 1894
blocks in bitmap, 1891 in gd
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=1076, inode=134217770, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=3100, inode=268435539, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=2308, inode=96, rec_len=12,
name_len=6
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=4768, inode=1198, rec_len=12,
name_len=35
EXT4-fs error (device hdb): ext4_mb_free_blocks: Freeing blocks not in datazone
- block = 1869770799, count = 1
EXT4-fs error (device hdb): ext4_mb_free_blocks: Freeing blocks not in datazone
- block = 1935748963, count = 1
EXT4-fs error (device hdb): ext4_mb_free_blocks: Freeing blocks not in datazone
- block = 1684960623, count = 1
EXT4-fs error (device hdb): ext4_mb_free_blocks: Freeing blocks not in datazone
- block = 1936944943, count = 1
EXT4-fs error (device hdb): ext4_mb_free_blocks: Freeing blocks not in datazone
- block = 1684960047, count = 1
EXT4-fs error (device hdb): ext4_mb_free_blocks: Freeing blocks not in datazone
- block = 1952543859, count = 1
__find_get_block_slow() failed. block=1099511629181, b_blocknr=1404
b_state=0x00000029, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=1099511629181, b_blocknr=1404
b_state=0x00000029, b_size=1024
device blocksize: 1024
grow_buffers: requested out-of-range block 1099511629181 for device hdb
__find_get_block_slow() failed. block=1099511629181, b_blocknr=1404
b_state=0x00000029, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=1099511629181, b_blocknr=1404
b_state=0x00000029, b_size=1024
device blocksize: 1024
grow_buffers: requested out-of-range block 1099511629181 for device hdb
EXT4-fs error (device hdb): empty_dir: error -5 reading directory #16 offset 0
__find_get_block_slow() failed. block=1099511629181, b_blocknr=1404
b_state=0x00000029, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=1099511629181, b_blocknr=1404
b_state=0x00000029, b_size=1024
device blocksize: 1024
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=1076, inode=134217770, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=3100, inode=268435539, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=2308, inode=96, rec_len=12,
name_len=6
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=4768, inode=1198, rec_len=12,
name_len=35
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #28:
inode out of bounds - offset=12, inode=262165, rec_len=12, name_len=2
EXT4-fs error (device hdb): ext4_xattr_delete_inode: inode 32: bad block 64
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=1076, inode=134217770, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=3100, inode=268435539, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=2308, inode=96, rec_len=12,
name_len=6
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=4768, inode=1198, rec_len=12,
name_len=35
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#1012: rec_len is smaller than minimal - offset=56, inode=0, rec_len=0,
name_len=0
EXT4-fs error (device hdb): empty_dir: bad entry in directory #1012: rec_len is
smaller than minimal - offset=56, inode=0, rec_len=0, name_len=0
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=1076, inode=134217770, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=3100, inode=268435539, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=2308, inode=96, rec_len=12,
name_len=6
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=4768, inode=1198, rec_len=12,
name_len=35
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=1076, inode=134217770, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
inode out of bounds - offset=3100, inode=268435539, rec_len=12, name_len=4
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=2308, inode=96, rec_len=12,
name_len=6
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory #12:
rec_len is too small for name_len - offset=4768, inode=1198, rec_len=12,
name_len=35
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=10576, inode=67109714, rec_len=48, name_len=37
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=10576, inode=67109714, rec_len=48, name_len=37
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=13016, inode=17347, rec_len=48, name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=13016, inode=17347, rec_len=48, name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
directory entry across blocks - offset=20696, inode=851, rec_len=1072,
name_len=40
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
directory entry across blocks - offset=20696, inode=851, rec_len=1072,
name_len=40
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=13016, inode=17347, rec_len=48, name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=13016, inode=17347, rec_len=48, name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=13016, inode=17347, rec_len=48, name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=13016, inode=17347, rec_len=48, name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=16648, inode=134218643, rec_len=48, name_len=39
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=16648, inode=134218643, rec_len=48, name_len=39
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
directory entry across blocks - offset=19504, inode=890, rec_len=8240,
name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
directory entry across blocks - offset=19504, inode=890, rec_len=8240,
name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
directory entry across blocks - offset=19504, inode=890, rec_len=8240,
name_len=38
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
directory entry across blocks - offset=19504, inode=890, rec_len=8240,
name_len=38
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#772: rec_len % 4 != 0 - offset=15904, inode=974, rec_len=482, name_len=27
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=16648, inode=134218643, rec_len=48, name_len=39
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=16648, inode=134218643, rec_len=48, name_len=39
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=16648, inode=134218643, rec_len=48, name_len=39
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=16648, inode=134218643, rec_len=48, name_len=39
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=14564, inode=536871785, rec_len=48, name_len=37
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=14564, inode=536871785, rec_len=48, name_len=37
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#772: rec_len % 4 != 0 - offset=15904, inode=974, rec_len=482, name_len=27
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#772: directory entry across blocks - offset=20696, inode=851, rec_len=1072,
name_len=40
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=10576, inode=67109714, rec_len=48, name_len=37
EXT4-fs error (device hdb): ext4_dx_find_entry: bad entry in directory #772:
inode out of bounds - offset=10576, inode=67109714, rec_len=48, name_len=37
attempt to access beyond end of device
hdb: rw=0, want=2147483650, limit=20480
EXT4-fs error (device hdb): ext4_xattr_delete_inode: inode 839: block
1073741824 read error
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#772: directory entry across blocks - offset=20696, inode=851, rec_len=1072,
name_len=40
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#772: inode out of bounds - offset=3416, inode=2098026, rec_len=72, name_len=62
EXT4-fs error (device hdb): htree_dirblock_to_tree: bad entry in directory
#772: inode out of bounds - offset=10576, inode=67109714, rec_len=48,
name_len=37
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
device blocksize: 1024
__find_get_block_slow() failed. block=4294967296, b_blocknr=0
b_state=0x00000020, b_size=1024
------------------------------------------------------------


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
