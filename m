From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 1/3] ext4: fix COLLAPSE_RANGE failure issue on ext4 with 1KB
 block size
Date: Thu, 17 Apr 2014 07:27:45 +0900
Message-ID: <002901cf59c3$16b21ca0$441655e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPW1q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 18:27:46 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4500E9HAE9WW40@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 07:27:45 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

When formatting with 1KB or 2KB(not aligned with PAGE SIZE) block size,
xfstests generic/075 and 091 are failing. The offset supplied to function
truncate_pagecache_range is block size aligned. In this function start offset
is re-aligned to PAGE_SIZE by rounding_up to the next page boundary.
Due to this rounding up, old data remains in the page cache when blocksize is
less than page size and start offset is not aligned with page size.
In case of collapse range, we need to align start offset to page size boundary
by doing a round down operation instead of round up.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1bb3e4b..f386dd6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5404,8 +5404,8 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t punch_start, punch_stop;
 	handle_t *handle;
-	unsigned int credits;
-	loff_t new_size;
+	unsigned int credits, rounding;
+	loff_t new_size, ioffset;
 	int ret;
 
 	/* Collapse range works only on fs block size aligned offsets. */
@@ -5428,8 +5428,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 			return ret;
 	}
 
+	rounding = max_t(uint, 1 << EXT4_BLOCK_SIZE_BITS(sb), PAGE_CACHE_SIZE);
+	ioffset = offset & ~(rounding - 1);
+
 	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, -1);
 	if (ret)
 		return ret;
 
@@ -5451,7 +5454,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
-	truncate_pagecache_range(inode, offset, -1);
+	truncate_pagecache_range(inode, ioffset, -1);
 
 	/* Wait for existing dio to complete */
 	ext4_inode_block_unlocked_dio(inode);
-- 
1.7.11-rc0

