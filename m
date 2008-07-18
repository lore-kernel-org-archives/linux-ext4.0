From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix data corruption when writing to prealloc area
Date: Fri, 18 Jul 2008 18:47:01 +0530
Message-ID: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:38744 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbYGRNRL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 09:17:11 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6IDHWw4012573
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 23:17:32 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IDH7124694216
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 23:17:07 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6IDH6RM006311
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 23:17:07 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to recalucate the path information on extent insert
even if depth doesn't change.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7bdaeec..9c8541e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2462,7 +2462,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		unsigned int newdepth;
 		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
 		if (allocated <= EXT4_EXT_ZERO_LEN) {
-			/* Mark first half uninitialized.
+			/*
+			 * iblock == ee_block is handled by the zerouout
+			 * at the beginning.
+			 * Mark first half uninitialized.
 			 * Mark second half initialized and zero out the
 			 * initialized extent
 			 */
@@ -2485,7 +2488,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				ex->ee_len   = orig_ex.ee_len;
 				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
-				/* zeroed the full extent */
+				/* blocks available from iblock */
 				return allocated;
 
 			} else if (err)
@@ -2513,6 +2516,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 					err = PTR_ERR(path);
 					return err;
 				}
+				/* get the second half extent details */
 				ex = path[depth].p_ext;
 				err = ext4_ext_get_access(handle, inode,
 								path + depth);
@@ -2542,6 +2546,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zeroed the full extent */
+			/* blocks available from iblock */
 			return allocated;
 
 		} else if (err)
@@ -2557,23 +2562,22 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		 */
 		orig_ex.ee_len = cpu_to_le16(ee_len -
 						ext4_ext_get_actual_len(ex3));
-		if (newdepth != depth) {
-			depth = newdepth;
-			ext4_ext_drop_refs(path);
-			path = ext4_ext_find_extent(inode, iblock, path);
-			if (IS_ERR(path)) {
-				err = PTR_ERR(path);
-				goto out;
-			}
-			eh = path[depth].p_hdr;
-			ex = path[depth].p_ext;
-			if (ex2 != &newex)
-				ex2 = ex;
-
-			err = ext4_ext_get_access(handle, inode, path + depth);
-			if (err)
-				goto out;
+		depth = newdepth;
+		ext4_ext_drop_refs(path);
+		path = ext4_ext_find_extent(inode, iblock, path);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out;
 		}
+		eh = path[depth].p_hdr;
+		ex = path[depth].p_ext;
+		if (ex2 != &newex)
+			ex2 = ex;
+
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (err)
+			goto out;
+
 		allocated = max_blocks;
 
 		/* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
@@ -2591,6 +2595,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
 			/* zero out the first half */
+			/* blocks available from iblock */
 			return allocated;
 		}
 	}
-- 
1.5.6.3.439.g1e10.dirty

