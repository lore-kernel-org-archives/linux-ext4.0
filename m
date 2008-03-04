From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: zero out small extents when writing to prealloc area.
Date: Tue,  4 Mar 2008 18:16:07 +0530
Message-ID: <1204634767-16918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:37062 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764518AbYCDMqJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 07:46:09 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m24Ck7GS015211
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:16:07 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m24Ck7NE1085440
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 18:16:07 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m24CkC74007179
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 12:46:13 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the preallocated area is small zero out the full extent
instead of splitting them. This should avoid the "write
every alternate block" problem that could grow the number
of extents dramatically.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 839caf2..dcdf92a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2210,6 +2210,8 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 	return ret;
 }
 
+#define EXT4_EXT_ZERO_LEN 7
+
 /*
  * This function is called by ext4_ext_get_blocks() if someone tries to write
  * to an uninitialized extent. It may result in splitting the uninitialized
@@ -2252,6 +2254,18 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
 		goto out;
+	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
+	if (ee_len <= 2*EXT4_EXT_ZERO_LEN) {
+		err =  ext4_ext_zeroout(inode, &orig_ex);
+		if (err)
+			goto fix_extent_len;
+		/* update the extent length and mark as initialized */
+		ex->ee_block = orig_ex.ee_block;
+		ex->ee_len   = orig_ex.ee_len;
+		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_dirty(handle, inode, path + depth);
+		return le16_to_cpu(ex->ee_len);
+	}
 
 	/* ex1: ee_block to iblock - 1 : uninitialized */
 	if (iblock > ee_block) {
@@ -2270,6 +2284,38 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	/* ex3: to ee_block + ee_len : uninitialised */
 	if (allocated > max_blocks) {
 		unsigned int newdepth;
+		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
+		if (allocated <= EXT4_EXT_ZERO_LEN) {
+			/* Mark first half uninitialized.
+			 * Mark second half initialized and zero out the
+			 * initialized extent
+			 */
+			ex->ee_block = orig_ex.ee_block;
+			ex->ee_len   = cpu_to_le16(ee_len - allocated);
+			ext4_ext_mark_uninitialized(ex);
+			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_dirty(handle, inode, path + depth);
+
+			ex3 = &newex;
+			ex3->ee_block = cpu_to_le32(iblock);
+			ext4_ext_store_pblock(ex3, newblock);
+			ex3->ee_len = cpu_to_le16(allocated);
+			err = ext4_ext_insert_extent(handle, inode, path, ex3);
+			if (err == -ENOSPC) {
+				err =  ext4_ext_zeroout(inode, &orig_ex);
+				if (err)
+					goto fix_extent_len;
+				ex->ee_block = orig_ex.ee_block;
+				ex->ee_len   = orig_ex.ee_len;
+				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+				ext4_ext_dirty(handle, inode, path + depth);
+				return le16_to_cpu(ex->ee_len);
+
+			} else if (err)
+				goto fix_extent_len;
+
+			return allocated;
+		}
 		ex3 = &newex;
 		ex3->ee_block = cpu_to_le32(iblock + max_blocks);
 		ext4_ext_store_pblock(ex3, newblock + max_blocks);
@@ -2318,6 +2364,23 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				goto out;
 		}
 		allocated = max_blocks;
+
+		/* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
+		 * to insert a extent in the middle zerout directly
+		 * otherwise give the extent a chance to merge to left
+		 */
+		if (le16_to_cpu(orig_ex.ee_len) <= EXT4_EXT_ZERO_LEN &&
+							iblock != ee_block) {
+			err =  ext4_ext_zeroout(inode, &orig_ex);
+			if (err)
+				goto fix_extent_len;
+			/* update the extent length and mark as initialized */
+			ex->ee_block = orig_ex.ee_block;
+			ex->ee_len   = orig_ex.ee_len;
+			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_dirty(handle, inode, path + depth);
+			return le16_to_cpu(ex->ee_len);
+		}
 	}
 	/*
 	 * If there was a change of depth as part of the
-- 
1.5.4.3.422.g34cd6.dirty

