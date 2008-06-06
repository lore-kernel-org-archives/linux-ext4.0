From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: delalloc  block reservation fix
Date: Fri,  6 Jun 2008 23:54:53 +0530
Message-ID: <1212776693-435-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212776693-435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34706 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbYFFSZy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:25:54 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m56IP7iK025810
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:07 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56IPY2f4636916
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:34 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56IPpDj031917
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:52 +1000
In-Reply-To: <1212776693-435-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

a) We need to decrement the meta data blocks that got allocated
from percpu s_freeblocks_counter

b) We need to protect the reservation block counter so that
reserve and release space doesn't race each other.

c) don't check for free space in ext4_mb_new_blocks with delalloc
We already reserved the space.

e) Don't release space for block allocation from fallocate space.
We don't  reserve space for them

f) clear the delay bit in ext4_da_get_block_write instead of __block_write_full_page
so that we clear the delay bit for every successfull block allocation. We may fail
while marking inode dirty in ext4_da_get_block_write after allocating block. So
it is better to clear the delay bit in ext4_da_get_block_write rather than
__block_write_full_page

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |    8 ++++++++
 fs/ext4/ext4_i.h  |    2 ++
 fs/ext4/inode.c   |   46 ++++++++++++++++++++++++++++++++--------------
 fs/ext4/mballoc.c |    7 ++++++-
 fs/ext4/super.c   |    2 ++
 fs/mpage.c        |   36 ++++++++++++++++++++++++++----------
 6 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 428e55f..9ccec61 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1973,6 +1973,14 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 		ar.flags = 0;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
+	/*
+	 * Account for the allocated meta blocks
+	 */
+	if (!(*errp) && (flags & EXT4_META_BLOCK)) {
+		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	}
 	return ret;
 }
 
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index fea6a5d..ef7409f 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -167,7 +167,9 @@ struct ext4_inode_info {
 	/* allocation reservation info for delalloc */
 	unsigned long i_reserved_data_blocks;
 	unsigned long i_reserved_meta_blocks;
+	unsigned long i_allocated_meta_blocks;
 	unsigned short i_delalloc_reserved_flag;
+	spinlock_t i_block_reservation_lock;
 };
 
 #endif	/* _EXT4_I */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c9cb360..5d1c830 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1426,11 +1426,12 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
        unsigned long md_needed, mdblocks, total = 0;
 
-       /*
-        * calculate the amount of metadata blocks to reserve
-	* in order to allocate nrblocks
-	* worse case is one extent per block
-	*/
+	/*
+	 * recalculate the amount of metadata blocks to reserve
+	 * in order to allocate nrblocks
+	 * worse case is one extent per block
+	 */
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
 	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
 	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
@@ -1438,42 +1439,51 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
-	if (ext4_has_free_blocks(sbi, total) < total)
+	if (ext4_has_free_blocks(sbi, total) < total) {
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return -ENOSPC;
+	}
 
 	/* reduce fs free blocks counter */
 	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
 
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
+	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
 
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	return 0;       /* success */
 }
 
 void ext4_da_release_space(struct inode *inode, int used, int to_free)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, release;
+	int total, mdb, mdb_free, release;
 
-	/* calculate the number of metablocks still need to be reserved */
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	/* recalculate the number of metablocks still need to be reserved */
 	total = EXT4_I(inode)->i_reserved_data_blocks - used - to_free;
 	mdb = ext4_ext_calc_metadata_amount(inode, total);
 
 	/* figure out how many metablocks to release */
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	mdb = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
+	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
-	release = to_free + mdb;
+	/* Account for allocated meta_blocks */
+	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+
+	release = to_free + mdb_free;
 
 	/* update fs free blocks counter for truncate case */
 	percpu_counter_add(&sbi->s_freeblocks_counter, release);
 
 	/* update per-inode reservations */
 	BUG_ON(used + to_free > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= used + to_free;
+	EXT4_I(inode)->i_reserved_data_blocks -= (used + to_free);
 
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	EXT4_I(inode)->i_reserved_meta_blocks -= mdb;
+	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
+	EXT4_I(inode)->i_allocated_meta_blocks = 0;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
@@ -1555,7 +1565,15 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 		bh_result->b_size = (ret << inode->i_blkbits);
 
 		/* release reserved-but-unused meta blocks */
-		ext4_da_release_space(inode, ret, 0);
+		if (buffer_delay(bh_result)) {
+			ext4_da_release_space(inode, ret, 0);
+			/*
+			 * clear the delay bit now that we allocated
+			 * blocks. If it is not a single block request
+			 * we clear the delay bit in mpage_put_bnr_to_bhs
+			 */
+			clear_buffer_delay(bh_result);
+		}
 
 		/*
 		 * Update on-disk size along with block allocation
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 334e585..ec44d52 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4049,7 +4049,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 					    &(ar->len), errp);
 		return block;
 	}
-	ar->len = ext4_has_free_blocks(sbi, ar->len);
+	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
+		/*
+		 * With delalloc we already reserved the blocks
+		 */
+		ar->len = ext4_has_free_blocks(sbi, ar->len);
+	}
 
 	if (ar->len == 0) {
 		*errp = -ENOSPC;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a990475..a33a0cf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -575,7 +575,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&ei->i_prealloc_lock);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
+	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
+	spin_lock_init(&(ei->i_block_reservation_lock));
 	return &ei->vfs_inode;
 }
 
diff --git a/fs/mpage.c b/fs/mpage.c
index c4376ec..b0db6bf 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -908,25 +908,41 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		new.b_blocknr = 0;
 		new.b_size = remain;
 		err = mpd->get_block(mpd->inode, next, &new, 1);
-		if (err) {
+		/*
+		 * we may have successfully allocated block. But
+		 * failed to mark inode dirty. If we have allocated
+		 * blocks update the buffer_head mappings
+		 */
+		if (buffer_new(&new)) {
 			/*
-			 * Rather than implement own error handling
-			 * here, we just leave remaining blocks
-			 * unallocated and try again with ->writepage()
+			 * buffer_head is only makred new if we have
+			 * a successfull block allocation
 			 */
-			break;
-		}
-		BUG_ON(new.b_size == 0);
-
-		if (buffer_new(&new))
 			__unmap_underlying_blocks(mpd->inode, &new);
+		}
 
 		/*
 		 * If blocks are delayed marked, we need to
 		 * put actual blocknr and drop delayed bit
 		 */
-		if (buffer_delay(lbh))
+		if (buffer_delay(lbh) && !buffer_delay(&new)) {
+			/*
+			 * get_block if successfully allocated
+			 * block will clear the delay bit of
+			 * new buffer_head
+			 */
 			mpage_put_bnr_to_bhs(mpd, next, &new);
+		} else if (err) {
+			/*
+			 * Rather than implement own error handling
+			 * here, we just leave remaining blocks
+			 * unallocated and try again with ->writepage()
+			 * we do this only if actually failed to allocate
+			 * blocks.
+			 */
+			break;
+		}
+		BUG_ON(new.b_size == 0);
 
 		/* go for the remaining blocks */
 		next += new.b_size >> mpd->inode->i_blkbits;
-- 
1.5.5.1.357.g1af8b.dirty

