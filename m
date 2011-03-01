From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 3/5] Ext4 Punch Hole Support: Punch out extents
Date: Mon, 28 Feb 2011 20:08:47 -0700
Message-ID: <4D6C633F.4000608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35076 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab1CADIq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 22:08:46 -0500
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p212iTj2028094
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 21:44:29 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 165686E8035
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:46 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2138j9o211730
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:45 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2138jfn007644
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:45 -0500
Received: from [127.0.0.1] (sig-9-48-100-125.mts.ibm.com [9.48.100.125])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2138ijX007619
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch modifes the truncate routines to support hole punching
Below is a brief summary of the pacthes changes:

- Added new function "ext_ext4_rm_leaf_punch_hole".
        This routine is very similar to ext_ext4_rm_leaf except that
        it punches a hole in a leaf instead of just removing the tail
        or removing the entire leaf all together

- Implemented the "remove head" case in the ext_remove_blocks routine
        This routine is used by ext_ext4_rm_leaf to remove the tail
        of an extent during a truncate.  The new ext_ext4_rm_leaf_punch_hole
        routine will now also use it to remove the head of an extent in the
        case that the hole covers a region of blocks at the beginning
        of an extent.

- Added "stop" param to ext4_ext_remove_space routine
        This function has been modified to accept a stop parameter.  If stop
        is not EXT_MAX_BLOCK, the routine will call ext_ext4_rm_leaf_punch_hole
        instead of ext_ext4_rm_leaf.

- Added new "ext4_ext_release_blocks" routine
        This routine is basically the ext4_ext_truncate routine, but
        modified to accept a "stop" param in addition to "start".  The existing
        ext4_ext_truncate routine has now become a wrapper to this
        function.  The stop parameter just passed through to ext4_ext_remove_space

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 ab2e42e... efbc3ef... M	fs/ext4/extents.c
 fs/ext4/extents.c |  265 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 256 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ab2e42e..efbc3ef 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2159,8 +2159,16 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, 0, start, num, flags);
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
@@ -2401,6 +2409,214 @@ out:
 }
 
 /*
+ * ext4_ext_rm_leaf_punch_hole() Removes the extents associated with the 
+ * blocks appearing between "start" and "stop", and splits the extents
+ * if "start" and "stop" appear in the same extent
+ */
+static int
+ext4_ext_rm_leaf_punch_hole(handle_t *handle, struct inode *inode,
+		struct ext4_ext_path *path, ext4_lblk_t start, ext4_lblk_t stop)
+{
+	int err = 0, correct_index = 0;
+	int depth = ext_depth(inode), credits;
+	struct ext4_extent_header *eh;
+	ext4_lblk_t a, b, block;
+	unsigned int num;
+	ext4_lblk_t ex_ee_block;
+	unsigned short ex_ee_len;
+	unsigned int uninitialized = 0;
+	struct ext4_extent *ex, *i_ex;
+
+	/* the header must be checked already in ext4_ext_remove_space() */
+	ext_debug("truncate since %u in leaf\n", start);
+	if (!path[depth].p_hdr)
+		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
+
+	eh = path[depth].p_hdr;
+	if (unlikely(path[depth].p_hdr == NULL)) {
+		EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
+		return -EIO;
+	}
+
+	/* find where to start removing */
+	ex = EXT_LAST_EXTENT(eh);
+
+	ex_ee_block = le32_to_cpu(ex->ee_block);
+	ex_ee_len = ext4_ext_get_actual_len(ex);
+
+	while (ex >= EXT_FIRST_EXTENT(eh) &&
+			ex_ee_block + ex_ee_len > start ) {
+		if (ext4_ext_is_uninitialized(ex))
+			uninitialized = 1;
+		else
+			uninitialized = 0;
+
+		ext_debug("remove ext %u:[%d]%d\n", ex_ee_block,
+			 uninitialized, ex_ee_len);
+		path[depth].p_ext = ex;
+
+		a = ex_ee_block > start ? ex_ee_block : start;
+		b = ex_ee_block+ex_ee_len - 1 < stop ? ex_ee_block+ex_ee_len - 1 : stop;
+
+		ext_debug("  border %u:%u\n", a, b);
+
+		/* If this extent is beyond the end of the hole, skip it  */
+		if(stop <= ex_ee_block){
+			ex--;
+			ex_ee_block = le32_to_cpu(ex->ee_block);
+			ex_ee_len = ext4_ext_get_actual_len(ex);
+			continue;
+		}
+		else if (a != ex_ee_block && b != ex_ee_block + ex_ee_len - 1) {
+			/*
+			 * If this is a truncate, then this condition should 
+			 * never happen becase at least one of the end points
+			 * needs to be on the edge of the extent.
+			 */
+			if(stop == EXT_MAX_BLOCK){
+				ext_debug("  bad truncate %u:%u\n", start, stop);
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
+				err = ext4_split_extents(handle,inode, b,path,0);
+				if(err)
+					goto out;
+
+				ex_ee_len = ext4_ext_get_actual_len(ex);
+
+				b = ex_ee_block+ex_ee_len - 1 < stop ? ex_ee_block+ex_ee_len - 1 : stop;
+
+				/* Then remove tail of this extent */
+				block = ex_ee_block;
+				num = a - block;
+			}
+		}
+		else if (a != ex_ee_block) {
+			/* remove tail of the extent */
+			block = ex_ee_block;
+			num = a - block;
+		}
+		else if (b != ex_ee_block + ex_ee_len - 1) {
+			/* remove head of the extent */
+			block = b;
+			num =  ex_ee_block+ex_ee_len - b;
+
+			/* If this is a truncate, this condition should never happen */
+			if(stop == EXT_MAX_BLOCK){
+				err = -EIO;
+				goto out;
+			}
+		}
+		else {
+			/* remove whole extent: excellent! */
+			block = ex_ee_block;
+			num = 0;
+			if (a != ex_ee_block){
+				err = -EIO;
+				goto out;
+			}
+
+			if (b != ex_ee_block + ex_ee_len - 1){
+				err = -EIO;
+				goto out;
+			}
+		}
+
+		/*
+		 * 3 for leaf, sb, and inode plus 2 (bmap and group
+		 * descriptor) for each block group; assume two block
+		 * groups plus ex_ee_len/blocks_per_block_group for
+		 * the worst case
+		 */
+		credits = 7 + 2*(ex_ee_len/EXT4_BLOCKS_PER_GROUP(inode->i_sb));
+		if (ex == EXT_FIRST_EXTENT(eh)) {
+			correct_index = 1;
+			credits += (ext_depth(inode)) + 1;
+		}
+		credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
+		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
+		if (err)
+			goto out;
+
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (err)
+			goto out;
+		
+		err = ext4_remove_blocks(handle, inode, ex, a, b);
+		if (err)
+			goto out;
+
+		ex->ee_block = cpu_to_le32(block);
+		ex->ee_len = cpu_to_le16(num);
+		
+		/* 
+		 * If this was a head removal, then we need to update 
+		 * the physical block since it is now at a different  
+		 * location   
+		 */ 
+		if (block != ex_ee_block)
+			ext4_ext_store_pblock(ex, ext4_ext_pblock(ex)+(b-a) );
+
+		/*
+		 * Do not mark uninitialized if all the blocks in the
+		 * extent have been removed.
+		 */
+		if (uninitialized && num)
+			ext4_ext_mark_uninitialized(ex);
+
+		err = ext4_ext_dirty(handle, inode, path + depth);
+		if (err)
+			goto out;
+
+		ext_debug("new extent: %u:%u:%llu\n", block, num,
+				ext4_ext_pblock(ex));
+
+		if (num == 0) {
+
+			/* 
+			 * For hole punching, we need to scoot all the   
+			 * extents up so that we dont have blank extents 
+			 * in the middle 
+			 */
+			for(i_ex = ex; i_ex < EXT_LAST_EXTENT(eh); i_ex++){
+				memcpy(i_ex, i_ex+1, sizeof(struct ext4_extent));
+			}
+
+			/* now get rid of the extent at the end  */
+			memset(i_ex, 0, sizeof(struct ext4_extent));
+				
+			le16_add_cpu(&eh->eh_entries, -1);
+		}
+
+		ex--;
+		ex_ee_block = le32_to_cpu(ex->ee_block);
+		ex_ee_len = ext4_ext_get_actual_len(ex);
+
+	}
+
+	if (correct_index && eh->eh_entries)
+		err = ext4_ext_correct_indexes(handle, inode, path);
+
+	/* 
+	 * If this leaf is free, then we should
+	 * remove it from index block above 
+	 */
+	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
+		err = ext4_ext_rm_idx(handle, inode, path + depth);
+
+out:
+	return err;
+}
+
+/*
  * ext4_ext_more_to_rm:
  * returns 1 if current index has to be freed (even partial)
  */
