From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.27.y 05/11] ext4: Retry block reservation
Date: Mon, 15 Mar 2010 20:25:59 -0400
Message-ID: <1268699165-17461-6-git-send-email-tytso@mit.edu>
References: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38669 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937236Ab0CPA0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Mar 2010 20:26:13 -0400
In-Reply-To: <1268699165-17461-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 030ba6bc67b4f2bc5cd174f57785a1745c929abe upstream.

During block reservation if we don't have enough blocks left, retry
block reservation with smaller block counts.  This makes sure we try
fallocate and DIO with smaller request size and don't fail early.  The
delayed allocation reservation cannot try with smaller block count. So
retry block reservation to handle temporary disk full conditions.  Also
print free blocks details if we fail block allocation during writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    8 +++++++-
 fs/ext4/inode.c   |   14 +++++++++++---
 fs/ext4/mballoc.c |    7 ++++++-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6b6b560..532f8cc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1907,10 +1907,16 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
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
index c454fef..e82b895 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1549,6 +1549,7 @@ static int ext4_journalled_write_end(struct file *file,
 
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
+	int retries = 0;
        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
        unsigned long md_needed, mdblocks, total = 0;
 
@@ -1557,6 +1558,7 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
+repeat:
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
 	mdblocks = ext4_calc_metadata_amount(inode, total);
@@ -1567,6 +1569,10 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+			yield();
+			goto repeat;
+		}
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
@@ -1864,20 +1870,18 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
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
@@ -1910,6 +1914,10 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
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
index 27bbff9..453589d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4651,7 +4651,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
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
1.6.6.1.1.g974db.dirty

