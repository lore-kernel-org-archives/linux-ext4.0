From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 7/9] ext2: use memweight()
Date: Sat,  9 Jun 2012 09:50:36 +0900
Message-ID: <1339203038-13069-7-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59124 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab2FIAvU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2012 20:51:20 -0400
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert ext2_count_free() to use memweight() instead of table lookup
based counting clear bits implementation.  This change only affects
the code segments enabled by EXT2FS_DEBUG.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is
aligned to long-word boundary.  Because the size of the memory area
may not be a multiple of BITS_PER_LONG, then it returns wrong value on
big-endian architecture.

This also includes the following changes.

- Remove unnecessary map == NULL check in ext2_count_free() which
  always takes non-null pointer as the memory area.

- Fix printk format warning that only reveals with EXT2FS_DEBUG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
---
v3: rewrite to keep ext2_count_free() as a wrapper for memweight()

 fs/ext2/balloc.c |   14 ++------------
 fs/ext2/ialloc.c |    1 +
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 1c36139..376aa77 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1444,19 +1444,9 @@ ext2_fsblk_t ext2_new_block(struct inode *inode, unsigned long goal, int *errp)
 
 #ifdef EXT2FS_DEBUG
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
-unsigned long ext2_count_free (struct buffer_head * map, unsigned int numchars)
+unsigned long ext2_count_free(struct buffer_head *map, unsigned int numchars)
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
 
 #endif  /*  EXT2FS_DEBUG  */
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index c13eb7b..8f370e01 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -644,6 +644,7 @@ unsigned long ext2_count_free_inodes (struct super_block * sb)
 	}
 	brelse(bitmap_bh);
 	printk("ext2_count_free_inodes: stored = %lu, computed = %lu, %lu\n",
+		(unsigned long)
 		percpu_counter_read(&EXT2_SB(sb)->s_freeinodes_counter),
 		desc_count, bitmap_count);
 	return desc_count;
-- 
1.7.7.6

