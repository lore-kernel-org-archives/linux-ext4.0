From: akpm@linux-foundation.org
Subject: + filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:15:57 -0700
Message-ID: <200810280615.m9S6FvYh020124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: t-sato@yk.jp.nec.com, agk@redhat.com, david@fromorbit.com,
	dgc@sgi.com, hch@lst.de, linux-ext4@vger.kernel.org,
	shaggy@austin.ibm.com, viro@zeniv.linux.org.uk,
	xfs-masters@oss.sgi.com
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     filesystem freeze: remove XFS specific ioctl interfaces for freeze feature
has been added to the -mm tree.  Its filename is
     filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: filesystem freeze: remove XFS specific ioctl interfaces for freeze feature
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
 
diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/linux-2.6/xfs_ioctl32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -398,8 +398,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
 	case XFS_IOC_FSGROWFSRT:
-	case XFS_IOC_FREEZE:
-	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
diff -puN fs/xfs/xfs_fs.h~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature fs/xfs/xfs_fs.h
--- a/fs/xfs/xfs_fs.h~filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature
+++ a/fs/xfs/xfs_fs.h
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
_

Patches currently in -mm which might be from t-sato@yk.jp.nec.com are

filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

