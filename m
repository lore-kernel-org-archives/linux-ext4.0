From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 01/23] vfs: VFS hooks for per-filesystem permission models
Date: Mon,  1 Feb 2010 11:04:43 +0530
Message-ID: <1265002505-8387-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Add may_create and may_delete inode operations that filesystems can
implement in order to override the vfs provided default behavior.
This is required for implementing permission models which go beyond
the traditional UNIX semantics.

If a filesystem does not implement these hooks, the behavior is
unchanged.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c         |   50 ++++++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |    4 ++++
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b55440b..3e842ac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1337,14 +1337,26 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
 
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
-
-	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (dir->i_op->may_delete) {
+		if (IS_RDONLY(dir))
+			return -EROFS;
+		if (IS_IMMUTABLE(dir))
+			return -EACCES;
+		error = dir->i_op->may_delete(dir, victim->d_inode);
+		if (!error)
+			error = security_inode_permission(dir,
+							MAY_WRITE | MAY_EXEC);
+	} else {
+		error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+		if (!error && check_sticky(dir, victim->d_inode))
+			error = -EPERM;
+	}
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
 		return -EPERM;
-	if (check_sticky(dir, victim->d_inode)||IS_APPEND(victim->d_inode)||
-	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
+	if (IS_APPEND(victim->d_inode) || IS_IMMUTABLE(victim->d_inode) ||
+		IS_SWAPFILE(victim->d_inode))
 		return -EPERM;
 	if (isdir) {
 		if (!S_ISDIR(victim->d_inode->i_mode))
@@ -1368,13 +1380,27 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child)
+static inline int may_create(struct inode *dir, struct dentry *child, int isdir)
 {
+	int error;
+
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (dir->i_op->may_create) {
+		if (IS_RDONLY(dir))
+			return -EROFS;
+		if (IS_IMMUTABLE(dir))
+			return -EACCES;
+		error = dir->i_op->may_create(dir, isdir);
+		if (!error)
+			error = security_inode_permission(dir,
+							MAY_WRITE | MAY_EXEC);
+	} else
+		error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+
+	return error;
 }
 
 /* 
@@ -1438,7 +1464,7 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, 0);
 
 	if (error)
 		return error;
@@ -1970,7 +1996,7 @@ EXPORT_SYMBOL_GPL(lookup_create);
 
 int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, 0);
 
 	if (error)
 		return error;
@@ -2075,7 +2101,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
 
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, 1);
 
 	if (error)
 		return error;
@@ -2360,7 +2386,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
 {
-	int error = may_create(dir, dentry);
+	int error = may_create(dir, dentry, 0);
 
 	if (error)
 		return error;
@@ -2434,7 +2460,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry);
+	error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
 	if (error)
 		return error;
 
@@ -2646,7 +2672,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir, new_dentry);
+		error = may_create(new_dir, new_dentry, is_dir);
 	else
 		error = may_delete(new_dir, new_dentry, is_dir);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9147ca8..2191464 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1534,6 +1534,10 @@ struct inode_operations {
 			  loff_t len);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
+	int (*may_create) (struct inode *, int);
+	int (*may_delete) (struct inode *, struct inode *);
+
+
 };
 
 struct seq_file;
-- 
1.7.0.rc0.48.gdace5

