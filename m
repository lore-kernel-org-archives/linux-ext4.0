From: Jan Kara <jack@suse.com>
Subject: [PATCH 3/9] ext4: Fix races between buffered IO and collapse / insert range
Date: Wed,  4 Nov 2015 17:18:34 +0100
Message-ID: <1446653920-23127-4-git-send-email-jack@suse.com>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	dan.j.williams@intel.com, Jan Kara <jack@suse.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbbKDQSv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2015 11:18:51 -0500
In-Reply-To: <1446653920-23127-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current code implementing FALLOC_FL_COLLAPSE_RANGE and
FALLOC_FL_INSERT_RANGE is prone to races with buffered writes and page
faults. If buffered write or write via mmap manages to squeeze between
filemap_write_and_wait_range() and truncate_pagecache() in the fallocate
implementations, the written data is simply discarded by
truncate_pagecache() although it should have been shifted.

Fix the problem by moving filemap_write_and_wait_range() call inside
i_mutex and i_mmap_sem. That way we are protected against races with
both buffered writes and page faults.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/extents.c | 61 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 66ab89b58c1f..a333c9cc651f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5483,21 +5483,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 			return ret;
 	}
 
-	/*
-	 * Need to round down offset to be aligned with page size boundary
-	 * for page size > block size.
-	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-
-	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-					   LLONG_MAX);
-	if (ret)
-		return ret;
-
-	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
-
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
@@ -5518,10 +5504,31 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	inode_dio_wait(inode);
 
 	/*
-	 * Prevent page faults from reinstantiating pages we have released from
+	 * Prevent page faults from reinstantiating we have released from
 	 * page cache.
 	 */
 	down_write(&EXT4_I(inode)->i_mmap_sem);
+	/*
+	 * Need to round down offset to be aligned with page size boundary
+	 * for page size > block size.
+	 */
+	ioffset = round_down(offset, PAGE_SIZE);
+	/*
+	 * Write tail of the last page before removed range since it will get
+	 * removed from the page cache below.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, offset);
+	if (ret)
+		goto out_mmap;
+	/*
+	 * Write data that will be shifted to preserve them when discarding
+	 * page cache below. We are also protected from pages becoming dirty
+	 * by i_mmap_sem.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset + len,
+					   LLONG_MAX);
+	if (ret)
+		goto out_mmap;
 	truncate_pagecache(inode, ioffset);
 
 	credits = ext4_writepage_trans_blocks(inode);
@@ -5622,21 +5629,7 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 			return ret;
 	}
 
-	/*
-	 * Need to round down to align start offset to page size boundary
-	 * for page size > block size.
-	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-
-	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-			LLONG_MAX);
-	if (ret)
-		return ret;
-
-	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
