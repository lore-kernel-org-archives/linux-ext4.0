From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 31/53] ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
Date: Sun, 30 May 2010 22:49:44 -0400
Message-ID: <1275274206-3900-31-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jing Zhang <zj.barak@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44659 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab0EaCuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:22 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

commit b720303df7352d4a7a1f61e467e0a124913c0d41 upstream (as of v2.6.34-git13)

When EIO occurs after bio is submitted, there is no memory free
operation for bio, which results in memory leakage. And there is also
no check against bio_alloc() for bio.

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4378941..f4844ed 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2446,7 +2446,7 @@ static void bi_complete(struct bio *bio, int error)
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
-	int ret = -EIO;
+	int ret;
 	struct bio *bio;
 	int blkbits, blocksize;
 	sector_t ee_pblock;
@@ -2470,6 +2470,9 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
+		if (!bio)
+			return -ENOMEM;
+
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 
@@ -2497,17 +2500,15 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 		submit_bio(WRITE, bio);
 		wait_for_completion(&event);
 
-		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
-			ret = 0;
-		else {
-			ret = -EIO;
-			break;
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			bio_put(bio);
+			return -EIO;
 		}
 		bio_put(bio);
 		ee_len    -= done;
 		ee_pblock += done  << (blkbits - 9);
 	}
-	return ret;
+	return 0;
 }
 
 #define EXT4_EXT_ZERO_LEN 7
-- 
1.6.6.1.1.g974db.dirty

