From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fiemap support for ext3
Date: Wed, 23 Apr 2008 15:39:15 -0400
Message-ID: <20080423193914.GA25173@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYDWTtt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 15:49:49 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Here is my reworked fiemap patch for ext3.  The generic fiemap handler takes the
get_block_t from the filesystem and does the fiemap that way, so then adding
ext2 support should be a snap, as well as any other fs that wants to use this.
Thanks much,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6.25/fs/ext3/file.c
===================================================================
--- linux-2.6.25.orig/fs/ext3/file.c
+++ linux-2.6.25/fs/ext3/file.c
@@ -134,5 +134,6 @@ const struct inode_operations ext3_file_
 	.removexattr	= generic_removexattr,
 #endif
 	.permission	= ext3_permission,
+	.fiemap		= ext3_fiemap,
 };
 
Index: linux-2.6.25/fs/ext3/inode.c
===================================================================
--- linux-2.6.25.orig/fs/ext3/inode.c
+++ linux-2.6.25/fs/ext3/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/fiemap.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -981,6 +982,11 @@ out:
 	return ret;
 }
 
+int ext3_fiemap(struct inode *inode, unsigned long arg)
+{
+	return generic_block_fiemap(inode, arg, ext3_get_block);
+}
+
 /*
  * `handle' can be NULL if create is zero
  */
