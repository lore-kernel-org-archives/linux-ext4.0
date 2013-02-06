From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/3] Ext2: mark inode dirty after the function dquot_free_block_nodirty
 is called
Date: Wed, 06 Feb 2013 12:02:14 -0800
Message-ID: <5112B6C6.5000107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:58949 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3BFD7t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2013 22:59:49 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so1044924iaz.2
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 19:59:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We should mark inode dirty after the function dquot_free_block_nodirty
is called.Besides,add a check whether it is necessary to call
dquot_free_block_nodirty functon.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
fs/ext2/balloc.c | 15 ++++++++++-----
fs/ext2/xattr.c | 1 +
2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 22993a0..9d372bf 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -568,8 +568,11 @@ do_more:
}
error_return:
brelse(bitmap_bh);
- release_blocks(sb, freed);
- dquot_free_block_nodirty(inode, freed);
+ if (freed) {
+ release_blocks(sb, freed);
+ dquot_free_block_nodirty(inode, freed);
+ mark_inode_dirty(inode);
+ }
}

/**
@@ -1412,9 +1415,11 @@ allocated:

*errp = 0;
brelse(bitmap_bh);
- dquot_free_block_nodirty(inode, *count-num);
- mark_inode_dirty(inode);
- *count = num;
+ if (num < *count) {
+ dquot_free_block_nodirty(inode, *count-num);
+ mark_inode_dirty(inode);
+ *count = num;
+ }
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
+ mark_inode_dirty(inode);
}
EXT2_I(inode)->i_file_acl = 0;

-- 
1.7.11.7

