From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 4/5] Ext4 Punch Hole Support: Punch out extents
Date: Tue, 15 Mar 2011 14:18:33 -0700
Message-ID: <4D7FD7A9.6000105@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42448 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1COVSg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 17:18:36 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2FL3OkE015087
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:03:24 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2FLIYFL085800
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:34 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2FLIYa2000504
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:34 -0600
Received: from [127.0.0.1] (IBM-3CEFE379E05.tucson.ibm.com [9.11.169.120])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2FLIWav000437
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:33 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch modifies the truncate routines to support hole punching
Below is a brief summary of the patches changes:

- Added end param to ext_ext4_rm_leaf
        This function has been modified to accept an end parameter
        which enables it to punch holes in leafs instead of just
        truncating them.

- Implemented the "remove head" case in the ext_remove_blocks routine
        This routine is used by ext_ext4_rm_leaf to remove the tail
        of an extent during a truncate.  The new ext_ext4_rm_leaf
        routine will now also use it to remove the head of an extent in the
        case that the hole covers a region of blocks at the beginning
        of an extent.

- Added "end" param to ext4_ext_remove_space routine
        This function has been modified to accept a stop parameter, which
        is passed through to ext4_ext_rm_leaf.

- Added new "ext4_ext_release_blocks" routine
        This routine is basically the ext4_ext_truncate routine, but
        modified to accept a "end" param in addition to "start".  The existing
        ext4_ext_truncate routine has now become a wrapper to this
        function.  The stop parameter just passed through to ext4_ext_remove_space

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 dacb0a1... a46d3d7... M	fs/ext4/extents.c
 fs/ext4/extents.c |  182 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 159 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dacb0a1..a46d3d7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2159,8 +2159,16 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, NULL, start, num, flags);
 	} else if (from == le32_to_cpu(ex->ee_block)
 		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
-		printk(KERN_INFO "strange request: removal %u-%u from %u:%u\n",
-			from, to, le32_to_cpu(ex->ee_block), ee_len);
+		/* head removal */
+		ext4_lblk_t num;
+		ext4_fsblk_t start;
+
+		num = to - from;
+		start = ext4_ext_pblock(ex);
+
+		ext_debug("free first %u blocks starting %llu\n", num, start);
+		ext4_free_blocks(handle, inode, 0, start, num, flags);
+
 	} else {
 		printk(KERN_INFO "strange request: removal(2) "
 				"%u-%u from %u:%u\n",
@@ -2272,9 +2280,22 @@ fix_extent_len:
 	return err;
 }
 +
+/*
+ * ext4_ext_rm_leaf() Removes the extents associated with the
+ * blocks appearing between "start" and "end", and splits the extents
+ * if "start" and "end" appear in the same extent
+ *
+ * @handle: The journal handle
+ * @inode:  The files inode
+ * @path:   The path to the leaf
+ * @start:  The first block to remove
+ * @end:   The last block to remove
+ */
 static int
 ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
-		struct ext4_ext_path *path, ext4_lblk_t start)
+		struct ext4_ext_path *path, ext4_lblk_t start,
+		ext4_lblk_t end)
 {
 	int err = 0, correct_index = 0;
 	int depth = ext_depth(inode), credits;
@@ -2314,31 +2335,88 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		path[depth].p_ext = ex;
  		a = ex_ee_block > start ? ex_ee_block : start;
-		b = ex_ee_block + ex_ee_len - 1 < EXT_MAX_BLOCK ?
-			ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCK;
+		b = ex_ee_block+ex_ee_len - 1 < end ?
+			ex_ee_block+ex_ee_len - 1 : end;
  		ext_debug("  border %u:%u\n", a, b);
 -		if (a != ex_ee_block && b != ex_ee_block + ex_ee_len - 1) {
-			block = 0;
-			num = 0;
-			BUG();
+		/* If this extent is beyond the end of the hole, skip it */
+		if (end <= ex_ee_block) {
+			ex--;
+			ex_ee_block = le32_to_cpu(ex->ee_block);
+			ex_ee_len = ext4_ext_get_actual_len(ex);
+			continue;
+		} else if (a != ex_ee_block &&
+			b != ex_ee_block + ex_ee_len - 1) {
+			/*
+			 * If this is a truncate, then this condition should
+			 * never happen because at least one of the end points
+			 * needs to be on the edge of the extent.
+			 */
+			if (end == EXT_MAX_BLOCK) {
+				ext_debug("  bad truncate %u:%u\n",
+						start, end);
+				block = 0;
+				num = 0;
+				err = -EIO;
+				goto out;
+			}
+			/*
+			 * else this is a hole punch, so the extent needs to
+			 * be split since neither edge of the hole is on the
+			 * extent edge
+			 */
+			else{
+				err = ext4_split_extents(handle, inode,
+					b, path, 0);
+				if (err)
+					goto out;
+
+				ex_ee_len = ext4_ext_get_actual_len(ex);
+
+				b = ex_ee_block+ex_ee_len - 1 < end ?
+					ex_ee_block+ex_ee_len - 1 : end;
+
+				/* Then remove tail of this extent */
+				block = ex_ee_block;
+				num = a - block;
+			}
 		} else if (a != ex_ee_block) {
 			/* remove tail of the extent */
 			block = ex_ee_block;
 			num = a - block;
 		} else if (b != ex_ee_block + ex_ee_len - 1) {
 			/* remove head of the extent */
-			block = a;
-			num = b - a;
-			/* there is no "make a hole" API yet */
-			BUG();
+			block = b;
+			num =  ex_ee_block + ex_ee_len - b;
+
+			/*
+			 * If this is a truncate, this condition
+			 * should never happen
+			 */
+			if (end == EXT_MAX_BLOCK) {
+				ext_debug("  bad truncate %u:%u\n",
+					start, end);
+				err = -EIO;
+				goto out;
+			}
 		} else {
 			/* remove whole extent: excellent! */
 			block = ex_ee_block;
 			num = 0;
-			BUG_ON(a != ex_ee_block);
-			BUG_ON(b != ex_ee_block + ex_ee_len - 1);
+			if (a != ex_ee_block) {
+				ext_debug("  bad truncate %u:%u\n",
+					start, end);
+				err = -EIO;
+				goto out;
+			}
+
+			if (b != ex_ee_block + ex_ee_len - 1) {
+				ext_debug("  bad truncate %u:%u\n",
+					start, end);
+				err = -EIO;
+				goto out;
+			}
 		}
  		/*
@@ -2369,7 +2447,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (num == 0) {
 			/* this extent is removed; mark slot entirely unused */
 			ext4_ext_store_pblock(ex, 0);
-			le16_add_cpu(&eh->eh_entries, -1);
+		} else if (block != ex_ee_block) {
+			/*
+			 * If this was a head removal, then we need to update
+			 * the physical block since it is now at a different
+			 * location
+			 */
+			ext4_ext_store_pblock(ex, ext4_ext_pblock(ex) + (b-a));
 		}
  		ex->ee_block = cpu_to_le32(block);
@@ -2385,6 +2469,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (err)
 			goto out;
 +		/*
+		 * If the extent was completely released,
+		 * we need to remove it from the leaf
+		 */
+		if (num == 0) {
+			if (end != EXT_MAX_BLOCK) {
+				/*
+				 * For hole punching, we need to scoot all the
+				 * extents up when an extent is removed so that
+				 * we dont have blank extents in the middle
+				 */
+				memmove(ex, ex+1, (EXT_LAST_EXTENT(eh) - ex) *
+					sizeof(struct ext4_extent));
+
+				/* Now get rid of the one at the end */
+				memset(EXT_LAST_EXTENT(eh), 0,
+					sizeof(struct ext4_extent));
+			}
+			le16_add_cpu(&eh->eh_entries, -1);
+		}
+
 		ext_debug("new extent: %u:%u:%llu\n", block, num,
 				ext4_ext_pblock(ex));
 		ex--;
@@ -2425,7 +2530,8 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 -static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
+static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
+				ext4_lblk_t end)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
@@ -2464,7 +2570,8 @@ again:
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
 			/* this is leaf block */
