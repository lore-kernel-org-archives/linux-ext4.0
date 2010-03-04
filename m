From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/5] ext4: Implement project ID support for ext4 filesystem
Date: Thu,  4 Mar 2010 21:34:35 +0300
Message-ID: <1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46597 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0CDSew (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 13:34:52 -0500
In-Reply-To: <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
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

TODO: implement e2libfs support for project_id.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/Kconfig   |    8 ++
 fs/ext4/Makefile  |    1 +
 fs/ext4/ext4.h    |    1 +
 fs/ext4/ialloc.c  |   12 +++-
 fs/ext4/inode.c   |    5 +-
 fs/ext4/project.c |  209 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/project.h |   25 +++++++
 fs/ext4/super.c   |    9 ++-
 fs/ext4/xattr.c   |    7 ++
 fs/ext4/xattr.h   |    2 +
 10 files changed, 276 insertions(+), 3 deletions(-)
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
index 8867b2a..be923b1 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -11,3 +11,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
+ext4-$(CONFIG_EXT4_PROJECT_ID)		+= project.o
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5806f53..9112c21 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -763,6 +763,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
+#define EXT4_MOUNT_PROJECT_ID		0x4000000 /* project owner id support */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 004c9da..13cc85f 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,7 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
-
+#include "project.h"
 #include <trace/events/ext4.h>
 
 /*
@@ -1028,6 +1028,13 @@ got:
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
 
+#ifdef CONFIG_EXT4_PROJECT_ID
+	/*
+	 * XXX: move this to generic inode init helper
+	 * depends on generic_inode_init patch.
+	 */
+	inode->i_prjid = dir->i_prjid;
+#endif
 	ret = inode;
 	if (vfs_dq_alloc_inode(inode)) {
 		err = -EDQUOT;
@@ -1041,6 +1048,9 @@ got:
 	err = ext4_init_security(handle, inode, dir);
 	if (err)
 		goto fail_free_drop;
+	err = ext4_prj_init(handle, inode);
+	if (err)
+		goto fail_free_drop;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		/* set extent flag only for directory, file and normal symlink*/
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index efc0442..119491a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -44,7 +44,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "ext4_extents.h"
-
+#include "project.h"
 #include <trace/events/ext4.h>
 
 #define MPAGE_DA_EXTENT_TAIL 0x01
@@ -5076,6 +5076,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
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
index 0000000..8de8c0c
--- /dev/null
+++ b/fs/ext4/project.c
@@ -0,0 +1,209 @@
+/*
+ * linux/fs/ext4/projectid.c
+ *
+ * Copyright (C) 2010 Parallels Inc
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
+static int ext4_prj_change(struct inode *inode, unsigned int new_prjid)
+{
+	/*
+	 * One data_trans_blocks chunk for xattr update.
+	 * One quota_trans_blocks chunk for quota transfer, and one
+	 * quota_trans_block chunk for emergency quota rollback transfer,
+	 * because quota rollback may result new quota blocks allocation.
+	 */
+	unsigned credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
+		EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb) * 2;
+	qid_t qid[MAXQUOTAS];
+	int ret, ret2 = 0;
+	unsigned retries = 0;
+	handle_t *handle;
+
+	vfs_dq_init(inode);
+retry:
+	handle = ext4_journal_start(inode, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		ext4_std_error(inode->i_sb, ret);
+		goto out;
+	}
+	/* Inode may not have project_id xattr yet. Create it explicitly */
+	ret = ext4_prj_xattr_write(handle, inode, inode->i_prjid,
+			XATTR_CREATE);
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
+	qid[PRJQUOTA] = new_prjid;
+	ret = inode->i_sb->dq_op->transfer(inode, qid, 1 << PRJQUOTA);
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
+		qid[PRJQUOTA] = inode->i_prjid;
+		inode->i_sb->dq_op->transfer(inode, qid, 1 << PRJQUOTA);
+#endif
+		ext4_std_error(inode->i_sb, ret);
+
+	}
+	inode->i_prjid = new_prjid;
+	ret2 = ext4_journal_stop(handle);
+out:
+	if (ret2)
+		ret = ret2;
+	return ret;
+}
+
+int ext4_prj_read(struct inode *inode)
+{
+	int ret = 0;
+	if(test_opt(inode->i_sb, PROJECT_ID)) {
+		ret = ext4_prj_xattr_read(inode, &inode->i_prjid);
+		if (ret == -ENODATA) {
+			inode->i_prjid = 0;
+			ret = 0;
+		}
+	} else
+		inode->i_prjid = 0;
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
+	return ext4_prj_xattr_write(handle, inode, inode->i_prjid,
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
+struct xattr_handler ext4_xattr_prj_handler = {
+	.prefix	= XATTR_PRJID,
+	.list	= ext4_xattr_prj_list,
+	.get	= ext4_xattr_prj_get,
+	.set	= ext4_xattr_prj_set,
+};
diff --git a/fs/ext4/project.h b/fs/ext4/project.h
new file mode 100644
index 0000000..7e80579
--- /dev/null
+++ b/fs/ext4/project.h
@@ -0,0 +1,25 @@
+#include <linux/xattr.h>
+#include <linux/fs.h>
+
+#ifdef CONFIG_EXT4_PROJECT_ID
+extern int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid);
+extern int ext4_prj_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int prjid, int xflags);
+extern int ext4_prj_init(handle_t *handle, struct inode *inode);
+extern int ext4_prj_read(struct inode *inode);
+
+#else
+static inline int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid)
+{
+	return -ENOTSUPP;
+}
+static inline int ext4_prj_xattr_write(handle_t *handle, struct inode *inode,
+				unsigned int prjid, int xflags)
+{
+	return -ENOTSUPP;
+}
+static int ext4_prj_read(struct inode *inode)
+{
+	return 0;
+}
+#endif
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9fc6057..240df9a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -960,6 +960,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, DISCARD))
 		seq_puts(seq, ",discard");
 
