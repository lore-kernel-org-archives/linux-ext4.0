From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: circular locking dependency detected with lock inversion
Date: Tue, 17 Jun 2008 22:32:49 +0530
Message-ID: <20080617170249.GB29335@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:33265 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755125AbYFQRDf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 13:03:35 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5HH38Ro003760
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 22:33:08 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5HH2H2C811248
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 22:32:17 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5HH37Hj021837
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 22:33:07 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc6-autokern1 #1
-------------------------------------------------------
umount/28231 is trying to acquire lock:
 (&ei->i_data_sem){----}, at: [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c

but task is already holding lock:
 (&type->s_lock_key#7){--..}, at: [<ffffffff8028a856>] lock_super+0x22/0x24

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&type->s_lock_key#7){--..}:
       [<ffffffff8024dbcf>] __lock_acquire+0xc3c/0xe20
       [<ffffffff8024e052>] lock_acquire+0x53/0x6d
       [<ffffffff80503ae2>] mutex_lock_nested+0xd6/0x27d
       [<ffffffff8028a856>] lock_super+0x22/0x24
       [<ffffffff803105e1>] ext4_orphan_add+0x29/0x17d
       [<ffffffff8031a538>] ext4_ext_truncate+0x91/0x19c
       [<ffffffff8030c984>] ext4_truncate+0xbb/0x568
       [<ffffffff8026f07e>] vmtruncate+0xc2/0xe0
       [<ffffffff8029d586>] inode_setattr+0x28/0x123
       [<ffffffff8030ad2f>] ext4_setattr+0x226/0x284
       [<ffffffff8029d7ea>] notify_change+0x169/0x27b
       [<ffffffff80287886>] do_truncate+0x60/0x7e
       [<ffffffff80287a16>] sys_truncate+0x172/0x1a8
       [<ffffffff80222721>] sys32_truncate64+0x16/0x18
       [<ffffffff802223a2>] ia32_sysret+0x0/0xa
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&ei->i_data_sem){----}:
       [<ffffffff8024dab7>] __lock_acquire+0xb24/0xe20
       [<ffffffff8024e052>] lock_acquire+0x53/0x6d
       [<ffffffff805045f7>] down_read+0x25/0x31
       [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
       [<ffffffff8030c4cc>] ext4_get_block+0xb5/0xf3
       [<ffffffff802ab7ee>] generic_block_bmap+0x3a/0x40
       [<ffffffff803093bb>] ext4_bmap+0x70/0x79
       [<ffffffff8029c9aa>] bmap+0x1f/0x27
       [<ffffffff80335c8d>] jbd2_journal_bmap+0x2c/0x8a
       [<ffffffff80335fe5>] jbd2_journal_next_log_block+0x76/0x7e
       [<ffffffff803362cd>] jbd2_journal_get_descriptor_buffer+0x17/0x80
       [<ffffffff80331b15>] jbd2_journal_commit_transaction+0x56e/0x1045
       [<ffffffff803356c4>] jbd2_journal_destroy+0xfc/0x250
       [<ffffffff80312acf>] ext4_put_super+0x3e/0x213
       [<ffffffff8028a96a>] generic_shutdown_super+0x63/0xf8
       [<ffffffff8028b6d6>] kill_block_super+0x12/0x27
       [<ffffffff8028a81f>] deactivate_super+0x4c/0x61
       [<ffffffff8029f28b>] mntput_no_expire+0xed/0x120
       [<ffffffff802a0d30>] sys_umount+0x312/0x327
       [<ffffffff802223a2>] ia32_sysret+0x0/0xa
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by umount/28231:
 #0:  (&type->s_umount_key#14){----}, at: [<ffffffff8028a817>] deactivate_super+0x44/0x61
 #1:  (&type->s_lock_key#7){--..}, at: [<ffffffff8028a856>] lock_super+0x22/0x24

stack backtrace:
Pid: 28231, comm: umount Not tainted 2.6.26-rc6-autokern1 #1

Call Trace:
 [<ffffffff8024be6d>] print_circular_bug_tail+0x70/0x7b
 [<ffffffff8024dab7>] __lock_acquire+0xb24/0xe20
 [<ffffffff8024c093>] ? find_usage_backwards+0xba/0xe0
 [<ffffffff8024e052>] lock_acquire+0x53/0x6d
 [<ffffffff8030be45>] ? ext4_get_blocks_wrap+0x36/0x15c
 [<ffffffff805045f7>] down_read+0x25/0x31
 [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
 [<ffffffff8030c4cc>] ext4_get_block+0xb5/0xf3
 [<ffffffff802ab7ee>] generic_block_bmap+0x3a/0x40
 [<ffffffff8024d799>] ? __lock_acquire+0x806/0xe20
 [<ffffffff8024d799>] ? __lock_acquire+0x806/0xe20
 [<ffffffff803093bb>] ext4_bmap+0x70/0x79
 [<ffffffff8029c9aa>] bmap+0x1f/0x27
 [<ffffffff80335c8d>] jbd2_journal_bmap+0x2c/0x8a
 [<ffffffff80335fe5>] jbd2_journal_next_log_block+0x76/0x7e
 [<ffffffff803362cd>] jbd2_journal_get_descriptor_buffer+0x17/0x80
 [<ffffffff80331b15>] jbd2_journal_commit_transaction+0x56e/0x1045
 [<ffffffff80505a0f>] ? _spin_unlock_irq+0x28/0x4e
 [<ffffffff8024ce49>] ? trace_hardirqs_on+0xed/0x111
 [<ffffffff80505a1a>] ? _spin_unlock_irq+0x33/0x4e
 [<ffffffff8024d799>] ? __lock_acquire+0x806/0xe20
 [<ffffffff803356c4>] jbd2_journal_destroy+0xfc/0x250
 [<ffffffff8024340b>] ? autoremove_wake_function+0x0/0x36
 [<ffffffff80505950>] ? _spin_unlock+0x45/0x49
 [<ffffffff8024340b>] ? autoremove_wake_function+0x0/0x36
 [<ffffffff80312acf>] ext4_put_super+0x3e/0x213
 [<ffffffff80312a91>] ? ext4_put_super+0x0/0x213
 [<ffffffff80312a91>] ? ext4_put_super+0x0/0x213
 [<ffffffff8028a96a>] generic_shutdown_super+0x63/0xf8
 [<ffffffff8028b6d6>] kill_block_super+0x12/0x27
 [<ffffffff8028a81f>] deactivate_super+0x4c/0x61
 [<ffffffff8029f28b>] mntput_no_expire+0xed/0x120
 [<ffffffff802a0d30>] sys_umount+0x312/0x327
 [<ffffffff80245fe9>] ? up_read+0x24/0x28
 [<ffffffff805052a6>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8024ce49>] ? trace_hardirqs_on+0xed/0x111
 [<ffffffff805052a6>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff803a9906>] ? __up_read+0x17/0x9b
 [<ffffffff803a9906>] ? __up_read+0x17/0x9b
 [<ffffffff802223a2>] ia32_sysret+0x0/0xa

