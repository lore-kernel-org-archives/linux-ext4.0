From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-22.diff>
Date: Fri, 9 Feb 2007 18:11:19 -0800
Message-ID: <200702100211.l1A2BJH8007158@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:14899 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXBJCOX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:23 -0500
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
Coverity ID: 22: Resource Leak

Need to free w_inode on early exit if w_inode != &temp_inode.

Index: e2fsprogs+chaos/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs+chaos.orig/lib/ext2fs/inode.c
+++ e2fsprogs+chaos/lib/ext2fs/inode.c
@@ -669,8 +669,10 @@ errcode_t ext2fs_write_inode_full(ext2_f
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);
 	block = offset >> EXT2_BLOCK_SIZE_BITS(fs->super);
-	if (!fs->group_desc[(unsigned) group].bg_inode_table)
-		return EXT2_ET_MISSING_INODE_TABLE;
+	if (!fs->group_desc[(unsigned) group].bg_inode_table) {
+		retval = EXT2_ET_MISSING_INODE_TABLE;
+		goto errout;
+	}
 	block_nr = fs->group_desc[(unsigned) group].bg_inode_table + block;
 
 	offset &= (EXT2_BLOCK_SIZE(fs->super) - 1);
