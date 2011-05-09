From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 15/30] ext4: snapshot block operation - copy blocks to snapshot
Date: Mon,  9 May 2011 19:41:33 +0300
Message-ID: <1304959308-11122-16-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1EIQnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:52 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:51 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Implementation of copying blocks into a snapshot file.
This mechanism is used to copy-on-write metadata blocks to snapshot.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h    |    3 +++
 fs/ext4/inode.c   |   40 ++++++++++++++++++++++++++++++++++++----
 fs/ext4/mballoc.c |   18 ++++++++++++++++++
 fs/ext4/resize.c  |   10 +++++++++-
 4 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c7fd33e..942cd9c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -122,6 +122,8 @@ typedef unsigned int ext4_group_t;
 /* We are doing stream allocation */
 #define EXT4_MB_STREAM_ALLOC		0x0800
 
+/* allocate blocks for active snapshot */
+#define EXT4_MB_HINT_COWING		0x02000
 
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
@@ -1836,6 +1838,7 @@ extern void __ext4_free_blocks(const char *where, unsigned int line,
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
+extern int ext4_mb_test_bit_range(int bit, void *addr, int *pcount);
 
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba66545..b930645 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -699,8 +699,17 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = target;
 	ar.logical = iblock;
-	if (S_ISREG(inode->i_mode))
-		/* enable in-core preallocation only for regular files */
+	if (IS_COWING(handle)) {
+		/*
+		 * This hint is used to tell the allocator not to fail
+		 * on quota limits and allow allocation from blocks which
+		 * are reserved for snapshots.
+		 * Failing allocation during COW operations would result
+		 * in I/O error, which is not desirable.
+		 */
+		ar.flags = EXT4_MB_HINT_COWING;
+	} else if (S_ISREG(inode->i_mode) && !ext4_snapshot_file(inode))
+		/* Enable preallocation only for non-snapshot regular files */
 		ar.flags = EXT4_MB_HINT_DATA;
 
 	current_block = ext4_mb_new_blocks(handle, &ar, err);
@@ -1359,6 +1368,21 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    struct ext4_map_blocks *map, int flags)
 {
 	int retval;
+	int cowing = 0;
+
+	if (handle && IS_COWING(handle)) {
+		/*
+		 * locking order for locks validator:
+		 * inode (VFS operation) -> active snapshot (COW operation)
+		 *
+		 * The i_data_sem lock is nested during COW operation, but
+		 * the active snapshot i_data_sem write lock is not taken
+		 * otherwise, because snapshot file has read-only aops and
+		 * because truncate/unlink of active snapshot is not permitted.
+		 */
+		BUG_ON(!ext4_snapshot_is_active(inode));
+		cowing = 1;
+	}
 
 	map->m_flags = 0;
 	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
@@ -1368,7 +1392,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.
 	 */
-	down_read((&EXT4_I(inode)->i_data_sem));
+	down_read_nested((&EXT4_I(inode)->i_data_sem), cowing);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval = ext4_ext_map_blocks(handle, inode, map,
 				flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE);
@@ -1427,7 +1451,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * the write lock of i_data_sem, and call get_blocks()
 	 * with create == 1 flag.
 	 */
-	down_write((&EXT4_I(inode)->i_data_sem));
+	down_write_nested((&EXT4_I(inode)->i_data_sem), cowing);
 
 	/*
 	 * if the caller is from delayed allocation writeout path
@@ -1618,6 +1642,14 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 		J_ASSERT(create != 0);
 		J_ASSERT(handle != NULL);
 
+		if (SNAPMAP_ISCOW(create)) {
+			/* COWing block or creating COW bitmap */
+			lock_buffer(bh);
+			clear_buffer_uptodate(bh);
+			/* flag locked buffer and return */
+			*errp = 1;
+			return bh;
+		}
 		/*
 		 * Now that we do not always journal data, we should
 		 * keep in mind whether this should always journal the
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5eced75..d43f493 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -420,6 +420,24 @@ static inline int mb_find_next_bit(void *addr, int max, int start)
 	return ret;
 }
 
+/*
+ * Find the largest range of set or clear bits.
+ * Return 1 for set bits and 0 for clear bits.
+ * Set *pcount to number of bits in range.
+ */
+int ext4_mb_test_bit_range(int bit, void *addr, int *pcount)
+{
+	int i, ret;
+
+	ret = mb_test_bit(bit, addr);
+	if (ret)
+		i = mb_find_next_zero_bit(addr, bit + *pcount, bit);
+	else
+		i = mb_find_next_bit(addr, bit + *pcount, bit);
+	*pcount = i - bit;
+	return ret ? 1 : 0;
+}
+
 static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ee9b999..06c11fd 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -673,7 +673,15 @@ static void update_backups(struct super_block *sb,
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
 
-		bh = sb_getblk(sb, group * bpg + blk_off);
+		if (ext4_snapshot_has_active(sb))
+			/*
+			 * test_and_cow() expects an uptodate buffer.
+			 * Read the buffer here to suppress the
+			 * "non uptodate buffer" warning.
+			 */
+			bh = sb_bread(sb, group * bpg + blk_off);
+		else
+			bh = sb_getblk(sb, group * bpg + blk_off);
 		if (!bh) {
 			err = -EIO;
 			break;
-- 
1.7.0.4

