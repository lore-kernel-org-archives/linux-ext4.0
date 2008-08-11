From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v2] ext4: Handle unwritten extent properly with delayed allocation.
Date: Mon, 11 Aug 2008 15:53:06 +0530
Message-ID: <1218450188-9643-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58546 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYHKKXO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 06:23:14 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7BAMM5d013987
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:22:22 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BANBXR244920
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:23:11 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BANAnw001582
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:23:11 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When using fallocate the buffer_heads are marked unwritten
and unmapped. We need to map them in the writepages after
a get_block. Otherwise we split the uninit extents,
but never write the content to disk.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c96cc0b..7a66bba 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1732,6 +1732,13 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 				if (buffer_delay(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_delay(bh);
+					bh->b_bdev = inode->i_sb->s_bdev;
+				} else if (buffer_unwritten(bh)) {
+					bh->b_blocknr = pblock;
+					clear_buffer_unwritten(bh);
+					set_buffer_mapped(bh);
+					set_buffer_new(bh);
+					bh->b_bdev = inode->i_sb->s_bdev;
 				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
 
@@ -1805,7 +1812,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		 * If blocks are delayed marked, we need to
 		 * put actual blocknr and drop delayed bit
 		 */
-		if (buffer_delay(lbh))
+		if (buffer_delay(lbh) || buffer_unwritten(lbh))
 			mpage_put_bnr_to_bhs(mpd, next, &new);
 
 		/* go for the remaining blocks */
@@ -1814,7 +1821,8 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	}
 }
 
-#define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | (1 << BH_Delay))
+#define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
+		(1 << BH_Delay) | (1 << BH_Unwritten))
 
 /*
  * mpage_add_bh_to_extent - try to add one more block to extent of blocks
-- 
1.6.0.rc0.42.g186458.dirty

