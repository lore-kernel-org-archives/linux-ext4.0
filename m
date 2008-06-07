From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: cleanup blockallocator
Date: Fri, 06 Jun 2008 18:12:50 -0700
Message-ID: <1212801170.22102.65.camel@localhost.localdomain>
References: <1212776693-435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47400 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbYFGBM5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jun 2008 21:12:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m571CqHr020683
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 21:12:52 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m571CqRI237910
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 21:12:52 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m570wJrK030029
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 20:58:19 -0400
In-Reply-To: <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-06-06 at 23:54 +0530, Aneesh Kumar K.V wrote:
> Move the code for block allocation to a single function and add helpers
> for the allocation of data and meta data blocks
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |   74 ++++++++++++++++++++--------------------------------
>  fs/ext4/ext4.h    |    2 +-
>  fs/ext4/mballoc.c |    2 +-
>  3 files changed, 31 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index b961ad1..10c2d49 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1645,7 +1645,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
>  }
> 
>  /**
> - * ext4_new_blocks_old() -- core block(s) allocation function
> + * ext4_orlov_new_blocks() -- core block(s) allocation function

How about calling ext4_old_new_blocks? and  expand the note as
 core block bitmap based block allocation function?

I added a few comments to each block allocator, and clear up a few other
confusion about allocation, how about this?

---

 fs/ext4/balloc.c  |   74 +++++++++++++++++++++--------------------------------
 fs/ext4/ext4.h    |    2 +
 fs/ext4/mballoc.c |    2 +
 3 files changed, 31 insertions(+), 47 deletions(-)


Index: linux-2.6.26-rc5/fs/ext4/balloc.c
===================================================================
--- linux-2.6.26-rc5.orig/fs/ext4/balloc.c	2008-06-06 17:06:03.000000000 -0700
+++ linux-2.6.26-rc5/fs/ext4/balloc.c	2008-06-06 17:59:05.000000000 -0700
@@ -1645,20 +1645,24 @@ int ext4_should_retry_alloc(struct super
 }
 
 /**
- * ext4_new_blocks_old() -- core block(s) allocation function
+ * ext4_old_new_blocks() -- core block bitmap based block allocation function
+ *
  * @handle:		handle to this transaction
  * @inode:		file inode
  * @goal:		given target block(filesystem wide)
  * @count:		target number of blocks to allocate
  * @errp:		error code
  *
- * ext4_new_blocks uses a goal block to assist allocation.  It tries to
- * allocate block(s) from the block group contains the goal block first. If that
- * fails, it will try to allocate block(s) from other block groups without
- * any specific goal block.
+ * ext4_old_new_blocks uses a goal block to assist allocation and look up
+ * the block bitmap directly to do block allocation.  It tries to
+ * allocate block(s) from the block group contains the goal block first. If
+ * that fails, it will try to allocate block(s) from other block groups
+ * without any specific goal block.
+ *
+ * This function is called when -o nomballoc mount option is enabled
  *
  */
-ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -1928,78 +1932,95 @@ out:
 	return 0;
 }
 
-ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, int *errp)
-{
-	struct ext4_allocation_request ar;
-	ext4_fsblk_t ret;
-
-	if (!test_opt(inode->i_sb, MBALLOC)) {
-		unsigned long count = 1;
-		ret = ext4_new_blocks_old(handle, inode, goal, &count, errp);
-		return ret;
-	}
-
-	memset(&ar, 0, sizeof(ar));
-	ar.inode = inode;
-	ar.goal = goal;
-	ar.len = 1;
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
-	return ret;
-}
-ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
-{
-	struct ext4_allocation_request ar;
-	ext4_fsblk_t ret;
-
-	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
-		return ret;
-	}
+#define EXT4_META_BLOCK 0x1
 
-	memset(&ar, 0, sizeof(ar));
-	ar.inode = inode;
-	ar.goal = goal;
-	ar.len = *count;
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
-	*count = ar.len;
-	return ret;
-}
-
-ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 				ext4_lblk_t iblock, ext4_fsblk_t goal,
-				unsigned long *count, int *errp)
+				unsigned long *count, int *errp, int flags)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
 
 	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
-		return ret;
+		return ext4_old_new_blocks(handle, inode, goal, count, errp);
 	}
 
 	memset(&ar, 0, sizeof(ar));
 	/* Fill with neighbour allocated blocks */
-	ar.lleft  = 0;
-	ar.pleft  = 0;
-	ar.lright = 0;
-	ar.pright = 0;
 
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = *count;
 	ar.logical = iblock;
