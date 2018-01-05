From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 1/3] ext4: move inode flags enum in preparation for cleanup
Date: Fri,  5 Jan 2018 01:23:23 -0800
Message-ID: <e6d7cc1aa972524d489e053ac50e3e037b4742ce.1515135646.git.tgnottingham@gmail.com>
References: <cover.1515135646.git.tgnottingham@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38855 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbeAEJYH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jan 2018 04:24:07 -0500
Received: by mail-pg0-f68.google.com with SMTP id t67so1805072pgc.5
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jan 2018 01:24:07 -0800 (PST)
In-Reply-To: <cover.1515135646.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1515135646.git.tgnottingham@gmail.com>
References: <cover.1515135646.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---

This is just a code move to make the next patch diff cleaner.

---
 fs/ext4/ext4.h | 66 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e091ea..33b3cac 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -369,6 +369,39 @@ struct flex_groups {
 #define	EXT4_N_BLOCKS			(EXT4_TIND_BLOCK + 1)
 
 /*
+ * Inode flags used for atomic set/get
+ */
+enum {
+	EXT4_INODE_SECRM	= 0,	/* Secure deletion */
+	EXT4_INODE_UNRM		= 1,	/* Undelete */
+	EXT4_INODE_COMPR	= 2,	/* Compress file */
+	EXT4_INODE_SYNC		= 3,	/* Synchronous updates */
+	EXT4_INODE_IMMUTABLE	= 4,	/* Immutable file */
+	EXT4_INODE_APPEND	= 5,	/* writes to file may only append */
+	EXT4_INODE_NODUMP	= 6,	/* do not dump file */
+	EXT4_INODE_NOATIME	= 7,	/* do not update atime */
+/* Reserved for compression usage... */
+	EXT4_INODE_DIRTY	= 8,
+	EXT4_INODE_COMPRBLK	= 9,	/* One or more compressed clusters */
+	EXT4_INODE_NOCOMPR	= 10,	/* Don't compress */
+	EXT4_INODE_ENCRYPT	= 11,	/* Encrypted file */
+/* End compression flags --- maybe not all used */
+	EXT4_INODE_INDEX	= 12,	/* hash-indexed directory */
+	EXT4_INODE_IMAGIC	= 13,	/* AFS directory */
+	EXT4_INODE_JOURNAL_DATA	= 14,	/* file data should be journaled */
+	EXT4_INODE_NOTAIL	= 15,	/* file tail should not be merged */
+	EXT4_INODE_DIRSYNC	= 16,	/* dirsync behaviour (directories only) */
+	EXT4_INODE_TOPDIR	= 17,	/* Top of directory hierarchies*/
+	EXT4_INODE_HUGE_FILE	= 18,	/* Set to each huge file */
+	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
+	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
+	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
+	EXT4_INODE_INLINE_DATA	= 28,	/* Data in inode. */
+	EXT4_INODE_PROJINHERIT	= 29,	/* Create with parents projid */
+	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
+};
+
+/*
  * Inode flags
  */
 #define	EXT4_SECRM_FL			0x00000001 /* Secure deletion */
@@ -436,39 +469,6 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 }
 
 /*
- * Inode flags used for atomic set/get
- */
-enum {
-	EXT4_INODE_SECRM	= 0,	/* Secure deletion */
-	EXT4_INODE_UNRM		= 1,	/* Undelete */
-	EXT4_INODE_COMPR	= 2,	/* Compress file */
-	EXT4_INODE_SYNC		= 3,	/* Synchronous updates */
-	EXT4_INODE_IMMUTABLE	= 4,	/* Immutable file */
-	EXT4_INODE_APPEND	= 5,	/* writes to file may only append */
-	EXT4_INODE_NODUMP	= 6,	/* do not dump file */
-	EXT4_INODE_NOATIME	= 7,	/* do not update atime */
-/* Reserved for compression usage... */
-	EXT4_INODE_DIRTY	= 8,
-	EXT4_INODE_COMPRBLK	= 9,	/* One or more compressed clusters */
-	EXT4_INODE_NOCOMPR	= 10,	/* Don't compress */
-	EXT4_INODE_ENCRYPT	= 11,	/* Encrypted file */
-/* End compression flags --- maybe not all used */
-	EXT4_INODE_INDEX	= 12,	/* hash-indexed directory */
-	EXT4_INODE_IMAGIC	= 13,	/* AFS directory */
-	EXT4_INODE_JOURNAL_DATA	= 14,	/* file data should be journaled */
-	EXT4_INODE_NOTAIL	= 15,	/* file tail should not be merged */
-	EXT4_INODE_DIRSYNC	= 16,	/* dirsync behaviour (directories only) */
-	EXT4_INODE_TOPDIR	= 17,	/* Top of directory hierarchies*/
-	EXT4_INODE_HUGE_FILE	= 18,	/* Set to each huge file */
-	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
-	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
-	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
-	EXT4_INODE_INLINE_DATA	= 28,	/* Data in inode. */
-	EXT4_INODE_PROJINHERIT	= 29,	/* Create with parents projid */
-	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
-};
