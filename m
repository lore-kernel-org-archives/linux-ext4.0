From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 6/6] ext4: tighten restrictions on inode flags
Date: Wed, 11 Jun 2008 01:04:09 +0100
Message-ID: <1213142649-32685-7-git-send-email-duaneg@dghda.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3344 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbYFKAEX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 20:04:23 -0400
In-Reply-To: <1213142649-32685-6-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the moment there are few restrictions on which flags may be set on which
inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
and APPEND may not be set on links. Tighten that to disallow TOPDIR being
set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
NOCOMPR, ECOMPR, INDEX, JOURNAL_DATA, NOTAIL, HUGE_FILE, EXTENTS or
EXT_MIGRATE being set on anything but regular files or directories.

Introduce a flags masking function which masks flags based on mode and use
it during inode creation and when flags are set via the ioctl to facilitate
future consistency.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

The specific flags masked out here are those suggested by Andreas, as well
as IMMUTABLE, which I included to match the behaviour of the existing code,
and EXT_MIGRATE.

It would be good to get some review of these.

---
 fs/ext4/ext4.h   |   24 ++++++++++++++++++++++++
 fs/ext4/ialloc.c |   14 +++++---------
 fs/ext4/ioctl.c  |    3 +--
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1a4faa5..2aafd1b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -243,6 +243,30 @@ struct ext4_group_desc
 			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL|\
 			   EXT4_DIRSYNC_FL)
 
+/* Flags that are inappropriate for regular files. */
+#define EXT4_REG_FLMASK (EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL)
+
+/* Flags that are inappropriate for non-directories/regular files. */
+#define EXT4_OTHER_FLMASK (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
+			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
+			   EXT4_DIRTY_FL | EXT4_COMPRBLK_FL | EXT4_NOCOMPR_FL|\
+			   EXT4_ECOMPR_FL | EXT4_INDEX_FL |\
+			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL |\
+			   EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL |\
+			   EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL |\
+			   EXT4_EXT_MIGRATE)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __le32 ext4_mask_flags(__le16 mode, __le32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & ~EXT4_REG_FLMASK;
+	else
+		return flags & ~EXT4_OTHER_FLMASK;
+}
+
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ff25d57..11fb561 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -698,16 +698,12 @@ got:
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
 	ei->i_block_alloc_info = NULL;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 7a6c2f1..ba0df2b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -49,8 +49,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (err)
 			return err;
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT4_DIRSYNC_FL;
+		flags = ext4_mask_flags(inode->i_mode, flags);
 
 		err = -EPERM;
 		mutex_lock(&inode->i_mutex);
-- 
1.5.3.7

