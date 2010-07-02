From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 15/16] ext4: Implement rich acl for ext4
Date: Sat,  3 Jul 2010 00:13:46 +0530
Message-ID: <1278096227-16784-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, staubach@redhat.com,
	bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

Support the richacl permission model in ext4.  The richacls are stored
in "system.richacl" xattrs.This need to be enabled by tune2fs or during
mkfs.ext4

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/ext4/Kconfig   |   15 +++
 fs/ext4/Makefile  |    1 +
 fs/ext4/ext4.h    |    4 +
 fs/ext4/file.c    |    4 +
 fs/ext4/ialloc.c  |    7 +-
 fs/ext4/inode.c   |   19 +++-
 fs/ext4/namei.c   |    7 ++
 fs/ext4/richacl.c |  293 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/richacl.h |   56 ++++++++++
 fs/ext4/super.c   |   12 ++-
 fs/ext4/xattr.c   |    6 +
 fs/ext4/xattr.h   |    2 +
 12 files changed, 420 insertions(+), 6 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..a22b8f1 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -83,3 +83,18 @@ config EXT4_DEBUG
 
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+
+config EXT4_FS_RICHACL
+      bool "Ext4 Rich Access Control Lists (EXPERIMENTAL)"
+      depends on EXT4_FS_XATTR && EXPERIMENTAL
+      select FS_RICHACL
+      help
+	Rich ACLs are an implementation of NFSv4 ACLs, extended by file masks
+	to fit into the standard POSIX file permission model.  They are
+	designed to work seamlessly locally as well as across the NFSv4 and
+	CIFS/SMB2 network file system protocols.
+
+	To learn more about Rich ACL, visit
+	http://acl.bestbits.at/richacl/
+
+	If you don't know what Rich ACLs are, say N
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 8867b2a..4acbffe 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -11,3 +11,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_FS_RICHACL)  	+= richacl.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 651379b..966d0cb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -836,6 +836,10 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+#ifdef CONFIG_EXT4_FS_RICHACL
+	struct richacl   *i_richacl;
+#endif
+
 };
 
 /*
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5313ae4..0e5a463 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 /*
  * Called when an inode is released. Note that this is different
@@ -160,5 +161,8 @@ const struct inode_operations ext4_file_inode_operations = {
 	.check_acl	= ext4_check_acl,
 	.fallocate	= ext4_fallocate,
 	.fiemap		= ext4_fiemap,
+	.permission	= ext4_permission,
+	.may_create	= ext4_may_create,
+	.may_delete	= ext4_may_delete,
 };
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25c4b31..57e885d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -1023,7 +1024,11 @@ got:
 	if (err)
 		goto fail_drop;
 
-	err = ext4_init_acl(handle, inode, dir);
+	if (EXT4_IS_RICHACL(dir))
+		err = ext4_init_richacl(handle, inode, dir);
+	else
+		err = ext4_init_acl(handle, inode, dir);
+
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..93550e3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -45,6 +45,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "ext4_extents.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -5020,6 +5021,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 
 	ei->i_state_flags = 0;
+#ifdef CONFIG_EXT4_FS_RICHACL
+	ei->i_richacl = EXT4_RICHACL_NOT_CACHED;
+#endif
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
 	/* We now have enough fields to check if the inode was active or not.
@@ -5446,7 +5450,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	int error, rc = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 
-	error = inode_change_ok(inode, attr);
+	if (EXT4_IS_RICHACL(inode))
+		error = richacl_inode_change_ok(inode, attr,
+						ext4_richacl_permission);
+	else
+		error = inode_change_ok(inode, attr);
 	if (error)
 		return error;
 
@@ -5537,9 +5545,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (inode->i_nlink)
 		ext4_orphan_del(NULL, inode);
 
-	if (!rc && (ia_valid & ATTR_MODE))
-		rc = ext4_acl_chmod(inode);
-
+	if (!rc && (ia_valid & ATTR_MODE)) {
+		if (EXT4_IS_RICHACL(inode))
+			rc = ext4_richacl_chmod(inode);
+		else
+			rc = ext4_acl_chmod(inode);
+	}
 err_out:
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a43e661..d792b63 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -39,6 +39,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 /*
  * define how far ahead to read directories while searching them.
@@ -2550,6 +2551,9 @@ const struct inode_operations ext4_dir_inode_operations = {
 #endif
 	.check_acl	= ext4_check_acl,
 	.fiemap         = ext4_fiemap,
+	.permission	= ext4_permission,
+	.may_create	= ext4_may_create,
+	.may_delete	= ext4_may_delete,
 };
 
 const struct inode_operations ext4_special_inode_operations = {
@@ -2561,4 +2565,7 @@ const struct inode_operations ext4_special_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.check_acl	= ext4_check_acl,
+	.permission	= ext4_permission,
+	.may_create	= ext4_may_create,
+	.may_delete	= ext4_may_delete,
 };
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
new file mode 100644
index 0000000..5dfba2b
--- /dev/null
+++ b/fs/ext4/richacl.c
@@ -0,0 +1,293 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/richacl_xattr.h>
+
+#include "ext4.h"
+#include "ext4_jbd2.h"
+#include "xattr.h"
+#include "acl.h"
+#include "richacl.h"
+
+static inline struct richacl *
+ext4_iget_richacl(struct inode *inode)
+{
+	struct richacl *acl = EXT4_RICHACL_NOT_CACHED;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	spin_lock(&inode->i_lock);
+	if (ei->i_richacl != EXT4_RICHACL_NOT_CACHED)
+		acl = richacl_get(ei->i_richacl);
+	spin_unlock(&inode->i_lock);
+
+	return acl;
+}
+
+static inline void
+ext4_iset_richacl(struct inode *inode, struct richacl *acl)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	spin_lock(&inode->i_lock);
+	if (ei->i_richacl != EXT4_RICHACL_NOT_CACHED)
+		richacl_put(ei->i_richacl);
+	ei->i_richacl = richacl_get(acl);
+	spin_unlock(&inode->i_lock);
+}
+
+static struct richacl *
+ext4_get_richacl(struct inode *inode)
+{
+	const int name_index = EXT4_XATTR_INDEX_RICHACL;
+	void *value = NULL;
+	struct richacl *acl;
+	int retval;
+
+	if (!IS_RICHACL(inode))
+		return ERR_PTR(-EOPNOTSUPP);
+	acl = ext4_iget_richacl(inode);
+	if (acl != EXT4_RICHACL_NOT_CACHED)
+		return acl;
+	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
+	if (retval > 0) {
+		value = kmalloc(retval, GFP_KERNEL);
+		if (!value)
+			return ERR_PTR(-ENOMEM);
+		retval = ext4_xattr_get(inode, name_index, "", value, retval);
+	}
+	if (retval > 0) {
+		acl = richacl_from_xattr(value, retval);
+		if (acl == ERR_PTR(-EINVAL))
+			acl = ERR_PTR(-EIO);
+	} else if (retval == -ENODATA || retval == -ENOSYS)
+		acl = NULL;
+	else
+		acl = ERR_PTR(retval);
+	kfree(value);
+
+	if (!IS_ERR_OR_NULL(acl))
+		ext4_iset_richacl(inode, acl);
+
+	return acl;
+}
+
+static int
+ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
+{
+	const int name_index = EXT4_XATTR_INDEX_RICHACL;
+	size_t size = 0;
+	void *value = NULL;
+	int retval;
+
+	if (acl) {
+		mode_t mode = inode->i_mode;
+		if (richacl_equiv_mode(acl, &mode) == 0) {
+			inode->i_mode = mode;
+			ext4_mark_inode_dirty(handle, inode);
+			acl = NULL;
+		}
+	}
+	if (acl) {
+		size = richacl_xattr_size(acl);
+		value = kmalloc(size, GFP_KERNEL);
+		if (!value)
+			return -ENOMEM;
+		richacl_to_xattr(acl, value);
+	}
+	if (handle)
+		retval = ext4_xattr_set_handle(handle, inode, name_index, "",
+					       value, size, 0);
+	else
+		retval = ext4_xattr_set(inode, name_index, "", value, size, 0);
+	kfree(value);
+	if (!retval)
+		ext4_iset_richacl(inode, acl);
+
+	return retval;
+}
+
+int
+ext4_richacl_permission(struct inode *inode, unsigned int mask)
+{
+	struct richacl *acl;
+	int retval;
+
+	if (!IS_RICHACL(inode))
+		BUG();
+
+	acl = ext4_get_richacl(inode);
+	if (acl && IS_ERR(acl))
+		retval = PTR_ERR(acl);
+	else {
+		retval = richacl_inode_permission(inode, acl, mask);
+		richacl_put(acl);
+	}
+
+	return retval;
+}
+
+int ext4_permission(struct inode *inode, int mask)
+{
+	if (IS_RICHACL(inode))
+		return ext4_richacl_permission(inode,
+					richacl_want_to_mask(mask));
+	else
+		return generic_permission(inode, mask, ext4_check_acl);
+}
+
+int ext4_may_create(struct inode *dir, int isdir)
+{
+	return richacl_may_create(dir, isdir, ext4_richacl_permission);
+}
+
+int ext4_may_delete(struct inode *dir, struct inode *inode, int replace)
+{
+	return richacl_may_delete(dir, inode, replace, ext4_richacl_permission);
+}
+
+int
+ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	struct richacl *dir_acl = NULL;
+
+	if (!S_ISLNK(inode->i_mode)) {
+		dir_acl = ext4_get_richacl(dir);
+		if (IS_ERR(dir_acl))
+			return PTR_ERR(dir_acl);
+	}
+	if (dir_acl) {
+		struct richacl *acl;
+		int retval;
+
+		acl = richacl_inherit_inode(dir_acl, inode);
+		richacl_put(dir_acl);
+
+		retval = PTR_ERR(acl);
+		if (acl && !IS_ERR(acl)) {
+			retval = ext4_set_richacl(handle, inode, acl);
+			richacl_put(acl);
+		}
+		return retval;
+	} else {
+		inode->i_mode &= ~current_umask();
+		return 0;
+	}
+}
+
+int
+ext4_richacl_chmod(struct inode *inode)
+{
+	struct richacl *acl;
+	int retval;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = ext4_get_richacl(inode);
+	if (IS_ERR_OR_NULL(acl))
+		return PTR_ERR(acl);
+	acl = richacl_chmod(acl, inode->i_mode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	retval = ext4_set_richacl(NULL, inode, acl);
+	richacl_put(acl);
+
+	return retval;
+}
+
+static size_t
+ext4_xattr_list_richacl(struct dentry *dentry, char *list, size_t list_len,
+			const char *name, size_t name_len, int type)
+{
+	const size_t size = sizeof(RICHACL_XATTR);
+	if (!IS_RICHACL(dentry->d_inode))
+		return 0;
+	if (list && size <= list_len)
+		memcpy(list, RICHACL_XATTR, size);
+	return size;
+}
+
+static int
+ext4_xattr_get_richacl(struct dentry *dentry, const char *name, void *buffer,
+		size_t buffer_size, int type)
+{
+	struct richacl *acl;
+	size_t size;
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	acl = ext4_get_richacl(dentry->d_inode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+	size = richacl_xattr_size(acl);
+	if (buffer) {
+		if (size > buffer_size)
+			return -ERANGE;
+		richacl_to_xattr(acl, buffer);
+	}
+	richacl_put(acl);
+
+	return size;
+}
+
+static int
+ext4_xattr_set_richacl(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags, int type)
+{
+	handle_t *handle;
+	struct richacl *acl = NULL;
+	int retval, retries = 0;
+	struct inode *inode = dentry->d_inode;
+
+	if (!IS_RICHACL(dentry->d_inode))
+		return -EOPNOTSUPP;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	if (current_fsuid() != inode->i_uid &&
+	    ext4_richacl_permission(inode, ACE4_WRITE_ACL) &&
+	    !capable(CAP_FOWNER))
+		return -EPERM;
+	if (value) {
+		acl = richacl_from_xattr(value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+
+		inode->i_mode &= ~S_IRWXUGO;
+		inode->i_mode |= richacl_masks_to_mode(acl);
+	}
+
+retry:
+	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	ext4_mark_inode_dirty(handle, inode);
+	retval = ext4_set_richacl(handle, inode, acl);
+	ext4_journal_stop(handle);
+	if (retval == ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+	richacl_put(acl);
+	return retval;
+}
+
+const struct xattr_handler ext4_richacl_xattr_handler = {
+	.prefix	= RICHACL_XATTR,
+	.list	= ext4_xattr_list_richacl,
+	.get	= ext4_xattr_get_richacl,
+	.set	= ext4_xattr_set_richacl,
+};
diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
new file mode 100644
index 0000000..00d89f2
--- /dev/null
+++ b/fs/ext4/richacl.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#ifndef __FS_EXT4_RICHACL_H
+#define __FS_EXT4_RICHACL_H
+
+#include <linux/richacl.h>
+
+#ifdef CONFIG_EXT4_FS_RICHACL
+
+# define EXT4_IS_RICHACL(inode) IS_RICHACL(inode)
+
+/* Value for i_richacl if RICHACL has not been cached */
+# define EXT4_RICHACL_NOT_CACHED ((void *)-1)
+
+extern int ext4_permission(struct inode *, int);
+extern int ext4_richacl_permission(struct inode *, unsigned int);
+extern int ext4_may_create(struct inode *, int);
+extern int ext4_may_delete(struct inode *, struct inode *, int);
+extern int ext4_init_richacl(handle_t *, struct inode *, struct inode *);
+extern int ext4_richacl_chmod(struct inode *);
+
+#else  /* CONFIG_FS_EXT4_RICHACL */
+
+# define EXT4_IS_RICHACL(inode) (0)
+
+# define ext4_permission NULL
+# define ext4_may_create NULL
+# define ext4_may_delete NULL
+# define ext4_richacl_permission NULL
+
+static inline int
+ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+
+static inline int
+ext4_richacl_chmod(struct inode *inode)
+{
+	return 0;
+}
+
+#endif  /* CONFIG_FS_EXT4_RICHACL */
+#endif  /* __FS_EXT4_RICHACL_H */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3836908..520ab44 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -46,6 +46,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "richacl.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -740,7 +741,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
-
+#ifdef CONFIG_EXT4_FS_RICHACL
+	ei->i_richacl = EXT4_RICHACL_NOT_CACHED;
+#endif
 	ei->vfs_inode.i_version = 1;
 	ei->vfs_inode.i_data.writeback_index = 0;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
