From: Sachin Sant <sachinp@in.ibm.com>
Subject: EXT4: kernel BUG at fs/ext4/mballoc.c:1721!
Date: Thu, 03 Sep 2009 13:46:08 +0530
Message-ID: <4A9F7B48.9010903@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050200060807080208090304"
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:46221 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZICIQP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 04:16:15 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id n838GABU017052
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 13:46:10 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n838GAaG2191492
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 13:46:10 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n838G9Ye024361
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 18:16:10 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050200060807080208090304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While executing FS resize test against ext4 on a 4-way
POWER6 box with 2.6.31-rc8 kernel ran into following bug.

------------[ cut here ]------------
cpu 0x2: Vector: 700 (Program Check) at [c0000000f963ece0]
    pc: c000000000264d80: .ext4_mb_good_group+0x54/0x15c
    lr: c00000000026c9b0: .ext4_mb_regular_allocator+0x278/0x44c
    sp: c0000000f963ef60
   msr: 8000000000029032
  current = 0xc000000047b635a0
  paca    = 0xc000000000b62a00
    pid   = 32202, comm = dd
kernel BUG at fs/ext4/mballoc.c:1721!
enter ? for help
[link register   ] c00000000026c9b0 .ext4_mb_regular_allocator+0x278/0x44c
[c0000000f963ef60] c00000000026c99c .ext4_mb_regular_allocator+0x264/0x44c
(unreliable)
[c0000000f963f090] c00000000026cde0 .ext4_mb_new_blocks+0x25c/0x5b0
[c0000000f963f170] c000000000263260 .ext4_ext_get_blocks+0xd18/0xf2c
[c0000000f963f2f0] c0000000002404a8 .ext4_get_blocks+0x1b8/0x438
[c0000000f963f3c0] c000000000241d8c .ext4_get_block+0xe8/0x15c
[c0000000f963f480] c00000000018e1c0 .__block_prepare_write+0x210/0x4b0
[c0000000f963f5c0] c00000000018e698 .block_write_begin+0xa8/0x13c
[c0000000f963f680] c000000000243be4 .ext4_write_begin+0x198/0x324
[c0000000f963f790] c000000000112e50 .generic_file_buffered_write+0x140/0x37c
[c0000000f963f8d0] c00000000011364c
.__generic_file_aio_write_nolock+0x37c/0x3e0
[c0000000f963f9d0] c0000000001140e0 .generic_file_aio_write+0x88/0x120
[c0000000f963fa90] c000000000239250 .ext4_file_write+0xe4/0x1a4
[c0000000f963fb40] c00000000015e1f4 .do_sync_write+0xcc/0x130
[c0000000f963fce0] c00000000015ef44 .vfs_write+0xd0/0x1dc
[c0000000f963fd80] c00000000015f158 .SyS_write+0x58/0xa0
[c0000000f963fe30] c000000000008534 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 00000fff8fd1a8f8
SP (fffc6270e00) is in userspace

During the first 3 runs i did not see this issue, so might
not be able to recreate this again. I have captured the dmesg
log and have attached it.

ext4 fs was created and mounted using :

mkfs.ext4 -b 1024 /dev/sda4 3943948
mount  -t ext4 -o errors=panic,data=journal /dev/sda4 /mnt/tmp/

The corresponding c code is :

1718         struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb,
group);
1719 
1720         BUG_ON(cr < 0 || cr >= 4);
1721         BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));
1722    ^^^^^^^^^^^^^^^^^^^^
1723         free = grp->bb_free;

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------050200060807080208090304
Content-Type: text/plain;
 name="dmesg-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-log"

