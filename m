From: Mingming Cao <cmm@us.ibm.com>
Subject: ext2: Fix ext2 block reservation early ENOSPC issue
Date: Thu, 28 Aug 2008 16:05:08 -0700
Message-ID: <1219964708.6384.73.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54908 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYH1XFJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 19:05:09 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SN58VZ013259
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 19:05:08 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SN58fp174436
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 19:05:08 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SN58mV018567
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 19:05:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

ext2: Fix ext2 nomballoc allocator for ENOSPC

We could run into ENOSPC error on ext2, even when there is free blocks
on the filesystem.

The problem is triggered in the case the goal block group has 0 free blocks
, and the rest block groups are skipped due to the check of "free_blocks 
< windowsz/2". Current code could fall back to non reservation allocation
to prevent early ENOSPC after examing all the block groups with reservation on
, but this code was  bypassed if the reservation window is turned off already,
which is true in this case.

This patch fixed two issues:
1) We don't need to turn off block reservation if the goal block group has 
0 free blocks left and continue search for the rest of block groups.

Current code the intention is to turn off the block reservation if the
 goal allocation group has a few (some) free blocks left (not enough 
for make the desired reservation window),to try to allocation in the
 goal block group, to get better locality. But if the goal blocks have 
0 free blocks,  it should leave the block reservation on, and continues
search for the next block groups,rather than turn off block reservation
completely.

2) we don't need to check the window size if the block reservation is off. 

The problem was originally found and fixed in ext4.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext2/balloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc3/fs/ext2/balloc.c
===================================================================
--- linux-2.6.27-rc3.orig/fs/ext2/balloc.c	2008-08-12 18:55:39.000000000 -0700
+++ linux-2.6.27-rc3/fs/ext2/balloc.c	2008-08-28 15:51:59.000000000 -0700
@@ -1295,6 +1295,7 @@
 	 * turn off reservation for this allocation
 	 */
 	if (my_rsv && (free_blocks < windowsz)
+		&& (free_blocks > 0)
 		&& (rsv_is_empty(&my_rsv->rsv_window)))
 		my_rsv = NULL;
 
@@ -1332,7 +1333,7 @@
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <= (windowsz/2))
+		if (my_rsv && (free_blocks <= (windowsz/2)))
 			continue;
 
 		brelse(bitmap_bh);


