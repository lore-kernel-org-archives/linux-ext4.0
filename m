From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH v1 2/3] Ext2: mark inode dirty after the function dquot_free_block_nodirty is called
Date: Thu,  7 Feb 2013 22:57:53 +0800
Message-ID: <1360249074-2642-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55830 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab3BGO6D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 09:58:03 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa10so1488376pad.41
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 06:58:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We should mark inode dirty after the function dquot_free_block_nodirty
is called.Besides,add a check whether it is necessary to call
dquot_free_block_nodirty functon.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/balloc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 22993a0..9d372bf 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -568,8 +568,11 @@ do_more:
 	}
 error_return:
 	brelse(bitmap_bh);
-	release_blocks(sb, freed);
-	dquot_free_block_nodirty(inode, freed);
+	if (freed) {
+		release_blocks(sb, freed);
+		dquot_free_block_nodirty(inode, freed);
+		mark_inode_dirty(inode);
+	}
 }
 
 /**
@@ -1412,9 +1415,11 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	dquot_free_block_nodirty(inode, *count-num);
-	mark_inode_dirty(inode);
-	*count = num;
+	if (num < *count) {
+		dquot_free_block_nodirty(inode, *count-num);
+		mark_inode_dirty(inode);
+		*count = num;
+	}
 	return ret_block;
 
 io_error:
-- 
1.7.11.7

