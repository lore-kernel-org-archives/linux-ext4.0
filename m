From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH v2] fs: new FS_IOC_[GS]ETFLAGS2 interface
Date: Tue, 7 Jan 2014 14:04:30 -0800
Message-ID: <20140107220430.GE9229@birch.djwong.org>
References: <20140107025855.GA9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Aurelien Jarno <aurelien@aurel32.net>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rob Browning <rlb@defaultvalue.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140107025855.GA9229@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a(nother) proof of concept interface for replacing the
contentious FS_IOC_[GS]ETFLAGS interface with a new ioctl that allows
for a dramatic increase in the size of the flag-space.

In this new interface, the new [GS]ETFLAGS functions take a flag
number and either return or set the flag value.  This will let us
put all the 'common' flags into a common flag-space and create
specific flag-spaces for each filesystem's unique features.

The initial conversion is for ext4, though given the similarities of
most filesystems' implementations, converting the rest shouldn't be
difficult.  It also pretends to service GETVERSION as an example of an
ext4-specific "flag".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/filesystems/inode-flags-ioctl.txt |   89 ++++++++
 fs/ext4/ioctl.c                                 |  257 ++++++++++++++---------
 include/uapi/linux/fs.h                         |    9 +
 3 files changed, 256 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/filesystems/inode-flags-ioctl.txt

diff --git a/Documentation/filesystems/inode-flags-ioctl.txt b/Documentation/filesystems/inode-flags-ioctl.txt
new file mode 100644
index 0000000..7244c37
--- /dev/null
+++ b/Documentation/filesystems/inode-flags-ioctl.txt
@@ -0,0 +1,89 @@
+This is the new inode flags ioctl interface.  Whereas before we could only work
+with a single value whose size changed depending on the platform, this new
+interface establishes the capability to store 2^32 (flagspace, value) tuples
+per inode.  Both key and value are defined to be an unsigned 32-bit quantity.
+
+To use this interface, we define struct inode_flag_ioctl.  The 'flag' field
+contains an identifier for the flag space that you want.  This is
+FS_IOC_FLAGS_COMMON for the old [GS]ETFLAGS functionality, or a FS-specific
+value.  The 'value' field contains the value that you wish to get or set.
+
+Here is an example program:
+/*
+ * Get/set flags via FS_IOC_[GS]ETFLAGS2 interface
+ * Copyright (C) 2014 Oracle, Darrick J. Wong
+ * Licensed under the GPLv2.
+ */
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <asm/types.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+
+#ifndef FS_IOC_GETFLAGS2
+struct inode_flag_ioctl {
+	__u32 flag;
+	__u32 value;
+};
+#define FS_IOC_GETFLAGS2 		_IOR('f', 12, struct inode_flag_ioctl)
+#define FS_IOC_SETFLAGS2 		_IOW('f', 13, struct inode_flag_ioctl)
+#endif /* FS_IOC_GETFLAGS2 */
+
+int main(int argc, char *argv[])
+{
+	struct inode_flag_ioctl fi;
+	__u32 key, value;
+	int set, ret, opt, i, fd;
+
+	if (argc < 2) {
+		printf("Usage: %s [-g key|-s key] [-v value] files\n",
+		       argv[0]);
+		return 1;
+	}
+
+	set = key = value = 0;
+	while ((opt = getopt(argc, argv, "g:s:v:")) != -1) {
+		switch (opt) {
+		case 'g':
+			set = 0;
+			key = strtol(optarg, NULL, 0);
+			break;
+		case 's':
+			set = 1;
+			key = strtol(optarg, NULL, 0);
+			break;
+		case 'v':
+			value = strtol(optarg, NULL, 0);
+			break;
+		default:
+			printf("Usage: %s [-g key|-s key] [-v value] files\n",
+			       argv[0]);
+			return 1;
+		}
+	}
+
+	fi.flag = key;
+	for (i = optind; i < argc; i++) {
+		fd = open(argv[i], O_RDONLY);
+		if (fd < 0) {
+			perror(argv[i]);
+			continue;
+		}
+		if (set)
+			fi.value = value;
+		ret = ioctl(fd, (set ? FS_IOC_SETFLAGS2 : FS_IOC_GETFLAGS2),
+			    &fi);
+		close(fd);
+		if (ret) {
+			perror(argv[i]);
+			continue;
+		}
+		if (!set)
+			printf("%s: 0x%x = 0x%x\n", argv[i], key, fi.value);
+	}
+
+	return 0;
+}
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 60589b6..9de72d5 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -213,128 +213,187 @@ swap_boot_out:
 	return err;
 }
 
