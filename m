From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 04/11] vfs: Add generic IS_ACL() test for acl support
Date: Fri, 24 Sep 2010 18:18:07 +0530
Message-ID: <1285332494-12756-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

When IS_POSIXACL() is true, the vfs does not apply the umask.  Other acl
models will need the same exception, so introduce a separate IS_ACL()
test.

The IS_POSIX_ACL() test is still needed so that nfsd can determine when
the underlying file system supports POSIX ACLs (as opposed to some other
kind).

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c         |    6 +++---
 fs/nfs/nfs4proc.c  |    2 +-
 include/linux/fs.h |    8 +++++++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index bf822b8..855b360 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1486,7 +1486,7 @@ static int __open_namei_create(struct nameidata *nd, struct path *path,
 	int error;
 	struct dentry *dir = nd->path.dentry;
 
-	if (!IS_POSIXACL(dir->d_inode))
+	if (!IS_ACL(dir->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&nd->path, path->dentry, mode, 0);
 	if (error)
@@ -2009,7 +2009,7 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, int, mode,
 		error = PTR_ERR(dentry);
 		goto out_unlock;
 	}
-	if (!IS_POSIXACL(nd.path.dentry->d_inode))
+	if (!IS_ACL(nd.path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = may_mknod(mode);
 	if (error)
@@ -2086,7 +2086,7 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, int, mode)
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	if (!IS_POSIXACL(nd.path.dentry->d_inode))
+	if (!IS_ACL(nd.path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 089da5b..c77dbbf 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2042,7 +2042,7 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	if (nd->flags & LOOKUP_CREATE) {
 		attr.ia_mode = nd->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
-		if (!IS_POSIXACL(dir))
+		if (!IS_ACL(dir))
 			attr.ia_mode &= ~current_umask();
 	} else {
 		open_flags &= ~O_EXCL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 63d069b..485c697 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -199,7 +199,7 @@ struct inodes_stat_t {
 #define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
 				   MS_VERBOSE is deprecated. */
 #define MS_SILENT	32768
-#define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
+#define MS_POSIXACL	(1<<16) /* Supports POSIX ACLs */
 #define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
 #define MS_PRIVATE	(1<<18)	/* change to private */
 #define MS_SLAVE	(1<<19)	/* change to slave */
@@ -270,6 +270,12 @@ struct inodes_stat_t {
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
 
+/*
+ * IS_ACL() tells the VFS to not apply the umask
+ * and use iop->check_acl for acl permission checks when defined.
+ */
+#define IS_ACL(inode)		__IS_FLG(inode, MS_POSIXACL)
+
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
 
-- 
1.7.0.4
