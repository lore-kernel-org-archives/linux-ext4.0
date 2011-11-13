From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: fix up a undefined error in ext4_free_blocks
Date: Sun, 13 Nov 2011 13:02:01 +0800
Message-ID: <1321160521-12129-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1KMHXl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Nov 2011 02:23:41 -0500
Received: by iage36 with SMTP id e36so5894602iag.19
        for <linux-ext4@vger.kernel.org>; Sat, 12 Nov 2011 23:23:40 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sbi is not defined, so let ext4_free_blocks use
EXT4_SB(sb) instead.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f6dba45..12ccacd 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -565,7 +565,7 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 	brelse(bitmap_bh);
 	printk(KERN_DEBUG "ext4_count_free_clusters: stored = %llu"
 	       ", computed = %llu, %llu\n",
-	       EXT4_B2C(sbi, ext4_free_blocks_count(es)),
+	       EXT4_B2C(EXT4_SB(sb), ext4_free_blocks_count(es)),
 	       desc_count, bitmap_count);
 	return bitmap_count;
 #else
-- 
1.7.5.1

