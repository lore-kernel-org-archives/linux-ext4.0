From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC v2 8/9] ext4: Make directory operations use itree
Date: Mon, 13 May 2013 17:42:09 +0200
Message-ID: <1368459730-3405-9-git-send-email-rpazdera@redhat.com>
References: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab3EMQm4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:42:56 -0400
In-Reply-To: <1368459730-3405-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds some changes to the existing directory operations so
they use the itree as well, apart from the original index tree.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d5e09eb..65312d3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2026,6 +2026,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	ext4_lblk_t  block;
 	struct fake_dirent *fde;
 	int		csum_size = 0;
+	ext4_fsblk_t	itree_root_block;
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
@@ -2058,9 +2059,11 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		brelse(bh);
 		return PTR_ERR(bh2);
 	}
+
 	ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
-	data1 = bh2->b_data;
+	ext4_set_inode_flag(dir, EXT4_INODE_ITREE);
 
+	data1 = bh2->b_data;
 	memcpy (data1, de, len);
 	de = (struct ext4_dir_entry_2 *) data1;
 	top = data1 + len;
@@ -2087,11 +2090,26 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	dx_set_count(entries, 1);
 	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
 
-	/* Initialize as for dx_probe */
 	hinfo.hash_version = root->info.hash_version;
 	if (hinfo.hash_version <= DX_HASH_TEA)
 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_ITREE)) {
+		retval = itree_init(handle, dir, &hinfo,
+				    (struct ext4_dir_entry_2 *)data1,
+				    dentry, inode, &itree_root_block);
+		if (retval)
+			return retval;
+		retval = dx_set_itree_root(dir,
+					   (struct ext4_dir_entry *)bh->b_data,
+					   itree_root_block);
+		if (retval)
+			return retval;
+	}
+
+	/* Initialize as for dx_probe */
 	ext4fs_dirhash(name, namelen, &hinfo);
 	frame = frames;
 	frame->entries = entries;
@@ -2102,7 +2120,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 	ext4_handle_dirty_dirent_node(handle, dir, bh);
 
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
+	de = do_split(handle, dir, &bh, frame, &hinfo, &retval);
 	if (!de) {
 		/*
 		 * Even if the block split failed, we have to properly write
@@ -2216,10 +2234,12 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	struct dx_frame frames[2], *frame;
 	struct dx_entry *entries, *at;
 	struct dx_hash_info hinfo;
-	struct buffer_head *bh;
+	struct buffer_head *bh = NULL;
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct super_block *sb = dir->i_sb;
+	struct ext4_dir_entry *dirent;
 	struct ext4_dir_entry_2 *de;
+	ext4_fsblk_t itree_root;
 	int err;
 
 	frame = dx_probe(&dentry->d_name, dir, &hinfo, frames, &err);
@@ -2227,6 +2247,24 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		return err;
 	entries = frame->entries;
 	at = frame->at;
+
+	/*
+	 * XXX This currently fails without any attempt to recover,
+	 * but we could also turn off the auxiliary tree and only
+	 * print a warning.
+	 */
+	if (dx_itree(dir)) {
+		dirent = (struct ext4_dir_entry *)frames[0].bh->b_data;
+		err = dx_get_itree_root(dir, dirent, &itree_root);
+		if (err)
+			goto cleanup;
+
+		err = itree_add_entry(handle, dir, itree_root,
+				      dentry, inode, hinfo.hash);
+		if (err)
+			goto cleanup;
+	}
+
 	bh = ext4_read_dirblock(dir, dx_get_block(frame->at), DIRENT);
 	if (IS_ERR(bh)) {
 		err = PTR_ERR(bh);
@@ -2947,6 +2985,12 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
+	if (dx_itree(dir)) {
+		retval = itree_delete_entry(handle, dir, dentry);
+		if (retval)
+			goto end_rmdir;
+	}
+
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_rmdir;
@@ -3016,6 +3060,11 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 			     inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
+	if (dx_itree(dir)) {
+		retval = itree_delete_entry(handle, dir, dentry);
+		if (retval)
+			goto end_unlink;
+	}
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
@@ -3355,6 +3404,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				old_dir->i_ino, old_dir->i_nlink, retval);
 	}
 
+	if (dx_itree(old_dir)) {
+		retval = itree_delete_entry(handle, old_dir, old_dentry);
+		if (retval)
+			goto end_rename;
+	}
+
 	if (new_inode) {
 		ext4_dec_count(handle, new_inode);
 		new_inode->i_ctime = ext4_current_time(new_inode);
-- 
1.7.11.7

