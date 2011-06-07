From: amir73il@users.sourceforge.net
Subject: [PATCH v1 10/36] ext4: snapshot file - read through to block device
Date: Tue,  7 Jun 2011 18:07:37 +0300
Message-ID: <1307459283-22130-11-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:22 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:21 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

On active snapshot page read, the function ext4_snapshot_get_block()
is called to map the page to a disk block.  If the page is not mapped
in the snapshot file a direct mapping to the block device is returned.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c          |    3 +-
 fs/ext4/snapshot_inode.c |  244 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 245 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0468ef2..f44f7d3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4158,8 +4158,7 @@ static int ext4_no_writepage(struct page *page,
  * the snapshot COW bitmaps and a few initial blocks copied on snapshot_take().
  */
 static const struct address_space_operations ext4_snapfile_aops = {
-	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
+	.readpage		= ext4_snapshot_readpage,
 	.writepage		= ext4_no_writepage,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index 2de017a..74b455d 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -38,5 +38,249 @@
 
 #include <trace/events/ext4.h>
 #include "snapshot.h"
+/*
+ * ext4_snapshot_get_block_access() - called from ext4_snapshot_read_through()
+ * on snapshot file access.
+ * return value <0 indicates access not granted
+ * return value 0 indicates snapshot inode read through access
+ * in which case 'prev_snapshot' is pointed to the previous snapshot
+ * on the list or set to NULL to indicate read through to block device.
+ */
+static int ext4_snapshot_get_block_access(struct inode *inode,
+		struct inode **prev_snapshot)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned long flags = ext4_get_snapstate_flags(inode);
+
+
+	*prev_snapshot = NULL;
+	if (ext4_snapshot_is_active(inode) ||
+			(flags & 1UL<<EXT4_SNAPSTATE_ACTIVE))
+		/* read through from active snapshot to block device */
+		return 0;
+
+	return -EPERM;
+}
+
+#ifdef CONFIG_EXT4_DEBUG
+/*
+ * ext4_snapshot_get_blockdev_access - get read through access to block device.
+ * Sanity test to verify that the read block is allocated and not excluded.
+ * This test has performance penalty and is only called if SNAPTEST_READ
+ * is enabled.  An attempt to read through to block device of a non allocated
+ * or excluded block may indicate a corrupted filesystem, corrupted snapshot
+ * or corrupted exclude bitmap.  However, it may also be a read-ahead, which
+ * was not implicitly requested by the user, so be sure to disable read-ahead
+ * on block device (blockdev --setra 0 <bdev>) before enabling SNAPTEST_READ.
+ *
+ * Return values:
+ * = 0 - block is allocated and not excluded
+ * < 0 - error (or block is not allocated or excluded)
+ */
+static int ext4_snapshot_get_blockdev_access(struct super_block *sb,
+				   struct buffer_head *bh)
+{
+	unsigned long block_group = SNAPSHOT_BLOCK_GROUP(bh->b_blocknr);
+	ext4_grpblk_t bit = SNAPSHOT_BLOCK_GROUP_OFFSET(bh->b_blocknr);
+	struct buffer_head *bitmap_bh;
+	int err = 0;
+
+	if (PageReadahead(bh->b_page))
+		return 0;
+
+	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
+	if (!bitmap_bh)
+		return -EIO;
+
+	if (!ext4_test_bit(bit, bitmap_bh->b_data)) {
+		snapshot_debug(2, "warning: attempt to read through to "
+				"non-allocated block [%d/%lu] - read ahead?\n",
+				bit, block_group);
+		brelse(bitmap_bh);
+		return -EIO;
+	}
+
+	brelse(bitmap_bh);
+	return err;
+}
+#endif
+
+/*
+ * ext4_snapshot_read_through - get snapshot image block.
+ * On read of snapshot file, an unmapped block is a peephole to prev snapshot.
+ * On read of active snapshot, an unmapped block is a peephole to the block
+ * device.  On first block write, the peephole is filled forever.
+ */
+static int ext4_snapshot_read_through(struct inode *inode, sector_t iblock,
+				      struct buffer_head *bh_result)
+{
+	int err;
+	struct ext4_map_blocks map;
+	struct inode *prev_snapshot;
+
+	map.m_lblk = iblock;
+	map.m_pblk = 0;
+	map.m_len = bh_result->b_size >> inode->i_blkbits;
+
+	prev_snapshot = NULL;
+	/* request snapshot file read access */
+	err = ext4_snapshot_get_block_access(inode, &prev_snapshot);
+	if (err < 0)
+		return err;
+	err = ext4_map_blocks(NULL, inode, &map, 0);
+	snapshot_debug(4, "ext4_snapshot_read_through(%lld): block = "
+		       "(%lld), err = %d\n prev_snapshot = %u",
+		       (long long)iblock, map.m_pblk, err,
+		       prev_snapshot ? prev_snapshot->i_generation : 0);
+	if (err < 0)
+		return err;
+	if (!err)
+		/* hole in active snapshot - read though to block device */
+		return 0;
+
+	map_bh(bh_result, inode->i_sb, map.m_pblk);
+	bh_result->b_state = (bh_result->b_state & ~EXT4_MAP_FLAGS) |
+		map.m_flags;
+
+	return 0;
+}
+
+/*
+ * Check if @block is a bitmap block of @group.
+ * if @block is found to be a block/inode/exclude bitmap block, the return
+ * value is one of the non-zero values below:
+ */
+#define BLOCK_BITMAP	1
+#define INODE_BITMAP	2
+#define EXCLUDE_BITMAP	3
+
+static int ext4_snapshot_is_group_bitmap(struct super_block *sb,
+		ext4_fsblk_t block, ext4_group_t group)
+{
+	struct ext4_group_desc *gdp;
+	struct ext4_group_info *grp;
+	ext4_fsblk_t bitmap_blk;
+
+	gdp = ext4_get_group_desc(sb, group, NULL);
+	grp = ext4_get_group_info(sb, group);
+	if (!gdp || !grp)
+		return 0;
+
+	bitmap_blk = ext4_block_bitmap(sb, gdp);
+	if (bitmap_blk == block)
+		return BLOCK_BITMAP;
+	bitmap_blk = ext4_inode_bitmap(sb, gdp);
+	if (bitmap_blk == block)
+		return INODE_BITMAP;
+	bitmap_blk = ext4_exclude_bitmap(sb, gdp);
+	if (bitmap_blk == block)
+		return EXCLUDE_BITMAP;
+	return 0;
+}
+
+/*
+ * Check if @block is a bitmap block and of any block group.
+ * if @block is found to be a bitmap block, @bitmap_group is set to the
+ * block group described by the bitmap block.
+ */
+static int ext4_snapshot_is_bitmap(struct super_block *sb,
+		ext4_fsblk_t block, ext4_group_t *bitmap_group)
+{
+	ext4_group_t group = SNAPSHOT_BLOCK_GROUP(block);
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	int flex_groups = ext4_flex_bg_size(EXT4_SB(sb));
+	int i, is_bitmap = 0;
+
+	/*
+	 * When block is in the first block group of a flex group, we need to
+	 * check all group desc of the flex group.
+	 * The exclude bitmap can potentially be allocated from any group, if
+	 * exclude inode was added not on mkfs.  The worst case if we fail to
+	 * identify a block as an exclude bitmap is that fsck sanity check of
+	 * snapshots will fail, becasue exclude bitmap inside snapshot will
+	 * not be all zeros.
+	 */
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) ||
+			(group % flex_groups) != 0)
+		flex_groups = 1;
+
+	for (i = 0; i < flex_groups && group < ngroups; i++, group++) {
+		is_bitmap = ext4_snapshot_is_group_bitmap(sb, block, group);
+		if (is_bitmap)
+			break;
+	}
+	*bitmap_group = group;
+	return is_bitmap;
+}
+
+static int ext4_snapshot_get_block(struct inode *inode, sector_t iblock,
+			struct buffer_head *bh_result, int create)
+{
+	ext4_group_t block_group;
+	int err, is_bitmap;
+
+	BUG_ON(create != 0);
+	BUG_ON(buffer_tracked_read(bh_result));
+
+	err = ext4_snapshot_read_through(inode, SNAPSHOT_IBLOCK(iblock),
+					 bh_result);
+	snapshot_debug(4, "ext4_snapshot_get_block(%lld): block = (%lld), "
+		       "err = %d\n",
+		       (long long)iblock, buffer_mapped(bh_result) ?
+		       (long long)bh_result->b_blocknr : 0, err);
+	if (err < 0)
+		return err;
+
+	if (!buffer_tracked_read(bh_result))
+		return 0;
+
+	/* Check for read through to block or exclude bitmap block */
+	is_bitmap = ext4_snapshot_is_bitmap(inode->i_sb, bh_result->b_blocknr,
+			&block_group);
+	if (is_bitmap == BLOCK_BITMAP) {
+		/* copy fixed block bitmap directly to page buffer */
+		cancel_buffer_tracked_read(bh_result);
+		/* cancel_buffer_tracked_read() clears mapped flag */
+		set_buffer_mapped(bh_result);
+		snapshot_debug(2, "fixing snapshot block bitmap #%u\n",
+			       block_group);
+		/*
+		 * XXX: if we return unmapped buffer, the page will be zeroed
+		 * but if we return mapped to block device and uptodate buffer
+		 * next readpage may read directly from block device without
+		 * fixing block bitmap.  This only affects fsck of snapshots.
+		 */
+		return ext4_snapshot_read_block_bitmap(inode->i_sb,
+						       block_group, bh_result);
+	} else if (is_bitmap == EXCLUDE_BITMAP) {
+		/* return unmapped buffer to zero out page */
+		cancel_buffer_tracked_read(bh_result);
+		/* cancel_buffer_tracked_read() clears mapped flag */
+		snapshot_debug(2, "zeroing snapshot exclude bitmap #%u\n",
+			       block_group);
+		return 0;
+	}
+
 #ifdef CONFIG_EXT4_DEBUG
+	snapshot_debug(3, "started tracked read: block = [%llu/%llu]\n",
+		       SNAPSHOT_BLOCK_TUPLE(bh_result->b_blocknr));
+	if (snapshot_enable_test[SNAPTEST_READ]) {
+		err = ext4_snapshot_get_blockdev_access(inode->i_sb,
+						    bh_result);
+		if (err) {
+			/* read through access denied */
+			cancel_buffer_tracked_read(bh_result);
+			return err;
+		}
+		/* sleep 1 tunable delay unit */
+		snapshot_test_delay(SNAPTEST_READ);
+	}
 #endif
+	return 0;
+}
+
+int ext4_snapshot_readpage(struct file *file, struct page *page)
+{
+	/* do read I/O with buffer heads to enable tracked reads */
+	return ext4_read_full_page(page, ext4_snapshot_get_block);
+}
-- 
1.7.4.1

