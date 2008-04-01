From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Cache the correct extent length for uninit extent.
Date: Tue,  1 Apr 2008 15:34:03 +0530
Message-ID: <1207044243-21455-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:52096 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbYDAKEP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2008 06:04:15 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m31A43Yg027066
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 15:34:03 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m31A44vQ1019924
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 15:34:04 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m31A43dI014642
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 10:04:03 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we convert uninitialized extent to initialized extent
we need to make sure we return the number of blocks in the
extent from the file system block corresponding to logical
file block. Other wise we cache wrong extent details and this
results in file system corruption.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 964d2c1..30f0f99 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2264,7 +2264,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
-		return le16_to_cpu(ex->ee_len);
+		/* zeroed the full extent */
+		return allocated;
 	}
 
 	/* ex1: ee_block to iblock - 1 : uninitialized */
@@ -2309,11 +2310,44 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				ex->ee_len   = orig_ex.ee_len;
 				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
-				return le16_to_cpu(ex->ee_len);
+				/* zeroed the full extent */
+				return allocated;
 
 			} else if (err)
 				goto fix_extent_len;
 
+			/* We need to zero out the second half because
+			 * fallocate request can update file size and
+			 * converting the second half to initialized extent
+			 * implies that we can leak some junk data to user
+			 * space
+			 */
+			err =  ext4_ext_zeroout(inode, ex3);
+			if (err) {
+				/*
+				 * We should actually mark the
+				 * second half as uninit and return error
+				 * Insert would have changed the extent
+				 */
+				depth = ext_depth(inode);
+				ext4_ext_drop_refs(path);
+				path = ext4_ext_find_extent(inode,
+								iblock, path);
+				if (IS_ERR(path)) {
+					err = PTR_ERR(path);
+					return err;
+				}
+				ex = path[depth].p_ext;
+				err = ext4_ext_get_access(handle, inode,
+								path + depth);
+				if (err)
+					return err;
+				ext4_ext_mark_uninitialized(ex);
+				ext4_ext_dirty(handle, inode, path + depth);
+				return err;
+			}
+
+			/* zeroed the second half */
 			return allocated;
 		}
 		ex3 = &newex;
@@ -2331,7 +2365,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
-			return le16_to_cpu(ex->ee_len);
+			/* zeroed the full extent */
+			return allocated;
 
 		} else if (err)
 			goto fix_extent_len;
@@ -2379,7 +2414,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
-			return le16_to_cpu(ex->ee_len);
+			/* zero out the first half */
+			return allocated;
 		}
 	}
 	/*
@@ -2446,7 +2482,8 @@ insert:
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
-		return le16_to_cpu(ex->ee_len);
+		/* zero out the first half */
+		return allocated;
 	} else if (err)
 		goto fix_extent_len;
 out:
-- 
1.5.5.rc1.22.g17689.dirty

