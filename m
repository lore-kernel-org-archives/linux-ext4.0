From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 4/6] ext2: tighten restrictions on inode flags
Date: Wed, 11 Jun 2008 01:04:07 +0100
Message-ID: <1213142649-32685-5-git-send-email-duaneg@dghda.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3331 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612AbYFKAEU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 20:04:20 -0400
In-Reply-To: <1213142649-32685-4-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the moment there are few restrictions on which flags may be set on which
inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
and APPEND may not be set on links. Tighten that to disallow TOPDIR being
set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
NOCOMP, ECOMPR, INDEX, JOURNAL_DATA and NOTAIL being set on anything but
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
 fs/ext2/ialloc.c        |    8 ++------
 fs/ext2/ioctl.c         |    3 +--
 include/linux/ext2_fs.h |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index a51d4ca..1559b8e 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
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
diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index de876fa..7cb4bad 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -50,8 +50,7 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto setflags_out;
 		}
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT2_DIRSYNC_FL;
+		flags = ext2_mask_flags(inode->i_mode, flags);
 
 		mutex_lock(&inode->i_mutex);
 		/* Is it quota file? Do not allow user to mess with it */
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 7ead7eb..48a6cc1 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -201,6 +201,28 @@ struct ext2_group_desc
 			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
 			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
 
+/* Flags that are inappropriate for regular files. */
+#define EXT2_REG_FLMASK (EXT2_DIRSYNC_FL | EXT2_TOPDIR_FL)
+
+/* Flags that are inappropriate for non-directories/regular files. */
+#define EXT2_OTHER_FLMASK (EXT2_SECRM_FL | EXT2_UNRM_FL | EXT2_COMPR_FL |\
+			   EXT2_SYNC_FL | EXT2_IMMUTABLE_FL | EXT2_APPEND_FL |\
+			   EXT2_DIRTY_FL | EXT2_COMPRBLK_FL | EXT2_NOCOMP_FL |\
+			   EXT2_ECOMPR_FL | EXT2_INDEX_FL |\
+			   EXT2_JOURNAL_DATA_FL | EXT2_NOTAIL_FL |\
+			   EXT2_DIRSYNC_FL | EXT2_TOPDIR_FL)
+
+/* Mask out flags that are inappropriate for the given type of inode. */
+static inline __le32 ext2_mask_flags(__le16 mode, __le32 flags)
+{
+	if (S_ISDIR(mode))
+		return flags;
+	else if (S_ISREG(mode))
+		return flags & ~EXT2_REG_FLMASK;
+	else
+		return flags & ~EXT2_OTHER_FLMASK;
+}
+
 /*
  * ioctl commands
  */
-- 
1.5.3.7

