From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/9] ext4: serialize dio nonlocked reads with defrag workers V3
Date: Thu, 13 Sep 2012 19:01:08 +0400
Message-ID: <1347548474-31897-4-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45957 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2IMPBY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 11:01:24 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so2024074lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:23 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's block defrag and ext4_change_inode_journal_flag() may
affect nonlocked DIO reads result, so proper synchronization
required.

- Add missed inode_dio_wait() calls where appropriate
- Check inode state under extra i_dio_count reference.


Changes from V1:
- add missed memory bariers
- move DIOREAD_LOCK state check out from generic should_dioread_nolock
  otherwise it will affect existing DIO readers.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h        |   17 +++++++++++++++++
 fs/ext4/indirect.c    |   13 +++++++++++++
 fs/ext4/inode.c       |    5 +++++
 fs/ext4/move_extent.c |    8 ++++++++
 4 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index be976ca..a71e299 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1348,6 +1348,8 @@ enum {
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
 	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
+	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
+					   nolocking */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
@@ -2456,6 +2458,21 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+/*
+ * Disable DIO read nolock optimization, so new dioreaders will be forced
+ * to grab i_mutex
+ */
+static inline void ext4_inode_block_unlocked_dio(struct inode *inode)
+{
+	ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
+	smp_mb();
+}
+static inline void ext4_inode_resume_unlocked_dio(struct inode *inode)
+{
+	smp_mb();
+	ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
+}
+
 #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
 
 /* For ioend & aio unwritten conversion wait queues */
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 61f13e5..e4cc904 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -810,10 +810,23 @@ retry:
 		if (unlikely(!list_empty(&ei->i_completed_io_list)))
 			ext4_flush_completed_IO(inode);
 
+		/*
+		 * Nolock dioread optimization may be dynamically disabled
+		 * via ext4_inode_block_unlocked_dio(). Check inode's state
+		 * while holding extra i_dio_count ref.
+		 */
+		atomic_inc(&inode->i_dio_count);
+		smp_mb();
+		if (!unlikely(ext4_test_inode_state(inode,
+						    EXT4_STATE_DIOREAD_LOCK))) {
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
index 762b955..c34d38c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4720,6 +4720,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 			return err;
 	}
 
+	/* Wait for all existing dio workers */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -4739,6 +4743,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
+	ext4_inode_resume_unlocked_dio(inode);
 
 	/* Finally we can mark the inode as dirty. */
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..ae0357b 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1214,6 +1214,12 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 	if (ret1 < 0)
 		return ret1;
 
+	/* Wait for all existing dio workers */
+	ext4_inode_block_unlocked_dio(orig_inode);
+	ext4_inode_block_unlocked_dio(donor_inode);
+	inode_dio_wait(orig_inode);
+	inode_dio_wait(donor_inode);
+
 	/* Protect extent tree against block allocations via delalloc */
 	double_down_write_data_sem(orig_inode, donor_inode);
 	/* Check the filesystem environment whether move_extent can be done */
@@ -1412,6 +1418,8 @@ out:
 		kfree(holecheck_path);
 	}
 	double_up_write_data_sem(orig_inode, donor_inode);
+	ext4_inode_block_unlocked_dio(orig_inode);
+	ext4_inode_block_unlocked_dio(donor_inode);
 	ret2 = mext_inode_double_unlock(orig_inode, donor_inode);
 
 	if (ret1)
-- 
1.7.7.6

