From: marcus.husar@rose.uni-heidelberg.de
Subject: [PATCH 1/4][2.6.32-stable] ext4: Prepare for backporting first
	quota patch
Date: Sat, 06 Feb 2010 17:33:49 +0100
Message-ID: <20100206173349.8ukmzch57xccokwo@wwwmail.urz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.uni-heidelberg.de ([129.206.210.211]:46120 "EHLO
	relay2.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab0BFRcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Feb 2010 12:32:17 -0500
Received: from ix.urz.uni-heidelberg.de (cyrus-portal.urz.uni-heidelberg.de [129.206.100.176])
	by relay2.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16GafWI001347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:36:41 +0100
Received: from wwwmail.urz.uni-heidelberg.de (wwwmail.urz.uni-heidelberg.de [129.206.100.145])
	by ix.urz.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16GXnmm030219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:33:49 +0100
Received: from wwwmail.urz.uni-heidelberg.de (localhost.localdomain [127.0.0.1])
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1) with ESMTP id o16GXnCO019306
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:33:49 +0100
Received: (from apache@localhost)
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1/Submit) id o16GXnbO019305
	for linux-ext4@vger.kernel.org; Sat, 6 Feb 2010 17:33:49 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

this patch series serves the purpose to solve problems with quota
support of ext4 in the stable tree of kernel 2.6.32. If the changes  
are not too extensive it would be great if you could send them over to  
Greg Kroah-Hartman. All patches apply cleanly, compile and have been  
tested with quota support enabled.

Aneesh Kumar has posted two patches to improve quota support that have  
been applied to 2.6.33-rc.  Patch 2 and 4 are backports of these  
patches on top of
2.6.32.7. Patch 1 and 3 are necessary to be able to backport Aneeshs patches.
Changes to some functions between 2.6.32.7 and 2.6.33-rc were to many.  
  So patch 1 and 3 adapt some functions from 2.6.33-rc3  
(74d2e4f8d79ae0c4b6ec027958d5b18058662eea, parent of patch 2 and
1db913823c0f8360fccbd24ca67eb073966a5ffd, parent of patch 4) to
2.6.32.7.

Adapt ext4_da_reserve_space, ext4_calc_metadata_amount,
ext4_indirect_calc_metadata_amount from 2.6.33-rc3 to apply on top of
2.6.32.7.  Do also a small adjustment to ext4_da_get_block_prep.

Signed-off-by: Marcus Husar <marcus.husar@rose.uni-heidelberg.de>
---
     ext4.h  |    2 +
     inode.c |   88 ++++++++++++++++++++++++++++++++----------------------
     2 files changed, 55 insertions(+), 35 deletions(-)

diff -uprN a/fs/ext4/ext4.h b/fs/ext4/ext4.h
--- a/fs/ext4/ext4.h	2010-02-05 09:11:41.900599000 +0100
+++ b/fs/ext4/ext4.h	2010-02-05 10:05:39.088239463 +0100
@@ -693,6 +693,8 @@ struct ext4_inode_info {
     	unsigned int i_reserved_meta_blocks;
     	unsigned int i_allocated_meta_blocks;
     	unsigned short i_delalloc_reserved_flag;
+	sector_t i_da_metadata_calc_last_lblock;
+	int i_da_metadata_calc_len;

     	/* on-disk additional length */
     	__u16 i_extra_isize;
diff -uprN a/fs/ext4/inode.c b/fs/ext4/inode.c
--- a/fs/ext4/inode.c	2010-02-05 09:11:41.941245000 +0100
+++ b/fs/ext4/inode.c	2010-02-05 09:55:16.068240477 +0100
@@ -1051,38 +1051,44 @@ qsize_t *ext4_get_reserved_space(struct
     	return &EXT4_I(inode)->i_reserved_quota;
     }
     #endif
+
     /*
      * Calculate the number of metadata blocks need to reserve
- * to allocate @blocks for non extent file based file
+ * to allocate a new block at @lblocks for non extent file based file
      */
-static int ext4_indirect_calc_metadata_amount(struct inode *inode,
int blocks)
+static int ext4_indirect_calc_metadata_amount(struct inode *inode,
+					sector_t lblock)
     {
-	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
-	int ind_blks, dind_blks, tind_blks;
-
-	/* number of new indirect blocks needed */
-	ind_blks = (blocks + icap - 1) / icap;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int dind_mask = EXT4_ADDR_PER_BLOCK(inode->i_sb) - 1;
+	int blk_bits;

-	dind_blks = (ind_blks + icap - 1) / icap;
+	if (lblock < EXT4_NDIR_BLOCKS)
+		return 0;

-	tind_blks = 1;
+	lblock -= EXT4_NDIR_BLOCKS;

-	return ind_blks + dind_blks + tind_blks;
+	if (ei->i_da_metadata_calc_len &&
+		(lblock & dind_mask) == ei->i_da_metadata_calc_last_lblock) {
+		ei->i_da_metadata_calc_len++;
+		return 0;
+	}
+	ei->i_da_metadata_calc_last_lblock = lblock & dind_mask;
+	ei->i_da_metadata_calc_len = 1;
+	blk_bits = roundup_pow_of_two(lblock + 1);
+	return (blk_bits / EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb)) + 1;
     }

     /*
      * Calculate the number of metadata blocks need to reserve
- * to allocate given number of blocks
+ * to allocate a block located at @lblock
      */
