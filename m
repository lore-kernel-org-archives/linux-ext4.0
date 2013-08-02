From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 08/22] debugfs: make lsdel command support inline data
Date: Fri,  2 Aug 2013 17:49:35 +0800
Message-ID: <1375436989-18948-9-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40719 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab3HBJul (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:50:41 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so498316pab.1
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:50:41 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/lsdel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
1.7.9.7

