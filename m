From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC][PATCH] fiemap support for ext3
Date: Fri, 18 Apr 2008 17:09:13 -0400
Message-ID: <20080418210913.GB13973@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYDRVSl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 17:18:41 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3ILIfnm025660
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 17:18:41 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ILIeqb022615
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 17:18:40 -0400
Received: from unused (unused [10.11.231.15] (may be forged))
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ILIe7n032748
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 17:18:40 -0400
Received: from unused (localhost.localdomain [127.0.0.1])
	by unused (8.14.1/8.14.1) with ESMTP id m3IL9DST017671
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 17:09:13 -0400
Received: (from jwhiter@localhost)
	by unused (8.14.1/8.14.1/Submit) id m3IL9Dpl017670
	for linux-ext4@vger.kernel.org; Fri, 18 Apr 2008 17:09:13 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Here is my patch for fiemap support on ext3.  The main reason for doing this is
because it will make it easier for application developers who are wanting to
take advantage of fiemap on extent based fs's to be able to use the same
interface for ext3 as well without having to fallback onto something like
fibmap.  Fibmap also means you are calling ext3_get_block for _every_ block in
the file, which is ineffecient when ext3_get_blocks can map multiple contiguous
blocks all at once, reducing the number of times you have to call
ext3_get_blocks.  Tested this with sandeens fiemap test program and verified it
with filefrag.  Thanks much,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/fs/ext3/file.c
===================================================================
--- linux-2.6.orig/fs/ext3/file.c
+++ linux-2.6/fs/ext3/file.c
@@ -134,5 +134,6 @@ const struct inode_operations ext3_file_
 	.removexattr	= generic_removexattr,
 #endif
 	.permission	= ext3_permission,
+	.fiemap		= ext3_fiemap,
 };
 
Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c
+++ linux-2.6/fs/ext3/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/fiemap.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -981,6 +982,157 @@ out:
 	return ret;
 }
 
+int ext3_fiemap(struct inode *inode, unsigned long arg)
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
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_SYNC)
+		ext3_force_commit(inode->i_sb);
+
+	/* guard against change */
+	mutex_lock(&EXT3_I(inode)->truncate_mutex);
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
+		ret = ext3_get_block(inode, start_blk, &tmp, 0);
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
+	mutex_unlock(&EXT3_I(inode)->truncate_mutex);
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
+
 /*
  * `handle' can be NULL if create is zero
  */
Index: linux-2.6/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.orig/include/linux/ext3_fs.h
+++ linux-2.6/include/linux/ext3_fs.h
@@ -836,6 +836,7 @@ extern void ext3_truncate (struct inode 
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
+extern int ext3_fiemap(struct inode *inode, unsigned long arg);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
