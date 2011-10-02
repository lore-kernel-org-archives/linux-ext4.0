From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/6] ext4: Implement project ID support for ext4 filesystem
Date: Sun,  2 Oct 2011 23:44:40 +0400
Message-ID: <1317584681-29967-5-git-send-email-dmonakhov@openvz.org>
References: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, viro@ZenIV.linux.org.uk,
	adityakali@google.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48569 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1JBTlV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 15:41:21 -0400
In-Reply-To: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Abstract
  A subtree of a directory tree T is a tree consisting of a directory
  (the subtree root) in T and all of its descendants in T.

  *NOTE*: User is allowed to break pure subtree hierarchy via manual
          id manipulation.

  Project subtrees assumptions:
  (1) Each inode has an id. This id is persistently stored inside
      inode (xattr, usually inside ibody)
  (2) Project id is inherent from parent directory

  This feature is similar to project-id in XFS. One may assign some id to
  a subtree. Each entry from the subtree may be accounted in directory
  project quota. Will appear in later patches.

* Disk layout
  Project id is stored on disk inside xattr usually inside ibody.
  Xattr is used only as a data storage, It has not user visible xattr
  interface.

* User interface
  Project id is accessible via generic xattr interface "system.project_id"

* Notes
  ext4_setattr interface to prjid: Semantically prjid must being changed
  similar to uid/gid, but project_id is stored inside xattr so on-disk
  structures updates is not that trivial, so I've move prjid change
  logic to separate function.

TODO[INPROGRESS] add project quota support for lib/ext2fs lib/quota

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/Kconfig           |    8 ++
 fs/ext4/Makefile          |    1 +
 fs/ext4/ext4.h            |    4 +
 fs/ext4/ialloc.c          |    6 ++
 fs/ext4/inode.c           |    4 +
 fs/ext4/project.c         |  213 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/project.h         |   45 ++++++++++
 fs/ext4/super.c           |   16 +++-
 fs/ext4/xattr.c           |    7 ++
 fs/ext4/xattr.h           |    2 +
 include/linux/ext3_fs_i.h |    1 +
 11 files changed, 306 insertions(+), 1 deletions(-)
 create mode 100644 fs/ext4/project.c
 create mode 100644 fs/ext4/project.h

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..1c04c9f 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -74,6 +74,14 @@ config EXT4_FS_SECURITY
 
 	  If you are not using a security module that requires using
 	  extended attributes for file security labels, say N.
+config EXT4_PROJECT_ID
+	bool "Ext4 project_id support"
+	depends on PROJECT_ID
+	depends on EXT4_FS_XATTR
+	help
+	  Enables project inode identifier support for ext4 filesystem.
+	  This feature allow to assign some id to inodes similar to
+	  uid/gid. 
 
 config EXT4_DEBUG
 	bool "EXT4 debugging support"
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 56fd8f8..692fe56 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,3 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_PROJECT_ID)		+= project.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e92c51a..93151e7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -867,6 +867,9 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+#ifdef CONFIG_EXT4_PROJECT_ID
+	__u32 i_prjid;
+#endif
 };
 
 /*
@@ -904,6 +907,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
+#define EXT4_MOUNT_PROJECT_ID		0x40000 /* project owner id support */
 #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
 #define EXT4_MOUNT_QUOTA		0x300000 /* Some quota option set */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index fd96ea1..af81b5f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "project.h"
 
 #include <trace/events/ext4.h>
 
@@ -1033,6 +1034,8 @@ got:
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 
+	ext4_setprjid(inode, ext4_getprjid(dir));
+
 	ret = inode;
 	dquot_initialize(inode);
 	err = dquot_alloc_inode(inode);
@@ -1046,6 +1049,9 @@ got:
 	err = ext4_init_security(handle, inode, dir, qstr);
 	if (err)
 		goto fail_free_drop;
+	err = ext4_prj_init(handle, inode);
+	if (err)
+		goto fail_free_drop;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		/* set extent flag only for directory, file and normal symlink*/
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0defe0b..b005f04 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -44,6 +44,7 @@
 #include "acl.h"
 #include "ext4_extents.h"
 #include "truncate.h"
+#include "project.h"
 
 #include <trace/events/ext4.h>
 
@@ -3541,6 +3542,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	}
 	if (ret)
 		goto bad_inode;
