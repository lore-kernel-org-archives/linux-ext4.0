From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 1/3] ext4: Make ext4_get_blocks_wrap take the truncate_mutex early.
Date: Mon,  3 Dec 2007 15:55:55 +0530
Message-ID: <1196677557-10403-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1196677557-10403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51806 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752065AbXLCK0L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 05:26:11 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id lB3APwSm023685
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:55:58 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3APv784575272
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:55:58 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id lB3APvR4029954
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 10:25:57 GMT
In-Reply-To: <1196677557-10403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When doing a migrate from ext3 to ext4 inode we need to make sure the test
for inode type and walking inode data happens inside  lock. To make this
happen move truncate_mutex early before checking the i_flags.


This actually should enable us to remove the verify_chain().

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c       |    7 +++--
 fs/ext4/inode.c         |   69 +++++-----------------------------------------
 include/linux/ext4_fs.h |   12 ++++++--
 3 files changed, 21 insertions(+), 67 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8528774..9dd4746 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2225,6 +2225,10 @@ out:
 	return err ? err : allocated;
 }
 
+/*
+ * Need to be called with
+ * mutex_lock(&EXT4_I(inode)->truncate_mutex);
+ */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
@@ -2240,7 +2244,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %d/%lu requested for inode %u\n", (int) iblock,
 			max_blocks, (unsigned) inode->i_ino);
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 
 	/* check in cache */
 	goal = ext4_ext_in_cache(inode, iblock, &newex);
@@ -2414,8 +2417,6 @@ out2:
 		ext4_ext_drop_refs(path);
 		kfree(path);
 	}
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
-
 	return err ? err : allocated;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5489703..9cf37b2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -243,13 +243,6 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 	p->bh = bh;
 }
 
-static int verify_chain(Indirect *from, Indirect *to)
-{
-	while (from <= to && from->key == *from->p)
-		from++;
-	return (from > to);
-}
-
 /**
  *	ext4_block_to_path - parse the block number into array of offsets
  *	@inode: inode in question (we are only interested in its superblock)
@@ -344,10 +337,11 @@ static int ext4_block_to_path(struct inode *inode,
  *		(pointer to last triple returned, *@err == 0)
  *	or when it gets an IO error reading an indirect block
  *		(ditto, *@err == -EIO)
- *	or when it notices that chain had been changed while it was reading
- *		(ditto, *@err == -EAGAIN)
  *	or when it reads all @depth-1 indirect blocks successfully and finds
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
+ *
+ *      Need to be called with
+ *      mutex_lock(&EXT4_I(inode)->truncate_mutex)
  */
 static Indirect *ext4_get_branch(struct inode *inode, int depth, int *offsets,
 				 Indirect chain[4], int *err)
@@ -365,9 +359,6 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth, int *offsets,
 		bh = sb_bread(sb, le32_to_cpu(p->key));
 		if (!bh)
 			goto failure;
-		/* Reader: pointers */
-		if (!verify_chain(chain, p))
-			goto changed;
 		add_chain(++p, bh, (__le32*)bh->b_data + *++offsets);
 		/* Reader: end */
 		if (!p->key)
@@ -375,10 +366,6 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth, int *offsets,
 	}
 	return NULL;
 
-changed:
-	brelse(bh);
-	*err = -EAGAIN;
-	goto no_block;
 failure:
 	*err = -EIO;
 no_block:
@@ -782,6 +769,10 @@ err_out:
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.
+ *
+ *
+ * Need to be called with
+ * mutex_lock(&EXT4_I(inode)->truncate_mutex)
  */
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		sector_t iblock, unsigned long maxblocks,
@@ -819,18 +810,6 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		while (count < maxblocks && count <= blocks_to_boundary) {
 			ext4_fsblk_t blk;
 
-			if (!verify_chain(chain, partial)) {
-				/*
-				 * Indirect block might be removed by
-				 * truncate while we were reading it.
-				 * Handling of that case: forget what we've
-				 * got now. Flag the err as EAGAIN, so it
-				 * will reread.
-				 */
-				err = -EAGAIN;
-				count = 0;
-				break;
-			}
 			blk = le32_to_cpu(*(chain[depth-1].p + count));
 
 			if (blk == first_block + count)
@@ -838,44 +817,13 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 			else
 				break;
 		}
-		if (err != -EAGAIN)
-			goto got_it;
+		goto got_it;
 	}
 
 	/* Next simple case - plain lookup or failed read of indirect block */
 	if (!create || err == -EIO)
 		goto cleanup;
 
-	mutex_lock(&ei->truncate_mutex);
-
-	/*
-	 * If the indirect block is missing while we are reading
-	 * the chain(ext4_get_branch() returns -EAGAIN err), or
-	 * if the chain has been changed after we grab the semaphore,
-	 * (either because another process truncated this branch, or
-	 * another get_block allocated this branch) re-grab the chain to see if
-	 * the request block has been allocated or not.
-	 *
-	 * Since we already block the truncate/other get_block
-	 * at this point, we will have the current copy of the chain when we
-	 * splice the branch into the tree.
-	 */
-	if (err == -EAGAIN || !verify_chain(chain, partial)) {
-		while (partial > chain) {
-			brelse(partial->bh);
-			partial--;
-		}
-		partial = ext4_get_branch(inode, depth, offsets, chain, &err);
-		if (!partial) {
-			count++;
-			mutex_unlock(&ei->truncate_mutex);
-			if (err)
-				goto cleanup;
-			clear_buffer_new(bh_result);
-			goto got_it;
-		}
-	}
-
 	/*
 	 * Okay, we need to do block allocation.  Lazily initialize the block
 	 * allocation info here if necessary
@@ -917,7 +865,6 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	*/
 	if (!err && extend_disksize && inode->i_size > ei->i_disksize)
 		ei->i_disksize = inode->i_size;
-	mutex_unlock(&ei->truncate_mutex);
 	if (err)
 		goto cleanup;
 
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 97dd409..7f84645 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -1061,11 +1061,17 @@ ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
 			int create, int extend_disksize)
 {
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_get_blocks(handle, inode, block, max_blocks,
+	int retval;
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
 					bh, create, extend_disksize);
-	return ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
+	} else {
+		retval =  ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
 					create, extend_disksize);
+	}
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	return retval;
 }
 
 
-- 
1.5.3.6.985.g65c6a4-dirty
