From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 3/3] Remove XFS specific ioctl interfaces for freeze feature
Date: Mon, 27 Oct 2008 21:59:13 +0900
Message-ID: <20081027215913t-sato__2663.94171999327$1225112503$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40205 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYJ0M7v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 08:59:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It removes XFS specific ioctl interfaces and request codes
for freeze feature.
This patch has been supplied by David Chinner.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |   15 ---------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |    2 --
 fs/xfs/xfs_fs.h                |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -uprN -X linux-2.6.28-rc2-freeze/Documentation/dontdiff linux-2.6.28-rc2-freeze/fs/xfs/linux-2.6/xfs_ioctl.c linux-
2.6.28-rc2-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.28-rc2-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-27 10:10:24.000000000 +0900
+++ linux-2.6.28-rc2-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-27 10:19:00.000000000 +0900
@@ -1528,21 +1528,6 @@ xfs_ioctl(
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
 
diff -uprN -X linux-2.6.28-rc2-freeze/Documentation/dontdiff linux-2.6.28-rc2-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c linu
x-2.6.28-rc2-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.28-rc2-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-10-27 10:10:24.000000000 +0900
+++ linux-2.6.28-rc2-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-10-27 10:19:00.000000000 +0900
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -uprN -X linux-2.6.28-rc2-freeze/Documentation/dontdiff linux-2.6.28-rc2-freeze/fs/xfs/xfs_fs.h linux-2.6.28-rc2-xf
s/fs/xfs/xfs_fs.h
--- linux-2.6.28-rc2-freeze/fs/xfs/xfs_fs.h	2008-10-27 10:10:24.000000000 +0900
+++ linux-2.6.28-rc2-xfs/fs/xfs/xfs_fs.h	2008-10-27 10:19:00.000000000 +0900
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
