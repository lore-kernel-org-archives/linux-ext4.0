From: "Theodore Ts'o" <tytso@mit.edu>
Subject: quota lockdep while running ext4 xfstests #219
Date: Sun, 10 Apr 2011 22:16:31 -0400
Message-ID: <E1Q96g3-0004W8-Vj@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47582 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1DKCQg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Apr 2011 22:16:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Jan,

FYI, I manage to trigger the following lockdep warning while running
v2.6.39-rc1 plus the ext4 patch queue.  None of the patches except for
your "ext4: remove unnecessary [cm]time update of quota file" patch
should affect the quota operations, and I don't think this patch should
have caused this, either.

I'm going to ignore this now, since it was triggered by repquota, and
I'm guessing it should occur rarely, but I thought I should let you know
in case I'm misjudging things.

Regards,

						- Ted


219 7s ...[ 3314.895274] EXT4-fs (vdc1): warning: maximal mount count reached, running e2fsck is recommended
[ 3315.676490] 
[ 3315.676493] =======================================================
[ 3315.679704] [ INFO: possible circular locking dependency detected ]
[ 3315.679704] 2.6.39-rc1-00009-g19e2b53 #1508
[ 3315.679704] -------------------------------------------------------
[ 3315.679704] repquota/10186 is trying to acquire lock:
[ 3315.679704]  (&mm->mmap_sem){++++++}, at: [<c01e3cce>] might_fault+0x4c/0x8a
[ 3315.679704] 
[ 3315.679704] but task is already holding lock:
[ 3315.679704]  (&type->s_umount_key#21){+++++.}, at: [<c01fd7b2>] get_super+0x55/0x98
[ 3315.679704] 
[ 3315.679704] which lock already depends on the new lock.
[ 3315.679704] 
[ 3315.679704] 
[ 3315.679704] the existing dependency chain (in reverse order) is:
[ 3315.679704] 
[ 3315.679704] -> #2 (&type->s_umount_key#21){+++++.}:
[ 3315.679704]        [<c0189957>] lock_acquire+0x99/0xbd
[ 3315.679704]        [<c0688727>] down_read+0x39/0x76
[ 3315.679704]        [<c0216db5>] writeback_inodes_sb_if_idle+0x26/0x3d
[ 3315.679704]        [<c026392b>] ext4_da_write_begin+0xfe/0x27d
[ 3315.679704]        [<c025e04c>] ext4_page_mkwrite+0x14b/0x198
[ 3315.679704]        [<c01e6220>] __do_fault+0xfd/0x346
[ 3315.679704]        [<c01e70a5>] handle_pte_fault+0x318/0x73c
[ 3315.679704]        [<c01e7589>] handle_mm_fault+0xc0/0xd2
[ 3315.679704]        [<c068c3c8>] do_page_fault+0x362/0x37e
[ 3315.679704]        [<c0689fab>] error_code+0x5f/0x64
[ 3315.679704] 
[ 3315.679704] -> #1 (&sb->s_type->i_alloc_sem_key#3){++++..}:
[ 3315.679704]        [<c0189957>] lock_acquire+0x99/0xbd
[ 3315.679704]        [<c0688727>] down_read+0x39/0x76
[ 3315.679704]        [<c025df32>] ext4_page_mkwrite+0x31/0x198
[ 3315.679704]        [<c01e6220>] __do_fault+0xfd/0x346
[ 3315.679704]        [<c01e70a5>] handle_pte_fault+0x318/0x73c
[ 3315.679704]        [<c01e7589>] handle_mm_fault+0xc0/0xd2
[ 3315.679704]        [<c068c3c8>] do_page_fault+0x362/0x37e
[ 3315.679704]        [<c0689fab>] error_code+0x5f/0x64
[ 3315.679704] 
[ 3315.679704] -> #0 (&mm->mmap_sem){++++++}:
[ 3315.679704]        [<c018964d>] __lock_acquire+0x926/0xb97
[ 3315.679704]        [<c0189957>] lock_acquire+0x99/0xbd
[ 3315.679704]        [<c01e3ced>] might_fault+0x6b/0x8a
[ 3315.679704]        [<c036e6f0>] copy_to_user+0x34/0x10c
[ 3315.679704]        [<c02365d1>] do_quotactl+0x247/0x39c
[ 3315.679704]        [<c0236830>] sys_quotactl+0x10a/0x136
[ 3315.679704]        [<c06898dd>] syscall_call+0x7/0xb
[ 3315.679704] 
[ 3315.679704] other info that might help us debug this:
[ 3315.679704] 
[ 3315.679704] 1 lock held by repquota/10186:
[ 3315.679704]  #0:  (&type->s_umount_key#21){+++++.}, at: [<c01fd7b2>] get_super+0x55/0x98
[ 3315.679704] 
[ 3315.679704] stack backtrace:
[ 3315.679704] Pid: 10186, comm: repquota Not tainted 2.6.39-rc1-00009-g19e2b53 #1508
[ 3315.679704] Call Trace:
[ 3315.679704]  [<c0188099>] print_circular_bug+0x90/0x9c
[ 3315.679704]  [<c018964d>] __lock_acquire+0x926/0xb97
[ 3315.679704]  [<c01876d3>] ? mark_lock+0x1e/0x1df
[ 3315.679704]  [<c0189957>] lock_acquire+0x99/0xbd
[ 3315.679704]  [<c01e3cce>] ? might_fault+0x4c/0x8a
[ 3315.679704]  [<c01e3ced>] might_fault+0x6b/0x8a
[ 3315.679704]  [<c01e3cce>] ? might_fault+0x4c/0x8a
[ 3315.679704]  [<c036e6f0>] copy_to_user+0x34/0x10c
[ 3315.679704]  [<c02365d1>] do_quotactl+0x247/0x39c
[ 3315.679704]  [<c01fd7b2>] ? get_super+0x55/0x98
[ 3315.679704]  [<c01fd7b2>] ? get_super+0x55/0x98
[ 3315.679704]  [<c0236830>] sys_quotactl+0x10a/0x136
[ 3315.679704]  [<c06898dd>] syscall_call+0x7/0xb
