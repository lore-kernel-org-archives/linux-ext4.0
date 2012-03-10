From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 4/6] Rename de patch4 from de to se scheme
Date: Fri,  9 Mar 2012 21:41:23 -0700
Message-ID: <1331354485-18515-5-git-send-email-achender@linux.vnet.ibm.com>
References: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46089 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2CJEkz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 23:40:55 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 21:40:54 -0700
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E58D53E40047
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 21:40:51 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2A4epfm200450
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:51 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2A4eorm030558
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:51 -0700
In-Reply-To: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renames changes introduced by patch
"[PATCH_V3_4_6]_ext4_let_ext4_maintian_delayed_extent_trees"

All code referencing "delayed extents" or "de" are changed to
"status extents" or "se"

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 de902cd... a8b382e... M	fs/ext4/extents.c
:100644 100644 f5f61b28.. 47d78b8... M	fs/ext4/indirect.c
:100644 100644 69f9249... af32ea6... M	fs/ext4/inode.c
:100644 100644 e6e2415... d1a438b... M	fs/ext4/super.c
 fs/ext4/extents.c  |    2 +-
 fs/ext4/indirect.c |    2 +-
 fs/ext4/inode.c    |    4 ++--
 fs/ext4/super.c    |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index de902cd..a8b382e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4142,7 +4142,7 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
-	err = ext4_de_remove_space(inode, last_block,
+	err = ext4_se_remove_space(inode, last_block,
 				   EXT_MAX_BLOCKS - last_block);
 	err = ext4_ext_remove_space(inode, last_block);
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index f5f61b2..47d78b8 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1400,7 +1400,7 @@ void ext4_ind_truncate(struct inode *inode)
 	down_write(&ei->i_data_sem);
 
 	ext4_discard_preallocations(inode);
-	ext4_de_remove_space(inode, last_block,
+	ext4_se_remove_space(inode, last_block,
 			     EXT_MAX_BLOCKS - last_block);
 
 	/*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 69f9249..af32ea6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -532,7 +532,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			int ret;
 delayed_mapped:
 			/* delayed allocation blocks has been allocated */
-			ret = ext4_de_remove_space(inode, map->m_lblk,
+			ret = ext4_se_remove_space(inode, map->m_lblk,
 						   map->m_len);
 			if (ret < 0)
 				retval = ret;
@@ -1683,7 +1683,7 @@ out_unlock:
 
 	if (retval ==0) {
 		down_write((&EXT4_I(inode)->i_data_sem));
-		ret = ext4_de_add_space(inode, map->m_lblk, map->m_len);
+		ret = ext4_se_add_space(inode, map->m_lblk, map->m_len);
 		up_write((&EXT4_I(inode)->i_data_sem));
 		if (ret)
 			return ret;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e6e2415..d1a438b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -984,7 +984,7 @@ void ext4_clear_inode(struct inode *inode)
 	end_writeback(inode);
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
-	ext4_de_remove_space(inode, 0, EXT_MAX_BLOCKS);
+	ext4_se_remove_space(inode, 0, EXT_MAX_BLOCKS);
 	if (EXT4_I(inode)->jinode) {
 		jbd2_journal_release_jbd_inode(EXT4_JOURNAL(inode),
 					       EXT4_I(inode)->jinode);
@@ -5068,7 +5068,7 @@ static int __init ext4_init_fs(void)
 		init_waitqueue_head(&ext4__ioend_wq[i]);
 	}
 
-	err = ext4_init_de();
+	err = ext4_init_se();
 	if (err)
 		return err;
 
@@ -5128,7 +5128,7 @@ out6:
 out7:
 	ext4_exit_pageio();
 out8:
-	ext4_exit_de();
+	ext4_exit_se();
 
 	return err;
 }
-- 
1.7.1

