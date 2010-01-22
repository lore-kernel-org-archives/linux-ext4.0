From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Handle -EDQUOT error on write
Date: Fri, 22 Jan 2010 13:27:43 +0530
Message-ID: <1264147063-18795-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54580 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0AVH5u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jan 2010 02:57:50 -0500
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id o0M7vlnY012127
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2010 13:27:47 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0M7vlOK1478692
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2010 13:27:47 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0M7vkMS021179
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2010 13:27:47 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to release the journal before we do a write_inode. Otherwise
we could deadlock.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..5af483a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1835,24 +1835,12 @@ repeat:
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
-		/* 
-		 * We tend to badly over-estimate the amount of
-		 * metadata blocks which are needed, so if we have
-		 * reserved any metadata blocks, try to force out the
-		 * inode and see if we have any better luck.
-		 */
-		if (md_reserved && retries++ <= 3)
-			goto retry;
+	if (vfs_dq_reserve_block(inode, md_needed + 1))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
 		vfs_dq_release_reservation_block(inode, md_needed + 1);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-		retry:
-			if (md_reserved)
-				write_inode_now(inode, (retries == 3));
 			yield();
 			goto repeat;
 		}
@@ -3032,7 +3020,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0;
+	int ret, retries = 0, quota_retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -3091,6 +3079,21 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
+
+	if ((ret == -EDQUOT) && (quota_retries <= 3)) {
+		/*
+		 * Since we do aggressive quota reservation may get no quota error
+		 * even though we may be having quota. Forcing the inode write will
+		 * free up the extra quota reserved. We do it only if we have
+		 * meta data blocks reserved because we do aggressive reservation only
+		 * for meta data blocks.
+		 */
+		if (EXT4_I(inode)->i_reserved_meta_blocks) {
+			write_inode_now(inode, (quota_retries == 3));
+			quota_retries++;
+			goto retry;
+		}
+	}
 out:
 	return ret;
 }
-- 
1.6.6.1.383.g5a9f

