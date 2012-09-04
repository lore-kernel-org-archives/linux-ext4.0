From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext4: serialize dio nonlocked reads with defrag workers
Date: Tue,  4 Sep 2012 21:22:48 +0400
Message-ID: <1346779371-28203-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52139 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2IDRW5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 13:22:57 -0400
Received: by lbbgj3 with SMTP id gj3so3268369lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 10:22:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's block defrag and ext4_change_inode_journal_flag() may
affect nonlocked DIO reads result, so proper synchronization
required.

- add missed inode_dio_wait() calls where appropriate
- recheck ext4_should_dioread_nolock under extra i_dio_count reference.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h        |    2 ++
 fs/ext4/ext4_jbd2.h   |    2 ++
 fs/ext4/indirect.c    |   12 ++++++++++++
 fs/ext4/inode.c       |    5 +++++
 fs/ext4/move_extent.c |   10 ++++++++++
 5 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f9024a6..36e8b84 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1349,6 +1349,8 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
+	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
+					   nolocking */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 56d258c..318d177 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -399,6 +399,8 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 		return 0;
 	if (ext4_should_journal_data(inode))
 		return 0;
+	if (ext4_test_inode_state(inode, EXT4_STATE_DIOREAD_LOCK))
+		return 0;
 	return 1;
 }
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..ba40309 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -812,10 +812,22 @@ retry:
 			ext4_flush_completed_IO(inode);
 			mutex_unlock(&inode->i_mutex);
 		}
+		/*
+		 * Inode's locking behaviour may change due to number
+		 * of reasons, in order to be shure that nolock dioreads
+		 * is still allowed we have to recheck inode's flags
+		 * while i_dio_count > 0
+		 */
+		atomic_inc(&inode->i_dio_count);
+		if (!unlikely(ext4_should_dioread_nolock(inode))) {
+			inode_dio_done(inode);
+			goto retry;
+		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
+		inode_dio_done(inode);
 	} else {
 		ret = blockdev_direct_IO(rw, iocb, inode, iov,
 				 offset, nr_segs, ext4_get_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d12d30e..58ef61a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4741,6 +4741,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 			return err;
 	}
 
+	/* Wait for all existing dio workers */
+	ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
+	inode_dio_wait(inode);
+
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -4760,6 +4764,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
+	ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
 
 	/* Finally we can mark the inode as dirty. */
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..a6a4278 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1213,6 +1213,14 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
 	if (ret1 < 0)
 		return ret1;
+	/* Protect inodes against DIO workers
+	 * - Disable dio nonlock reads, so all new dio workers will block
+	 *   on i_mutex.
+	 * - wait for existing DIO in flight */
+	ext4_set_inode_state(orig_inode, EXT4_STATE_DIOREAD_LOCK);
+	ext4_set_inode_state(donor_inode, EXT4_STATE_DIOREAD_LOCK);
+	inode_dio_wait(orig_inode);
+	inode_dio_wait(donor_inode);
 
 	/* Protect extent tree against block allocations via delalloc */
 	double_down_write_data_sem(orig_inode, donor_inode);
@@ -1412,6 +1420,8 @@ out:
 		kfree(holecheck_path);
 	}
 	double_up_write_data_sem(orig_inode, donor_inode);
+	ext4_clear_inode_state(orig_inode, EXT4_STATE_DIOREAD_LOCK);
+	ext4_clear_inode_state(donor_inode, EXT4_STATE_DIOREAD_LOCK);
 	ret2 = mext_inode_double_unlock(orig_inode, donor_inode);
 
 	if (ret1)
-- 
1.7.7.6

