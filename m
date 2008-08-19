From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: limit nrblocks properly with non extent format
Date: Tue, 19 Aug 2008 12:18:13 +0530
Message-ID: <1219128494-10402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53203 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYHSGtg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 02:49:36 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7J6nrIw018133
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 16:49:54 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7J6mJ5e234950
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 16:48:19 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7J6mIa1018820
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 16:48:18 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure adding new buffer_head to the
contiguous block extent doesn't result in nrblocks
greater than EXT4_MAX_TRANS_DATA. We only have
enought credit to insert EXT4_MAX_TRANS_DATA blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dcd1337..a10f8e5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1909,27 +1909,39 @@ static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 				   sector_t logical, struct buffer_head *bh)
 {
-	struct buffer_head *lbh = &mpd->lbh;
 	sector_t next;
+	size_t b_size = bh->b_size;
+	struct buffer_head *lbh = &mpd->lbh;
 	int nrblocks = lbh->b_size >> mpd->inode->i_blkbits;
 
 	/* check if thereserved journal credits might overflow */
-	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL) &&
-	     (nrblocks >= EXT4_MAX_TRANS_DATA))
-		/*
-		 * With noextent format we are limited by the journal
-		 * credit available. Total credit needed to insert
-		 * nrblocks contiguous blocks is dependent on the
-		 * nrblocks. So limit nrblocks.
-		 */
-		goto flush_it;
-
+	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL)) {
+		if (nrblocks >= EXT4_MAX_TRANS_DATA) {
+			/*
+			 * With noextent format we are limited by the journal
+			 * credit available. Total credit needed to insert
+			 * nrblocks contiguous blocks is dependent on the
+			 * nrblocks. So limit nrblocks.
+			 */
+			goto flush_it;
+		} else if ((nrblocks + (b_size >> mpd->inode->i_blkbits)) >
+				EXT4_MAX_TRANS_DATA) {
+			/*
+			 * Adding the new buffer_head would make it cross the
+			 * allowed limit for which we have journal credit
+			 * reserved. So limit the new bh->b_size
+			 */
+			b_size = (EXT4_MAX_TRANS_DATA - nrblocks) <<
+						mpd->inode->i_blkbits;
+			/* we will do mpage_da_submit_io in the next loop */
+		}
+	}
 	/*
 	 * First block in the extent
 	 */
 	if (lbh->b_size == 0) {
 		lbh->b_blocknr = logical;
-		lbh->b_size = bh->b_size;
+		lbh->b_size = b_size;
 		lbh->b_state = bh->b_state & BH_FLAGS;
 		return;
 	}
@@ -1939,7 +1951,7 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	 * Can we merge the block to our big extent?
 	 */
 	if (logical == next && (bh->b_state & BH_FLAGS) == lbh->b_state) {
-		lbh->b_size += bh->b_size;
+		lbh->b_size += b_size;
 		return;
 	}
 
-- 
1.6.0.2.g2ebc0

