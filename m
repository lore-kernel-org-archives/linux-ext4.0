From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] e2fsck: delay metadata checksum in pass1
Date: Fri, 29 Jun 2012 10:35:56 +0800
Message-ID: <1340937356-12493-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62680 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2F2C2A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2012 22:28:00 -0400
Received: by dady13 with SMTP id y13so3700910dad.19
        for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2012 19:28:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

in __ext4_get_inode_loc, when all other inodes are free, we will skip I/O.
Thus, all of inodes in this block are set to 0.  Then when we scan these inodes
in pass1, we will get a metadata checksum error.  However, we don't need to scan
these inodes because they have been freed.

This bug can be reproduced by xfstests #013.

Reported-by: Tao Ma <boyu.tm@taobao.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 48a1af0..72f8e82 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -583,6 +583,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	ext2_ino_t	ino = 0;
 	struct ext2_inode *inode;
 	ext2_inode_scan	scan;
+	errcode_t	csum_errcode;
 	char		*block_buf;
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
@@ -788,12 +789,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		pctx.inode = inode;
 		ctx->stashed_ino = ino;
 
-		/* Clear corrupt inode? */
-		if (pctx.errcode == EXT2_ET_INODE_CSUM_INVALID) {
-			if (fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
-				goto clear_inode;
-			failed_csum = 1;
-		}
+		csum_errcode = pctx.errcode;
 
 		if (inode->i_links_count) {
 			pctx.errcode = ext2fs_icount_store(ctx->inode_link_info,
@@ -1063,6 +1059,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 			continue;
 		}
+
+		/* Clear corrupt inode? */
+		if (csum_errcode == EXT2_ET_INODE_CSUM_INVALID) {
+			if (fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
+				goto clear_inode;
+			failed_csum = 1;
+		}
+
 		/*
 		 * n.b.  0.3c ext2fs code didn't clear i_links_count for
 		 * deleted files.  Oops.
-- 
1.7.4.1

