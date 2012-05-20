From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 09/10] ext3: use memweight()
Date: Sun, 20 May 2012 22:23:22 +0900
Message-ID: <1337520203-29147-9-git-send-email-akinobu.mita@gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use memweight() to count the total number of bits clear in memory area.
This change only affects the code segments enabled by EXT3FS_DEBUG.

This also fixes printk format warning that only reveals with EXT3FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/Makefile |    2 +-
 fs/ext3/balloc.c |    5 +++--
 fs/ext3/bitmap.c |   30 ------------------------------
 fs/ext3/ext3.h   |    2 --
 fs/ext3/ialloc.c |    4 +++-
 5 files changed, 7 insertions(+), 36 deletions(-)
 delete mode 100644 fs/ext3/bitmap.c

diff --git a/fs/ext3/Makefile b/fs/ext3/Makefile
index e77766a..ce93e94 100644
--- a/fs/ext3/Makefile
+++ b/fs/ext3/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_EXT3_FS) += ext3.o
 
-ext3-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
+ext3-y	:= balloc.o dir.o file.o fsync.o ialloc.o inode.o \
 	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o
 
 ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index baac1b1..676bd53 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1804,7 +1804,8 @@ ext3_fsblk_t ext3_count_free_blocks(struct super_block *sb)
 		if (bitmap_bh == NULL)
 			continue;
 
-		x = ext3_count_free(bitmap_bh, sb->s_blocksize);
+		x = sb->s_blocksize * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data, sb->s_blocksize);
 		printk("group %d: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(gdp->bg_free_blocks_count), x);
 		bitmap_count += x;
@@ -1812,7 +1813,7 @@ ext3_fsblk_t ext3_count_free_blocks(struct super_block *sb)
 	brelse(bitmap_bh);
 	printk("ext3_count_free_blocks: stored = "E3FSBLK
 		", computed = "E3FSBLK", "E3FSBLK"\n",
-	       le32_to_cpu(es->s_free_blocks_count),
+		(ext3_fsblk_t)le32_to_cpu(es->s_free_blocks_count),
 		desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff --git a/fs/ext3/bitmap.c b/fs/ext3/bitmap.c
deleted file mode 100644
index 909d13e..0000000
--- a/fs/ext3/bitmap.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- *  linux/fs/ext3/bitmap.c
- *
- * Copyright (C) 1992, 1993, 1994, 1995
- * Remy Card (card@masi.ibp.fr)
- * Laboratoire MASI - Institut Blaise Pascal
- * Universite Pierre et Marie Curie (Paris VI)
- */
-
-#include "ext3.h"
-
-#ifdef EXT3FS_DEBUG
-
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
-unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
-{
-	unsigned int i;
-	unsigned long sum = 0;
-
-	if (!map)
-		return (0);
-	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
-	return (sum);
-}
-
-#endif  /*  EXT3FS_DEBUG  */
-
diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index b6515fd..5c6246d 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -1029,8 +1029,6 @@ extern struct inode * ext3_orphan_get (struct super_block *, unsigned long);
 extern unsigned long ext3_count_free_inodes (struct super_block *);
 extern unsigned long ext3_count_dirs (struct super_block *);
 extern void ext3_check_inodes_bitmap (struct super_block *);
-extern unsigned long ext3_count_free (struct buffer_head *, unsigned);
-
 
 /* inode.c */
 int ext3_forget(handle_t *handle, int is_metadata, struct inode *inode,
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index e3c39e4..b58c8e2 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -683,7 +683,9 @@ unsigned long ext3_count_free_inodes (struct super_block * sb)
 		if (!bitmap_bh)
 			continue;
 
-		x = ext3_count_free(bitmap_bh, EXT3_INODES_PER_GROUP(sb) / 8);
+		x = EXT3_INODES_PER_GROUP(sb) / 8 * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data,
+				EXT3_INODES_PER_GROUP(sb) / 8);
 		printk("group %d: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(gdp->bg_free_inodes_count), x);
 		bitmap_count += x;
-- 
1.7.7.6
