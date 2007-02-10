From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-36.diff>
Date: Fri, 9 Feb 2007 18:11:31 -0800
Message-ID: <200702100211.l1A2BV5D007345@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:2899 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbXBJCOf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:35 -0500
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
Coverity ID: 36: Resource Leak

Memory could be leaked when jumping to the clear_extattr label once
region_create() had been called. The applied fix for the issue is to
initialize region to NULL, and then in the clear_extattr case free to region
with region_free() when region != NULL.

Additionally some whitespace cleanup was done.

Index: e2fsprogs+chaos/e2fsck/pass1.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass1.c
+++ e2fsprogs+chaos/e2fsck/pass1.c
@@ -1160,8 +1160,8 @@ static int check_ext_attr(e2fsck_t ctx, 
 	struct ext2_ext_attr_header *header;
 	struct ext2_ext_attr_entry *entry;
 	int		count;
-	region_t	region;
-	
+	region_t	region = NULL;
+
 	blk = inode->i_file_acl;
 	if (blk == 0)
 		return 0;
@@ -1227,7 +1227,7 @@ static int check_ext_attr(e2fsck_t ctx, 
 		ea_refcount_increment(ctx->refcount_extra, blk, 0);
 		return 1;
 	}
-	
+
 	/*
 	 * OK, we haven't seen this EA block yet.  So we need to
 	 * validate it
@@ -1261,7 +1261,7 @@ static int check_ext_attr(e2fsck_t ctx, 
 		if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
 			goto clear_extattr;
 	}
-	
+
 	entry = (struct ext2_ext_attr_entry *)(header+1);
 	end = block_buf + fs->blocksize;
 	while ((char *)entry < end && *(__u32 *)entry) {
@@ -1300,10 +1300,12 @@ static int check_ext_attr(e2fsck_t ctx, 
 		ea_refcount_store(ctx->refcount, blk, count);
 	mark_block_used(ctx, blk);
 	ext2fs_fast_mark_block_bitmap(ctx->block_ea_map, blk);
-	
+
 	return 1;
 
 clear_extattr:
+	if (region)
+		region_free(region);
 	inode->i_file_acl = 0;
 	e2fsck_write_inode(ctx, ino, inode, "check_ext_attr");
 	return 0;
