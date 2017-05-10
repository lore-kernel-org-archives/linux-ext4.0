From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Move error reporting on bio completion to ext4_finish_bio()
Date: Wed, 10 May 2017 09:41:44 +0200
Message-ID: <20170510074147.26743-2-jack@suse.cz>
References: <20170510074147.26743-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752165AbdEJHro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 May 2017 03:47:44 -0400
In-Reply-To: <20170510074147.26743-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we were reporting errors from IO completion in ext4_end_bio().
Additionally we were setting page error bit in ext4_finish_bio() and
also unnecessarily calling mapping_set_error() again. Move all the error
reporting from IO completion to ext4_finish_bio().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 1a82138ba739..61e4e25b8e95 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -62,6 +62,7 @@ static void ext4_finish_bio(struct bio *bio)
 {
 	int i;
 	struct bio_vec *bvec;
+	bool error_reported = false;
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
@@ -87,7 +88,19 @@ static void ext4_finish_bio(struct bio *bio)
 
 		if (bio->bi_error) {
 			SetPageError(page);
-			mapping_set_error(page->mapping, -EIO);
+			if (!error_reported) {
+				struct inode *inode = page->mapping->host;
+				sector_t bi_sector = bio->bi_iter.bi_sector;
+
+				ext4_warning(inode->i_sb,
+					"I/O error %d writing to inode %lu "
+					"(starting block %llu)",
+					bio->bi_error, inode->i_ino,
+					(unsigned long long)
+					bi_sector >> (inode->i_blkbits - 9));
+				mapping_set_error(page->mapping, bio->bi_error);
+				error_reported = true;
+			}
 		}
 		bh = head = page_buffers(page);
 		/*
@@ -296,7 +309,6 @@ ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
 static void ext4_end_bio(struct bio *bio)
 {
 	ext4_io_end_t *io_end = bio->bi_private;
-	sector_t bi_sector = bio->bi_iter.bi_sector;
 	char b[BDEVNAME_SIZE];
 
 	if (WARN_ONCE(!io_end, "io_end is NULL: %s: sector %Lu len %u err %d\n",
@@ -310,19 +322,6 @@ static void ext4_end_bio(struct bio *bio)
 	}
 	bio->bi_end_io = NULL;
 
-	if (bio->bi_error) {
-		struct inode *inode = io_end->inode;
-
-		ext4_warning(inode->i_sb, "I/O error %d writing to inode %lu "
-			     "(offset %llu size %ld starting block %llu)",
-			     bio->bi_error, inode->i_ino,
-			     (unsigned long long) io_end->offset,
-			     (long) io_end->size,
-			     (unsigned long long)
-			     bi_sector >> (inode->i_blkbits - 9));
-		mapping_set_error(inode->i_mapping, bio->bi_error);
-	}
