From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/3] Ext2: mark inode dirty after the function dquot_free_block_nodirty is called
Date: Wed,  6 Feb 2013 14:14:27 +0800
Message-ID: <1360131268-1615-2-git-send-email-wangshilong1991@gmail.com>
References: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	Wang shilong <wangshilong1991@gmail.com>,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:59484 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3BFGO6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2013 01:14:58 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so453092dan.37
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 22:14:58 -0800 (PST)
In-Reply-To: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We should mark inode dirty after the function dquot_free_block_nodirty
is called.Besides,add a check whether it is necessary to call
dquot_free_block_nodirty functon.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/balloc.c | 15 ++++++++++-----
 fs/ext2/xattr.c  |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

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
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index b6754db..4c4cda9 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -795,6 +795,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 		if (IS_SYNC(inode))
 			sync_dirty_buffer(bh);
 		dquot_free_block_nodirty(inode, 1);
+		mark_inode_dirty(inode);
 	}
 	EXT2_I(inode)->i_file_acl = 0;
 
-- 
1.7.11.7

