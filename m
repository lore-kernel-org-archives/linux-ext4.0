From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 05/23] ext4: Implement rich acl for ext4
Date: Mon,  1 Feb 2010 11:04:47 +0530
Message-ID: <1265002505-8387-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

This need to be enabled by tune2fs or during mkfs.ext4

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/Kconfig   |    7 +
 fs/ext4/Makefile  |    1 +
 fs/ext4/acl.c     |   40 +++++--
 fs/ext4/ext4.h    |   13 ++-
 fs/ext4/file.c    |    5 +-
 fs/ext4/ialloc.c  |    7 +-
 fs/ext4/inode.c   |   77 ++++++++++++-
 fs/ext4/namei.c   |   21 +++-
 fs/ext4/richacl.c |  317 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/richacl.h |   47 ++++++++
 fs/ext4/super.c   |   58 +++++++---
 fs/ext4/xattr.c   |    6 +
 fs/ext4/xattr.h   |    2 +
 13 files changed, 563 insertions(+), 38 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..39fcb29 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -83,3 +83,10 @@ config EXT4_DEBUG
 
 	  If you select Y here, then you will be able to turn on debugging
 	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+
+config EXT4_FS_RICHACL
+      bool "Ext4 native rich Access  Control List (EXPERIMENTAL)"
+      depends on EXT4_FS_XATTR && EXPERIMENTAL
+      select FS_RICHACL
+      help
+        Allow to use rich acl model
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 8867b2a..4acbffe 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -11,3 +11,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_FS_RICHACL)  	+= richacl.o
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8a2a29d..5f09df4 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -14,6 +14,28 @@
 #include "xattr.h"
 #include "acl.h"
 
+
+/*
+ * Check wether posix acl need to be enabled for the
+ * file system
+ */
+static inline int posix_acl_enabled(struct super_block *sb)
+{
+
+	if (!test_opt(sb, ACL))
+		return 0;
+	/*
+	 * we disable posix acl if the fil system have
+	 * richacl feature enabled. Having richacl feature
+	 * enabled indicate that the user prever richacl model
+	 */
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					EXT4_FEATURE_INCOMPAT_RICHACL))
+		return 0;
+	else
+		return 1;
+}
+
 /*
  * Convert from filesystem to in-memory representation.
  */
@@ -139,7 +161,7 @@ ext4_get_acl(struct inode *inode, int type)
 	struct posix_acl *acl;
 	int retval;
 
-	if (!test_opt(inode->i_sb, POSIX_ACL))
+	if (!posix_acl_enabled(inode->i_sb))
 		return NULL;
 
 	acl = get_cached_acl(inode, type);
