From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Code cleanups
Date: Tue, 19 Aug 2008 12:18:14 +0530
Message-ID: <1219128494-10402-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219128494-10402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58459 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYHSGsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 02:48:24 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7J6lIME007277
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 16:47:18 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7J6mMXe4620342
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 16:48:22 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7J6mLJL018919
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 16:48:22 +1000
In-Reply-To: <1219128494-10402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

a) rename num to nrblocks to clearly indicate we expecting block count as argument.
b) renmae ext4_writepages_trans_blocks to ext4_da_writepages_trans_blocks to
indicate it is the delayed allocation writepages transaction credit.
c) Add some comments. remove some stale comments.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    8 ++++----
 fs/ext4/inode.c   |   14 ++++++++------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 73bb308..bf612a7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1893,7 +1893,7 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
  * When pass the actual path, the caller should calculate credits
  * under i_data_sem.
  */
-int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
+int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
 						struct ext4_ext_path *path)
 {
 	if (path) {
@@ -1912,12 +1912,12 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
 			 *  and other metadat blocks still need to be
 			 *  accounted.
 			 */
-			/* 1 one bitmap, 1 block group descriptor */
+			/* 1 bitmap, 1 block group descriptor */
 			ret = 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
 		}
 	}
 
-	return ext4_chunk_trans_blocks(inode, num);
+	return ext4_chunk_trans_blocks(inode, nrblocks);
 }
 
 /*
@@ -1931,7 +1931,7 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
  * If the nrblocks are discontiguous, they could cause
  * the whole tree split more than once, but this is really rare.
  */
-int ext4_ext_index_trans_blocks(struct inode *inode, int num, int chunk)
+int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	int index;
 	int depth = ext_depth(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a10f8e5..b32a723 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2321,16 +2321,18 @@ static int ext4_da_writepage(struct page *page,
  * a single extent allocation into a single transaction,
  * ext4_da_writpeages() will loop calling this before
  * the block allocation.
- *
- * The page vector size limited the max number of pages could
- * be writeout at a time. Based on this, the max blocks to pass to
- * get_block is calculated
  */
 
-static int ext4_writepages_trans_blocks(struct inode *inode)
+static int ext4_da_writepages_trans_blocks(struct inode *inode)
 {
 	int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
 
+	/*
+	 * With noextent format the journal credit needed to
+	 * insert nrblocks contiguous block is dependent on
+	 * number of contiguous block. So we will limit
+	 * number of contiguous block to a sane value
+	 */
 	if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
 	    (max_blocks > EXT4_MAX_TRANS_DATA))
 		max_blocks = EXT4_MAX_TRANS_DATA;
@@ -2387,7 +2389,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 		 * by delalloc
 		 */
 		BUG_ON(ext4_should_journal_data(inode));
-		needed_blocks = ext4_writepages_trans_blocks(inode);
+		needed_blocks = ext4_da_writepages_trans_blocks(inode);
 
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
-- 
1.6.0.2.g2ebc0

