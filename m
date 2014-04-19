From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 1/2] ext4: fix COLLAPSE_RANGE failure issue on ext4 with 1KB
 block size
Date: Sat, 19 Apr 2014 13:50:37 +0900
Message-ID: <000c01cf5b8a$e7dd2cc0$b7978640$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:9251 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDSEuj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2014 00:50:39 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4900313HGDJVA0@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Sat, 19 Apr 2014 13:50:37 +0900 (KST)
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
 fs/ext4/extents.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9b9251a..4cf8c5b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5395,7 +5395,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	ext4_lblk_t punch_start, punch_stop;
 	handle_t *handle;
 	unsigned int credits;
-	loff_t new_size;
+	loff_t new_size, ioffset;
 	int ret;
 
 	/* Collapse range works only on fs block size aligned offsets. */
@@ -5418,8 +5418,15 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 			return ret;
 	}
 
+	/*
+	 * Need to round down offset to be aligned with page size boundary
+	 * for page size > block size.
+	 */
+	ioffset = round_down(offset, PAGE_SIZE);
+
 	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
+					   LLONG_MAX);
 	if (ret)
 		return ret;
 
@@ -5441,7 +5448,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
-	truncate_pagecache(inode, offset);
+	truncate_pagecache(inode, ioffset);
 
 	/* Wait for existing dio to complete */
 	ext4_inode_block_unlocked_dio(inode);
-- 
1.7.11-rc0

