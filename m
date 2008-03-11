From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Return EIO if new block allocation returns block from system zone.
Date: Tue, 11 Mar 2008 14:57:10 +0530
Message-ID: <1205227630-14683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49439 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYCKJ1P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 05:27:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2B9QZ9Z007748
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 20:26:35 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B9UrRp160060
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 20:30:53 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2B9RA0L021493
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 20:27:11 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block allocator gets blocks out of system zone ext4 calls
ext4_error. But if the file system is mounted with errors=continue
return with -EIO.

System zone is the block range mapping block bitmap, inode bitmap and inode
table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/mballoc.c |   17 +++++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1e6c5dc..4a8cb53 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1779,7 +1779,7 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from %llu, length %lu",
 			     ret_block, num);
-		goto out;
+		goto io_error;
 	}
 
 	performed_allocation = 1;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 340daae..2eb8bd2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3079,9 +3079,11 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 			in_range(block, ext4_inode_table(sb, gdp),
 				EXT4_SB(sb)->s_itb_per_group)) {
 
+		err = -EIO;
 		ext4_error(sb, __func__,
 			   "Allocating block in system zone - block = %llu",
 			   block);
+		goto out_err;
 	}
 #ifdef AGGRESSIVE_CHECK
 	{
@@ -4345,10 +4347,15 @@ repeat:
 	}
 
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
-		ext4_mb_mark_diskspace_used(ac, handle);
-		*errp = 0;
-		block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
-		ar->len = ac->ac_b_ex.fe_len;
+		*errp = ext4_mb_mark_diskspace_used(ac, handle);
+		if (*errp) {
+			ac->ac_b_ex.fe_len = 0;
+			ar->len = 0;
+			ext4_mb_show_ac(ac);
+		} else {
+			block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
+			ar->len = ac->ac_b_ex.fe_len;
+		}
 	} else {
 		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
 		if (freed)
@@ -4535,6 +4542,8 @@ do_more:
 		ext4_error(sb, __func__,
 			   "Freeing blocks in system zone - "
 			   "Block = %lu, count = %lu", block, count);
+		/* err = 0. ext4_std_error should be a no op */
+		goto error_return;
 	}
 
 	BUFFER_TRACE(bitmap_bh, "getting write access");
-- 
1.5.4.4.481.g5075.dirty

