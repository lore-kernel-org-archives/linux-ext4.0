From: Allison Henderson <achender@vnet.ibm.com>
Subject: PATCH 2/2 v2] EXT4: Remove un-needed ext4_ext_remove_space param
Date: Mon, 06 Jun 2011 16:43:48 -0700
Message-ID: <4DED6634.5030908@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42910 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1FFXnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 19:43:52 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p56NV6RP013524
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:31:06 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p56NhnNm120120
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:43:49 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p56Nn3VX031643
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:49:03 -0600
Received: from lc4eb0185863151.ibm.com (sig-9-65-175-246.mts.ibm.com [9.65.175.246])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p56Nn2Y9031557
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:49:03 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch removes the extra parameter in the ext4_ext_remove_space
routine which is no longer needed.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 ecaa767... 5b62553... M	fs/ext4/extents.c
 fs/ext4/extents.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ecaa767..5b62553 100644
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
+					start, EXT_MAX_BLOCK);
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
 			path[i].p_bh = NULL;
@@ -3718,7 +3717,7 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
-	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCK);
+	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
-- 
1.7.1

