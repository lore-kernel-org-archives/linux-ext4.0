From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 9/10] Remove XFS specific ioctl interfaces for freeze feature
Date: Mon, 22 Sep 2008 19:58:18 +0900
Message-ID: <20080922195819t-sato__30473.9611027346$1222081240$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37724 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYIVK6c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 06:58:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It removes XFS specific ioctl interfaces and request codes
for freeze feature.
This patch has been supplied by David Chinner.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 linux-2.6/xfs_ioctl.c   |   15 ---------------
 linux-2.6/xfs_ioctl32.c |    2 --
 xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl.c linux-
2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-22 14:19:19.000000000 +0900
@@ -1529,21 +1529,6 @@ xfs_ioctl(
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
 
diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c linu
x-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.27-rc7-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-09-22 14:19:19.000000000 +0900
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -uprN -X linux-2.6.27-rc7-freeze/Documentation/dontdiff linux-2.6.27-rc7-freeze/fs/xfs/xfs_fs.h linux-2.6.27-rc7-xf
s/fs/xfs/xfs_fs.h
--- linux-2.6.27-rc7-freeze/fs/xfs/xfs_fs.h	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-xfs/fs/xfs/xfs_fs.h	2008-09-22 14:19:19.000000000 +0900
@@ -477,8 +477,8 @@ typedef struct xfs_handle {
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
