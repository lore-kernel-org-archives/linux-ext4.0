From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 17/23] vfs: Add new MS_ACL and MS_RICHACL flag
Date: Mon,  1 Feb 2010 11:04:59 +0530
Message-ID: <1265002505-8387-18-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60722 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0BAFfY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:24 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ADD MS_ACL and MS_RICHACL flag which can be used to
indicate whether richacl is enabled or not. This will
help nfsd to use the right acl mapping when storing
NFSv4 ACL to disk

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c         |    9 ++++++---
 include/linux/fs.h |    9 +++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2a1a1d6..ecc7476 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -471,6 +471,9 @@ static int exec_permission(struct inode *inode)
 			goto ok;
 		return ret;
 	}
+	/*
+	 * Do the basic POSIX ACL permission checks.
+	 */
 	ret = acl_permission_check(inode, MAY_EXEC, inode->i_op->check_acl);
 	if (!ret)
 		goto ok;
@@ -1573,7 +1576,7 @@ static int __open_namei_create(struct nameidata *nd, struct path *path,
 	int error;
 	struct dentry *dir = nd->path.dentry;
 
-	if (!IS_POSIXACL(dir->d_inode))
+	if (!IS_ACL(dir->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&nd->path, path->dentry, mode, 0);
 	if (error)
@@ -2065,7 +2068,7 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, int, mode,
 		error = PTR_ERR(dentry);
 		goto out_unlock;
 	}
-	if (!IS_POSIXACL(nd.path.dentry->d_inode))
+	if (!IS_ACL(nd.path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = may_mknod(mode);
 	if (error)
@@ -2143,7 +2146,7 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, int, mode)
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	if (!IS_POSIXACL(nd.path.dentry->d_inode))
+	if (!IS_ACL(nd.path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2191464..2ff6114 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -197,7 +197,7 @@ struct inodes_stat_t {
 #define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
 				   MS_VERBOSE is deprecated. */
 #define MS_SILENT	32768
-#define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
+#define MS_ACL		(1<<16)	/* VFS does not apply the umask */
 #define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
 #define MS_PRIVATE	(1<<18)	/* change to private */
 #define MS_SLAVE	(1<<19)	/* change to slave */
@@ -206,6 +206,8 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_POSIXACL	(MS_ACL | 1<<25)/* Default ACL is POSIX ACL */
+#define MS_RICHACL	(MS_ACL | 1<<26)/* VFS uses richacl to check access */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -247,6 +249,7 @@ struct inodes_stat_t {
  * flags, so these have to be checked separately. -- rmk@arm.uk.linux.org
  */
 #define __IS_FLG(inode,flg) ((inode)->i_sb->s_flags & (flg))
+#define __IS_EXFLG(inode,flg) (((inode)->i_sb->s_flags & (flg)) == (flg))
 
 #define IS_RDONLY(inode) ((inode)->i_sb->s_flags & MS_RDONLY)
 #define IS_SYNC(inode)		(__IS_FLG(inode, MS_SYNCHRONOUS) || \
@@ -260,7 +263,9 @@ struct inodes_stat_t {
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
 #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
-#define IS_POSIXACL(inode)	__IS_FLG(inode, MS_POSIXACL)
+#define IS_ACL(inode)		__IS_FLG(inode, MS_ACL)
+#define IS_POSIXACL(inode)	__IS_EXFLG(inode, MS_POSIXACL)
+#define IS_RICHACL(inode)	__IS_EXFLG(inode, MS_RICHACL)
 
 #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
-- 
1.7.0.rc0.48.gdace5

