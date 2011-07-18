From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 06/12] ext4: let ext4_group_add_blocks() handle 0 blocks quickly
Date: Mon, 18 Jul 2011 10:52:29 +0800
Message-ID: <1310957555-15617-7-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65169 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1GRC45 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:56:57 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so2725572iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:56:57 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_group_add_blocks() is called with 0 block, it just return 0.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/mballoc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 33c41e6..a2af35b 100644
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

