From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/6] ext4: cleanup ext4_ext_grow_indepth code
Date: Fri, 21 Oct 2011 01:08:54 +0400
Message-ID: <1319144939-28801-2-git-send-email-dmonakhov@openvz.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1JTVIt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 17:08:49 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so4002126bkb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 14:08:48 -0700 (PDT)
In-Reply-To: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently code make an impression what grow procedure is very complicated
and some mythical paths, blocks are involved. But in fact grow in depth
it relatively simple procedure:
 1) Just create new meta block and copy roots content to it
 2) Convert root from extent to index if old depth == 0
 3) update root block pointer

This patch does:
 - Reorganize code to make it more self explanatory
 - Do not pass path parameter to new_meta_block() in order to
   provoke allocation from inode's group because top-level block
   should site closer to it's inode, but not to leaf data block.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   41 +++++++++++++++--------------------------
 1 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2759357..8eb3656 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1045,16 +1045,14 @@ cleanup:
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 				 unsigned int flags,
-				 struct ext4_ext_path *path,
 				 struct ext4_extent *newext)
 {
-	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
 	struct buffer_head *bh;
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_meta_block(handle, inode, path,
+	newblock = ext4_ext_new_meta_block(handle, inode, NULL,
 		newext, &err, flags);
 	if (newblock == 0)
 		return err;
@@ -1074,7 +1072,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	}
 
 	/* move top-level index/leaf into new block */
-	memmove(bh->b_data, curp->p_hdr, sizeof(EXT4_I(inode)->i_data));
+	memmove(bh->b_data, EXT4_I(inode)->i_data,
+		sizeof(EXT4_I(inode)->i_data));
 
 	/* set size of new block */
 	neh = ext_block_hdr(bh);
@@ -1092,32 +1091,23 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	if (err)
 		goto out;
 
-	/* create index in new top-level index: num,max,pointer */
-	err = ext4_ext_get_access(handle, inode, curp);
-	if (err)
-		goto out;
-
-	curp->p_hdr->eh_magic = EXT4_EXT_MAGIC;
-	curp->p_hdr->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode, 0));
-	curp->p_hdr->eh_entries = cpu_to_le16(1);
-	curp->p_idx = EXT_FIRST_INDEX(curp->p_hdr);
-
-	if (path[0].p_hdr->eh_depth)
-		curp->p_idx->ei_block =
-			EXT_FIRST_INDEX(path[0].p_hdr)->ei_block;
-	else
-		curp->p_idx->ei_block =
-			EXT_FIRST_EXTENT(path[0].p_hdr)->ee_block;
-	ext4_idx_store_pblock(curp->p_idx, newblock);
-
+	/* Update top-level index: num,max,pointer */
 	neh = ext_inode_hdr(inode);
+	neh->eh_entries = cpu_to_le16(1);
+	ext4_idx_store_pblock(EXT_FIRST_INDEX(neh), newblock);
+	if (neh->eh_depth == 0) {
+		/* Root extent block becomes index block */
+		neh->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode, 0));
+		EXT_FIRST_INDEX(neh)->ei_block =
+			EXT_FIRST_EXTENT(neh)->ee_block;
+	}
 	ext_debug("new root: num %d(%d), lblock %d, ptr %llu\n",
 		  le16_to_cpu(neh->eh_entries), le16_to_cpu(neh->eh_max),
 		  le32_to_cpu(EXT_FIRST_INDEX(neh)->ei_block),
 		  ext4_idx_pblock(EXT_FIRST_INDEX(neh)));
 
-	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
-	err = ext4_ext_dirty(handle, inode, curp);
+	neh->eh_depth = cpu_to_le16(neh->eh_depth + 1);
+	ext4_mark_inode_dirty(handle, inode);
 out:
 	brelse(bh);
 
@@ -1165,8 +1155,7 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, flags,
-					    path, newext);
+		err = ext4_ext_grow_indepth(handle, inode, flags, newext);
 		if (err)
 			goto out;
 
-- 
1.7.1

