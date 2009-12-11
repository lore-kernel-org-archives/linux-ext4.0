From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext4: flush delalloc blocks when space is low
Date: Fri, 11 Dec 2009 17:07:04 -0600
Message-ID: <4B22D098.3080600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Creating many small files in rapid succession on a small
filesystem can lead to spurious ENOSPC; on a 104MB filesystem:

for i in `seq 1 22500`; do
    echo -n > $SCRATCH_MNT/$i
    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
done

leads to ENOSPC even though after a sync, 40% of the fs is free
again.

This is because we reserve worst-case metadata for delalloc writes,
and when data is allocated that worst-case reservation is not
usually needed.

When freespace is low, kicking off an async writeback will start
converting that worst-case space usage into something more realistic,
almost always freeing up space to continue.

This resolves the testcase for me, and survives all 4 generic
ENOSPC tests in xfstests.

We'll still need a hard synchronous sync to squeeze out the last bit,
but this fixes things up to a large degree.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..5b3f468 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3024,11 +3024,18 @@ static int ext4_nonda_switch(struct super_block *sb)
 	if (2 * free_blocks < 3 * dirty_blocks ||
 		free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
 		/*
-		 * free block count is less that 150% of dirty blocks
-		 * or free blocks is less that watermark
+		 * free block count is less than 150% of dirty blocks
+		 * or free blocks is less than watermark
 		 */
 		return 1;
 	}
+	/*
+	 * Even if we don't switch but are nearing capacity,
+	 * start pushing delalloc when 1/2 of free blocks are dirty.
+	 */
+	if (free_blocks < 2 * dirty_blocks)
+		writeback_inodes_sb_if_idle(sb);
+
 	return 0;
 }
 

