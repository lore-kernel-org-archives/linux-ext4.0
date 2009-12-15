From: tytso@mit.edu
Subject: Re: [PATCH] Possible data loss on ext[34], reiserfs with external
 journal
Date: Tue, 15 Dec 2009 00:32:07 -0500
Message-ID: <20091215053207.GA26541@thunk.org>
References: <20091211081608.GA597088@fiona.linuxhacker.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext3@vger.kernel.org,
	linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
To: Oleg Drokin <green@linuxhacker.ru>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091211081608.GA597088@fiona.linuxhacker.ru>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 11, 2009 at 11:16:08AM +0300, Oleg Drokin wrote:
> Hello!
> 
>    It seems when external journal device is used for ext3, ext4 and reiserfs
>    (possibly others, but I can only readily confirm these three) and
>    main filesystem device had writeback cache enabled, a very real
>    data loss is possible because we never flush main device cache on commit.
>    As a result if we just wrote some files in ordered mode and then
>    transaction was committed, the journal data makes it to the disk
>    (provided that barriers are in use), but the actual file data only made
>    it to the device cache. As such sudden loss of power at this stage
>    would lead to files in place, but their content replaced with
>    whatever happened to be in those blocks before.
> 
>    This simple patch at the end should remedy the problem.

Can you separate this patch into separate ones for each file system?
I think we can actually do better for ext4; for example, in the case
of data=journal or data=writeback, it's not necessary to flush the fs
data device.  It's only the case of data=ordered that we need to send
a barrier.  With that optimization, we do need to add a barrier in the
case of fsync() and when we are doing a journal checkpoint, but the
extra code complexity is worth not having to force a barrier for the
fs data device for every single commit, especially in the data=journal
mode with a heavy fsync workload.

Do you have a test case that will allow you to easily try out this
patch, in all of ext4's various journalling modes?  Thanks!!

       	      	 			    - Ted

commit 4ba96b277f26952097d15736f6e960bc84cf4c0c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Dec 15 00:31:12 2009 -0500

    ext4, jbd2: Add barriers for file systems with exernal journals
    
    This is a bit complicated because we are trying to optimize when we
    send barriers to the fs data disk.  We could just throw in an extra
    barrier to the data disk whenever we send a barrier to the journal
    disk, but that's not always strictly necessary.
    
    We only need to send a barrier during a commit when there are data
    blocks which are must be written out due to an inode written in
    ordered mode, or if fsync() depends on the commit to force data blocks
    to disk.  Finally, before we drop transactions from the beginning of
    the journal during a checkpoint operation, we need to guarantee that
    any blocks that were flushed out to the data disk are firmly on the
    rust platter before we drop the transaction from the journal.
    
    Thanks to Oleg Drokin for pointing out this flaw in ext3/ext4.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0b22497..98bd140 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -88,9 +88,21 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		return ext4_force_commit(inode->i_sb);
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
-	if (jbd2_log_start_commit(journal, commit_tid))
+	if (jbd2_log_start_commit(journal, commit_tid)) {
+		/*
+		 * When the journal is on a different device than the
+		 * fs data disk, we need to issue the barrier in
+		 * writeback mode.  (In ordered mode, the jbd2 layer
+		 * will take care of issuing the barrier.  In
+		 * data=journal, all of the data blocks are written to
+		 * the journal device.)
+		 */
+		if (ext4_should_writeback_data(inode) &&
+		    (journal->j_fs_dev != journal->j_dev) &&
+		    (journal->j_flags & JBD2_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 		jbd2_log_wait_commit(journal, commit_tid);
-	else if (journal->j_flags & JBD2_BARRIER)
+	} else if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
 }
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index ca0f5eb..8868493 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -22,6 +22,7 @@
 #include <linux/jbd2.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>
 #include <trace/events/jbd2.h>
 
 /*
@@ -515,6 +516,20 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	journal->j_tail_sequence = first_tid;
 	journal->j_tail = blocknr;
 	spin_unlock(&journal->j_state_lock);
+
+	/*
+	 * If there is an external journal, we need to make sure that
+	 * any data blocks that were recently written out --- perhaps
+	 * by jbd2_log_do_checkpoint() --- are flushed out before we
+	 * drop the transactions from the external journal.  It's
+	 * unlikely this will be necessary, especially with a
+	 * appropriately sized journal, but we need this to guarantee
+	 * correctness.  Fortunately jbd2_cleanup_journal_tail()
+	 * doesn't get called all that often.
+	 */
+	if ((journal->j_fs_dev != journal->j_dev) &&
+	    (journal->j_flags & JBD2_BARRIER))
+		blkdev_issue_flush(journal->j_fs_dev, NULL);
 	if (!(journal->j_flags & JBD2_ABORT))
 		jbd2_journal_update_superblock(journal, 1);
 	return 0;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6a10238..5b78f9a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -259,6 +259,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 			ret = err;
 		spin_lock(&journal->j_list_lock);
 		J_ASSERT(jinode->i_transaction == commit_transaction);
+		commit_transaction->t_flushed_data_blocks = 1;
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
@@ -277,6 +278,16 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	struct jbd2_inode *jinode, *next_i;
 	int err, ret = 0;
 
+	/* 
+	 * If the journal is not located on the file system device,
+	 * then we must flush the file system device before we issue
+	 * the commit record
+	 */
+	if (commit_transaction->t_flushed_data_blocks &&
+	    (journal->j_fs_dev != journal->j_dev) &&
+	    (journal->j_flags & JBD2_BARRIER))
+		blkdev_issue_flush(journal->j_fs_dev, NULL);
+
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f1011f7..638ce45 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -653,6 +653,7 @@ struct transaction_s
 	 * waiting for it to finish.
 	 */
 	unsigned int t_synchronous_commit:1;
+	unsigned int t_flushed_data_blocks:1;
 
 	/*
 	 * For use by the filesystem to store fs-specific data
