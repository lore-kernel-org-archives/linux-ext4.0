From: Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Fix deadlock during path resolution
Date: Wed, 15 Sep 2010 23:39:51 +0200
Message-ID: <1284586791-8245-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>,
	Joel Becker <joel.becker@oracle.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As Al Viro pointed out path resolution during Q_QUOTAON calls to quotactl
is prone to deadlocks. We hold s_umount semaphore for reading during the
path resolution and resolution itself may need to acquire the semaphore
for writing when e. g. autofs mountpoint is passed.

Solve the problem by performing the resolution before we get hold of the
superblock (and thus s_umount semaphore). The whole thing is complicated
by the fact that some filesystems (OCFS2) ignore the path argument. So to
distinguish between filesystem which want the path and which do not we
introduce new .quota_on_meta callback which does not get the path. OCFS2
then uses this callback instead of old .quota_on.

CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Christoph Hellwig <hch@lst.de>
CC: Ted Ts'o <tytso@mit.edu>
CC: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c          |   25 +++++++------------------
 fs/ext4/super.c          |   25 +++++++------------------
 fs/ocfs2/super.c         |    5 ++---
 fs/quota/dquot.c         |   18 ++----------------
 fs/quota/quota.c         |   41 +++++++++++++++++++++++++++--------------
 fs/reiserfs/super.c      |   17 ++++++-----------
 include/linux/quota.h    |    5 ++++-
 include/linux/quotaops.h |    4 +---
 8 files changed, 56 insertions(+), 84 deletions(-)

 The patch changes quota_on interface and thus all filesystems using it need
