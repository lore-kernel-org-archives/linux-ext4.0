From: yi zhang <yi.zhang@huawei.com>
Subject: [PATCH 1/2] vfs: add detection of inode validation
Date: Wed, 18 Jan 2017 17:46:08 +0800
Message-ID: <1484732769-31670-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <viro@ZenIV.linux.org.uk>,
        <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When we open/rename/unlink a file and open/rmdir a directory, the inode
nlink can't be zero, if it does, the file system is inconsistency,
and it can cause some unexpected errors, so add aggressive detection.

Signed-off-by: yi zhang <yi.zhang@huawei.com>
---
 fs/namei.c         | 44 ++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h |  2 ++
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ad74877..a39bf7c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -257,6 +257,23 @@ void putname(struct filename *name)
 		__putname(name);
 }
 
+int generic_validate(struct inode *inode)
+{
+	if (unlikely(inode->i_nlink == 0))
+		return -EUCLEAN;
+}
+EXPORT_SYMBOL(generic_validate);
+
+static inline int inode_validate(struct inode *inode)
+{
+	int retval = 0;
+
+	if (inode->i_op->validate)
+		retval = inode->i_op->validate(inode);
+
+	return retval;
+}
+
 static int check_acl(struct inode *inode, int mask)
 {
 #ifdef CONFIG_FS_POSIX_ACL
@@ -2716,20 +2733,21 @@ EXPORT_SYMBOL(__check_sticky);
  *	Check whether we can remove a link victim from directory dir, check
  *  whether the type of victim is right.
  *  1. We can't do it if dir is read-only (done in permission())
- *  2. We should have write and exec permissions on dir
- *  3. We can't remove anything from append-only dir
- *  4. We can't do anything with immutable dir (done in permission())
- *  5. If the sticky bit on dir is set we should either
+ *  2. We should validate the victim's inode
+ *  3. We should have write and exec permissions on dir
+ *  4. We can't remove anything from append-only dir
+ *  5. We can't do anything with immutable dir (done in permission())
+ *  6. If the sticky bit on dir is set we should either
  *	a. be owner of dir, or
  *	b. be owner of victim, or
  *	c. have CAP_FOWNER capability
- *  6. If the victim is append-only or immutable we can't do antyhing with
+ *  7. If the victim is append-only or immutable we can't do antyhing with
  *     links pointing to it.
- *  7. If the victim has an unknown uid or gid we can't change the inode.
- *  8. If we were asked to remove a directory and victim isn't one - ENOTDIR.
- *  9. If we were asked to remove a non-directory and victim isn't one - EISDIR.
- * 10. We can't remove a root or mountpoint.
- * 11. We don't allow removal of NFS sillyrenamed files; it's handled by
+ *  8. If the victim has an unknown uid or gid we can't change the inode.
+ *  9. If we were asked to remove a directory and victim isn't one - ENOTDIR.
+ * 10. If we were asked to remove a non-directory and victim isn't one - EISDIR.
+ * 11. We can't remove a root or mountpoint.
+ * 12. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
 static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
@@ -2744,6 +2762,9 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
+	error = inode_validate(inode);
+	if (error)
+		return error;
 	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
@@ -2889,6 +2910,9 @@ static int may_open(const struct path *path, int acc_mode, int flag)
 		break;
 	}
 
+	error = inode_validate(inode);
+	if (error)
+		return error;
 	error = inode_permission(inode, MAY_OPEN | acc_mode);
 	if (error)
 		return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba0743..52910f7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1710,6 +1710,7 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
+	int (*validate)(struct inode *);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
@@ -2534,6 +2535,7 @@ extern int inode_permission(struct inode *, int);
 extern int __inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int);
 extern int __check_sticky(struct inode *dir, struct inode *inode);
+extern int generic_validate(struct inode *inode);
 
 static inline bool execute_ok(struct inode *inode)
 {
-- 
2.5.0