@@ -816,6 +819,13 @@ static void destroy_inodecache(void)
 static void ext4_clear_inode(struct inode *inode)
 {
 	dquot_drop(inode);
+#ifdef CONFIG_EXT4_FS_RICHACL
+	if (EXT4_I(inode)->i_richacl &&
+		EXT4_I(inode)->i_richacl != EXT4_RICHACL_NOT_CACHED) {
+		richacl_put(EXT4_I(inode)->i_richacl);
+		EXT4_I(inode)->i_richacl = EXT4_RICHACL_NOT_CACHED;
+	}
+#endif
 	ext4_discard_preallocations(inode);
 	if (EXT4_JOURNAL(inode))
 		jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0433800..a4c8382 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -107,6 +107,9 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	[EXT4_XATTR_INDEX_RICHACL]           = &ext4_richacl_xattr_handler,
+#endif
 };
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
@@ -119,6 +122,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	&ext4_richacl_xattr_handler,
+#endif
 	NULL
 };
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 518e96e..d65a62f 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_RICHACL		7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -70,6 +71,7 @@ extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_acl_access_handler;
 extern const struct xattr_handler ext4_xattr_acl_default_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
+extern const struct xattr_handler ext4_richacl_xattr_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
-- 
1.7.2.rc1

_______________________________________________
NOTE: THIS LIST IS DEPRECATED.  Please use linux-nfs@vger.kernel.org instead.
(To subscribe to linux-nfs@vger.kernel.org: send "subscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org.)

NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
