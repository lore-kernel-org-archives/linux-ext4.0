From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix the oldallocator block reservation accounting with delalloc.
Date: Thu, 12 Jun 2008 22:39:53 +0530
Message-ID: <1213290593-31424-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33788 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYFLRKC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 13:10:02 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5CH96Pb026625
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 03:09:06 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CH9xWh272852
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 03:09:59 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CH9wMV016722
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 03:09:58 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update old block allocator to not decrement s_freeblocks_counter
for allocated blocks with delalloc. Also account for the
actual meta-data allocated. We should not check for freespace
again in allocator with delalloc since we already did block
reservation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4331577..eca8c0e 100644
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
@@ -1957,7 +1963,8 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t ret;
 
 	if (!test_opt(inode->i_sb, MBALLOC)) {
-		return ext4_old_new_blocks(handle, inode, goal, count, errp);
+		ret = ext4_old_new_blocks(handle, inode, goal, count, errp);
+		goto out;
 	}
 
 	memset(&ar, 0, sizeof(ar));
@@ -1990,12 +1997,13 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
+out:
 	/*
 	 * Account for the allocated meta blocks
 	 */
 	if (!(*errp) && (flags & EXT4_META_BLOCK)) {
 		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
+		EXT4_I(inode)->i_allocated_meta_blocks += *count;
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	}
 	return ret;
-- 
1.5.6.rc2.15.g457bb.dirty

