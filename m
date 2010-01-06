From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ext4: unmap the underlying metadata when allocating blocks via fallocate
Date: Thu,  7 Jan 2010 00:52:42 +0530
Message-ID: <1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41052 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0AFTWu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 14:22:50 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id o06JMm8k027351
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 00:52:48 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o06JMlb62388184
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 00:52:47 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o06JMlfv002151
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 06:22:47 +1100
In-Reply-To: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This become important when we are running with nojournal mode. We
may end up allocating recently freed metablocks for fallocate. We
want to make sure we unmap the old mapping so that when we convert
the fallocated uninitialized extent to initialized extent we don't
have the old mapping around. Leaving the old mapping can cause
file system corruption

Now that we unmap old metadata blocks we need not return blocks
allocated from fallocate area as new.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |   14 ++++++++++++++
 fs/ext4/extents.c |   18 ++++--------------
 fs/ext4/inode.c   |   18 +-----------------
 3 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 874d169..110a31f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1773,6 +1773,20 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+/*
+ * __unmap_underlying_bh_blocks - just a helper function to unmap
+ * set of blocks described by @bh
+ */
+static inline void __unmap_underlying_bh_blocks(struct inode *inode,
+					     struct buffer_head *bh)
+{
+	struct block_device *bdev = inode->i_sb->s_bdev;
+	int blocks, i;
+
+	blocks = bh->b_size >> inode->i_blkbits;
+	for (i = 0; i < blocks; i++)
+		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 765a482..7b4f4cc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3120,21 +3120,9 @@ out:
 		goto out2;
 	} else
 		allocated = ret;
-	set_buffer_new(bh_result);
-	/*
-	 * if we allocated more blocks than requested
-	 * we need to make sure we unmap the extra block
-	 * allocated. The actual needed block will get
-	 * unmapped later when we find the buffer_head marked
-	 * new.
-	 */
-	if (allocated > max_blocks) {
-		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
-					newblock + max_blocks,
-					allocated - max_blocks);
-		allocated = max_blocks;
-	}
 
+	if (allocated > max_blocks)
+		allocated = max_blocks;
 	/*
 	 * If we have done fallocate with the offset that is already
 	 * delayed allocated, we would have block reservation
@@ -3570,6 +3558,8 @@ retry:
 			ret2 = ext4_journal_stop(handle);
 			break;
 		}
+		if (buffer_new(&map_bh))
+			__unmap_underlying_bh_blocks(inode, &map_bh);
 		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
 						blkbits) >> blkbits))
 			new_size = offset + len;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fec4ea1..831c7cd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2104,22 +2104,6 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 	}
 }
 
-
-/*
- * __unmap_underlying_blocks - just a helper function to unmap
- * set of blocks described by @bh
- */
-static inline void __unmap_underlying_blocks(struct inode *inode,
-					     struct buffer_head *bh)
-{
-	struct block_device *bdev = inode->i_sb->s_bdev;
-	int blocks, i;
-
-	blocks = bh->b_size >> inode->i_blkbits;
-	for (i = 0; i < blocks; i++)
-		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
-}
