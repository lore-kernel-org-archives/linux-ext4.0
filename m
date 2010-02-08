From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 08/11] ext4: introduce subtree logic
Date: Mon, 08 Feb 2010 16:28:10 +0300
Message-ID: <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33220 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0BHO2a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:30 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:02 +0300 (MSK)
In-reply-to: <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Abstract
  A subtree of a directory tree T is a tree consisting of a directory
  (the subtree root) in T and all of its descendants in T.

  Subtree feature allows to create an isolated (from user point of view)
  trees.

  Subtree assumptions:
  (1) Each inode has subtree id. This id is persistently stored inside
      inode (xattr, usually inside ibody)
  (2) Subtree id is inherent from parent directory
  (3) Inode can not belongs to different subtree
      Otherwise changes in one subtree result in changes in other subtree
      which contradict to isolation criteria.

  This feature is similar to project-id in XFS. One may assign some id to
  a subtree. Each entry from the subtree may be accounted in directory
  subtree quota. Will appear in later patches.

* Disk layout
  Subtree id is stored on disk inside xattr usually inside ibody.
  Xattr is used only as a data storage, It has not user visiable xattr
  interface.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/subtree.c |  292 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/subtree.h |   60 +++++++++++
 fs/ext4/xattr.h   |    1 +
 3 files changed, 353 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/subtree.c
 create mode 100644 fs/ext4/subtree.h

