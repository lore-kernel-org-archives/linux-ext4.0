From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-38.diff>
Date: Fri, 9 Feb 2007 18:11:33 -0800
Message-ID: <200702100211.l1A2BXIO007393@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:24558 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXBJCOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:42 -0500
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
Coverity ID: 38: Resource Leak

The memory allocated by inode is not reclaimed.  At this point
inode has not even really been used at all.  Should be safe
to free it. **Note that this patch depends on cid-37.diff

Index: e2fsprogs+chaos/e2fsck/pass1.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass1.c
+++ e2fsprogs+chaos/e2fsck/pass1.c
@@ -481,6 +481,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1_ALLOCATE_DBCOUNT, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
+		ext2fs_free_mem(&inode);
 		return;
 	}
 
@@ -509,6 +510,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		ext2fs_free_mem(&block_buf);
+		ext2fs_free_mem(&inode);
 		return;
 	}
 	ext2fs_inode_scan_flags(scan, EXT2_SF_SKIP_MISSING_ITABLE, 0);
