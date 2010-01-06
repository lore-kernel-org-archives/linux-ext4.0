From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ext4: Fix quota accounting error with fallocate
Date: Thu,  7 Jan 2010 00:52:40 +0530
Message-ID: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58520 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0AFTWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 14:22:48 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp06.in.ibm.com (8.14.3/8.13.1) with ESMTP id o06JMkOe011778
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 00:52:46 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o06JMkZH3223768
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 00:52:46 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o06JMj8H002127
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 06:22:46 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we fallocate a region of the file which we had recently written,
and which is still in the page cache marked as delayed allocated blocks
we need to make sure we don't do the quota update on writepage path.
This is because the needed quota updated would have already be done
by fallocate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/extents.c |   21 +++++++++++++++++++++
 fs/ext4/inode.c   |   35 +++++++++++++++++++++++------------
 3 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af7b626..b98de17 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1443,6 +1443,8 @@ extern int ext4_block_truncate_page(handle_t *handle,
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
+extern void ext4_da_update_reserve_space(struct inode *inode,
+					int used, int quota_claim);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7d7b74e..3b6ff72 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3132,7 +3132,19 @@ out:
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
@@ -3368,9 +3380,18 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
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
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..3d1a1d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1053,7 +1053,8 @@ static int ext4_calc_metadata_amount(struct inode *inode, sector_t lblock)
  * Called with i_data_sem down, which is important since we can call
  * ext4_discard_preallocations() from here.
  */
-static void ext4_da_update_reserve_space(struct inode *inode, int used)
+void ext4_da_update_reserve_space(struct inode *inode,
+					int used, int quota_claim)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -1090,9 +1091,17 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
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
+		 * This is a request to cancel the reservation. So just
+		 * update the resevation and cancel the quota reservation
+		 */
+		vfs_dq_release_reservation_block(inode, mdb_free + used);
+	}
 
 	/*
 	 * If we have done all the pending block allocations and if
@@ -1292,18 +1301,20 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
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
