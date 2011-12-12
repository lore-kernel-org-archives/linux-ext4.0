From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Unify inode flags bit and inode flags.
Date: Mon, 12 Dec 2011 09:59:49 +0800
Message-ID: <1323655189-3417-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:58375 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752700Ab1LLCAf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Dec 2011 21:00:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In order to make atomic set/get of inode flags, we create a enum of
different inode flags. Now when we add a new inode flag(e.g inline data),
we have to add both the 'enum' and the 'define' and calculate the value
of 'define' by ourselves. This is a bit boring and error-prune.
So this patch just unify these 2 fields.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h |  108 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5b0e26a..c5a8a8d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -345,33 +345,64 @@ struct flex_groups {
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
+	EXT4_INODE_ECOMPR	= 11,	/* Compression error */
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
+	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
+};
+
+/*
  * Inode flags
  */
-#define	EXT4_SECRM_FL			0x00000001 /* Secure deletion */
-#define	EXT4_UNRM_FL			0x00000002 /* Undelete */
-#define	EXT4_COMPR_FL			0x00000004 /* Compress file */
-#define EXT4_SYNC_FL			0x00000008 /* Synchronous updates */
-#define EXT4_IMMUTABLE_FL		0x00000010 /* Immutable file */
-#define EXT4_APPEND_FL			0x00000020 /* writes to file may only append */
-#define EXT4_NODUMP_FL			0x00000040 /* do not dump file */
-#define EXT4_NOATIME_FL			0x00000080 /* do not update atime */
+#define EXT4_SECRM_FL			(1 << EXT4_INODE_SECRM)
+#define EXT4_UNRM_FL			(1 << EXT4_INODE_UNRM)
+#define EXT4_COMPR_FL			(1 << EXT4_INODE_COMPR)
+#define EXT4_SYNC_FL			(1 << EXT4_INODE_SYNC)
+#define EXT4_IMMUTABLE_FL		(1 << EXT4_INODE_IMMUTABLE)
+#define EXT4_APPEND_FL			(1 << EXT4_INODE_APPEND)
+#define EXT4_NODUMP_FL			(1 << EXT4_INODE_NODUMP)
+#define EXT4_NOATIME_FL			(1 << EXT4_INODE_NOATIME)
 /* Reserved for compression usage... */
-#define EXT4_DIRTY_FL			0x00000100
-#define EXT4_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
-#define EXT4_NOCOMPR_FL			0x00000400 /* Don't compress */
-#define EXT4_ECOMPR_FL			0x00000800 /* Compression error */
+#define EXT4_DIRTY_FL			(1 << EXT4_INODE_DIRTY)
+#define EXT4_COMPRBLK_FL		(1 << EXT4_INODE_COMPRBLK)
+#define EXT4_NOCOMPR_FL			(1 << EXT4_INODE_NOCOMPR)
+#define EXT4_ECOMPR_FL			(1 << EXT4_INODE_ECOMPR)
 /* End compression flags --- maybe not all used */
-#define EXT4_INDEX_FL			0x00001000 /* hash-indexed directory */
-#define EXT4_IMAGIC_FL			0x00002000 /* AFS directory */
-#define EXT4_JOURNAL_DATA_FL		0x00004000 /* file data should be journaled */
-#define EXT4_NOTAIL_FL			0x00008000 /* file tail should not be merged */
-#define EXT4_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
-#define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
-#define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
-#define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
-#define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
-#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
-#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
+#define EXT4_INDEX_FL			(1 << EXT4_INODE_INDEX)
+#define EXT4_IMAGIC_FL			(1 << EXT4_INODE_IMAGIC)
+#define EXT4_JOURNAL_DATA_FL		(1 << EXT4_INODE_JOURNAL_DATA)
+#define EXT4_NOTAIL_FL			(1 << EXT4_INODE_NOTAIL)
+#define EXT4_DIRSYNC_FL			(1 << EXT4_INODE_DIRSYNC)
+#define EXT4_TOPDIR_FL			(1 << EXT4_INODE_TOPDIR)
+#define EXT4_HUGE_FILE_FL               (1 << EXT4_INODE_HUGE_FILE)
+#define EXT4_EXTENTS_FL			(1 << EXT4_INODE_EXTENTS)
+#define EXT4_EA_INODE_FL	        (1 << EXT4_INODE_EA_INODE)
+#define EXT4_EOFBLOCKS_FL		(1 << EXT4_INODE_EOFBLOCKS)
+#define EXT4_RESERVED_FL		(1 << EXT4_INODE_RESERVED)
 
 #define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
@@ -399,37 +430,6 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 		return flags & EXT4_OTHER_FLMASK;
 }
 
-/*
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
-	EXT4_INODE_ECOMPR	= 11,	/* Compression error */
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
-	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
-};