@@ -2421,7 +2637,7 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
-static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
+static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start, ext4_lblk_t stop)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
@@ -2460,7 +2676,10 @@ again:
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
 			/* this is leaf block */
-			err = ext4_ext_rm_leaf(handle, inode, path, start);
+			if(stop == EXT_MAX_BLOCK)
+				err = ext4_ext_rm_leaf(handle, inode, path, start);
+			else
+				err = ext4_ext_rm_leaf_punch_hole(handle, inode, path, start, stop);
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
 			path[i].p_bh = NULL;
@@ -3627,11 +3846,23 @@ out2:
 	return err ? err : allocated;
 }
 
-void ext4_ext_truncate(struct inode *inode)
+/*
+ * ext4_ext_release_blocks
+ *
+ * Releases the blocks in a file starting at block "start"
+ * and ending at block "stop".  Pass EXT_MAX_BLOCK
+ * for "stop" to just truncate the file to the
+ * "start" block
+ *
+ * @inode: The inode of the file to release blocks from 
+ * @start: The starting block of the hole
+ * @stop:  The ending block of the hole
+ *
+ */  
+static void ext4_ext_release_blocks(struct inode *inode, ext4_lblk_t start, ext4_lblk_t stop)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
-	ext4_lblk_t last_block;
 	handle_t *handle;
 	int err = 0;
 
@@ -3670,9 +3901,7 @@ void ext4_ext_truncate(struct inode *inode)
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	ext4_mark_inode_dirty(handle, inode);
 
-	last_block = (inode->i_size + sb->s_blocksize - 1)
-			>> EXT4_BLOCK_SIZE_BITS(sb);
-	err = ext4_ext_remove_space(inode, last_block);
+	err = ext4_ext_remove_space(inode, start, stop);
 
 	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
@@ -3698,6 +3927,24 @@ out_stop:
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


