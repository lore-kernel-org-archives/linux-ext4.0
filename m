From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: possible circular locking dependency detected (mmap_sem and
	i_alloc_sem_key)
Date: Tue, 12 May 2009 20:17:35 +0530
Message-ID: <20090512144735.GA23862@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38757 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZELOry (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 10:47:54 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4CElECt021268
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 00:47:14 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4CEls301511444
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 00:47:54 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4CElsCM030323
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 00:47:54 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30-rc5-autokern1 #1
-------------------------------------------------------
fsx-linux/11055 is trying to acquire lock:
 (&sb->s_type->i_alloc_sem_key#6){+++++.}, at: [<c04e307b>] ext4_page_mkwrite+0x34/0x174

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<c06a9eae>] do_page_fault+0x1cc/0x2f1

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&mm->mmap_sem){++++++}:
       [<c0447f29>] validate_chain+0x849/0xb1e
       [<c0448876>] __lock_acquire+0x678/0x710
       [<c0449a1f>] lock_acquire+0xa8/0xc5
       [<c047eb45>] might_fault+0x52/0x72
       [<c054910d>] copy_to_user+0x28/0x3f
       [<c049c3c1>] filldir+0x88/0xc8
       [<c04d08ca>] sysfs_readdir+0x11d/0x156
       [<c049c469>] vfs_readdir+0x68/0x94
       [<c049c6bb>] sys_getdents+0x5f/0xa0
       [<c0402a25>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #3 (sysfs_mutex){+.+.+.}:
       [<c0447f29>] validate_chain+0x849/0xb1e
       [<c0448876>] __lock_acquire+0x678/0x710
       [<c0449a1f>] lock_acquire+0xa8/0xc5
       [<c06a657f>] mutex_lock_nested+0x3f/0x292
       [<c04d0b50>] sysfs_addrm_start+0x23/0x90
       [<c04d0f56>] sysfs_remove_dir+0x36/0x6a
       [<c0543a78>] kobject_del+0xf/0x2c
       [<c04eb7cb>] ext4_put_super+0xb4/0x22d
       [<c0492568>] generic_shutdown_super+0x5d/0xc4
       [<c04925ec>] kill_block_super+0x1d/0x31
       [<c04926a8>] deactivate_super+0x57/0x6a
       [<c04a326f>] mntput_no_expire+0xbd/0xee
       [<c04a3747>] sys_umount+0x284/0x2cf
       [<c0402944>] sysenter_do_call+0x12/0x32
       [<ffffffff>] 0xffffffff

-> #2 (&type->s_lock_key#9){+.+...}:
       [<c0447f29>] validate_chain+0x849/0xb1e
       [<c0448876>] __lock_acquire+0x678/0x710
       [<c0449a1f>] lock_acquire+0xa8/0xc5
       [<c06a657f>] mutex_lock_nested+0x3f/0x292
       [<c0491cd6>] lock_super+0x1b/0x1d
       [<c04e79a5>] ext4_orphan_add+0x110/0x13b
       [<c04e8ad5>] ext4_unlink+0x177/0x20b
       [<c0497fea>] vfs_unlink+0xa0/0x105
       [<c0499f15>] do_unlinkat+0x8d/0x126
       [<c0499fbe>] sys_unlink+0x10/0x12
       [<c0402944>] sysenter_do_call+0x12/0x32
       [<ffffffff>] 0xffffffff

-> #1 (jbd2_handle){+.+.+.}:
       [<c0447f29>] validate_chain+0x849/0xb1e
       [<c0448876>] __lock_acquire+0x678/0x710
       [<c0449a1f>] lock_acquire+0xa8/0xc5
       [<c04ff59e>] jbd2_journal_start+0xe5/0xf2
       [<c04ea4ed>] ext4_journal_start_sb+0x44/0x64
       [<c04f2a1d>] ext4_ext_truncate+0x38/0x7d1
       [<c04e2ace>] ext4_truncate+0x73/0x431
       [<c047ec66>] vmtruncate+0x101/0x125
       [<c04a14ca>] inode_setattr+0x71/0x143
       [<c04e48dd>] ext4_setattr+0x23f/0x2c2
       [<c04a16fa>] notify_change+0x15e/0x29c
       [<c048f8be>] do_truncate+0x62/0x7b
       [<c048fbf6>] do_sys_truncate+0x19a/0x1d6
       [<c048fc43>] sys_truncate64+0x11/0x13
       [<c0402944>] sysenter_do_call+0x12/0x32
       [<ffffffff>] 0xffffffff

-> #0 (&sb->s_type->i_alloc_sem_key#6){+++++.}:
       [<c0447c87>] validate_chain+0x5a7/0xb1e
       [<c0448876>] __lock_acquire+0x678/0x710
       [<c0449a1f>] lock_acquire+0xa8/0xc5
       [<c06a6d1f>] down_read+0x1e/0x5b
       [<c04e307b>] ext4_page_mkwrite+0x34/0x174
       [<c047ba1b>] __do_fault+0x14c/0x393
       [<c047d680>] handle_mm_fault+0x36d/0x7a9
       [<c06a9f6f>] do_page_fault+0x28d/0x2f1
       [<c06a838a>] error_code+0x72/0x78
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by fsx-linux/11055:
 #0:  (&mm->mmap_sem){++++++}, at: [<c06a9eae>] do_page_fault+0x1cc/0x2f1

stack backtrace:
Pid: 11055, comm: fsx-linux Not tainted 2.6.30-rc5-autokern1 #1
Call Trace:
 [<c04475f2>] print_circular_bug_tail+0xa4/0xaf
 [<c0447c87>] validate_chain+0x5a7/0xb1e
 [<c0447164>] ? check_usage_backwards+0x5d/0x7f
 [<c0448876>] __lock_acquire+0x678/0x710
 [<c046c2a2>] ? find_get_page+0x94/0xd9
 [<c0449a1f>] lock_acquire+0xa8/0xc5
 [<c04e307b>] ? ext4_page_mkwrite+0x34/0x174
 [<c06a6d1f>] down_read+0x1e/0x5b
 [<c04e307b>] ? ext4_page_mkwrite+0x34/0x174
 [<c04e307b>] ext4_page_mkwrite+0x34/0x174
 [<c047ba1b>] __do_fault+0x14c/0x393
 [<c047d680>] handle_mm_fault+0x36d/0x7a9
 [<c06a9eae>] ? do_page_fault+0x1cc/0x2f1
 [<c043e864>] ? down_read_trylock+0x39/0x43
 [<c06a9f6f>] do_page_fault+0x28d/0x2f1
 [<c06a9ce2>] ? do_page_fault+0x0/0x2f1
 [<c06a838a>] error_code+0x72/0x78
 [<c06a9ce2>] ? do_page_fault+0x0/0x2f1
fsx-linux used greatest stack depth: 1448 bytes left
