From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] ext4: propagate errors up to ext4_find_entry()'s callers
Date: Fri, 22 Aug 2014 03:29:45 -0400
Message-ID: <1408692590-13346-2-git-send-email-tytso@mit.edu>
References: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44050 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbaHVHaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 03:30:01 -0400
In-Reply-To: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we run into some kind of error, such as ENOMEM, while calling
ext4_getblk() or ext4_dx_find_entry(), we need to make sure this error
gets propagated up to ext4_find_entry() and then to its callers.  This
way, transient errors such as ENOMEM can get propagated to the VFS.
This is important so that the system calls return the appropriate
error, and also so that in the case of ext4_lookup(), we return an
error instead of a NULL inode, since that will result in a negative
dentry cache entry that will stick around long past the OOM condition
which caused a transient ENOMEM error.

Addresses-Google-Bug: #17142205

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/namei.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b147a67..ae7088b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1227,7 +1227,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 				   buffer */
 	int num = 0;
 	ext4_lblk_t  nblocks;
-	int i, err;
+	int i, err = 0;
 	int namelen;
 
 	*res_dir = NULL;
@@ -1264,7 +1264,11 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		 * return.  Otherwise, fall back to doing a search the
 		 * old fashioned way.
 		 */
-		if (bh || (err != ERR_BAD_DX_DIR))
+		if (err == -ENOENT)
+			return NULL;
+		if (err && err != ERR_BAD_DX_DIR)
+			return ERR_PTR(err);
+		if (bh)
 			return bh;
 		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
 			       "falling back\n"));
@@ -1295,6 +1299,11 @@ restart:
 				}
 				num++;
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
+				if (unlikely(err)) {
+					if (ra_max == 0)
+						return ERR_PTR(err);
+					break;
+				}
 				bh_use[ra_max] = bh;
 				if (bh)
 					ll_rw_block(READ | REQ_META | REQ_PRIO,
@@ -1417,6 +1426,8 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 		return ERR_PTR(-ENAMETOOLONG);
 
 	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	if (IS_ERR(bh))
+		return (struct dentry *) bh;
 	inode = NULL;
 	if (bh) {
 		__u32 ino = le32_to_cpu(de->inode);
@@ -1450,6 +1461,8 @@ struct dentry *ext4_get_parent(struct dentry *child)
 	struct buffer_head *bh;
 
 	bh = ext4_find_entry(child->d_inode, &dotdot, &de, NULL);
+	if (IS_ERR(bh))
+		return (struct dentry *) bh;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
 	ino = le32_to_cpu(de->inode);
@@ -2727,6 +2740,8 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2794,6 +2809,8 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	if (!bh)
 		goto end_unlink;
 
@@ -3121,6 +3138,8 @@ static int ext4_find_delete_entry(handle_t *handle, struct inode *dir,
 	struct ext4_dir_entry_2 *de;
 
 	bh = ext4_find_entry(dir, d_name, &de, NULL);
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	if (bh) {
 		retval = ext4_delete_entry(handle, dir, de, bh);
 		brelse(bh);
@@ -3202,6 +3221,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		dquot_initialize(new.inode);
 
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	if (IS_ERR(old.bh))
+		return PTR_ERR(old.bh);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3214,6 +3235,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
+	if (IS_ERR(new.bh)) {
+		retval = PTR_ERR(new.bh);
+		goto end_rename;
+	}
 	if (new.bh) {
 		if (!new.inode) {
 			brelse(new.bh);
@@ -3330,6 +3355,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
 				 &old.de, &old.inlined);
+	if (IS_ERR(old.bh))
+		return PTR_ERR(old.bh);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3342,6 +3369,10 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
 				 &new.de, &new.inlined);
+	if (IS_ERR(new.bh)) {
+		retval = PTR_ERR(new.bh);
+		goto end_rename;
+	}
 
 	/* RENAME_EXCHANGE case: old *and* new must both exist */
 	if (!new.bh || le32_to_cpu(new.de->inode) != new.inode->i_ino)
-- 
2.1.0

