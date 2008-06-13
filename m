From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix the oldallocator block reservation
	accounting with delalloc.
Date: Fri, 13 Jun 2008 08:40:14 +0530
Message-ID: <20080613031014.GB12892@skywalker>
References: <1213290593-31424-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1213303915.3698.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56513 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbYFMDLm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 23:11:42 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5D3B3UI013653
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:11:03 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5D3A4hK2224188
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:10:05 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5D3AN0t016108
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:10:24 +1000
Content-Disposition: inline
In-Reply-To: <1213303915.3698.3.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2008 at 01:51:55PM -0700, Mingming Cao wrote:
> 
> The changes looks correct, but I think it would be cleaner to put the
> changes about metadata allocation related accounting for delayed
> allocation  to ext4_new_meta_blocks() , so it doesn't need to check the
> EXT4_META_BLOCK flags in common code do_blk_alloc all the time.
> 
> 

updated patch below.

ext4: Fix the oldallocator block reservation accounting with delalloc.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Update old block allocator to not decrement s_freeblocks_counter
for allocated blocks with delalloc. Also account for the
actual meta-data allocated. We should not check for freespace
again in allocator with delalloc since we already did block
reservation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/balloc.c |   57 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 25 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4331577..69a3c2e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1706,7 +1706,12 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	sbi = EXT4_SB(sb);
-	*count = ext4_has_free_blocks(sbi, *count);
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag) {
+		/*
+		 * With delalloc we already reserved the blocks
+		 */
+		*count = ext4_has_free_blocks(sbi, *count);
+	}
 	if (*count == 0) {
 		*errp = -ENOSPC;
 		return 0;	/*return with ENOSPC error */
@@ -1907,7 +1912,8 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
+		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
@@ -1990,52 +1996,53 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
-	/*
-	 * Account for the allocated meta blocks
-	 */
-	if (!(*errp) && (flags & EXT4_META_BLOCK)) {
-		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-	}
 	return ret;
 }
 
 /*
- * ext4_new_meta_block() -- allocate block for meta data (indexing) blocks
+ * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
  *
  * @handle:             handle to this transaction
  * @inode:              file inode
  * @goal:               given target block(filesystem wide)
+ * @count:		total number of blocks need
  * @errp:               error code
  *
- * Return allocated block number on success
+ * Return 1st allocated block numberon success, *count stores total account
+ * error stores in errp pointer
  */
-ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, int *errp)
+ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
-	unsigned long count = 1;
-	return do_blk_alloc(handle, inode, 0, goal,
-			&count, errp, EXT4_META_BLOCK);
+	ext4_fsblk_t ret;
+	ret = do_blk_alloc(handle, inode, 0, goal,
+				count, errp, EXT4_META_BLOCK);
+	/*
+	 * Account for the allocated meta blocks
+	 */
+	if (!(*errp)) {
+		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+		EXT4_I(inode)->i_allocated_meta_blocks += *count;
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	}
+	return ret;
 }
 
 /*
- * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
+ * ext4_new_meta_block() -- allocate block for meta data (indexing) blocks
  *
  * @handle:             handle to this transaction
  * @inode:              file inode
  * @goal:               given target block(filesystem wide)
- * @count:		total number of blocks need
  * @errp:               error code
  *
- * Return 1st allocated block numberon success, *count stores total account
- * error stores in errp pointer
+ * Return allocated block number on success
  */
-ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, int *errp)
 {
-	return do_blk_alloc(handle, inode, 0, goal,
-			count, errp, EXT4_META_BLOCK);
+	unsigned long count = 1;
+	return ext4_new_meta_blocks(handle, inode, goal, &count, errp);
 }
 
 /*
