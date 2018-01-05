From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 2/3] ext4: define inode flags in terms of enum values
Date: Fri,  5 Jan 2018 01:23:24 -0800
Message-ID: <0862d7a86a1c651ff0bc73f3ff8fd4959e43daea.1515135646.git.tgnottingham@gmail.com>
References: <cover.1515135646.git.tgnottingham@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38856 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbeAEJYJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jan 2018 04:24:09 -0500
Received: by mail-pg0-f68.google.com with SMTP id t67so1805088pgc.5
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jan 2018 01:24:09 -0800 (PST)
In-Reply-To: <cover.1515135646.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1515135646.git.tgnottingham@gmail.com>
References: <cover.1515135646.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Define inode flag bit masks in terms of inode flag enum values to make
relationship between them clearer. Also, make the masks unsigned longs
instead of ints (as a consequence of the way they are now defined).

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---

This change introduces some long lines. It's debatable whether or not they
improve readability over shorter lines with flag definitions and comments
interleaved, or over removing the comments, since they are duplicated in
the other inode flag enumeration. I'd be happy to change it if desired.

The build time flag consistency check has been removed since it has already
shown the enums and flags to be consistent, and the flag definitions are very
difficult to get wrong now. It also means an extra list doesn't need to be
maintained. I can add it back if we're ultra paranoid.

I think the change to unsigned longs should be okay unless the flags are being
used perversely. I checked all uses and didn't see anything unusual. I also ran
the xfstests smoke test without issue (other than failure of generic/472, but
that is failing for me without this patch, too).

---
 fs/ext4/ext4.h  | 103 +++++++++++++++-----------------------------------------
 fs/ext4/super.c |   3 --
 2 files changed, 28 insertions(+), 78 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 33b3cac..6fd2698 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -36,6 +36,7 @@
 #include <crypto/hash.h>
 #include <linux/falloc.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/bitops.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
@@ -402,36 +403,33 @@ enum {
 };
 
 /*
- * Inode flags
- */
-#define	EXT4_SECRM_FL			0x00000001 /* Secure deletion */
-#define	EXT4_UNRM_FL			0x00000002 /* Undelete */
-#define	EXT4_COMPR_FL			0x00000004 /* Compress file */
-#define EXT4_SYNC_FL			0x00000008 /* Synchronous updates */
-#define EXT4_IMMUTABLE_FL		0x00000010 /* Immutable file */
-#define EXT4_APPEND_FL			0x00000020 /* writes to file may only append */
-#define EXT4_NODUMP_FL			0x00000040 /* do not dump file */
-#define EXT4_NOATIME_FL			0x00000080 /* do not update atime */
-/* Reserved for compression usage... */
-#define EXT4_DIRTY_FL			0x00000100
-#define EXT4_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
-#define EXT4_NOCOMPR_FL			0x00000400 /* Don't compress */
-	/* nb: was previously EXT2_ECOMPR_FL */
-#define EXT4_ENCRYPT_FL			0x00000800 /* encrypted file */
-/* End compression flags --- maybe not all used */
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
-#define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
-#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
-#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
+ * Inode flags used for bit masks
+ */
+#define EXT4_SECRM_FL		BIT(EXT4_INODE_SECRM)		/* Secure deletion */
+#define EXT4_UNRM_FL		BIT(EXT4_INODE_UNRM)		/* Undelete */
+#define EXT4_COMPR_FL		BIT(EXT4_INODE_COMPR)		/* Compress file */
+#define EXT4_SYNC_FL		BIT(EXT4_INODE_SYNC)		/* Synchronous updates */
+#define EXT4_IMMUTABLE_FL	BIT(EXT4_INODE_IMMUTABLE)	/* Immutable file */
+#define EXT4_APPEND_FL		BIT(EXT4_INODE_APPEND)		/* writes to file may only append */
+#define EXT4_NODUMP_FL		BIT(EXT4_INODE_NODUMP)		/* do not dump file */
+#define EXT4_NOATIME_FL		BIT(EXT4_INODE_NOATIME)		/* do not update atime */
+#define EXT4_DIRTY_FL		BIT(EXT4_INODE_DIRTY)
+#define EXT4_COMPRBLK_FL	BIT(EXT4_INODE_COMPRBLK)	/* One or more compressed clusters */
+#define EXT4_NOCOMPR_FL		BIT(EXT4_INODE_NOCOMPR)		/* Don't compress */
+#define EXT4_ENCRYPT_FL		BIT(EXT4_INODE_ENCRYPT)		/* encrypted file, previously EXT2_ECOMPR_FL */
+#define EXT4_INDEX_FL		BIT(EXT4_INODE_INDEX)		/* hash-indexed directory */
+#define EXT4_IMAGIC_FL		BIT(EXT4_INODE_IMAGIC)		/* AFS directory */
+#define EXT4_JOURNAL_DATA_FL	BIT(EXT4_INODE_JOURNAL_DATA)	/* file data should be journaled */
+#define EXT4_NOTAIL_FL		BIT(EXT4_INODE_NOTAIL)		/* file tail should not be merged */
+#define EXT4_DIRSYNC_FL		BIT(EXT4_INODE_DIRSYNC)		/* dirsync behaviour (directories only) */
+#define EXT4_TOPDIR_FL		BIT(EXT4_INODE_TOPDIR)		/* Top of directory hierarchies*/
+#define EXT4_HUGE_FILE_FL	BIT(EXT4_INODE_HUGE_FILE)	/* Set to each huge file */
+#define EXT4_EXTENTS_FL		BIT(EXT4_INODE_EXTENTS)		/* Inode uses extents */
+#define EXT4_EA_INODE_FL	BIT(EXT4_INODE_EA_INODE)	/* Inode used for large EA */
+#define EXT4_EOFBLOCKS_FL	BIT(EXT4_INODE_EOFBLOCKS)	/* Blocks allocated beyond EOF */
+#define EXT4_INLINE_DATA_FL	BIT(EXT4_INODE_INLINE_DATA)	/* Inode has inline data. */
+#define EXT4_PROJINHERIT_FL	BIT(EXT4_INODE_PROJINHERIT)	/* Create with parents projid */
+#define EXT4_RESERVED_FL	BIT(EXT4_INODE_RESERVED)	/* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
@@ -468,51 +466,6 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
 		return flags & EXT4_OTHER_FLMASK;
 }
 
