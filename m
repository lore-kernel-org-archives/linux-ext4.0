From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-42.diff>
Date: Fri, 9 Feb 2007 18:11:38 -0800
Message-ID: <200702100211.l1A2BcZh007467@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:24558 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXBJCOn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:43 -0500
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
Coverity ID: 42: Resource Leak

The temporary scratch inode must be freed in the early return cases.

Index: e2fsprogs+chaos/e2fsck/pass4.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass4.c
+++ e2fsprogs+chaos/e2fsck/pass4.c
@@ -113,12 +113,12 @@ void e2fsck_pass4(e2fsck_t ctx)
 	
 	for (i=1; i <= fs->super->s_inodes_count; i++) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-			return;
+			goto errout;
 		if ((i % fs->super->s_inodes_per_group) == 0) {
 			group++;
 			if (ctx->progress)
 				if ((ctx->progress)(ctx, 4, group, maxgroup))
-					return;
+					goto errout;
 		}
 		if (i == EXT2_BAD_INO ||
 		    (i > EXT2_ROOT_INO && i < EXT2_FIRST_INODE(fs->super)))
@@ -166,6 +166,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	ctx->inode_bb_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
 	ctx->inode_imagic_map = 0;
+errout:
 	if (buf)
 		ext2fs_free_mem(&buf);
 #ifdef RESOURCE_TRACK
