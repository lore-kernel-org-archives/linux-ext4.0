From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ext4_get_blocks_wrap take the truncate_mutex early.
Date: Thu, 28 Jun 2007 14:38:52 +0530
Message-ID: <1183021733383-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:65227 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684AbXF1JJv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2007 05:09:51 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5S9BAZJ3317808
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2007 19:11:10 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5S9D4Pa143356
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2007 19:13:07 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5S997p3002447
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jun 2007 19:09:08 +1000
Message-Id: <a8cc5ebabdb8e837df10bb04455d9bd4b7fe0ab8.1183021714.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When doing a migrate from ext3 to ext4 inode we need to make sure the test
for inode type and walking inode data happens inside  lock. To make this
happen move truncate_mutex early before checking the i_flags.


This actually should enable us to remove the verify_chain().

I haven't done any performance benchmark with this change.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c       |    7 +++--
 fs/ext4/inode.c         |   69 +++++-----------------------------------------
 include/linux/ext4_fs.h |   15 +++++++---
 3 files changed, 23 insertions(+), 68 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b9ce241..8193e97 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1977,6 +1977,10 @@ void ext4_ext_release(struct super_block *sb)
 #endif
 }
 
+/*
+ * Need to be called with
+ * mutex_lock(&EXT4_I(inode)->truncate_mutex);
+ */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
@@ -1991,7 +1995,6 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %d/%lu requested for inode %u\n", (int) iblock,
 			max_blocks, (unsigned) inode->i_ino);
-	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 
 	/* check in cache */
 	goal = ext4_ext_in_cache(inode, iblock, &newex);
@@ -2127,8 +2130,6 @@ out2:
 		ext4_ext_drop_refs(path);
 		kfree(path);
 	}
-	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
-
 	return err ? err : allocated;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8416fa2..255db76 100644
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
index de1f9f7..ebd6f86 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -988,11 +988,18 @@ ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
 			int create, int extend_disksize)
 {
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_get_blocks(handle, inode, block, max_blocks,
+	int retval;
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		retval = ext4_ext_get_blocks(handle, inode, block, max_blocks,
 					bh, create, extend_disksize);
-	return ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
-					create, extend_disksize);
+	} else {
+		retval = ext4_get_blocks_handle(handle, inode, block, max_blocks,
+					bh, create, extend_disksize);
+	}
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+
+	return retval;
 }
 
 
-- 
1.5.2.2.571.ge1341-dirty
