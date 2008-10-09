From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 12/42] ext4: Don't add the inode to journal handle until after the block is allocated
Date: Thu,  9 Oct 2008 00:05:30 -0400
Message-ID: <1223525160-9887-13-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54486 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757463AbYJIEGK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:10 -0400
In-Reply-To: <1223525160-9887-12-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Make sure we don't add the inode to the journal handle until after the
block allocation, so that a journal commit will not include the inode in
case of block allocation failure.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |   36 +++++++++++++++---------------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 87b660b..02068fa 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -2060,7 +2060,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	/*
 	 * Account for the allocated meta blocks
 	 */
-	if (!(*errp)) {
+	if (!(*errp) && EXT4_I(inode)->i_delalloc_reserved_flag) {
 		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 		EXT4_I(inode)->i_allocated_meta_blocks += *count;
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b1a6a73..b567e71 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2170,18 +2170,24 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
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
+			int retval;
+			retval = ext4_jbd2_file_inode(handle, inode);
+			if (retval)
+				/*
+				 * Failed to add inode for ordered
+				 * mode. Don't update file size
+				 */
+				return retval;
+		}
+
 		/*
 		 * Update on-disk size along with block allocation
 		 * we don't use 'extend_disksize' as size may change
@@ -2407,18 +2413,6 @@ restart_loop:
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
1.5.6.1.205.ge2c7.dirty

