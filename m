From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 10/11] ext4: add subtree support
Date: Mon, 08 Feb 2010 16:28:12 +0300
Message-ID: <1265635693-12182-11-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-10-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33218 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0BHO2e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:34 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:02 +0300 (MSK)
In-reply-to: <1265635693-12182-10-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After this patch ext4 has basic subtree support.
* User visiable changes
  mount option:	       "subtree"
  mount flag: 	       EXT4_MOUNT_SUBTREE
  ioctl	   	       EXT4_IOC_GET_TREEID / EXT4_IOC_SET_TREEID

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h   |    6 ++++++
 fs/ext4/ialloc.c |    6 ++++++
 fs/ext4/inode.c  |    5 +++++
 fs/ext4/ioctl.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |    9 ++++++++-
 fs/ext4/super.c  |   18 +++++++++++++++++-
 6 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 55f1034..c707c7c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -390,6 +390,8 @@ struct ext4_new_group_data {
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
+#define EXT4_IOC_GET_SUBTREE		_IOR('f', 16, unsigned int)
+#define EXT4_IOC_SET_SUBTREE		_IOW('f', 17, unsigned int)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -711,6 +713,9 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
+#ifdef CONFIG_EXT4_SUBTREE
+	unsigned i_subtree;
+#endif
 };
 
 /*
@@ -760,6 +765,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000LL /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000LL /* Block validity checking */
 #define EXT4_MOUNT_DISCARD		0x40000000LL /* Issue DISCARD requests */
+#define EXT4_MOUNT_SUBTREE		0x80000000LL /* Dedicated subtree */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2fab5ad..d527a0c 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -28,6 +28,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "acl.h"
+#include "subtree.h"
 
 #include <trace/events/ext4.h>
 
@@ -1033,6 +1034,7 @@ got:
 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
+	ext4_st_inherent_subtree(inode, dir);
 
 	ret = inode;
 	if (vfs_dq_alloc_inode(inode)) {
@@ -1048,6 +1050,10 @@ got:
 	if (err)
 		goto fail_free_drop;
 
+	err = ext4_st_init(handle, inode, dir);
+	if (err)
+		goto fail_free_drop;
+
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
 		/* set extent flag only for directory, file and normal symlink*/
 		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 218ea0b..2a31b0f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -44,6 +44,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "ext4_extents.h"
+#include "subtree.h"
 
 #include <trace/events/ext4.h>
 
@@ -5053,6 +5054,10 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (ret)
 		goto bad_inode;
 
+	ret = ext4_st_read(inode);
+	if (ret)
+		goto bad_inode;
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index b63d193..135d059 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -17,6 +17,7 @@
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#include "subtree.h"
 
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
@@ -164,6 +165,57 @@ setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
+#ifdef CONFIG_EXT4_SUBTREE
+	case EXT4_IOC_GET_SUBTREE:
+		if (test_opt(inode->i_sb, SUBTREE))
+			return put_user(EXT4_I(inode)->i_subtree,
+					(unsigned int __user*) arg);
+		else
+			return -EINVAL;
+	case EXT4_IOC_SET_SUBTREE: {
+		int err;
+		unsigned int subtree;
+		struct inode *dir = IS_ROOT(filp->f_dentry) ?
+			NULL : filp->f_dentry->d_parent->d_inode;
+
+		if (!test_opt(inode->i_sb, SUBTREE))
+			return -EINVAL;
+
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		if (get_user(subtree, (unsigned int __user *) arg))
+			return -EFAULT;
+
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			return err;
+		/*
+		 * Nested  subtrees are not allowed! We have to hold
+		 * dir->i_mutex for entire operation in order to prevent
+		 * from races with parent's ioctl.
+		 */
+		if (dir)
+			mutex_lock(&dir->i_mutex);
+		mutex_lock(&inode->i_mutex);
+
+		err = -EPERM;
+		/* Is it quota file? Do not allow user to mess with it */
+		if (IS_NOQUOTA(inode))
+			goto settree_out;
+
+		if (!capable(CAP_SYS_RESOURCE))
+			goto settree_out;
+
+		err = ext4_st_change(inode, dir, subtree);
+settree_out:
+		if (dir)
+			mutex_unlock(&dir->i_mutex);
+		mutex_unlock(&inode->i_mutex);
+		mnt_drop_write(filp->f_path.mnt);
+		return err;
+	}
+#endif
 #ifdef CONFIG_JBD2_DEBUG
 	case EXT4_IOC_WAIT_FOR_READONLY:
 		/*
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 17a17e1..4b1ac37 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -39,6 +39,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "subtree.h"
 
 /*
  * define how far ahead to read directories while searching them.
@@ -1086,6 +1087,7 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 				return ERR_CAST(inode);
 			}
 		}
+		ext4_st_check_parent(dir, inode);
 	}
 	return d_splice_alias(inode, dentry);
 }
@@ -2314,7 +2316,8 @@ static int ext4_link(struct dentry *old_dentry,
 	 */
 	if (inode->i_nlink == 0)
 		return -ENOENT;
-
+	if (!ext4_st_may_link(dir, inode))
+		return -EXDEV;
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
@@ -2364,6 +2367,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * in separate transaction */
 	if (new_dentry->d_inode)
 		vfs_dq_init(new_dentry->d_inode);
+
+	if (!ext4_st_may_rename(new_dir, old_dentry->d_inode))
+		return -EXDEV;
+
 	handle = ext4_journal_start(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 93ba5e2..2684453 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -46,6 +46,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "subtree.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
@@ -853,6 +854,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
+	if (test_opt(sb, SUBTREE))
+		seq_puts(seq, ",subtree");
 #ifdef CONFIG_EXT4_FS_XATTR
 	if (test_opt(sb, XATTR_USER) &&
 		!(def_mount_opts & EXT4_DEFM_XATTR_USER))
@@ -1115,7 +1118,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_subtree, Opt_nosubtree,
 };
 
 static const match_table_t tokens = {
@@ -1186,6 +1189,8 @@ static const match_table_t tokens = {
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_subtree, "subtree"},
+	{Opt_nosubtree, "nosubtree"},
 	{Opt_err, NULL},
 };
 
@@ -1612,6 +1617,17 @@ set_qf_format:
 			*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
 							    option);
 			break;
+		case Opt_subtree:
+			if (is_remount && !test_opt(sb, SUBTREE)) {
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot toggle subtree support on remount");
+				return 0;
+			}
+			set_opt(sbi->s_mount_opt, SUBTREE);
+			break;
+		case Opt_nosubtree:
+			clear_opt(sbi->s_mount_opt, SUBTREE);
+			break;
 		case Opt_noauto_da_alloc:
 			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
-- 
1.6.3.3

