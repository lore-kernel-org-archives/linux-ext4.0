From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 10/10] ext4: use memweight()
Date: Sun, 20 May 2012 22:23:23 +0900
Message-ID: <1337520203-29147-10-git-send-email-akinobu.mita@gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use memweight() to count the total number of bits clear in memory area.
This change only affects the code segments enabled by EXT4FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/Makefile |    2 +-
 fs/ext4/balloc.c |    3 ++-
 fs/ext4/bitmap.c |   31 -------------------------------
 fs/ext4/ext4.h   |    3 ---
 fs/ext4/ialloc.c |    4 +++-
 5 files changed, 6 insertions(+), 37 deletions(-)
 delete mode 100644 fs/ext4/bitmap.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 56fd8f86..0caff90 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
-ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
+ext4-y	:= balloc.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
 		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
 		mmp.o indirect.o
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4bbd07a..57e3bfb 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -584,7 +584,8 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 		if (bitmap_bh == NULL)
 			continue;
 
-		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
+		x = sb->s_blocksize * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data, sb->s_blocksize);
 		printk(KERN_DEBUG "group %u: stored = %d, counted = %u\n",
 			i, ext4_free_group_clusters(sb, gdp), x);
 		bitmap_count += x;
diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
deleted file mode 100644
index fa3af81..0000000
--- a/fs/ext4/bitmap.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- *  linux/fs/ext4/bitmap.c
- *
- * Copyright (C) 1992, 1993, 1994, 1995
- * Remy Card (card@masi.ibp.fr)
- * Laboratoire MASI - Institut Blaise Pascal
- * Universite Pierre et Marie Curie (Paris VI)
- */
-
-#include <linux/buffer_head.h>
-#include <linux/jbd2.h>
-#include "ext4.h"
-
-#ifdef EXT4FS_DEBUG
-
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
-unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
-{
-	unsigned int i, sum = 0;
-
-	if (!map)
-		return 0;
-	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
-	return sum;
-}
-
-#endif  /*  EXT4FS_DEBUG  */
-
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0e01e90..9c616d9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1782,9 +1782,6 @@ struct mmpd_data {
 # define ATTRIB_NORET	__attribute__((noreturn))
 # define NORET_AND	noreturn,
 
-/* bitmap.c */
-extern unsigned int ext4_count_free(struct buffer_head *, unsigned);
-
 /* balloc.c */
 extern unsigned int ext4_block_group(struct super_block *sb,
 			ext4_fsblk_t blocknr);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 409c2ee..2452bb7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1011,7 +1011,9 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 		if (!bitmap_bh)
 			continue;
 
-		x = ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
+		x = EXT4_INODES_PER_GROUP(sb) / 8 * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data,
+				EXT4_INODES_PER_GROUP(sb) / 8);
 		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
 			(unsigned long) i, ext4_free_inodes_count(sb, gdp), x);
 		bitmap_count += x;
-- 
1.7.7.6
