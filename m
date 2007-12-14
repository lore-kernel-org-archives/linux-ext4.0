From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ext4: Take read  lock during overwrite case.
Date: Fri, 14 Dec 2007 21:18:17 +0530
Message-ID: <1197647297-7009-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1197647297-7009-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1197647297-7009-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1197647297-7009-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58068 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbXLNPsv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2007 10:48:51 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBEFmkBn031434
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:48:46 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBEFqQVV244662
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:52:26 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBEFmW5X014876
	for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2007 02:48:33 +1100
In-Reply-To: <1197647297-7009-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we are overwriting a file and not actually allocating new file system
blocks we need to take only the read lock on i_data_sem.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 669d560..7dda65d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -895,11 +895,31 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
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
@@ -907,11 +927,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
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
1.5.4.rc0-dirty
