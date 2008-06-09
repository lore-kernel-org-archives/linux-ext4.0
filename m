From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2] ext4: Update i_disksize correctly in ext4_get_block
Date: Mon,  9 Jun 2008 15:33:03 +0530
Message-ID: <1213005784-10539-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54382 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714AbYFIKD0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 06:03:26 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m59A35fK015855
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:33:05 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m59A2R1M864306
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:32:27 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m59A34mE019702
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:33:04 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With delayed allocation we delay the allocation of blocks
and request for blocks in multiple chunks. We should not
update i_disksize to inode.i_size unless we are allocating
blocks corresponding to the end of file.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   10 ++++++++--
 fs/ext4/inode.c   |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dae3b60..27cfd30 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2698,6 +2698,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	int err = 0, depth, ret;
 	unsigned long allocated = 0;
 	struct ext4_allocation_request ar;
+	loff_t disksize;
 
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%lu requested for inode %u\n",
@@ -2885,8 +2886,13 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		goto out2;
 	}
 
-	if (extend_disksize && inode->i_size > EXT4_I(inode)->i_disksize)
-		EXT4_I(inode)->i_disksize = inode->i_size;
+	if (extend_disksize) {
+		disksize = ((loff_t) iblock + ar.len) << inode->i_blkbits;
+		if (disksize > i_size_read(inode))
+			disksize = i_size_read(inode);
+		if (disksize > EXT4_I(inode)->i_disksize)
+			EXT4_I(inode)->i_disksize = disksize;
+	}
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a51d5f4..5265933 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -846,6 +846,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	int count = 0;
 	ext4_fsblk_t first_block = 0;
+	loff_t disksize;
 
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
@@ -921,8 +922,13 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 * protect it if you're about to implement concurrent
 	 * ext4_get_block() -bzzz
 	*/
-	if (!err && extend_disksize && inode->i_size > ei->i_disksize)
-		ei->i_disksize = inode->i_size;
+	if (!err && extend_disksize) {
+		disksize = ((loff_t) iblock + count) << inode->i_blkbits;
+		if (disksize > i_size_read(inode))
+			disksize = i_size_read(inode);
+		if (disksize > ei->i_disksize)
+			ei->i_disksize = disksize;
+	}
 	if (err)
 		goto cleanup;
 
-- 
1.5.6.rc2.15.g457bb.dirty

