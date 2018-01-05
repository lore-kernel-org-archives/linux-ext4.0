From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 3/3] ext4: define visible/modifiable flag masks in terms of inode flags
Date: Fri,  5 Jan 2018 01:23:25 -0800
Message-ID: <72549a0cca1ccc4097deb19899aa9756f0397aa2.1515135646.git.tgnottingham@gmail.com>
References: <cover.1515135646.git.tgnottingham@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35832 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbeAEJYK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jan 2018 04:24:10 -0500
Received: by mail-pl0-f67.google.com with SMTP id b96so2765618pli.2
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jan 2018 01:24:10 -0800 (PST)
In-Reply-To: <cover.1515135646.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1515135646.git.tgnottingham@gmail.com>
References: <cover.1515135646.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Define visible and modifiable inode flag masks in terms of inode flags
instead of hexadecimal to make it clearer which flags are included.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---

I printed and diffed the flag values before and after to verify they match.

---
 fs/ext4/ext4.h | 73 ++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6fd2698..9fe70ab 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -431,23 +431,66 @@ enum {
 #define EXT4_PROJINHERIT_FL	BIT(EXT4_INODE_PROJINHERIT)	/* Create with parents projid */
 #define EXT4_RESERVED_FL	BIT(EXT4_INODE_RESERVED)	/* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
-
-/* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
-#define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
-					 EXT4_IMMUTABLE_FL | \
-					 EXT4_APPEND_FL | \
-					 EXT4_NODUMP_FL | \
-					 EXT4_NOATIME_FL | \
-					 EXT4_PROJINHERIT_FL)
+/* Flags we can manipulate through EXT4_IOC_GETFLAGS */
+#define EXT4_FL_USER_VISIBLE	(EXT4_SECRM_FL | \
+				 EXT4_UNRM_FL | \
+				 EXT4_COMPR_FL | \
+				 EXT4_SYNC_FL | \
+				 EXT4_IMMUTABLE_FL | \
+				 EXT4_APPEND_FL | \
+				 EXT4_NODUMP_FL | \
+				 EXT4_NOATIME_FL | \
+				 EXT4_DIRTY_FL | \
+				 EXT4_COMPRBLK_FL | \
+				 EXT4_NOCOMPR_FL | \
+				 EXT4_ENCRYPT_FL | \
+				 EXT4_INDEX_FL | \
+				 EXT4_JOURNAL_DATA_FL | \
+				 EXT4_NOTAIL_FL | \
+				 EXT4_DIRSYNC_FL | \
+				 EXT4_TOPDIR_FL | \
+				 EXT4_EXTENTS_FL | \
+				 EXT4_EOFBLOCKS_FL | \
+				 EXT4_INLINE_DATA_FL | \
+				 EXT4_PROJINHERIT_FL)
+
+/* Flags we can manipulate through EXT4_IOC_SETFLAGS */
+#define EXT4_FL_USER_MODIFIABLE	(EXT4_SECRM_FL | \
+				 EXT4_UNRM_FL | \
+				 EXT4_COMPR_FL | \
+				 EXT4_SYNC_FL | \
+				 EXT4_IMMUTABLE_FL | \
+				 EXT4_APPEND_FL | \
+				 EXT4_NODUMP_FL | \
+				 EXT4_NOATIME_FL | \
+				 EXT4_JOURNAL_DATA_FL | \
+				 EXT4_NOTAIL_FL | \
+				 EXT4_DIRSYNC_FL | \
+				 EXT4_TOPDIR_FL | \
+				 EXT4_EXTENTS_FL | \
+				 EXT4_EOFBLOCKS_FL | \
+				 EXT4_PROJINHERIT_FL)
+
+/* Flags we can manipulate through EXT4_IOC_FSSETXATTR */
+#define EXT4_FL_XFLAG_VISIBLE	(EXT4_SYNC_FL | \
+				 EXT4_IMMUTABLE_FL | \
+				 EXT4_APPEND_FL | \
+				 EXT4_NODUMP_FL | \
+				 EXT4_NOATIME_FL | \
+				 EXT4_PROJINHERIT_FL)
 
 /* Flags that should be inherited by new inodes from their parent. */
-#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
-			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
-			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
-			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
-			   EXT4_PROJINHERIT_FL)
+#define EXT4_FL_INHERITED	(EXT4_SECRM_FL | \
+				 EXT4_UNRM_FL | \
+				 EXT4_COMPR_FL | \
+				 EXT4_SYNC_FL | \
+				 EXT4_NODUMP_FL | \
+				 EXT4_NOATIME_FL | \
+				 EXT4_NOCOMPR_FL | \
+				 EXT4_JOURNAL_DATA_FL | \
+				 EXT4_NOTAIL_FL | \
+				 EXT4_DIRSYNC_FL | \
+				 EXT4_PROJINHERIT_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
-- 
2.7.4
