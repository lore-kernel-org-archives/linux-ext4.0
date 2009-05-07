From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH for 2.6.31] ext4: Mark the unwritten buffer_head mapped during write_begin
Date: Thu,  7 May 2009 16:20:29 +0530
Message-ID: <1241693429-27588-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:54146 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761384AbZEGKuk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2009 06:50:40 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id n47AmbQL004687
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:48:37 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n47AoY6c381294
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:50:35 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n47AoYWk012825
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:50:34 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This avoid multiple get_block calls during write. Now that we have
unwritten buffer marked as mapped, we need to make sure writepages
will handle unwritten buffer_heads also.

With this patch we have the below:

ext4_ext_get_block returns unmapped, unwritten, buffer head when called with
create = 0 for prealloc space. This make sure we handle the read path and non
delalloc case correctly.  Even though the buffer head is marked unmapped we
have valid b_blocknr and b_bdev values in the buffer_head.

ext4_da_get_block_prep called for block resrevation will now return mapped,
unwritten, new buffer_head for prealloc space. This make sure we don't do
multiple get_block calls for write to same offset. Also marking it new make
sure sub-block zeroing of buffered writes happen correctly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    6 ++-
 fs/ext4/inode.c   |   81 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10b3028..abf5e5d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2865,6 +2865,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
 				goto out;
 			if (!create) {
+				if (allocated > max_blocks)
+					allocated = max_blocks;
 				/*
 				 * We have blocks reserved already.  We
 				 * return allocated blocks so that delalloc
@@ -2872,9 +2874,9 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				 * the buffer head will be unmapped so that
 				 * a read from the block returns 0s.
 				 */
-				if (allocated > max_blocks)
-					allocated = max_blocks;
 				set_buffer_unwritten(bh_result);
+				bh_result->b_bdev = inode->i_sb->s_bdev;
+				bh_result->b_blocknr = newblock;
 				goto out2;
 			}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f6d7e9b..b265b03 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1908,7 +1908,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
  * @logical - first logical block to start assignment with
  *
  * the function goes through all passed space and put actual disk
- * block numbers into buffer heads, dropping BH_Delay
+ * block numbers into buffer heads, dropping BH_Delay and BH_Unwritten
  */
 static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 				 struct buffer_head *exbh)
@@ -1958,16 +1958,24 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 			do {
 				if (cur_logical >= logical + blocks)
 					break;
-				if (buffer_delay(bh)) {
-					bh->b_blocknr = pblock;
-					clear_buffer_delay(bh);
-					bh->b_bdev = inode->i_sb->s_bdev;
-				} else if (buffer_unwritten(bh)) {
-					bh->b_blocknr = pblock;
-					clear_buffer_unwritten(bh);
-					set_buffer_mapped(bh);
-					set_buffer_new(bh);
-					bh->b_bdev = inode->i_sb->s_bdev;
+
+				if (buffer_delay(bh) ||
+						buffer_unwritten(bh)) {
+
+					BUG_ON(bh->b_bdev != inode->i_sb->s_bdev);
+
+					if (buffer_delay(bh)) {
+						clear_buffer_delay(bh);
+						bh->b_blocknr = pblock;
+					} else {
+						/*
+						 * unwritten already should have
+						 * blocknr assigned. Verify that
+						 */
+						clear_buffer_unwritten(bh);
+						BUG_ON(bh->b_blocknr != pblock);
+					}
+
 				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
 
@@ -2109,7 +2117,8 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if ((mpd->b_state  & (1 << BH_Mapped)) &&
-	    !(mpd->b_state & (1 << BH_Delay)))
+		!(mpd->b_state & (1 << BH_Delay)) &&
+		!(mpd->b_state & (1 << BH_Unwritten)))
 		return 0;
 	new.b_state = 0;
 	new.b_blocknr = 0;
@@ -2248,6 +2257,17 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	return;
 }
 
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	/*
+	 * unmapped buffer is possible for holes.
+	 * delay buffer is possible with delayed allocation.
+	 * We also need to consider unwritten buffer as unmapped.
+	 */
+	return (!buffer_mapped(bh) || buffer_delay(bh) ||
+				buffer_unwritten(bh)) && buffer_dirty(bh);
+}
+
 /*
  * __mpage_da_writepage - finds extent of pages and blocks
  *
@@ -2332,8 +2352,7 @@ static int __mpage_da_writepage(struct page *page,
 			 * Otherwise we won't make progress
 			 * with the page in ext4_da_writepage
 			 */
-			if (buffer_dirty(bh) &&
-			    (!buffer_mapped(bh) || buffer_delay(bh))) {
+			if (ext4_bh_unmapped_or_delay(NULL, bh)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       bh->b_size,
 						       bh->b_state);
@@ -2361,6 +2380,14 @@ static int __mpage_da_writepage(struct page *page,
 /*
  * this is a special callback for ->write_begin() only
  * it's intention is to return mapped block or reserve space
+ *
+ * For delayed buffer_head we have BH_Mapped, BH_New, BH_Delay set.
+ * We also have b_blocknr = -1 and b_bdev initialized properly
+ *
+ * For unwritten buffer_head we have BH_Mapped, BH_New, BH_Unwritten set.
+ * We also have b_blocknr = physicalblock mapping unwritten extent and b_bdev
+ * initialized properly.
+ *
  */
 static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 				  struct buffer_head *bh_result, int create)
@@ -2392,15 +2419,16 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
-		/*
-		 * With sub-block writes into unwritten extents
-		 * we also need to mark the buffer as new so that
-		 * the unwritten parts of the buffer gets correctly zeroed.
-		 */
 		if (buffer_unwritten(bh_result)) {
-			bh_result->b_bdev = inode->i_sb->s_bdev;
+			/* a delayed write to unwritten bh should
+			 * be marked new and mapped. Mapped ensures
+			 * that we don't do get_block multiple times
+			 * when we write to the same offset and new
+			 * ensures that we do proper zero out for
+			 * partial write
+			 */
 			set_buffer_new(bh_result);
-			bh_result->b_blocknr = ~0;
+			set_buffer_mapped(bh_result);
 		}
 		ret = 0;
 	}
@@ -2408,15 +2436,6 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
-{
-	/*
-	 * unmapped buffer is possible for holes.
-	 * delay buffer is possible with delayed allocation
-	 */
-	return ((!buffer_mapped(bh) || buffer_delay(bh)) && buffer_dirty(bh));
-}
