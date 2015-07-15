From: Jan Kara <jack@suse.com>
Subject: [PATCH 3/6] ext4: Handle error from dquot_initialize()
Date: Wed, 15 Jul 2015 14:42:29 +0200
Message-ID: <1436964152-11203-4-git-send-email-jack@suse.com>
References: <1436964152-11203-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Mark Fasheh <mfasheh@suse.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1436964152-11203-1-git-send-email-jack@suse.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

dquot_initialize() can now return error. Handle it where possible.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/ialloc.c |  6 ++++--
 fs/ext4/inode.c  |  7 +++++--
 fs/ext4/namei.c  | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 173c1ae21395..619bfc1fda8c 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -721,7 +721,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	struct ext4_group_desc *gdp = NULL;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int ret2, err = 0;
+	int ret2, err;
 	struct inode *ret;
 	ext4_group_t i;
 	ext4_group_t flex_group;
@@ -769,7 +769,9 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		inode->i_gid = dir->i_gid;
 	} else
 		inode_init_owner(inode, dir, mode);
-	dquot_initialize(inode);
+	err = dquot_initialize(inode);
+	if (err)
+		goto out;
 
 	if (!goal)
 		goal = sbi->s_inode_goal;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cecf9aa10811..fed7ee7ea6e8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4661,8 +4661,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		return error;
 
-	if (is_quota_modification(inode, attr))
-		dquot_initialize(inode);
+	if (is_quota_modification(inode, attr)) {
+		error = dquot_initialize(inode);
+		if (error)
+			return error;
+	}
 	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
 	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
 		handle_t *handle;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 011dcfb5cce3..d3ff83742a33 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2436,7 +2436,9 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	struct inode *inode;
 	int err, credits, retries = 0;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	credits = (EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3);
@@ -2470,7 +2472,9 @@ static int ext4_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	credits = (EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3);
@@ -2499,7 +2503,9 @@ static int ext4_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct inode *inode;
 	int err, retries = 0;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 retry:
 	inode = ext4_new_inode_start_handle(dir, mode,
@@ -2612,7 +2618,9 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	credits = (EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3);
@@ -2910,8 +2918,12 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
-	dquot_initialize(dir);
-	dquot_initialize(d_inode(dentry));
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(d_inode(dentry));
+	if (retval)
+		return retval;
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
@@ -2980,8 +2992,12 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	trace_ext4_unlink_enter(dir, dentry);
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
-	dquot_initialize(dir);
-	dquot_initialize(d_inode(dentry));
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(d_inode(dentry));
+	if (retval)
+		return retval;
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
@@ -3066,7 +3082,9 @@ static int ext4_symlink(struct inode *dir,
 		goto err_free_sd;
 	}
 
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 	if ((disk_link.len > EXT4_N_BLOCKS * 4)) {
 		/*
@@ -3197,7 +3215,9 @@ static int ext4_link(struct dentry *old_dentry,
 	if (ext4_encrypted_inode(dir) &&
 	    !ext4_is_child_context_consistent_with_parent(dir, inode))
 		return -EPERM;
-	dquot_initialize(dir);
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
 
 retry:
 	handle = ext4_journal_start(dir, EXT4_HT_DIR,
@@ -3476,13 +3496,20 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int credits;
 	u8 old_file_type;
 
-	dquot_initialize(old.dir);
-	dquot_initialize(new.dir);
+	retval = dquot_initialize(old.dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(new.dir);
+	if (retval)
+		return retval;
 
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
-	if (new.inode)
-		dquot_initialize(new.inode);
+	if (new.inode) {
+		retval = dquot_initialize(new.inode);
+		if (retval)
+			return retval;
+	}
 
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
 	if (IS_ERR(old.bh))
@@ -3678,8 +3705,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 							   new.inode)))
 		return -EPERM;
 
-	dquot_initialize(old.dir);
-	dquot_initialize(new.dir);
+	retval = dquot_initialize(old.dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(new.dir);
+	if (retval)
+		return retval;
 
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name,
 				 &old.de, &old.inlined);
-- 
2.1.4