-long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int ext4_ioctl_setflags(struct file *filp, unsigned int flags)
 {
 	struct inode *inode = file_inode(filp);
-	struct super_block *sb = inode->i_sb;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	unsigned int flags;
+	handle_t *handle = NULL;
+	int err, migrate = 0;
+	struct ext4_iloc iloc;
+	unsigned int oldflags, mask, i;
+	unsigned int jflag;
 
-	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
 
-	switch (cmd) {
-	case EXT4_IOC_GETFLAGS:
-		ext4_get_inode_flags(ei);
-		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
-		return put_user(flags, (int __user *) arg);
-	case EXT4_IOC_SETFLAGS: {
-		handle_t *handle = NULL;
-		int err, migrate = 0;
-		struct ext4_iloc iloc;
-		unsigned int oldflags, mask, i;
-		unsigned int jflag;
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
 
-		if (!inode_owner_or_capable(inode))
-			return -EACCES;
+	flags = ext4_mask_flags(inode->i_mode, flags);
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+	err = -EPERM;
+	mutex_lock(&inode->i_mutex);
+	/* Is it quota file? Do not allow user to mess with it */
+	if (IS_NOQUOTA(inode))
+		goto flags_out;
 
-		err = mnt_want_write_file(filp);
-		if (err)
-			return err;
+	oldflags = ei->i_flags;
 
-		flags = ext4_mask_flags(inode->i_mode, flags);
+	/* The JOURNAL_DATA flag is modifiable only by root */
+	jflag = flags & EXT4_JOURNAL_DATA_FL;
 
-		err = -EPERM;
-		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode))
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
+	 * the relevant capability.
+	 *
+	 * This test looks nicer. Thanks to Pauline Middelink
+	 */
+	if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
+		if (!capable(CAP_LINUX_IMMUTABLE))
 			goto flags_out;
+	}
 
-		oldflags = ei->i_flags;
-
-		/* The JOURNAL_DATA flag is modifiable only by root */
-		jflag = flags & EXT4_JOURNAL_DATA_FL;
-
-		/*
-		 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
-		 * the relevant capability.
-		 *
-		 * This test looks nicer. Thanks to Pauline Middelink
-		 */
-		if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
-			if (!capable(CAP_LINUX_IMMUTABLE))
-				goto flags_out;
-		}
-
-		/*
-		 * The JOURNAL_DATA flag can only be changed by
-		 * the relevant capability.
-		 */
-		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
-			if (!capable(CAP_SYS_RESOURCE))
-				goto flags_out;
-		}
-		if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
-			migrate = 1;
-
-		if (flags & EXT4_EOFBLOCKS_FL) {
-			/* we don't support adding EOFBLOCKS flag */
-			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
-				err = -EOPNOTSUPP;
-				goto flags_out;
-			}
-		} else if (oldflags & EXT4_EOFBLOCKS_FL)
-			ext4_truncate(inode);
+	/*
+	 * The JOURNAL_DATA flag can only be changed by
+	 * the relevant capability.
+	 */
+	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
+		if (!capable(CAP_SYS_RESOURCE))
+			goto flags_out;
+	}
+	if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
+		migrate = 1;
 
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
-		if (IS_ERR(handle)) {
-			err = PTR_ERR(handle);
+	if (flags & EXT4_EOFBLOCKS_FL) {
+		/* we don't support adding EOFBLOCKS flag */
+		if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
+			err = -EOPNOTSUPP;
 			goto flags_out;
 		}
-		if (IS_SYNC(inode))
-			ext4_handle_sync(handle);
-		err = ext4_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto flags_err;
-
-		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
-			if (!(mask & EXT4_FL_USER_MODIFIABLE))
-				continue;
-			if (mask & flags)
-				ext4_set_inode_flag(inode, i);
-			else
-				ext4_clear_inode_flag(inode, i);
-		}
+	} else if (oldflags & EXT4_EOFBLOCKS_FL)
+		ext4_truncate(inode);
 
-		ext4_set_inode_flags(inode);
-		inode->i_ctime = ext4_current_time(inode);
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto flags_out;
+	}
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto flags_err;
+
+	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
+		if (!(mask & EXT4_FL_USER_MODIFIABLE))
+			continue;
+		if (mask & flags)
+			ext4_set_inode_flag(inode, i);
+		else
+			ext4_clear_inode_flag(inode, i);
+	}
 
