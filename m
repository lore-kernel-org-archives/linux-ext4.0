From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 3/3] ext4: Take read  lock during overwrite case.
Date: Mon,  3 Dec 2007 15:55:57 +0530
Message-ID: <1196677557-10403-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1196677557-10403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1196677557-10403-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1196677557-10403-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51804 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752067AbXLCK0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 05:26:15 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id lB3APwfX023680
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:55:58 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3APvwM3473562
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:55:58 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id lB3APvV0029962
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 10:25:57 GMT
In-Reply-To: <1196677557-10403-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we are overwriting a file and not actually allocating new file system
blocks we need to take only the read lock on i_data_sem.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8aa8855..4489bfd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -894,11 +894,31 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			int create, int extend_disksize)
 {
 	int retval;
-	if (create) {
-		down_write((&EXT4_I(inode)->i_data_sem));
+	/*
+	 * Try to see if we can get  the block without requesting
+	 * for new file system block.
+	 */
+	down_read((&EXT4_I(inode)->i_data_sem));
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
+				bh, 0, 0);
 	} else {
-		down_read((&EXT4_I(inode)->i_data_sem));
+		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks,
+				bh, 0, 0);
 	}
+	up_read((&EXT4_I(inode)->i_data_sem));
+	if (!create || (retval > 0))
+		return retval;
+
+	/*
+	 * We need to allocate new blocks which will result
+	 * in i_data update
+	 */
+	down_write((&EXT4_I(inode)->i_data_sem));
+	/*
+	 * We need to check for EXT4 here because migrate
+	 * could have changed the inode type in between
+	 */
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 				bh, create, extend_disksize);
@@ -906,11 +926,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks,
 				bh, create, extend_disksize);
 	}
-	if (create) {
-		up_write((&EXT4_I(inode)->i_data_sem));
-	} else {
-		up_read((&EXT4_I(inode)->i_data_sem));
-	}
+	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
 }
 static int ext4_get_block(struct inode *inode, sector_t iblock,
-- 
1.5.3.6.985.g65c6a4-dirty
