From: akpm@linux-foundation.org
Subject: + ext3-tighten-restrictions-on-inode-flags.patch added to -mm tree
Date: Sat, 06 Dec 2008 22:18:24 -0800
Message-ID: <200812070618.mB76IOMx017095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: tighten restrictions on inode flags
has been added to the -mm tree.  Its filename is
     ext3-tighten-restrictions-on-inode-flags.patch

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

ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext2-tighten-restrictions-on-inode-flags.patch
ext3-tighten-restrictions-on-inode-flags.patch
ext4-tighten-restrictions-on-inode-flags.patch

