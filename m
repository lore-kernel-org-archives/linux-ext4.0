From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patch for 2.6.25 queue
Date: Sat, 26 Jan 2008 17:08:49 +0530
Message-ID: <20080126113849.GA18602@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Y Tso <theotso@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:51547 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYAZLiy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 06:38:54 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m0QBcqt4007556
	for <linux-ext4@vger.kernel.org>; Sat, 26 Jan 2008 17:08:52 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0QBcpd91024154
	for <linux-ext4@vger.kernel.org>; Sat, 26 Jan 2008 17:08:51 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m0QBctV4014531
	for <linux-ext4@vger.kernel.org>; Sat, 26 Jan 2008 11:38:55 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This diff contain mballoc fixes and update for ext3-4 migrate patch.

Testing:
ext3 to ext4 migration.

I will be putting the patch queue for abat test now.

-aneesh

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ebcd25e..99d16f5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -62,7 +62,7 @@ static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
  * idx_pblock:
  * combine low and high parts of a leaf physical block number into ext4_fsblk_t
  */
-static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
+ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a60672c..9de0cdf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2723,7 +2723,7 @@ int ext4_mb_release(struct super_block *sb)
 #endif
 			ext4_lock_group(sb, i);
 			ext4_mb_cleanup_pa(grinfo);
-			ext4_lock_group(sb, i);
+			ext4_unlock_group(sb, i);
 			kfree(grinfo);
 		}
 		num_meta_group_infos = (sbi->s_groups_count +
@@ -4452,7 +4452,6 @@ do_more:
 		overflow = bit + count - EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
 	}
-	put_bh(bitmap_bh);
 	bitmap_bh = read_block_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 70a4d9c..3ebc233 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -342,16 +342,6 @@ err_out:
 	return retval;
 }
 
-/* Will go away */
-static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
-{
-	ext4_fsblk_t block;
-
-	block = le32_to_cpu(ix->ei_leaf_lo);
-	block |= ((ext4_fsblk_t) le16_to_cpu(ix->ei_leaf_hi) << 31) << 1;
-	return block;
-}
-
 static int free_ext_idx(handle_t *handle, struct inode *inode,
 					struct ext4_extent_idx *ix)
 {
@@ -366,9 +356,7 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 		return -EIO;
 
 	eh = (struct ext4_extent_header *)bh->b_data;
-	if (eh->eh_depth == 0)
-		ext4_free_blocks(handle, inode, block, 1, 1);
-	else {
+	if (eh->eh_depth != 0) {
 		ix = EXT_FIRST_INDEX(eh);
 		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
 			retval = free_ext_idx(handle, inode, ix);
@@ -377,6 +365,7 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 		}
 	}
 	put_bh(bh);
+	ext4_free_blocks(handle, inode, block, 1, 1);
 	return retval;
 }
 
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index f536b2f..697da4b 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -212,6 +212,7 @@ static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
 
+extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
