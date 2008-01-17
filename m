From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] Convert ext4_ioctl to an unlocked_ioctl
Date: Thu, 17 Jan 2008 11:30:24 +0100
Message-ID: <1200565824-362-3-git-send-email-mathieu.segaud@regala.cx>
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
 <1200565824-362-2-git-send-email-mathieu.segaud@regala.cx>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com, Mathieu Segaud <mathieu.segaud@regala.cx>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bde.crans.org ([138.231.137.76]:51260 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbYAQKa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 05:30:29 -0500
In-Reply-To: <1200565824-362-2-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/ext4/dir.c           |    2 +-
 fs/ext4/file.c          |    2 +-
 fs/ext4/ioctl.c         |  159 ++++++++++++++++++++++++++++++++---------------
 include/linux/ext4_fs.h |    3 +-
 4 files changed, 112 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f612bef..8f6677a 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext4_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext4_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext4_ioctl,		/* BKL held */
+	.unlocked_ioctl	= ext4_ioctl,		/* BKL held */
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 1a81cd6..34852a9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext4_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext4_file_write,
-	.ioctl		= ext4_ioctl,
+	.unlocked_ioctl	= ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e7f894b..a0ee342 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -17,12 +17,18 @@
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_inode_info *ei;
+	struct inode *inode;
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	long retval = 0;
+
+	lock_kernel();
+
+	inode = filp->f_dentry->d_inode;
+	ei = EXT4_I(inode);
 
 	ext4_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
@@ -30,7 +36,8 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 	case EXT4_IOC_GETFLAGS:
 		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
-		return put_user(flags, (int __user *) arg);
+		retval = put_user(flags, (int __user *) arg);
+		goto out;
 	case EXT4_IOC_SETFLAGS: {
 		handle_t *handle = NULL;
 		int err;
@@ -38,14 +45,20 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		if (IS_RDONLY(inode)) {
+			retval = -EROFS;
+			goto out;
+		}
 
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		if (!is_owner_or_cap(inode)) {
+			retval = -EACCES;
+			goto out;
+		}
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if (get_user(flags, (int __user *) arg)) {
+			retval = -EFAULT;
+			goto out;
+		}
 
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT4_DIRSYNC_FL;
@@ -54,7 +67,8 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
-			return -EPERM;
+			retval = -EPERM;
+			goto out;
 		}
 		oldflags = ei->i_flags;
 
@@ -70,7 +84,8 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				retval = -EPERM;
+				goto out;
 			}
 		}
 
@@ -81,7 +96,8 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				retval = -EPERM;
+				goto out;
 			}
 		}
 
@@ -89,7 +105,8 @@ int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		handle = ext4_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
+			retval = PTR_ERR(handle);
+			goto out;
 		}
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -109,17 +126,20 @@ flags_err:
 		ext4_journal_stop(handle);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
-			return err;
+			retval = err;
+			goto out;
 		}
 
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
 			err = ext4_change_inode_journal_flag(inode, jflag);
 		mutex_unlock(&inode->i_mutex);
-		return err;
+		retval = err;
+		goto out;
 	}
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
-		return put_user(inode->i_generation, (int __user *) arg);
+		retval = put_user(inode->i_generation, (int __user *) arg);
+		goto out;
 	case EXT4_IOC_SETVERSION:
 	case EXT4_IOC_SETVERSION_OLD: {
 		handle_t *handle;
@@ -127,16 +147,24 @@ flags_err:
 		__u32 generation;
 		int err;
 
-		if (!is_owner_or_cap(inode))
-			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(generation, (int __user *) arg))
-			return -EFAULT;
+		if (!is_owner_or_cap(inode)) {
+			retval = -EPERM;
+			goto out;
+		}
+		if (IS_RDONLY(inode)) {
+			retval = -EROFS;
+			goto out;
+		}
+		if (get_user(generation, (int __user *) arg)) {
+			retval = -EFAULT;
+			goto out;
+		}
 
 		handle = ext4_journal_start(inode, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+		if (IS_ERR(handle)) {
+			retval = PTR_ERR(handle);
+			goto out;
+		}
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
 			inode->i_ctime = ext4_current_time(inode);
@@ -144,7 +172,8 @@ flags_err:
 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext4_journal_stop(handle);
-		return err;
+		retval = err;
+		goto out;
 	}
 #ifdef CONFIG_JBD2_DEBUG
 	case EXT4_IOC_WAIT_FOR_READONLY:
