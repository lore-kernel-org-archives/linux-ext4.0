From: amir73il@users.sourceforge.net
Subject: [PATCH v1 17/36] ext4: snapshot block operation - copy block bitmap to snapshot
Date: Tue,  7 Jun 2011 18:07:44 +0300
Message-ID: <1307459283-22130-18-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:42 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:41 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

The snapshot copy of the file system block bitmap is called the COW
bitmap and it is used to check if a block was allocated at the time
that the snapshot was taken.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/snapshot.c     |  250 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/snapshot_ctl.c |   19 ++++-
 2 files changed, 264 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index adeb0b6..9fb5c2f 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -75,6 +75,27 @@ __ext4_snapshot_copy_buffer(struct buffer_head *sbh,
 }
 
 /*
+ * use @mask to clear exclude bitmap bits from block bitmap
+ * when creating COW bitmap and mark snapshot buffer @sbh uptodate
+ */
+static inline void
+__ext4_snapshot_copy_bitmap(struct buffer_head *sbh,
+		char *dst, const char *src, const char *mask)
+{
+	const u32 *ps = (const u32 *)src, *pm = (const u32 *)mask;
+	u32 *pd = (u32 *)dst;
+	int i;
+
+	if (mask) {
+		for (i = 0; i < SNAPSHOT_ADDR_PER_BLOCK; i++)
+			*pd++ = *ps++ & ~*pm++;
+	} else
+		memcpy(dst, src, SNAPSHOT_BLOCK_SIZE);
+
+	set_buffer_uptodate(sbh);
+}
+
+/*
  * ext4_snapshot_complete_cow()
  * Unlock a newly COWed snapshot buffer and complete the COW operation.
  * Optionally, sync the buffer to disk or add it to the current transaction
@@ -123,13 +144,228 @@ void ext4_snapshot_copy_buffer(struct buffer_head *sbh,
 		struct buffer_head *bh, const char *mask)
 {
 	lock_buffer(sbh);
-	__ext4_snapshot_copy_buffer(sbh, bh);
+	if (mask)
+		__ext4_snapshot_copy_bitmap(sbh,
+				sbh->b_data, bh->b_data, mask);
+	else
+		__ext4_snapshot_copy_buffer(sbh, bh);
 	unlock_buffer(sbh);
 	mark_buffer_dirty(sbh);
 	sync_dirty_buffer(sbh);
 }
 
 /*
+ * COW bitmap functions
+ */
+
+/*
+ * ext4_snapshot_init_cow_bitmap() init a new allocated (locked) COW bitmap
+ * buffer on first time block group access after snapshot take.
+ * COW bitmap is created by masking the block bitmap with exclude bitmap.
+ */
+static int
+ext4_snapshot_init_cow_bitmap(struct super_block *sb,
+		unsigned int block_group, struct buffer_head *cow_bh)
+{
+	struct buffer_head *bitmap_bh;
+	char *dst, *src, *mask = NULL;
+
+	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
+	if (!bitmap_bh)
+		return -EIO;
+
+	src = bitmap_bh->b_data;
+	/*
+	 * Another COWing task may be changing this block bitmap
+	 * (allocating active snapshot blocks) while we are trying
+	 * to copy it.  At this point we are guaranteed that the only
+	 * changes to block bitmap are the new active snapshot blocks,
+	 * because before allocating/freeing any other blocks a task
+	 * must first get_write_access() on the bitmap and get here.
+	 */
+	ext4_lock_group(sb, block_group);
+
+	/*
+	 * in the path coming from ext4_snapshot_read_block_bitmap(),
+	 * cow_bh is a user page buffer so it has to be kmapped.
+	 */
+	dst = kmap_atomic(cow_bh->b_page, KM_USER0);
+	__ext4_snapshot_copy_bitmap(cow_bh, dst, src, mask);
+	kunmap_atomic(dst, KM_USER0);
+
+	ext4_unlock_group(sb, block_group);
+
+	brelse(bitmap_bh);
+	return 0;
+}
+
+/*
+ * ext4_snapshot_read_block_bitmap()
+ * helper function for ext4_snapshot_get_block()
+ * used for fixing the block bitmap user page buffer when
+ * reading through to block device.
+ */
+int ext4_snapshot_read_block_bitmap(struct super_block *sb,
+		unsigned int block_group, struct buffer_head *bitmap_bh)
+{
+	int err;
+
+	lock_buffer(bitmap_bh);
+	err = ext4_snapshot_init_cow_bitmap(sb, block_group, bitmap_bh);
+	unlock_buffer(bitmap_bh);
+	return err;
+}
+
+/*
+ * ext4_snapshot_read_cow_bitmap - read COW bitmap from active snapshot
+ * @handle:	JBD handle
+ * @snapshot:	active snapshot
+ * @block_group: block group
+ *
+ * Reads the COW bitmap block (i.e., the active snapshot copy of block bitmap).
+ * Creates the COW bitmap on first access to @block_group after snapshot take.
+ * COW bitmap cache is non-persistent, so no need to mark the group descriptor
+ * block dirty.  COW bitmap races are handled internally, so no locks are
+ * required when calling this function, only a valid @handle.
+ *
+ * Return COW bitmap buffer on success or NULL in case of failure.
+ */
+static struct buffer_head *
+ext4_snapshot_read_cow_bitmap(handle_t *handle, struct inode *snapshot,
+			       unsigned int block_group)
+{
+	struct super_block *sb = snapshot->i_sb;
+	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
+	struct ext4_group_desc *desc;
+	struct buffer_head *cow_bh;
+	ext4_fsblk_t bitmap_blk;
+	ext4_fsblk_t cow_bitmap_blk;
+	int err = 0;
+
+	desc = ext4_get_group_desc(sb, block_group, NULL);
+	if (!desc)
+		return NULL;
+
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+
+	ext4_lock_group(sb, block_group);
+	cow_bitmap_blk = grp->bg_cow_bitmap;
+	ext4_unlock_group(sb, block_group);
+	if (cow_bitmap_blk)
+		return sb_bread(sb, cow_bitmap_blk);
+
+	/*
+	 * Try to read cow bitmap block from snapshot file.  If COW bitmap
+	 * is not yet allocated, create the new COW bitmap block.
+	 */
+	cow_bh = ext4_bread(handle, snapshot, SNAPSHOT_IBLOCK(bitmap_blk),
+				SNAPMAP_READ, &err);
+	if (cow_bh)
+		goto out;
+
+	/* allocate snapshot block for COW bitmap */
+	cow_bh = ext4_getblk(handle, snapshot, SNAPSHOT_IBLOCK(bitmap_blk),
+			     SNAPMAP_BITMAP, &err);
+	if (!cow_bh)
+		goto out;
+	if (!err) {
+		/*
+		 * err should be 1 to indicate new allocated (locked) buffer.
+		 * if err is 0, it means that someone mapped this block
+		 * before us, while we are updating the COW bitmap cache.
+		 * the pending COW bitmap code should prevent that.
+		 */
+		WARN_ON(1);
+		err = -EIO;
+		goto out;
+	}
+
+	err = ext4_snapshot_init_cow_bitmap(sb, block_group, cow_bh);
+	if (err)
+		goto out;
+	/*
+	 * complete pending COW operation. no need to wait for tracked reads
+	 * of block bitmap, because it is copied directly to page buffer by
+	 * ext4_snapshot_read_block_bitmap()
+	 */
+	err = ext4_snapshot_complete_cow(handle, snapshot, cow_bh, NULL, 1);
+	if (err)
+		goto out;
+
+	trace_cow_inc(handle, bitmaps);
+out:
+	if (!err && cow_bh) {
+		/* initialized COW bitmap block */
+		cow_bitmap_blk = cow_bh->b_blocknr;
+		snapshot_debug(3, "COW bitmap #%u of snapshot (%u) "
+				"mapped to block [%lld/%lld]\n",
+				block_group, snapshot->i_generation,
+				SNAPSHOT_BLOCK_TUPLE(cow_bitmap_blk));
+	} else {
+		/* uninitialized COW bitmap block */
+		cow_bitmap_blk = 0;
+		snapshot_debug(1, "failed to read COW bitmap #%u of snapshot "
+				"(%u)\n", block_group, snapshot->i_generation);
+		brelse(cow_bh);
+		cow_bh = NULL;
+	}
+
+	/* update or reset COW bitmap cache */
+	ext4_lock_group(sb, block_group);
+	grp->bg_cow_bitmap = cow_bitmap_blk;
+	ext4_unlock_group(sb, block_group);
+
+	return cow_bh;
+}
+
+/*
+ * ext4_snapshot_test_cow_bitmap - test if blocks are in use by snapshot
+ * @handle:	JBD handle
+ * @snapshot:	active snapshot
+ * @block:	address of block
+ * @maxblocks:	max no. of blocks to be tested
+ * @excluded:	if not NULL, blocks belong to this excluded inode
+ *
+ * If the block bit is set in the COW bitmap, than it was allocated at the time
+ * that the active snapshot was taken and is therefore "in use" by the snapshot.
+ *
+ * Return values:
+ * > 0 - blocks are in use by snapshot
+ * = 0 - @blocks are not in use by snapshot
+ * < 0 - error
+ */
+static int
+ext4_snapshot_test_cow_bitmap(handle_t *handle, struct inode *snapshot,
+		ext4_fsblk_t block, int *maxblocks, struct inode *excluded)
+{
+	struct buffer_head *cow_bh;
+	unsigned long block_group = SNAPSHOT_BLOCK_GROUP(block);
+	ext4_grpblk_t bit = SNAPSHOT_BLOCK_GROUP_OFFSET(block);
+	ext4_fsblk_t snapshot_blocks = SNAPSHOT_BLOCKS(snapshot);
+	int ret;
+
+	if (block >= snapshot_blocks)
+		/*
+		 * Block is not is use by snapshot because it is past the
+		 * last f/s block at the time that the snapshot was taken.
+		 * (suggests that f/s was resized after snapshot take)
+		 */
+		return 0;
+
+	cow_bh = ext4_snapshot_read_cow_bitmap(handle, snapshot, block_group);
+	if (!cow_bh)
+		return -EIO;
+	/*
+	 * if the bit is set in the COW bitmap,
+	 * then the block is in use by snapshot
+	 */
+
+	ret = ext4_mb_test_bit_range(bit, cow_bh->b_data, maxblocks);
+
+	brelse(cow_bh);
+	return ret;
+}
+/*
  * COW functions
  */
 
