From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Wed, 21 Sep 2016 01:27:44 -0400
Message-ID: <20160921052744.5223-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44704 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752320AbcIUF2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Sep 2016 01:28:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Even if we are not using dioread_nolock, if the blocks to be read are
allocated and initialized, and we know we have not done any block
allocation "recently", it safe to issue the direct I/O read without
doing any locking.

For now we use a very simple definition of "recently".  If we have
done any block allocations at all, we set the HAS_ALLOCATED state
flag.  This flag is only cleared after an fsync() call.

We could also clear the HAS_ALLOCATED flag after all of the dirty
pages for the inode have been written to disk, but tracking that is a
bit trickier, so we don't do that for now.  In pretty much all of the
use cases where we would care about DIO scalability, the applications
tend to be issuing fsync(2) calls very frequently in any case.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h  |  4 ++++
 fs/ext4/fsync.c | 23 +++++++++++++++++++++++
 fs/ext4/inode.c | 55 +++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 282a51b..3bb3734 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1566,6 +1566,10 @@ enum {
 					   nolocking */
 	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
 	EXT4_STATE_EXT_PRECACHED,	/* extents have been precached */
+	EXT4_STATE_HAS_ALLOCATED,	/* there may be some unwritten,
+					   allocated blocks */
+	EXT4_STATE_IS_SYNCING,		/* potentially allocated blocks
+					   are being synced  */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 88effb1..cb8565f 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -96,6 +96,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	unsigned long old_state;
 	int ret = 0, err;
 	tid_t commit_tid;
 	bool needs_barrier = false;
@@ -112,6 +113,8 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
+	if (ext4_test_inode_state(inode, EXT4_STATE_HAS_ALLOCATED))
+		ext4_set_inode_state(inode, EXT4_STATE_IS_SYNCING);
 	if (!journal) {
 		ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret)
@@ -155,6 +158,26 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			ret = err;
 	}
 out:
+#if (BITS_PER_LONG < 64)
+	old_state = READ_ONCE(ei->i_state_flags);
+	if (old_state & (1 << EXT4_STATE_IS_SYNCING)) {
+		unsigned long new_state;
+
+		new_state = old_state & ~((1 << EXT4_STATE_IS_SYNCING) |
+					  (1 << EXT4_STATE_HAS_ALLOCATED));
+		cmpxchg(&ei->i_state_flags, old_state, new_state);
+	}
+#else
+	old_state = READ_ONCE(ei->i_flags);
+	if (old_state & (1UL << (32 + EXT4_STATE_IS_SYNCING))) {
+		unsigned long new_state;
+
+		new_state = old_state &
+			~((1UL << (32 + EXT4_STATE_IS_SYNCING)) |
+			  (1UL << (32 + EXT4_STATE_HAS_ALLOCATED)));
+		cmpxchg(&ei->i_flags, old_state, new_state);
+	}
+#endif
 	trace_ext4_sync_file_exit(inode, ret);
 	return ret;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b464e5..4ce0a81 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -659,6 +659,11 @@ found:
 				goto out_sem;
 			}
 		}
+		if ((map->m_flags & EXT4_MAP_NEW) &&
+		    !(map->m_flags & EXT4_MAP_UNWRITTEN)) {
+			ext4_clear_inode_state(inode, EXT4_STATE_IS_SYNCING);
+			ext4_set_inode_state(inode, EXT4_STATE_HAS_ALLOCATED);
+		}
 
 		/*
 		 * If the extent has been zeroed out, we don't need to update
@@ -3532,20 +3537,47 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	ssize_t ret;
 
-	if (ext4_should_dioread_nolock(inode)) {
+	inode_dio_begin(inode);
+	smp_mb();
+	if (ext4_should_dioread_nolock(inode))
+		unlocked = 1;
+	else if (!ext4_has_inline_data(inode)) {
+		struct ext4_map_blocks map;
+		loff_t offset = iocb->ki_pos;
+		loff_t end = offset + iov_iter_count(iter) - 1;
+		ext4_lblk_t iblock = offset >> inode->i_blkbits;
+		int wanted = ((offset + end) >> inode->i_blkbits) - iblock + 1;
+		int ret;
+
 		/*
-		 * Nolock dioread optimization may be dynamically disabled
-		 * via ext4_inode_block_unlocked_dio(). Check inode's state
-		 * while holding extra i_dio_count ref.
+		 * If the blocks we are going to read are all
+		 * allocated and initialized, and we haven't allocated
+		 * any blocks to this inode recently, it is safe to do
+		 * an unlocked DIO read.  (We do this check with
+		 * i_dio_count elevated, so we don't have to worry
+		 * about any racing truncate or punch hole
+		 * operations.)
 		 */
-		inode_dio_begin(inode);
-		smp_mb();
-		if (unlikely(ext4_test_inode_state(inode,
-						    EXT4_STATE_DIOREAD_LOCK)))
-			inode_dio_end(inode);
-		else
+		while (wanted) {
+			map.m_lblk = iblock;
+			map.m_len = wanted;
+
+			ret = ext4_map_blocks(NULL, inode, &map, 0);
+			if ((ret <= 0) ||
+			    (map.m_flags & EXT4_MAP_UNWRITTEN))
+				break;
+			iblock += ret;
+			wanted -= ret;
+		}
+		if ((wanted == 0) &&
+		    !ext4_test_inode_state(inode, EXT4_STATE_HAS_ALLOCATED))
 			unlocked = 1;
 	}
+	if (unlocked &&
+	    unlikely(ext4_test_inode_state(inode,
+					   EXT4_STATE_DIOREAD_LOCK)))
+		unlocked = 0;
+
 	if (IS_DAX(inode)) {
 		ret = dax_do_io(iocb, inode, iter, ext4_dio_get_block,
 				NULL, unlocked ? 0 : DIO_LOCKING);
@@ -3555,8 +3587,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 					   NULL, NULL,
 					   unlocked ? 0 : DIO_LOCKING);
 	}
-	if (unlocked)
-		inode_dio_end(inode);
+	inode_dio_end(inode);
 	return ret;
 }
 
-- 
2.9.0.243.g5c589a7.dirty

