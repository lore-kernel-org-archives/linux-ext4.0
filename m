From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/3] Add ioctl FITRIM.
Date: Wed,  4 Aug 2010 15:44:33 +0200
Message-ID: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
Cc: jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952Ab0HDNpK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 09:45:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds an filesystem independent ioctl to allow implementation of file
system batched discard support.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ioctl.c         |   31 +++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..6c01c3c 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -540,6 +540,33 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
+static int ioctl_fstrim(struct file *filp, unsigned long arg)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	unsigned int minlen;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If filesystem doesn't support trim feature, return. */
+	if (sb->s_op->trim_fs == NULL)
+		return -EOPNOTSUPP;
+
+	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	err = get_user(minlen, (unsigned int __user *) arg);
+	if (err)
+		return err;
+
+	err = sb->s_op->trim_fs(minlen, sb);
+	if (err)
+		return err;
+	return 0;
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -590,6 +617,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		error = ioctl_fsthaw(filp);
 		break;
 
+	case FITRIM:
+		error = ioctl_fstrim(filp, arg);
+		break;
+
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, arg);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..01632e4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -315,6 +315,7 @@ struct inodes_stat_t {
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define FITRIM		_IOWR('X', 121, int)	/* Trim */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1580,6 +1581,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*trim_fs) (unsigned int, struct super_block *);
 };
 
 /*
-- 
1.7.2