-			err = ext4_ext_rm_leaf(handle, inode, path, start);
+			err = ext4_ext_rm_leaf(handle, inode, path,
+					start, end);
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
 			path[i].p_bh = NULL;
@@ -3631,11 +3738,24 @@ out2:
 	return err ? err : allocated;
 }
 -void ext4_ext_truncate(struct inode *inode)
+/*
+ * ext4_ext_release_blocks
+ *
+ * Releases the blocks in a file starting at block "start"
+ * and ending at block "end".  Pass EXT_MAX_BLOCK
+ * for "end" to just truncate the file to the
+ * "start" block
+ *
+ * @inode: The inode of the file to release blocks from
+ * @start: The starting block of the hole
+ * @end:  The ending block of the hole
+ *
+ */
+static void ext4_ext_release_blocks(struct inode *inode, ext4_lblk_t start,
+				ext4_lblk_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
-	ext4_lblk_t last_block;
 	handle_t *handle;
 	int err = 0;
 @@ -3674,9 +3794,7 @@ void ext4_ext_truncate(struct inode *inode)
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	ext4_mark_inode_dirty(handle, inode);
 -	last_block = (inode->i_size + sb->s_blocksize - 1)
-			>> EXT4_BLOCK_SIZE_BITS(sb);
-	err = ext4_ext_remove_space(inode, last_block);
+	err = ext4_ext_remove_space(inode, start, end);
  	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
@@ -3702,6 +3820,24 @@ out_stop:
 }
  /*
+ * ext4_ext_truncate
+ *
+ * Truncate the file to the current i_size
+ *
+ * @inode: The file inode
+ */
+void ext4_ext_truncate(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	ext4_lblk_t last_block;
+
+	last_block = (inode->i_size + sb->s_blocksize - 1)
+			>> EXT4_BLOCK_SIZE_BITS(sb);
+
+	ext4_ext_release_blocks(inode, last_block, EXT_MAX_BLOCK);
+
+}
+/*
  * ext4_ext_convert_blocks_uninit()
  * Converts a range of blocks to uninitialized
  *
-- 
1.7.1


