From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc
Date: Thu,  4 Dec 2008 19:34:25 +0530
Message-ID: <1228399465-6749-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:33168 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbYLDOEf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 09:04:35 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB4E4VK7021418
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 19:34:31 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB4E3fYJ4448480
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 19:33:41 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB4E4T2q012265
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 19:34:30 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With nodelalloc option we need to update the dirty block counter on
block allocation failure. This is needed because we increment the
dirty block counter early in the block allocation phase. Without
the patch s_dirty_blocks_counter goes wrong so that filesystem's
free blocks decreases incorrectly.

Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bacc2f4..22d31c3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4550,7 +4550,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	}
 	if (ar->len == 0) {
 		*errp = -EDQUOT;
-		return 0;
+		goto out3;
 	}
 	inquota = ar->len;
 
@@ -4623,6 +4623,13 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 out1:
 	if (ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
+out3:
+	if (!ar->len) {
+		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
+			/* release all the reserved blocks if non delalloc */
+			percpu_counter_sub(&sbi->s_dirtyblocks_counter,
+						reserv_blks);
+	}
 
 	return block;
 }
-- 
1.6.1.rc1