-static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
+static int ext4_calc_metadata_amount(struct inode *inode, sector_t lblock)
     {
-	if (!blocks)
-		return 0;
-
     	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_calc_metadata_amount(inode, blocks);
+		return ext4_ext_calc_metadata_amount(inode, lblock);

-	return ext4_indirect_calc_metadata_amount(inode, blocks);
+	return ext4_indirect_calc_metadata_amount(inode, lblock);
     }

     static void ext4_da_update_reserve_space(struct inode *inode, int used)
@@ -1834,11 +1840,15 @@ static int ext4_journalled_write_end(str
     	return ret ? ret : copied;
     }

-static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
+/*
+ * Reserve a single block located at lblock
+ */
+static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
     {
     	int retries = 0;
     	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	unsigned long md_needed, mdblocks, total = 0;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned long md_needed, md_reserved;

     	/*
     	 * recalculate the amount of metadata blocks to reserve
@@ -1846,35 +1856,43 @@ static int ext4_da_reserve_space(struct
     	 * worse case is one extent per block
     	 */
     repeat:
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
-	mdblocks = ext4_calc_metadata_amount(inode, total);
-	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
-
-	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
-	total = md_needed + nrblocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	spin_lock(&ei->i_block_reservation_lock);
+	md_reserved = ei->i_reserved_meta_blocks;
+	md_needed = ext4_calc_metadata_amount(inode, lblock);
+	spin_unlock(&ei->i_block_reservation_lock);

     	/*
     	 * Make quota reservation here to prevent quota overflow
     	 * later. Real quota accounting is done at pages writeout
     	 * time.
     	 */
-	if (vfs_dq_reserve_block(inode, total))
+	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
+		/*
+		 * We tend to badly over-estimate the amount of
+		 * metadata blocks which are needed, so if we have
+		 * reserved any metadata blocks, try to force out the
+		 * inode and see if we have any better luck.
+		 */
+		if (md_reserved && retries++ <= 3)
+			goto retry;
     		return -EDQUOT;
+	}

-	if (ext4_claim_free_blocks(sbi, total)) {
-		vfs_dq_release_reservation_block(inode, total);
+	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
+		vfs_dq_release_reservation_block(inode, md_needed + 1);
     		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
+		retry:
+			if (md_reserved)
+				write_inode_now(inode, (retries == 3));
     			yield();
     			goto repeat;
     		}
     		return -ENOSPC;
     	}
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	spin_lock(&ei->i_block_reservation_lock);
+	ei->i_reserved_data_blocks++;
+	ei->i_reserved_meta_blocks += md_needed;
+	spin_unlock(&ei->i_block_reservation_lock);

     	return 0;       /* success */
     }
@@ -2530,7 +2548,7 @@ static int ext4_da_get_block_prep(struct
     		 * XXX: __block_prepare_write() unmaps passed block,
     		 * is it OK?
     		 */
-		ret = ext4_da_reserve_space(inode, 1);
+		ret = ext4_da_reserve_space(inode, iblock);
     		if (ret)
     			/* not enough space to reserve */
     			return ret;



