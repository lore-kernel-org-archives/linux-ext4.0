From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: jbd2_handle and i_data_sem circular locking dependency detected
Date: Mon, 4 Feb 2008 15:42:28 +0530
Message-ID: <20080204101228.GA1939@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:49517 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYBDKMj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 05:12:39 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m14ACIF3024975
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 21:12:18 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14ACbGG3449028
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 21:12:37 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14ACaqO002438
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 21:12:37 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This is with the new ext3 -> ext4 migrate code added. The recently added
lockdep for jbd2 helped to find this out. We want to hold the i_data_sem
on the ext3 inode during migration to prevent walking the ext3 inode
when it is being converted to ext4 format. Also we want to avoid 
file truncation and new blocks being added while converting to ext4.
Also we dont want to reserve large number of credits for journal.
Any idea how to fix this ?


-aneesh

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc8 #6
-------------------------------------------------------
rm/2401 is trying to acquire lock:
 (&ei->i_data_sem){----}, at: [<c01dca58>] ext4_get_blocks_wrap+0x21/0x108

but task is already holding lock:
 (jbd2_handle){--..}, at: [<c01fc4a7>] jbd2_journal_start+0xd2/0xff

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (jbd2_handle){--..}:
       [<c0143a5c>] __lock_acquire+0xa31/0xc1a
       [<c0143cbf>] lock_acquire+0x7a/0x94
       [<c01fc4ca>] jbd2_journal_start+0xf5/0xff
       [<c01e3539>] ext4_journal_start_sb+0x48/0x4a
       [<c01eb980>] ext4_ext_migrate+0x7d/0x535
       [<c01df328>] ext4_ioctl+0x528/0x56c
       [<c0177700>] do_ioctl+0x50/0x67
       [<c017794e>] vfs_ioctl+0x237/0x24a
       [<c0177992>] sys_ioctl+0x31/0x4b
       [<c0104f8a>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

-> #0 (&ei->i_data_sem){----}:
       [<c014394c>] __lock_acquire+0x921/0xc1a
       [<c0143cbf>] lock_acquire+0x7a/0x94
       [<c044f247>] down_read+0x42/0x79
       [<c01dca58>] ext4_get_blocks_wrap+0x21/0x108
       [<c01dcba1>] ext4_getblk+0x62/0x1c4
       [<c01e0de9>] ext4_find_entry+0x350/0x5b7
       [<c01e200c>] ext4_unlink+0x6e/0x1a4
       [<c017449e>] vfs_unlink+0x49/0x89
       [<c0175f02>] do_unlinkat+0x96/0x12c
       [<c0175fa8>] sys_unlink+0x10/0x12
       [<c0104f8a>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by rm/2401:
 #0:  (&type->i_mutex_dir_key#5/1){--..}, at: [<c0175eca>] do_unlinkat+0x5e/0x12c
 #1:  (&sb->s_type->i_mutex_key#8){--..}, at: [<c017448b>] vfs_unlink+0x36/0x89
 #2:  (jbd2_handle){--..}, at: [<c01fc4a7>] jbd2_journal_start+0xd2/0xff

stack backtrace:
Pid: 2401, comm: rm Not tainted 2.6.24-rc8 #6
 [<c0106017>] show_trace_log_lvl+0x1a/0x2f
 [<c0106893>] show_trace+0x12/0x14
 [<c0106b89>] dump_stack+0x6c/0x72
 [<c0141b26>] print_circular_bug_tail+0x5f/0x68
 [<c014394c>] __lock_acquire+0x921/0xc1a
 [<c0143cbf>] lock_acquire+0x7a/0x94
 [<c044f247>] down_read+0x42/0x79
 [<c01dca58>] ext4_get_blocks_wrap+0x21/0x108
 [<c01dcba1>] ext4_getblk+0x62/0x1c4
 [<c01e0de9>] ext4_find_entry+0x350/0x5b7
 [<c01e200c>] ext4_unlink+0x6e/0x1a4
 [<c017449e>] vfs_unlink+0x49/0x89
 [<c0175f02>] do_unlinkat+0x96/0x12c
 [<c0175fa8>] sys_unlink+0x10/0x12
 [<c0104f8a>] sysenter_past_esp+0x5f/0xa5
 
