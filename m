From: akpm@linux-foundation.org
Subject: [patch 3/3] ext4: tighten restrictions on inode flags
Date: Fri, 09 Jan 2009 12:24:54 -0800
Message-ID: <200901092024.n09KOtOA021740@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	duaneg@dghda.com, adilger@sun.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbZAIUZV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jan 2009 15:25:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

 fs/ext4/ext4.h   |   17 +++++++++++++++++
 fs/ext4/ialloc.c |   14 +++++---------
 fs/ext4/ioctl.c  |    3 +--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-tighten-restrictions-on-inode-flags fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-tighten-restrictions-on-inode-flags
+++ a/fs/ext4/ext4.h
@@ -256,6 +256,23 @@ struct flex_groups {
 			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL|\
 			   EXT4_DIRSYNC_FL)
 
+/* Flags that are appropriate for regular files (all but dir-specific ones). */
+#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
+
+/* Flags that are appropriate for non-directories/regular files. */
+#define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & EXT4_REG_FLMASK;
+	else
+		return flags & EXT4_OTHER_FLMASK;
+}
+
 /*
  * Inode dynamic state flags
  */
diff -puN fs/ext4/ialloc.c~ext4-tighten-restrictions-on-inode-flags fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~ext4-tighten-restrictions-on-inode-flags
+++ a/fs/ext4/ialloc.c
@@ -874,16 +874,12 @@ got:
 	ei->i_disksize = 0;
 
 	/*
-	 * Don't inherit extent flag from directory. We set extent flag on
-	 * newly created directory and file only if -o extent mount option is
-	 * specified
+	 * Don't inherit extent flag from directory, amongst others. We set
+	 * extent flag on newly created directory and file only if -o extent
+	 * mount option is specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
-	if (S_ISLNK(mode))
-		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
-	/* dirsync only applies to directories */
-	if (!S_ISDIR(mode))
-		ei->i_flags &= ~EXT4_DIRSYNC_FL;
+	ei->i_flags =
+		ext4_mask_flags(mode, EXT4_I(dir)->i_flags & EXT4_FL_INHERITED);
 	ei->i_file_acl = 0;
 	ei->i_dtime = 0;
 	ei->i_block_group = group;
diff -puN fs/ext4/ioctl.c~ext4-tighten-restrictions-on-inode-flags fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~ext4-tighten-restrictions-on-inode-flags
+++ a/fs/ext4/ioctl.c
@@ -48,8 +48,7 @@ long ext4_ioctl(struct file *filp, unsig
 		if (err)
 			return err;
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT4_DIRSYNC_FL;
+		flags = ext4_mask_flags(inode->i_mode, flags);
 
 		err = -EPERM;
 		mutex_lock(&inode->i_mutex);
_
