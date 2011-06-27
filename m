From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: avoid redundant cache finding if flags not cantian PUNCH_OUT
Date: Mon, 27 Jun 2011 14:33:40 +0800
Message-ID: <1309156420-4201-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1F0Gdt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 02:33:49 -0400
Received: by iyb12 with SMTP id 12so3831678iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 26 Jun 2011 23:33:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In old code, ext4 will find extent in cache first even flags does
not contian PUNCH_OUT, that may waste some time.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eb63c7b..d583ec3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3358,8 +3358,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
 
 	/* check in cache */
-	if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
-		((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0)) {
+	if (((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0) &&
+		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
 		if (!newex.ee_start_lo && !newex.ee_start_hi) {
 			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 				/*
-- 
1.7.1