@@ -248,8 +484,11 @@ int ext4_snapshot_test_and_cow(const char *where, handle_t *handle,
 		cow = 0;
 	}
 
-	if (clear < 0)
-		goto cowed;
+	/* get the COW bitmap and test if blocks are in use by snapshot */
+	err = ext4_snapshot_test_cow_bitmap(handle, active_snapshot,
+			block, &count, clear < 0 ? inode : NULL);
+	if (err < 0)
+		goto out;
 	if (!err) {
 		trace_cow_inc(handle, ok_bitmap);
 		goto cowed;
@@ -374,7 +613,10 @@ int ext4_snapshot_test_and_move(const char *where, handle_t *handle,
 		move = 0;
 	}
 
-	if (excluded)
+	/* get the COW bitmap and test if blocks are in use by snapshot */
+	err = ext4_snapshot_test_cow_bitmap(handle, active_snapshot,
+			block, &count, excluded ? inode : NULL);
+	if (err < 0)
 		goto out;
 	if (!err) {
 		/* block not in COW bitmap - no need to move */
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 1abda77..810cb21 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -112,7 +112,24 @@ static int ext4_snapshot_set_active(struct super_block *sb,
 
 	return 0;
 }
-#define ext4_snapshot_reset_bitmap_cache(sb, init) 0
+/*
+ * ext4_snapshot_reset_bitmap_cache():
+ *
+ * Resets the COW/exclude bitmap cache for all block groups.
+ *
+ * Called from snapshot_take() under journal_lock_updates().
+ */
+static void ext4_snapshot_reset_bitmap_cache(struct super_block *sb)
+{
+	struct ext4_group_info *grp;
+	int i;
+
+	for (i = 0; i < EXT4_SB(sb)->s_groups_count; i++) {
+		grp = ext4_get_group_info(sb, i);
+		grp->bg_cow_bitmap = 0;
+		cond_resched();
+	}
+}
 
 /*
  * Snapshot constructor/destructor
-- 
1.7.4.1

