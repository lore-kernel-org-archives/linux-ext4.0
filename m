From: tytso@mit.edu
Subject: Re: [PATCH] Possible data loss on ext[34], reiserfs with external
 journal
Date: Wed, 23 Dec 2009 07:10:27 -0500
Message-ID: <20091223121027.GB21594@thunk.org>
References: <20091211081608.GA597088@fiona.linuxhacker.ru>
 <20091215053207.GA26541@thunk.org>
 <2EEF5D3D-AFA5-4D74-92A7-B42A0FB9A4F5@linuxhacker.ru>
 <20091215164503.GI4867@thunk.org>
 <02CF0C94-BEC0-428A-878D-D61ADA302944@linuxhacker.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Oleg Drokin <green@linuxhacker.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33573 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbZLWMKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 07:10:31 -0500
Content-Disposition: inline
In-Reply-To: <02CF0C94-BEC0-428A-878D-D61ADA302944@linuxhacker.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After taking a look at things, you're right.  We need to flush the
data disk before the first call to journal_submit_commit_record() to
eliminate the race condition in the ASYNC_COMMIT case.

	      	   	     	    		 - Ted

commit 82dd90c0e74797d1cea2ebfb9370ba2d6a3e12bf
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Dec 23 06:52:08 2009 -0500

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
index 6a10238..1bc74b6 100644
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
@@ -708,8 +709,17 @@ start_journal_io:
 		}
 	}
 
-	/* Done it all: now write the commit record asynchronously. */
+	/* 
+	 * If the journal is not located on the file system device,
+	 * then we must flush the file system device before we issue
+	 * the commit record
+	 */
+	if (commit_transaction->t_flushed_data_blocks &&
+	    (journal->j_fs_dev != journal->j_dev) &&
+	    (journal->j_flags & JBD2_BARRIER))
+		blkdev_issue_flush(journal->j_fs_dev, NULL);
 
+	/* Done it all: now write the commit record asynchronously. */
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
 		err = journal_submit_commit_record(journal, commit_transaction,
@@ -720,13 +730,6 @@ start_journal_io:
 			blkdev_issue_flush(journal->j_dev, NULL);
 	}
 
-	/*
-	 * This is the right place to wait for data buffers both for ASYNC
-	 * and !ASYNC commit. If commit is ASYNC, we need to wait only after
-	 * the commit block went to disk (which happens above). If commit is
-	 * SYNC, we need to wait for data buffers before we start writing
-	 * commit block, which happens below in such setting.
-	 */
 	err = journal_finish_inode_data_buffers(journal, commit_transaction);
 	if (err) {
 		printk(KERN_WARNING
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
