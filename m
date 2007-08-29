From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH] FIEMAP ioctl
Date: Wed, 29 Aug 2007 15:43:52 +0530
Message-ID: <1188382432.3975.21.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-onKvdqkqUnC6FKsAlL2b"
Cc: TheodoreTso <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41412 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXH2KN1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Aug 2007 06:13:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-onKvdqkqUnC6FKsAlL2b
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Recently there was discussion about an "FIle Extent MAP"(FIEMAP) ioctl for efficiently mapping the extents and holes of a file. This will be many times more efficient than FIBMAP by cutting down the number of ioctls.

This patch implements this ioctl. Ted, in this patch I have used ioctl nunber 10 for FIEMAP. We need to make sure that the ioctl number in our releases and upstream is same. So can you please advise if we can register ioctl no 10 for FIEMAP or if I need to change it?

Let me just mention the the structures and flags used in FIEMAP for people to have a quick review:

struct fiemap_extent {
	__u64	fe_offset; /* offset in bytes for the start of the extent */
	__u64	fe_length; /* length in bytes for the extent */
	__u32	fe_flags;  /* returned FIEMAP_EXTENT_* flags for the extent */
	__u32	fe_lun;	   /* logical device number for extent (starting at 0)*/
};

/*
 * fiemap is not ext4-specific and should be moved into fs.h eventually.
 */

struct fiemap {
	__u64	fm_start;	 /* logical starting byte offset (in/out) */
	__u64	fm_length;	 /* logical length of map (in/out) */
	__u32	fm_flags;	 /* FIEMAP_FLAG_* flags for request (in/out) */
	__u32	fm_extent_count; /* number of extents in fm_extents (in/out) */
	__u64	fm_unused;
	struct fiemap_extent	fm_extents[0];
};

#define	FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
#define	FIEMAP_FLAG_HSM_READ	0x00000002 /* get data from HSM before map */
#define	FIEMAP_FLAG_NUM_EXTENTS	0x00000004 /* return only number of extents */
#define	FIEMAP_FLAG_INCOMPAT	0xff000000 /* error for unknown flags in here */

#define	FIEMAP_EXTENT_HOLE	0x00000001 /* has no data or space allocation */
#define	FIEMAP_EXTENT_UNWRITTEN	0x00000002 /* space allocated, but no data */
#define	FIEMAP_EXTENT_UNMAPPED	0x00000004 /* has data but no space allocation*/
#define	FIEMAP_EXTENT_ERROR	0x00000008 /* mapping error, errno in fe_start*/
#define	FIEMAP_EXTENT_NO_DIRECT	0x00000010 /* cannot access data directly */
#define	FIEMAP_EXTENT_LAST	0x00000020 /* last extent in the file */
#define	FIEMAP_EXTENT_DELALLOC	0x00000040 /* has data but not yet written,
					    * must have EXTENT_UNKNOWN set */
#define	FIEMAP_EXTENT_SECONDARY	0x00000080 /* data (also) in secondary storage,
					    * not in primary if EXTENT_UNKNOWN*/
#define	FIEMAP_EXTENT_EOF	0x00000100 /* if fm_start+fm_len is beyond EOF*/
--

checkpatch.pl has been run on this patch and did not report any errors.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Thanks,
Kalpak.

--=-onKvdqkqUnC6FKsAlL2b
Content-Disposition: attachment; filename=ext4-fiemap.patch
Content-Type: text/x-patch; name=ext4-fiemap.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.22.1/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.22.1.orig/fs/ext4/ioctl.c
+++ linux-2.6.22.1/fs/ext4/ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/compat.h>
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
+#include "fiemap.h"
 
 int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		unsigned long arg)
@@ -248,6 +249,9 @@ flags_err:
 
 		return err;
 	}
+	case EXT4_IOC_FIEMAP: {
+		return ext4_fiemap(inode, filp, cmd, arg);
+	}
 
 	default:
 		return -ENOTTY;
Index: linux-2.6.22.1/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/ext4_fs.h
+++ linux-2.6.22.1/include/linux/ext4_fs.h
@@ -240,15 +240,16 @@ struct ext4_new_group_data {
 #define	EXT4_IOC_SETFLAGS		FS_IOC_SETFLAGS
 #define	EXT4_IOC_GETVERSION		_IOR('f', 3, long)
 #define	EXT4_IOC_SETVERSION		_IOW('f', 4, long)
+#define	EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
+#define	EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 #define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
+#define	EXT4_IOC_FIEMAP			_IOWR('f', 10, struct fiemap)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
 #define	EXT4_IOC_SETVERSION_OLD		FS_IOC_SETVERSION
 #ifdef CONFIG_JBD2_DEBUG
 #define EXT4_IOC_WAIT_FOR_READONLY	_IOR('f', 99, long)
 #endif
-#define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
-#define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -266,7 +267,6 @@ struct ext4_new_group_data {
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
 
-
 /*
  *  Mount options
  */
@@ -1094,6 +1094,8 @@ ext4_get_blocks_wrap(handle_t *handle, s
 	return ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
 					create, extend_disksize);
 }
