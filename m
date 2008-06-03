From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: delalloc  block reservation fix
Date: Tue,  3 Jun 2008 22:59:37 +0530
Message-ID: <1212514177-7249-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39119 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYFCR3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 13:29:55 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m53HTc7h008889
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 22:59:38 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m53HTNJT1257556
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 22:59:23 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m53HTbvi002818
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 22:59:37 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

a) We need to decrement the meta data blocks that got allocated
from percpu s_freeblocks_counter

b) We need to protect the reservation block counter so that
reserve and release space doesn't race each other.

c) don't check for free space in ext4_mb_new_blocks with delalloc
We already reserved the space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |    9 +++++++++
 fs/ext4/ext4_i.h  |    2 ++
 fs/ext4/inode.c   |   36 +++++++++++++++++++++++-------------
 fs/ext4/mballoc.c |    7 ++++++-
 fs/ext4/super.c   |    2 ++
 5 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 71b184c..bd18ceb 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1959,6 +1959,15 @@ ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = 1;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	/*
+	 * Account for the allocated meta blocks
+	 */
+	if (!(*errp)) {
+		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	}
+
 	return ret;
 }
 ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index 425518e..3d08e5b 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -166,7 +166,9 @@ struct ext4_inode_info {
 	/* allocation reservation info for delalloc */
 	unsigned long i_reserved_data_blocks;
 	unsigned long i_reserved_meta_blocks;
+	unsigned long i_allocated_meta_blocks;
 	unsigned short i_delalloc_reserved_flag;
+	spinlock_t i_block_reservation_lock;
 };
 
 #endif	/* _EXT4_I */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1695ecc..2e485a3 100644
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
+
+	/* Account for allocated meta_blocks */
+	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
 
-	release = to_free + mdb;
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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a7bdacb..09922ae 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4052,7 +4052,12 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
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
index 073bb2c..ee036af 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -574,7 +574,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&ei->i_prealloc_lock);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
+	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
+	spin_lock_init(&(ei->i_block_reservation_lock));
 	return &ei->vfs_inode;
 }
 
-- 
1.5.5.1.357.g1af8b.dirty

