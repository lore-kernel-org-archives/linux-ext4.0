From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 11/42] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Thu,  9 Oct 2008 00:05:29 -0400
Message-ID: <1223525160-9887-12-git-send-email-tytso@mit.edu>
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54454 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757252AbYJIEGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:05 -0400
In-Reply-To: <1223525160-9887-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We run into ENOSPC error on nonmballoc ext4, even when there is free blocks
on the filesystem.

The patch includes two changes:

a) Set reservation to NULL if we trying to allocate near group_target_block
from the goal group if the free block in the group is less than windows.
This should give us a better chance to allocate near group_target_block.
This also ensures that if we are not allocating near group_target_block
then we don't trun off reservation. This should enable us to allocate
with reservation from other groups that have large free blocks count.

b) we don't need to check the window size if the block reservation is off.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e4274aa..87b660b 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1804,15 +1804,17 @@ retry_alloc:
 		goto io_error;
 
 	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
-	/*
-	 * if there is not enough free blocks to make a new resevation
-	 * turn off reservation for this allocation
-	 */
-	if (my_rsv && (free_blocks < windowsz)
-		&& (rsv_is_empty(&my_rsv->rsv_window)))
-		my_rsv = NULL;
 
 	if (free_blocks > 0) {
+		/*
+		 * try to allocate with group target block
+		 * in the goal group. If we have low free_blocks
+		 * count turn off reservation
+		 */
+		if (my_rsv && (free_blocks < windowsz)
+			&& (rsv_is_empty(&my_rsv->rsv_window)))
+			my_rsv = NULL;
+
 		bitmap_bh = ext4_read_block_bitmap(sb, group_no);
 		if (!bitmap_bh)
 			goto io_error;
@@ -1845,7 +1847,7 @@ retry_alloc:
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <= (windowsz/2))
+		if (my_rsv && (free_blocks <= (windowsz/2)))
 			continue;
 
 		brelse(bitmap_bh);
-- 
1.5.6.1.205.ge2c7.dirty

