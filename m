From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4: Fix ext4 old block reservation early ENOSPC issue
Date: Thu, 28 Aug 2008 16:02:36 -0700
Message-ID: <1219964556.6384.67.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso <tytso@mit.edu>, Aneesh Kumar <aneesh.kumar@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49902 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYH1XCh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 19:02:37 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SN2awW001005
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 19:02:36 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SN2asj185912
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:02:36 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SN2ZSX010412
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:02:36 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We run into ENOSPC error on nonmballoc ext4, even when there is free blocks
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

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.27-rc3/fs/ext4/balloc.c
===================================================================
--- linux-2.6.27-rc3.orig/fs/ext4/balloc.c	2008-08-28 12:41:55.000000000 -0700
+++ linux-2.6.27-rc3/fs/ext4/balloc.c	2008-08-28 14:40:43.000000000 -0700
@@ -1807,6 +1807,7 @@
 	 * turn off reservation for this allocation
 	 */
 	if (my_rsv && (free_blocks < windowsz)
+		&& (free_blocks > 0)
 		&& (rsv_is_empty(&my_rsv->rsv_window)))
 		my_rsv = NULL;
 
@@ -1843,7 +1844,7 @@
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <= (windowsz/2))
+		if (my_rsv && (free_blocks <= (windowsz/2)))
 			continue;
 
 		brelse(bitmap_bh);


