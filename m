From: akpm@linux-foundation.org
Subject: - ext3-tighten-restrictions-on-inode-flags.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:06 -0800
Message-ID: <200901082247.n08Ml6tm026586@imap1.linux-foundation.org>
To: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759776AbZAHWrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 17:47:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: tighten restrictions on inode flags
has been removed from the -mm tree.  Its filename was
     ext3-tighten-restrictions-on-inode-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: tighten restrictions on inode flags
From: "Duane Griffin" <duaneg@dghda.com>

At the moment there are few restrictions on which flags may be set on
which inodes.  Specifically DIRSYNC may only be set on directories and
IMMUTABLE and APPEND may not be set on links.  Tighten that to disallow
TOPDIR being set on non-directories and only NODUMP and NOATIME to be set
on non-regular file, non-directories.

Introduces a flags masking function which masks flags based on mode and
use it during inode creation and when flags are set via the ioctl to
facilitate future consistency.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |    8 ++------
 fs/ext3/ioctl.c         |    3 +--
 include/linux/ext3_fs.h |   17 +++++++++++++++++
 3 files changed, 20 insertions(+), 8 deletions(-)

diff -puN fs/ext3/ialloc.c~ext3-tighten-restrictions-on-inode-flags fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-tighten-restrictions-on-inode-flags
+++ a/fs/ext3/ialloc.c
@@ -559,12 +559,8 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	ei->i_flags = EXT3_I(dir)->i_flags & EXT3_FL_INHERITED;
-	if (S_ISLNK(mode))
-		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
-	/* dirsync only applies to directories */
-	if (!S_ISDIR(mode))
-		ei->i_flags &= ~EXT3_DIRSYNC_FL;
+	ei->i_flags =
+		ext3_mask_flags(mode, EXT3_I(dir)->i_flags & EXT3_FL_INHERITED);
 #ifdef EXT3_FRAGMENTS
 	ei->i_faddr = 0;
 	ei->i_frag_no = 0;
diff -puN fs/ext3/ioctl.c~ext3-tighten-restrictions-on-inode-flags fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~ext3-tighten-restrictions-on-inode-flags
+++ a/fs/ext3/ioctl.c
@@ -53,8 +53,7 @@ int ext3_ioctl (struct inode * inode, st
 			goto flags_out;
 		}
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT3_DIRSYNC_FL;
+		flags = ext3_mask_flags(inode->i_mode, flags);
 
 		mutex_lock(&inode->i_mutex);
 		/* Is it quota file? Do not allow user to mess with it */
diff -puN include/linux/ext3_fs.h~ext3-tighten-restrictions-on-inode-flags include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-tighten-restrictions-on-inode-flags
+++ a/include/linux/ext3_fs.h
@@ -185,6 +185,23 @@ struct ext3_group_desc
 			   EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
 			   EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
 
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define EXT3_REG_FLMASK (~(EXT3_DIRSYNC_FL | EXT3_TOPDIR_FL))
+
+/* Flags that are appropriate for non-directories/regular files. */
+#define EXT3_OTHER_FLMASK (EXT3_NODUMP_FL | EXT3_NOATIME_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __u32 ext3_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & EXT3_REG_FLMASK;
+	else
+		return flags & EXT3_OTHER_FLMASK;
+}
+
 /*
  * Inode dynamic state flags
  */
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch

