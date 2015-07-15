From: Jan Kara <jack@suse.com>
Subject: [PATCH 2/6] ext2: Handle error from dquot_initalize()
Date: Wed, 15 Jul 2015 14:42:28 +0200
Message-ID: <1436964152-11203-3-git-send-email-jack@suse.com>
References: <1436964152-11203-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Mark Fasheh <mfasheh@suse.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1436964152-11203-1-git-send-email-jack@suse.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

dquot_initialize() can now return error. Handle it where possible.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext2/ialloc.c |  5 ++++-
 fs/ext2/inode.c  |  7 +++++--
 fs/ext2/namei.c  | 46 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 5c04a0ddea80..efe5fb21c533 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -577,7 +577,10 @@ got:
 		goto fail;
 	}
 
-	dquot_initialize(inode);
+	err = dquot_initialize(inode);
+	if (err)
+		goto fail_drop;
+
 	err = dquot_alloc_inode(inode);
 	if (err)
 		goto fail_drop;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 5c09776d347f..a3a404c5df2e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1552,8 +1552,11 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (error)
 		return error;
 
-	if (is_quota_modification(inode, iattr))
-		dquot_initialize(inode);
+	if (is_quota_modification(inode, iattr)) {
+		error = dquot_initialize(inode);
+		if (error)
+			return error;
+	}
 	if ((iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)) ||
 	    (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))) {
 		error = dquot_transfer(inode, iattr);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 13ec54a99c96..b4841e3066a5 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -96,8 +96,11 @@ struct dentry *ext2_get_parent(struct dentry *child)
 static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode, bool excl)
 {
 	struct inode *inode;
+	int err;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	inode = ext2_new_inode(dir, mode, &dentry->d_name);
 	if (IS_ERR(inode))
@@ -143,7 +146,9 @@ static int ext2_mknod (struct inode * dir, struct dentry *dentry, umode_t mode,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	inode = ext2_new_inode (dir, mode, &dentry->d_name);
 	err = PTR_ERR(inode);
@@ -169,7 +174,9 @@ static int ext2_symlink (struct inode * dir, struct dentry * dentry,
 	if (l > sb->s_blocksize)
 		goto out;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		goto out;
 
 	inode = ext2_new_inode (dir, S_IFLNK | S_IRWXUGO, &dentry->d_name);
 	err = PTR_ERR(inode);
@@ -212,7 +219,9 @@ static int ext2_link (struct dentry * old_dentry, struct inode * dir,
 	struct inode *inode = d_inode(old_dentry);
 	int err;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	inode->i_ctime = CURRENT_TIME_SEC;
 	inode_inc_link_count(inode);
@@ -233,7 +242,9 @@ static int ext2_mkdir(struct inode * dir, struct dentry * dentry, umode_t mode)
 	struct inode * inode;
 	int err;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	inode_inc_link_count(dir);
 
@@ -279,13 +290,17 @@ static int ext2_unlink(struct inode * dir, struct dentry *dentry)
 	struct inode * inode = d_inode(dentry);
 	struct ext2_dir_entry_2 * de;
 	struct page * page;
-	int err = -ENOENT;
+	int err;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		goto out;
 
 	de = ext2_find_entry (dir, &dentry->d_name, &page);
-	if (!de)
+	if (!de) {
+		err = -ENOENT;
 		goto out;
+	}
 
 	err = ext2_delete_entry (de, page);
 	if (err)
@@ -323,14 +338,21 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct ext2_dir_entry_2 * dir_de = NULL;
 	struct page * old_page;
 	struct ext2_dir_entry_2 * old_de;
-	int err = -ENOENT;
+	int err;
+
+	err = dquot_initialize(old_dir);
+	if (err)
+		goto out;
 
-	dquot_initialize(old_dir);
-	dquot_initialize(new_dir);
+	err = dquot_initialize(new_dir);
+	if (err)
+		goto out;
 
 	old_de = ext2_find_entry (old_dir, &old_dentry->d_name, &old_page);
-	if (!old_de)
+	if (!old_de) {
+		err = -ENOENT;
 		goto out;
+	}
 
 	if (S_ISDIR(old_inode->i_mode)) {
 		err = -EIO;
-- 
2.1.4

