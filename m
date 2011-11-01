From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 6/8 bigalloc] ext4: directories allocate a cluster when it need spaces
Date: Tue,  1 Nov 2011 18:53:35 +0800
Message-ID: <1320144817-16397-7-git-send-email-hao.bigrat@gmail.com>
References: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55262 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1KAKyF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 06:54:05 -0400
Received: by ggnb1 with SMTP id b1so6909337ggn.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Nov 2011 03:54:04 -0700 (PDT)
In-Reply-To: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

allocate a cluster instead of a block when directories need new space.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/namei.c |   54 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..e8618ea 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -49,6 +49,16 @@
 #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
 #define NAMEI_RA_INDEX(c,b)  (((c) * NAMEI_RA_BLOCKS) + (b))
 
+static void ext4_zero_append(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, ext4_lblk_t block)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+	if ((sbi->s_cluster_ratio > 1) &&
+				(block % sbi->s_cluster_ratio))
+		memset(bh->b_data, 0, inode->i_sb->s_blocksize);
+}
+
 static struct buffer_head *ext4_append(handle_t *handle,
 					struct inode *inode,
 					ext4_lblk_t *block, int *err)
@@ -59,6 +69,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
 
 	bh = ext4_bread(handle, inode, *block, 1, err);
 	if (bh) {
+		ext4_zero_append(handle, inode, bh, *block);
 		inode->i_size += inode->i_sb->s_blocksize;
 		EXT4_I(inode)->i_disksize = inode->i_size;
 		*err = ext4_journal_get_write_access(handle, bh);
@@ -1811,10 +1822,12 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	handle_t *handle;
 	struct inode *inode;
-	struct buffer_head *dir_block = NULL;
+	struct buffer_head *first_block = NULL;
+	struct buffer_head *dir_block[EXT4_MAX_CTXT_PAGES];
 	struct ext4_dir_entry_2 *de;
+	struct ext4_sb_info *sbi = EXT4_SB(dir->i_sb);
 	unsigned int blocksize = dir->i_sb->s_blocksize;
-	int err, retries = 0;
+	int i, err, retries = 0;
 
 	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
@@ -1824,6 +1837,7 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+					sbi->s_cluster_ratio +
 					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -1840,14 +1854,20 @@ retry:
 	inode->i_op = &ext4_dir_inode_operations;
 	inode->i_fop = &ext4_dir_operations;
 	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-	dir_block = ext4_bread(handle, inode, 0, 1, &err);
-	if (!dir_block)
-		goto out_clear_inode;
-	BUFFER_TRACE(dir_block, "get_write_access");
-	err = ext4_journal_get_write_access(handle, dir_block);
-	if (err)
-		goto out_clear_inode;
-	de = (struct ext4_dir_entry_2 *) dir_block->b_data;
+
+	for (i = 0; i < sbi->s_cluster_ratio; i++) {
+		dir_block[i] = ext4_bread(handle, inode, i, 1, &err);
+		if (!dir_block[i])
+			goto out_clear_inode;
+		BUFFER_TRACE(dir_block[i], "get_write_access");
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
@@ -1862,10 +1882,13 @@ retry:
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
@@ -1885,7 +1908,8 @@ out_clear_inode:
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 out_stop:
-	brelse(dir_block);
+	for (i = 0; i < sbi->s_cluster_ratio; i++)
+		brelse(dir_block[i]);
 	ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
-- 
1.7.3.2

