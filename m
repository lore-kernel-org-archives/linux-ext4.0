From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ext4: let ext4 maintian status extent trees
Date: Wed, 18 Apr 2012 00:07:16 -0700
Message-ID: <1334732838-25102-5-git-send-email-achender@linux.vnet.ibm.com>
References: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33956 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2DRHGM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2012 03:06:12 -0400
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 18 Apr 2012 03:06:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 2AF6B38C8059
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 03:06:08 -0400 (EDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3I767QY338266
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 03:06:07 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3I76coL005481
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:39 -0600
In-Reply-To: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch let ext4 maintain status extent trees.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 ad39627... 2322ff8... M	fs/ext4/extents.c
:100644 100644 3cfc73f... 47d78b8... M	fs/ext4/indirect.c
:100644 100644 1380cd2... adeae2f... M	fs/ext4/inode.c
:100644 100644 da223a1... d1a438b... M	fs/ext4/super.c
 fs/ext4/extents.c  |    2 ++
 fs/ext4/indirect.c |    3 +++
 fs/ext4/inode.c    |   30 ++++++++++++++++++++++++++++--
 fs/ext4/super.c    |   12 +++++++++++-
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad39627..2322ff8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4227,6 +4227,8 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
+	err = ext4_se_remove_space(inode, last_block,
+				   EXT_MAX_BLOCKS - last_block);
 	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3cfc73f..47d78b8 100644
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
+	ext4_se_remove_space(inode, last_block,
+			     EXT_MAX_BLOCKS - last_block);
 
 	/*
 	 * The orphan list entry will now protect us from any crash which
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1380cd2..adeae2f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -484,7 +484,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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
@@ -566,8 +575,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		 * set the BH_Da_Mapped bit on them. Its important to do this
 		 * under the protection of i_data_sem.
 		 */
-		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
+		if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
+			int ret;
 			set_buffers_da_mapped(inode, map);
+delayed_mapped:
+			/* delayed allocation blocks has been allocated */
+			ret = ext4_se_remove_space(inode, map->m_lblk,
+						   map->m_len);
+			if (ret < 0)
+				retval = ret;
+		}
 	}
 
 	up_write((&EXT4_I(inode)->i_data_sem));
@@ -1668,6 +1685,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 			      struct buffer_head *bh)
 {
 	int retval;
+	int ret;
 	sector_t invalid_block = ~((sector_t) 0xffff);
 
 	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
@@ -1714,6 +1732,14 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 out_unlock:
 	up_read((&EXT4_I(inode)->i_data_sem));
 
+	if (retval == 0) {
+		down_write((&EXT4_I(inode)->i_data_sem));
+		ret = ext4_se_add_space(inode, map->m_lblk, map->m_len);
+		up_write((&EXT4_I(inode)->i_data_sem));
+		if (ret)
+			return ret;
+	}
+
 	return retval;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index da223a1..d1a438b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -49,6 +49,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "ext4_extents.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -983,6 +984,7 @@ void ext4_clear_inode(struct inode *inode)
 	end_writeback(inode);
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
+	ext4_se_remove_space(inode, 0, EXT_MAX_BLOCKS);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
@@ -5066,9 +5068,14 @@ static int __init ext4_init_fs(void)
 		init_waitqueue_head(&ext4__ioend_wq[i]);
 	}
 
-	err = ext4_init_pageio();
+	err = ext4_init_se();
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
@@ -5120,6 +5127,9 @@ out6:
 	ext4_exit_system_zone();
 out7:
 	ext4_exit_pageio();
+out8:
+	ext4_exit_se();
+
 	return err;
 }
 
-- 
1.7.1

