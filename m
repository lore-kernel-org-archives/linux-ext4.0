From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] direct-io: Use unmap_underlying_metadata_ext() instead of handmade iteration
Date: Fri, 21 Oct 2016 13:55:39 +0200
Message-ID: <1477050941-29682-3-git-send-email-jack@suse.cz>
References: <1477050941-29682-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477050941-29682-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use new provided function instead of an iteration through all allocated
blocks.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index fb9aa16a7727..656b9bc2112d 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -843,24 +843,6 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 }
 
 /*
- * Clean any dirty buffers in the blockdev mapping which alias newly-created
- * file blocks.  Only called for S_ISREG files - blockdevs do not set
- * buffer_new
- */
-static void clean_blockdev_aliases(struct dio *dio, struct buffer_head *map_bh)
-{
-	unsigned i;
-	unsigned nblocks;
-
-	nblocks = map_bh->b_size >> dio->inode->i_blkbits;
-
-	for (i = 0; i < nblocks; i++) {
-		unmap_underlying_metadata(map_bh->b_bdev,
-					  map_bh->b_blocknr + i);
-	}
-}
-
-/*
  * If we are not writing the entire block and get_block() allocated
  * the block for us, we need to fill-in the unused portion of the
  * block with zeros. This happens only if user-buffer, fileoffset or
@@ -960,11 +942,15 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
 					goto do_holes;
 
 				sdio->blocks_available =
-						map_bh->b_size >> sdio->blkbits;
+						map_bh->b_size >> blkbits;
 				sdio->next_block_for_io =
 					map_bh->b_blocknr << sdio->blkfactor;
-				if (buffer_new(map_bh))
-					clean_blockdev_aliases(dio, map_bh);
+				if (buffer_new(map_bh)) {
+					unmap_underlying_metadata_ext(
+						map_bh->b_bdev,
+						map_bh->b_blocknr,
+						map_bh->b_size >> blkbits);
+				}
 
 				if (!sdio->blkfactor)
 					goto do_holes;
-- 
2.6.6

