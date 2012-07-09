From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: Implement subtree ID support for ext4 filesystem
Date: Mon,  9 Jul 2012 19:28:44 +0400
Message-ID: <1341847725-26114-3-git-send-email-dmonakhov@openvz.org>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46285 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2GIP25 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2012 11:28:57 -0400
In-Reply-To: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Abstract
  A subtree of a directory tree T is a tree consisting of a directory
  (the subtree root) in T and all of its descendants in T.

  *NOTE*: User is allowed to break pure subtree hierarchy via manual
          id manipulation.

  Subtree subtrees assumptions:
  (1) Each inode has an id. This id is persistently stored inside
      inode (xattr, usually inside ibody)
  (2) Subtree id is inherent from parent directory

  This feature is similar to project-id in XFS. One may assign some id to
  a subtree. Each entry from the subtree may be accounted in directory
  subtree quota. Will appear in later patches.

* Disk layout
  Subtree id is stored on disk inside xattr usually inside ibody.
  Xattr is used only as a data storage, It has not user visible xattr
  interface.

* User interface
  Subtree id is accessible via generic xattr interface "system.subtree"

* Notes
  ext4_setattr interface to subtreeid: Semantically subtree id must being changed
  similar to uid/gid, but subtree id is stored inside xattr so on-disk
  structures updates is not that trivial, so I've move subtree change
  logic to separate function.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/Kconfig   |   12 +++
 fs/ext4/Makefile  |    1 +
 fs/ext4/ext4.h    |    3 +
 fs/ext4/ialloc.c  |    6 ++
 fs/ext4/inode.c   |    4 +
 fs/ext4/subtree.c |  215 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/subtree.h |   45 +++++++++++
 fs/ext4/super.c   |    7 ++
 fs/ext4/xattr.c   |    7 ++
 fs/ext4/xattr.h   |    2 +
 10 files changed, 302 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/subtree.c
 create mode 100644 fs/ext4/subtree.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index c22f170..f571168 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -77,6 +77,18 @@ config EXT4_FS_SECURITY
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
 
+config EXT4_SUBTREE
+	bool "Ext4 subtree id support"
+	select SUBTREE
+	depends on EXT4_FS_XATTR
+	help
+	  Enables subtree inode identifier support for ext4 filesystem.
+	  This feature allow to assign extended inode's identifier similar to
+	  uid/gid. Value is stored in xattr "system.subtree" and may be used
+	  as additional quota limit.
+
+	  If unsure, say N.
+
 config EXT4_DEBUG
 	bool "EXT4 debugging support"
 	depends on EXT4_FS
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 56fd8f8..df0a54c 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,3 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_SUBTREE)		+= subtree.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cfc4e01..f831210 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -925,6 +925,9 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+#ifdef CONFIG_EXT4_SUBTREE
+	__u32 i_subtree;
+#endif
 };
 
 /*
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d48e8b1..ff73fea 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "subtree.h"
 
 #include <trace/events/ext4.h>
 
@@ -898,6 +899,8 @@ got:
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 
+	ext4_set_subtree(inode, ext4_get_subtree(dir));
+
 	ret = inode;
 	dquot_initialize(inode);
 	err = dquot_alloc_inode(inode);
@@ -911,6 +914,9 @@ got:
 	err = ext4_init_security(handle, inode, dir, qstr);
 	if (err)
 		goto fail_free_drop;
+	err = ext4_subtree_init(handle, inode);
+	if (err)
+		goto fail_free_drop;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		/* set extent flag only for directory, file and normal symlink*/
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..caf72f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -42,6 +42,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "truncate.h"
+#include "subtree.h"
 
 #include <trace/events/ext4.h>
 
@@ -3870,6 +3871,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	}
 	if (ret)
 		goto bad_inode;
