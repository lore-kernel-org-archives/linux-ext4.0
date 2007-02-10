From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-23.diff>
Date: Fri, 9 Feb 2007 18:11:20 -0800
Message-ID: <200702100211.l1A2BKSg007169@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:43687 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXBJCO3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 23: Resource Leak

Use pre-existing early exit label in function to handle proper 
error code return and local memory allocation cleanup.

Index: e2fsprogs+chaos/lib/ext2fs/imager.c
===================================================================
--- e2fsprogs+chaos.orig/lib/ext2fs/imager.c
+++ e2fsprogs+chaos/lib/ext2fs/imager.c
@@ -72,8 +72,10 @@ errcode_t ext2fs_image_inode_write(ext2_
 	
 	for (group = 0; group < fs->group_desc_count; group++) {
 		blk = fs->group_desc[(unsigned)group].bg_inode_table;
-		if (!blk)
-			return EXT2_ET_MISSING_INODE_TABLE;
+		if (!blk) {
+			retval = EXT2_ET_MISSING_INODE_TABLE;
+			goto errout;
+		}
 		left = fs->inode_blocks_per_group;
 		while (left) {
 			c = BUF_BLOCKS;
