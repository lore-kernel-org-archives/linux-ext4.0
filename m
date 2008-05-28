From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Delayed allocation and journal locking order inversion.
Date: Wed, 28 May 2008 14:46:48 +0530
Message-ID: <20080528091648.GA15851@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:33695 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYE1JRe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 May 2008 05:17:34 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4S9GvVU003085
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 14:46:57 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4S9Gcbt450572
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 14:46:38 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4S9Gvqo025437
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 14:46:57 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan and Mingming,

I am observing hangs with the delalloc with locking order inversion
patches. I guess we can't start journal and call write_cache_pages.
The process get stuck as below

fsstress      D 00000008     0  2520      1
       c69c9d70 00000046 c69c9d28 00000008 c6a300a0 c69c50e0 c69c5244 c1210d80 
       00000000 c7a102a0 c69c50e0 c043c960 c69c9da8 c69c9d6c c0246fe8 00000000 
       00000000 00000000 c69c9da8 c1210d80 c69c9da8 c11c0998 c69c9d7c c043a8cb 
Call Trace:
 [<c043c960>] ? _spin_unlock_irqrestore+0x36/0x58
 [<c0246fe8>] ? blk_unplug+0x63/0x6b
 [<c043a8cb>] io_schedule+0x1e/0x28
 [<c014aac1>] sync_page+0x36/0x3a
 [<c043aa17>] __wait_on_bit_lock+0x30/0x59
 [<c014aa8b>] ? sync_page+0x0/0x3a
 [<c014aa77>] __lock_page+0x4e/0x56
 [<c01325a4>] ? wake_bit_function+0x0/0x43
 [<c014ffca>] write_cache_pages+0x120/0x296
 [<c018c516>] ? __mpage_da_writepage+0x0/0x105
 [<c043c89d>] ? _spin_unlock+0x27/0x3c
 [<c018bde8>] mpage_da_writepages+0x5c/0x7e
 [<c01faa8f>] ? jbd2_journal_start+0xce/0xf0
 [<c01faaa4>] ? jbd2_journal_start+0xe3/0xf0
 [<c01d893b>] ? ext4_da_get_block_write+0x0/0x151
 [<c01d8cc6>] ext4_da_writepages+0xbe/0x116
 [<c01d8c08>] ? ext4_da_writepages+0x0/0x116
 [<c015018a>] do_writepages+0x23/0x34
 [<c0180ffa>] __writeback_single_inode+0x12a/0x260
 [<c0181480>] sync_sb_inodes+0x18d/0x25b
 [<c01815d0>] sync_inodes_sb+0x82/0x94
 [<c0181638>] __sync_inodes+0x56/0x9c
 [<c0181692>] sync_inodes+0x14/0x2c
 [<c0183bc1>] do_sync+0x14/0x50
 [<c0183c0a>] sys_sync+0xd/0x13
 [<c0103931>] sysenter_past_esp+0x6a/0xb1

And kjournald is stuck because it is expecting journal_stop to be
called.

kjournald2    D 00007e87     0  2511      2
       c69b1f00 00000046 c69b1ec0 00007e87 c6a04140 c7ae9060 c7ae91c4 c1210d80 
       00000000 c7a10500 c7ae9060 c69b5c24 c69b1ef4 00000246 c01fbf82 00000246 
       c69b5c14 c79fe41c c69b5c14 c69b5c14 c79fe41c c69b5d54 c69b1f9c c01fbf87 
Call Trace:
 [<c01fbf82>] ? jbd2_journal_commit_transaction+0x139/0x1167
 [<c01fbf87>] jbd2_journal_commit_transaction+0x13e/0x1167
 [<c010811a>] ? native_sched_clock+0x92/0xa6
 [<c013a261>] ? lock_release_holdtime+0x50/0x56
 [<c013bff7>] ? trace_hardirqs_on+0xe9/0x111
 [<c0132571>] ? autoremove_wake_function+0x0/0x33
 [<c0129d5f>] ? try_to_del_timer_sync+0x48/0x4f
 [<c0200149>] kjournald2+0xac/0x1e3
 [<c0132571>] ? autoremove_wake_function+0x0/0x33
 [<c020009d>] ? kjournald2+0x0/0x1e3
 [<c01324af>] kthread+0x3b/0x64
 [<c0132474>] ? kthread+0x0/0x64
 [<c0104633>] kernel_thread_helper+0x7/0x10
 =======================


Most of the other process are now stuck on i_mutex. because one of the
journal_start is now stuck at

fsstress      D 00006e2e     0  2517      1
       c6985d64 00000046 c6985d24 00006e2e c697d0a0 c7a20080 c7a201e4 c1210d80 
       00000000 c7a52c40 c7a20080 c69b5c24 c6985d58 00000246 c01fa915 00000246 
       c69b5c14 c79fe3e0 c69b5c14 c69b5c8c c79fe3e0 c6985d84 c6985da4 c01fa91a 
Call Trace:
 [<c01fa915>] ? start_this_handle+0x2b1/0x35d
 [<c01fa91a>] start_this_handle+0x2b6/0x35d
 [<c0132571>] ? autoremove_wake_function+0x0/0x33
 [<c01faa68>] jbd2_journal_start+0xa7/0xf0
 [<c01dde10>] ext4_journal_start_sb+0x40/0x42
 [<c01d9120>] ext4_dirty_inode+0x24/0x8a
 [<c0181788>] __mark_inode_dirty+0x26/0x146
 [<c0179857>] file_update_time+0x8b/0xb4
 [<c014be0c>] __generic_file_aio_write_nolock+0x2fc/0x445
 [<c013be64>] ? mark_held_locks+0x41/0x5c
 [<c013bff7>] ? trace_hardirqs_on+0xe9/0x111
 [<c014bfab>] generic_file_aio_write+0x56/0xa9
 [<c01d3e22>] ext4_file_write+0x9c/0x110
 [<c0168129>] do_sync_write+0xab/0xe9
 [<c014aaea>] ? unlock_page+0x25/0x28
 [<c0132571>] ? autoremove_wake_function+0x0/0x33
 [<c010811a>] ? native_sched_clock+0x92/0xa6
 [<c013a261>] ? lock_release_holdtime+0x50/0x56
 [<c016807e>] ? do_sync_write+0x0/0xe9
 [<c0168805>] vfs_write+0x8c/0x108
 [<c0168d9e>] sys_write+0x3b/0x60
 [<c0103931>] sysenter_past_esp+0x6a/0xb1


The full dmesg log is at 
http://www.radian.org/~kvaneesh/ext4/delalloc-lockinversion/dmesg-1.log

Also starting journal in writepages make unmount throw lockdep errors.

unlink does journal_start and lock_super.
umount does lock_super and later it need to sync_inodes does writepages
which does a journal_start.

I guess we will have to rework the delalloc related changes.

-aneesh
