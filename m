From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 4/6] ext2: tighten restrictions on inode flags
Date: Wed,  3 Dec 2008 19:55:01 +0000
Message-ID: <1228334103-15948-5-git-send-email-duaneg@dghda.com>
References: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
 <1228334103-15948-2-git-send-email-duaneg@dghda.com>
 <1228334103-15948-3-git-send-email-duaneg@dghda.com>
 <1228334103-15948-4-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2870 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbYLCUCE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 15:02:04 -0500
In-Reply-To: <1228334103-15948-4-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the moment there are few restrictions on which flags may be set on
which inodes. Specifically DIRSYNC may only be set on directories and
IMMUTABLE and APPEND may not be set on links. Tighten that to disallow
TOPDIR being set on non-directories and only NODUMP and NOATIME to be
set on non-regular file, non-directories.

Introduces a flags masking function which masks flags based on mode and
use it during inode creation and when flags are set via the ioctl to
facilitate future consistency.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ext2/ialloc.c        |    8 ++------
 fs/ext2/ioctl.c         |    3 +--
 include/linux/ext2_fs.h |   17 +++++++++++++++++
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 8c1897e..bee9709 100644
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
index c3a0518..121720d 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
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
-- 
1.5.6.4

