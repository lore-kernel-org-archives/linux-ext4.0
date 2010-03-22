From: tytso@mit.edu
Subject: Re: [PATCH] memory leakage in ext4_ext_zeroout
Date: Sun, 21 Mar 2010 21:02:10 -0400
Message-ID: <20100322010210.GC11560@thunk.org>
References: <ac8f92701003110542p6c11ad77l285091cf28928660@mail.gmail.com>
 <1268402132.32032.13.camel@norville.austin.ibm.com>
 <ac8f92701003122233i6e673351p692dbc2a452b2514@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Xu Chang Ming <xcmhit@gmail.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51214 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0CVCMS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Mar 2010 22:12:18 -0400
Content-Disposition: inline
In-Reply-To: <ac8f92701003122233i6e673351p692dbc2a452b2514@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 13, 2010 at 02:33:28PM +0800, jing zhang wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Sat Mar 13 14:05:27     2010
> 
> When EIO occurs after bio is submitted, there is no memory free
> operation for bio, which results in memory leakage. And there is also
> no check against bio_alloc() for bio.
> 
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>

Thanks for the patch.

This is what I've checked in, which also simplifies the error handling
a bit and makes the code a bit easier to follow.

      	  	    	       	      	 - Ted

ext4: fix memory leaks in error path handling of ext4_ext_zeroout()

From: jing zhang <zj.barak@gmail.com>

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
index 94c8ee8..8bdee27 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2544,7 +2544,7 @@ static void bi_complete(struct bio *bio, int error)
 /* FIXME!! we need to try to merge to left or right after zero-out  */
 static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 {
-	int ret = -EIO;
+	int ret;
 	struct bio *bio;
 	int blkbits, blocksize;
 	sector_t ee_pblock;
@@ -2568,6 +2568,9 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
+		if (!bio)
+			return -ENOMEM;
+
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 
@@ -2595,17 +2598,15 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
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

