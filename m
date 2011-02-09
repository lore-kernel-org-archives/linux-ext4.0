From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: don't check/clone duplicate xattr blocks in fs without
 xattr feature
Date: Wed, 09 Feb 2011 12:41:37 -0600
Message-ID: <4D52DFE1.4090709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1BISlj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Feb 2011 13:41:39 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p19Ifcmj029934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Feb 2011 13:41:38 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p19IfbaE005162
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Feb 2011 13:41:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I had an extremely corrupted customer filesystem which, after thousands
of lines of e2fsck output, found one more problem on an immediately
subsequent e2fsck.  In short, a file had had its i_file_acl block
cloned due to being a duplicate.  That ultimately got cleared
because the fs did not have the xattr feature, and the inode
was subsequently removed due to invalid mode.

The 2nd e2fsck pass found the cloned xattr block as in use, but
not owned by any file, and had to fix up the block bitmaps.

Simply skipping the processing of duplicate xattr blocks on a
non-xattr filesystem seems reasonable, since they will be cleared
later in any case.

(also fix existing brace misalignment)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 155fcba..2ddaeb4 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -310,12 +310,14 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 			pctx.errcode = ext2fs_block_iterate3(fs, ino,
 					     BLOCK_FLAG_READ_ONLY, block_buf,
 					     process_pass1b_block, &pb);
-		if (ext2fs_file_acl_block(&inode)) {
+		/* If the feature is not set, attrs will be cleared later anyway */
+		if ((fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) &&
+		    ext2fs_file_acl_block(&inode)) {
 			blk64_t blk = ext2fs_file_acl_block(&inode);
 			process_pass1b_block(fs, &blk,
 					     BLOCK_COUNT_EXTATTR, 0, 0, &pb);
 			ext2fs_file_acl_block_set(&inode, blk);
-			}
+		}
 		if (pb.dup_blocks) {
 			end_problem_latch(ctx, PR_LATCH_DBLOCK);
 			if (ino >= EXT2_FIRST_INODE(fs->super) ||
