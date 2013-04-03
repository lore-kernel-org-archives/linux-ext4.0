From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix free space estimate in ext4_nonda_switch()
Date: Wed, 3 Apr 2013 13:19:31 -0400
Message-ID: <20130403171931.GC3006@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:50063 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722Ab3DCRTh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 13:19:37 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so1903928veb.12
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 10:19:36 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Values stored in s_freeclusters_counter and s_dirtyclusters_counter
are both in cluster units.  Remove the cluster to block conversion
applied to s_freeclusters_counter causing an inflated estimate of
free space because s_dirtyclusters_counter is not similarly
converted.  Rename free_blocks and dirty_blocks to better reflect
the units these variables contain to avoid future confusion.  This
fix corrects ENOSPC failures for xfstests 127 and 231 on bigalloc
file systems.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/inode.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3a5213..5f5cc40 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2661,7 +2661,7 @@ out_writepages:
 
 static int ext4_nonda_switch(struct super_block *sb)
 {
-	s64 free_blocks, dirty_blocks;
+	s64 free_clusters, dirty_clusters;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	/*
@@ -2672,17 +2672,18 @@ static int ext4_nonda_switch(struct super_block *sb)
 	 * Delalloc need an accurate free block accounting. So switch
 	 * to non delalloc when we are near to error range.
 	 */
-	free_blocks  = EXT4_C2B(sbi,
-		percpu_counter_read_positive(&sbi->s_freeclusters_counter));
-	dirty_blocks = percpu_counter_read_positive(&sbi->s_dirtyclusters_counter);
+	free_clusters =
+		percpu_counter_read_positive(&sbi->s_freeclusters_counter);
+	dirty_clusters =
+		percpu_counter_read_positive(&sbi->s_dirtyclusters_counter);
 	/*
 	 * Start pushing delalloc when 1/2 of free blocks are dirty.
 	 */
-	if (dirty_blocks && (free_blocks < 2 * dirty_blocks))
+	if (dirty_clusters && (free_clusters < 2 * dirty_clusters))
 		try_to_writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
 
-	if (2 * free_blocks < 3 * dirty_blocks ||
-		free_blocks < (dirty_blocks + EXT4_FREECLUSTERS_WATERMARK)) {
+	if (2 * free_clusters < 3 * dirty_clusters ||
+	    free_clusters < (dirty_clusters + EXT4_FREECLUSTERS_WATERMARK)) {
 		/*
 		 * free block count is less than 150% of dirty blocks
 		 * or free blocks is less than watermark
-- 
1.7.10.4

