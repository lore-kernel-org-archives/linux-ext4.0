From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext4: Allow IO submission without io_end
Date: Wed, 10 May 2017 09:41:45 +0200
Message-ID: <20170510074147.26743-3-jack@suse.cz>
References: <20170510074147.26743-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752057AbdEJHro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 May 2017 03:47:44 -0400
In-Reply-To: <20170510074147.26743-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow submission of bio through ext4_bio_write_page() without io_end.
For the case where we are not converting unwritten extents we don't need
io_end for anything anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 61e4e25b8e95..34c5ec4c6572 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -309,20 +309,10 @@ ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
 static void ext4_end_bio(struct bio *bio)
 {
 	ext4_io_end_t *io_end = bio->bi_private;
-	char b[BDEVNAME_SIZE];
 
-	if (WARN_ONCE(!io_end, "io_end is NULL: %s: sector %Lu len %u err %d\n",
-		      bdevname(bio->bi_bdev, b),
-		      (long long) bio->bi_iter.bi_sector,
-		      (unsigned) bio_sectors(bio),
-		      bio->bi_error)) {
-		ext4_finish_bio(bio);
-		bio_put(bio);
-		return;
-	}
 	bio->bi_end_io = NULL;
 
-	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
+	if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN) {
 		/*
 		 * Link bio into list hanging from io_end. We have to do it
 		 * atomically as bio completions can be racing against each
@@ -330,15 +320,17 @@ static void ext4_end_bio(struct bio *bio)
 		 */
 		bio->bi_private = xchg(&io_end->bio, bio);
 		ext4_put_io_end_defer(io_end);
-	} else {
+		return;
+	}
+	if (io_end) {
 		/*
 		 * Drop io_end reference early. Inode can get freed once
 		 * we finish the bio.
 		 */
 		ext4_put_io_end_defer(io_end);
-		ext4_finish_bio(bio);
-		bio_put(bio);
 	}
+	ext4_finish_bio(bio);
+	bio_put(bio);
 }
 
 void ext4_io_submit(struct ext4_io_submit *io)
@@ -374,7 +366,8 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_end_io = ext4_end_bio;
-	bio->bi_private = ext4_get_io_end(io->io_end);
+	if (io->io_end)
+		bio->bi_private = ext4_get_io_end(io->io_end);
 	io->io_bio = bio;
 	io->io_next_block = bh->b_blocknr;
 	return 0;
-- 
2.12.0
