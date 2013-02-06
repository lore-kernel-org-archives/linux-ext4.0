From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH 3/3] Ext2: remove the static function release_blocks to optimize the kernel
Date: Wed,  6 Feb 2013 14:14:28 +0800
Message-ID: <1360131268-1615-3-git-send-email-wangshilong1991@gmail.com>
References: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	Wang shilong <wangshilong1991@gmail.com>,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:50362 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3BFGPE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2013 01:15:04 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so466713dal.15
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 22:15:02 -0800 (PST)
In-Reply-To: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
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