+	if (test_opt(sb, PROJECT_ID))
+		seq_puts(seq, ",project_id");
+
 	if (test_opt(sb, NOLOAD))
 		seq_puts(seq, ",norecovery");
 
@@ -1150,7 +1153,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_project_id,
 };
 
 static const match_table_t tokens = {
@@ -1221,6 +1224,7 @@ static const match_table_t tokens = {
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_project_id, "project_id"},
 	{Opt_err, NULL},
 };
 
@@ -1689,6 +1693,9 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
+		case Opt_project_id:
+			set_opt(sbi->s_mount_opt, PROJECT_ID);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index efc16a4..881b4de 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -107,6 +107,10 @@ static struct xattr_handler *ext4_xattr_handler_map[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	[EXT4_XATTR_INDEX_SECURITY]	     = &ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_PROJECT_ID
+	[EXT4_XATTR_INDEX_PROJECT_ID]	     = &ext4_xattr_prj_handler,
+#endif
+
 };
 
 struct xattr_handler *ext4_xattr_handlers[] = {
@@ -119,6 +123,9 @@ struct xattr_handler *ext4_xattr_handlers[] = {
 #ifdef CONFIG_EXT4_FS_SECURITY
 	&ext4_xattr_security_handler,
 #endif
+#ifdef CONFIG_EXT4_PROJECT_ID
+	&ext4_xattr_prj_handler,
+#endif
 	NULL
 };
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 8ede88b..777d60f 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_PROJECT_ID	        7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
@@ -70,6 +71,7 @@ extern struct xattr_handler ext4_xattr_trusted_handler;
 extern struct xattr_handler ext4_xattr_acl_access_handler;
 extern struct xattr_handler ext4_xattr_acl_default_handler;
 extern struct xattr_handler ext4_xattr_security_handler;
+extern struct xattr_handler ext4_xattr_prj_handler;
 
 extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 
-- 
1.6.6