to be modified. Since the patch is small, I'd prefer to keep all the fs
changes in this single patch. FS maintainers, please review. Thanks.

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5dbf4db..15f63d3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -736,7 +736,7 @@ static int ext3_release_dquot(struct dquot *dquot);
 static int ext3_mark_dquot_dirty(struct dquot *dquot);
 static int ext3_write_info(struct super_block *sb, int type);
 static int ext3_quota_on(struct super_block *sb, int type, int format_id,
-				char *path);
+			 struct path *path);
 static int ext3_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -2849,27 +2849,20 @@ static int ext3_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int ext3_quota_on(struct super_block *sb, int type, int format_id,
-			 char *name)
+			 struct path *path)
 {
 	int err;
-	struct path path;
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
 
-	err = kern_path(name, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-
 	/* Quotafile not on the same filesystem? */
-	if (path.mnt->mnt_sb != sb) {
-		path_put(&path);
+	if (path->mnt->mnt_sb != sb)
 		return -EXDEV;
-	}
 	/* Journaling quota? */
 	if (EXT3_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not of fs root? */
-		if (path.dentry->d_parent != sb->s_root)
+		if (path->dentry->d_parent != sb->s_root)
 			ext3_msg(sb, KERN_WARNING,
 				"warning: Quota file not on filesystem root. "
 				"Journaled quota will not work.");
@@ -2879,7 +2872,7 @@ static int ext3_quota_on(struct super_block *sb, int type, int format_id,
 	 * When we journal data on quota file, we have to flush journal to see
 	 * all updates to the file when we bypass pagecache...
 	 */
-	if (ext3_should_journal_data(path.dentry->d_inode)) {
+	if (ext3_should_journal_data(path->dentry->d_inode)) {
 		/*
 		 * We don't need to lock updates but journal_flush() could
 		 * otherwise be livelocked...
@@ -2887,15 +2880,11 @@ static int ext3_quota_on(struct super_block *sb, int type, int format_id,
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		err = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
-		if (err) {
-			path_put(&path);
+		if (err)
 			return err;
-		}
 	}
 
-	err = dquot_quota_on_path(sb, type, format_id, &path);
-	path_put(&path);
-	return err;
+	return dquot_quota_on(sb, type, format_id, path);
 }
 
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..bcf86b3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1123,7 +1123,7 @@ static int ext4_release_dquot(struct dquot *dquot);
 static int ext4_mark_dquot_dirty(struct dquot *dquot);
 static int ext4_write_info(struct super_block *sb, int type);
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
-				char *path);
+			 struct path *path);
 static int ext4_quota_off(struct super_block *sb, int type);
 static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
@@ -4066,27 +4066,20 @@ static int ext4_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
-			 char *name)
+			 struct path *path)
 {
 	int err;
-	struct path path;
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
 
-	err = kern_path(name, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-
 	/* Quotafile not on the same filesystem? */
-	if (path.mnt->mnt_sb != sb) {
-		path_put(&path);
+	if (path->mnt->mnt_sb != sb)
 		return -EXDEV;
-	}
 	/* Journaling quota? */
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not in fs root? */
-		if (path.dentry->d_parent != sb->s_root)
+		if (path->dentry->d_parent != sb->s_root)
 			ext4_msg(sb, KERN_WARNING,
 				"Quota file not on filesystem root. "
 				"Journaled quota will not work");
@@ -4097,7 +4090,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	 * all updates to the file when we bypass pagecache...
 	 */
 	if (EXT4_SB(sb)->s_journal &&
-	    ext4_should_journal_data(path.dentry->d_inode)) {
+	    ext4_should_journal_data(path->dentry->d_inode)) {
 		/*
 		 * We don't need to lock updates but journal_flush() could
 		 * otherwise be livelocked...
@@ -4105,15 +4098,11 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		err = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
-		if (err) {
-			path_put(&path);
+		if (err)
 			return err;
-		}
 	}
 
-	err = dquot_quota_on_path(sb, type, format_id, &path);
-	path_put(&path);
-	return err;
+	return dquot_quota_on(sb, type, format_id, path);
 }
 
 static int ext4_quota_off(struct super_block *sb, int type)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa1be1b..26bd015 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -962,8 +962,7 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 }
 
 /* Handle quota on quotactl */
-static int ocfs2_quota_on(struct super_block *sb, int type, int format_id,
-			  char *path)
+static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
 {
 	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
 					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
@@ -982,7 +981,7 @@ static int ocfs2_quota_off(struct super_block *sb, int type)
 }
 
 static const struct quotactl_ops ocfs2_quotactl_ops = {
-	.quota_on	= ocfs2_quota_on,
+	.quota_on_meta	= ocfs2_quota_on,
 	.quota_off	= ocfs2_quota_off,
 	.quota_sync	= dquot_quota_sync,
 	.get_info	= dquot_get_dqinfo,
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index aad1316..317e0e1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2177,8 +2177,8 @@ int dquot_resume(struct super_block *sb, int type)
 }
 EXPORT_SYMBOL(dquot_resume);
 
-int dquot_quota_on_path(struct super_block *sb, int type, int format_id,
-		      struct path *path)
+int dquot_quota_on(struct super_block *sb, int type, int format_id,
+		   struct path *path)
 {
 	int error = security_quota_on(path->dentry);
 	if (error)
@@ -2194,20 +2194,6 @@ int dquot_quota_on_path(struct super_block *sb, int type, int format_id,
 }
 EXPORT_SYMBOL(dquot_quota_on_path);
 
-int dquot_quota_on(struct super_block *sb, int type, int format_id, char *name)
-{
-	struct path path;
-	int error;
-
-	error = kern_path(name, LOOKUP_FOLLOW, &path);
-	if (!error) {
-		error = dquot_quota_on_path(sb, type, format_id, &path);
-		path_put(&path);
-	}
-	return error;
-}
-EXPORT_SYMBOL(dquot_quota_on);
-
 /*
  * More powerful function for turning on quotas allowing setting
  * of individual quota flags
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index b299961..b34bdb2 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -64,18 +64,15 @@ static int quota_sync_all(int type)
 }
 
 static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
-		         void __user *addr)
+		         struct path *path)
 {
-	char *pathname;
-	int ret = -ENOSYS;
-
-	pathname = getname(addr);
-	if (IS_ERR(pathname))
-		return PTR_ERR(pathname);
-	if (sb->s_qcop->quota_on)
-		ret = sb->s_qcop->quota_on(sb, type, id, pathname);
-	putname(pathname);
-	return ret;
+	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_on_meta)
+		return -ENOSYS;
+	if (sb->s_qcop->quota_on_meta)
+		return sb->s_qcop->quota_on_meta(sb, type, id);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
+	return sb->s_qcop->quota_on(sb, type, id, path);
 }
 
 static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
@@ -241,7 +238,7 @@ static int quota_getxquota(struct super_block *sb, int type, qid_t id,
 
 /* Copy parameters and call proper function */
 static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
-		       void __user *addr)
+		       void __user *addr, struct path *path)
 {
 	int ret;
 
@@ -256,7 +253,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 
 	switch (cmd) {
 	case Q_QUOTAON:
-		return quota_quotaon(sb, type, cmd, id, addr);
+		return quota_quotaon(sb, type, cmd, id, path);
 	case Q_QUOTAOFF:
 		if (!sb->s_qcop->quota_off)
 			return -ENOSYS;
@@ -335,6 +332,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 {
 	uint cmds, type;
 	struct super_block *sb = NULL;
+	struct path path, *pathp = NULL;
 	int ret;
 
 	cmds = cmd >> SUBCMDSHIFT;
@@ -351,12 +349,27 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 		return -ENODEV;
 	}
 
+	/*
+	 * Path for quotaon has to be resolved before grabbing superblock
+	 * because that gets s_umount sem which is also possibly needed by path
+	 * resolution (think about autofs) and thus deadlocks could arise.
+	 */
+	if (cmds == Q_QUOTAON) {
+		ret = user_path_at(AT_FDCWD, addr, LOOKUP_FOLLOW, &path);
+		if (ret)
+			pathp = ERR_PTR(ret);
+		else
+			pathp = &path;
+	}
+
 	sb = quotactl_block(special);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 
-	ret = do_quotactl(sb, type, cmds, id, addr);
+	ret = do_quotactl(sb, type, cmds, id, addr, pathp);
 
 	drop_super(sb);
+	if (pathp && !IS_ERR(pathp))
+		path_put(pathp);
 	return ret;
 }
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index e15ff61..6e85cfd 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -626,7 +626,7 @@ static int reiserfs_acquire_dquot(struct dquot *);
 static int reiserfs_release_dquot(struct dquot *);
 static int reiserfs_mark_dquot_dirty(struct dquot *);
 static int reiserfs_write_info(struct super_block *, int);
-static int reiserfs_quota_on(struct super_block *, int, int, char *);
+static int reiserfs_quota_on(struct super_block *, int, int, struct path *);
 
 static const struct dquot_operations reiserfs_quota_operations = {
 	.write_dquot = reiserfs_write_dquot,
@@ -2042,25 +2042,21 @@ static int reiserfs_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
-			     char *name)
+			     struct path *path)
 {
 	int err;
-	struct path path;
 	struct inode *inode;
 	struct reiserfs_transaction_handle th;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
 
-	err = kern_path(name, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
 	/* Quotafile not on the same filesystem? */
-	if (path.mnt->mnt_sb != sb) {
+	if (path->mnt->mnt_sb != sb) {
 		err = -EXDEV;
 		goto out;
 	}
-	inode = path.dentry->d_inode;
+	inode = path->dentry->d_inode;
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
 	if (!(REISERFS_I(inode)->i_flags & i_nopack_mask)) {
 		err = reiserfs_unpack(inode, NULL);
@@ -2076,7 +2072,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 	/* Journaling quota? */
 	if (REISERFS_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not of fs root? */
-		if (path.dentry->d_parent != sb->s_root)
+		if (path->dentry->d_parent != sb->s_root)
 			reiserfs_warning(sb, "super-6521",
 				 "Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
@@ -2095,9 +2091,8 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 		if (err)
 			goto out;
 	}
-	err = dquot_quota_on_path(sb, type, format_id, &path);
+	err = dquot_quota_on(sb, type, format_id, path);
 out:
-	path_put(&path);
 	return err;
 }
 
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 94c1f03..9a85412 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -322,9 +322,12 @@ struct dquot_operations {
 	qsize_t *(*get_reserved_space) (struct inode *);
 };
 
+struct path;
+
 /* Operations handling requests from userspace */
 struct quotactl_ops {
-	int (*quota_on)(struct super_block *, int, int, char *);
+	int (*quota_on)(struct super_block *, int, int, struct path *);
+	int (*quota_on_meta)(struct super_block *, int, int);
 	int (*quota_off)(struct super_block *, int);
 	int (*quota_sync)(struct super_block *, int, int);
 	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index d1a9193..9e09c9a 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -75,11 +75,9 @@ int dquot_mark_dquot_dirty(struct dquot *dquot);
 
 int dquot_file_open(struct inode *inode, struct file *file);
 
-int dquot_quota_on(struct super_block *sb, int type, int format_id,
-	char *path);
 int dquot_enable(struct inode *inode, int type, int format_id,
 	unsigned int flags);
-int dquot_quota_on_path(struct super_block *sb, int type, int format_id,
+int dquot_quota_on(struct super_block *sb, int type, int format_id,
  	struct path *path);
 int dquot_quota_on_mount(struct super_block *sb, char *qf_name,
  	int format_id, int type);
-- 
1.6.4.2