@@ -265,7 +287,7 @@ ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 	int error = 0;
 
 	if (!S_ISLNK(inode->i_mode)) {
-		if (test_opt(dir->i_sb, POSIX_ACL)) {
+		if (test_opt(dir->i_sb, ACL)) {
 			acl = ext4_get_acl(dir, ACL_TYPE_DEFAULT);
 			if (IS_ERR(acl))
 				return PTR_ERR(acl);
@@ -273,7 +295,7 @@ ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 		if (!acl)
 			inode->i_mode &= ~current_umask();
 	}
-	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
+	if (test_opt(inode->i_sb, ACL) && acl) {
 		struct posix_acl *clone;
 		mode_t mode;
 
@@ -325,10 +347,10 @@ ext4_acl_chmod(struct inode *inode)
 	struct posix_acl *acl, *clone;
 	int error;
 
+	if (!posix_acl_enabled(inode->i_sb))
+		return 0;
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
-	if (!test_opt(inode->i_sb, POSIX_ACL))
-		return 0;
 	acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
 	if (IS_ERR(acl) || !acl)
 		return PTR_ERR(acl);
@@ -369,7 +391,7 @@ ext4_xattr_list_acl_access(struct dentry *dentry, char *list, size_t list_len,
 {
 	const size_t size = sizeof(POSIX_ACL_XATTR_ACCESS);
 
-	if (!test_opt(dentry->d_sb, POSIX_ACL))
+	if (!posix_acl_enabled(dentry->d_sb))
 		return 0;
 	if (list && size <= list_len)
 		memcpy(list, POSIX_ACL_XATTR_ACCESS, size);
@@ -382,7 +404,7 @@ ext4_xattr_list_acl_default(struct dentry *dentry, char *list, size_t list_len,
 {
 	const size_t size = sizeof(POSIX_ACL_XATTR_DEFAULT);
 
-	if (!test_opt(dentry->d_sb, POSIX_ACL))
+	if (!posix_acl_enabled(dentry->d_sb))
 		return 0;
 	if (list && size <= list_len)
 		memcpy(list, POSIX_ACL_XATTR_DEFAULT, size);
@@ -398,7 +420,7 @@ ext4_xattr_get_acl(struct dentry *dentry, const char *name, void *buffer,
 
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
-	if (!test_opt(dentry->d_sb, POSIX_ACL))
+	if (!posix_acl_enabled(dentry->d_sb))
 		return -EOPNOTSUPP;
 
 	acl = ext4_get_acl(dentry->d_inode, type);
@@ -423,7 +445,7 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
 
 	if (strcmp(name, "") != 0)
 		return -EINVAL;
-	if (!test_opt(inode->i_sb, POSIX_ACL))
+	if (!posix_acl_enabled(dentry->d_sb))
 		return -EOPNOTSUPP;
 	if (!is_owner_or_cap(inode))
 		return -EPERM;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af7b626..13df624 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -722,6 +722,10 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+#ifdef CONFIG_EXT4_FS_RICHACL
+	struct richacl   *i_richacl;
+#endif
+
 };
 
 /*
@@ -756,7 +760,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
 #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
 #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
-#define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
+#define EXT4_MOUNT_ACL			0x08000	/* Access Control Lists enabled*/
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
 #define EXT4_MOUNT_NOBH			0x40000 /* No bufferheads */
@@ -1129,14 +1133,16 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_RICHACL		0x0400
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
-					 EXT4_FEATURE_INCOMPAT_64BIT| \
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_64BIT|   \
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
+					 EXT4_FEATURE_INCOMPAT_RICHACL)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
@@ -1717,6 +1723,7 @@ extern const struct file_operations ext4_file_operations;
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
 extern struct dentry *ext4_get_parent(struct dentry *child);
+extern int ext4_permission(struct inode *, int);
 
 /* symlink.c */
 extern const struct inode_operations ext4_symlink_inode_operations;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 9630583..a300eb2 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -27,6 +27,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 /*
  * Called when an inode is released. Note that this is different
@@ -158,8 +159,10 @@ const struct inode_operations ext4_file_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext4_check_acl,
 	.fallocate	= ext4_fallocate,
 	.fiemap		= ext4_fiemap,
+	.permission	= ext4_permission,
+	.may_create	= ext4_may_create,
+	.may_delete	= ext4_may_delete,
 };
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f3624ea..15e80b8 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -1038,8 +1039,10 @@ got:
 		err = -EDQUOT;
 		goto fail_drop;
 	}
-
-	err = ext4_init_acl(handle, inode, dir);
+	if (richacl_enabled(sb))
+		err = ext4_richacl_init(handle, inode, dir);
+	else
+		err = ext4_init_acl(handle, inode, dir);
 	if (err)
 		goto fail_free_drop;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..24506df 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -43,6 +43,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "ext4_extents.h"
+#include "richacl.h"
 
 #include <trace/events/ext4.h>
 
@@ -4792,6 +4793,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 
+#ifdef CONFIG_EXT4_FS_RICHACL
+	ei->i_richacl = EXT4_RICHACL_NOT_CACHED;
+#endif
 	ei->i_state = 0;
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
@@ -5193,6 +5197,68 @@ int ext4_write_inode(struct inode *inode, int wait)
 	return err;
 }
 
+#ifdef CONFIG_EXT4_FS_RICHACL
+static int ext4_inode_change_ok(struct inode *inode, struct iattr *attr)
+{
+	unsigned int ia_valid = attr->ia_valid;
+
+	if (!richacl_enabled(inode->i_sb))
+		return inode_change_ok(inode, attr);
+
+	/* If force is set do it anyway. */
+	if (ia_valid & ATTR_FORCE)
+		return 0;
+
+	/* Make sure a caller can chown. */
+	if ((ia_valid & ATTR_UID) &&
+	    (current_fsuid() != inode->i_uid ||
+	     attr->ia_uid != inode->i_uid) &&
+	    (current_fsuid() != attr->ia_uid ||
+	     ext4_richacl_permission(inode, ACE4_WRITE_OWNER)) &&
+	    !capable(CAP_CHOWN))
+		goto error;
+
+	/* Make sure caller can chgrp. */
+	if ((ia_valid & ATTR_GID)) {
+		int in_group = in_group_p(attr->ia_gid);
+		if ((current_fsuid() != inode->i_uid ||
+		    (!in_group && attr->ia_gid != inode->i_gid)) &&
+		    (!in_group ||
+		     ext4_richacl_permission(inode, ACE4_WRITE_OWNER)) &&
+		    !capable(CAP_CHOWN))
+			goto error;
+	}
+
+	/* Make sure a caller can chmod. */
+	if (ia_valid & ATTR_MODE) {
+		if (current_fsuid() != inode->i_uid &&
+		    ext4_richacl_permission(inode, ACE4_WRITE_ACL) &&
+		    !capable(CAP_FOWNER))
+			goto error;
+		/* Also check the setgid bit! */
+		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
+				inode->i_gid) && !capable(CAP_FSETID))
+			attr->ia_mode &= ~S_ISGID;
+	}
+
+	/* Check for setting the inode time. */
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
+		if (current_fsuid() != inode->i_uid &&
+		    ext4_richacl_permission(inode, ACE4_WRITE_ATTRIBUTES) &&
+		    !capable(CAP_FOWNER))
+			goto error;
+	}
+	return 0;
+error:
+	return -EPERM;
+}
+#else
+static inline int ext4_inode_change_ok(struct inode *inode, struct iattr *attr)
+{
+	return inode_change_ok(inode, attr);
+}
+#endif
+
 /*
  * ext4_setattr()
  *
@@ -5223,7 +5289,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	int error, rc = 0;
 	const unsigned int ia_valid = attr->ia_valid;
 
-	error = inode_change_ok(inode, attr);
+	error = ext4_inode_change_ok(inode, attr);
 	if (error)
 		return error;
 
@@ -5307,9 +5373,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (inode->i_nlink)
 		ext4_orphan_del(NULL, inode);
 
-	if (!rc && (ia_valid & ATTR_MODE))
-		rc = ext4_acl_chmod(inode);
-
+	if (!rc && (ia_valid & ATTR_MODE)) {
+		if (richacl_enabled(inode->i_sb))
+			rc = ext4_richacl_chmod(inode);
+		else
+			rc = ext4_acl_chmod(inode);
+	}
 err_out:
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 17a17e1..48ee6a3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -39,6 +39,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "richacl.h"
 
 /*
  * define how far ahead to read directories while searching them.
@@ -2511,6 +2512,18 @@ end_rename:
 	return retval;
 }
 
+int ext4_permission(struct inode *inode, int mask)
+{
+
+#ifdef CONFIG_EXT4_FS_RICHACL
+	if (richacl_enabled(inode->i_sb))
+		return ext4_richacl_permission(inode,
+					richacl_want_to_mask(mask));
+	else
+#endif
+	return generic_permission(inode, mask, ext4_check_acl);
+}
+
 /*
  * directories can handle most operations...
  */
@@ -2531,8 +2544,10 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext4_check_acl,
 	.fiemap         = ext4_fiemap,
+	.permission	= ext4_permission,
+	.may_create	= ext4_may_create,
+	.may_delete	= ext4_may_delete,
 };
 
 const struct inode_operations ext4_special_inode_operations = {
@@ -2543,5 +2558,7 @@ const struct inode_operations ext4_special_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.check_acl	= ext4_check_acl,
+	.permission	= ext4_permission,
+	.may_create	= ext4_may_create,
+	.may_delete	= ext4_may_delete,
 };
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
new file mode 100644
index 0000000..1c78086
--- /dev/null
+++ b/fs/ext4/richacl.c
@@ -0,0 +1,317 @@
+/*
+ * Copyright (C) 2009 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/richacl_xattr.h>
+
+#include "ext4.h"
+#include "ext4_jbd2.h"
+#include "xattr.h"
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
+	if (!richacl_enabled(inode->i_sb))
+		return NULL;
+
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
+	if (!IS_ERR(acl))
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
+	if (!richacl_enabled(inode->i_sb))
+		BUG();
+
+	acl = ext4_get_richacl(inode);
+	if (!acl)
+		retval = richacl_generic_permission(inode, mask);
+	else if (IS_ERR(acl))
+		retval = PTR_ERR(acl);
+	else {
+		retval = richacl_permission(inode, acl, mask);
+		richacl_put(acl);
+	}
+
+	return retval;
+}
+
+int ext4_may_create(struct inode *dir, int isdir)
+{
+	int error;
+
+	if (richacl_enabled(dir->i_sb)) {
+		unsigned int mask = (isdir ? ACE4_ADD_SUBDIRECTORY :
+					ACE4_ADD_FILE) | ACE4_EXECUTE;
+
+		error = ext4_richacl_permission(dir, mask);
+	} else
+		error = ext4_permission(dir, MAY_WRITE | MAY_EXEC);
+
+	return error;
+}
+
+static int check_sticky(struct inode *dir, struct inode *inode)
+{
+	if (!(dir->i_mode & S_ISVTX))
+		return 0;
+	if (inode->i_uid == current_fsuid())
+		return 0;
+	if (dir->i_uid == current_fsuid())
+		return 0;
+	return !capable(CAP_FOWNER);
+}
+
+int ext4_may_delete(struct inode *dir, struct inode *inode)
+{
+	int error;
+
+	if (richacl_enabled(inode->i_sb)) {
+		error = ext4_richacl_permission(dir,
+					ACE4_DELETE_CHILD|ACE4_EXECUTE);
+		if (!error && check_sticky(dir, inode))
+			error = -EPERM;
+		if (error && !ext4_richacl_permission(inode, ACE4_DELETE))
+			error = 0;
+	} else {
+		error = ext4_permission(dir, MAY_WRITE | MAY_EXEC);
+		if (!error && check_sticky(dir, inode))
+			error = -EPERM;
+	}
+
+	return error;
+}
+
+int
+ext4_richacl_init(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	struct richacl *dir_acl = NULL, *acl;
+	int retval;
+
+	if (!test_opt(dir->i_sb, ACL))
+		return 0;
+	if (!S_ISLNK(inode->i_mode))
+		dir_acl = ext4_get_richacl(dir);
+	if (!dir_acl || IS_ERR(dir_acl)) {
+		inode->i_mode &= ~current_umask();
+		return PTR_ERR(dir_acl);
+	}
+	acl = richacl_inherit(dir_acl, inode->i_mode);
+	richacl_put(dir_acl);
+
+	retval = PTR_ERR(acl);
+	if (acl && !IS_ERR(acl)) {
+		retval = ext4_set_richacl(handle, inode, acl);
+		inode->i_mode = (inode->i_mode & ~S_IRWXUGO) |
+				richacl_masks_to_mode(acl);
+		richacl_put(acl);
+	}
+	return retval;
+}
+
+int
+ext4_richacl_chmod(struct inode *inode)
+{
+	struct richacl *acl;
+	int retval;
+
+	if (!richacl_enabled(inode->i_sb))
+		return 0;
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+	acl = ext4_get_richacl(inode);
+	if (!acl || IS_ERR(acl))
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
+	if (!richacl_enabled(dentry->d_sb))
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
+	if (!richacl_enabled(dentry->d_sb))
+		return -EOPNOTSUPP;
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+
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
+	if (!richacl_enabled(dentry->d_sb))
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
+struct xattr_handler ext4_richacl_xattr_handler = {
+	.prefix	= RICHACL_XATTR,
+	.list	= ext4_xattr_list_richacl,
+	.get	= ext4_xattr_get_richacl,
+	.set	= ext4_xattr_set_richacl,
+};
diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
new file mode 100644
index 0000000..3dc162c
--- /dev/null
+++ b/fs/ext4/richacl.h
@@ -0,0 +1,47 @@
+#ifndef __FS_EXT4_RICHACL_H
+#define __FS_EXT4_RICHACL_H
+
+#ifdef CONFIG_EXT4_FS_RICHACL
+
+#include <linux/richacl.h>
+
+/* Value for i_richacl if RICHACL has not been cached */
+#define EXT4_RICHACL_NOT_CACHED ((void *)-1)
+
+extern int ext4_richacl_permission(struct inode *, unsigned int);
+extern int ext4_may_create(struct inode *, int);
+extern int ext4_may_delete(struct inode *, struct inode *);
+extern int ext4_richacl_init(handle_t *, struct inode *, struct inode *);
+extern int ext4_richacl_chmod(struct inode *);
+
+#else  /* CONFIG_FS_EXT4_RICHACL */
+
+#define ext4_may_create NULL
+#define ext4_may_delete NULL
+
+static inline int
+ext4_richacl_init(handle_t *handle, struct inode *inode, struct inode *dir)
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
+
+static inline int richacl_enabled(struct super_block *sb)
+{
+	if (!test_opt(sb, ACL))
+		return 0;
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					EXT4_FEATURE_INCOMPAT_RICHACL))
+		return 1;
+	else
+		return 0;
+}
+
+#endif  /* __FS_EXT4_RICHACL_H */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..fb051a1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -46,6 +46,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "richacl.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -687,7 +688,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
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
@@ -761,6 +764,14 @@ static void destroy_inodecache(void)
 
 static void ext4_clear_inode(struct inode *inode)
 {
+
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
@@ -861,10 +872,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nouser_xattr");
 	}
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
-	if (test_opt(sb, POSIX_ACL) && !(def_mount_opts & EXT4_DEFM_ACL))
+#if defined(CONFIG_EXT4_FS_POSIX_ACL) || defined(CONFIG_EXT4_FS_RICHACL)
+	if (test_opt(sb, ACL) && !(def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",acl");
-	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
+	if (!test_opt(sb, ACL) && (def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",noacl");
 #endif
 	if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
@@ -1204,6 +1215,26 @@ static ext4_fsblk_t get_sb_block(void **data)
 	return sb_block;
 }
 
+static void enable_acl(struct ext4_sb_info *sbi)
+{
+#if !defined(CONFIG_EXT4_FS_POSIX_ACL) && !defined(CONFIG_EXT4_FS_RICHACL)
+	ext4_msg(sb, KERN_ERR, "acl options not supported");
+	return;
+#endif
+	set_opt(sbi->s_mount_opt, ACL);
+	return;
+}
+
+static void disable_acl(struct ext4_sb_info *sbi)
+{
+#if !defined(CONFIG_EXT4_FS_POSIX_ACL) && !defined(CONFIG_EXT4_FS_RICHACL)
+	ext4_msg(sb, KERN_ERR, "noacl options not supported");
+	return;
+#endif
+	clear_opt(sbi->s_mount_opt, ACL);
+	return;
+}
+
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
 
 static int parse_options(char *options, struct super_block *sb,
@@ -1297,19 +1328,12 @@ static int parse_options(char *options, struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "(no)user_xattr options not supported");
 			break;
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
 		case Opt_acl:
-			set_opt(sbi->s_mount_opt, POSIX_ACL);
+			enable_acl(sbi);
 			break;
 		case Opt_noacl:
-			clear_opt(sbi->s_mount_opt, POSIX_ACL);
+			disable_acl(sbi);
 			break;
-#else
-		case Opt_acl:
-		case Opt_noacl:
-			ext4_msg(sb, KERN_ERR, "(no)acl options not supported");
-			break;
-#endif
 		case Opt_journal_update:
 			/* @@@ FIXME */
 			/* Eventually we will want to be able to create
@@ -2440,9 +2464,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (def_mount_opts & EXT4_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
+#if defined(CONFIG_EXT4_FS_POSIX_ACL) || defined(CONFIG_EXT4_FS_RICHACL)
 	if (def_mount_opts & EXT4_DEFM_ACL)
-		set_opt(sbi->s_mount_opt, POSIX_ACL);
+		set_opt(sbi->s_mount_opt, ACL);
 #endif
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		sbi->s_mount_opt |= EXT4_MOUNT_JOURNAL_DATA;
@@ -2477,7 +2501,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		((sbi->s_mount_opt & EXT4_MOUNT_ACL) ? MS_POSIXACL : 0);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
@@ -3514,7 +3538,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		ext4_abort(sb, __func__, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		((sbi->s_mount_opt & EXT4_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+		((sbi->s_mount_opt & EXT4_MOUNT_ACL) ? MS_POSIXACL : 0);
 
 	es = sbi->s_es;
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index f3a2f7e..649aeea 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -107,6 +107,9 @@ static struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	[EXT4_XATTR_INDEX_RICHACL]           = &ext4_richacl_xattr_handler,
+#endif
 };
 
 struct xattr_handler *ext4_xattr_handlers[] = {
@@ -119,6 +122,9 @@ struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_FS_RICHACL
+	&ext4_richacl_xattr_handler,
+#endif
 	NULL
 };
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 8ede88b..daef032 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_RICHACL		7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -70,6 +71,7 @@ extern struct xattr_handler ext4_xattr_trusted_handler;
 extern struct xattr_handler ext4_xattr_acl_access_handler;
 extern struct xattr_handler ext4_xattr_acl_default_handler;
 extern struct xattr_handler ext4_xattr_security_handler;
+extern struct xattr_handler ext4_richacl_xattr_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
-- 
1.7.0.rc0.48.gdace5

