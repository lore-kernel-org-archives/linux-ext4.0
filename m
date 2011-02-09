From: Tao Ma <tm@tao.ma>
Subject: [PATCH 2/4] ext4: speed up group trim with the right free block count.
Date: Wed,  9 Feb 2011 13:57:26 +0800
Message-ID: <1297231048-3458-2-git-send-email-tm@tao.ma>
References: <4D522B9B.5070707@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:52701 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750919Ab1BIF6N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 00:58:13 -0500
Received: from [114.251.86.0] (helo=taoma-linux.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Pn347-0005it-Rf
	for linux-ext4@vger.kernel.org; Tue, 08 Feb 2011 22:58:13 -0700
In-Reply-To: <4D522B9B.5070707@tao.ma>
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
index 94e9f23..806adb2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4757,7 +4757,7 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 		ext4_grpblk_t start, ext4_grpblk_t max, ext4_grpblk_t minblocks)
 {
 	void *bitmap;
-	ext4_grpblk_t next, count = 0;
+	ext4_grpblk_t next, count = 0, free_count = 0;
 	ext4_group_t group;
 	int ret = 0;
 
@@ -4782,6 +4782,7 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 				break;
 			count += next - start;
 		}
+		free_count += next - start;
 		start = next + 1;
 
 		if (fatal_signal_pending(current)) {
@@ -4795,7 +4796,7 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 			ext4_lock_group(sb, group);
 		}
 
-		if ((e4b->bd_info->bb_free - count) < minblocks)
+		if ((e4b->bd_info->bb_free - free_count) < minblocks)
 			break;
 	}
 	ext4_unlock_group(sb, group);
-- 
1.6.3.GIT

