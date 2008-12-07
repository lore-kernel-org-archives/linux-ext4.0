From: akpm@linux-foundation.org
Subject: + ext2-tighten-restrictions-on-inode-flags.patch added to -mm tree
Date: Sat, 06 Dec 2008 22:18:22 -0800
Message-ID: <200812070618.mB76IMiU017089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: tighten restrictions on inode flags
has been added to the -mm tree.  Its filename is
     ext2-tighten-restrictions-on-inode-flags.patch

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
Subject: ext2: tighten restrictions on inode flags
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

 fs/ext2/ialloc.c        |    8 ++------
 fs/ext2/ioctl.c         |    3 +--
 include/linux/ext2_fs.h |   17 +++++++++++++++++
 3 files changed, 20 insertions(+), 8 deletions(-)

diff -puN fs/ext2/ialloc.c~ext2-tighten-restrictions-on-inode-flags fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c~ext2-tighten-restrictions-on-inode-flags
+++ a/fs/ext2/ialloc.c
@@ -565,12 +565,8 @@ got:
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	memset(ei->i_data, 0, sizeof(ei->i_data));
-	ei->i_flags = EXT2_I(dir)->i_flags & EXT2_FL_INHERITED;
-	if (S_ISLNK(mode))
-		ei->i_flags &= ~(EXT2_IMMUTABLE_FL|EXT2_APPEND_FL);
-	/* dirsync is only applied to directories */
-	if (!S_ISDIR(mode))
-		ei->i_flags &= ~EXT2_DIRSYNC_FL;
+	ei->i_flags =
+		ext2_mask_flags(mode, EXT2_I(dir)->i_flags & EXT2_FL_INHERITED);
 	ei->i_faddr = 0;
 	ei->i_frag_no = 0;
 	ei->i_frag_size = 0;
diff -puN fs/ext2/ioctl.c~ext2-tighten-restrictions-on-inode-flags fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~ext2-tighten-restrictions-on-inode-flags
+++ a/fs/ext2/ioctl.c
@@ -50,8 +50,7 @@ long ext2_ioctl(struct file *filp, unsig
 			goto setflags_out;
 		}
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT2_DIRSYNC_FL;
+		flags = ext2_mask_flags(inode->i_mode, flags);
 
 		mutex_lock(&inode->i_mutex);
 		/* Is it quota file? Do not allow user to mess with it */
diff -puN include/linux/ext2_fs.h~ext2-tighten-restrictions-on-inode-flags include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~ext2-tighten-restrictions-on-inode-flags
+++ a/include/linux/ext2_fs.h
@@ -201,6 +201,23 @@ struct ext2_group_desc
 			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
 			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
 
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define EXT2_REG_FLMASK (~(EXT2_DIRSYNC_FL | EXT2_TOPDIR_FL))
+
+/* Flags that are appropriate for non-directories/regular files. */
+#define EXT2_OTHER_FLMASK (EXT2_NODUMP_FL | EXT2_NOATIME_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __u32 ext2_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & EXT2_REG_FLMASK;
+	else
+		return flags & EXT2_OTHER_FLMASK;
+}
+
 /*
  * ioctl commands
  */
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext2-tighten-restrictions-on-inode-flags.patch
ext3-tighten-restrictions-on-inode-flags.patch
ext4-tighten-restrictions-on-inode-flags.patch

