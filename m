From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 10/11] ext4: Add inode to journal handle after block allocation for ordered mode
Date: Wed, 27 Aug 2008 20:58:35 +0530
Message-ID: <1219850916-8986-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:60815 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755583AbYH0P3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:29:17 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7RFTFcq005793
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:15 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RFTFsv1785882
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:15 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7RFTEEg022080
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:15 +0530
In-Reply-To: <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This make sure when we have block allocation failure
we don't have inode inode added to the journal handle.
So journal commit will not include the inode for which
block allocation failed.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |   36 +++++++++++++++---------------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a52fde3..9a0239e 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -2061,7 +2061,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	/*
 	 * Account for the allocated meta blocks
 	 */
-	if (!(*errp)) {
+	if (!(*errp) && EXT4_I(inode)->i_delalloc_reserved_flag) {
 		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 		EXT4_I(inode)->i_allocated_meta_blocks += *count;
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3ef0822..24381bb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1591,6 +1591,7 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 		 */
 		mdb_free = EXT4_I(inode)->i_reserved_meta_blocks;
 		EXT4_I(inode)->i_reserved_meta_blocks = 0;
+		EXT4_I(inode)->i_allocated_meta_blocks = 0;
 
 	}
 	release = to_free + mdb_free;
@@ -2169,18 +2170,23 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle_t *handle = NULL;
 
 	handle = ext4_journal_current_handle();
-	if (!handle) {
-		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, 0, 0, 0);
-		BUG_ON(!ret);
-	} else {
-		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
-	}
-
+	BUG_ON(!handle);
+	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+			bh_result, create, 0, EXT4_DELALLOC_RSVED);
 	if (ret > 0) {
+
 		bh_result->b_size = (ret << inode->i_blkbits);
 
+		if (ext4_should_order_data(inode)) {
+			ret = ext4_jbd2_file_inode(handle, inode);
+			if (ret)
+				/*
+				 * Failed to add inode for ordered
+				 * mode. Don't update file size
+				 */
+				return ret;
+		}
+
 		/*
 		 * Update on-disk size along with block allocation
 		 * we don't use 'extend_disksize' as size may change
@@ -2406,18 +2412,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 			dump_stack();
 			goto out_writepages;
 		}
-		if (ext4_should_order_data(inode)) {
-			/*
-			 * With ordered mode we need to add
-			 * the inode to the journal handl
-			 * when we do block allocation.
-			 */
-			ret = ext4_jbd2_file_inode(handle, inode);
-			if (ret) {
-				ext4_journal_stop(handle);
-				goto out_writepages;
-			}
-		}
 
 		to_write -= wbc->nr_to_write;
 		ret = mpage_da_writepages(mapping, wbc,
-- 
1.6.0.1.90.g27a6e