+extern int ext4_fiemap(struct inode *, struct file *, unsigned int,
+		       unsigned long);
 
 
 #endif	/* __KERNEL__ */
Index: linux-2.6.22.1/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.22.1/include/linux/ext4_fs_extents.h
@@ -131,8 +131,8 @@ struct ext4_ext_path {
  * callback must return valid extent (passed or newly created)
  */
 typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
-					struct ext4_ext_cache *,
-					void *);
+				    struct ext4_ext_cache *,
+				    struct ext4_extent *, void *);
 
 #define EXT_CONTINUE	0
 #define EXT_BREAK	1
Index: linux-2.6.22.1/fs/ext4/extents.c
===================================================================
--- linux-2.6.22.1.orig/fs/ext4/extents.c
+++ linux-2.6.22.1/fs/ext4/extents.c
@@ -42,7 +42,7 @@
 #include <linux/falloc.h>
 #include <linux/ext4_fs_extents.h>
 #include <asm/uaccess.h>
-
+#include "fiemap.h"
 
 /*
  * ext_pblock:
@@ -1513,7 +1513,7 @@ int ext4_ext_walk_space(struct inode *in
 		}
 
 		BUG_ON(cbex.ec_len == 0);
-		err = func(inode, path, &cbex, cbdata);
+		err = func(inode, path, &cbex, ex, cbdata);
 		ext4_ext_drop_refs(path);
 
 		if (err < 0)
@@ -2631,3 +2631,141 @@ retry:
 
 	return ret > 0 ? ret2 : ret;
 }
+
+struct fiemap_internal {
+	struct fiemap	   	*fiemap_s;
+	struct fiemap_extent    fm_extent;
+	size_t		  	tot_mapping_len;
+	char		    	*cur_ext_ptr;
+	int		     	current_extent;
+	int		     	err;
+};
+
+ /*
+  * Callback function called for each extent to gather fiemap information.
+  */
+int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
+		       void *data)
+{
+	struct fiemap_internal *fiemap_i = data;
+	struct fiemap *fiemap_s = fiemap_i->fiemap_s;
+	struct fiemap_extent *fm_extent = &fiemap_i->fm_extent;
+	int current_extent = fiemap_i->current_extent;
+	unsigned long blksize_bits = inode->i_sb->s_blocksize_bits;
+
+	/*
+	 * ext4_ext_walk_space returns a hole for extents that have not been
+	 * allocated yet.
+	 */
+	if (((u64)(newex->ec_block + newex->ec_len) << blksize_bits >=
+	     inode->i_size) && !ext4_ext_is_uninitialized(ex) &&
+	    newex->ec_type == EXT4_EXT_CACHE_GAP)
+		return EXT_BREAK;
+
+	/*
+	 * We only need to return number of extents.
+	 */
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS)
+		goto count_extents;
+
+	if (current_extent >= fiemap_s->fm_extent_count)
+		return EXT_BREAK;
+
+	memset(fm_extent, 0, sizeof(*fm_extent));
+	fm_extent->fe_offset = (__u64)newex->ec_start << blksize_bits;
+	fm_extent->fe_length = (__u64)newex->ec_len << blksize_bits;
+	fiemap_i->tot_mapping_len += fm_extent->fe_length;
+
+	if (newex->ec_type == EXT4_EXT_CACHE_GAP)
+		fm_extent->fe_flags |= FIEMAP_EXTENT_HOLE;
+
+	if (ext4_ext_is_uninitialized(ex))
+		fm_extent->fe_flags |= (FIEMAP_EXTENT_DELALLOC |
+					FIEMAP_EXTENT_UNMAPPED);
+
+	/*
+	 * Mark this fiemap_extent as FIEMAP_EXTENT_EOF if it's past the end
+	 * of file.
+	 */
+	if ((u64)(newex->ec_block + newex->ec_len) << blksize_bits >=
+								inode->i_size)
+		fm_extent->fe_flags |= FIEMAP_EXTENT_EOF;
+
+	if (!copy_to_user(fiemap_i->cur_ext_ptr, fm_extent,
+			  sizeof(struct fiemap_extent))) {
+		fiemap_i->cur_ext_ptr += sizeof(struct fiemap_extent);
+	} else {
+		fiemap_i->err = -EFAULT;
+		return EXT_BREAK;
+	}
+
+count_extents:
+	fiemap_i->current_extent++;
+
+	/*
+	 * Stop if we are beyond requested mapping size but return complete last
+	 * extent.
+	 */
+	if ((u64)(newex->ec_block + newex->ec_len) << blksize_bits >=
+	    fiemap_s->fm_length)
+		return EXT_BREAK;
+
+	return EXT_CONTINUE;
+}
+
+int ext4_fiemap(struct inode *inode, struct file *filp, unsigned int cmd,
+		unsigned long arg)
+{
+	struct fiemap *fiemap_s;
+	struct fiemap_internal fiemap_i;
+	struct fiemap_extent *last_extent;
+	ext4_fsblk_t start_blk;
+	int err = 0;
+
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+		return -EOPNOTSUPP;
+
+	fiemap_s = kmalloc(sizeof(*fiemap_s), GFP_KERNEL);
+	if (fiemap_s == NULL)
+		return -ENOMEM;
+	if (copy_from_user(fiemap_s, (struct fiemap __user *)arg,
+			   sizeof(*fiemap_s)))
+		return -EFAULT;
+
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_INCOMPAT)
+		return -EOPNOTSUPP;
+
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_SYNC)
+		ext4_sync_file(filp, filp->f_path.dentry, 1);
+
+	start_blk = (fiemap_s->fm_start + inode->i_sb->s_blocksize - 1) >>
+						inode->i_sb->s_blocksize_bits;
+	fiemap_i.fiemap_s = fiemap_s;
+	fiemap_i.tot_mapping_len = 0;
+	fiemap_i.cur_ext_ptr = (char *)(arg + sizeof(*fiemap_s));
+	fiemap_i.current_extent = 0;
+	fiemap_i.err = 0;
+
+	/*
+	 * Walk the extent tree gathering extent information
+	 */
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	err = ext4_ext_walk_space(inode, start_blk , EXT_MAX_BLOCK - start_blk,
+				  (void *)ext4_ext_fiemap_cb, &fiemap_i);
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	if (err)
+		return err;
+
+	fiemap_s->fm_extent_count = fiemap_i.current_extent;
+	fiemap_s->fm_length = fiemap_i.tot_mapping_len;
+	if (fiemap_i.current_extent != 0 &&
+	    !(fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS)) {
+		last_extent = &fiemap_i.fm_extent;
+		last_extent->fe_flags |= FIEMAP_EXTENT_LAST;
+	}
+	err = copy_to_user((void *)arg, fiemap_s, sizeof(*fiemap_s));
+
+	return err;
+}
+
Index: linux-2.6.22.1/fs/ext4/fiemap.h
===================================================================
--- /dev/null
+++ linux-2.6.22.1/fs/ext4/fiemap.h
@@ -0,0 +1,49 @@
+/*
+ * linux/fs/ext3/fiemap.h
+ *
+ * Copyright (C) 2007 Cluster File Systems, Inc
+ *
+ * Author: Kalpak Shah <kalpak@clusterfs.com>
+ */
+
+#ifndef _LINUX_EXT4_FIEMAP_H
+#define _LINUX_EXT4_FIEMAP_H
+
+struct fiemap_extent {
+	__u64	fe_offset; /* offset in bytes for the start of the extent */
+	__u64	fe_length; /* length in bytes for the extent */
+	__u32	fe_flags;  /* returned FIEMAP_EXTENT_* flags for the extent */
+	__u32	fe_lun;	   /* logical device number for extent (starting at 0)*/
+};
+
+/*
+ * fiemap is not ext4-specific and should be moved into fs.h eventually.
+ */
+
+struct fiemap {
+	__u64	fm_start;	 /* logical starting byte offset (in/out) */
+	__u64	fm_length;	 /* logical length of map (in/out) */
+	__u32	fm_flags;	 /* FIEMAP_FLAG_* flags for request (in/out) */
+	__u32	fm_extent_count; /* number of extents in fm_extents (in/out) */
+	__u64	fm_unused;
+	struct fiemap_extent	fm_extents[0];
+};
+
+#define	FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
+#define	FIEMAP_FLAG_HSM_READ	0x00000002 /* get data from HSM before map */
+#define	FIEMAP_FLAG_NUM_EXTENTS	0x00000004 /* return only number of extents */
+#define	FIEMAP_FLAG_INCOMPAT	0xff000000 /* error for unknown flags in here */
+
+#define	FIEMAP_EXTENT_HOLE	0x00000001 /* has no data or space allocation */
+#define	FIEMAP_EXTENT_UNWRITTEN	0x00000002 /* space allocated, but no data */
+#define	FIEMAP_EXTENT_UNMAPPED	0x00000004 /* has data but no space allocation*/
+#define	FIEMAP_EXTENT_ERROR	0x00000008 /* mapping error, errno in fe_start*/
+#define	FIEMAP_EXTENT_NO_DIRECT	0x00000010 /* cannot access data directly */
+#define	FIEMAP_EXTENT_LAST	0x00000020 /* last extent in the file */
+#define	FIEMAP_EXTENT_DELALLOC	0x00000040 /* has data but not yet written,
+					    * must have EXTENT_UNKNOWN set */
+#define	FIEMAP_EXTENT_SECONDARY	0x00000080 /* data (also) in secondary storage,
+					    * not in primary if EXTENT_UNKNOWN*/
+#define	FIEMAP_EXTENT_EOF	0x00000100 /* if fm_start+fm_len is beyond EOF*/
+
+#endif /* _LINUX_EXT4_FIEMAP_H */

--=-onKvdqkqUnC6FKsAlL2b--
