From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 08/21 v5] debugfs: make lsdel command support inline data
Date: Sat, 22 Sep 2012 12:00:56 +0800
Message-ID: <1348286469-31690-9-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2IVDvN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:13 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873835pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:13 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/lsdel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index bed0ce6..71546c7 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -149,7 +149,8 @@ void do_lsdel(int argc, char **argv)
 				"while calling ext2fs_block_iterate2");
 			goto next;
 		}
-		if (lsd.free_blocks && !lsd.bad_blocks) {
+		if (lsd.free_blocks && !lsd.bad_blocks ||
+		    inode.i_flags & EXT4_INLINE_DATA_FL) {
 			if (num_delarray >= max_delarray) {
 				max_delarray += 50;
 				delarray = realloc(delarray,
-- 
1.7.4.1

