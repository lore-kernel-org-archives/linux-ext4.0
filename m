From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Wed, 27 Aug 2008 20:58:34 +0530
Message-ID: <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51793 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755368AbYH0P3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:29:14 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7RFTCYf018336
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:12 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RFTCdu1372386
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:12 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7RFTB1Q022031
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:12 +0530
In-Reply-To: <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure we  set windowsize to zero if the free
blocks left is less that window size. Otherwise
we skip some group with low freeblock count during
block allocation

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 7fdc236..a52fde3 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1809,8 +1809,10 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	 * turn off reservation for this allocation
 	 */
 	if (my_rsv && (free_blocks < windowsz)
-		&& (rsv_is_empty(&my_rsv->rsv_window)))
+		&& (rsv_is_empty(&my_rsv->rsv_window))) {
 		my_rsv = NULL;
+		windowsz = 0;
+	}
 
 	if (free_blocks > 0) {
 		bitmap_bh = ext4_read_block_bitmap(sb, group_no);
-- 
1.6.0.1.90.g27a6e

