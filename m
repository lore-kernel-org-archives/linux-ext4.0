From: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: implement fallocate V2
Date: Mon, 16 Jul 2007 15:37:51 +1000
Message-ID: <20070716053751.GN12413810@sgi.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
	cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com,
	dgc@sgi.com, michael.kerrisk@gmx.net
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49001 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071AbXGPFiN (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 01:38:13 -0400
Content-Disposition: inline
In-Reply-To: <20070713184125.GA12156@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Initial implementation of ->fallocate for XFS.

Version 2:

o Make allocation and setting the file size atomic.
o Drop deallocate/punch functionality
o use mode field appropriately to determine if size needs changing.

---
 fs/xfs/linux-2.6/xfs_iops.c |   47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-07-16 14:16:02.090255611 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-07-16 14:50:07.087885337 +1000
@@ -51,6 +51,7 @@
 #include <linux/xattr.h>
 #include <linux/namei.h>
 #include <linux/security.h>
+#include <linux/falloc.h>
 
 /*
  * Get a XFS inode from a given vnode.
@@ -812,6 +813,51 @@ xfs_vn_removexattr(
 	return namesp->attr_remove(vp, attr, xflags);
 }
 
+/*
+ * generic space allocation vector.
+ *
+ * This should really through a bhv_vop before stuffing around
+ * with xfs_inodes and such.
+ */
+STATIC long
+xfs_vn_fallocate(
+	struct inode	*inode,
+	int		mode,
+	loff_t		offset,
+	loff_t		len)
+{
+	long		error = -EOPNOTSUPP;
+	bhv_vnode_t	*vp = vn_from_inode(inode);
+	bhv_desc_t	*bdp;
+	loff_t		new_size = 0;
+	xfs_flock64_t	bf;
+
+	bf.l_whence = 0;
+	bf.l_start = offset;
+	bf.l_len = len;
+
+	bdp = bhv_lookup_range(VN_BHV_HEAD(vp), VNODE_POSITION_XFS,
+						VNODE_POSITION_XFS);
+
+	xfs_ilock(xfs_vtoi(vp), XFS_IOLOCK_EXCL);
+	error = xfs_change_file_space(bdp, XFS_IOC_RESVSP, &bf, 0, NULL,
+							ATTR_NOLOCK);
+	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + len > i_size_read(inode))
+		new_size = offset + len;
+
+	/* Change file size if needed */
+	if (new_size) {
+		bhv_vattr_t	va;
+
+		va.va_mask = XFS_AT_SIZE;
+		va.va_size = new_size;
+		error = bhv_vop_setattr(vp, &va, ATTR_NOLOCK, NULL);
+	}
+
+	xfs_iunlock(xfs_vtoi(vp), XFS_IOLOCK_EXCL);
+	return error;
+}
 
 const struct inode_operations xfs_inode_operations = {
 	.permission		= xfs_vn_permission,
@@ -822,6 +868,7 @@ const struct inode_operations xfs_inode_
 	.getxattr		= xfs_vn_getxattr,
 	.listxattr		= xfs_vn_listxattr,
 	.removexattr		= xfs_vn_removexattr,
+	.fallocate		= xfs_vn_fallocate,
 };
 
 const struct inode_operations xfs_dir_inode_operations = {
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
