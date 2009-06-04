From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/4] ext4: Check for only delay or unwritten buffer_heads
Date: Thu,  4 Jun 2009 11:40:02 +0530
Message-ID: <1244095805-17015-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36303 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZFDGKa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 02:10:30 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5468IgT023895
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:08:18 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n546AJZU798934
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:10:19 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n546AJuQ012616
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:10:19 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Even with changes to make pages writeprotech on truncate/i_size update we
can still see buffer_heads which are not mapped in the writepage
callback. Consider the below case.

1) truncate(f, 1024)
2) mmap(f, 0, 4096)
3) a[0] = 'a'
4) truncate(f, 4096)
5) writepage(...)

Now if we get a writepage callback immediately after (4) and before an
attempt to write at any other offset via mmap address (which implies we
are yet to get a pagefault and do a get_block) what we would have is the
page which is dirty have first block allocated and the other three
buffer_heads unmapped.

In the above case the writepage should go ahead and try to write
the first blocks and clear the page_dirty flag. Because the further
attempt to write to the page will again create a fault and result in
allocating blocks and marking page dirty. Also if we don't write
any other offset via mmap address we would still have written the first
block to the disk and rest of the space will be considered as a hole.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b7fd336..6b61ee5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2225,15 +2225,9 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	return;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
 {
-	/*
-	 * unmapped buffer is possible for holes.
-	 * delay buffer is possible with delayed allocation.
-	 * We also need to consider unwritten buffer as unmapped.
-	 */
-	return (!buffer_mapped(bh) || buffer_delay(bh) ||
-				buffer_unwritten(bh)) && buffer_dirty(bh);
+	return (buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh);
 }
 
 /*
@@ -2320,7 +2314,7 @@ static int __mpage_da_writepage(struct page *page,
 			 * Otherwise we won't make progress
 			 * with the page in ext4_da_writepage
 			 */
-			if (ext4_bh_unmapped_or_delay(NULL, bh)) {
+			if (ext4_bh_delay_or_unwritten(NULL, bh)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       bh->b_size,
 						       bh->b_state);
@@ -2437,7 +2431,6 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 	 * so call get_block_wrap with create = 0
 	 */
 	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks, bh_result, 0);
-	BUG_ON(create && ret == 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -2473,7 +2466,7 @@ static int ext4_da_writepage(struct page *page,
 	if (page_has_buffers(page)) {
 		page_bufs = page_buffers(page);
 		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-					ext4_bh_unmapped_or_delay)) {
+					ext4_bh_delay_or_unwritten)) {
 			/*
 			 * We don't want to do  block allocation
 			 * So redirty the page and return
@@ -2506,7 +2499,7 @@ static int ext4_da_writepage(struct page *page,
 			page_bufs = page_buffers(page);
 			/* check whether all are mapped and non delay */
 			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-						ext4_bh_unmapped_or_delay)) {
+						ext4_bh_delay_or_unwritten)) {
 				redirty_page_for_writepage(wbc, page);
 				unlock_page(page);
 				return 0;
@@ -3182,7 +3175,7 @@ static int ext4_normal_writepage(struct page *page,
 		 * happily proceed with mapping them and writing the page.
 		 */
 		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_unmapped_or_delay));
+					ext4_bh_delay_or_unwritten));
 	}
 
 	if (!ext4_journal_current_handle())
@@ -3274,7 +3267,7 @@ static int ext4_journalled_writepage(struct page *page,
 		 * happily proceed with mapping them and writing the page.
 		 */
 		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-					ext4_bh_unmapped_or_delay));
+					ext4_bh_delay_or_unwritten));
 	}
 
 	if (ext4_journal_current_handle())
-- 
1.6.3.1.244.gf9275

