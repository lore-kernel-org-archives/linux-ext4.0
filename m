From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Fri, 26 Feb 2010 14:46:07 +0300
Message-ID: <87ljegb4ow.fsf@openvz.org>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Karsten Weiss <K.Weiss@science-computing.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38029 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab0BZLqN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Feb 2010 06:46:13 -0500
Received: by bwz1 with SMTP id 1so10989bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 03:46:11 -0800 (PST)
In-Reply-To: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de>
	(Karsten Weiss's message of "Fri, 26 Feb 2010 13:18:47 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Karsten Weiss <K.Weiss@science-computing.de> writes:

> Hi,
>
> (please Cc: me, I'm no subscriber)
>
> we were performing some ext4 tests on a 16 TB GPT partition and ran into 
> this issue when writing a single large file with dd and syncing 
> afterwards.
>
> The problem: dd is fast (cached) but the following sync is *very* slow.
>
> # /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB bs=1M count=10000 && sync"
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 15.9423 seconds, 658 MB/s
> 0.01user 441.40system 7:26.10elapsed 98%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+794minor)pagefaults 0swaps
>
> dd: ~16 seconds
> sync: ~7 minutes
>
> (The same test finishes in 57s with xfs!)
>
> Here's the "iostat -m /dev/sdb 1" output during dd write:
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0,00    0,00    6,62   19,35    0,00   74,03
>
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sdb             484,00         0,00       242,00          0        242
>
> "iostat -m /dev/sdb 1" during the sync looks like this
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0,00    0,00   12,48    0,00    0,00   87,52
>
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sdb              22,00         0,00         8,00          0          8
>
> However, the sync performance is fine if we ...
>
> * use xfs or
> * disable the ext4 journal or
> * disable ext4 extents (but with enabled journal)
>
> Here's a kernel profile of the test:
>
> # readprofile -r
> # /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB_3 bs=1M count=10000 && sync"
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 15.8261 seconds, 663 MB/s
> 0.01user 448.55system 7:32.89elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+788minor)pagefaults 0swaps
> # readprofile -m /boot/System.map-2.6.18-190.el5 | sort -nr -k 3 | head -15
> 3450304 default_idle                             43128.8000
>   9532 mod_zone_page_state                      733.2308
>  58594 find_get_pages                           537.5596
>  58499 find_get_pages_tag                       427.0000
>  72404 __set_page_dirty_nobuffers               310.7468
>  10740 __wake_up_bit                            238.6667
>   7786 unlock_page                              165.6596
>   1996 dec_zone_page_state                      153.5385
>  12230 clear_page_dirty_for_io                   63.0412
>   5938 page_waitqueue                            60.5918
>  14440 release_pages                             41.7341
>  12664 __mark_inode_dirty                        34.6011
>   5281 copy_user_generic_unrolled                30.7035
>    323 redirty_page_for_writepage                26.9167
>  15537 write_cache_pages                         18.9939
>
> Here are three call traces from the "sync" command:
>
> sync          R  running task       0  5041   5032                     (NOTLB)
>  00000000ffffffff 000000000000000c ffff81022bb16510 00000000001ec2a3
>  ffff81022bb16548 ffffffffffffff10 ffffffff800d1964 0000000000000010
>  0000000000000286 ffff8101ff56bb48 0000000000000018 ffff81033686e970
> Call Trace:
>  [<ffffffff800d1964>] page_mkclean+0x255/0x281
>  [<ffffffff8000eab5>] find_get_pages_tag+0x34/0x89
>  [<ffffffff800f4467>] write_cache_pages+0x21b/0x332
>  [<ffffffff886fad9d>] :ext4:__mpage_da_writepage+0x0/0x162
>  [<ffffffff886fc2f1>] :ext4:ext4_da_writepages+0x317/0x4fe
>  [<ffffffff8005b1f0>] do_writepages+0x20/0x2f
>  [<ffffffff8002fefc>] __writeback_single_inode+0x1ae/0x328
>  [<ffffffff8004a667>] wait_on_page_writeback_range+0xd6/0x12e
>  [<ffffffff80020f0d>] sync_sb_inodes+0x1b5/0x26f
>  [<ffffffff800f3b0b>] sync_inodes_sb+0x99/0xa9
>  [<ffffffff800f3b78>] __sync_inodes+0x5d/0xaa
>  [<ffffffff800f3bd6>] sync_inodes+0x11/0x29
>  [<ffffffff800e1bb0>] do_sync+0x12/0x5a
>  [<ffffffff800e1c06>] sys_sync+0xe/0x12
>  [<ffffffff8005e28d>] tracesys+0xd5/0xe0
>
> sync          R  running task       0  5041   5032                     (NOTLB)
>  ffff81022a3e4e88 ffffffff8000e930 ffff8101ff56bee8 ffff8101ff56bcd8
>  0000000000000000 ffffffff886fbdbc ffff8101ff56bc68 ffff8101ff56bc68
>  00000000002537c3 000000000001dfcd 0000000000000007 ffff8101ff56bc90
> Call Trace:
>  [<ffffffff8000e9c4>] __set_page_dirty_nobuffers+0xde/0xe9
>  [<ffffffff8001b694>] find_get_pages+0x2f/0x6d
>  [<ffffffff886f8170>] :ext4:mpage_da_submit_io+0xd0/0x12c
>  [<ffffffff886fc31d>] :ext4:ext4_da_writepages+0x343/0x4fe
>  [<ffffffff8005b1f0>] do_writepages+0x20/0x2f
>  [<ffffffff8002fefc>] __writeback_single_inode+0x1ae/0x328
>  [<ffffffff8004a667>] wait_on_page_writeback_range+0xd6/0x12e
>  [<ffffffff80020f0d>] sync_sb_inodes+0x1b5/0x26f
>  [<ffffffff800f3b0b>] sync_inodes_sb+0x99/0xa9
>  [<ffffffff800f3b78>] __sync_inodes+0x5d/0xaa
>  [<ffffffff800f3bd6>] sync_inodes+0x11/0x29
>  [<ffffffff800e1bb0>] do_sync+0x12/0x5a
>  [<ffffffff800e1c06>] sys_sync+0xe/0x12
>  [<ffffffff8005e28d>] tracesys+0xd5/0xe0
>
> sync          R  running task       0  5353   5348                     (NOTLB)
>  ffff810426e04048 0000000000001200 0000000100000001 0000000000000001
>  0000000100000000 ffff8103dcecadf8 ffff810426dfd000 ffff8102ebd81b48
>  ffff810426e04048 ffff810239bbbc40 0000000000000008 00000000008447f8
> Call Trace:
>  [<ffffffff801431db>] elv_merged_request+0x1e/0x26
>  [<ffffffff8000c02b>] __make_request+0x324/0x401
>  [<ffffffff8005c6cf>] cache_alloc_refill+0x106/0x186
>  [<ffffffff886f6bf9>] :ext4:walk_page_buffers+0x65/0x8b
>  [<ffffffff8000e9c4>] __set_page_dirty_nobuffers+0xde/0xe9
>  [<ffffffff886fbd42>] :ext4:ext4_writepage+0x9b/0x333
>  [<ffffffff886f8170>] :ext4:mpage_da_submit_io+0xd0/0x12c
>  [<ffffffff886fc31d>] :ext4:ext4_da_writepages+0x343/0x4fe
>  [<ffffffff8005b1f0>] do_writepages+0x20/0x2f
>  [<ffffffff8002fefc>] __writeback_single_inode+0x1ae/0x328
>  [<ffffffff8004a667>] wait_on_page_writeback_range+0xd6/0x12e
>  [<ffffffff80020f0d>] sync_sb_inodes+0x1b5/0x26f
>  [<ffffffff800f3b0b>] sync_inodes_sb+0x99/0xa9
>  [<ffffffff800f3b78>] __sync_inodes+0x5d/0xaa
>  [<ffffffff800f3bd6>] sync_inodes+0x11/0x29
>  [<ffffffff800e1bb0>] do_sync+0x12/0x5a
>  [<ffffffff800e1c06>] sys_sync+0xe/0x12
>  [<ffffffff8005e28d>] tracesys+0xd5/0xe0
>
> I've tried some more options. These do *not* influence the (bad) result:
>
> * data=writeback and data=ordered
> * disabling/enabling uninit_bg 
> * max_sectors_kb=512 or 4096
> * io scheduler: cfq or noop
>
> Some background information about the system:
>
> OS: CentOS 5.4
> Memory: 16 GB
> CPUs: 2x Quad-Core Opteron 2356
> IO scheduler: CFQ
> Kernels:
> * 2.6.18-164.11.1.el5 x86_64 (latest CentOS 5.4 kernel)
> * 2.6.18-190.el5 x86_64 (latest Red Hat EL5 test kernel I've found from
>   http://people.redhat.com/jwilson/el5/ which contains an ext4 version 
>   which (according to the rpm's changelog) was updated from the 2.6.32
>   ext4 codebase.
Hmm.. It is hard to predict differences between vanilla tree.
This is no only ext4 related. writeback path is changed dramatically.
It is not easy to port writeback code to 2.6.18 with full performance
improvements but without introducing new issues.
> * I did not try a vanilla kernel so far.
IMHO It would be really good to know vanilla kernel's stats.
>
> # df -h /dev/sdb{1,2}
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb1              15T  9.9G   14T   1% /mnt/large
> /dev/sdb2             7.3T  179M  7.0T   1% /mnt/small
>
> (parted) print
> Model: easyRAID easyRAID_Q16PS (scsi)
> Disk /dev/sdb: 24,0TB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>
> Number  Start   End     Size    File system  Name   Flags
>  1      1049kB  16,0TB  16,0TB  ext3         large
>  2      16,0TB  24,0TB  8003GB  ext3         small
>
> ("start 1049kB" is at sector 2048)
>
> sdb is a FC HW-RAID (easyRAID_Q16PS) and consists of a RAID6 volume 
> created from 14 disks with chunk size 128kb.
>
> QLogic Fibre Channel HBA Driver: 8.03.01.04.05.05-k
>  QLogic QLE2462 - PCI-Express Dual Channel 4Gb Fibre Channel HBA
>  ISP2432: PCIe (2.5Gb/s x4) @ 0000:01:00.1 hdma+, host#=8, fw=4.04.09 (486)
>
> The ext4 filesystem was created with
>
> mkfs.ext4 -T ext4,largefile4 -E stride=32,stripe-width=$((32*(14-2))) /dev/sdb1
> or
> mkfs.ext4 -T ext4 /dev/sdb1
>
> Mount options: defaults,noatime,data=writeback
>
> Any ideas?
