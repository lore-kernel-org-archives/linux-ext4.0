From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 07/12] ext4: fix a typo in ext4_group_extend()
Date: Mon, 18 Jul 2011 10:52:30 +0800
Message-ID: <1310957555-15617-8-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65169 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1GRC47 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:56:59 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so2725572iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:56:59 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixed a typo in ext4_group_extend().

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 2e63376..4089642 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -996,7 +996,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	o_blocks_count = ext4_blocks_count(es);
 
 	if (test_opt(sb, DEBUG))
-		printk(KERN_DEBUG "EXT4-fs: extending last group from %llu uto %llu blocks\n",
+		printk(KERN_DEBUG "EXT4-fs: extending last group from %llu to %llu blocks\n",
 		       o_blocks_count, n_blocks_count);
 
 	if (n_blocks_count == 0 || n_blocks_count == o_blocks_count)
-- 
1.7.5.1