+	ret = ext4_prj_read(inode);
+	if (ret)
+		goto bad_inode;
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
diff --git a/fs/ext4/project.c b/fs/ext4/project.c
new file mode 100644
index 0000000..a262a49
--- /dev/null
+++ b/fs/ext4/project.c
@@ -0,0 +1,213 @@
+/*
+ * linux/fs/ext4/projectid.c
+ *
+ * Copyright (C) 2011 Parallels Inc
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
+#include "project.h"
+
+
+/*
+ * PROJECT SUBTREE
+ * A subtree of a directory tree T is a tree consisting of a directory
+ * (the subtree root) in T and all of its descendants in T.
+ *
+ * Project Subtree's assumptions:
+ * (1) Each inode has subtree id. This id is persistently stored inside
+ *     inode's xattr, usually inside ibody
+ * (2) Subtree id is inherent from parent directory
+ */
+
+/*
+ * Read project_id id from inode's xattr
+ * Locking: none
+ */
+int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid)
+{
+	__le32 dsk_prjid;
+	int retval;
+	retval = ext4_xattr_get(inode, EXT4_XATTR_INDEX_PROJECT_ID, "",
+				&dsk_prjid, sizeof (dsk_prjid));
+	if (retval > 0) {
+		if (retval != sizeof(dsk_prjid))
+			return -EIO;
+		else
+			retval = 0;
+	}
+	*prjid = le32_to_cpu(dsk_prjid);
+	return retval;
+
+}
+
+/*
+ * Save project_id id to inode's xattr
+ * Locking: none
+ */
+int ext4_prj_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int prjid, int xflags)
+{
+	__le32 dsk_prjid = cpu_to_le32(prjid);
+	int retval;
+	retval = ext4_xattr_set_handle(handle,
+				inode, EXT4_XATTR_INDEX_PROJECT_ID, "",
+				&dsk_prjid, sizeof (dsk_prjid), xflags);
+	if (retval > 0) {
+		if (retval != sizeof(dsk_prjid))
+			retval =  -EIO;
+		else
+			retval = 0;
+	}
+	return retval;
+}
+
+/*
+ * Change project_id id.
+ * Called under inode->i_mutex
+ */
+int ext4_prj_change(struct inode *inode, unsigned int new_prjid)
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
+	int old_id = ext4_getprjid(inode);
+	dquot_initialize(inode);
+
+	dquot[PRJQUOTA] = dqget(inode->i_sb, new_prjid, PRJQUOTA);
+retry:
+	handle = ext4_journal_start(inode, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		ext4_std_error(inode->i_sb, ret);
+		goto out;
+	}
+	/* Inode may not have project_id xattr yet. Create it explicitly */
+	ret = ext4_prj_xattr_write(handle, inode, old_id, XATTR_CREATE);
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
+	ret = ext4_prj_xattr_write(handle, inode, new_prjid, XATTR_REPLACE);
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
+		ext4_setprjid(inode, new_prjid);
+
+	ret2 = ext4_journal_stop(handle);
+out:
+	dqput(dquot[PRJQUOTA]);
+	if (ret2)
+		ret = ret2;
+	return ret;
+}
+
+int ext4_prj_read(struct inode *inode)
+{
+	int ret = 0;
+	int prjid = 0;
+	if(test_opt(inode->i_sb, PROJECT_ID)) {
+		ret = ext4_prj_xattr_read(inode, &prjid);
+		if (ret == -ENODATA) {
+			prjid = 0;
+			ret = 0;
+		}
+	}
+	if (!ret)
+		ext4_setprjid(inode, prjid);
+	return ret;
+}
+/*
+ * Initialize the projectid xattr of a new inode. Called from ext4_new_inode.
+ *
+ * dir->i_mutex: down
+ * inode->i_mutex: up (access to inode is still exclusive)
+ * Note: caller must assign correct project id to inode before.
+ */
+int ext4_prj_init(handle_t *handle, struct inode *inode)
+{
+	return ext4_prj_xattr_write(handle, inode, EXT4_I(inode)->i_prjid,
+				XATTR_CREATE);
+}
+
+static size_t
+ext4_xattr_prj_list(struct dentry *dentry, char *list, size_t list_size,
+		const char *name, size_t name_len, int type)
+{
+	if (list && XATTR_PRJID_LEN <= list_size)
+		memcpy(list, XATTR_PRJID, XATTR_PRJID_LEN);
+	return XATTR_PRJID_LEN;
+
+}
+
+static int
+ext4_xattr_prj_get(struct dentry *dentry, const char *name,
+		       void *buffer, size_t size, int type)
+{
+	int ret;
+	unsigned prjid;
+	char buf[32];
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	ret = ext4_prj_xattr_read(dentry->d_inode, &prjid);
+	if (ret)
+		return ret;
+	snprintf(buf, sizeof(buf)-1, "%u", prjid);
+	buf[31] = '\0';
+	strncpy(buffer, buf, size);
+	return strlen(buf);
+}
+
+static int
+ext4_xattr_prj_set(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags, int type)
+{
+	unsigned int new_prjid;
+	if (strcmp(name, "") != 0)
+		return -EINVAL;
+	new_prjid = simple_strtoul(value, (char **)&value, 0);
+	return ext4_prj_change(dentry->d_inode, new_prjid);
+}
+
+const struct xattr_handler ext4_xattr_prj_handler = {
+	.prefix	= XATTR_PRJID,
+	.list	= ext4_xattr_prj_list,
+	.get	= ext4_xattr_prj_get,
+	.set	= ext4_xattr_prj_set,
+};
diff --git a/fs/ext4/project.h b/fs/ext4/project.h
new file mode 100644
index 0000000..054ec4c
--- /dev/null
+++ b/fs/ext4/project.h
@@ -0,0 +1,45 @@
+#include <linux/xattr.h>
+#include <linux/fs.h>
+
+#ifdef CONFIG_EXT4_PROJECT_ID
+extern int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid);
+extern int ext4_prj_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int prjid, int xflags);
+extern int ext4_prj_init(handle_t *handle, struct inode *inode);
+extern int ext4_prj_read(struct inode *inode);
+extern int ext4_prj_change(struct inode *inode, unsigned int new_prjid);
+static inline u32 ext4_getprjid(const struct inode *inode)
+{
+	const struct ext4_inode_info *ei =
+		container_of(inode, const struct ext4_inode_info, vfs_inode);
+	return ei->i_prjid;
+}
+static inline void ext4_setprjid(struct inode *inode, u32 id)
+{
+	EXT4_I(inode)->i_prjid = id;
+}
+#else
+#define ext4_getprjid(inode) do {} while (0)
+#define ext4_setprjid(inode, id) do {} while (0)
+static inline int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_prj_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int prjid, int xflags)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_prj_read(struct inode *inode)
+{
+	return 0;
+}
+static inline int ext4_prj_change(struct inode *inode, unsigned int new_prjid)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_prj_init(handle_t *handle, struct inode *inode)
+{
+	return 0;
+}
+#endif
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 74d2726..fefc007 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -49,6 +49,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "project.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -1129,6 +1130,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, DISCARD) && !(def_mount_opts & EXT4_DEFM_DISCARD))
 		seq_puts(seq, ",discard");
 
