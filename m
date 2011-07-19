From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 06/11] ext4: fix a typo in ext4_group_extend()
Date: Tue, 19 Jul 2011 12:02:12 +0800
Message-ID: <1311048137-16400-7-git-send-email-xiaoqiangnk@gmail.com>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48758 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1GSEGj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:39 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so3708338iyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:38 -0700 (PDT)
In-Reply-To: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixed a typo in ext4_group_extend().

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 v1->v2:
   nothing changed.
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 4c041e3..5f0aefd 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -986,7 +986,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	o_blocks_count = ext4_blocks_count(es);
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: extending last group from %llu uto %llu blocks\n",
+		printk(KERN_DEBUG "EXT4-fs: extending last group from %llu to %llu blocks\n",
 		       o_blocks_count, n_blocks_count);
 
 	if (n_blocks_count == 0 || n_blocks_count == o_blocks_count)
-- 
1.7.5.1

