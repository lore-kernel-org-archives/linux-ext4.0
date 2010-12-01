From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: Automatically allocate delay allocated blocks before rename
Date: Wed, 01 Dec 2010 14:11:14 +0300
Message-ID: <87wrntsq7h.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37005 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0LALLS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 06:11:18 -0500
Received: by eye27 with SMTP id 27so3365421eye.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Dec 2010 03:11:17 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Ext4 already performs block allocation on rename, but it does it after
rename was complete, so race window is much tighter but still exist.
In order to guarantee atomic behavior let's force block allocation before
actual rename. This rearrangement should not affect IO performance.

- Code cleanup: It is possible to move some checks out of transaction
  which theoretically may result in better performance.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/namei.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92203b8..7fe187f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2333,7 +2333,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh, *dir_bh;
 	struct ext4_dir_entry_2 *old_de, *new_de;
-	int retval, force_da_alloc = 0;
+	int retval;
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -2344,14 +2344,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * in separate transaction */
 	if (new_dentry->d_inode)
 		dquot_initialize(new_dentry->d_inode);
-	handle = ext4_journal_start(old_dir, 2 *
-					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
-					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
-
-	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
-		ext4_handle_sync(handle);
 
 	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de);
 	/*
@@ -2363,7 +2355,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode = old_dentry->d_inode;
 	retval = -ENOENT;
 	if (!old_bh || le32_to_cpu(old_de->inode) != old_inode->i_ino)
-		goto end_rename;
+		goto out_release;
 
 	new_inode = new_dentry->d_inode;
 	new_bh = ext4_find_entry(new_dir, &new_dentry->d_name, &new_de);
@@ -2373,6 +2365,19 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			new_bh = NULL;
 		}
 	}
+
+	if (!test_opt(new_dir->i_sb, NO_AUTO_DA_ALLOC) && new_inode)
+ 		ext4_alloc_da_blocks(old_inode);
+
+	handle = ext4_journal_start(old_dir, 2 *
+					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
+		ext4_handle_sync(handle);
+
 	if (S_ISDIR(old_inode->i_mode)) {
 		if (new_inode) {
 			retval = -ENOTEMPTY;
@@ -2476,18 +2481,15 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ext4_mark_inode_dirty(handle, new_inode);
 		if (!new_inode->i_nlink)
 			ext4_orphan_add(handle, new_inode);
-		if (!test_opt(new_dir->i_sb, NO_AUTO_DA_ALLOC))
-			force_da_alloc = 1;
 	}
 	retval = 0;
 
 end_rename:
+	ext4_journal_stop(handle);
+out_release:
 	brelse(dir_bh);
 	brelse(old_bh);
 	brelse(new_bh);
-	ext4_journal_stop(handle);
-	if (retval == 0 && force_da_alloc)
-		ext4_alloc_da_blocks(old_inode);
 	return retval;
 }
 
-- 
1.7.2.3

