From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 9/9] ext4: use memweight()
Date: Sat,  9 Jun 2012 09:50:38 +0900
Message-ID: <1339203038-13069-9-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert ext4_count_free() to use memweight() instead of table lookup
based counting clear bits implementation.  This change only affects
the code segments enabled by EXT4FS_DEBUG.

Note that this memweight() call can't be replaced with a single
bitmap_weight() call, although the pointer to the memory area is
aligned to long-word boundary.  Because the size of the memory area
may not be a multiple of BITS_PER_LONG, then it returns wrong value on
big-endian architecture.

This also includes the following change.

- Remove unnecessary map == NULL check in ext4_count_free() which
  always takes non-null pointer as the memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
v3: rewrite to keep ext4_count_free() as a wrapper for memweight()
v2: don't remove bitmap.c which now has other than ext4_count_free()

 fs/ext4/bitmap.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index b319721..ff53d5d 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -13,18 +13,9 @@
 
 #ifdef EXT4FS_DEBUG
 
-static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
-
 unsigned int ext4_count_free(struct buffer_head *map, unsigned int numchars)
 {
-	unsigned int i, sum = 0;
-
-	if (!map)
-		return 0;
-	for (i = 0; i < numchars; i++)
-		sum += nibblemap[map->b_data[i] & 0xf] +
-			nibblemap[(map->b_data[i] >> 4) & 0xf];
-	return sum;
+	return numchars * BITS_PER_BYTE - memweight(map->b_data, numchars);
 }
 
 #endif  /*  EXT4FS_DEBUG  */
-- 
1.7.7.6
