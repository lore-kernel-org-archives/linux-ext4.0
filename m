From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/42] ext4: Retry block reservation
Date: Thu,  9 Oct 2008 00:05:25 -0400
Message-ID: <1223525160-9887-8-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54466 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757331AbYJIEGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:08 -0400
In-Reply-To: <1223525160-9887-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

During block reservation if we don't have enough blocks left, retry
block reservation with smaller block counts.  This makes sure we try
fallocate and DIO with smaller request size and don't fail early.  The
delayed allocation reservation cannot try with smaller block count. So
retry block reservation to handle temporary disk full conditions.  Also
print free blocks details if we fail block allocation during writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    8 +++++++-
 fs/ext4/inode.c   |   14 +++++++++++---
 fs/ext4/mballoc.c |    7 ++++++-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1707850..5790988 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1738,10 +1738,16 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
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
index b778d5a..eb9d449 100644
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
@@ -1825,20 +1831,18 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
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
@@ -1871,6 +1875,10 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 				  lbh->b_size >> mpd->inode->i_blkbits, err);
 		printk(KERN_EMERG "This should not happen.!! "
 					"Data will be lost\n");
+		if (err == -ENOSPC) {
+			printk(KERN_CRIT "Total free blocks count %lld\n",
+				ext4_count_free_blocks(mpd->inode->i_sb));
+		}
 		/* invlaidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
 				lbh->b_size >> mpd->inode->i_blkbits);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2c10b50..e4f30de 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4395,7 +4395,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
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
1.5.6.1.205.ge2c7.dirty