-		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-flags_err:
-		ext4_journal_stop(handle);
-		if (err)
-			goto flags_out;
+	ext4_set_inode_flags(inode);
+	inode->i_ctime = ext4_current_time(inode);
 
-		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
-			err = ext4_change_inode_journal_flag(inode, jflag);
-		if (err)
-			goto flags_out;
-		if (migrate) {
-			if (flags & EXT4_EXTENTS_FL)
-				err = ext4_ext_migrate(inode);
-			else
-				err = ext4_ind_migrate(inode);
-		}
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+flags_err:
+	ext4_journal_stop(handle);
+	if (err)
+		goto flags_out;
+
+	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
+		err = ext4_change_inode_journal_flag(inode, jflag);
+	if (err)
+		goto flags_out;
+	if (migrate) {
+		if (flags & EXT4_EXTENTS_FL)
+			err = ext4_ext_migrate(inode);
+		else
+			err = ext4_ind_migrate(inode);
+	}
 
 flags_out:
-		mutex_unlock(&inode->i_mutex);
-		mnt_drop_write_file(filp);
-		return err;
+	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(filp);
+	return err;
+}
+
+static int ext4_ioctl_getflags2(struct file *filp, void __user *arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct inode_flag_ioctl fi;
+
+	if (copy_from_user(&fi, arg, sizeof(fi)))
+		return -EFAULT;
+
+	switch (fi.flag) {
+	case FS_IOC_FLAGS_COMMON:
+		ext4_get_inode_flags(ei);
+		fi.value = ei->i_flags & EXT4_FL_USER_VISIBLE;
+		break;
+	case FS_IOC_FLAGS_EXT4_IVERSION:
+		fi.value = inode->i_generation;
+		break;
+	default:
+		return -EINVAL;
 	}
+
+	if (copy_to_user(arg, &fi, sizeof(fi)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ext4_ioctl_setflags2(struct file *filp, void __user *arg)
+{
+	struct inode_flag_ioctl fi;
+
+	if (copy_from_user(&fi, arg, sizeof(fi)))
+		return -EFAULT;
+
+	switch (fi.flag) {
+	case FS_IOC_FLAGS_COMMON:
+		return ext4_ioctl_setflags(filp, fi.value);
+	case FS_IOC_FLAGS_EXT4_IVERSION:
+		/* not supported right now */
+		return -ENOTTY;
+	}
+	return -EINVAL;
+}
+
+long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct super_block *sb = inode->i_sb;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int flags;
+
+	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS2:
+		return ext4_ioctl_getflags2(filp, (void __user *)arg);
+	case FS_IOC_SETFLAGS2:
+		return ext4_ioctl_setflags2(filp, (void __user *)arg);
+	case EXT4_IOC_GETFLAGS:
+		printk_once(KERN_WARNING "EXT4-fs: FS_IOC_GETFLAGS is "
+			    "deprecated; use FS_IOC_GETFLAGS2.\n");
+		ext4_get_inode_flags(ei);
+		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
+		return put_user(flags, (int __user *) arg);
+	case EXT4_IOC_SETFLAGS:
+		printk_once(KERN_WARNING "EXT4-fs: FS_IOC_SETFLAGS is "
+			    "deprecated; use FS_IOC_SETFLAGS2.\n");
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+		return ext4_ioctl_setflags(filp, flags);
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
+		printk_once(KERN_WARNING "EXT4-fs: FS_IOC_GETVERSION is "
+			    "deprecated; use FS_IOC_GETFLAGS2.\n");
 		return put_user(inode->i_generation, (int __user *) arg);
 	case EXT4_IOC_SETVERSION:
 	case EXT4_IOC_SETVERSION_OLD: {
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 6c28b61..806165f 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -196,6 +196,15 @@ struct inodes_stat_t {
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
 #define FS_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
 
+/* New inode flags API */
+#define FS_IOC_FLAGS_COMMON		0x00000000 /* common inode flags */
+#define FS_IOC_FLAGS_EXT4_IVERSION	0x0000EF53 /* ext4 inode version */
+struct inode_flag_ioctl {
+	__u32 flag;
+	__u32 value;
+};
+#define FS_IOC_GETFLAGS2		_IOR('f', 12, struct inode_flag_ioctl)
+#define FS_IOC_SETFLAGS2		_IOW('f', 13, struct inode_flag_ioctl)
 
 #define SYNC_FILE_RANGE_WAIT_BEFORE	1
 #define SYNC_FILE_RANGE_WRITE		2
