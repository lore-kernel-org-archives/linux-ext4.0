From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext4: don't use quota reservation for speculative metadata
 blocks
Date: Tue, 23 Feb 2010 17:18:25 -0600
Message-ID: <4B846241.7050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0BWXS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2010 18:18:29 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1NNITDo006308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 18:18:29 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1NNIPXV025414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 18:18:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Because we can badly over-reserve metadata when we
calculate worst-case, it complicates things for quota, since
we must reserve and then claim later, retry on EDQUOT, etc.
Quota is also a generally smaller pool than fs free blocks,
so this over-reservation hurts more, and more often.

I'm of the opinion that it's not the worst thing to allow
metadata to push a user slightly over quota, if we can simplify
the code by doing so.

The patch below stops the speculative quota-charging for
worst-case metadata requirements, and just charges quota
when the blocks are allocated at writeout.  It also is
able to remove the try-again loop on EDQUOT.

In the longer run I'd like to even consider not charging
speculative metadata against the superblock counters, and use
a reserved space pool similar to what XFS does, but this change
could maybe stand on its own, too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 balloc.c |    5 +++--
 inode.c  |   63 +++++++++++++++++++++------------------------------------------
 2 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 22bc743..e11e5b0 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -604,13 +604,14 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	if (count)
 		*count = ar.len;
-
 	/*
-	 * Account for the allocated meta blocks
+	 * Account for the allocated meta blocks.  We will never
+	 * fail EDQUOT for metdata, but we do account for it.
 	 */
 	if (!(*errp) && EXT4_I(inode)->i_delalloc_reserved_flag) {
 		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
+		vfs_dq_alloc_block(inode, ar.len);
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	}
 	return ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e119524..6f0faf0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1058,7 +1058,6 @@ void ext4_da_update_reserve_space(struct inode *inode,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	int mdb_free = 0, allocated_meta_blocks = 0;
 
 	spin_lock(&ei->i_block_reservation_lock);
 	if (unlikely(used > ei->i_reserved_data_blocks)) {
@@ -1072,11 +1071,10 @@ void ext4_da_update_reserve_space(struct inode *inode,
 
 	/* Update per-inode reservations */
 	ei->i_reserved_data_blocks -= used;
-	used += ei->i_allocated_meta_blocks;
 	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
-	allocated_meta_blocks = ei->i_allocated_meta_blocks;
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+			   used + ei->i_allocated_meta_blocks);
 	ei->i_allocated_meta_blocks = 0;
-	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used);
 
 	if (ei->i_reserved_data_blocks == 0) {
 		/*
@@ -1084,30 +1082,23 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		mdb_free = ei->i_reserved_meta_blocks;
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+				   ei->i_reserved_meta_blocks);
 		ei->i_reserved_meta_blocks = 0;
 		ei->i_da_metadata_calc_len = 0;
-		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
 	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	/* Update quota subsystem */
+	/* Update quota subsystem for data blocks */
 	if (quota_claim) {
 		vfs_dq_claim_block(inode, used);
-		if (mdb_free)
-			vfs_dq_release_reservation_block(inode, mdb_free);
 	} else {
 		/*
 		 * We did fallocate with an offset that is already delayed
 		 * allocated. So on delayed allocated writeback we should
-		 * not update the quota for allocated blocks. But then
-		 * converting an fallocate region to initialized region would
-		 * have caused a metadata allocation. So claim quota for
-		 * that
+		 * not re-claim the quota for fallocated blocks.
 		 */
-		if (allocated_meta_blocks)
-			vfs_dq_claim_block(inode, allocated_meta_blocks);
-		vfs_dq_release_reservation_block(inode, mdb_free + used);
+		vfs_dq_release_reservation_block(inode, used);
 	}
 
 	/*
@@ -1835,7 +1826,7 @@ static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
 	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	unsigned long md_needed, md_reserved;
+	unsigned long md_needed;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1844,20 +1835,23 @@ static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
 	 */
 repeat:
 	spin_lock(&ei->i_block_reservation_lock);
-	md_reserved = ei->i_reserved_meta_blocks;
 	md_needed = ext4_calc_metadata_amount(inode, lblock);
 	spin_unlock(&ei->i_block_reservation_lock);
 
 	/*
-	 * Make quota reservation here to prevent quota overflow
-	 * later. Real quota accounting is done at pages writeout
-	 * time.
+	 * We will charge metadata quota at writeout time; this saves
+	 * us from metadata over-estimation, though we may go over by
+	 * a small amount in the end.  Here we just reserve for data.
 	 */
-	if (vfs_dq_reserve_block(inode, md_needed + 1))
+	if (vfs_dq_reserve_block(inode, 1))
 		return -EDQUOT;
 
+	/*
+	 * We do still charge estimated metadata to the sb though;
+	 * we cannot afford to run out of free blocks.
+	 */
 	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
-		vfs_dq_release_reservation_block(inode, md_needed + 1);
+		vfs_dq_release_reservation_block(inode, 1);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
@@ -1904,12 +1898,13 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
-		to_free += ei->i_reserved_meta_blocks;
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+				   ei->i_reserved_meta_blocks);
 		ei->i_reserved_meta_blocks = 0;
 		ei->i_da_metadata_calc_len = 0;
 	}
 
-	/* update fs dirty blocks counter */
+	/* update fs dirty data blocks counter */
 	percpu_counter_sub(&sbi->s_dirtyblocks_counter, to_free);
 
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
@@ -3038,7 +3033,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0, quota_retries = 0;
+	int ret, retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -3097,22 +3092,6 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
