From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 5/6] ext3: tighten restrictions on inode flags
Date: Wed, 11 Jun 2008 01:04:08 +0100
Message-ID: <1213142649-32685-6-git-send-email-duaneg@dghda.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3335 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830AbYFKAEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 20:04:21 -0400
In-Reply-To: <1213142649-32685-5-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the moment there are few restrictions on which flags may be set on which
inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
and APPEND may not be set on links. Tighten that to disallow TOPDIR being
set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
NOCOMPR, ECOMPR, INDEX, JOURNAL_DATA and NOTAIL being set on anything but
regular files or directories.

Introduce a flags masking function which masks flags based on mode and use
it during inode creation and when flags are set via the ioctl to facilitate
future consistency.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

The specific flags masked out here are those suggested by Andreas, as well
as IMMUTABLE, which I included to match the behaviour of the existing code.

It would be good to get some review of these.

---
 fs/ext3/ialloc.c        |    8 ++------
 fs/ext3/ioctl.c         |    3 +--
 include/linux/ext3_fs.h |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 1d9fe3f..c72d49d 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
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
diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 0d0c701..6d6534d 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -53,8 +53,7 @@ int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 			goto flags_out;
 		}
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT3_DIRSYNC_FL;
+		flags = ext3_mask_flags(inode->i_mode, flags);
 
 		mutex_lock(&inode->i_mutex);
 		/* Is it quota file? Do not allow user to mess with it */
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 140190d..c22e1c1 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -185,6 +185,28 @@ struct ext3_group_desc
 			   EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
 			   EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
 
+/* Flags that are inappropriate for regular files. */
+#define EXT3_REG_FLMASK (EXT3_DIRSYNC_FL | EXT3_TOPDIR_FL)
+
+/* Flags that are inappropriate for non-directories/regular files. */
+#define EXT3_OTHER_FLMASK (EXT3_SECRM_FL | EXT3_UNRM_FL | EXT3_COMPR_FL |\
+			   EXT3_SYNC_FL | EXT3_IMMUTABLE_FL | EXT3_APPEND_FL |\
+			   EXT3_DIRTY_FL | EXT3_COMPRBLK_FL | EXT3_NOCOMPR_FL|\
+			   EXT3_ECOMPR_FL | EXT3_INDEX_FL |\
+			   EXT3_JOURNAL_DATA_FL | EXT3_NOTAIL_FL |\
+			   EXT3_DIRSYNC_FL | EXT3_TOPDIR_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __le32 ext3_mask_flags(__le16 mode, __le32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & ~EXT3_REG_FLMASK;
+	else
+		return flags & ~EXT3_OTHER_FLMASK;
+}
+
 /*
  * Inode dynamic state flags
  */
-- 
1.5.3.7

