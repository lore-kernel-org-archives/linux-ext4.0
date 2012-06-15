From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: sudden (big) performance drop in writes
Date: Fri, 15 Jun 2012 11:33:47 -0300
Message-ID: <20443.18379.984605.38375@fisica.ufpr.br>
References: <20442.47124.34363.560455@fisica.ufpr.br>
	<67D336C0-4529-477D-B0B3-D840B8032F6F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:43341 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2FOOdt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jun 2012 10:33:49 -0400
In-Reply-To: <67D336C0-4529-477D-B0B3-D840B8032F6F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger (adilger@dilger.ca) wrote on 14 June 2012 23:34:
 >On 2012-06-14, at 10:20 PM, Carlos Carvalho wrote:
 >> Our server has suddenly become extremely slow in writes. With
 >> 
 >> % dd if=/dev/zero of=zero bs=2M count=2000
 >> 
 >> I get only 1.4MB/s in an almost idle machine. It has a raid6 with 6
 >> disks, running 3.3.7. 3.4.2 doesn't improve matters.
 >> 
 >> The important point is that it became so slow yesterday. No hardware
 >> has changed and all disks are fine. Reading from the filesystem is
 >> unaffected, at more than 85MB/s. The problem happens both in the root
 >> and home partitions.
 >> 
 >> During the dd the disk utilization measured by sar is small:
 >> 
 >> DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
 >> sdb     93.30    254.40    931.20     12.71      0.57      6.10      4.16     38.77
 >> sdc    100.50    244.00    970.40     12.08      0.76      7.59      3.80     38.20
 >> sdd    101.40    261.60    927.20     11.72      0.68      6.68      3.74     37.90
 >> sde     86.80    300.00    780.80     12.45      0.69      7.93      4.29     37.20
 >> sdf     82.90    315.20    810.40     13.58      0.55      6.60      4.39     36.37
 >> sda     96.70    220.00    984.00     12.45      0.47      4.87      3.72     35.94
 >> 
 >> So it seems that it's not a disk problem. Both filesystems reached 90%
 >> usage in space but less than 10% in inodes shortly before the slowness
 >> appeared. Now they're at 57% and 77% but still crawl. Could this be
 >> related?
 >
 >Definitely yes.  I was going to ask this question even before I got to
 >the end and saw your comment.  If the filesystem gets too full, it can
 >cause new allocations to become fragmented, and then even if you delete
 >other files, the fragmented files end up leaving individual allocated
 >blocks all around your filesystem, making future allocations bad also.
 >
 >You can run "e2freefrag" on the block device to report the current sizes
 >for free space in the filesystem.  There is the "e4defrag" tool that can
 >defragment files, but I don't recall whether this is working well or not.

Thanks. Here's the output for two of the filesystems:

Device: /dev/md1
Blocksize: 4096 bytes
Total blocks: 2621376
Free blocks: 1208294 (46.1%)

Min. free extent: 4 KB 
Max. free extent: 1482688 KB
Avg. free extent: 492 KB
Num. free extent: 9817

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    4K...    8K-  :           983           983    0.08%
    8K...   16K-  :          1067          2580    0.21%
   16K...   32K-  :          1700          9243    0.76%
   32K...   64K-  :          3245         37692    3.12%
   64K...  128K-  :           812         18279    1.51%
  128K...  256K-  :           703         31845    2.64%
  256K...  512K-  :           573         49964    4.14%
  512K... 1024K-  :           395         66984    5.54%
    1M...    2M-  :           222         79026    6.54%
    2M...    4M-  :            54         35170    2.91%
    4M...    8M-  :            14         17754    1.47%
    8M...   16M-  :            13         39447    3.26%
   16M...   32M-  :            15         85868    7.11%
   32M...   64M-  :            17        203310   16.83%
   64M...  128M-  :             1         18211    1.51%
  128M...  256M-  :             1         64895    5.37%
  256M...  512M-  :             1         76372    6.32%
    1G...    2G-  :             1        370672   30.68%




Device: /dev/md3
Blocksize: 4096 bytes
Total blocks: 488378357
Free blocks: 122356070 (25.1%)