2:mon> dl
<4>Crash kernel location must be 0x2000000
<6>Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
<6>Phyp-dump disabled at boot time
<6>Using pSeries machine description
<7>Page orders: linear mapping = 24, virtual = 16, io = 12, vmemmap = 24
<6>Using 1TB segments
<4>Found initrd at 0xc0000000034d0000:0xc000000003c92232
<6>console [udbg0] enabled
<6>Partition configured for 4 cpus.
<6>CPU maps initialized for 2 threads per core
<7> (thread shift is 1)
<4>Starting Linux PPC64 #3 SMP Thu Sep 3 09:17:40 IST 2009
<4>-----------------------------------------------------
<4>ppc64_pft_size                = 0x1a
<4>physicalMemorySize            = 0x100000000
<4>htab_hash_mask                = 0x7ffff
<4>-----------------------------------------------------
<6>Initializing cgroup subsys cpuset
<6>Initializing cgroup subsys cpu
<5>Linux version 2.6.31-rc8 (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #3 SMP Thu Sep 3 09:17:40 IST 2009
<4>[boot]0012 Setup Arch
<7>Node 0 Memory:
<7>Node 1 Memory: 0x0-0x100000000
<4>EEH: No capable adapters found
<6>PPC64 nvram contains 15360 bytes
<7>Using shared processor idle loop
<4>Zone PFN ranges:
<4>  DMA      0x00000000 -> 0x00010000
<4>  Normal   0x00010000 -> 0x00010000
<4>Movable zone start PFN for each node
<4>early_node_map[1] active PFN ranges
<4>    1: 0x00000000 -> 0x00010000
<4>Could not find start_pfn for node 0
<7>On node 0 totalpages: 0
<7>On node 1 totalpages: 65536
<7>  DMA zone: 56 pages used for memmap
<7>  DMA zone: 0 pages reserved
<7>  DMA zone: 65480 pages, LIFO batch:1
<4>[boot]0015 Setup Done
<4>Built 2 zonelists in Node order, mobility grouping on.  Total pages: 65480
<4>Policy zone: DMA
<5>Kernel command line: root=/dev/sda5 sysrq=1 insmod=sym53c8xx insmod=ipr crashkernel=512M-:256M  
<4>PID hash table entries: 4096 (order: 12, 32768 bytes)
<4>freeing bootmem node 1
<6>Memory: 3898432k/4194304k available (8640k kernel code, 295872k reserved, 2048k data, 4267k bss, 512k init)
<6>SLUB: Genslabs=18, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=16
<6>Hierarchical RCU implementation.
<6>NR_IRQS:512
<4>[boot]0020 XICS Init
<4>[boot]0021 XICS Done
<7>pic: no ISA interrupt controller
<7>time_init: decrementer frequency = 512.000000 MHz
<7>time_init: processor frequency   = 4704.000000 MHz
<6>clocksource: timebase mult[7d0000] shift[22] registered
<7>clockevent: decrementer mult[83126e97] shift[32] cpu[0]
<4>Console: colour dummy device 80x25
<6>console handover: boot [udbg0] -> real [hvc0]
<6>allocated 2621440 bytes of page_cgroup
<6>please try 'cgroup_disable=memory' option if you don't want memory cgroups
<6>Security Framework initialized
<6>SELinux:  Disabled at boot.
<6>Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
<6>Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
<4>Mount-cache hash table entries: 4096
<6>Initializing cgroup subsys ns
<6>Initializing cgroup subsys cpuacct
<6>Initializing cgroup subsys memory
<6>Initializing cgroup subsys devices
<6>Initializing cgroup subsys freezer
<7>irq: irq 2 on host null mapped to virtual irq 16
<7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
<4>Processor 1 found.
<7>clockevent: decrementer mult[83126e97] shift[32] cpu[2]
<4>Processor 2 found.
<7>clockevent: decrementer mult[83126e97] shift[32] cpu[3]
<4>Processor 3 found.
<6>Brought up 4 CPUs
<7>Node 0 CPUs: 0-3
<7>Node 1 CPUs:
<7>CPU0 attaching sched-domain:
<7> domain 0: span 0-1 level SIBLING
<7>  groups: 0 1
<7>  domain 1: span 0-3 level CPU
<7>   groups: 0-1 2-3
<7>   domain 2: span 0-3 level NODE
<7>    groups: 0-3 (__cpu_power = 2048)
<7>CPU1 attaching sched-domain:
<7> domain 0: span 0-1 level SIBLING
<7>  groups: 1 0
<7>  domain 1: span 0-3 level CPU
<7>   groups: 0-1 2-3
<7>   domain 2: span 0-3 level NODE
<7>    groups: 0-3 (__cpu_power = 2048)
<7>CPU2 attaching sched-domain:
<7> domain 0: span 2-3 level SIBLING
<7>  groups: 2 3
<7>  domain 1: span 0-3 level CPU
<7>   groups: 2-3 0-1
<7>   domain 2: span 0-3 level NODE
<7>    groups: 0-3 (__cpu_power = 2048)
<7>CPU3 attaching sched-domain:
<7> domain 0: span 2-3 level SIBLING
<7>  groups: 3 2
<7>  domain 1: span 0-3 level CPU
<7>   groups: 2-3 0-1
<7>   domain 2: span 0-3 level NODE
<7>    groups: 0-3 (__cpu_power = 2048)
<6>NET: Registered protocol family 16
<6>IBM eBus Device Driver
<6>POWER6 performance monitor hardware support registered
<6>PCI: Probing PCI hardware
<7>PCI: Probing PCI hardware done
<4>bio: create slab <bio-0> at 0
<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
<6>NET: Registered protocol family 2
<6>IP route cache hash table entries: 32768 (order: 2, 262144 bytes)
<6>TCP established hash table entries: 131072 (order: 5, 2097152 bytes)
<6>TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
<6>TCP: Hash tables configured (established 131072 bind 65536)
<6>TCP reno registered
<6>NET: Registered protocol family 1
<6>Unpacking initramfs...
<7>Switched to high resolution mode on CPU 0
<7>Switched to high resolution mode on CPU 1
<7>Switched to high resolution mode on CPU 2
<7>Switched to high resolution mode on CPU 3
<7>irq: irq 655360 on host null mapped to virtual irq 17
<7>irq: irq 655362 on host null mapped to virtual irq 18
<6>IOMMU table initialized, virtual merging enabled
<7>irq: irq 589825 on host null mapped to virtual irq 19
<7>RTAS daemon started
<7>RTAS: event: 62, Type: Platform Error, Severity: 2
<6>audit: initializing netlink socket (disabled)
<5>type=2000 audit(1251952168.240:1): initialized
<6>HugeTLB registered 16 MB page size, pre-allocated 0 pages
<6>HugeTLB registered 16 GB page size, pre-allocated 0 pages
<5>VFS: Disk quotas dquot_6.5.2
<4>Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
<6>msgmni has been set to 7612
<6>alg: No test for stdrng (krng)
<6>Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
<6>io scheduler noop registered
<6>io scheduler anticipatory registered
<6>io scheduler deadline registered
<6>io scheduler cfq registered (default)
<6>pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
<7>vio_register_driver: driver hvc_console registering
<7>HVSI: registered 0 devices
<6>Generic RTC Driver v1.07
<6>Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
<6>pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
<6>input: Macintosh mouse button emulation as /devices/virtual/input/input0
<6>Uniform Multi-Platform E-IDE driver
<6>ide-gd driver 1.18
<6>IBM eHEA ethernet device driver (Release EHEA_0102)
<7>irq: irq 590080 on host null mapped to virtual irq 256
<6>ehea: eth0: Jumbo frames are disabled
<6>ehea: eth0 -> logical port id #2
<6>ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>mice: PS/2 mouse device common for all mice
<6>EDAC MC: Ver: 2.1.0 Aug 31 2009
<6>usbcore: registered new interface driver hiddev
<6>usbcore: registered new interface driver usbhid
<6>usbhid: v2.6:USB HID core driver
<6>TCP cubic registered
<6>NET: Registered protocol family 15
<4>registered taskstats version 1
<4>Freeing unused kernel memory: 512k freed
<6>SysRq : Changing Loglevel
<4>Loglevel set to 1
<5>SCSI subsystem initialized
<7>vio_register_driver: driver ibmvscsi registering
<6>ibmvscsi 30000002: SRP_VERSION: 16.a
<6>scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
<6>ibmvscsi 30000002: partner initialization complete
<6>ibmvscsi 30000002: host srp version: 16.a, host partition VIO (1), OS 3, max io 1048576
<3>ibmvscsi 30000002: fast_fail not supported in server
<6>ibmvscsi 30000002: Client reserve enabled
<6>ibmvscsi 30000002: sent SRP login
<6>ibmvscsi 30000002: SRP_LOGIN succeeded
<5>scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
<6>udevd version 128 started
<5>sd 0:0:1:0: [sda] 167772160 512-byte logical blocks: (85.8 GB/80.0 GiB)
<5>sd 0:0:1:0: [sda] Write Protect is off
<7>sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
<5>sd 0:0:1:0: [sda] Cache data unavailable
<3>sd 0:0:1:0: [sda] Assuming drive cache: write through
<5>sd 0:0:1:0: [sda] Cache data unavailable
<3>sd 0:0:1:0: [sda] Assuming drive cache: write through
<6> sda: sda1 sda2 < sda5 > sda3 sda4
<5>sd 0:0:1:0: [sda] Cache data unavailable
<3>sd 0:0:1:0: [sda] Assuming drive cache: write through
<5>sd 0:0:1:0: [sda] Attached SCSI disk
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sda5, internal journal
<6>EXT3-fs: mounted filesystem with writeback data mode.
<6>udevd version 128 started
<5>sd 0:0:1:0: Attached scsi generic sg0 type 0
<6>Adding 1044096k swap on /dev/sda3.  Priority:-1 extents:1 across:1044096k 
<6>device-mapper: uevent: version 1.0.3
<6>device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
<6>loop: module loaded
<6>fuse init (API version 7.12)
<6>ehea: eth0: Physical port up
<6>ehea: External switch port is backup port
<7>irq: irq 780 on host null mapped to virtual irq 268
<7>irq: irq 781 on host null mapped to virtual irq 269
<6>NET: Registered protocol family 10
<6>lo: Disabled Privacy Extensions
<7>eth0: no IPv6 routers present
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2369, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
<6>EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 0 generated and it took 0
<6>EXT4-fs: mballoc: 0 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2421, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 6244531 blocks 10745 reqs (2595 success)
<6>EXT4-fs: mballoc: 26476 extents scanned, 2300 goal hits, 4471 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 896 generated and it took 150107
<6>EXT4-fs: mballoc: 6526653 preallocated, 6273745 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2496, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 607646 blocks 13911 reqs (1584 success)
<6>EXT4-fs: mballoc: 82962 extents scanned, 2609 goal hits, 6966 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 56 generated and it took 25783
<6>EXT4-fs: mballoc: 3006529 preallocated, 1982560 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2591, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 590599 blocks 13721 reqs (1511 success)
<6>EXT4-fs: mballoc: 84253 extents scanned, 2582 goal hits, 6916 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 56 generated and it took 24777
<6>EXT4-fs: mballoc: 2930797 preallocated, 1924365 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2666, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 2372555 blocks 14001 reqs (1494 success)
<6>EXT4-fs: mballoc: 32852 extents scanned, 2406 goal hits, 7468 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 896 generated and it took 150887
<6>EXT4-fs: mballoc: 11110121 preallocated, 7007315 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2761, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 2353859 blocks 14033 reqs (1473 success)
<6>EXT4-fs: mballoc: 33436 extents scanned, 2457 goal hits, 7511 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 864 generated and it took 143955
<6>EXT4-fs: mballoc: 10936855 preallocated, 6890516 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2836, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 1560428 blocks 10526 reqs (2610 success)
<6>EXT4-fs: mballoc: 71851 extents scanned, 2052 goal hits, 4218 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 56 generated and it took 24738
<6>EXT4-fs: mballoc: 1778678 preallocated, 1722174 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2963, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
<6>EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 0 generated and it took 0
<6>EXT4-fs: mballoc: 0 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2988, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 6238187 blocks 10560 reqs (2618 success)
<6>EXT4-fs: mballoc: 25763 extents scanned, 2294 goal hits, 4393 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 896 generated and it took 148384
<6>EXT4-fs: mballoc: 6413426 preallocated, 6138288 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 3065, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 6010491 blocks 7217 reqs (4585 success)
<6>EXT4-fs: mballoc: 161881 extents scanned, 2299 goal hits, 3097 2^N hits, 747 breaks, 74 lost
<6>EXT4-fs: mballoc: 4554 generated and it took 1320519
<6>EXT4-fs: mballoc: 3711031 preallocated, 195203 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 23415, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
<6>EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 0 generated and it took 0
<6>EXT4-fs: mballoc: 0 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 23440, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 594416 blocks 13850 reqs (1513 success)
<6>EXT4-fs: mballoc: 81136 extents scanned, 2608 goal hits, 7019 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 56 generated and it took 24638
<6>EXT4-fs: mballoc: 2958282 preallocated, 1948161 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 23517, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 1399 blocks 1399 reqs (0 success)
<6>EXT4-fs: mballoc: 1399 extents scanned, 68 goal hits, 1331 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 88 generated and it took 50539
<6>EXT4-fs: mballoc: 2303933 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 11506, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
<6>EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 0 generated and it took 0
<6>EXT4-fs: mballoc: 0 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 11531, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 581002 blocks 13862 reqs (1523 success)
<6>EXT4-fs: mballoc: 83828 extents scanned, 2601 goal hits, 7021 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 56 generated and it took 24906
<6>EXT4-fs: mballoc: 2962458 preallocated, 1945571 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 11649, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 1399 blocks 1399 reqs (0 success)
<6>EXT4-fs: mballoc: 1399 extents scanned, 69 goal hits, 1330 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 88 generated and it took 50888
<6>EXT4-fs: mballoc: 2303933 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 31982, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
<6>EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 0 generated and it took 0
<6>EXT4-fs: mballoc: 0 preallocated, 0 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 32007, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 2347542 blocks 14187 reqs (1540 success)
<6>EXT4-fs: mballoc: 33559 extents scanned, 2535 goal hits, 7553 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 896 generated and it took 149256
<6>EXT4-fs: mballoc: 11009673 preallocated, 6901648 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 32133, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<0>------------[ cut here ]------------
<2>kernel BUG at fs/ext4/mballoc.c:1721!
2:mon>



--------------050200060807080208090304--
