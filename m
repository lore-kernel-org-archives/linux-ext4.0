From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/2] EXT4: Punch Hole Optimizations: Removed un-needed ext4_ext_remove_space param
Date: Mon, 27 Jun 2011 15:49:51 -0700
Message-ID: <1309214991-31141-3-git-send-email-achender@linux.vnet.ibm.com>
References: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48612 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1F0Wrc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 18:47:32 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5RMPhlJ015361
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:25:43 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5RMlVmN086914
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:47:31 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5RMlVUj014731
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:47:31 -0400
In-Reply-To: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch removes the extra parameter in the ext4_ext_remove_space
routine which is no longer needed.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v1->v2
Added patch 2/2 to remove uneeded parameter

v2->v3
Rebased to apply onto latest ext4 code

:100644 100644 dc5a077... 3579822... M	fs/ext4/extents.c
 fs/ext4/extents.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dc5a077..3579822 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2534,8 +2534,7 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
-static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
-				ext4_lblk_t end)
+static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
@@ -2575,7 +2574,7 @@ again:
 		if (i == depth) {
 			/* this is leaf block */
 			err = ext4_ext_rm_leaf(handle, inode, path,
-					start, end);
+					start, EXT_MAX_BLOCKS - 1);
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
 			path[i].p_bh = NULL;
@@ -3718,7 +3717,7 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
-	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
+	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
-- 
1.7.1

