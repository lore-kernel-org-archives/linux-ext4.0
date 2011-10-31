From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 4/6] ext4: let ext4 maintian delayed extent trees
Date: Mon, 31 Oct 2011 08:55:45 +0800
Message-ID: <1320022547-2284-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1JaDAH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 23:00:07 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so6677937iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 20:00:07 -0700 (PDT)
In-Reply-To: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch let ext4 maintain delayed extent trees.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c  |    2 ++
 fs/ext4/indirect.c |    3 +++
 fs/ext4/inode.c    |   30 ++++++++++++++++++++++++++++--
 fs/ext4/super.c    |   12 +++++++++++-
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 37a5df7..f878da1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4233,6 +4233,8 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
+	err = ext4_de_remove_space(inode, last_block,
+				   EXT_MAX_BLOCKS - last_block);
 	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3cfc73f..f5f61b28 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include "ext4_jbd2.h"
+#include "ext4_extents.h"
 #include "truncate.h"
 
 #include <trace/events/ext4.h>
@@ -1399,6 +1400,8 @@ void ext4_ind_truncate(struct inode *inode)
 	down_write(&ei->i_data_sem);
 
 	ext4_discard_preallocations(inode);
+	ext4_de_remove_space(inode, last_block,
+			     EXT_MAX_BLOCKS - last_block);
 
 	/*
 	 * The orphan list entry will now protect us from any crash which
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f97d671..f573020 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -486,7 +486,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
-		int ret = check_block_validity(inode, map);
+		int ret;
+		if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
+			/* delayed alloc may be allocated by fallocate and
+			 * coverted to initialized by directIO.
+			 * we need to handle delayed extent here.
+			 */
+			down_write((&EXT4_I(inode)->i_data_sem));
+			goto delayed_mapped;
+		}
+		ret = check_block_validity(inode, map);
 		if (ret != 0)
 			return ret;
 	}
@@ -568,8 +577,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		 * set the BH_Da_Mapped bit on them. Its important to do this
 		 * under the protection of i_data_sem.
 		 */
-		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
+		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
+			int ret;
 			set_buffers_da_mapped(inode, map);
+delayed_mapped:
+			/* delayed allocation blocks has been allocated */
+			ret = ext4_de_remove_space(inode, map->m_lblk,
+						   map->m_len);
+			if (ret < 0)
+				retval = ret;
+		}
 	}
 
 	up_write((&EXT4_I(inode)->i_data_sem));
@@ -1676,6 +1693,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 			      struct buffer_head *bh)
 {
 	int retval;
+	int ret;
 	sector_t invalid_block = ~((sector_t) 0xffff);
 
 	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
@@ -1722,6 +1740,14 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 out_unlock:
 	up_read((&EXT4_I(inode)->i_data_sem));
 
+	if (retval ==0) {
+		down_write((&EXT4_I(inode)->i_data_sem));
+		ret = ext4_de_add_space(inode, map->m_lblk, map->m_len);
+		up_write((&EXT4_I(inode)->i_data_sem));
+		if (ret)
+			return ret;
+	}
+
 	return retval;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9515e5f..3df7c7b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -50,6 +50,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "ext4_extents.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -984,6 +985,7 @@ void ext4_clear_inode(struct inode *inode)
 	end_writeback(inode);
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
+	ext4_de_remove_space(inode, 0, EXT_MAX_BLOCKS);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
@@ -5065,9 +5067,14 @@ static int __init ext4_init_fs(void)
 		init_waitqueue_head(&ext4__ioend_wq[i]);
 	}
 
-	err = ext4_init_pageio();
+	err = ext4_init_de();
 	if (err)
 		return err;
+
+	err = ext4_init_pageio();
+	if (err)
+		goto out8;
+
 	err = ext4_init_system_zone();
 	if (err)
 		goto out6;
@@ -5117,6 +5124,9 @@ out5:
 	ext4_exit_system_zone();
 out6:
 	ext4_exit_pageio();
+out8:
+	ext4_exit_de();
+
 	return err;
 }
 
-- 
1.7.5.1

