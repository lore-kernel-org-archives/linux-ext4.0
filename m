From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH v1 3/3] Ext2: remove the static function release_blocks to optimize the kernel
Date: Thu,  7 Feb 2013 22:57:54 +0800
Message-ID: <1360249074-2642-2-git-send-email-wangshilong1991@gmail.com>
References: <1360249074-2642-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56184 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab3BGO6F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 09:58:05 -0500
Received: by mail-pa0-f51.google.com with SMTP id hz1so1472395pad.10
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 06:58:05 -0800 (PST)
In-Reply-To: <1360249074-2642-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Because the static function 'release_blocks' is only called
when releasing blocks,it will be more simple and efficient to
call the function 'percpu_counter_add' directly.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/balloc.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9d372bf..d5a6afd 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -159,15 +159,6 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	return bh;
 }
 
-static void release_blocks(struct super_block *sb, int count)
-{
-	if (count) {
-		struct ext2_sb_info *sbi = EXT2_SB(sb);
-
-		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-	}
-}
