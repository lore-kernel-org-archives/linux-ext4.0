From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Fri, 04 Sep 2009 10:30:06 +0530
Message-ID: <4AA09ED6.3050007@in.ibm.com>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu> <20090902210737.GV4197@webber.adilger.int> <20090902223011.GA30497@mit.edu> <4A9F3F7F.6030304@in.ibm.com> <4A9F71EA.4070406@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000104020105070209070500"
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52272 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZIDFAS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 01:00:18 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id n844x4u7021237
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 14:59:04 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n844wXmd1179864
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 14:58:33 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8450HPo029026
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 15:00:17 +1000
In-Reply-To: <4A9F71EA.4070406@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000104020105070209070500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sachin Sant wrote:
> As for this issue not sure how to proceed further. I probably will
> continue to execute the tests few more times. Maybe will try on
> a different box.
After increasing nproc value from 50 to 150 (-p 150)
i was able to recreate this bug again.

------------[ cut here ]------------
cpu 0x0: Vector: 700 (Program Check) at [c0000000fedeb970]
    pc: c000000000280f74: .jbd2_journal_commit_transaction+0x91c/0x1c6c
    lr: c000000000280f5c: .jbd2_journal_commit_transaction+0x904/0x1c6c
    sp: c0000000fedebbf0
   msr: 8000000000029032
  current = 0xc00000005e550c20
  paca    = 0xc000000000b62600
    pid   = 13149, comm = kjournald2
kernel BUG at fs/jbd2/commit.c:542!
enter ? for help
[c0000000fedebdd0] c000000000289cac .kjournald2+0x198/0x46c
[c0000000fedebed0] c0000000000a86a0 .kthread+0xac/0xb8
[c0000000fedebf90] c00000000002ab3c .kernel_thread+0x54/0x70
0:mon> dl

The change in line number for commit.c (533 to 542) is because of
some debug printk's i added in that file. Here are some of the
last few statements from dmesg buffer.


<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089515). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089516). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089517). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089518). There's a risk of filesystem corruption in case of system crash.
<1>nr_buffers = 1560
<1>outstanding_credits = 1557
<1>state = 4
<1>state = 4
<1>start = 4300814543
<1>updates = 0
<0>------------[ cut here ]------------
<2>kernel BUG at fs/jbd2/commit.c:542!

The nr_buffers value was 1560 while that of t_outstanding_credits was 1557.

Let me know if i can provide any other information to
debug this issue. Have attached dmesg log.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------000104020105070209070500
Content-Type: text/plain;
 name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log"

------------[ cut here ]------------
cpu 0x0: Vector: 700 (Program Check) at [c0000000fedeb970]
    pc: c000000000280f74: .jbd2_journal_commit_transaction+0x91c/0x1c6c
    lr: c000000000280f5c: .jbd2_journal_commit_transaction+0x904/0x1c6c
    sp: c0000000fedebbf0
   msr: 8000000000029032
  current = 0xc00000005e550c20
  paca    = 0xc000000000b62600
    pid   = 13149, comm = kjournald2
