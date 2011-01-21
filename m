From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext3: speed up group trim with the right free block count.
Date: Fri, 21 Jan 2011 09:59:26 +0800
Message-ID: <1295575166-3674-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51754 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751816Ab1AUB7w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jan 2011 20:59:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

When we trim some free blocks in a group of ext3, we should
calculate the free blocks properly and check whether there are
enough freed blocks left for us to trim. Current solution will
only calculate free spaces if they are large for a trim which
is wrong.

Let us see a small example:
a group has 1.5M free which are 300k, 300k, 300k, 300k, 300k.
And minblocks is 1M. With current solution, we have to iterate
the whole group since these 300k will never be subtracted from
1.5M. But actually we should exit after we find the first 2
free spaces since the left 3 chunks only sum up to 900K if we
subtract the first 600K although they can't be trimed.

Cc: Jan Kara <jack@suse.cz>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/balloc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 045995c..971e1bd 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1922,7 +1922,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 				ext3_grpblk_t minblocks)
 {
 	handle_t *handle;
-	ext3_grpblk_t next, free_blocks, bit, freed, count = 0;
+	ext3_grpblk_t next, free_blocks, bit, freed, count = 0, free_count = 0;
 	ext3_fsblk_t discard_block;
 	struct ext3_sb_info *sbi;
 	struct buffer_head *gdp_bh, *bitmap_bh = NULL;
@@ -1991,6 +1991,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 		spin_unlock(sb_bgl_lock(sbi, group));
 		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
 
+		free_count += next - start;
 		/* Do not issue a TRIM on extents smaller than minblocks */
 		if ((next - start) < minblocks)
 			goto free_extent;
@@ -2040,7 +2041,7 @@ free_extent:
 		cond_resched();
 
 		/* No more suitable extents */
-		if ((free_blocks - count) < minblocks)
+		if ((free_blocks - free_count) < minblocks)
 			break;
 	}
 
-- 
1.7.1

