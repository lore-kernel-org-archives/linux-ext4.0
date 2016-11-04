From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/6] direct-io: Use clean_bdev_aliases() instead of handmade iteration
Date: Fri,  4 Nov 2016 18:08:12 +0100
Message-ID: <1478279296-6575-3-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932899AbcKDRI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 13:08:26 -0400
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use new provided function instead of an iteration through all allocated
blocks.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index fb9aa16a7727..12ac532a444a 100644
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
+					clean_bdev_aliases(
+						map_bh->b_bdev,
+						map_bh->b_blocknr,
+						map_bh->b_size >> blkbits);
+				}
 
 				if (!sdio->blkfactor)
 					goto do_holes;
-- 
2.6.6

