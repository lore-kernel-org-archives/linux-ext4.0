From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 7/9 bigalloc] ext4: allocate a cluster for a directory when it need spaces
Date: Wed,  9 Nov 2011 19:17:06 +0800
Message-ID: <1320837428-8516-8-git-send-email-hao.bigrat@gmail.com>
References: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56031 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1KILRk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 06:17:40 -0500
Received: by mail-yx0-f174.google.com with SMTP id r9so558061yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 03:17:39 -0800 (PST)
In-Reply-To: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/inode.c |    9 +++++++++
 fs/ext4/namei.c |   46 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index be922ae..69d0031 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -673,6 +673,15 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
+	/* if the block has been allocated by cluster,
+	 * do not need to read it
+	 */
+	if ((EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) &&
+		((block << inode->i_sb->s_blocksize_bits) >= inode->i_size)) {
+		memset(bh->b_data, 0, inode->i_sb->s_blocksize);
+		set_buffer_uptodate(bh);
+		return bh;
+	}
 	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..43f7dcb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1811,10 +1811,12 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	handle_t *handle;
 	struct inode *inode;
-	struct buffer_head *dir_block = NULL;
+	struct buffer_head *first_block = NULL;
+	struct buffer_head **dir_block = NULL;
 	struct ext4_dir_entry_2 *de;
+	struct ext4_sb_info *sbi = EXT4_SB(dir->i_sb);
 	unsigned int blocksize = dir->i_sb->s_blocksize;
-	int err, retries = 0;
+	int i, err, retries = 0;
 
 	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
@@ -1824,6 +1826,7 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+					sbi->s_cluster_ratio +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -1840,14 +1843,24 @@ retry:
 	inode->i_op = &ext4_dir_inode_operations;
 	inode->i_fop = &ext4_dir_operations;
 	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext4_bread(handle, inode, 0, 1, &err);
+
+	dir_block = kzalloc(sizeof(struct buffer_head *) * EXT4_MAX_CTXT_PAGES,
+			GFP_NOFS);
 	if (!dir_block)
-		goto out_clear_inode;
-	BUFFER_TRACE(dir_block, "get_write_access");
-	err = ext4_journal_get_write_access(handle, dir_block);
-	if (err)
-		goto out_clear_inode;
-	de = (struct ext4_dir_entry_2 *) dir_block->b_data;
+		goto out_stop;
+
+	for (i = 0; i < sbi->s_cluster_ratio; i++) {
+		dir_block[i] = ext4_getblk(handle, inode, i, 1, &err);
+		if (!dir_block[i])
+			goto out_clear_inode;
+		memset(dir_block[i]->b_data, 0, inode->i_sb->s_blocksize);
+		set_buffer_uptodate(dir_block[i]);
+		err = ext4_journal_get_write_access(handle, dir_block[i]);
+		if (err)
+			goto out_clear_inode;
+	}
+	first_block = dir_block[0];
+	de = (struct ext4_dir_entry_2 *) first_block->b_data;
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
 	de->rec_len = ext4_rec_len_to_disk(EXT4_DIR_REC_LEN(de->name_len),
@@ -1862,10 +1875,13 @@ retry:
 	strcpy(de->name, "..");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
-	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
-	if (err)
-		goto out_clear_inode;
+	BUFFER_TRACE(first_block, "call ext4_handle_dirty_metadata");
+
+	for (i = 0; i < sbi->s_cluster_ratio; i++) {
+		err = ext4_handle_dirty_metadata(handle, dir, dir_block[i]);
+		if (err)
+			goto out_clear_inode;
+	}
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (!err)
 		err = ext4_add_entry(handle, dentry, inode);
@@ -1885,7 +1901,9 @@ out_clear_inode:
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 out_stop:
-	brelse(dir_block);
+	for (i = 0; i < sbi->s_cluster_ratio; i++)
+		brelse(dir_block[i]);
+	kfree(dir_block);
 	ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
-- 
1.7.3.2