diff --git a/fs/ext4/subtree.c b/fs/ext4/subtree.c
new file mode 100644
index 0000000..40d3d85
--- /dev/null
+++ b/fs/ext4/subtree.c
@@ -0,0 +1,292 @@
+/*
+ *  linux/fs/ext4/subtree.c
+ *
+ * Support for subtree quota for ext4 filesystem
+ *
+ * Copyright (C) Parallels Inc, 2010
+ * Dmitry Monakhov <dmonakhov@openvz.org>
+ *
+ */
+
+/*
+ * *Abstract*
+ * A subtree of a directory tree T is a tree consisting of a directory
+ * (the subtree root) in T and all of its descendants in T.
+ *
+ * Subtree feature allows to create an isolated trees.
+ * Isolation means what:
+ *   1) Subtrees has no common inodes (no hadlinks across subtrees)
+ *   2) All descendants belongs to the same subtree.
+ * Such isolated subtrees may be restricted by subtree quota.
+ *
+ * Subtree assumptions:
+ * (1) Each inode has subtree id. This id is persistently stored inside
+ *     inode's xattr, usually inside ibody
+ * (2) Subtree id is inherent from parent directory
+ * (3) Inode can not belongs to different subtree trees
+ *     Otherwise changes in one subtree result in changes in other subtree
+ *     which contradict to isolation criteria.
+ *
+ * Default directory tree (with subtree_id == 0) has special meaning.
+ * directory which belongs to default subtree may contains entries with
+ * other trees. It may be used for renames between different subtrees.
+ */
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/mbcache.h>
+#include <linux/quotaops.h>
+#include <linux/rwsem.h>
+#include "ext4_jbd2.h"
+#include "ext4.h"
+#include "xattr.h"
+#include "acl.h"
+#include "subtree.h"
+enum {
+	EXT4_SUBTREE_SAME = 1,	/* Both nodes belongs to same subtree */
+	EXT4_SUBTREE_COMMON,	/* Ancestor tree includes descent subtree*/
+	EXT4_SUBTREE_CROSS,     /* Nodes belongs to different subtrees */
+};
+
+#define EXT4_I_SUBTREE(inode) (EXT4_I(inode)->i_subtree)
+/**
+   Check ancestor descendant subtree relationship.
+   @ancino: ancestor inode
+   @inode: descendant inode
+ */
+static inline int ext4_which_subtree(struct inode *ancino, struct inode *inode)
+{
+#ifdef EXT4_SUBTREE_DEBUG
+	BUG_ON(EXT4_I_SUBTREE(ancino) > EXT4_SUBTREE_ID_MAX);
+	BUG_ON(EXT4_I_SUBTREE(inode) > EXT4_SUBTREE_ID_MAX);
+#endif
+	if (EXT4_I_SUBTREE(inode) == EXT4_I_SUBTREE(ancino))
+		return EXT4_SUBTREE_SAME;
+		else if (EXT4_I_SUBTREE(ancino) == 0)
+		/*
+		 * Ancestor inode belongs to default tree and it includes
+		 * other subtrees by default
+		*/
+		return EXT4_SUBTREE_COMMON;
+	return EXT4_SUBTREE_CROSS;
+}
+/*
+ * Function is called for new inode before quota init.
+ */
+void ext4_st_inherent_subtree(struct inode *inode, struct inode *dir)
+{
+#ifdef EXT4_SUBTREE_DEBUG
+	BUG_ON(EXT4_I_SUBTREE(dir) > EXT4_SUBTREE_ID_MAX);
+#endif
+	EXT4_I_SUBTREE(inode) = EXT4_I_SUBTREE(dir);
+}
+/*
+ * Initialize directory subtree id of a new inode. Called from ext4_new_inode.
+ *
+ * dir->i_mutex: down
+ * inode->i_mutex: up (access to inode is still exclusive)
+ */
+int ext4_st_init(handle_t *handle, struct inode *inode, struct inode *dir)
+{
+	struct ext4_subtree_entry est;
+	int ret;
+	if (!test_opt(inode->i_sb, SUBTREE))
+		return 0;
+
+	if (EXT4_I_SUBTREE(inode) > EXT4_SUBTREE_ID_MAX)
+		return -EINVAL;
+
+	est.est_id = cpu_to_le32(EXT4_I_SUBTREE(dir));
+	est.est_fl = cpu_to_le16(EXT4_SUBTREE_FL_VALID);
+	ret = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_SUBTREE,
+				"", &est, sizeof(est), XATTR_CREATE);
+	return ret;
+}
+
+/*
+ * Read subtree from inode.
+ */
+int ext4_st_read(struct inode *inode)
+{
+	struct ext4_subtree_entry est;
+	int ret;
+	if (!test_opt(inode->i_sb, SUBTREE))
+		return 0;
+
+	ret = ext4_xattr_get(inode, EXT4_XATTR_INDEX_SUBTREE, "",
+			&est, sizeof(est));
+
+	if (ret != -ENODATA && ret != sizeof(est)) {
+		EXT4_I_SUBTREE(inode) = 0;
+		if (ret > 0)
+			/* Index currupted */
+			ret = -EIO;
+		return ret;
+	}
+	if (ret != -ENODATA) {
+		/*
+		 * Inode has not subtree xattr yet. That's ok
+		 * Belongs to default tree.
+		 */
+		EXT4_I_SUBTREE(inode) = 0;
+		return 0;
+	}
+	if (!(le16_to_cpu(est.est_fl) | EXT4_SUBTREE_FL_VALID) ||
+			le32_to_cpu(est.est_id) > EXT4_SUBTREE_ID_MAX) {
+		EXT4_I_SUBTREE(inode) = 0;
+		return -EINVAL;
+	}
+
+	EXT4_I_SUBTREE(inode) = le32_to_cpu(est.est_id);
+	return 0;
+}
+
+/*
+ * Change subtree id for a given inode
+ * ->i_mutex is locked.
+ */
+int ext4_st_change(struct inode *inode, struct inode *dir, int subtree)
+{
+	struct ext4_subtree_entry est;
+	int credits = EXT4_XATTR_TRANS_BLOCKS +
+		EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
+	handle_t *handle;
+	int retries = 0;
+	int ret, ret2;
+
+	if (subtree > EXT4_SUBTREE_ID_MAX)
+		return -EINVAL;
+
+	/*
+	 * In order to preserve subtree structure caller must traverse
+	 * hierarchy in following order.
+	 * change from some subtree to default subtree: from parent to child
+	 * change from default subtree to some subtree: from child to parent
+	*/
+	if (dir && (EXT4_I_SUBTREE(dir) != 0 &&
+			EXT4_I_SUBTREE(dir)  != subtree))
+		return -EXDEV;
+
+	if (EXT4_I_SUBTREE(inode) == subtree)
+		return 0;
+retry:
+	handle = ext4_journal_start(inode, credits);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	est.est_id = cpu_to_le32(subtree);
+	est.est_fl = cpu_to_le16(EXT4_SUBTREE_FL_VALID);
+	ret = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_SUBTREE,
+				"", &est, sizeof(est), XATTR_REPLACE);
+	if (unlikely(ret == -ENODATA)) {
+		/* Inode has not subtree xattr on disk */
+		BUG_ON(EXT4_I_SUBTREE(inode) != 0);
+		ret = ext4_xattr_set_handle(handle, inode,
+					EXT4_XATTR_INDEX_SUBTREE,
+					"", &est, sizeof(est), XATTR_CREATE);
+	}
+	if (ret) {
+		ret2 = ext4_journal_stop(handle);
+		if (!ret2 && ret == -ENOSPC &&
+			ext4_should_retry_alloc(inode->i_sb, &retries))
+			goto retry;
+		if (ret == 0)
+		ret = ret2;
+	}
+	if (ret)
+		return ret;
+	/*
+	 * Quota transfer only after xattr update. Because it may be
+	 * impossible to roll back quota changed due to -EDQUOT
+	 * TODO: add quota transfer here
+	 */
+	EXT4_I_SUBTREE(inode) = subtree;
+	ret2 = ext4_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+	return ret;
+
+	/*
+	 * Restore xattr to previous value. Xattr is already allocated, so
+	 * operation may fail only due to some serious error.
+	 */
+	est.est_id = cpu_to_le32(EXT4_I_SUBTREE(inode));
+	est.est_fl = cpu_to_le16(EXT4_SUBTREE_FL_VALID);
+
+	ret2 = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_SUBTREE,
+				"", &est, sizeof(est), XATTR_REPLACE);
+	if (ret2)
+		ext4_warning(inode->i_sb, __func__,
+			"Cant restore subtree id err:%d", ret2);
+	ext4_journal_stop(handle);
+	return ret;
+
+}
+/**
+ * Check subtree assumptions on ext4_link()
+ * @tdir:   target directory inode
+ * @inode:  inode in question
+ * @return: true if link is possible, zero otherwise
+ */
+inline int ext4_st_may_link(struct inode *tdir, struct inode *inode)
+{
+	if (!test_opt(inode->i_sb, SUBTREE))
+		return 1;
+	/*
+	 * According to subtree quota assumptions inode can not belongs to
+	 * different quota trees.
+	 */
+	if(ext4_which_subtree(tdir, inode) != EXT4_SUBTREE_SAME)
+		return 0;
+	return 1;
+}
+
+/**
+ * Check for directory subtree assumptions on ext4_rename()
+ * @new_dir: new directory inode
+ * @inode:   inode in question
+ * @return:  true if rename is possible, zero otherwise.
+ */
+inline int ext4_st_may_rename(struct inode *new_dir, struct inode *inode)
+{
+	int same;
+	// XXX: Seems what i_nlink check is racy
+	// Is it possible to get inode->i_mutex here?
+	if (!test_opt(inode->i_sb, SUBTREE))
+		return 1;
+	same = ext4_which_subtree(new_dir, inode);
+	if (S_ISDIR(inode->i_mode)) {
+		if (same == EXT4_SUBTREE_CROSS)
+			return 0;
+	} else {
+		if (inode->i_nlink > 1) {
+			/*
+			 * If we allow to move any dentry of inode which has
+			 * more than one link between subtrees then we end up
+			 * with inode which belongs to different subtrees.
+			 */
+			if (same != EXT4_SUBTREE_SAME)
+				return 0;
+		} else {
+			if (same == EXT4_SUBTREE_CROSS)
+				return 0;
+		}
+	}
+	return 1;
+}
+
+/**
+ * Check subtree  parent/child relationship assumptions.
+ */
+inline void ext4_st_check_parent(struct inode *dir, struct inode *inode)
+{
+	if (!test_opt(dir->i_sb, SUBTREE))
+		return;
+	if (ext4_which_subtree(dir, inode) == EXT4_SUBTREE_CROSS) {
+		ext4_warning(inode->i_sb, __func__,
+			"Bad subtree hierarchy: directory{ino:%lu, sbtr:%u}"
+			"inoode{ino:%lu, sbtr:%u}\n",
+			dir->i_ino, EXT4_I_SUBTREE(dir),
+			inode->i_ino, EXT4_I_SUBTREE(inode));
+		}
+}
diff --git a/fs/ext4/subtree.h b/fs/ext4/subtree.h
new file mode 100644
index 0000000..83583c7
--- /dev/null
+++ b/fs/ext4/subtree.h
@@ -0,0 +1,60 @@
+/*
+ *  linux/fs/ext4/subtree.h
+ *
+ * Support for subtree quota for ext4 filesystem
+ *
+ * Copyright (C) Parallels Inc, 2010
+ * Dmitry Monakhov <dmonakhov@openvz.org>
+ *
+ */
+#ifndef _EXT4_SUBTREE_H
+#define _EXT4_SUBTREE_H
+
+/* On disk data size of subtree entry */
+struct ext4_subtree_entry
+{
+	__le16 est_fl;
+	__le32 est_id;
+	__le16 est_reserved;
+};
+enum {
+	EXT4_SUBTREE_FL_VALID	= 0x1,
+};
+#define EXT4_SUBTREE_ID_MAX	((1UL << 31) -16)
+
+#ifdef CONFIG_EXT4_SUBTREE
+void ext4_st_inherent_subtree(struct inode *inode, struct inode *dir);
+int ext4_st_init(handle_t *h, struct inode *inode, struct inode *dir);
+int ext4_st_read(struct inode *inode);
+int ext4_st_change(struct inode *inode, struct inode *dir, int subtree);
+int ext4_st_may_link(struct inode *dir, struct inode *inode);
+int ext4_st_may_rename(struct inode *dir, struct inode *inode);
+void ext4_st_check_parent(struct inode *dir, struct inode *inode);
+#else
+inline void ext4_st_inherent_subtree(struct inode *inode, struct inode *dir)
+{
+	return 0;
+}
+inline int ext4_st_init(handle_t *, struct inode *, struct inode *)
+{
+	return 0
+}
+inline int ext4_st_read(struct inode *inode)
+{
+	return 0;
+}
+inline int ext4_st_change(struct inode *inode, struct inode *dir, int subtree)
+{
+	return 0;
+}
+inline int ext4_st_may_link(struct inode *dir, struct inode *inode)
+{
+	return 1;
+}
+inline int ext4_st_may_rename(struct inode *dir, struct inode *inode)
+{
+	return 1;
+}
+inline void ext4_st_check_parent(struct inode *dir, struct inode *inode) {}
+#endif /* CONFIG_EXT4_SUBTREE */
+#endif
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 8ede88b..688dde8 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -21,6 +21,7 @@
 #define EXT4_XATTR_INDEX_TRUSTED		4
 #define	EXT4_XATTR_INDEX_LUSTRE			5
 #define EXT4_XATTR_INDEX_SECURITY	        6
+#define EXT4_XATTR_INDEX_SUBTREE		7
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
-- 
1.6.3.3

