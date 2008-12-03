From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 6/6] ext4: tighten restrictions on inode flags
Date: Wed,  3 Dec 2008 19:55:03 +0000
Message-ID: <1228334103-15948-7-git-send-email-duaneg@dghda.com>
References: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
 <1228334103-15948-2-git-send-email-duaneg@dghda.com>
 <1228334103-15948-3-git-send-email-duaneg@dghda.com>
 <1228334103-15948-4-git-send-email-duaneg@dghda.com>
 <1228334103-15948-5-git-send-email-duaneg@dghda.com>
 <1228334103-15948-6-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2874 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbYLCUCK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 15:02:10 -0500
In-Reply-To: <1228334103-15948-6-git-send-email-duaneg@dghda.com>
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
 fs/ext4/ext4.h   |   17 +++++++++++++++++
 fs/ext4/ialloc.c |   14 +++++---------
 fs/ext4/ioctl.c  |    3 +--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 63e5163..7b5c86d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -255,6 +255,23 @@ struct flex_groups {
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
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 6fd3f3c..8efcc5e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -809,16 +809,12 @@ got:
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
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index dc99b47..2af1132 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -48,8 +48,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (err)
 			return err;
 
-		if (!S_ISDIR(inode->i_mode))
-			flags &= ~EXT4_DIRSYNC_FL;
+		flags = ext4_mask_flags(inode->i_mode, flags);
 
 		err = -EPERM;
 		mutex_lock(&inode->i_mutex);
-- 
1.5.6.4

