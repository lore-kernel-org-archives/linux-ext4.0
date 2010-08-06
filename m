From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/3] Add ioctl FITRIM.
Date: Fri,  6 Aug 2010 13:31:14 +0200
Message-ID: <1281094276-11377-2-git-send-email-lczerner@redhat.com>
References: <1281094276-11377-1-git-send-email-lczerner@redhat.com>
Cc: dmonakhov@openvz.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228Ab0HFLcI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 07:32:08 -0400
In-Reply-To: <1281094276-11377-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds an filesystem independent ioctl to allow implementation of file
system batched discard support. It takes an array of three uint64_t
as an argument, the meaning of each item is as follows:

array[0] - (start) first Byte to trim
array[1] - (len) number of Bytes to trim from start
array[2] - (minlen) minimum extent length to trim, free extents shorter
than this number of Bytes will be ignored. This number will be rounded
up to the block size.

It is also possible to specify NULL as an argument. In this case the
arguments will set itself as follows:

args[0] = 0;
args[1] = LLONG_MAX;
args[2] = 0;

So it will trim the whole file system at one run.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ioctl.c         |   34 ++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..a0e243c 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -540,6 +540,36 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
+static int ioctl_fstrim(struct file *filp, void __user *argp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	uint64_t args[3];
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
+	if (argp == NULL) {
+		args[0] = 0;
+		args[1] = ULLONG_MAX;
+		args[2] = 0;
+	} else if (copy_from_user(args, argp, sizeof(args)))
+		return -EFAULT;
+
+	err = sb->s_op->trim_fs(sb, args[0], args[1], args[2]);
+	if (err)
+		return err;
+	return 0;
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -590,6 +620,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		error = ioctl_fsthaw(filp);
 		break;
 
+	case FITRIM:
+		error = ioctl_fstrim(filp, argp);
+		break;
+
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, arg);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e5106e4..0cc196f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -316,6 +316,7 @@ struct inodes_stat_t {
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
+#define FITRIM		_IOW('X', 121, uint64_t)/* Trim */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1582,6 +1583,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*trim_fs) (struct super_block *, uint64_t, uint64_t, uint64_t);
 };
 
 /*
-- 
1.7.2

