From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] ext4: general handling preallocated blocks in delayed
	allocation
Date: Fri, 22 Feb 2008 12:36:39 -0800
Message-ID: <1203712599.3639.55.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55717 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762271AbYBVUgz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 15:36:55 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1MKanPK026331
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:36:49 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MKanAs220392
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:36:49 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MKanJk011035
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:36:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With delayed allocation, get_block() is only doing block map at the
write_begin() time. If the blocks are prea-allocated, the result bh
is not mapped, but the blocks are actually being allocated. 
delalloc should not treat it as other regular unallocated area, thus
mark it as need block allocation later, and doing extra reservation
incorrectly.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

Index: linux-2.6.25-rc2/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/inode.c	2008-02-19 14:57:00.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/inode.c	2008-02-19 15:04:56.000000000 -0800
@@ -1401,20 +1401,18 @@ static int ext4_da_get_block_prep(struct
 	 * XXX: when the filesystem has a lot of free blocks, we could
 	 * reserve even allocated blocks to save this lookup */
 	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
-	if (ret >= 0) {
-		if (buffer_mapped(bh_result)) {
-			bh_result->b_size = (ret << inode->i_blkbits);
-		} else {
-			/* the block isn't allocated yet, let's reserve space */
-			/* XXX: call reservation here */
-			/*
-			 * XXX: __block_prepare_write() unmaps passed block,
-			 * is it OK?
-			 */
-			map_bh(bh_result, inode->i_sb, 0);
-			set_buffer_new(bh_result);
-			set_buffer_delay(bh_result);
-		}
+	if (ret == 0) {
+		/* the block isn't allocated yet, let's reserve space */
+		/* XXX: call reservation here */
+		/*
+		 * XXX: __block_prepare_write() unmaps passed block,
+		 * is it OK?
+		 */
+		map_bh(bh_result, inode->i_sb, 0);
+		set_buffer_new(bh_result);
+		set_buffer_delay(bh_result);
+	} else if ((ret > 0) && (buffer_mapped(bh_result))) {
+		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
 	}
 
