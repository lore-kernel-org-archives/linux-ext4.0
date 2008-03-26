From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] vfs-level fiemap interface
Date: Wed, 26 Mar 2008 10:40:42 -0500
Message-ID: <47EA6E7A.90605@redhat.com>
References: <47EA6DA9.4010103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYCZPkn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2008 11:40:43 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2QFehcB017074
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 11:40:43 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QFegl1012024
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 11:40:43 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m2QFegwd015333
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 11:40:42 -0400
In-Reply-To: <47EA6DA9.4010103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Basic vfs-level fiemap infrastructure, which sets up a new
->fiemap inode operation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(and I think also signed-off-by Andreas and/or Kalpak as well should
also go here, since it's their work originally.)

Index: linux-2.6.25-rc1/include/linux/fiemap.h
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/include/linux/fiemap.h
@@ -0,0 +1,49 @@
+/*
+ * FIEMAP ioctl infrastructure.
+ *
+ * Copyright (C) 2007 Cluster File Systems, Inc
+ *
+ * Author: Kalpak Shah <kalpak.shah@sun.com>
+ *	   Andreas Dilger <adilger@sun.com>
+ */
+
+#ifndef _LINUX_FIEMAP_H
+#define _LINUX_FIEMAP_H
+
+struct fiemap_extent {
+	__u64	fe_offset; /* offset in bytes for the start of the extent */
+	__u64	fe_length; /* length in bytes for the extent */
+	__u32	fe_flags;  /* returned FIEMAP_EXTENT_* flags for the extent */
+	__u32	fe_lun;	   /* logical device number for extent (starting at 0)*/
+};
+
+struct fiemap {
+	__u64	fm_start;	 /* logical starting byte offset (in/out) */
+	__u64	fm_length;	 /* logical length of map (in/out) */
+	__u32	fm_flags;	 /* FIEMAP_FLAG_* flags for request (in/out) */
+	__u32	fm_extent_count; /* number of extents in fm_extents (in/out) */
+	__u64	fm_end_offset;	 /* logical offset of end of mapping in last ioctl (out) */
+	struct fiemap_extent	fm_extents[0];
+};
+
+#define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
+#define FIEMAP_FLAG_HSM_READ	0x00000002 /* get data from HSM before map */
+#define FIEMAP_FLAG_NUM_EXTENTS	0x00000004 /* return only number of extents */
+#define FIEMAP_FLAG_INCOMPAT	0xff000000 /* error for unknown flags in here */
+
+#define FIEMAP_FLAG_LUN_OFFSET	0x01000000 /* use lun offsets, instead of
+					    * logical file offsets */
+
+#define FIEMAP_EXTENT_HOLE	0x00000001 /* has no data or space allocation */
+#define FIEMAP_EXTENT_UNWRITTEN	0x00000002 /* space allocated, but no data */
+#define FIEMAP_EXTENT_UNKNOWN	0x00000004 /* in use, location unknown */
+#define FIEMAP_EXTENT_ERROR	0x00000008 /* mapping error, errno in fe_start*/
+#define FIEMAP_EXTENT_NO_DIRECT	0x00000010 /* cannot access data directly */
+#define FIEMAP_EXTENT_LAST	0x00000020 /* last extent in the file */
+#define FIEMAP_EXTENT_DELALLOC	0x00000040 /* has data but not yet written,
+					    * must have EXTENT_UNKNOWN set */
+#define FIEMAP_EXTENT_SECONDARY	0x00000080 /* data (also) in secondary storage,
+					    * not in primary if EXTENT_UNKNOWN*/
+#define FIEMAP_EXTENT_EOF	0x00000100 /* if fm_start+fm_len is beyond EOF*/
+
+#endif /* _LINUX_FIEMAP_H */
Index: linux-2.6.25-rc1/include/linux/fs.h
===================================================================
--- linux-2.6.25-rc1.orig/include/linux/fs.h
+++ linux-2.6.25-rc1/include/linux/fs.h
@@ -228,6 +228,7 @@ extern int dir_notify_enable;
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
+#define FS_IOC_FIEMAP			_IOWR('f', 10, struct fiemap)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
@@ -287,6 +288,7 @@ extern int dir_notify_enable;
 #include <linux/pid.h>
 #include <linux/mutex.h>
 #include <linux/capability.h>
+#include <linux/fiemap.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -1223,6 +1225,7 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
+	int (*fiemap) (struct inode *, unsigned long arg);
 };
 
 struct seq_file;
Index: linux-2.6.25-rc1/fs/ioctl.c
===================================================================
--- linux-2.6.25-rc1.orig/fs/ioctl.c
+++ linux-2.6.25-rc1/fs/ioctl.c
@@ -71,6 +71,34 @@ static int ioctl_fibmap(struct file *fil
 	return put_user(res, p);
 }
 
+static int ioctl_fiemap(struct file *filp, unsigned long arg)
+{
+	struct fiemap fiemap_s;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int error = 0;
+
+	if (!inode->i_op->fiemap)
+		return -EOPNOTSUPP;
+
+        if (copy_from_user(&fiemap_s, (struct fiemap __user *)arg,
+                           sizeof(struct fiemap)))
+                return -EFAULT;
+
+	/* Need arg sanity checking:
+	 * start >= 0?  Must be; unsigned.
+	 * length > 0? (or is -1 valid?)
+	 * extent count non-zero if not FLAG_NUM_EXTENTS
+	 */
+
+	/* Should fs do this under a lock? */
+	if (fiemap_s.fm_flags & FIEMAP_FLAG_SYNC)
+		filemap_write_and_wait(inode->i_mapping);
+
+	error = inode->i_op->fiemap(inode, arg);
+
+	return error;
+}
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
@@ -80,6 +108,8 @@ static int file_ioctl(struct file *filp,
 	switch (cmd) {
 	case FIBMAP:
 		return ioctl_fibmap(filp, p);
+	case FS_IOC_FIEMAP:
+		return ioctl_fiemap(filp, arg);
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:

