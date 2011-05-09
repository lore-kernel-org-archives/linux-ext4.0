From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 17/30] ext4: snapshot control
Date: Mon,  9 May 2011 19:41:35 +0300
Message-ID: <1304959308-11122-18-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1EIQn4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:56 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:56 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Snapshot control with chsnap/lssnap.
Take/delete snapshot with chsnap +/-S.
Enable/disable snapshot with chsnap +/-n.
Show snapshot status with lssnap.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/ioctl.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 942cd9c..3cf6602 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -597,6 +597,8 @@ struct ext4_new_group_data {
  /* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
+#define EXT4_IOC_GETSNAPFLAGS		_IOR('f', 13, long)
+#define EXT4_IOC_SETSNAPFLAGS		_IOW('f', 14, long)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a426332..e100c04 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -83,6 +83,21 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			if (!capable(CAP_SYS_RESOURCE))
 				goto flags_out;
 		}
+
+		/*
+		 * The SNAPFILE flag can only be changed on directories by
+		 * the relevant capability.
+		 * It can only be inherited by regular files.
+		 */
+		if ((flags ^ oldflags) & EXT4_SNAPFILE_FL) {
+			if (!S_ISDIR(inode->i_mode)) {
+				err = -ENOTDIR;
+				goto flags_out;
+			}
+			if (!capable(CAP_SYS_RESOURCE))
+				goto flags_out;
+		}
+
 		if (oldflags & EXT4_EXTENTS_FL) {
 			/* We don't support clearning extent flags */
 			if (!(flags & EXT4_EXTENTS_FL)) {
@@ -139,6 +154,102 @@ flags_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
+	case EXT4_IOC_GETSNAPFLAGS:
+		if (!EXT4_SNAPSHOTS(inode->i_sb))
+			return -EOPNOTSUPP;
+
+		ext4_snapshot_get_flags(inode, filp);
+		flags = ext4_get_snapstate_flags(inode);
+		return put_user(flags, (int __user *) arg);
+
+	case EXT4_IOC_SETSNAPFLAGS: {
+		handle_t *handle = NULL;
+		struct ext4_iloc iloc;
+		unsigned int oldflags;
+		int err;
+
+		if (!EXT4_SNAPSHOTS(inode->i_sb))
+			return -EOPNOTSUPP;
+
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			return err;
+
+		/*
+		 * Snapshot file state flags can only be changed by
+		 * the relevant capability and under snapshot_mutex lock.
+		 */
+		if (!ext4_snapshot_file(inode) ||
+				!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
+		/* update snapshot 'open' flag under i_mutex */
+		mutex_lock(&inode->i_mutex);
+		ext4_snapshot_get_flags(inode, filp);
+		oldflags = ext4_get_snapstate_flags(inode);
+
+		/*
+		 * snapshot_mutex should be held throughout the trio
+		 * snapshot_{set_flags,take,update}().  It must be taken
+		 * before starting the transaction, otherwise
+		 * journal_lock_updates() inside snapshot_take()
+		 * can deadlock:
+		 * A: journal_start()
+		 * A: snapshot_mutex_lock()
+		 * B: journal_start()
+		 * B: snapshot_mutex_lock() (waiting for A)
+		 * A: journal_stop()
+		 * A: snapshot_take() ->
+		 * A: journal_lock_updates() (waiting for B)
+		 */
+		mutex_lock(&EXT4_SB(inode->i_sb)->s_snapshot_mutex);
+
+		handle = ext4_journal_start(inode, 1);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto snapflags_out;
+		}
+		err = ext4_reserve_inode_write(handle, inode, &iloc);
+		if (err)
+			goto snapflags_err;
+
+		err = ext4_snapshot_set_flags(handle, inode, flags);
+		if (err)
+			goto snapflags_err;
+
+		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+snapflags_err:
+		ext4_journal_stop(handle);
+		if (err)
+			goto snapflags_out;
+
+		if (!(oldflags & 1UL<<EXT4_SNAPSTATE_LIST)  &&
+				(flags & 1UL<<EXT4_SNAPSTATE_LIST))
+			/* setting list flag - take snapshot */
+			err = ext4_snapshot_take(inode);
+snapflags_out:
+		if ((oldflags|flags) & 1UL<<EXT4_SNAPSTATE_LIST) {
+			/* if clearing list flag, cleanup snapshot list */
+			int ret;
+
+			/* update/cleanup snapshots list even if take failed */
+			ret = ext4_snapshot_update(inode->i_sb,
+					!(flags & 1UL<<EXT4_SNAPSTATE_LIST), 0);
+			if (!err)
+				err = ret;
+		}
+
+		mutex_unlock(&EXT4_SB(inode->i_sb)->s_snapshot_mutex);
+		mutex_unlock(&inode->i_mutex);
+		mnt_drop_write(filp->f_path.mnt);
+		return err;
+	}
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
 		return put_user(inode->i_generation, (int __user *) arg);
@@ -210,6 +321,8 @@ setversion_out:
 
 		if (get_user(n_blocks_count, (__u32 __user *)arg))
 			return -EFAULT;
+		/* avoid snapshot_take() in the middle of group_extend() */
+		mutex_lock(&EXT4_SB(sb)->s_snapshot_mutex);
 
 		err = mnt_want_write(filp->f_path.mnt);
 		if (err)
@@ -223,6 +336,7 @@ setversion_out:
 		}
 		if (err == 0)
 			err = err2;
+		mutex_unlock(&EXT4_SB(sb)->s_snapshot_mutex);
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
@@ -285,6 +399,8 @@ mext_out:
 		if (err)
 			return err;
 
+		/* avoid snapshot_take() in the middle of group_add() */
+		mutex_lock(&EXT4_SB(sb)->s_snapshot_mutex);
 		err = ext4_group_add(sb, &input);
 		if (EXT4_SB(sb)->s_journal) {
 			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
@@ -293,6 +409,7 @@ mext_out:
 		}
 		if (err == 0)
 			err = err2;
+		mutex_unlock(&EXT4_SB(sb)->s_snapshot_mutex);
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
-- 
1.7.0.4

