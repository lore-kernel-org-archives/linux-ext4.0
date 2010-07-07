From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] Add batched discard support for ext3
Date: Wed,  7 Jul 2010 15:18:47 +0200
Message-ID: <1278508727-29135-3-git-send-email-lczerner@redhat.com>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
Cc: lczerner@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab0GGNS5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jul 2010 09:18:57 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o67DIvlN019998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jul 2010 09:18:57 -0400
In-Reply-To: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Walk through each allocation group and trim all free extents. It can be
invoked through TRIM ioctl on the file system. The main idea is to
provide a way to trim the whole file system if needed, since some SSD's
may suffer from performance loss after the whole device was filled (it
does not mean that fs is full!).

It search for free extents in each allocation group. When the free
extent is found, blocks are marked as used and then trimmed. Afterwards
these blocks are marked as free in per-group bitmap.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext3/balloc.c        |  145 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    1 +
 include/linux/ext3_fs.h |    1 +
 3 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a177122..bcee525 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -20,6 +20,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/blkdev.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -1876,3 +1877,147 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
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
+ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
+			struct ext3_group_desc *gdp, ext3_grpblk_t minblocks)
+{
+	ext3_grpblk_t max = EXT3_BLOCKS_PER_GROUP(sb);
+	ext3_grpblk_t next, tmp, count = 0, start = 0;
+	struct ext3_sb_info *sbi;
+	ext3_fsblk_t discard_block;
+	struct buffer_head *bh = NULL;
+	ext3_grpblk_t free_blocks;
+
+	BUG_ON(gdp == NULL);
+
+	bh = read_block_bitmap(sb, group);
+	if (!bh) {
+		brelse(bh);
+		return 0;
+	}
+
+	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+	sbi = EXT3_SB(sb);
+
+	/**
+	 * Walk through the whole group
+	 */
+	while (start < max) {
+		start = ext3_find_next_zero_bit(bh->b_data, max, start);
+		next = start;
+
+		/**
+		 * Allocate contiguous free extents by setting bits in the
+		 * block bitmap
+		 */
+		while (next < max
+			&& !ext3_set_bit_atomic(sb_bgl_lock(sbi, group),
+					next, bh->b_data)) {
+			next++;
+		}
+
+		if (next == start)
+			continue;
+
+		spin_lock(sb_bgl_lock(sbi, group));
+		le16_add_cpu(&gdp->bg_free_blocks_count, start - next);
+		spin_unlock(sb_bgl_lock(sbi, group));
+		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
+
+		/* Do not issue a TRIM on extents smaller than minblocks */
+		if ((next - start) < minblocks)
+			goto free_extent;
+
+		count += (next - start);
+
+		discard_block = (ext3_fsblk_t)start +
+				ext3_group_first_block_no(sb, group);
+		sb_issue_discard(sb, discard_block, next - start);
+
+free_extent:
+		/**
+		 * Free previously allocated extent by clearing bits in the
+		 * blocks bitmap
+		 */
+		tmp = next - 1;
+		while (tmp >= start) {
+			ext3_clear_bit_atomic(sb_bgl_lock(sbi, group),
+						tmp, bh->b_data);
+			tmp--;
+		}
+
+		spin_lock(sb_bgl_lock(sbi, group));
+		le16_add_cpu(&gdp->bg_free_blocks_count, next - start);
+		spin_unlock(sb_bgl_lock(sbi, group));
+		percpu_counter_add(&sbi->s_freeblocks_counter, next - start);
+
+		start = next;
+
+		/* No more suitable extents */
+		if ((free_blocks - count) < minblocks)
+			break;
+	}
+
+	brelse(bh);
+
+	ext3_debug("trimmed %d blocks in the group %d\n",
+		count, group);
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
+ * invoked.
+ */
+int ext3_trim_fs(unsigned int minlen, struct super_block *sb)
+{
+	ext3_grpblk_t minblocks;
+	unsigned long ngroups;
+	unsigned int group;
+	struct ext3_group_desc *gdp;
+	ext3_grpblk_t free_blocks;
+
+	if (!test_opt(sb, DISCARD))
+		return 0;
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
+			continue;
+
+		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+		if (free_blocks < minblocks)
+			continue;
+
+		ext3_trim_all_free(sb, group, gdp, minblocks);
+	}
+
+	return 0;
+}
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6baf7ef..5b639b3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -794,6 +794,7 @@ static const struct super_operations ext3_sops = {
 	.quota_write	= ext3_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.trim_fs	= ext3_trim_fs,
 };
 
 static const struct export_operations ext3_export_ops = {
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index f3fdd94..b7337e9 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -858,6 +858,7 @@ extern struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
 extern int ext3_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext3_init_block_alloc_info(struct inode *);
 extern void ext3_rsv_window_add(struct super_block *sb, struct ext3_reserve_window_node *rsv);
+extern int ext3_trim_fs(unsigned int minlen, struct super_block *sb);
 
 /* dir.c */
 extern int ext3_check_dir_entry(const char *, struct inode *,
-- 
1.6.6.1

