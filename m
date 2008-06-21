From: Mingming <cmm@us.ibm.com>
Subject: [PATCH] delalloc: Add block reservation estimate for non-extent
	files
Date: Fri, 20 Jun 2008 18:11:31 -0700
Message-ID: <1214010691.27507.223.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41257 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYFUBLC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2008 21:11:02 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5L1AxFI031035
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 21:10:59 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5L1AujV182578
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 19:10:59 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5L1AuoV016913
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 19:10:56 -0600
Received: from [9.47.17.71] (BVR-FS.beaverton.ibm.com [9.47.17.71])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m5L1Att5016889
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jun 2008 19:10:55 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add support for full delayed allocation over ext3 format file.

This patch added a function to estimate the number of indirect blocks need
to reserve for non-extent based (ext3) file, in order to properly
reserve the need amount of indirect blocks for delayed allocation.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc6/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc6.orig/fs/ext4/inode.c	2008-06-20 16:50:09.000000000 -0700
+++ linux-2.6.26-rc6/fs/ext4/inode.c	2008-06-20 17:36:08.000000000 -0700
@@ -1426,6 +1426,36 @@ static int ext4_journalled_write_end(str
 
 	return ret ? ret : copied;
 }
+/*
+ * Calculate the number of metadata blocks need to reserve
+ * to allocate @blocks for non extent file based file
+ */
+static int ext4_indirect_calc_metadata_amount(struct inode *inode, int blocks)
+{
+	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+	int ind_blks, dind_blks, tind_blks;
+
+	/* number of new indirect blocks needed */
+	ind_blks = (blocks + icap - 1) / icap;
+
+	dind_blks = (ind_blks + icap - 1) / icap;
+
+	tind_blks = 1;
+
+	return ind_blks + dind_blks + tind_blks;
+}
+
+/*
+ * Calculate the number of metadata blocks need to reserve
+ * to allocate given number of blocks
+ */
+static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
+{
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
+		return ext4_ext_calc_metadata_amount(inode, blocks);
+
+	return ext4_indirect_calc_metadata_amount(inode, blocks);
+}
 
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
@@ -1439,7 +1469,7 @@ static int ext4_da_reserve_space(struct 
 	 */
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
-	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
+	mdblocks = ext4_calc_metadata_amount(inode, total);
 	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
 
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
@@ -1468,7 +1498,7 @@ void ext4_da_release_space(struct inode 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	/* recalculate the number of metablocks still need to be reserved */
 	total = EXT4_I(inode)->i_reserved_data_blocks - used - to_free;
-	mdb = ext4_ext_calc_metadata_amount(inode, total);
+	mdb = ext4_calc_metadata_amount(inode, total);
 
 	/* figure out how many metablocks to release */
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);


