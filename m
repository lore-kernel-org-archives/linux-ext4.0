From: Jan Kara <jack@suse.cz>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Mon, 4 Feb 2008 17:31:56 +0100
Message-ID: <20080204163156.GC3426@duck.suse.cz>
References: <20080204101228.GA1939@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36232 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750847AbYBDQb6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Feb 2008 11:31:58 -0500
Content-Disposition: inline
In-Reply-To: <20080204101228.GA1939@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon 04-02-08 15:42:28, Aneesh Kumar K.V wrote:
> This is with the new ext3 -> ext4 migrate code added. The recently added
> lockdep for jbd2 helped to find this out. We want to hold the i_data_sem
> on the ext3 inode during migration to prevent walking the ext3 inode
> when it is being converted to ext4 format. Also we want to avoid 
> file truncation and new blocks being added while converting to ext4.
> Also we dont want to reserve large number of credits for journal.
> Any idea how to fix this ?
  Hmm, while briefly looking at the code - why do you introduce i_data_sem
and not use i_alloc_sem which is already in VFS inode? That is aimed
exactly at the serialization of truncates, writes and similar users.
That doesn't solve problems with lock ordering but I was just wondering...
  Another problem - ext4_fallocate() has the same lock ordering problem as
the migration code and maybe there are others...
  One (stupid) solution to your problem is to make i_data_sem be
always locked before the transaction is started. It could possibly have
negative performance impact because you'd have to hold the semaphore for
a longer time and thus a writer would block readers for longer time. So one
would have to measure how big difference that would make.
  Another possibility is to start a single transaction for migration and
extend it as long as you can (as truncate does it). And when you can't
extend any more, you drop the i_data_sem and start a new transaction and
acquire the semaphore again. This has the disadvantage that after dropping
the semaphore you have to resync your original inode with the temporary
one your are building which probably ends up being ugly as night... Hmm,
but maybe we could get rid of this - hold i_mutex to protect against all
writes (that ranks outside of transaction start so you can hold it for the
whole migration time - maybe you even hold it if you are called from the
write path...). After dropping i_data_sem you let some readers proceed
but writers still wait on i_mutex so the file shouldn't change under you
(but I suggest adding some BUG_ONs to verify that the file really doesn't
change :).

									Honza

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.24-rc8 #6
> -------------------------------------------------------
> rm/2401 is trying to acquire lock:
>  (&ei->i_data_sem){----}, at: [<c01dca58>] ext4_get_blocks_wrap+0x21/0x108
> 
> but task is already holding lock:
>  (jbd2_handle){--..}, at: [<c01fc4a7>] jbd2_journal_start+0xd2/0xff
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (jbd2_handle){--..}:
>        [<c0143a5c>] __lock_acquire+0xa31/0xc1a
>        [<c0143cbf>] lock_acquire+0x7a/0x94
>        [<c01fc4ca>] jbd2_journal_start+0xf5/0xff
>        [<c01e3539>] ext4_journal_start_sb+0x48/0x4a
>        [<c01eb980>] ext4_ext_migrate+0x7d/0x535
>        [<c01df328>] ext4_ioctl+0x528/0x56c
>        [<c0177700>] do_ioctl+0x50/0x67
>        [<c017794e>] vfs_ioctl+0x237/0x24a
>        [<c0177992>] sys_ioctl+0x31/0x4b
>        [<c0104f8a>] sysenter_past_esp+0x5f/0xa5
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&ei->i_data_sem){----}:
>        [<c014394c>] __lock_acquire+0x921/0xc1a
>        [<c0143cbf>] lock_acquire+0x7a/0x94
>        [<c044f247>] down_read+0x42/0x79
>        [<c01dca58>] ext4_get_blocks_wrap+0x21/0x108
>        [<c01dcba1>] ext4_getblk+0x62/0x1c4
>        [<c01e0de9>] ext4_find_entry+0x350/0x5b7
>        [<c01e200c>] ext4_unlink+0x6e/0x1a4
>        [<c017449e>] vfs_unlink+0x49/0x89
>        [<c0175f02>] do_unlinkat+0x96/0x12c
>        [<c0175fa8>] sys_unlink+0x10/0x12
>        [<c0104f8a>] sysenter_past_esp+0x5f/0xa5
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 3 locks held by rm/2401:
>  #0:  (&type->i_mutex_dir_key#5/1){--..}, at: [<c0175eca>] do_unlinkat+0x5e/0x12c
>  #1:  (&sb->s_type->i_mutex_key#8){--..}, at: [<c017448b>] vfs_unlink+0x36/0x89
>  #2:  (jbd2_handle){--..}, at: [<c01fc4a7>] jbd2_journal_start+0xd2/0xff
> 
> stack backtrace:
> Pid: 2401, comm: rm Not tainted 2.6.24-rc8 #6
>  [<c0106017>] show_trace_log_lvl+0x1a/0x2f
>  [<c0106893>] show_trace+0x12/0x14
>  [<c0106b89>] dump_stack+0x6c/0x72
>  [<c0141b26>] print_circular_bug_tail+0x5f/0x68
>  [<c014394c>] __lock_acquire+0x921/0xc1a
>  [<c0143cbf>] lock_acquire+0x7a/0x94
>  [<c044f247>] down_read+0x42/0x79
>  [<c01dca58>] ext4_get_blocks_wrap+0x21/0x108
>  [<c01dcba1>] ext4_getblk+0x62/0x1c4
>  [<c01e0de9>] ext4_find_entry+0x350/0x5b7
>  [<c01e200c>] ext4_unlink+0x6e/0x1a4
>  [<c017449e>] vfs_unlink+0x49/0x89
>  [<c0175f02>] do_unlinkat+0x96/0x12c
>  [<c0175fa8>] sys_unlink+0x10/0x12
>  [<c0104f8a>] sysenter_past_esp+0x5f/0xa5
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
