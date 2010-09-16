From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/6] Use sb_issue_zeroout in ext4_ext_zeroout
Date: Thu, 16 Sep 2010 14:47:30 +0200
Message-ID: <1284641251-24531-6-git-send-email-lczerner@redhat.com>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com, snitzer@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0IPMrs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 08:47:48 -0400
In-Reply-To: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change ext4_ext_zeroout to use sb_issue_zeroout instead of its
own approach to zero out extents.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   69 +++++-----------------------------------------------
 1 files changed, 7 insertions(+), 62 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 06328d3..519cd2b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2535,77 +2535,22 @@ void ext4_ext_release(struct super_block *sb)
 #endif
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
+	ext4_fsblk_t ee_pblock;
+	unsigned int ee_len;
 	int ret;
-	struct bio *bio;
-	int blkbits, blocksize;
-	sector_t ee_pblock;
-	struct completion event;
-	unsigned int ee_len, len, done, offset;
 
-
-	blkbits   = inode->i_blkbits;
-	blocksize = inode->i_sb->s_blocksize;
 	ee_len    = ext4_ext_get_actual_len(ex);
 	ee_pblock = ext_pblock(ex);
 
-	/* convert ee_pblock to 512 byte sectors */
-	ee_pblock = ee_pblock << (blkbits - 9);
-
-	while (ee_len > 0) {
-
-		if (ee_len > BIO_MAX_PAGES)
-			len = BIO_MAX_PAGES;
-		else
-			len = ee_len;
-
-		bio = bio_alloc(GFP_NOIO, len);
-		if (!bio)
-			return -ENOMEM;
-
-		bio->bi_sector = ee_pblock;
-		bio->bi_bdev   = inode->i_sb->s_bdev;
-
-		done = 0;
-		offset = 0;
-		while (done < len) {
-			ret = bio_add_page(bio, ZERO_PAGE(0),
-							blocksize, offset);
-			if (ret != blocksize) {
-				/*
-				 * We can't add any more pages because of
-				 * hardware limitations.  Start a new bio.
-				 */
-				break;
-			}
-			done++;
-			offset += blocksize;
-			if (offset >= PAGE_CACHE_SIZE)
-				offset = 0;
-		}
-
-		init_completion(&event);
-		bio->bi_private = &event;
-		bio->bi_end_io = bi_complete;
-		submit_bio(WRITE, bio);
-		wait_for_completion(&event);
+	ret = sb_issue_zeroout(inode->i_sb, ee_pblock, ee_len,
+			       GFP_NOFS, BLKDEV_IFL_WAIT);
+	if (ret > 0)
+		ret = 0;
 
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
-			bio_put(bio);
-			return -EIO;
-		}
-		bio_put(bio);
-		ee_len    -= done;
-		ee_pblock += done  << (blkbits - 9);
-	}
-	return 0;
+	return ret;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
-- 
1.7.2.2

