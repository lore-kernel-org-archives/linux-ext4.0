From: marcus.husar@rose.uni-heidelberg.de
Subject: [PATCH 3/4][2.6.32-stable] ext4: Prepare for backporting second
	quota patch
Date: Sat, 06 Feb 2010 17:40:21 +0100
Message-ID: <20100206174021.1ri1ofzhss8sgcw8@wwwmail.urz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:46476 "EHLO
	relay.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0BFRUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Feb 2010 12:20:22 -0500
Received: from ix.urz.uni-heidelberg.de (cyrus-portal.urz.uni-heidelberg.de [129.206.100.176])
	by relay.uni-heidelberg.de (8.14.1/8.14.1) with ESMTP id o16GeMl5025967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:40:22 +0100
Received: from wwwmail.urz.uni-heidelberg.de (wwwmail.urz.uni-heidelberg.de [129.206.100.145])
	by ix.urz.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16GeLuA031714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:40:21 +0100
Received: from wwwmail.urz.uni-heidelberg.de (localhost.localdomain [127.0.0.1])
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1) with ESMTP id o16GeL5Z020311
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:40:21 +0100
Received: (from apache@localhost)
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1/Submit) id o16GeLdm020310
	for linux-ext4@vger.kernel.org; Sat, 6 Feb 2010 17:40:21 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adapt unmap_underlying_metadata_blocks,
ext4_ext_handle_uninitialized_extents (extents.c) and
ext4_da_update_reserve_space (inode.c) from 2.6.33-rc3 to apply on top
of patch 2 of this patchset.

Signed-off-by: Marcus Husar <marcus.husar@rose.uni-heidelberg.de>
---
     extents.c |   38 +++++++++++++++++++++++++--------
     inode.c   |   59 ++++++++++++++++++++++++++++++----------------------
     2 files changed, 64 insertions(+), 33 deletions(-)

diff -uprN a/fs/ext4/extents.c b/fs/ext4/extents.c
--- a/fs/ext4/extents.c	2010-02-05 09:11:41.904755000 +0100
+++ b/fs/ext4/extents.c	2010-02-06 11:43:34.636221247 +0100
@@ -3029,21 +3029,29 @@ out:
     	return err;
     }

+static void unmap_underlying_metadata_blocks(struct block_device *bdev,
+					sector_t block, int count)
+{
+	int i;
+	for (i = 0; i < count; i++)
+                unmap_underlying_metadata(bdev, block + i);
+}
+
     static int
     ext4_ext_handle_uninitialized_extents(handle_t *handle, struct
inode *inode,
-			ext4_lblk_t iblock, unsigned int max_blocks,
-			struct ext4_ext_path *path, int flags,
-			unsigned int allocated, struct buffer_head *bh_result,
-			ext4_fsblk_t newblock)
+				ext4_lblk_t iblock, unsigned int max_blocks,
+				struct ext4_ext_path *path, int flags,
+				unsigned int allocated, struct buffer_head *bh_result,
+				ext4_fsblk_t newblock)
     {
     	int ret = 0;
     	int err = 0;
     	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;

     	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical"
-		  "block %llu, max_blocks %u, flags %d, allocated %u",
-		  inode->i_ino, (unsigned long long)iblock, max_blocks,
-		  flags, allocated);
+		"block %llu, max_blocks %u, flags %d, allocated %u",
+		inode->i_ino, (unsigned long long)iblock, max_blocks,
+		flags, allocated);
     	ext4_ext_show_leaf(inode, path);

     	/* DIO get_block() before submit the IO, split the extent */
@@ -3093,8 +3101,8 @@ ext4_ext_handle_uninitialized_extents(ha

     	/* buffered write, writepage time, convert*/
     	ret = ext4_ext_convert_to_initialized(handle, inode,
-						path, iblock,
-						max_blocks);
+					path, iblock,
+					max_blocks);
     	if (ret >= 0)
     		ext4_update_inode_fsync_trans(handle, inode, 1);
     out:
@@ -3104,6 +3112,18 @@ out:
     	} else
     		allocated = ret;
     	set_buffer_new(bh_result);
+	/*
+	 * if we allocated more blocks than requested
+	 * we need to make sure we unmap the extra block
+	 * allocated. The actual needed block will get
+	 * unmapped later when we find the buffer_head marked
+	 * new.
+	 */
+	if (allocated > max_blocks) {
+		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
+						newblock + max_blocks,
+						allocated - max_blocks);
+	}
     map_out:
     	set_buffer_mapped(bh_result);
     out1:
diff -uprN a/fs/ext4/inode.c b/fs/ext4/inode.c
--- a/fs/ext4/inode.c	2010-02-05 10:52:12.148240000 +0100
+++ b/fs/ext4/inode.c	2010-02-06 11:45:59.188218923 +0100
@@ -1091,38 +1091,48 @@ static int ext4_calc_metadata_amount(str
     	return ext4_indirect_calc_metadata_amount(inode, lblock);
     }

+/*
+ * Called with i_data_sem down, which is important since we can call
+ * ext4_discard_preallocations() from here.
+ */
     static void ext4_da_update_reserve_space(struct inode *inode, int used)
     {
     	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free;
-
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	/* recalculate the number of metablocks still need to be reserved */
-	total = EXT4_I(inode)->i_reserved_data_blocks - used;
-	mdb = ext4_calc_metadata_amount(inode, total);
-
-	/* figure out how many metablocks to release */
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int mdb_free = 0;

-	if (mdb_free) {
-		/* Account for allocated meta_blocks */
-		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+	spin_lock(&ei->i_block_reservation_lock);
+	if (unlikely(used > ei->i_reserved_data_blocks)) {
+		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used %d "
+			"with only %d reserved data blocks\n",
+			__func__, inode->i_ino, used,
+			ei->i_reserved_data_blocks);
+		WARN_ON(1);
+		used = ei->i_reserved_data_blocks;
+	}
+
+	/* Update per-inode reservations */
+	ei->i_reserved_data_blocks -= used;
+	used += ei->i_allocated_meta_blocks;
+	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
+	ei->i_allocated_meta_blocks = 0;
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used);

-		/* update fs dirty blocks counter */
+	if (ei->i_reserved_data_blocks == 0) {
+		/*
+		 * We can release all of the reserved metadata blocks
+		 * only when we have written all of the delayed
+		 * allocation blocks.
+		 */
+		mdb_free = ei->i_reserved_meta_blocks;
+		ei->i_reserved_meta_blocks = 0;
+		ei->i_da_metadata_calc_len = 0;
     		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
-		EXT4_I(inode)->i_allocated_meta_blocks = 0;
-		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
     	}
-
-	/* update per-inode reservations */
-	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= used;
     	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);

-	/*
-	 * free those over-booking quota for metadata blocks
-	 */
+	/* Update quota subsystem */
+	vfs_dq_claim_block(inode, used);
     	if (mdb_free)
     		vfs_dq_release_reservation_block(inode, mdb_free);

@@ -1131,7 +1141,8 @@ static void ext4_da_update_reserve_space
     	 * there aren't any writers on the inode, we can discard the
     	 * inode's preallocations.
     	 */
-	if (!total && (atomic_read(&inode->i_writecount) == 0))
+	if ((ei->i_reserved_data_blocks == 0) &&
+		(atomic_read(&inode->i_writecount) == 0))
     		ext4_discard_preallocations(inode);
     }





