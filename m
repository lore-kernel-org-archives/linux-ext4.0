From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 3/3] ext4: modify the process of invalidate_page for the new implemention of quota reservation
Date: Tue, 13 Mar 2012 19:38:18 +0800
Message-ID: <1331638698-14796-3-git-send-email-hao.bigrat@gmail.com>
References: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <hao.bigrat@gmail.com>, Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59593 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab2CMLif (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2012 07:38:35 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so671109iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2012 04:38:34 -0700 (PDT)
In-Reply-To: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since buffer_head with PG_Delay does not means "quota already occupied" any more, we
should check whether to release reservation in ext4_da_invalidatepage.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/inode.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7e27581..e5d15eb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1202,6 +1202,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 	unsigned int curr_off = 0;
 	struct inode *inode = page->mapping->host;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_map_blocks map;
 	int num_clusters;
 
 	head = page_buffers(page);
@@ -1220,15 +1221,21 @@ static void ext4_da_page_release_reservation(struct page *page,
 	/* If we have released all the blocks belonging to a cluster, then we
 	 * need to release the reserved space for that cluster. */
 	num_clusters = EXT4_NUM_B2C(sbi, to_release);
-	while (num_clusters > 0) {
-		ext4_fsblk_t lblk;
-		lblk = (page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits)) +
-			((num_clusters - 1) << sbi->s_cluster_bits);
-		if (sbi->s_cluster_ratio == 1 ||
-		    !ext4_find_delalloc_cluster(inode, lblk, 1))
-			ext4_da_release_space(inode, 1);
