From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] Ext4: Fix delalloc enospace handling counter update race
Date: Mon, 14 Jul 2008 09:28:17 -0700
Message-ID: <1216052897.7937.1.camel@mingming-laptop>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
	 <20080714010828.GD7938@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42049 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597AbYGNQ2l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2008 12:28:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EGUtbr024322
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 12:30:55 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EGSKj1220622
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 12:28:20 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EGSKcx015666
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 12:28:20 -0400
In-Reply-To: <20080714010828.GD7938@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Ext4: Fix delalloc enospace handling counter update race

From: Mingming Cao <cmm@us.ibm.com>

Ext4 delalloc reserve meta blocks ahead of time so later when real block
allocation fs will not short of free blocks for allocating meta blocks.
It keeps track of the real number of new allocated meta data blocks, so
after block allocation it will update how much meta data blocks still
need to be reserved for that inode.

Both per inode reserved metadata blocks and per-allocation allocated metablocks
are protected by the per inode delalloc reservation lock. The per-allocation
allocated metablocks counter should be protected by the i_data_sem as well,
so that it could avoid race with other block allocation to the same inode
in parallel. The patch moves the code under the i_data_sem protection.

Also in the case of truncate, we should not clear the per-allocation allocated
metablocks counter as that may be in-use by parallel allocation. The patch
only clear the per-allocation allocated metablocks when allocation is successfully returned.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6.26-rc9/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc9.orig/fs/ext4/inode.c	2008-07-14 08:54:25.000000000 -0700
+++ linux-2.6.26-rc9/fs/ext4/inode.c	2008-07-14 09:23:29.000000000 -0700
@@ -1060,8 +1060,18 @@ int ext4_get_blocks_wrap(handle_t *handl
 							~EXT4_EXT_MIGRATE;
 		}
 	}
-	if (flag)
+
+	if (flag) {
 		EXT4_I(inode)->i_delalloc_reserved_flag = 0;
+		/*
+		 * Update reserved blocks/metadata blocks
+		 * after successful block allocation
+		 * which were deferred till now
+		 */
+		if ((retval > 0) && buffer_delay(bh))
+			ext4_da_release_space(inode, retval, 0);
+	}
+
 	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
 }
@@ -1519,7 +1529,8 @@ void ext4_da_release_space(struct inode 
 
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	EXT4_I(inode)->i_allocated_meta_blocks = 0;
+	if (used)
+		EXT4_I(inode)->i_allocated_meta_blocks = 0;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
@@ -2005,10 +2016,6 @@ static int ext4_da_get_block_write(struc
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 
-		/* release reserved-but-unused meta blocks */
-		if (buffer_delay(bh_result))
-			ext4_da_release_space(inode, ret, 0);
