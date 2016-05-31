From: Eryu Guan <eguan@redhat.com>
Subject: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Tue, 31 May 2016 22:09:22 +0800
Message-ID: <20160531140922.GM5140@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbcEaOJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2016 10:09:25 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I noticed that generic/130 hangs starting from 4.7-rc1 kernel, on non-4k
block size ext4 (x86_64 host). And I bisected to commit 06bd3c36a733
("ext4: fix data exposure after a crash").

It's the sub-test "Small Vector Sync" in generic/130 hangs the kernel,
and I can reproduce it on different hosts, both bare metal and kvm
guest.

Thanks,
Eryu

P.S-1: a slightly simplified reproducer

#!/bin/bash
dev=/dev/sda5
mnt=/mnt/ext4

mkfs -t ext4 -b 1024 $dev
mount $dev $mnt

echo "abcdefghijklmnopqrstuvwxyz" > $mnt/testfile
xfs_io -f -s -c "pread -v 0 1" -c "pread -v 1 1" -c "pread -v 2 1" -c "pread -v 3 1" -c "pread -v 4 1" -c "pread -v 5 1" -c "pread -v 6 1" -c "pread -v 7 1" -c "pread -v 8 1" -c "pread -v 9 1" -c "pread -v 10 1" -c "pread -v 11 1" -c "pread -v 12 1" -c "pread -v 13 13" -c "pwrite -S 0x61 4090 1" -c "pwrite -S 0x62 4091 1" -c "pwrite -S 0x63 4092 1" -c "pwrite -S 0x64 4093 1" -c "pwrite -S 0x65 4094 1" -c "pwrite -S 0x66 4095 1" -c "pwrite -S 0x67 4096 1" -c "pwrite -S 0x68 4097 1" -c "pwrite -S 0x69 4098 1" -c "pwrite -S 0x6A 4099 1" -c "pwrite -S 0x6B 4100 1" -c "pwrite -S 0x6C 4101 1" -c "pwrite -S 0x6D 4102 1" -c "pwrite -S 0x6E 4103 1" -c "pwrite -S 0x6F 4104 1" -c "pwrite -S 0x70 4105 1" -c "pread -v 4090 4" -c "pread -v 4094 4" -c "pread -v 4098 4" -c "pread -v 4102 4" -c "pwrite -S 
 0x61 10000000000 1" -c "pwrite -S 0x62 10000000001 1" -c "pwrite -S 0x63 10000000002 1" -c "pwrite -S 0x64 10000000003 1" -c "pwrite -S 0x65 10000000004 1" -c "pwrite -S 0x66 10000000005 1" -c "pwrite -S 0x67 10000000006 1" -c "pwrite -S 0x68 10000000007 1" -c "pwrite -S 0x69 10000000008 1" -c "pwrite -S 0x6A 10000000009 1" -c "pwrite -S 0x6B 10000000010 1" -c "pwrite -S 0x6C 10000000011 1" -c "pwrite -S 0x6D 10000000012 1" -c "pwrite -S 0x6E 10000000013 1" -c "pwrite -S 0x6F 10000000014 1" -c "pwrite -S 0x70 10000000015 1" -c "pread -v 10000000000 4" -c "pread -v 10000000004 4" -c "pread -v 10000000008 4" -c "pread -v 10000000012 4" $mnt/testfile


