From: akpm@linux-foundation.org
Subject: [patch 7/8] filesystem freeze: remove XFS specific ioctl interfaces for freeze feature
Date: Fri, 09 Jan 2009 16:41:00 -0800
Message-ID: <200901100041.n0A0f06e013797@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, t-sato@yk.jp.nec.com, agk@redhat.com,
	david@fromorbit.com, dgc@sgi.com, hch@lst.de,
	linux-ext4@vger.kernel.org, shaggy@austin.ibm.com,
	viro@zeniv.linux.org.uk, xfs-masters@oss.sgi.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbZAJAmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jan 2009 19:42:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Takashi Sato <t-sato@yk.jp.nec.com>

It removes XFS specific ioctl interfaces and request codes
for freeze feature.

This patch has been supplied by David Chinner.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: <xfs-masters@oss.sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl.c   |   15 ---------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |    2 --
 fs/xfs/xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1546,21 +1546,6 @@ xfs_file_ioctl(
 		return -error;
 	}
 
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
 	case XFS_IOC_GOINGDOWN: {
 		__uint32_t in;
 
diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/linux-2.6/xfs_ioctl32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -632,8 +632,6 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
 	case XFS_IOC_FSGROWFSLOG:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -puN fs/xfs/xfs_fs.h~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/xfs_fs.h
--- a/fs/xfs/xfs_fs.h~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/xfs_fs.h
@@ -465,8 +465,8 @@ typedef struct xfs_handle {
 #define XFS_IOC_ERROR_INJECTION	     _IOW ('X', 116, struct xfs_error_injection)
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
-#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
-#define XFS_IOC_THAW		     _IOWR('X', 120, int)
+/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
+/*	XFS_IOC_THAW		  -- FITHAW     120	 */
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
_
