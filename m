From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH v3] ext4: avoid wasted extent cache lookup if !PUNCH_OUT_EXT
Date: Wed, 29 Jun 2011 08:57:51 +0800
Message-ID: <1309309071-2244-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47994 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1F2A6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 20:58:01 -0400
Received: by iwn6 with SMTP id 6so619727iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2011 17:58:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch avoids an extraneous lookup of the extent cache
in ext4_ext_map_blocks() when the flag
EXT4_GET_BLOCKS_PUNCH_OUT_EXT is absent.

The existing logic was performing the lookup but not making
use of the result. The patch simply reverses the order of evaluation
in the condition.

Since ext4_ext_in_cache() does not initialize newex on misses, bypassing
its invocation does not introduce any new issue in this regard.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Eric Gouriou <egouriou@google.com>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eb63c7b..fed2633 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3358,8 +3358,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
 
 	/* check in cache */
-	if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
-		((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0)) {
+	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
+		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
 		if (!newex.ee_start_lo && !newex.ee_start_hi) {
 			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
 				/*
-- 
1.7.1

