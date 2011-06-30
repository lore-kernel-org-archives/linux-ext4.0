From: Tao Ma <tm@tao.ma>
Subject: [PATCH 2/4] ext4: speed up group trim with the right free block count.
Date: Thu, 30 Jun 2011 22:50:37 +0800
Message-ID: <1309445439-3753-2-git-send-email-tm@tao.ma>
References: <4E0C8B6C.8030403@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46495 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751017Ab1F3Ou6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 10:50:58 -0400
In-Reply-To: <4E0C8B6C.8030403@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

When we trim some free blocks in a group of ext4, we should
calculate the free blocks properly and check whether there are
enough freed blocks left for us to trim. Current solution will
only calculate free spaces if they are large for a trim which
isn't appropriate.

Let us see a small example:
a group has 1.5M free which are 300k, 300k, 300k, 300k, 300k.
And minblocks is 1M. With current solution, we have to iterate
the whole group since these 300k will never be subtracted from
1.5M. But actually we should exit after we find the first 2
free spaces since the left 3 chunks only sum up to 900K if we
subtract the first 600K although they can't be trimed.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2336424..83fb04b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4823,7 +4823,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		   ext4_grpblk_t minblocks)
 {
 	void *bitmap;
-	ext4_grpblk_t next, count = 0;
+	ext4_grpblk_t next, count = 0, free_count = 0;
 	struct ext4_buddy e4b;
 	int ret;
 
@@ -4850,6 +4850,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 					 next - start, group, &e4b);
 			count += next - start;
 		}
+		free_count += next - start;
 		start = next + 1;
 
 		if (fatal_signal_pending(current)) {
@@ -4863,7 +4864,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 			ext4_lock_group(sb, group);
 		}
 
-		if ((e4b.bd_info->bb_free - count) < minblocks)
+		if ((e4b.bd_info->bb_free - free_count) < minblocks)
 			break;
 	}
 	ext4_unlock_group(sb, group);
-- 
1.7.4

