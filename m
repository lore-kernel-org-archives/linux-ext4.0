From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v3 6/6] btrfs: add an is_readonly() so btrfs can use common
	code for update_time()
Date: Tue, 25 Nov 2014 00:34:34 -0500
Message-ID: <1416893674-419-7-git-send-email-tytso@mit.edu>
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1416893674-419-1-git-send-email-tytso@mit.edu>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

The only reason btrfs cloned code from the VFS layer was so it could
add a check to see if a subvolume is read-ony.  Instead of doing that,
let's add a new inode operation which allows a file system to return
an error if the inode is read-only, and use that in update_time().
There may be other places where the VFS layer may want to know that
btrfs would want to treat an inode is read-only.

With this commit, there are no remaining users of update_time() in the
inode operations structure, so we can remove it and simply things
further.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/inode.c   | 26 ++++++--------------------
 fs/inode.c         | 22 +++++++++++-----------
 include/linux/fs.h |  2 +-
 3 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a5e0d0d..0bfe3a4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5554,26 +5554,12 @@ static int btrfs_dirty_inode(struct inode *inode)
 	return ret;
 }
 
-/*
- * This is a copy of file_update_time.  We need this so we can return error on
- * ENOSPC for updating the inode in the case of file write and mmap writes.
- */
-static int btrfs_update_time(struct inode *inode, struct timespec *now,
-			     int flags)
+static int btrfs_is_readonly(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
-
-	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
-	if (flags & S_CTIME)
-		inode->i_ctime = *now;
-	if (flags & S_MTIME)
-		inode->i_mtime = *now;
-	if (flags & S_ATIME)
-		inode->i_atime = *now;
 	return 0;
 }
 
@@ -9466,8 +9452,8 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 	.tmpfile        = btrfs_tmpfile,
 };
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
@@ -9475,8 +9461,8 @@ static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 
 static const struct file_operations btrfs_dir_file_operations = {
@@ -9546,8 +9532,8 @@ static const struct inode_operations btrfs_file_inode_operations = {
 	.fiemap		= btrfs_fiemap,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
@@ -9559,8 +9545,8 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.removexattr	= btrfs_removexattr,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
@@ -9573,8 +9559,8 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.getxattr	= btrfs_getxattr,
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
-	.update_time	= btrfs_update_time,
 	.write_time	= btrfs_write_time,
+	.is_readonly	= btrfs_is_readonly,
 };
 
 const struct dentry_operations btrfs_dentry_operations = {
diff --git a/fs/inode.c b/fs/inode.c
index 1f90591..e83c6d2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1555,20 +1555,20 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 	unsigned short daycode;
 	int ret;
 
-	if (inode->i_op->update_time) {
-		ret = inode->i_op->update_time(inode, time, flags);
+	if (inode->i_op->is_readonly) {
+		ret = inode->i_op->is_readonly(inode);
 		if (ret)
 			return ret;
-	} else {
-		if (flags & S_ATIME)
-			inode->i_atime = *time;
-		if (flags & S_VERSION)
-			inode_inc_iversion(inode);
-		if (flags & S_CTIME)
-			inode->i_ctime = *time;
-		if (flags & S_MTIME)
-		inode->i_mtime = *time;
 	}
+	if (flags & S_ATIME)
+		inode->i_atime = *time;
+	if (flags & S_VERSION)
+		inode_inc_iversion(inode);
+	if (flags & S_CTIME)
+		inode->i_ctime = *time;
+	if (flags & S_MTIME)
+		inode->i_mtime = *time;
+
 	/*
 	 * If i_ts_dirty_day is zero, then either we have not deferred
 	 * timestamp updates, or the system has been up for less than
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dbbd642..70711c8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1545,8 +1545,8 @@ struct inode_operations {
 	int (*removexattr) (struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
-	int (*update_time)(struct inode *, struct timespec *, int);
 	int (*write_time)(struct inode *);
+	int (*is_readonly)(struct inode *);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode, int *opened);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
