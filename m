From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2] ext4: Retry block reservation
Date: Mon, 25 Aug 2008 16:50:30 +0530
Message-ID: <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41470 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753600AbYHYLUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 07:20:42 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7PBKdwn004255
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:39 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PBKbOH1585238
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:38 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7PBKaXe014087
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:37 +0530
In-Reply-To: <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During block reservation if we don't have enough
blocks left, retry block reservation with smaller
block count. This make sure we try fallocate
and DIO with smaller request size and don't fail early.
The delayed allocation reservation cannot try with smaller
block count. So retry block reservation to handle temporary
disk full conditions.  Also print free blocks details if we
fail block allocation during writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |    8 +++++++-
 fs/ext4/inode.c   |   33 ++++++++++++++++++++++++++++++---
 fs/ext4/mballoc.c |    7 ++++++-
 3 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4a53541..b7d1347 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1760,10 +1760,16 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		if (ext4_claim_free_blocks(sbi, *count)) {
+		while (*count && ext4_claim_free_blocks(sbi, *count)) {
+			/* let others to free the space */
+			yield();
+			*count = *count >> 1;
+		}
+		if (!*count) {
 			*errp = -ENOSPC;
 			return 0;	/*return with ENOSPC error */
 		}
+		num = *count;
 	}
 	/*
 	 * Check quota for allocation of this block.
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d965a05..72a4a71 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1521,6 +1521,7 @@ static int ext4_journalled_write_end(struct file *file,
 
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
+	int retries = 0;
        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
        unsigned long md_needed, mdblocks, total = 0;
 
@@ -1529,6 +1530,7 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
+repeat:
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
 	mdblocks = ext4_calc_metadata_amount(inode, total);
@@ -1539,6 +1541,10 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			yield();
+			goto repeat;
+		}
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
@@ -1813,6 +1819,26 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
 	return;
 }
 
+static void ext4_print_free_blocks(struct super_block *sb)
+{
+#ifdef EXT4FS_DEBUG
+	ext4_group_t i;
+	struct ext4_group_desc *gdp;
+	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
+	printk(KERN_DEBUG "Free blocks details\n");
+	for (i = 0; i < ngroups; i++) {
+		gdp = ext4_get_group_desc(sb, i, NULL);
+		if (!gdp)
+			continue;
+		printk(KERN_DEBUG "Free blocks in group %lu is %d\n",
+				i, le16_to_cpu(gdp->bg_free_blocks_count));
+	}
+#endif
+	printk(KERN_CRIT "Total free blocks count %lld\n",
+			ext4_count_free_blocks(sb));
+	return;
+}
+
 /*
  * mpage_da_map_blocks - go through given space
  *
@@ -1825,20 +1851,18 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
 static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
 	int err = 0;
+	struct buffer_head new;
 	struct buffer_head *lbh = &mpd->lbh;
 	sector_t next = lbh->b_blocknr;
-	struct buffer_head new;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if (buffer_mapped(lbh) && !buffer_delay(lbh))
 		return 0;
-
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
 	new.b_size = lbh->b_size;
-
 	/*
 	 * If we didn't accumulate anything
 	 * to write simply return
@@ -1871,6 +1895,9 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 				  lbh->b_size >> mpd->inode->i_blkbits, err);
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
+		if (err == -ENOSPC) {
+			ext4_print_free_blocks(mpd->inode->i_sb);
+		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
 				lbh->b_size >> mpd->inode->i_blkbits);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4404b46..419009f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4397,7 +4397,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		if (ext4_claim_free_blocks(sbi, ar->len)) {
+		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
+			/* let others to free the space */
+			yield();
+			ar->len = ar->len >> 1;
+		}
+		if (!ar->len) {
 			*errp = -ENOSPC;
 			return 0;
 		}
-- 
1.6.0.1.90.g27a6e