@@ -158,7 +187,7 @@ flags_err:
 		{
 			struct super_block *sb = inode->i_sb;
 			DECLARE_WAITQUEUE(wait, current);
-			int ret = 0;
+			long ret = 0;
 
 			set_current_state(TASK_INTERRUPTIBLE);
 			add_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
@@ -167,6 +196,7 @@ flags_err:
 				ret = 1;
 			}
 			remove_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
+			unlock_kernel();
 			return ret;
 		}
 #endif
@@ -175,22 +205,33 @@ flags_err:
 			&& S_ISREG(inode->i_mode)
 			&& ei->i_block_alloc_info) {
 			rsv_window_size = ei->i_block_alloc_info->rsv_window_node.rsv_goal_size;
-			return put_user(rsv_window_size, (int __user *)arg);
+			retval = put_user(rsv_window_size, (int __user *)arg);
+			goto out;
 		}
-		return -ENOTTY;
+		retval = -ENOTTY;
+		goto out;
 	case EXT4_IOC_SETRSVSZ: {
 
-		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
-			return -ENOTTY;
+		if (!test_opt(inode->i_sb, RESERVATION) ||
+				!S_ISREG(inode->i_mode)) {
+			retval = -ENOTTY;
+			goto out;
+		}
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		if (IS_RDONLY(inode)) {
+			retval = -EROFS;
+			goto out;
+		}
 
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		if (!is_owner_or_cap(inode)) {
+			retval = -EACCES;
+			goto out;
+		}
 
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			retval = -EFAULT;
+			goto out;
+		}
 
 		if (rsv_window_size > EXT4_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT4_MAX_RESERVE_BLOCKS;
@@ -208,27 +249,34 @@ flags_err:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+		goto out;
 	}
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
 		int err;
 
-		if (!capable(CAP_SYS_RESOURCE))
-			return -EPERM;
+		if (!capable(CAP_SYS_RESOURCE)) {
+			retval = -EPERM;
+			goto out;
+		}
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		if (IS_RDONLY(inode)) {
+			retval = -EROFS;
+			goto out;
+		}
 
-		if (get_user(n_blocks_count, (__u32 __user *)arg))
-			return -EFAULT;
+		if (get_user(n_blocks_count, (__u32 __user *)arg)) {
+			retval = -EFAULT;
+			goto out;
+		}
 
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 
+		unlock_kernel();
 		return err;
 	}
 	case EXT4_IOC_GROUP_ADD: {
@@ -236,27 +284,38 @@ flags_err:
 		struct super_block *sb = inode->i_sb;
 		int err;
 
-		if (!capable(CAP_SYS_RESOURCE))
-			return -EPERM;
+		if (!capable(CAP_SYS_RESOURCE)) {
+			retval = -EPERM;
+			goto out;
+		}
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		if (IS_RDONLY(inode)) {
+			retval = -EROFS;
+			goto out;
+		}
 
 		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
-				sizeof(input)))
-			return -EFAULT;
+				sizeof(input))) {
+			retval = -EFAULT;
+			goto out;
+		}
 
 		err = ext4_group_add(sb, &input);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 
+		unlock_kernel();
 		return err;
 	}
 
 	default:
+		unlock_kernel();
 		return -ENOTTY;
 	}
+out:
+	unlock_kernel();
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 97dd409..4b85c56 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -939,8 +939,7 @@ extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from);
 
 /* ioctl.c */
-extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* namei.c */
-- 
1.5.3.8