Index: linux-2.6.25/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.25.orig/include/linux/ext3_fs.h
+++ linux-2.6.25/include/linux/ext3_fs.h
@@ -836,6 +836,7 @@ extern void ext3_truncate (struct inode 
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
+extern int ext3_fiemap(struct inode *inode, unsigned long arg);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
Index: linux-2.6.25/fs/ioctl.c
===================================================================
--- linux-2.6.25.orig/fs/ioctl.c
+++ linux-2.6.25/fs/ioctl.c
@@ -13,6 +13,8 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/writeback.h>
+#include <linux/buffer_head.h>
 
 #include <asm/ioctls.h>
 
@@ -99,6 +101,166 @@ static int ioctl_fiemap(struct file *fil
 	return error;
 }
 
+int generic_block_fiemap(struct inode *inode, unsigned long arg,
+			 get_block_t *get_block)
+{
+	struct fiemap *fiemap_s;
+	struct fiemap_extent fiemap_e;
+	struct buffer_head tmp;
+	unsigned int start_blk;
+	unsigned int num_of_extents;
+	long length;
+	char *cur_ext_ptr = (char *)(arg + sizeof(struct fiemap));
+	int ret, hole = 0;
+
+	fiemap_s = kmalloc(sizeof(struct fiemap), GFP_KERNEL);
+	if (!fiemap_s)
+		return -ENOMEM;
+
+	if (copy_from_user(fiemap_s, (struct fiemap __user *)arg,
+			   sizeof(struct fiemap))) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	/*
+	 * if fm_start is in the middle of the current block, get the next
+	 * block so we don't end up returning a start thats before the given
+	 * fm_start
+	 */
+	start_blk = (fiemap_s->fm_start + (1 << inode->i_blkbits) - 1) >>
+		inode->i_blkbits;
+	num_of_extents = fiemap_s->fm_extent_count;
+
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_SYNC) {
+		struct writeback_control wbc = {
+			.sync_mode = WB_SYNC_ALL,
+			.nr_to_write = 0,
+		};
+		ret = sync_inode(inode, &wbc);
+		if (ret)
+			goto out_free;
+	}
+
+	/* guard against change */
+	mutex_lock(&inode->i_mutex);
+
+	/*
+	 * we want the comparisons to be unsigned, in case somebody passes -1,
+	 * meaning they want they want the entire file, but the result has to be
+	 * signed so we can handle the case where we get more blocks than the
+	 * size of the file
+	 */
+	length = (long)min((unsigned long)fiemap_s->fm_length,
+			   (unsigned long)i_size_read(inode));
+
+	fiemap_s->fm_start = start_blk << inode->i_blkbits;
+	fiemap_s->fm_length = 0;
+
+	memset(&fiemap_e, 0, sizeof(struct fiemap_extent));
+	do {
+		/*
+		 * we set this to length because we want ext3_get_block to
+		 * find as many contiguous blocks as it can
+		 */
+		memset(&tmp, 0, sizeof(struct buffer_head));
+		tmp.b_size = length;
+
+		ret = get_block(inode, start_blk, &tmp, 0);
+		if (ret)
+			break;
+
+		/*
+		 * Hole, we're going to have to walk the inodes blocks until
+		 * find data
+		 */
+		if (!tmp.b_blocknr) {
+
+			if (!hole) {
+				hole = 1;
+				fiemap_e.fe_flags |= FIEMAP_EXTENT_HOLE;
+				fiemap_e.fe_offset = start_blk <<
+					inode->i_blkbits;
+			}
+
+			fiemap_e.fe_length += 1 << inode->i_blkbits;
+			length -= 1 << inode->i_blkbits;
+			start_blk++;
+		} else {
+			if (hole &&
+			    !copy_to_user(cur_ext_ptr, &fiemap_e,
+					  sizeof(struct fiemap_extent))) {
+				cur_ext_ptr += sizeof(struct fiemap_extent);
+				fiemap_s->fm_extent_count++;
+				fiemap_s->fm_length += fiemap_e.fe_length;
+
+				hole = 0;
+				num_of_extents--;
+				memset(&fiemap_e, 0,
+				       sizeof(struct fiemap_extent));
+
+				if (!num_of_extents || length <= 0)
+					break;
+			} else if (hole) {
+				/* copy_to_user failed */
+				ret = -EFAULT;
+				break;
+			}
+
+			length -= tmp.b_size;
+			start_blk += tmp.b_size >> inode->i_blkbits;
+
+			fiemap_e.fe_offset = tmp.b_blocknr <<
+				inode->i_blkbits;
+			fiemap_e.fe_length = tmp.b_size;
+
+			if (length <= 0)
+				fiemap_e.fe_flags |= FIEMAP_EXTENT_LAST;
+
+			if (!copy_to_user(cur_ext_ptr, &fiemap_e,
+					  sizeof(struct fiemap_extent))) {
+				cur_ext_ptr += sizeof(struct fiemap_extent);
+				num_of_extents--;
+			} else {
+				ret = -EFAULT;
+				break;
+			}
+
+			fiemap_s->fm_extent_count++;
+			fiemap_s->fm_length += fiemap_e.fe_length;
+
+			memset(&fiemap_e, 0, sizeof(struct fiemap_extent));
+		}
+	} while (length > 0 && num_of_extents);
+
+	mutex_unlock(&inode->i_mutex);
+
+	/* hole at the end of the file */
+	if (hole && !copy_to_user(cur_ext_ptr, &fiemap_e,
+				  sizeof(struct fiemap_extent))) {
+		fiemap_s->fm_extent_count++;
+		fiemap_s->fm_length += fiemap_e.fe_length;
+
+		if (length <= 0)
+			fiemap_e.fe_flags |= FIEMAP_EXTENT_LAST;
+
+	} else if (hole) {
+		/* copy to user failed */
+		ret = -EFAULT;
+	}
+
+	if (!ret) {
+		if (copy_to_user((char *)arg, fiemap_s,
+				 sizeof(struct fiemap)))
+			ret = -EFAULT;
+	}
+
+out_free:
+	kfree(fiemap_s);
+	return ret;
+}
+EXPORT_SYMBOL(generic_block_fiemap);
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
Index: linux-2.6.25/include/linux/fs.h
===================================================================
--- linux-2.6.25.orig/include/linux/fs.h
+++ linux-2.6.25/include/linux/fs.h
@@ -1925,6 +1925,8 @@ extern int vfs_fstat(unsigned int, struc
 extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
+extern int generic_block_fiemap(struct inode *inode, unsigned long arg,
+				get_block_t *get_block);
 
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