P.S-2: sysrq-w output
[43360.261177] sysrq: SysRq : Show Blocked State 
[43360.265588]   task                        PC stack   pid father 
[43360.271579] jbd2/sda5-8     D ffff880225d3b9e8     0 21723      2 0x00000080 
[43360.278718]  ffff880225d3b9e8 0000000000000000 ffff88022695bd80 0000000000002000 
[43360.286229]  ffff880225d3c000 0000000000000000 7fffffffffffffff ffff88022ffaa790 
[43360.293741]  ffffffff816c2f50 ffff880225d3ba00 ffffffff816c26e5 ffff88022fc17ec0 
[43360.301268] Call Trace: 
[43360.303737]  [<ffffffff816c2f50>] ? bit_wait+0x50/0x50 
[43360.308900]  [<ffffffff816c26e5>] schedule+0x35/0x80 
[43360.313884]  [<ffffffff816c5691>] schedule_timeout+0x231/0x2d0 
[43360.319733]  [<ffffffff81318ad0>] ? queue_unplugged+0xa0/0xb0 
[43360.325505]  [<ffffffff810fc44c>] ? ktime_get+0x3c/0xb0 
[43360.330739]  [<ffffffff816c2f50>] ? bit_wait+0x50/0x50 
[43360.335895]  [<ffffffff816c1fb6>] io_schedule_timeout+0xa6/0x110 
[43360.341917]  [<ffffffff816c2f6b>] bit_wait_io+0x1b/0x60 
[43360.347161]  [<ffffffff816c2b10>] __wait_on_bit+0x60/0x90 
[43360.352580]  [<ffffffff8119025e>] wait_on_page_bit+0xce/0xf0 
[43360.358256]  [<ffffffff810cd1c0>] ? autoremove_wake_function+0x40/0x40 
[43360.364798]  [<ffffffff8119037f>] __filemap_fdatawait_range+0xff/0x180 
[43360.371341]  [<ffffffff8131b127>] ? submit_bio+0x77/0x150 
[43360.376758]  [<ffffffff81312b9b>] ? bio_alloc_bioset+0x1ab/0x2d0 
[43360.382782]  [<ffffffffa06bffa9>] ? jbd2_journal_write_metadata_buffer+0x279/0x430 [jbd2] 
[43360.390973]  [<ffffffff81190414>] filemap_fdatawait_range+0x14/0x30 
[43360.397264]  [<ffffffff81190453>] filemap_fdatawait+0x23/0x30 
[43360.403032]  [<ffffffffa06b7787>] jbd2_journal_commit_transaction+0x677/0x1860 [jbd2] 
[43360.410881]  [<ffffffff81036bb9>] ? sched_clock+0x9/0x10 
[43360.416195]  [<ffffffff8102c6d9>] ? __switch_to+0x219/0x5c0 
[43360.421795]  [<ffffffffa06bcd5a>] kjournald2+0xca/0x260 [jbd2] 
[43360.427649]  [<ffffffff810cd180>] ? prepare_to_wait_event+0xf0/0xf0 
[43360.433936]  [<ffffffffa06bcc90>] ? commit_timeout+0x10/0x10 [jbd2] 
[43360.440215]  [<ffffffff810a92b8>] kthread+0xd8/0xf0 
[43360.445105]  [<ffffffff816c663f>] ret_from_fork+0x1f/0x40 
[43360.450519]  [<ffffffff810a91e0>] ? kthread_park+0x60/0x60 
[43360.456025] xfs_io          D ffff880082503960     0 21895  21474 0x00000080 
[43360.463145]  ffff880082503960 0000000000000246 ffff880220805200 ffff880225d5f088 
[43360.470681]  ffff880082504000 0000000000000012 ffff880225d5f088 ffff880225d5f024 
[43360.478186]  ffff8800825039a8 ffff880082503978 ffffffff816c26e5 ffff880225d5f000 
[43360.485707] Call Trace: 
[43360.488176]  [<ffffffff816c26e5>] schedule+0x35/0x80 
[43360.493162]  [<ffffffffa06bc899>] jbd2_log_wait_commit+0xa9/0x130 [jbd2] 
[43360.499877]  [<ffffffff810cd180>] ? prepare_to_wait_event+0xf0/0xf0 
[43360.506163]  [<ffffffffa06b560c>] jbd2_journal_stop+0x38c/0x3e0 [jbd2] 
[43360.512731]  [<ffffffffa07337fc>] __ext4_journal_stop+0x3c/0xa0 [ext4] 
[43360.519278]  [<ffffffffa0703bce>] ext4_writepages+0x8ce/0xd70 [ext4] 
[43360.525660]  [<ffffffff8119e8ae>] do_writepages+0x1e/0x30 
[43360.531068]  [<ffffffff81192996>] __filemap_fdatawrite_range+0xc6/0x100 
[43360.537699]  [<ffffffff81192b01>] filemap_write_and_wait_range+0x41/0x90 
[43360.544420]  [<ffffffffa06fa971>] ext4_sync_file+0xb1/0x320 [ext4] 
[43360.550619]  [<ffffffff8124ca7d>] vfs_fsync_range+0x3d/0xb0 
[43360.556223]  [<ffffffffa06f9fad>] ext4_file_write_iter+0x22d/0x330 [ext4] 
[43360.563031]  [<ffffffff811937b7>] ? generic_file_read_iter+0x627/0x7b0 
[43360.569569]  [<ffffffff812180b3>] __vfs_write+0xe3/0x160 
[43360.574888]  [<ffffffff81219302>] vfs_write+0xb2/0x1b0 
[43360.580046]  [<ffffffff8121a8f7>] SyS_pwrite64+0x87/0xb0 
[43360.585366]  [<ffffffff81003b12>] do_syscall_64+0x62/0x110 
[43360.590869]  [<ffffffff816c64e1>] entry_SYSCALL64_slow_path+0x25/0x25 
