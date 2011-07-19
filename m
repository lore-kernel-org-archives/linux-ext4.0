From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 05/11] ext4: let ext4_group_add_blocks() handle 0 blocks quickly
Date: Tue, 19 Jul 2011 12:02:11 +0800
Message-ID: <1311048137-16400-6-git-send-email-xiaoqiangnk@gmail.com>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1GSEGg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:36 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so3703318iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:36 -0700 (PDT)
In-Reply-To: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_group_add_blocks() is called with 0 block, it just return 0.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

 v1->v2:
    nothing changed.
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 48784eb..397e27c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4680,6 +4680,9 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 
 	ext4_debug("Adding block(s) %llu-%llu\n", block, block + count - 1);
 
+	if (count == 0)
+		return 0;
+
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
 	/*
 	 * Check to see if we are freeing blocks across a group
-- 
1.7.5.1

