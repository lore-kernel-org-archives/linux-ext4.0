From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 06/11] ext4: Update meta-data reservation with delalloc.
Date: Wed, 27 Aug 2008 20:58:31 +0530
Message-ID: <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:57222 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756823AbYH0P3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:29:05 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7RFT28S023320
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:02 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RFT2CU1785864
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:02 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7RFT1eJ021891
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:02 +0530
In-Reply-To: <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This makes the meta-data reservation simpler. The logic
followed is simpler. After each block allocation request
if we have allocated some meta-data blocks subtract the
same from the reserved meta-data blocks. If the total
reserved data blocks after allocation is zero, free the
remaining meta-data blocks reserved. During reservation
if the total reserved blocks need more meta-data blocks
add the extra meta-data blocks needed to the reserve_meta_blocks

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   75 +++++++++++++++++++++++++++----------------------------
 1 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a45121f..3ef0822 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1019,31 +1019,34 @@ static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
 static void ext4_da_update_reserve_space(struct inode *inode, int used)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free;
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	/* recalculate the number of metablocks still need to be reserved */
-	total = EXT4_I(inode)->i_reserved_data_blocks - used;
-	mdb = ext4_calc_metadata_amount(inode, total);
-
-	/* figure out how many metablocks to release */
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
-
-	if (mdb_free) {
-		/* Account for allocated meta_blocks */
-		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
-
-		/* update fs dirty blocks counter */
-		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
+	if (EXT4_I(inode)->i_allocated_meta_blocks) {
+		/* update the reseved meta- blocks */
+		BUG_ON(EXT4_I(inode)->i_allocated_meta_blocks >
+			EXT4_I(inode)->i_reserved_meta_blocks);
+		EXT4_I(inode)->i_reserved_meta_blocks -=
+			EXT4_I(inode)->i_allocated_meta_blocks;
 		EXT4_I(inode)->i_allocated_meta_blocks = 0;
-		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
+		/*
+		 * We already updated the percpu dirty
+		 * block counter in the block allocation path.
+		 */
 	}
-
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
+	if (!EXT4_I(inode)->i_reserved_data_blocks) {
+		/*
+		 * If we don't have any reserved data blocks
+		 * release all the resered meta data blocks
+		 * update percpu dirty block counter also.
+		 */
+		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+				EXT4_I(inode)->i_reserved_meta_blocks);
+		EXT4_I(inode)->i_reserved_meta_blocks = 0;
 
+	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
@@ -1524,7 +1527,7 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
 	int retries = 0;
        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-       unsigned long md_needed, mdblocks, total = 0;
+       unsigned long md_needed = 0, mdblocks, total = 0;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1535,9 +1538,9 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
 	mdblocks = ext4_calc_metadata_amount(inode, total);
-	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
+	if (mdblocks > EXT4_I(inode)->i_reserved_meta_blocks)
+		md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 
-	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
 	if (ext4_claim_free_blocks(sbi, total)) {
@@ -1549,7 +1552,7 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
 
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	return 0;       /* success */
@@ -1558,13 +1561,12 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 static void ext4_da_release_space(struct inode *inode, int to_free)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free, release;
+	int release, mdb_free = 0;
 
 	if (!to_free)
 		return;		/* Nothing to release, exit */
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-
 	if (!EXT4_I(inode)->i_reserved_data_blocks) {
 		/*
 		 * if there is no reserved blocks, but we try to free some
@@ -1578,26 +1580,23 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return;
 	}
+	/* update per-inode reservations */
+	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
+	EXT4_I(inode)->i_reserved_data_blocks -= to_free;
+	if (!EXT4_I(inode)->i_reserved_data_blocks) {
+		/*
+		 * If we don't have any reserved data blocks
+		 * release all the resered meta data blocks
+		 * update percpu dirty block counter also.
+		 */
+		mdb_free = EXT4_I(inode)->i_reserved_meta_blocks;
+		EXT4_I(inode)->i_reserved_meta_blocks = 0;
 
-	/* recalculate the number of metablocks still need to be reserved */
-	total = EXT4_I(inode)->i_reserved_data_blocks - to_free;
-	mdb = ext4_calc_metadata_amount(inode, total);
-
-	/* figure out how many metablocks to release */
-	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
-	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
-
+	}
 	release = to_free + mdb_free;
 
 	/* update fs dirty blocks counter for truncate case */
 	percpu_counter_sub(&sbi->s_dirtyblocks_counter, release);
-
-	/* update per-inode reservations */
-	BUG_ON(to_free > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= to_free;
