Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:47999 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKCZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:02:25 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 08/10] ext2: fix coding style for namei.c
Date: Tue, 13 Nov 2018 08:04:46 +0800
Message-Id: <20181113000448.16023-9-cgxu519@gmx.com>
In-Reply-To: <20181113000448.16023-1-cgxu519@gmx.com>
References: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various complains from checkpatch.pl

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/namei.c | 55 ++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0c26dcc5d850..1368324a68e8 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -53,9 +53,10 @@ static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
  * Methods themselves.
  */
 
-static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, unsigned int flags)
+static struct dentry *ext2_lookup(struct inode *dir, struct dentry *dentry,
+				  unsigned int flags)
 {
-	struct inode * inode;
+	struct inode *inode;
 	ino_t ino;
 	
 	if (dentry->d_name.len > EXT2_NAME_LEN)
@@ -92,7 +93,8 @@ struct dentry *ext2_get_parent(struct dentry *child)
  * If the create succeeds, we fill in the inode information
  * with d_instantiate(). 
  */
-static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode, bool excl)
+static int ext2_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+		       bool excl)
 {
 	struct inode *inode;
 	int err;
@@ -123,9 +125,10 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	return 0;
 }
 
-static int ext2_mknod (struct inode * dir, struct dentry *dentry, umode_t mode, dev_t rdev)
+static int ext2_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
+		      dev_t rdev)
 {
-	struct inode * inode;
+	struct inode *inode;
 	int err;
 
 	err = dquot_initialize(dir);
@@ -145,13 +148,13 @@ static int ext2_mknod (struct inode * dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
-static int ext2_symlink (struct inode * dir, struct dentry * dentry,
-	const char * symname)
+static int ext2_symlink(struct inode *dir, struct dentry *dentry,
+			const char *symname)
 {
-	struct super_block * sb = dir->i_sb;
+	struct super_block *sb = dir->i_sb;
 	int err = -ENAMETOOLONG;
 	unsigned l = strlen(symname)+1;
-	struct inode * inode;
+	struct inode *inode;
 
 	if (l > sb->s_blocksize)
 		goto out;
@@ -195,7 +198,7 @@ static int ext2_symlink (struct inode * dir, struct dentry * dentry,
 	goto out;
 }
 
-static int ext2_link (struct dentry * old_dentry, struct inode * dir,
+static int ext2_link(struct dentry *old_dentry, struct inode *dir,
 	struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
@@ -219,9 +222,9 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	return err;
 }
 
-static int ext2_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
+static int ext2_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	struct inode * inode;
+	struct inode *inode;
 	int err;
 
 	err = dquot_initialize(dir);
@@ -265,11 +268,11 @@ static int ext2_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 	goto out;
 }
 
-static int ext2_unlink(struct inode * dir, struct dentry *dentry)
+static int ext2_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct inode * inode = d_inode(dentry);
-	struct ext2_dir_entry_2 * de;
-	struct page * page;
+	struct inode *inode = d_inode(dentry);
+	struct ext2_dir_entry_2 *de;
+	struct page *page;
 	int err;
 
 	err = dquot_initialize(dir);
@@ -293,9 +296,9 @@ static int ext2_unlink(struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
+static int ext2_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	struct inode * inode = d_inode(dentry);
+	struct inode *inode = d_inode(dentry);
 	int err = -ENOTEMPTY;
 
 	if (ext2_empty_dir(inode)) {
@@ -309,16 +312,16 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	return err;
 }
 
-static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
-			struct inode * new_dir,	struct dentry * new_dentry,
+static int ext2_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
 			unsigned int flags)
 {
-	struct inode * old_inode = d_inode(old_dentry);
-	struct inode * new_inode = d_inode(new_dentry);
-	struct page * dir_page = NULL;
-	struct ext2_dir_entry_2 * dir_de = NULL;
-	struct page * old_page;
-	struct ext2_dir_entry_2 * old_de;
+	struct inode *old_inode = d_inode(old_dentry);
+	struct inode *new_inode = d_inode(new_dentry);
+	struct page *dir_page = NULL;
+	struct ext2_dir_entry_2 *dir_de = NULL;
+	struct page *old_page;
+	struct ext2_dir_entry_2 *old_de;
 	int err;
 
 	if (flags & ~RENAME_NOREPLACE)
-- 
2.17.2
