From: marcus.husar@rose.uni-heidelberg.de
Subject: [PATCH 4/4][2.6.32-stable] ext4: Fix quota accounting error with
	fallocate
Date: Sat, 06 Feb 2010 17:41:32 +0100
Message-ID: <20100206174132.f7lkaprm144wsgwc@wwwmail.urz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:46476 "EHLO
	relay.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0BFRUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Feb 2010 12:20:25 -0500
Received: from ix.urz.uni-heidelberg.de (cyrus-portal.urz.uni-heidelberg.de [129.206.100.176])
	by relay.uni-heidelberg.de (8.14.1/8.14.1) with ESMTP id o16GfXcY027106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:41:33 +0100
Received: from wwwmail.urz.uni-heidelberg.de (wwwmail.urz.uni-heidelberg.de [129.206.100.145])
	by ix.urz.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16GfWDi031906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:41:32 +0100
Received: from wwwmail.urz.uni-heidelberg.de (localhost.localdomain [127.0.0.1])
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1) with ESMTP id o16GfWc1020522
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:41:32 +0100
Received: (from apache@localhost)
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1/Submit) id o16GfWtD020521
	for linux-ext4@vger.kernel.org; Sat, 6 Feb 2010 17:41:32 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a backport of 5f634d064c709ea02c3cdaa850a08323a4a4bf28 that
applies cleanly on top of patch 3 of this patchset.

ext4: Fix quota accounting error with fallocate

When we fallocate a region of the file which we had recently written,
and which is still in the page cache marked as delayed allocated blocks
we need to make sure we don't do the quota update on writepage path.
This is because the needed quota updated would have already be done
by fallocate.

Signed-off-by: Marcus Husar <marcus.husar@rose.uni-heidelberg.de>
---
     ext4.h    |    2 ++
     extents.c |   21 +++++++++++++++++++++
     inode.c   |   44 +++++++++++++++++++++++++++++++-------------
     3 files changed, 54 insertions(+), 13 deletions(-)

diff -uprN a/fs/ext4/ext4.h b/fs/ext4/ext4.h
--- a/fs/ext4/ext4.h	2010-02-05 10:05:39.088239000 +0100
+++ b/fs/ext4/ext4.h	2010-02-06 12:11:56.600219566 +0100
@@ -1440,6 +1440,8 @@ extern int ext4_block_truncate_page(hand
     extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct
vm_fault *vmf);
     extern qsize_t *ext4_get_reserved_space(struct inode *inode);
     extern int flush_aio_dio_completed_IO(struct inode *inode);
+extern void ext4_da_update_reserve_space(struct inode *inode,
+					int used, int quota_claim);
     /* ioctl.c */
     extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
     extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff -uprN a/fs/ext4/extents.c b/fs/ext4/extents.c
--- a/fs/ext4/extents.c	2010-02-06 11:43:34.636221000 +0100
+++ b/fs/ext4/extents.c	2010-02-06 12:16:51.620226519 +0100
@@ -3123,7 +3123,19 @@ out:
     		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
     						newblock + max_blocks,
     						allocated - max_blocks);
+		allocated = max_blocks;
     	}
+
+	/*
+	 * If we have done fallocate with the offset that is already
+	 * delayed allocated, we would have block reservation
+	 * and quota reservation done in the delayed write path.
+	 * But fallocate would have already updated quota and block
+	 * count for this offset. So cancel these reservation
+	 */
+	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+		ext4_da_update_reserve_space(inode, allocated, 0);
+
     map_out:
     	set_buffer_mapped(bh_result);
     out1:
@@ -3353,9 +3365,18 @@ int ext4_ext_get_blocks(handle_t *handle
     	/* previous routine could use block we allocated */
     	newblock = ext_pblock(&newex);
     	allocated = ext4_ext_get_actual_len(&newex);
+	if (allocated > max_blocks)
+		allocated = max_blocks;
     	set_buffer_new(bh_result);

     	/*
+	 * Update reserved blocks/metadata blocks after successful
+	 * block allocation which had been deferred till now.
+	 */
+	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+		ext4_da_update_reserve_space(inode, allocated, 1);
+
+	/*
     	 * Cache the extent and update transaction to commit on fdatasync only
     	 * when it is _not_ an uninitialized extent.
     	 */
diff -uprN a/fs/ext4/inode.c b/fs/ext4/inode.c
--- a/fs/ext4/inode.c	2010-02-06 11:45:59.188218000 +0100
+++ b/fs/ext4/inode.c	2010-02-06 12:25:26.736219057 +0100
@@ -1095,11 +1095,12 @@ static int ext4_calc_metadata_amount(str
      * Called with i_data_sem down, which is important since we can call
      * ext4_discard_preallocations() from here.
      */
-static void ext4_da_update_reserve_space(struct inode *inode, int used)
+void ext4_da_update_reserve_space(struct inode *inode,
+				int used, int quota_claim)
     {
     	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
     	struct ext4_inode_info *ei = EXT4_I(inode);
-	int mdb_free = 0;
+	int mdb_free = 0, allocated_meta_blocks = 0;

     	spin_lock(&ei->i_block_reservation_lock);
     	if (unlikely(used > ei->i_reserved_data_blocks)) {
@@ -1115,6 +1116,7 @@ static void ext4_da_update_reserve_space
     	ei->i_reserved_data_blocks -= used;
     	used += ei->i_allocated_meta_blocks;
     	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
+	allocated_meta_blocks = ei->i_allocated_meta_blocks;
     	ei->i_allocated_meta_blocks = 0;
     	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used);

@@ -1132,9 +1134,23 @@ static void ext4_da_update_reserve_space
     	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);

     	/* Update quota subsystem */
-	vfs_dq_claim_block(inode, used);
-	if (mdb_free)
-		vfs_dq_release_reservation_block(inode, mdb_free);
+	if (quota_claim) {
+		vfs_dq_claim_block(inode, used);
+		if (mdb_free)
+			vfs_dq_release_reservation_block(inode, mdb_free);
+	} else {
+		/*
+		 * We did fallocate with an offset that is already delayed
+		 * allocated. So on delayed allocated writeback we should
+		 * not update the quota for allocated blocks. But then
+		 * converting an fallocate region to initialized region would
+		 * have caused a metadata allocation. So claim quota for
+		 * that
+		 */
+		if (allocated_meta_blocks)
+			vfs_dq_claim_block(inode, allocated_meta_blocks);
+		vfs_dq_release_reservation_block(inode, mdb_free + used);
+	}

     	/*
     	 * If we have done all the pending block allocations and if
@@ -1334,18 +1350,20 @@ int ext4_get_blocks(handle_t *handle, st
     			 */
     			EXT4_I(inode)->i_state &= ~EXT4_STATE_EXT_MIGRATE;
     		}
-	}

+		/*
+		 * Update reserved blocks/metadata blocks after successful
+		 * block allocation which had been deferred till now. We don't
+		 * support fallocate for non extent files. So we can update
+		 * reserve space here.
+		 */
+		if ((retval > 0) &&
+			(flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
+			ext4_da_update_reserve_space(inode, retval, 1);
+	}
     	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
     		EXT4_I(inode)->i_delalloc_reserved_flag = 0;

-	/*
-	 * Update reserved blocks/metadata blocks after successful
-	 * block allocation which had been deferred till now.
-	 */
-	if ((retval > 0) && (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
-		ext4_da_update_reserve_space(inode, retval);
