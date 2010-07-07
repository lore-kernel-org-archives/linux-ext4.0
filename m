From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] Add ioctl FITRIM.
Date: Wed,  7 Jul 2010 09:53:31 +0200
Message-ID: <1278489212-12110-2-git-send-email-lczerner@redhat.com>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
Cc: lczerner@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: eshishki@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0GGHyD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jul 2010 03:54:03 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o677s2Ot026214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jul 2010 03:54:02 -0400
In-Reply-To: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
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
index 7faefb4..09b33ae 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -551,6 +551,33 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_bdev(sb->s_bdev, sb);
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
@@ -601,6 +628,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		error = ioctl_fsthaw(filp);
 		break;
 
+	case FITRIM:
+		error = ioctl_fstrim(filp, arg);
+		break;
+
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, arg);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..7a27fa4 100644
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
1.6.6.1

