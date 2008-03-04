From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix fallocate error path.
Date: Tue,  4 Mar 2008 18:10:48 +0530
Message-ID: <1204634448-16402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:35099 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755495AbYCDMkv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:40:51 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m24Cem3i011805
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:10:48 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m24Cemkw864358
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:10:48 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m24CelJs017978
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 12:40:48 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Put the old extent details back if we fail to split the
uninitialized extent.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 39d5315..d315cc1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2152,7 +2152,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 						ext4_lblk_t iblock,
 						unsigned long max_blocks)
 {
-	struct ext4_extent *ex, newex;
+	struct ext4_extent *ex, newex, orig_ex;
 	struct ext4_extent *ex1 = NULL;
 	struct ext4_extent *ex2 = NULL;
 	struct ext4_extent *ex3 = NULL;
@@ -2171,6 +2171,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	allocated = ee_len - (iblock - ee_block);
 	newblock = iblock - ee_block + ext_pblock(ex);
 	ex2 = ex;
+	orig_ex.ee_block = ex->ee_block;
+	orig_ex.ee_len   = cpu_to_le16(ee_len);
+	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -2199,13 +2202,25 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
 		err = ext4_ext_insert_extent(handle, inode, path, ex3);
-		if (err)
+		if (err) {
+			ex->ee_block = orig_ex.ee_block;
+			ex->ee_len   = orig_ex.ee_len;
+			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_mark_uninitialized(ex);
+			ext4_ext_dirty(handle, inode, path + depth);
 			goto out;
+		}
 		/*
 		 * The depth, and hence eh & ex might change
 		 * as part of the insert above.
 		 */
 		newdepth = ext_depth(inode);
+		/*
+		 * update the extent length after successfull insert of the
+		 * split extent
+		 */
+		orig_ex.ee_len = cpu_to_le16(ee_len -
+						ext4_ext_get_actual_len(ex3));
 		if (newdepth != depth) {
 			depth = newdepth;
 			ext4_ext_drop_refs(path);
@@ -2280,6 +2295,13 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	goto out;
 insert:
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
+	if (err) {
+		ex->ee_block = orig_ex.ee_block;
+		ex->ee_len   = orig_ex.ee_len;
+		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_mark_uninitialized(ex);
+		ext4_ext_dirty(handle, inode, path + depth);
+	}
 out:
 	return err ? err : allocated;
 }
-- 
1.5.4.3.422.g34cd6.dirty