kernel BUG at fs/jbd2/commit.c:542!
enter ? for help
[c0000000fedebdd0] c000000000289cac .kjournald2+0x198/0x46c
[c0000000fedebed0] c0000000000a86a0 .kthread+0xac/0xb8
[c0000000fedebf90] c00000000002ab3c .kernel_thread+0x54/0x70
0:mon> dl
<4>Crash kernel location must be 0x2000000
<6>Reserving 256MB of memory at 32MB for crashkernel (System RAM: 4096MB)
<6>Phyp-dump disabled at boot time
<6>Using pSeries machine description
<7>Page orders: linear mapping = 24, virtual = 16, io = 12, vmemmap = 24
<6>Using 1TB segments
<4>Found initrd at 0xc0000000034d0000:0xc000000003c92a47
<6>console [udbg0] enabled
<6>Partition configured for 4 cpus.
<6>CPU maps initialized for 2 threads per core
<7> (thread shift is 1)
<4>Starting Linux PPC64 #5 SMP Thu Sep 3 17:40:05 IST 2009
<4>-----------------------------------------------------
<4>ppc64_pft_size                = 0x1a
<4>physicalMemorySize            = 0x100000000
<4>htab_hash_mask                = 0x7ffff
<4>-----------------------------------------------------
<6>Initializing cgroup subsys cpuset
<6>Initializing cgroup subsys cpu
<5>Linux version 2.6.31-rc8-ext4 (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #5 SMP Thu Sep 3 17:40:05 IST 2009
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
<5>type=2000 audit(1251980114.240:1): initialized
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
<7>irq: irq 780 on host null mapped to virtual irq 268
<6>ehea: eth0: Physical port up
<6>ehea: External switch port is backup port
<7>irq: irq 781 on host null mapped to virtual irq 269
<6>NET: Registered protocol family 10
<6>lo: Disabled Privacy Extensions
<7>eth0: no IPv6 routers present
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2470, dev sda4:8, commit interval 5 seconds
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
<6>kjournald2 starting: pid 2496, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 6316218 blocks 10869 reqs (2718 success)
<6>EXT4-fs: mballoc: 27518 extents scanned, 2341 goal hits, 4450 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 896 generated and it took 148897
<6>EXT4-fs: mballoc: 6538210 preallocated, 6274779 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2577, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 19076715 blocks 456774 reqs (317263 success)
<6>EXT4-fs: mballoc: 18713654 extents scanned, 2719 goal hits, 105504 2^N hits, 92395 breaks, 5 lost
<6>EXT4-fs: mballoc: 2920 generated and it took 1307140
<6>EXT4-fs: mballoc: 6234268 preallocated, 4510097 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 2644, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 6220451 blocks 7639 reqs (5005 success)
<6>EXT4-fs: mballoc: 155191 extents scanned, 2611 goal hits, 3143 2^N hits, 702 breaks, 35 lost
<6>EXT4-fs: mballoc: 5198 generated and it took 1487446
<6>EXT4-fs: mballoc: 3712797 preallocated, 255769 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 22997, dev sda4:8, commit interval 5 seconds
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
<6>kjournald2 starting: pid 23022, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 614411 blocks 14001 reqs (1591 success)
<6>EXT4-fs: mballoc: 84926 extents scanned, 2606 goal hits, 7016 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 56 generated and it took 24655
<6>EXT4-fs: mballoc: 3030592 preallocated, 1996613 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 23097, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 83691 blocks 83691 reqs (0 success)
<6>EXT4-fs: mballoc: 4557305 extents scanned, 28226 goal hits, 32220 2^N hits, 22231 breaks, 0 lost
<6>EXT4-fs: mballoc: 183 generated and it took 169061
<6>EXT4-fs: mballoc: 5727024 preallocated, 1058154 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 23164, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<6>EXT4-fs: mballoc: 846 blocks 846 reqs (0 success)
<6>EXT4-fs: mballoc: 846 extents scanned, 69 goal hits, 777 2^N hits, 0 breaks, 0 lost
<6>EXT4-fs: mballoc: 40 generated and it took 20887
<6>EXT4-fs: mballoc: 1171942 preallocated, 42496 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 24964, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 18741536 blocks 32464 reqs (8049 success)
<6>EXT4-fs: mballoc: 299662 extents scanned, 6400 goal hits, 12567 2^N hits, 1020 breaks, 0 lost
<6>EXT4-fs: mballoc: 2408 generated and it took 399674
<6>EXT4-fs: mballoc: 18770332 preallocated, 17992765 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 25162, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<6>EXT4-fs (sda4): delayed allocation enabled
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with ordered data mode
<6>EXT4-fs: mballoc: 6530971 blocks 8232 reqs (5365 success)
<6>EXT4-fs: mballoc: 167871 extents scanned, 2905 goal hits, 3279 2^N hits, 765 breaks, 56 lost
<6>EXT4-fs: mballoc: 5704 generated and it took 1692089
<6>EXT4-fs: mballoc: 3997891 preallocated, 254614 discarded
<6>EXT4-fs (sda4): barriers enabled
<6>kjournald2 starting: pid 13149, dev sda4:8, commit interval 5 seconds
<6>EXT4-fs (sda4): internal journal on sda4:8
<4>EXT4-fs (sda4): Ignoring delalloc option - requested data journaling mode
<6>EXT4-fs: file extents enabled
<6>EXT4-fs: mballoc enabled
<6>EXT4-fs (sda4): mounted filesystem with journalled data mode
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089515). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089516). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089517). There's a risk of filesystem corruption in case of system crash.
<4>JBD: Spotted dirty metadata buffer (dev = sda4, blocknr = 1089518). There's a risk of filesystem corruption in case of system crash.
<1>nr_buffers = 1560
<1>outstanding_credits = 1557
<1>state = 4
<1>state = 4
<1>start = 4300814543
<1>updates = 0
<0>------------[ cut here ]------------
<2>kernel BUG at fs/jbd2/commit.c:542!
0:mon>
0:mon> r
R00 = 0000000000000001   R16 = c00000005e6dc560
R01 = c0000000fedebbf0   R17 = 0000000000000000
R02 = c000000000a6f1f8   R18 = 0000000000000000
R03 = 0000000000000012   R19 = 0000000000000409
R04 = 0000000000000000   R20 = 0000000000000001
R05 = ffffffffffffffff   R21 = 0000000000000001
R06 = 0000000000000002   R22 = c0000000fedebc78
R07 = c000000000779d51   R23 = 0000000000000000
R08 = c000000000c07248   R24 = c0000000f3e1b800
R09 = 0000000000000618   R25 = c00000005e6dc570
R10 = c000000000c07750   R26 = c00000005e6dc500
R11 = 0000000000000001   R27 = c00000005e6dc550
R12 = 0000000028000082   R28 = c0000000fedebc78
R13 = c000000000b62600   R29 = c000000000779d23
R14 = c0000000008325c8   R30 = c0000000009ec158
R15 = c0000000f3e1bb9c   R31 = 0000000000000000
pc  = c000000000280f74 .jbd2_journal_commit_transaction+0x91c/0x1c6c
lr  = c000000000280f5c .jbd2_journal_commit_transaction+0x904/0x1c6c
msr = 8000000000029032   cr  = 28000084
ctr = 0000000000000001   xer = 0000000020000001   trap =  700
0:mon> 



--------------000104020105070209070500--
