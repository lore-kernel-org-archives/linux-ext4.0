From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 08/10] ext2: use memweight()
Date: Sun, 20 May 2012 22:23:21 +0900
Message-ID: <1337520203-29147-8-git-send-email-akinobu.mita@gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use memweight() to count the total number of bits clear in memory area.
This change only affects the code segments enabled by EXT2FS_DEBUG.

This also fixes printk format warning that only reveals with EXT2FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/balloc.c |   22 ++--------------------
 fs/ext2/ext2.h   |    1 -
 fs/ext2/ialloc.c |    5 ++++-
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index a8cbe1b..3351731 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1443,25 +1443,6 @@ ext2_fsblk_t ext2_new_block(struct inode *inode, unsigned long goal, int *errp)
 	return ext2_new_blocks(inode, goal, &count, errp);
 }
 
-#ifdef EXT2FS_DEBUG
-
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
-unsigned long ext2_count_free (struct buffer_head * map, unsigned int numchars)
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
-#endif  /*  EXT2FS_DEBUG  */
-
 unsigned long ext2_count_free_blocks (struct super_block * sb)
 {
 	struct ext2_group_desc * desc;
@@ -1485,7 +1466,8 @@ unsigned long ext2_count_free_blocks (struct super_block * sb)
 		if (!bitmap_bh)
 			continue;
 		
-		x = ext2_count_free(bitmap_bh, sb->s_blocksize);
+		x = sb->s_blocksize * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data, sb->s_blocksize);
 		printk ("group %d: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(desc->bg_free_blocks_count), x);
 		bitmap_count += x;
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 0b2b4db..de2a4e5 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -745,7 +745,6 @@ extern struct inode * ext2_new_inode (struct inode *, umode_t, const struct qstr
 extern void ext2_free_inode (struct inode *);
 extern unsigned long ext2_count_free_inodes (struct super_block *);
 extern void ext2_check_inodes_bitmap (struct super_block *);
-extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 
 /* inode.c */
 extern struct inode *ext2_iget (struct super_block *, unsigned long);
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 8b15cf8..82139c4 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -639,13 +639,16 @@ unsigned long ext2_count_free_inodes (struct super_block * sb)
 		if (!bitmap_bh)
 			continue;
 
-		x = ext2_count_free(bitmap_bh, EXT2_INODES_PER_GROUP(sb) / 8);
+		x = EXT2_INODES_PER_GROUP(sb) / 8 * BITS_PER_BYTE -
+			memweight(bitmap_bh->b_data,
+				EXT2_INODES_PER_GROUP(sb) / 8);
 		printk("group %d: stored = %d, counted = %u\n",
 			i, le16_to_cpu(desc->bg_free_inodes_count), x);
 		bitmap_count += x;
 	}
 	brelse(bitmap_bh);
 	printk("ext2_count_free_inodes: stored = %lu, computed = %lu, %lu\n",
+		(unsigned long)
 		percpu_counter_read(&EXT2_SB(sb)->s_freeinodes_counter),
 		desc_count, bitmap_count);
 	return desc_count;
-- 
1.7.7.6
