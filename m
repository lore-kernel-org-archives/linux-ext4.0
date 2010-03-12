From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext3, jbd: Add barriers for file systems with exernal journals
Date: Fri, 12 Mar 2010 20:26:50 +0300
Message-ID: <1268414810-17289-2-git-send-email-dmonakhov@openvz.org>
References: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37241 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab0CLR07 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Mar 2010 12:26:59 -0500
Received: by bwz1 with SMTP id 1so1247715bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 12 Mar 2010 09:26:57 -0800 (PST)
In-Reply-To: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a bit complicated because we are trying to optimize when we
send barriers to the fs data disk.  We could just throw in an extra
barrier to the data disk whenever we send a barrier to the journal
disk, but that's not always strictly necessary.

Send barrier only if transaction has data or metadata.
The patch is mostly backported from ext4.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/fsync.c     |   39 ++++++++++++++++++++++++---------------
 fs/jbd/commit.c     |   16 ++++++++++++++++
 include/linux/jbd.h |    1 +
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 8209f26..983a3bc 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -70,10 +70,8 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	 *  (they were dirtied by commit).  But that's OK - the blocks are
 	 *  safe in-journal, which is all fsync() needs to ensure.
 	 */
-	if (ext3_should_journal_data(inode)) {
-		ret = ext3_force_commit(inode->i_sb);
-		goto out;
-	}
+	if (ext3_should_journal_data(inode))
+		return  ext3_force_commit(inode->i_sb);
 
 	if (datasync)
 		commit_tid = atomic_read(&ei->i_datasync_tid);
@@ -81,17 +79,28 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 		commit_tid = atomic_read(&ei->i_sync_tid);
 
 	if (log_start_commit(journal, commit_tid)) {
-		log_wait_commit(journal, commit_tid);
-		goto out;
-	}
+		/*
+		 * When the journal is on a different device than the
+		 * fs data disk, we need to issue the barrier in
+		 * writeback mode.  (In ordered mode, the jbd layer
+		 * will take care of issuing the barrier.  In
+		 * data=journal, all of the data blocks are written to
+		 * the journal device.)
+		 */
+		if (ext3_should_writeback_data(inode) &&
+		    (journal->j_fs_dev != journal->j_dev) &&
+		    (journal->j_flags & JFS_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 
-	/*
-	 * In case we didn't commit a transaction, we have to flush
-	 * disk caches manually so that data really is on persistent
-	 * storage
-	 */
-	if (test_opt(inode->i_sb, BARRIER))
-		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-out:
+		ret = log_wait_commit(journal, commit_tid);
+	} else {
+		/*
+		 * In case we didn't commit a transaction, we have to flush
+		 * disk caches manually so that data really is on persistent
+		 * storage
+		 */
+		if (test_opt(inode->i_sb, BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+	}
 	return ret;
 }
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 2c90e3e..027e02b 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include <linux/blkdev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -194,6 +195,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 	struct journal_head *jh;
 	struct buffer_head *bh;
 	int locked;
+	int sync_data = 0;
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
 	int err = 0;
@@ -211,6 +213,7 @@ write_out_data:
 	spin_lock(&journal->j_list_lock);
 
 	while (commit_transaction->t_sync_datalist) {
+		sync_data = 1;
 		jh = commit_transaction->t_sync_datalist;
 		bh = jh2bh(jh);
 		locked = 0;
@@ -288,6 +291,7 @@ write_out_data:
 			goto write_out_data;
 		}
 	}
+	commit_transaction->t_flushed_data_blocks |= sync_data;
 	spin_unlock(&journal->j_list_lock);
 	journal_do_submit_data(wbuf, bufs, write_op);
 
@@ -668,6 +672,8 @@ void journal_commit_transaction(journal_t *journal)
 			tag->t_flags |= cpu_to_be32(JFS_FLAG_LAST_TAG);
 
 start_journal_io:
+			if (bufs)
+				commit_transaction->t_flushed_data_blocks = 1;
 			for (i = 0; i < bufs; i++) {
 				struct buffer_head *bh = wbuf[i];
 				lock_buffer(bh);
@@ -685,6 +691,16 @@ start_journal_io:
 		}
 	}
 
+	/*
+	 * If the journal is not located on the file system device,
+	 * then we must flush the file system device before we issue
+	 * the commit record
+	 */
+	if (commit_transaction->t_flushed_data_blocks &&
+	    (journal->j_fs_dev != journal->j_dev) &&
+	    (journal->j_flags & JFS_BARRIER))
+		blkdev_issue_flush(journal->j_fs_dev, NULL);
+
 	/* Lo and behold: we have just managed to send a transaction to
            the log.  Before we can commit it, wait for the IO so far to
            complete.  Control buffers being written are on the
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index f3aa59c..3ea2807 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -546,6 +546,7 @@ struct transaction_s
 	 * waiting for it to finish.
 	 */
 	unsigned int t_synchronous_commit:1;
+	unsigned int t_flushed_data_blocks:1;
 };
 
 /**
-- 
1.6.6

