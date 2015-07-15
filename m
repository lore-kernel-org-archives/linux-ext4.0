From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH] dquot_initialize() can now return error. Handle it where
 possible
Date: Wed, 15 Jul 2015 13:53:19 -0500
Message-ID: <55A6AC1F.3070400@oracle.com>
References: <1436964152-11203-1-git-send-email-jack@suse.com>
 <1436964152-11203-6-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Mark Fasheh <mfasheh@suse.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org
To: Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1436964152-11203-6-git-send-email-jack@suse.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Slightly modified by Dave Kleikamp due to needed jfs_rename() error path fix.

Signed-off-by: Jan Kara <jack@suse.com>
Reviewed-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/jfs/file.c      |  7 +++++--
 fs/jfs/jfs_inode.c |  4 +++-
 fs/jfs/namei.c     | 54 ++++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index e98d39d..34ad63ea0 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -107,8 +107,11 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (rc)
 		return rc;
 
-	if (is_quota_modification(inode, iattr))
-		dquot_initialize(inode);
+	if (is_quota_modification(inode, iattr)) {
+		rc = dquot_initialize(inode);
+		if (rc)
+			return rc;
+	}
 	if ((iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)) ||
 	    (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))) {
 		rc = dquot_transfer(inode, iattr);
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index 6b0f816..cf7936f 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -109,7 +109,9 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 	/*
 	 * Allocate inode to quota.
 	 */
-	dquot_initialize(inode);
+	rc = dquot_initialize(inode);
+	if (rc)
+		goto fail_drop;
 	rc = dquot_alloc_inode(inode);
 	if (rc)
 		goto fail_drop;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index a5ac97b..35976bd 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -86,7 +86,9 @@ static int jfs_create(struct inode *dip, struct dentry *dentry, umode_t mode,
 
 	jfs_info("jfs_create: dip:0x%p name:%pd", dip, dentry);
 
-	dquot_initialize(dip);
+	rc = dquot_initialize(dip);
+	if (rc)
+		goto out1;
 
 	/*
 	 * search parent directory for entry/freespace
@@ -218,7 +220,9 @@ static int jfs_mkdir(struct inode *dip, struct dentry *dentry, umode_t mode)
 
 	jfs_info("jfs_mkdir: dip:0x%p name:%pd", dip, dentry);
 
-	dquot_initialize(dip);
+	rc = dquot_initialize(dip);
+	if (rc)
+		goto out1;
 
 	/*
 	 * search parent directory for entry/freespace
@@ -355,8 +359,12 @@ static int jfs_rmdir(struct inode *dip, struct dentry *dentry)
 	jfs_info("jfs_rmdir: dip:0x%p name:%pd", dip, dentry);
 
 	/* Init inode for quota operations. */
-	dquot_initialize(dip);
-	dquot_initialize(ip);
+	rc = dquot_initialize(dip);
+	if (rc)
+		goto out;
+	rc = dquot_initialize(ip);
+	if (rc)
+		goto out;
 
 	/* directory must be empty to be removed */
 	if (!dtEmpty(ip)) {
@@ -483,8 +491,12 @@ static int jfs_unlink(struct inode *dip, struct dentry *dentry)
 	jfs_info("jfs_unlink: dip:0x%p name:%pd", dip, dentry);
 
 	/* Init inode for quota operations. */
-	dquot_initialize(dip);
-	dquot_initialize(ip);
+	rc = dquot_initialize(dip);
+	if (rc)
+		goto out;
+	rc = dquot_initialize(ip);
+	if (rc)
+		goto out;
 
 	if ((rc = get_UCSname(&dname, dentry)))
 		goto out;
@@ -799,7 +811,9 @@ static int jfs_link(struct dentry *old_dentry,
 
 	jfs_info("jfs_link: %pd %pd", old_dentry, dentry);
 
-	dquot_initialize(dir);
+	rc = dquot_initialize(dir);
+	if (rc)
+		goto out;
 
 	tid = txBegin(ip->i_sb, 0);
 
@@ -810,7 +824,7 @@ static int jfs_link(struct dentry *old_dentry,
 	 * scan parent directory for entry/freespace
 	 */
 	if ((rc = get_UCSname(&dname, dentry)))
-		goto out;
+		goto out_tx;
 
 	if ((rc = dtSearch(dir, &dname, &ino, &btstack, JFS_CREATE)))
 		goto free_dname;
@@ -842,12 +856,13 @@ static int jfs_link(struct dentry *old_dentry,
       free_dname:
 	free_UCSname(&dname);
 
-      out:
+      out_tx:
 	txEnd(tid);
 
 	mutex_unlock(&JFS_IP(ip)->commit_mutex);
 	mutex_unlock(&JFS_IP(dir)->commit_mutex);
 
+      out:
 	jfs_info("jfs_link: rc:%d", rc);
 	return rc;
 }
@@ -891,7 +906,9 @@ static int jfs_symlink(struct inode *dip, struct dentry *dentry,
 
 	jfs_info("jfs_symlink: dip:0x%p name:%s", dip, name);
 
-	dquot_initialize(dip);
+	rc = dquot_initialize(dip);
+	if (rc)
+		goto out1;
 
 	ssize = strlen(name) + 1;
 
@@ -1082,8 +1099,12 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	jfs_info("jfs_rename: %pd %pd", old_dentry, new_dentry);
 
-	dquot_initialize(old_dir);
-	dquot_initialize(new_dir);
+	rc = dquot_initialize(old_dir);
+	if (rc)
+		goto out1;
+	rc = dquot_initialize(new_dir);
+	if (rc)
+		goto out1;
 
 	old_ip = d_inode(old_dentry);
 	new_ip = d_inode(new_dentry);
@@ -1130,7 +1151,9 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	} else if (new_ip) {
 		IWRITE_LOCK(new_ip, RDWRLOCK_NORMAL);
 		/* Init inode for quota operations. */
-		dquot_initialize(new_ip);
+		rc = dquot_initialize(new_ip);
+		if (rc)
+			goto out_unlock;
 	}
 
 	/*
@@ -1318,6 +1341,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		clear_cflag(COMMIT_Stale, old_dir);
 	}
+      out_unlock:
 	if (new_ip && !S_ISDIR(new_ip->i_mode))
 		IWRITE_UNLOCK(new_ip);
       out3:
@@ -1353,7 +1377,9 @@ static int jfs_mknod(struct inode *dir, struct dentry *dentry,
 
 	jfs_info("jfs_mknod: %pd", dentry);
 
-	dquot_initialize(dir);
+	rc = dquot_initialize(dir);
+	if (rc)
+		goto out;
 
 	if ((rc = get_UCSname(&dname, dentry)))
 		goto out;
-- 
2.4.5