+	ret = ext4_subtree_read(inode);
+	if (ret)
+		goto bad_inode;
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
diff --git a/fs/ext4/subtree.c b/fs/ext4/subtree.c
new file mode 100644
index 0000000..0486740
--- /dev/null
+++ b/fs/ext4/subtree.c
@@ -0,0 +1,215 @@
+/*
+ * linux/fs/ext4/subtree.c
+ *
+ * Copyright (C) 2012 Parallels Inc
+ * Dmitry Monakhov <dmonakhov@openvz.org>
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/capability.h>
+#include <linux/fs.h>
+#include <linux/quotaops.h>
+#include "ext4_jbd2.h"
+#include "ext4.h"
+#include "xattr.h"
+#include "subtree.h"
+
+/*
+ * Subtree assumptions:
+ * (1) Each inode has subtree id. This id is persistently stored inside
+ *     inode's xattr, usually inside ibody
+ * (2) Subtree id is inherent from parent directory
+ */
+
+/*
+ * Read subtree id from inode's xattr
+ * Locking: none
+ */
+int ext4_subtree_xattr_read(struct inode *inode, unsigned int *subtree)
+{
+	__le32 dsk_subtree;
+	int retval;
+
+	retval = ext4_xattr_get(inode, EXT4_XATTR_INDEX_SUBTREE, "",
+				&dsk_subtree, sizeof(dsk_subtree));
+	if (retval > 0) {
+		if (retval != sizeof(dsk_subtree))
+			return -EIO;
+		else
+			retval = 0;
+	}
+	*subtree = le32_to_cpu(dsk_subtree);
+	return retval;
+}
+
+/*
+ * Save subtree id to inode's xattr
+ * Locking: none
+ */
+int ext4_subtree_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int subtree, int xflags)
+{
+	__le32 dskid = cpu_to_le32(subtree);
+	int retval;
+
+	retval = ext4_xattr_set_handle(handle,
+				       inode, EXT4_XATTR_INDEX_SUBTREE, "",
+				       &dskid, sizeof(dskid), xflags);
+	if (retval > 0) {
+		if (retval != sizeof(dskid))
+			retval =  -EIO;
+		else
+			retval = 0;
+	}
+	return retval;
+}
+
+/*
+ * Change subtree id.
+ * Called under inode->i_mutex
+ */
+int ext4_subtree_change(struct inode *inode, unsigned int new_subtree)
+{
+	/*
+	 * One data_trans_blocks chunk for xattr update.
+	 * One quota_trans_blocks chunk for quota transfer, and one
+	 * quota_trans_block chunk for emergency quota rollback transfer,
+	 * because quota rollback may result new quota blocks allocation.
+	 */
+	unsigned credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
+		EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb) * 2;
+	int ret, ret2 = 0;
+	unsigned retries = 0;
+	handle_t *handle;
+	struct dquot *dquot[MAXQUOTAS] = {};
+	int old_id = ext4_get_subtree(inode);
+
+	dquot_initialize(inode);
+	dquot[SBTRQUOTA] = dqget(inode->i_sb, new_subtree, SBTRQUOTA);
+retry:
+	handle = ext4_journal_start(inode, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		ext4_std_error(inode->i_sb, ret);
+		goto out;
+	}
+	/* Inode may not have subtree xattr yet. Create it explicitly */
+	ret = ext4_subtree_xattr_write(handle, inode, old_id, XATTR_CREATE);
+	if (ret == -EEXIST)
+		ret = 0;
+	if (ret) {
+		ret2 = ext4_journal_stop(handle);
+		if (ret2)
+			ret = ret2;
+		if (ret == -ENOSPC &&
+			ext4_should_retry_alloc(inode->i_sb, &retries))
+			goto retry;
+	}
+#ifdef CONFIG_QUOTA
+	ret = __dquot_transfer(inode, dquot);
+	if (ret)
+		return ret;
+#endif
+	ret = ext4_subtree_xattr_write(handle, inode, new_subtree,
+				       XATTR_REPLACE);
+	if (ret) {
+		/*
+		 * Function may fail only due to fatal error, Nor than less
+		 * we have try to rollback quota changes.
+		 */
+#ifdef CONFIG_QUOTA
+		__dquot_transfer(inode, dquot);
+#endif
+		ext4_std_error(inode->i_sb, ret);
+
+	} else
+		ext4_set_subtree(inode, new_subtree);
+
+	ret2 = ext4_journal_stop(handle);
+out:
+	dqput(dquot[SBTRQUOTA]);
+	if (ret2)
+		ret = ret2;
+	return ret;
+}
+
+int ext4_subtree_read(struct inode *inode)
+{
+	int ret = 0;
+	int subtree = 0;
+
+	ret = ext4_subtree_xattr_read(inode, &subtree);
+	if (ret == -ENODATA) {
+		subtree = 0;
+		ret = 0;
+	}
+	if (!ret)
+		ext4_set_subtree(inode, subtree);
+	return ret;
+}
+
+/*
+ * Initialize the subtree xattr of a new inode. Called from ext4_new_inode.
+ *
+ * dir->i_mutex: down
+ * inode->i_mutex: up (access to inode is still exclusive)
+ * Note: caller must assign correct subtree id to inode before.
+ */
+int ext4_subtree_init(handle_t *handle, struct inode *inode)
+{
+	return ext4_subtree_xattr_write(handle, inode, EXT4_I(inode)->i_subtree,
+				XATTR_CREATE);
+}
+
+static size_t
+ext4_xattr_subtree_list(struct dentry *dentry, char *list, size_t list_size,
+		const char *name, size_t name_len, int type)
+{
+	if (list && XATTR_SUBTREE_LEN <= list_size)
+		memcpy(list, XATTR_SUBTREE, XATTR_SUBTREE_LEN);
+	return XATTR_SUBTREE_LEN;
+}
+
+static int
+ext4_xattr_subtree_get(struct dentry *dentry, const char *name,
+		       void *buffer, size_t size, int type)
+{
+	int ret;
+	unsigned subtree;
+	char buf[32];
+
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	ret = ext4_subtree_xattr_read(dentry->d_inode, &subtree);
+	if (ret)
+		return ret;
+	snprintf(buf, sizeof(buf)-1, "%u", subtree);
+	buf[31] = '\0';
+	strncpy(buffer, buf, size);
+	return strlen(buf);
+}
+
+static int
+ext4_xattr_subtree_set(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags, int type)
+{
+	unsigned int new_subtree;
+	int ret = 0;
+	char buf[11];
+	if (strcmp(name, "") != 0 || size + 1 > sizeof(buf))
+		return -EINVAL;
+	memcpy(buf, (char *)value, size);
+	buf[size] = '\0';
+	if (kstrtouint(buf, 10, &new_subtree))
+		return -EINVAL;
+	return ext4_subtree_change(dentry->d_inode, new_subtree);
+}
+
+const struct xattr_handler ext4_xattr_subtree_handler = {
+	.prefix	= XATTR_SUBTREE,
+	.list	= ext4_xattr_subtree_list,
+	.get	= ext4_xattr_subtree_get,
+	.set	= ext4_xattr_subtree_set,
+};
diff --git a/fs/ext4/subtree.h b/fs/ext4/subtree.h
new file mode 100644
index 0000000..362de80
--- /dev/null
+++ b/fs/ext4/subtree.h
@@ -0,0 +1,45 @@
+#include <linux/xattr.h>
+#include <linux/fs.h>
+
+#ifdef CONFIG_EXT4_SUBTREE
+extern int ext4_subtree_xattr_read(struct inode *inode, unsigned int *subtree);
+extern int ext4_subtree_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int subtree, int xflags);
+extern int ext4_subtree_init(handle_t *handle, struct inode *inode);
+extern int ext4_subtree_read(struct inode *inode);
+extern int ext4_subtree_change(struct inode *inode, unsigned int new_subtree);
+static inline u32 ext4_get_subtree(const struct inode *inode)
+{
+	const struct ext4_inode_info *ei =
+		container_of(inode, const struct ext4_inode_info, vfs_inode);
+	return ei->i_subtree;
+}
+static inline void ext4_set_subtree(struct inode *inode, u32 id)
+{
+	EXT4_I(inode)->i_subtree = id;
+}
+#else
+#define ext4_get_subtree(inode) do {} while (0)
+#define ext4_set_subtree(inode, id) do {} while (0)
+static inline int ext4_subtree_xattr_read(struct inode *inode, unsigned int *id)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_subtree_xattr_write(handle_t *h, struct inode *inode,
+				unsigned int subtree, int xflags)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_subtree_read(struct inode *inode)
+{
+	return 0;
+}
+static inline int ext4_subtree_change(struct inode *inode, unsigned int id)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_subtree_init(handle_t *handle, struct inode *inode)
+{
+	return 0;
+}
+#endif
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 84c7ba4..3599c95 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -50,6 +50,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "subtree.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -1185,6 +1186,9 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+#ifdef CONFIG_EXT4_SUBTREE
+	.get_subtree      = ext4_get_subtree,
+#endif
 };
 
 static const struct super_operations ext4_nojournal_sops = {
@@ -1204,6 +1208,9 @@ static const struct super_operations ext4_nojournal_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+#ifdef CONFIG_EXT4_SUBTREE
+	.get_subtree      = ext4_get_subtree,
+#endif
 };
 
 static const struct export_operations ext4_export_ops = {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e56c9ed..7466544 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -107,6 +107,10 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_SUBTREE
+	[EXT4_XATTR_INDEX_SUBTREE]	     = &ext4_xattr_subtree_handler,
+#endif
+
 };
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
@@ -119,6 +123,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_SUBTREE
+	&ext4_xattr_subtree_handler,
+#endif
 	NULL
 };
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 91f31ca..b207f35 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_SUBTREE	        7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -72,6 +73,7 @@ extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_acl_access_handler;
 extern const struct xattr_handler ext4_xattr_acl_default_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
+extern const struct xattr_handler ext4_xattr_subtree_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
-- 
1.7.1

