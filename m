From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
Date: Tue, 22 Jul 2008 18:38:05 +0900
Message-ID: <20080722183805t-sato__32914.6553799093$1216719629$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"viro@ZenIV.linux.org.uk" <vir
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:47256 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYGVJjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 05:39:24 -0400
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

diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26-freeze/fs/xfs/linux-2.6/xfs_ioctl.c linux-2.6.26-xfs/
fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.26-freeze/fs/xfs/linux-2.6/xfs_ioctl.c	2008-07-17 11:29:29.000000000 +0900
+++ linux-2.6.26-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-07-17 11:34:20.000000000 +0900
@@ -1233,21 +1233,6 @@ xfs_ioctl(
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
 
diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c linux-2.6.26-xf
s/fs/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.26-freeze/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-07-17 11:29:29.000000000 +0900
+++ linux-2.6.26-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-07-17 11:34:20.000000000 +0900
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -uprN -X linux-2.6.26.org/Documentation/dontdiff linux-2.6.26-freeze/fs/xfs/xfs_fs.h linux-2.6.26-xfs/fs/xfs/xfs_fs
.h
--- linux-2.6.26-freeze/fs/xfs/xfs_fs.h	2008-07-17 11:29:29.000000000 +0900
+++ linux-2.6.26-xfs/fs/xfs/xfs_fs.h	2008-07-17 11:34:20.000000000 +0900
@@ -473,8 +473,8 @@ typedef struct xfs_handle {
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
