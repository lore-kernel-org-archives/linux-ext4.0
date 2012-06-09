From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 8/9] ext3: use memweight()
Date: Sat,  9 Jun 2012 09:50:37 +0900
Message-ID: <1339203038-13069-8-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert ext3_count_free() to use memweight() instead of table lookup
based counting clear bits implementation.  This change only affects
the code segments enabled by EXT3FS_DEBUG.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is
aligned to long-word boundary.  Because the size of the memory area
may not be a multiple of BITS_PER_LONG, then it returns wrong value on
big-endian architecture.

This also includes the following changes.

- Remove unnecessary map == NULL check in ext3_count_free() which
  always takes non-null pointer as the memory area.

- Fix printk format warning that only reveals with EXT3FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
v3: rewrite to keep ext3_count_free() as a wrapper for memweight()

 fs/ext3/balloc.c |    2 +-
 fs/ext3/bitmap.c |   12 +-----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 25cd608..90d901f 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1813,7 +1813,7 @@ ext3_fsblk_t ext3_count_free_blocks(struct super_block *sb)
 	brelse(bitmap_bh);
 	printk("ext3_count_free_blocks: stored = "E3FSBLK
 		", computed = "E3FSBLK", "E3FSBLK"\n",
-	       le32_to_cpu(es->s_free_blocks_count),
+	       (ext3_fsblk_t)le32_to_cpu(es->s_free_blocks_count),
 		desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff --git a/fs/ext3/bitmap.c b/fs/ext3/bitmap.c
index 909d13e..ef9c643 100644
--- a/fs/ext3/bitmap.c
+++ b/fs/ext3/bitmap.c
@@ -11,19 +11,9 @@
 
 #ifdef EXT3FS_DEBUG
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
 unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
 {
-	unsigned int i;
-	unsigned long sum = 0;
-
-	if (!map)
-		return (0);
-	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
-	return (sum);
+	return numchars * BITS_PER_BYTE - memweight(map->b_data, numchars);
 }
 
 #endif  /*  EXT3FS_DEBUG  */
-- 
1.7.7.6
