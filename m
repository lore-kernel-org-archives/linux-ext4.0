From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] fs: add file_dentry()
Date: Sat, 26 Mar 2016 17:09:56 -0400
Message-ID: <1459026600-9232-2-git-send-email-tytso@mit.edu>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, <stable@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Daniel Axtens <dja@axtens.net>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34266 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbcCZVKS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Mar 2016 17:10:18 -0400
In-Reply-To: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Miklos Szeredi <miklos@szeredi.hu>

This series fixes bugs in nfs and ext4 due to 4bacc9c9234c ("overlayfs:
Make f_path always point to the overlay and f_inode to the underlay").

Regular files opened on overlayfs will result in the file being opened on
the underlying filesystem, while f_path points to the overlayfs
mount/dentry.

This confuses filesystems which get the dentry from struct file and assume
it's theirs.

Add a new helper, file_dentry() [*], to get the filesystem's own dentry
from the file.  This checks file->f_path.dentry->d_flags against
DCACHE_OP_REAL, and returns file->f_path.dentry if DCACHE_OP_REAL is not
set (this is the common, non-overlayfs case).

In the uncommon case it will call into overlayfs's ->d_real() to get the
underlying dentry, matching file_inode(file).

The reason we need to check against the inode is that if the file is copied
up while being open, d_real() would return the upper dentry, while the open
file comes from the lower dentry.

[*] If possible, it's better simply to use file_inode() instead.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: <stable@vger.kernel.org> # v4.2
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Daniel Axtens <dja@axtens.net>
---
 fs/dcache.c            |  5 ++++-
 fs/overlayfs/super.c   | 33 +++++++++++++++++++++++++++++++++
 include/linux/dcache.h | 10 ++++++++++
 include/linux/fs.h     | 10 ++++++++++
 4 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 32ceae3..d5ecc6e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1667,7 +1667,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
 				DCACHE_OP_REVALIDATE	|
 				DCACHE_OP_WEAK_REVALIDATE	|
 				DCACHE_OP_DELETE	|
-				DCACHE_OP_SELECT_INODE));
+				DCACHE_OP_SELECT_INODE	|
+				DCACHE_OP_REAL));
 	dentry->d_op = op;
 	if (!op)
 		return;
@@ -1685,6 +1686,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
 		dentry->d_flags |= DCACHE_OP_PRUNE;
 	if (op->d_select_inode)
 		dentry->d_flags |= DCACHE_OP_SELECT_INODE;
+	if (op->d_real)
+		dentry->d_flags |= DCACHE_OP_REAL;
 
 }
 EXPORT_SYMBOL(d_set_d_op);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ef64984..5d972e6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -295,6 +295,37 @@ static void ovl_dentry_release(struct dentry *dentry)
 	}
 }
 
+static struct dentry *ovl_d_real(struct dentry *dentry, struct inode *inode)
+{
+	struct dentry *real;
+
+	if (d_is_dir(dentry)) {
+		if (!inode || inode == d_inode(dentry))
+			return dentry;
+		goto bug;
+	}
+
+	real = ovl_dentry_upper(dentry);
+	if (real && (!inode || inode == d_inode(real)))
+		return real;
+
+	real = ovl_dentry_lower(dentry);
+	if (!real)
+		goto bug;
+
+	if (!inode || inode == d_inode(real))
+		return real;
+
+	/* Handle recursion */
+	if (real->d_flags & DCACHE_OP_REAL)
+		return real->d_op->d_real(real, inode);
+
+bug:
+	WARN(1, "ovl_d_real(%pd4, %s:%lu\n): real dentry not found\n", dentry,
+	     inode ? inode->i_sb->s_id : "NULL", inode ? inode->i_ino : 0);
+	return dentry;
+}
+
 static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -339,11 +370,13 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_select_inode = ovl_d_select_inode,
+	.d_real = ovl_d_real,
 };
 
 static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_select_inode = ovl_d_select_inode,
+	.d_real = ovl_d_real,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 7cb043d..4bb4de8 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -161,6 +161,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(struct dentry *, bool);
 	struct inode *(*d_select_inode)(struct dentry *, unsigned);
+	struct dentry *(*d_real)(struct dentry *, struct inode *);
 } ____cacheline_aligned;
 
 /*
@@ -229,6 +230,7 @@ struct dentry_operations {
 #define DCACHE_OP_SELECT_INODE		0x02000000 /* Unioned entry: dcache op selects inode */
 
 #define DCACHE_ENCRYPTED_WITH_KEY	0x04000000 /* dir is encrypted with a valid key */
+#define DCACHE_OP_REAL			0x08000000
 
 extern seqlock_t rename_lock;
 
@@ -555,4 +557,12 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
 	return upper;
 }
 
+static inline struct dentry *d_real(struct dentry *dentry)
+{
+	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
+		return dentry->d_op->d_real(dentry, NULL);
+	else
+		return dentry;
+}
+
 #endif	/* __LINUX_DCACHE_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 35d9926..b2ed231 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1241,6 +1241,16 @@ static inline struct inode *file_inode(const struct file *f)
 	return f->f_inode;
 }
 
+static inline struct dentry *file_dentry(const struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+
+	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
+		return dentry->d_op->d_real(dentry, file_inode(file));
+	else
+		return dentry;
+}
+
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
 {
 	return locks_lock_inode_wait(file_inode(filp), fl);
-- 
2.5.0

