From: Jan Kara <jack@suse.com>
Subject: [PATCH 6/6] reiserfs: Handle error from dquot_initialize()
Date: Wed, 15 Jul 2015 14:42:32 +0200
Message-ID: <1436964152-11203-7-git-send-email-jack@suse.com>
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
 fs/reiserfs/inode.c |  7 ++++--
 fs/reiserfs/namei.c | 63 ++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index f6f2fbad9777..3d8e7e671d5b 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3319,8 +3319,11 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 	/* must be turned off for recursive notify_change calls */
 	ia_valid = attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
 
-	if (is_quota_modification(inode, attr))
-		dquot_initialize(inode);
+	if (is_quota_modification(inode, attr)) {
+		error = dquot_initialize(inode);
+		if (error)
+			return error;
+	}
 	reiserfs_write_lock(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/*
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b55a074653d7..5f1c9c29eb8c 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -613,8 +613,7 @@ static int new_inode_init(struct inode *inode, struct inode *dir, umode_t mode)
 	 * we have to set uid and gid here
 	 */
 	inode_init_owner(inode, dir, mode);
-	dquot_initialize(inode);
-	return 0;
+	return dquot_initialize(inode);
 }
 
 static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
@@ -633,12 +632,18 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mod
 	struct reiserfs_transaction_handle th;
 	struct reiserfs_security_handle security;
 
-	dquot_initialize(dir);
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
 
 	if (!(inode = new_inode(dir->i_sb))) {
 		return -ENOMEM;
 	}
-	new_inode_init(inode, dir, mode);
+	retval = new_inode_init(inode, dir, mode);
+	if (retval) {
+		drop_new_inode(inode);
+		return retval;
+	}
 
 	jbegin_count += reiserfs_cache_default_acl(dir);
 	retval = reiserfs_security_init(dir, inode, &dentry->d_name, &security);
@@ -710,12 +715,18 @@ static int reiserfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	dquot_initialize(dir);
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
 
 	if (!(inode = new_inode(dir->i_sb))) {
 		return -ENOMEM;
 	}
-	new_inode_init(inode, dir, mode);
+	retval = new_inode_init(inode, dir, mode);
+	if (retval) {
+		drop_new_inode(inode);
+		return retval;
+	}
 
 	jbegin_count += reiserfs_cache_default_acl(dir);
 	retval = reiserfs_security_init(dir, inode, &dentry->d_name, &security);
@@ -787,7 +798,9 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
 	    2 * (REISERFS_QUOTA_INIT_BLOCKS(dir->i_sb) +
 		 REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb));
 
-	dquot_initialize(dir);
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
 
 #ifdef DISPLACE_NEW_PACKING_LOCALITIES
 	/*
@@ -800,7 +813,11 @@ static int reiserfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
 	if (!(inode = new_inode(dir->i_sb))) {
 		return -ENOMEM;
 	}
-	new_inode_init(inode, dir, mode);
+	retval = new_inode_init(inode, dir, mode);
+	if (retval) {
+		drop_new_inode(inode);
+		return retval;
+	}
 
 	jbegin_count += reiserfs_cache_default_acl(dir);
 	retval = reiserfs_security_init(dir, inode, &dentry->d_name, &security);
@@ -899,7 +916,9 @@ static int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
 	    JOURNAL_PER_BALANCE_CNT * 2 + 2 +
 	    4 * REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb);
 
-	dquot_initialize(dir);
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
 
 	reiserfs_write_lock(dir->i_sb);
 	retval = journal_begin(&th, dir->i_sb, jbegin_count);
@@ -985,7 +1004,9 @@ static int reiserfs_unlink(struct inode *dir, struct dentry *dentry)
 	int jbegin_count;
 	unsigned long savelink;
 
-	dquot_initialize(dir);
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
 
 	inode = d_inode(dentry);
 
@@ -1095,12 +1116,18 @@ static int reiserfs_symlink(struct inode *parent_dir,
 	    2 * (REISERFS_QUOTA_INIT_BLOCKS(parent_dir->i_sb) +
 		 REISERFS_QUOTA_TRANS_BLOCKS(parent_dir->i_sb));
 
-	dquot_initialize(parent_dir);
+	retval = dquot_initialize(parent_dir);
+	if (retval)
+		return retval;
 
 	if (!(inode = new_inode(parent_dir->i_sb))) {
 		return -ENOMEM;
 	}
-	new_inode_init(inode, parent_dir, mode);
+	retval = new_inode_init(inode, parent_dir, mode);
+	if (retval) {
+		drop_new_inode(inode);
+		return retval;
+	}
 
 	retval = reiserfs_security_init(parent_dir, inode, &dentry->d_name,
 					&security);
@@ -1184,7 +1211,9 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 	    JOURNAL_PER_BALANCE_CNT * 3 +
 	    2 * REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb);
 
-	dquot_initialize(dir);
+	retval = dquot_initialize(dir);
+	if (retval)
+		return retval;
 
 	reiserfs_write_lock(dir->i_sb);
 	if (inode->i_nlink >= REISERFS_LINK_MAX) {
@@ -1308,8 +1337,12 @@ static int reiserfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    JOURNAL_PER_BALANCE_CNT * 3 + 5 +
 	    4 * REISERFS_QUOTA_TRANS_BLOCKS(old_dir->i_sb);
 
-	dquot_initialize(old_dir);
-	dquot_initialize(new_dir);
+	retval = dquot_initialize(old_dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(new_dir);
+	if (retval)
+		return retval;
 
 	old_inode = d_inode(old_dentry);
 	new_dentry_inode = d_inode(new_dentry);
-- 
2.1.4