+	if (test_opt(sb, PROJECT_ID))
+		seq_puts(seq, ",prjid");
+
 	if (test_opt(sb, NOLOAD))
 		seq_puts(seq, ",norecovery");
 
@@ -1272,6 +1276,9 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+#ifdef CONFIG_EXT4_PROJECT_ID
+	.get_prjid      = ext4_getprjid,
+#endif
 };
 
 static const struct super_operations ext4_nojournal_sops = {
@@ -1291,6 +1298,9 @@ static const struct super_operations ext4_nojournal_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+#ifdef CONFIG_EXT4_PROJECT_ID
+	.get_prjid      = ext4_getprjid,
+#endif
 };
 
 static const struct export_operations ext4_export_ops = {
@@ -1318,7 +1328,7 @@ enum {
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_project_id,
 	Opt_init_inode_table, Opt_noinit_inode_table,
 };
 
@@ -1395,6 +1405,7 @@ static const match_table_t tokens = {
 	{Opt_init_inode_table, "init_itable=%u"},
 	{Opt_init_inode_table, "init_itable"},
 	{Opt_noinit_inode_table, "noinit_itable"},
+	{Opt_project_id, "prjid"},
 	{Opt_err, NULL},
 };
 
@@ -1882,6 +1893,9 @@ set_qf_format:
 		case Opt_noinit_inode_table:
 			clear_opt(sb, INIT_INODE_TABLE);
 			break;
+		case Opt_project_id:
+			set_opt(sbi->s_mount_opt, PROJECT_ID);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..13dc05d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -107,6 +107,10 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_PROJECT_ID
+	[EXT4_XATTR_INDEX_PROJECT_ID]	     = &ext4_xattr_prj_handler,
+#endif
+
 };
 
 const struct xattr_handler *ext4_xattr_handlers[] = {
@@ -119,6 +123,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_PROJECT_ID
+	&ext4_xattr_prj_handler,
+#endif
 	NULL
 };
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 25b7387..4f03863 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_PROJECT_ID	        7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -70,6 +71,7 @@ extern const struct xattr_handler ext4_xattr_trusted_handler;
 extern const struct xattr_handler ext4_xattr_acl_access_handler;
 extern const struct xattr_handler ext4_xattr_acl_default_handler;
 extern const struct xattr_handler ext4_xattr_security_handler;
+extern const struct xattr_handler ext4_xattr_prj_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index f42c098..77ad18f 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -87,6 +87,7 @@ struct ext3_inode_info {
 	 * near to their parent directory's inode.
 	 */
 	__u32	i_block_group;
+	__u32	i_prjid;
 	unsigned long	i_state_flags;	/* Dynamic state flags for ext3 */
 
 	/* block reservation info */
-- 
1.7.1

