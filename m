From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 10/10] ext4: use memweight()
Date: Sat,  2 Jun 2012 22:40:16 +0900
Message-ID: <1338644416-11417-10-git-send-email-akinobu.mita@gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49994 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965361Ab2FBNlK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jun 2012 09:41:10 -0400
In-Reply-To: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use memweight() to count the total number of bits clear in memory area.
This change only affects the code segments enabled by EXT4FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---

v2: don't remove bitmap.c which now has other than ext4_count_free()

 fs/ext4/balloc.c |    3 ++-
 fs/ext4/bitmap.c |   18 ------------------
 fs/ext4/ext4.h   |    1 -
 fs/ext4/ialloc.c |    4 +++-
 4 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 99b6324..e5eadfe 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -609,7 +609,8 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 		if (bitmap_bh == NULL)
 			continue;
 
-		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
+		x = sb->s_blocksize * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data, sb->s_blocksize);
 		printk(KERN_DEBUG "group %u: stored = %d, counted = %u\n",
 			i, ext4_free_group_clusters(sb, gdp), x);
 		bitmap_count += x;
diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index b319721..3c67c97 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -11,24 +11,6 @@
 #include <linux/jbd2.h>
 #include "ext4.h"
 
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
 int ext4_inode_bitmap_csum_verify(struct super_block *sb, ext4_group_t group,
 				  struct ext4_group_desc *gdp,
 				  struct buffer_head *bh, int sz)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cfc4e01..3a3511d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1852,7 +1852,6 @@ struct mmpd_data {
 # define NORET_AND	noreturn,
 
 /* bitmap.c */
-extern unsigned int ext4_count_free(struct buffer_head *, unsigned);
 void ext4_inode_bitmap_csum_set(struct super_block *sb, ext4_group_t group,
 				struct ext4_group_desc *gdp,
 				struct buffer_head *bh, int sz);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d48e8b1..1310108 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1054,7 +1054,9 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
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

