From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Tue, 5 Feb 2008 17:53:42 +0530
Message-ID: <20080205122342.GC7038@skywalker>
References: <20080204101228.GA1939@skywalker> <20080204163156.GC3426@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60752 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYBEMXw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 07:23:52 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m15CNnN7014674
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 17:53:49 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m15CNmxd1057012
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 17:53:48 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m15CNlCJ018194
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 12:23:48 GMT
Content-Disposition: inline
In-Reply-To: <20080204163156.GC3426@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 04, 2008 at 05:31:56PM +0100, Jan Kara wrote:
>   Hi,
> 
> On Mon 04-02-08 15:42:28, Aneesh Kumar K.V wrote:
> > This is with the new ext3 -> ext4 migrate code added. The recently added
> > lockdep for jbd2 helped to find this out. We want to hold the i_data_sem
> > on the ext3 inode during migration to prevent walking the ext3 inode
> > when it is being converted to ext4 format. Also we want to avoid 
> > file truncation and new blocks being added while converting to ext4.
> > Also we dont want to reserve large number of credits for journal.
> > Any idea how to fix this ?
>   Hmm, while briefly looking at the code - why do you introduce i_data_sem
> and not use i_alloc_sem which is already in VFS inode? That is aimed
> exactly at the serialization of truncates, writes and similar users.
> That doesn't solve problems with lock ordering but I was just wondering...
>   Another problem - ext4_fallocate() has the same lock ordering problem as
> the migration code and maybe there are others...
>   One (stupid) solution to your problem is to make i_data_sem be
> always locked before the transaction is started. It could possibly have
> negative performance impact because you'd have to hold the semaphore for
> a longer time and thus a writer would block readers for longer time. So one
> would have to measure how big difference that would make.
>   Another possibility is to start a single transaction for migration and
> extend it as long as you can (as truncate does it). And when you can't
> extend any more, you drop the i_data_sem and start a new transaction and
> acquire the semaphore again. This has the disadvantage that after dropping
> the semaphore you have to resync your original inode with the temporary
> one your are building which probably ends up being ugly as night... Hmm,
> but maybe we could get rid of this - hold i_mutex to protect against all
> writes (that ranks outside of transaction start so you can hold it for the
> whole migration time - maybe you even hold it if you are called from the
> write path...). After dropping i_data_sem you let some readers proceed
> but writers still wait on i_mutex so the file shouldn't change under you
> (but I suggest adding some BUG_ONs to verify that the file really doesn't
> change :).
> 

How about the patch below. I did the below testing
a) migrate a file
b) run fs_inode fsstres fsx_linux.

The intention was to find out whether the new locking is breaking any of
the other expected hierarchy. It seems to fine. I didn't get any lockdep
warning.

ext4: Fix circular locking dependency with migrate and rm.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We now take inode->i_mutex lock to prevent any update of the inode i_data
field. Before we switch the inode format we take i_data_sem to prevent
parallel read.

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

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/migrate.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)


diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 9ee1f7c..f97c993 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -317,6 +317,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 			goto err_out;
 	}
 
+	down_write(&EXT4_I(inode)->i_data_sem);
 	/*
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
@@ -336,6 +337,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	spin_lock(&inode->i_lock);
 	inode->i_blocks += tmp_inode->i_blocks;
 	spin_unlock(&inode->i_lock);
+	up_write(&EXT4_I(inode)->i_data_sem);
 
 	ext4_mark_inode_dirty(handle, inode);
 err_out:
@@ -420,7 +422,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 		 */
 		return retval;
 
-	down_write(&EXT4_I(inode)->i_data_sem);
 	handle = ext4_journal_start(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
@@ -454,13 +455,6 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	ext4_orphan_add(handle, tmp_inode);
 	ext4_journal_stop(handle);
 
-	ei = EXT4_I(inode);
-	i_data = ei->i_data;
-	memset(&lb, 0, sizeof(lb));
-
-	/* 32 bit block address 4 bytes */
-	max_entries = inode->i_sb->s_blocksize >> 2;
-
 	/*
 	 * start with one credit accounted for
 	 * superblock modification.
@@ -469,7 +463,20 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
 	 * trascation that created the inode. Later as and
 	 * when we add extents we extent the journal
 	 */
+	/*
+	 * inode_mutex prevent write and truncate on the file. Read still goes
+	 * through. We take i_data_sem in ext4_ext_swap_inode_data before we
+	 * switch the inode format to prevent read.
+	 */
+	mutex_lock(&(inode->i_mutex));
 	handle = ext4_journal_start(inode, 1);
+
+	ei = EXT4_I(inode);
+	i_data = ei->i_data;
+	memset(&lb, 0, sizeof(lb));
+
+	/* 32 bit block address 4 bytes */
+	max_entries = inode->i_sb->s_blocksize >> 2;
 	for (i = 0; i < EXT4_NDIR_BLOCKS; i++, blk_count++) {
 		if (i_data[i]) {
 			retval = update_extent_range(handle, tmp_inode,
@@ -556,8 +563,7 @@ err_out:
 	tmp_inode->i_nlink = 0;
 
 	ext4_journal_stop(handle);
-
-	up_write(&EXT4_I(inode)->i_data_sem);
+	mutex_unlock(&(inode->i_mutex));
 
 	if (tmp_inode)
 		iput(tmp_inode);