Min. free extent: 4 KB 
Max. free extent: 2096512 KB
Avg. free extent: 9416 KB
Num. free extent: 51348

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
    4K...    8K-  :          7303          7303    0.01%
    8K...   16K-  :          4413         10063    0.01%
   16K...   32K-  :          2766         13920    0.01%
   32K...   64K-  :          3647         40394    0.03%
   64K...  128K-  :          2751         61344    0.05%
  128K...  256K-  :          2613        116467    0.10%
  256K...  512K-  :          2717        251263    0.21%
  512K... 1024K-  :          3511        658799    0.54%
    1M...    2M-  :          5158       1833440    1.50%
    2M...    4M-  :          6008       4421326    3.61%
    4M...    8M-  :          5247       7242579    5.92%
    8M...   16M-  :          1787       4422718    3.61%
   16M...   32M-  :          1442       7825134    6.40%
   32M...   64M-  :           719       7570736    6.19%
   64M...  128M-  :           547      14188577   11.60%
  128M...  256M-  :           309      13895787   11.36%
  256M...  512M-  :           203      18558351   15.17%
  512M... 1024M-  :           176      28142764   23.00%
    1G...    2G-  :            31      11647234    9.52%


It seems to me that free space is not excessively fragmented. Anyway,
in our case it was not the problem. I managed to put the disks in
another machine and there the behaviour was normal. Putting the disks
back in the production machine it is normal again(?!)... I had to
unplug all power cords first, otherwise it wouldn't even enter the
bios.

While running 3.4.2 there appeared some call traces and nfs stopped.
This didn't happen with 3.3.7 even when it was crawling, so I don't
know if it's a kernel problem. Here's the log, just in case:

