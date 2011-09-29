From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC PATCH V2 5/6] ext4: let ext4 maintian delayed extent trees
Date: Thu, 29 Sep 2011 13:08:45 +0800
Message-ID: <1317272926-13303-6-git-send-email-xiaoqiangnk@gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: jack@suse.cz, jeff.liu@oracle.com, achender@linux.vnet.ibm.com,
	adityakali@google.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33073 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1I2Gll (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 02:41:41 -0400
Received: by mail-yi0-f46.google.com with SMTP id 18so248472yib.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 23:41:40 -0700 (PDT)
In-Reply-To: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch let ext4 maintain delayed extent trees.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h     |    1 +
 fs/ext4/extents.c  |    2 ++
 fs/ext4/indirect.c |    3 +++
 fs/ext4/inode.c    |   28 ++++++++++++++++++++++++++--
 fs/ext4/super.c    |   12 +++++++++++-
 5 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d3c6b97..177ec0a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -519,6 +519,7 @@ struct ext4_new_group_data {
 #define EXT4_GET_BLOCKS_PUNCH_OUT_EXT		0x0020
 	/* Don't normalize allocation size (used for fallocate) */
 #define EXT4_GET_BLOCKS_NO_NORMALIZE		0x0040
+#define EXT4_GET_BLOCKS_DEALLOC			0x0080
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9124cd2..bdbb984 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3688,6 +3688,8 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
+	err = ext4_de_remove_space(inode, last_block,
+				   EXT_MAX_BLOCKS - last_block);
 	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 0962642..25cdb5b 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include "ext4_jbd2.h"
+#include "ext4_extents.h"
 #include "truncate.h"
 
 #include <trace/events/ext4.h>
@@ -1383,6 +1384,8 @@ void ext4_ind_truncate(struct inode *inode)
 	down_write(&ei->i_data_sem);
 
 	ext4_discard_preallocations(inode);
+	ext4_de_remove_space(inode, last_block,
+			     EXT_MAX_BLOCKS - last_block);
 
 	/*
 	 * The orphan list entry will now protect us from any crash which
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f86b149..0f9f108 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -442,7 +442,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
-		int ret = check_block_validity(inode, map);
+		int ret;
+		if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
+			/* delayed alloc may be allocated by fallocate,
+			 * we need to handle delayed extent here.
+			 */
+			down_write((&EXT4_I(inode)->i_data_sem));
+			goto delayed_mapped;
+		}
+		ret = check_block_validity(inode, map);
 		if (ret != 0)
 			return ret;
 	}
@@ -517,8 +525,18 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
 			ext4_da_update_reserve_space(inode, retval, 1);
 	}
-	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
 		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
+delayed_mapped:
+		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
+			int ret;
+			/* delayed allocation blocks has been allocated */
+			ret = ext4_de_remove_space(inode, map->m_lblk,
+						   map->m_len);
+			if (ret < 0)
+				retval = ret;
+		}
+	}
 
 	up_write((&EXT4_I(inode)->i_data_sem));
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
@@ -1630,6 +1648,12 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			/* not enough space to reserve */
 			return ret;
 
+		down_write((&EXT4_I(inode)->i_data_sem));
+		ret = ext4_de_add_space(inode, map.m_lblk, map.m_len);
+		up_write((&EXT4_I(inode)->i_data_sem));
+		if (ret)
+			return ret;
+
 		map_bh(bh, inode->i_sb, invalid_block);
 		set_buffer_new(bh);
 		set_buffer_delay(bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 247fcdd..a248551 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -49,6 +49,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "ext4_extents.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -967,6 +968,7 @@ void ext4_clear_inode(struct inode *inode)
 	end_writeback(inode);
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
+	ext4_de_remove_space(inode, 0, EXT_MAX_BLOCKS);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
@@ -4976,9 +4978,14 @@ static int __init ext4_init_fs(void)
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
 		goto out7;
@@ -5030,6 +5037,9 @@ out6:
 	ext4_exit_system_zone();
 out7:
 	ext4_exit_pageio();
+out8:
+	ext4_exit_de();
+
 	return err;
 }
 
-- 
1.7.5.1