-/*
- * Since it's pretty easy to mix up bit numbers and hex values, we use a
- * build-time check to make sure that EXT4_XXX_FL is consistent with respect to
- * EXT4_INODE_XXX. If all is well, the macros will be dropped, so, it won't cost
- * any extra space in the compiled kernel image, otherwise, the build will fail.
- * It's important that these values are the same, since we are using
- * EXT4_INODE_XXX to test for flag values, but EXT4_XXX_FL must be consistent
- * with the values of FS_XXX_FL defined in include/linux/fs.h and the on-disk
- * values found in ext2, ext3 and ext4 filesystems, and of course the values
- * defined in e2fsprogs.
- *
- * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
- */
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
-#define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
-
-static inline void ext4_check_flag_values(void)
-{
-	CHECK_FLAG_VALUE(SECRM);
-	CHECK_FLAG_VALUE(UNRM);
-	CHECK_FLAG_VALUE(COMPR);
-	CHECK_FLAG_VALUE(SYNC);
-	CHECK_FLAG_VALUE(IMMUTABLE);
-	CHECK_FLAG_VALUE(APPEND);
-	CHECK_FLAG_VALUE(NODUMP);
-	CHECK_FLAG_VALUE(NOATIME);
-	CHECK_FLAG_VALUE(DIRTY);
-	CHECK_FLAG_VALUE(COMPRBLK);
-	CHECK_FLAG_VALUE(NOCOMPR);
-	CHECK_FLAG_VALUE(ENCRYPT);
-	CHECK_FLAG_VALUE(INDEX);
-	CHECK_FLAG_VALUE(IMAGIC);
-	CHECK_FLAG_VALUE(JOURNAL_DATA);
-	CHECK_FLAG_VALUE(NOTAIL);
-	CHECK_FLAG_VALUE(DIRSYNC);
-	CHECK_FLAG_VALUE(TOPDIR);
-	CHECK_FLAG_VALUE(HUGE_FILE);
-	CHECK_FLAG_VALUE(EXTENTS);
-	CHECK_FLAG_VALUE(EA_INODE);
-	CHECK_FLAG_VALUE(EOFBLOCKS);
-	CHECK_FLAG_VALUE(INLINE_DATA);
-	CHECK_FLAG_VALUE(PROJINHERIT);
-	CHECK_FLAG_VALUE(RESERVED);
-}
-
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
 	__u32 group;		/* Group number for this data */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7c46693..ec96765 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5790,9 +5790,6 @@ static int __init ext4_init_fs(void)
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
 
-	/* Build-time check for flags consistency */
-	ext4_check_flag_values();