Jun 14 14:13:38 hoggar kernel: Pid: 17751, comm: nfsd Tainted: G      D      3.4.2 #1 ASUSTek Computer INC. KFSN5-D/KFSN5-D
Jun 14 14:13:38 hoggar kernel: EIP: 0060:[<0005bd9c>] EFLAGS: 00010246 CPU: 0
Jun 14 14:13:38 hoggar kernel: EAX: fd8977e0 EBX: 00000000 ECX: 3686d477 EDX: 00000000
Jun 14 14:13:38 hoggar kernel: ESI: 00000000 EDI: 00000000 EBP: 00000001 ESP: e6281bd4
Jun 14 14:13:38 hoggar kernel: DS: 0068 ES: 0068 FS: 00d8 GS: 0068 SS: 0068
Jun 14 14:13:38 hoggar kernel: CR0: 8005003b CR2: 00000000 CR3: 01235000 CR4: 000007f0
Jun 14 14:13:38 hoggar kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jun 14 14:13:38 hoggar kernel: DR6: ffff0ff0 DR7: 00000400
Jun 14 14:13:38 hoggar kernel: Process nfsd (pid: 17751, ti=c2f19340 task=c2f190c0 task.ti=c2f19340)
Jun 14 14:13:38 hoggar kernel: Stack:
Jun 14 14:13:38 hoggar kernel: 0000005d 49bdf715 fff91232 00000000 0000003c 00000000 00000000 ee9f2334
Jun 14 14:13:38 hoggar kernel: 00000b90 0005c741 000000b1 00000000 00000001 000000b1 00000001 02809f00
Jun 14 14:13:38 hoggar kernel: c2f190c0 00000000 00000014 01000000 c2f190c0 00000001 00001770 ffffffff
Jun 14 14:13:38 hoggar kernel: Call Trace:
Jun 14 14:13:38 hoggar kernel: [<0005c741>] ? balance_dirty_pages_ratelimited_nr+0x303/0x517
Jun 14 14:13:38 hoggar kernel: [<00058015>] ? generic_file_buffered_write+0x176/0x1e0
Jun 14 14:13:38 hoggar kernel: [<00006b3e>] ? ich_force_enable_hpet+0xc/0x124
Jun 14 14:13:38 hoggar kernel: [<0005847e>] ? __generic_file_aio_write+0x3ff/0x431
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<001bc2cc>] ? memcpy_toiovec+0xcf/0x107
Jun 14 14:13:38 hoggar kernel: [<0008702b>] ? find_inode_fast+0x3e/0x6a
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<0005850d>] ? generic_file_aio_write+0x5d/0xb3
Jun 14 14:13:38 hoggar kernel: [<000bc397>] ? ext4_file_mmap+0x39/0x39
Jun 14 14:13:38 hoggar kernel: [<000bc57c>] ? ext4_file_write+0x1e5/0x233
Jun 14 14:13:38 hoggar kernel: [<000eb5fc>] ? nfsd_acceptable+0x6e/0x74
Jun 14 14:13:38 hoggar kernel: [<000bc397>] ? ext4_file_mmap+0x39/0x39
Jun 14 14:13:38 hoggar kernel: [<00075373>] ? do_sync_readv_writev+0x9e/0xd3
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<0007566b>] ? do_readv_writev+0x81/0x128
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<000bc397>] ? ext4_file_mmap+0x39/0x39
Jun 14 14:13:38 hoggar kernel: [<00075782>] ? vfs_writev+0x37/0x3c
Jun 14 14:13:38 hoggar kernel: [<000ec1e4>] ? nfsd_vfs_write.isra.13+0x92/0x1ba
Jun 14 14:13:38 hoggar kernel: [<0007255b>] ? kmem_cache_alloc+0x46/0x8e
Jun 14 14:13:38 hoggar kernel: [<000bc252>] ? ext4_release_file+0x76/0x76
Jun 14 14:13:38 hoggar kernel: [<0007349b>] ? __dentry_open.isra.17+0x153/0x220
Jun 14 14:13:38 hoggar kernel: [<00008001>] ? native_calibrate_tsc+0x3e0/0x4e5
Jun 14 14:13:38 hoggar kernel: [<000edb02>] ? nfsd_write+0xad/0xc2
Jun 14 14:13:38 hoggar kernel: [<000f1aa5>] ? nfsd3_proc_write+0x85/0x9a
Jun 14 14:13:38 hoggar kernel: [<00007b3e>] ? tsc_refine_calibration_work+0x13c/0x16c
Jun 14 14:13:38 hoggar kernel: [<000e9fb5>] ? nfsd_dispatch+0x84/0x12a
Jun 14 14:13:38 hoggar kernel: [<00210fdc>] ? svc_process+0x385/0x5fc
Jun 14 14:13:38 hoggar kernel: [<000186a3>] ? arch_pick_mmap_layout+0xf/0x11c
Jun 14 14:13:38 hoggar kernel: [<00007bc4>] ? native_sched_clock+0x56/0xad
Jun 14 14:13:38 hoggar kernel: [<000e9a97>] ? nfsd+0xc7/0xfc
Jun 14 14:13:38 hoggar kernel: [<000e99d0>] ? exportfs_decode_fh+0x218/0x218
Jun 14 14:13:38 hoggar kernel: [<000308a8>] ? kthread+0x68/0x6d
Jun 14 14:13:38 hoggar kernel: [<00030840>] ? kthread_flush_work_fn+0x8/0x8
Jun 14 14:13:38 hoggar kernel: [<0022cc86>] ? kernel_thread_helper+0x6/0xd
Jun 14 14:13:38 hoggar kernel: Code: f1 89 ca 29 c2 39 54 24 30 73 2c 89 c8 2b 44 24 30 8b 5c 24 08 46 0f af d8 f7 64 24 04 01 da 31 db 89 c1 39 f2 72 08 89 d0 31 d2 <f7> f6 89 c3 89 c8 f7 f6 89 da eb 1d 8b 4c 24 08 31 d2 c1 f9 1f 
Jun 14 14:13:38 hoggar kernel: EIP: [<0005bd9c>] bdi_position_ratio.isra.14+0x141/0x1a9 SS:ESP 0068:e6281bd4
Jun 14 14:13:38 hoggar kernel: ---[ end trace c19aa5d263f5a20d ]---
