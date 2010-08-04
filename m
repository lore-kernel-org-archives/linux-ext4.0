From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] Add batched discard support for ext3
Date: Wed,  4 Aug 2010 15:44:34 +0200
Message-ID: <1280929475-12823-2-git-send-email-lczerner@redhat.com>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
Cc: jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946Ab0HDNpK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 09:45:10 -0400
In-Reply-To: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Walk through each allocation group and trim all free extents. It can be
invoked through FITRIM ioctl on the file system. The main idea is to
provide a way to trim the whole file system if needed, since some SSD's
may suffer from performance loss after the whole device was filled (it
does not mean that fs is full!).

It search for free extents in each allocation group. When the free
extent is found, blocks are marked as used and then trimmed. Afterwards
these blocks are marked as free in per-group bitmap.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext3/balloc.c        |  217 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    1 +
 include/linux/ext3_fs.h |    1 +
 3 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 4a32511..dffc2e2 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -20,6 +20,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/blkdev.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -1882,3 +1883,219 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
 	return ext3_bg_num_gdb_meta(sb,group);
 
 }
+
+/**
+ * ext3_trim_all_free -- function to trim all free space in alloc. group
+ * @sb:			super block for file system
+ * @group:		allocation group to trim
+ * @gdp:		allocation group description structure
+ * @minblocks:		minimum extent block count
+ *
+ * ext3_trim_all_free walks through group's block bitmap searching for free
+ * blocks. When the free block is found, it tries to allocate this block and
+ * consequent free block to get the biggest free extent possible, until it
+ * reaches any used block. Then issue a TRIM command on this extent and free
+ * the extent in the block bitmap. This is done until whole group is scanned.
+ */
+ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
+			unsigned int group, ext3_grpblk_t minblocks)
+{
+	handle_t *handle;
+	ext3_grpblk_t max = EXT3_BLOCKS_PER_GROUP(sb);
+	ext3_grpblk_t next, count = 0, start, bit;
+	struct ext3_sb_info *sbi;
+	ext3_fsblk_t discard_block;
+	struct buffer_head *bitmap_bh = NULL;
+	struct buffer_head *gdp_bh;
+	ext3_grpblk_t free_blocks;
+	struct ext3_group_desc *gdp;
+	int err = 0, ret;
+	ext3_grpblk_t freed;
+
+	/*
+	 * We will update one block bitmap, and one group descriptor
+	 */
+	handle = ext3_journal_start_sb(sb, 2);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		return err;
+	}
+
+	bitmap_bh = read_block_bitmap(sb, group);
+	if (!bitmap_bh)
+		goto err_out;
+
+	BUFFER_TRACE(bitmap_bh, "getting undo access");
+	err = ext3_journal_get_undo_access(handle, bitmap_bh);
+	if (err)
+		goto err_out;
+
+	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
+	if (!gdp)
+		goto err_out;
+
+	BUFFER_TRACE(gd_bh, "get_write_access");
+	err = ext3_journal_get_write_access(handle, gdp_bh);
+	if (err)
+		goto err_out;
+
+	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+	sbi = EXT3_SB(sb);
+
+	 /* Walk through the whole group */
+	start = 0;
+	while (start < max) {
+
+		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
+		if (start < 0)
+			break;
+		next = start;
+
+		/*
+		 * Allocate contiguous free extents by setting bits in the
+		 * block bitmap
+		 */
+		while (next < max
+			&& claim_block(sb_bgl_lock(sbi, group),
+					next, bitmap_bh)) {
+			next++;
+		}
+
+		 /* We did not claim any blocks */
+		if (next == start)
+			continue;
+
+		discard_block = (ext3_fsblk_t)start +
+				ext3_group_first_block_no(sb, group);
+
+		/* Update counters */
+		spin_lock(sb_bgl_lock(sbi, group));
+		le16_add_cpu(&gdp->bg_free_blocks_count, start - next);
+		spin_unlock(sb_bgl_lock(sbi, group));
+		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
+
+		/* Do not issue a TRIM on extents smaller than minblocks */
+		if ((next - start) < minblocks)
+			goto free_extent;
+
+		 /* Send the TRIM command down to the device */
+		ret = sb_issue_discard(sb, discard_block, next - start);
+		count += (next - start);
+
+free_extent:
+		freed = 0;
+
+		/*
+		 * Clear bits in the bitmap
+		 */
+		for (bit = start; bit < next; bit++) {
+			BUFFER_TRACE(bitmap_bh, "clear bit");
+			if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, group),
+						bit, bitmap_bh->b_data)) {
+				ext3_error(sb, __func__,
+					"bit already cleared for block "E3FSBLK,
+					 (unsigned long)bit);
+				BUFFER_TRACE(bitmap_bh, "bit already cleared");
+			} else {
+				freed++;
+			}
+		}
+
+		/* Update couters */
+		spin_lock(sb_bgl_lock(sbi, group));
+		le16_add_cpu(&gdp->bg_free_blocks_count, freed);
+		spin_unlock(sb_bgl_lock(sbi, group));
+		percpu_counter_add(&sbi->s_freeblocks_counter, next - start);
+
+		start = next;
+
+		if (ret == EOPNOTSUPP) {
+			ext3_warning(sb, __func__,
+				"discard not supported!");
+			count = -EOPNOTSUPP;
+			break;
+
+		}
+
+		if (signal_pending(current)) {
+			count = -ERESTARTSYS;
+			break;
+		}
+
+		cond_resched();
+
+		/* No more suitable extents */
+		if ((free_blocks - count) < minblocks)
+			break;
+	}
+
+	/* We dirtied the bitmap block */
+	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	err = ext3_journal_dirty_metadata(handle, bitmap_bh);
+
+	/* And the group descriptor block */
+	BUFFER_TRACE(gdp_bh, "dirtied group descriptor block");
+	ret = ext3_journal_dirty_metadata(handle, gdp_bh);
+	if (!err)
+		err = ret;
+
+	ext3_debug("trimmed %d blocks in the group %d\n",
+		count, group);
+
+err_out:
+	if (err) {
+		ext3_std_error(sb, err);
+		count = -err;
+	}
+
+	ext3_journal_stop(handle);
+	brelse(bitmap_bh);
+
+	return count;
+}
+
+/**
+ * ext3_trim_fs() -- trim ioctl handle function
+ * @minlen:		minimum extent length in Bytes
+ * @sb:			superblock for filesystem
+ *
+ * ext3_trim_fs goes through all allocation group searching for groups with more
+ * free space than minlen. For such a group ext3_trim_all_free function is
+ * invoked to trim all free space.
+ */
+int ext3_trim_fs(unsigned int minlen, struct super_block *sb)
+{
+	ext3_grpblk_t minblocks;
+	unsigned long ngroups;
+	unsigned int group;
+	struct ext3_group_desc *gdp;
+	ext3_grpblk_t free_blocks;
+	int ret = 0;
+
+	minblocks = DIV_ROUND_UP(minlen, sb->s_blocksize);
+	if (unlikely(minblocks > EXT3_BLOCKS_PER_GROUP(sb)))
+		return -EINVAL;
+
+	ngroups = EXT3_SB(sb)->s_groups_count;
+	smp_rmb();
+
+	for (group = 0; group < ngroups; group++) {
+
+		gdp = ext3_get_group_desc(sb, group, NULL);
+		if (!gdp)
+			break;
+
+		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+		if (free_blocks < minblocks)
+			continue;
+
+		ret = ext3_trim_all_free(sb, group, minblocks);
+		if (ret < 0)
+			break;
+	}
+
+	if (ret >= 0)
+		ret = 0;
+
+	return ret;
+}
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6c953bb..b172c88 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -797,6 +797,7 @@ static const struct super_operations ext3_sops = {
 	.quota_write	= ext3_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.trim_fs	= ext3_trim_fs,
 };
 
 static const struct export_operations ext3_export_ops = {
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 7fc62d4..9083e16 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -857,6 +857,7 @@ extern struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 extern int ext3_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext3_init_block_alloc_info(struct inode *);
 extern void ext3_rsv_window_add(struct super_block *sb, struct ext3_reserve_window_node *rsv);
+extern int ext3_trim_fs(unsigned int minlen, struct super_block *sb);
 
 /* dir.c */
 extern int ext3_check_dir_entry(const char *, struct inode *,
-- 
1.7.2

