From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 16/30] ext4: snapshot block operation - move blocks to snapshot
Date: Mon,  9 May 2011 19:41:34 +0300
Message-ID: <1304959308-11122-17-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1EIQny (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:54 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:53 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Implementation of moving blocks into a snapshot file.
The move block command maps an allocated blocks to the snapshot file,
allocating only the indirect blocks when needed.
This mechanism is used to move-on-write data blocks to snapshot.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   62 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b930645..c3d4e7a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -676,6 +676,11 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			new_blocks[index++] = current_block++;
 			count--;
 		}
+		if (blks == 0 && target == 0) {
+			/* mapping data blocks */
+			*err = 0;
+			return 0;
+		}
 		if (count > 0) {
 			/*
 			 * save the new block number
@@ -777,10 +782,10 @@ failed_out:
  *	ext4_alloc_block() (normally -ENOSPC). Otherwise we set the chain
  *	as described above and return 0.
  */
-static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
-			     ext4_lblk_t iblock, int indirect_blks,
-			     int *blks, ext4_fsblk_t goal,
-			     ext4_lblk_t *offsets, Indirect *branch)
+static int ext4_alloc_branch_cow(handle_t *handle, struct inode *inode,
+			ext4_fsblk_t iblock, int indirect_blks,
+				  int *blks, ext4_fsblk_t goal,
+				  int *offsets, Indirect *branch, int flags)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -790,6 +795,22 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t new_blocks[4];
 	ext4_fsblk_t current_block;
 
+	if (SNAPMAP_ISMOVE(flags)) {
+		/* mapping snapshot block to block device block */
+		current_block = SNAPSHOT_BLOCK(iblock);
+		num = 0;
+		if (indirect_blks > 0) {
+			/* allocating only indirect blocks */
+			ext4_alloc_blocks(handle, inode, iblock, goal,
+					  indirect_blks, 0, new_blocks, &err);
+			if (err)
+				return err;
+		}
+		/* charge snapshot file owner for moved blocks */
+		dquot_alloc_block_nofail(inode, *blks);
+		num = *blks;
+		new_blocks[indirect_blks] = current_block;
+	} else
 	num = ext4_alloc_blocks(handle, inode, iblock, goal, indirect_blks,
 				*blks, new_blocks, &err);
 	if (err)
@@ -861,8 +882,11 @@ failed:
 	}
 	for (i = n+1; i < indirect_blks; i++)
 		ext4_free_blocks(handle, inode, NULL, new_blocks[i], 1, 0);
-
-	ext4_free_blocks(handle, inode, NULL, new_blocks[i], num, 0);
+	if (SNAPMAP_ISMOVE(flags) && num > 0)
+		/* don't charge snapshot file owner if move failed */
+		dquot_free_block(inode, num);
+	else if (num > 0)
+		ext4_free_blocks(handle, inode, NULL, new_blocks[i], num, 0);
 
 	return err;
 }
@@ -882,9 +906,8 @@ failed:
  * inode (->i_blocks, etc.). In case of success we end up with the full
  * chain to new block and return 0.
  */
-static int ext4_splice_branch(handle_t *handle, struct inode *inode,
-			      ext4_lblk_t block, Indirect *where, int num,
-			      int blks)
+static int ext4_splice_branch_cow(handle_t *handle, struct inode *inode,
+		long block, Indirect *where, int num, int blks, int flags)
 {
 	int i;
 	int err = 0;
@@ -951,8 +974,12 @@ err_out:
 		ext4_free_blocks(handle, inode, where[i].bh, 0, 1,
 				 EXT4_FREE_BLOCKS_FORGET);
 	}
-	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(where[num].key),
-			 blks, 0);
+	if (SNAPMAP_ISMOVE(flags))
+		/* don't charge snapshot file owner if move failed */
+		dquot_free_block(inode, blks);
+	else
+		ext4_free_blocks(handle, inode, NULL,
+				 le32_to_cpu(where[num].key), blks, 0);
 
 	return err;
 }
@@ -1098,9 +1125,11 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	/*
 	 * Block out ext4_truncate while we alter the tree
 	 */
-	err = ext4_alloc_branch(handle, inode, map->m_lblk, indirect_blks,
-				&count, goal,
-				offsets + (partial - chain), partial);
+	err = ext4_alloc_branch_cow(handle, inode, map->m_lblk, indirect_blks,
+				     &count, goal, offsets + (partial - chain),
+				     partial, flags);
+	if (err)
+		goto cleanup;
 
 	if (map->m_flags & EXT4_MAP_REMAP) {
 		map->m_len = count;
@@ -1126,9 +1155,8 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	 * credits cannot be returned.  Can we handle this somehow?  We
 	 * may need to return -EAGAIN upwards in the worst case.  --sct
 	 */
-	if (!err)
-		err = ext4_splice_branch(handle, inode, map->m_lblk,
-					 partial, indirect_blks, count);
+	err = ext4_splice_branch_cow(handle, inode, map->m_lblk, partial,
+				     indirect_blks, count, flags);
 	if (err)
 		goto cleanup;
 
-- 
1.7.0.4