-	if (S_ISREG(inode->i_mode))
+
+	if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
+		/* enable in-core preallocation for data block allocation */
 		ar.flags = EXT4_MB_HINT_DATA;
 	else
 		/* disable in-core preallocation for non-regular files */
 		ar.flags = 0;
+
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
 	return ret;
 }
 
+/*
+ * ext4_new_meta_block() -- allocate block for meta data (indexing) block
+ *
+ * @handle:             handle to this transaction
+ * @inode:              file inode
+ * @goal:               given target block(filesystem wide)
+ * @errp:               error code
+ *
+ * Return allocated block number on success
+ */
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, int *errp)
+{
+	unsigned long count = 1;
+	return do_blk_alloc(handle, inode, 0, goal,
+			&count, errp, EXT4_META_BLOCK);
+}
+
+/*
+ * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
+ *
+ * @handle:             handle to this transaction
+ * @inode:              file inode
+ * @goal:               given target block(filesystem wide)
+ * @count:		total number of blocks need
+ * @errp:               error code
+ *
+ * Return 1st allocated block numberon success, *count stores total account
+ * error stores in errp pointer
+ */
+ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
+{
+	return do_blk_alloc(handle, inode, 0, goal,
+			count, errp, EXT4_META_BLOCK);
+}
+
+/*
+ * ext4_new_blocks() -- allocate data blocks
+ *
+ * @handle:             handle to this transaction
+ * @inode:              file inode
+ * @goal:               given target block(filesystem wide)
+ * @count:		total number of blocks need
+ * @errp:               error code
+ *
+ * Return 1st allocated block numberon success, *count stores total account
+ * error stores in errp pointer
+ */
+
+ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+				ext4_lblk_t iblock, ext4_fsblk_t goal,
+				unsigned long *count, int *errp)
+{
+	return do_blk_alloc(handle, inode, iblock, goal, count, errp, 0);
+}
 
 /**
  * ext4_count_free_blocks() -- count filesystem free blocks
Index: linux-2.6.26-rc5/fs/ext4/ext4.h
===================================================================
--- linux-2.6.26-rc5.orig/fs/ext4/ext4.h	2008-06-06 17:06:03.000000000 -0700
+++ linux-2.6.26-rc5/fs/ext4/ext4.h	2008-06-06 17:49:58.000000000 -0700
@@ -977,7 +977,7 @@ extern ext4_fsblk_t ext4_new_meta_blocks
 extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					ext4_lblk_t iblock, ext4_fsblk_t goal,
 					unsigned long *count, int *errp);
-extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
Index: linux-2.6.26-rc5/fs/ext4/extents.c
===================================================================
--- linux-2.6.26-rc5.orig/fs/ext4/extents.c	2008-06-06 17:39:45.000000000 -0700
+++ linux-2.6.26-rc5/fs/ext4/extents.c	2008-06-06 17:54:03.000000000 -0700
@@ -180,8 +180,11 @@ static ext4_fsblk_t ext4_ext_find_goal(s
 	return bg_start + colour + block;
 }
 
+/*
+ * Allocation for a meta data block
+ */
 static ext4_fsblk_t
-ext4_ext_new_block(handle_t *handle, struct inode *inode,
+ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
 			struct ext4_extent *ex, int *err)
 {
@@ -688,7 +691,8 @@ static int ext4_ext_split(handle_t *hand
 	/* allocate all needed blocks */
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
-		newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+		newblock = ext4_ext_new_meta_block(handle, inode, path,
+						   newext, &err);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -884,7 +888,7 @@ static int ext4_ext_grow_indepth(handle_
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_meta_block(handle, inode, path, newext, &err);
 	if (newblock == 0)
 		return err;
 
Index: linux-2.6.26-rc5/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc5.orig/fs/ext4/inode.c	2008-06-06 17:56:09.000000000 -0700
+++ linux-2.6.26-rc5/fs/ext4/inode.c	2008-06-06 17:56:41.000000000 -0700
@@ -561,7 +561,7 @@ static int ext4_alloc_blocks(handle_t *h
 		goto allocated;
 	/* Now allocate data blocks */
 	count = target;
-	/* allocating blocks for indirect blocks and direct blocks */
+	/* allocating blocks for data  blocks */
 	current_block = ext4_new_blocks(handle, inode, iblock,
 						goal, &count, err);
 	if (*err && (target == blks)) {


