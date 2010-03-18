From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/5] ext4: add isolated project support
Date: Thu, 18 Mar 2010 17:02:50 +0300
Message-ID: <1268920970-9061-6-git-send-email-dmonakhov@openvz.org>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-2-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-3-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-4-git-send-email-dmonakhov@openvz.org>
 <1268920970-9061-5-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
	hch@infradead.org, jack@suse.cz, david@fromorbit.com,
	viro@ZenIV.linux.org.uk, xemul@openvz.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40021 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab0CRODK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 10:03:10 -0400
In-Reply-To: <1268920970-9061-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is not mandatory part of project_id feature, but it allows to
use projects hierarchy to implement subfilesystem isolation semantics.

PROJECT_ISOLATION
This feature allows to create an isolated project sub-trees.
Isolation means what:
  1) directory sub-tree has no common inodes (no hadlinks across sub-trees)
  2) All descendants belongs to the same sub-tree.

Project sub-tree's isolation assumptions:
  1)Inode can not belongs to different sub-tree trees
    Otherwise changes in one sub-tree result in changes in other sub-tree
    which contradict to isolation criteria.

*Usage*
 We already has bind mounts which prevent link/remount across mounts.
 But if user has isolated project which consists of several sub-trees
 and he want link/renames to work between sub-trees(but in one project)

Since this feature is non obvious it controlled by mount option.

*Approach N2*
 Currently i'm consider another approach to implement isolation semantics:
 Maintains per-sb list of prjid objects similar dquot. Each object
 has corresponding isolation type.Three isolation types are possible
 1) NO_ISOLATION: no isolation at all
 2) SEMI_ISOLATION restrict rename/link similar to XFS implementation
 3) FULL_ISOLATION do not allow any nested sub-trees, even if user
    want to change prjid explicitly. This type of isolation may be
    useful for nfs export and containers-like solutions.
 Read info from special config-file for projectid sub-trees for example
 like this:
 # mnt_point      projectid     type
   /mnt           100           NO_ISOLATION
   /mnt           101           FULL_ISOLATION
 Any project id which does not contains in config file considered
 as NO_ISOLATION by default, This allow us to enable isolation
 semantics by default without pain.

---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/namei.c   |    9 ++++-
 fs/ext4/project.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/project.h |   15 +++++++
 fs/ext4/super.c   |    9 ++++-
 5 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3fa3602..22996eb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -769,6 +769,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
 #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
+#define EXT4_MOUNT_PRJ_ISOLATION	0x80000000 /* Isolation project support */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0c070fa..92afa62 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -39,6 +39,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "project.h"
 
 /*
  * define how far ahead to read directories while searching them.
@@ -1080,6 +1081,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 				return ERR_CAST(inode);
 			}
 		}
+		ext4_prj_check_parent(dir, inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -2329,7 +2331,8 @@ static int ext4_link(struct dentry *old_dentry,
 	 */
 	if (inode->i_nlink == 0)
 		return -ENOENT;
-
+	if (!ext4_prj_may_link(dir, inode))
+		return -EXDEV;
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
@@ -2382,6 +2385,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * in separate transaction */
 	if (new_dentry->d_inode)
 		dquot_initialize(new_dentry->d_inode);
+
+	if (!ext4_prj_may_rename(new_dir, old_dentry->d_inode))
+		return -EXDEV;
+
 	handle = ext4_journal_start(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
diff --git a/fs/ext4/project.c b/fs/ext4/project.c
index b571599..22085cc 100644
--- a/fs/ext4/project.c
+++ b/fs/ext4/project.c
@@ -25,6 +25,17 @@
  * (1) Each inode has subtree id. This id is persistently stored inside
  *     inode's xattr, usually inside ibody
  * (2) Subtree id is inherent from parent directory
+ *
+ * PROJECT ISOLATION
+ * This feature allows to create an isolated subtrees.
+ * Isolation means what:
+ *   1) Subtrees has no common inodes (no hadlinks across subtrees)
+ *   2) All descendants belongs to the same subtree.
+ *
+ * Project subtree's isolation assumptions:
+ *   1)Inode can not belongs to different subtree trees
+ *     Otherwise changes in one subtree result in changes in other subtree
+ *     which contradict to isolation criteria.
  */
 
 /*
@@ -151,6 +162,101 @@ int ext4_prj_read(struct inode *inode)
 		inode->i_prjid = 0;
 	return ret;
 }
+
+enum {
+	EXT4_SUBTREE_SAME = 1,	/* Both nodes belongs to same subtree */
+	EXT4_SUBTREE_COMMON,	/* Ancestor tree includes descent subtree*/
+	EXT4_SUBTREE_CROSS,     /* Nodes belongs to different subtrees */
+};
+
+/**
+ *  Check ancestor descendant subtree relationship.
+ *  @ancino: ancestor inode
+ *  @inode: descendant inode
+ */
+static inline int ext4_which_subtree(struct inode *ancino, struct inode *inode)
+{
+	if (inode->i_prjid == ancino->i_prjid)
+		return EXT4_SUBTREE_SAME;
+		else if (ancino->i_prjid == 0)
+		/*
+		 * Ancestor inode belongs to default tree and it includes
+		 * other subtrees by default
+		*/
+		return EXT4_SUBTREE_COMMON;
+	return EXT4_SUBTREE_CROSS;
+}
+
+/**
+ * Check subtree assumptions on ext4_link()
+ * @tdir:   target directory inode
+ * @inode:  inode in question
+ * @return: true if link is possible, zero otherwise
+ */
+inline int ext4_prj_may_link(struct inode *tdir, struct inode *inode)
+{
+	if (!test_opt(inode->i_sb, PRJ_ISOLATION))
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
+inline int ext4_prj_may_rename(struct inode *new_dir, struct inode *inode)
+{
+	int same;
+	if (!test_opt(inode->i_sb, PRJ_ISOLATION))
+		return 1;
+	// XXX: Seems what i_nlink check is racy
+	// Is it possible to get inode->i_mutex here?
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
+inline void ext4_prj_check_parent(struct inode *dir, struct inode *inode)
+{
+	if (!test_opt(dir->i_sb, PRJ_ISOLATION))
+		return;
+
+	if (ext4_which_subtree(dir, inode) == EXT4_SUBTREE_CROSS) {
+		ext4_warning(inode->i_sb,
+			"Bad subtree hierarchy: directory{ino:%lu, project:%u}"
+			"inoode{ino:%lu, project:%u}\n",
+			dir->i_ino, dir->i_prjid,
+			inode->i_ino, inode->i_prjid);
+		}
+}
+
 /*
  * Initialize the projectid xattr of a new inode. Called from ext4_new_inode.
  *
diff --git a/fs/ext4/project.h b/fs/ext4/project.h
index a8b56a0..00deddc 100644
--- a/fs/ext4/project.h
+++ b/fs/ext4/project.h
@@ -8,6 +8,9 @@ extern int ext4_prj_xattr_write(handle_t *handle, struct inode *inode,
 extern int ext4_prj_init(handle_t *handle, struct inode *inode);
 extern int ext4_prj_read(struct inode *inode);
 extern int ext4_prj_change(struct inode *inode, unsigned int new_prjid);
+extern int ext4_prj_may_link(struct inode *dir, struct inode *inode);
+extern int ext4_prj_may_rename(struct inode *dir, struct inode *inode);
+extern void ext4_prj_check_parent(struct inode *dir, struct inode *inode);
 #else
 static inline int ext4_prj_xattr_read(struct inode *inode, unsigned int *prjid)
 {
@@ -26,4 +29,16 @@ static int ext4_prj_change(struct inode *inode, unsigned int new_prjid)
 {
 	return -ENOTSUP;
 }
+static int ext4_prj_may_link(struct inode *dir, struct inode *inode)
+{
+	return 1;
+}
+static int ext4_prj_may_rename(struct inode *dir, struct inode *inode)
+{
+	return 1;
+}
+static void ext4_prj_check_parent(struct inode *dir, struct inode *inode)
+{
+	return 1;
+}
 #endif
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43a525e..8321844 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -971,6 +971,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, PROJECT_ID))
 		seq_puts(seq, ",project_id");
 
+	if (test_opt(sb, PRJ_ISOLATION))
+		seq_puts(seq, ",project_isolation");
+
 	if (test_opt(sb, NOLOAD))
 		seq_puts(seq, ",norecovery");
 
@@ -1152,7 +1155,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard, Opt_project_id,
+	Opt_discard, Opt_nodiscard, Opt_project_id, Opt_prj_isolation
 };
 
 static const match_table_t tokens = {
@@ -1227,6 +1230,7 @@ static const match_table_t tokens = {
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
 	{Opt_project_id, "project_id"},
+	{Opt_prj_isolation, "project_isolation"},
 	{Opt_err, NULL},
 };
 
@@ -1729,6 +1733,9 @@ set_qf_format:
 		case Opt_project_id:
 			set_opt(sbi->s_mount_opt, PROJECT_ID);
 			break;
+		case Opt_prj_isolation:
+			set_opt(sbi->s_mount_opt, PRJ_ISOLATION);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
-- 
1.6.6.1

