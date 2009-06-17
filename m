From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 1/3] Add EXT4_IOC_MOVE_EXT ioctl and related	functions
Date: Wed, 17 Jun 2009 14:51:30 +0900
Message-ID: <4A388462.9070209@rs.jp.nec.com>
References: <4A164EE8.1070903@rs.jp.nec.com> <20090613132148.GK24336@mit.edu> <4A36005B.6080101@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40531 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbZFQFvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2009 01:51:46 -0400
In-Reply-To: <4A36005B.6080101@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Theodore Tso wrote:
> As a side note, the static functions in fs/ext4/move_extent.c really
> don't need the ext4_mext prefix, since static functions don't have
> namespace issues that require a consistent naming scheme.  (Sometimes
> a shorter name can also be useful since it avoids needing to line wrap
> function calls with a long list of parameters.)

This patch is for "online-defrag" in the ext4 patch queue,
and changes are as follows:

- Remove unneeded function prefix (ext4_mext_ or ext4_)
  in fs/ext4/move_extent.c to make function name shorter.
  And change some name of functions.
- Fix error handling issue.
- Add some argument checks.

If this patch does not seem to have any problem,
could you add this change to the ext4 patch queue?

Best regards,
Akira Fujita

---
ext4: online defrag -- Change function prefix and some fixes

From: Akira Fujita <a-fujita@rs.jp.nec.com>

- Remove unneeded function prefix to make function name shorter.
  e.g ext4_mext_copy_extent_status() -> copy_extent_status()
  And change some name of functions.
- Fix error handling issue.
- Add some argument checks.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 move_extent.c |  214 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 113 insertions(+), 101 deletions(-)
--- linux-2.6.30-git4/fs/ext4/move_extent.c	2009-06-16 11:43:41.000000000 +0900
+++ linux-2.6.30-git4-fix/fs/ext4/move_extent.c	2009-06-16 13:45:14.000000000 +0900
@@ -19,7 +19,7 @@
 #include "ext4_extents.h"
 #include "ext4.h"

-#define ext4_mext_get_extpath(path, inode, block, ret)		\
+#define get_ext_path(path, inode, block, ret)		\
 	do {								\
 		path = ext4_ext_find_extent(inode, block, path);	\
 		if (IS_ERR(path)) {					\
@@ -29,13 +29,13 @@
 	} while (0)

 /**
- * ext4_mext_copy_extent_status - Copy the extent's initialization status
+ * copy_extent_status - Copy the extent's initialization status
  *
  * @src:	an extent for getting initialize status
  * @dest:	an extent to be set the status
  */
 static void
-ext4_mext_copy_extent_status(struct ext4_extent *src, struct ext4_extent *dest)
+copy_extent_status(struct ext4_extent *src, struct ext4_extent *dest)
 {
 	if (ext4_ext_is_uninitialized(src))
 		ext4_ext_mark_uninitialized(dest);
@@ -44,7 +44,7 @@ ext4_mext_copy_extent_status(struct ext4
 }

 /**
- * ext4_mext_next_extent - Search for the next extent and set it to "extent"
+ * mext_next_extent - Search for the next extent and set it to "extent"
  *
  * @inode:	inode which is searched
  * @path:	this will obtain data for the next extent
@@ -57,7 +57,7 @@ ext4_mext_copy_extent_status(struct ext4
  * value on failure.
  */
 static int
-ext4_mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
+mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 		      struct ext4_extent **extent)
 {
 	int ppos, leaf_ppos = path->p_depth;
@@ -113,15 +113,14 @@ ext4_mext_next_extent(struct inode *inod
 }

 /**
- * ext4_mext_double_down_read - Acquire two inodes' read semaphore
+ * mext_double_down_read - Acquire two inodes' read semaphore
  *
  * @orig_inode:		original inode structure
  * @donor_inode:	donor inode structure
  * Acquire read semaphore of the two inodes (orig and donor) by i_ino order.
  */
 static void
-ext4_mext_double_down_read(struct inode *orig_inode,
-			   struct inode *donor_inode)
+mext_double_down_read(struct inode *orig_inode, struct inode *donor_inode)
 {
 	struct inode *first = orig_inode, *second = donor_inode;

@@ -142,15 +141,14 @@ ext4_mext_double_down_read(struct inode
 }

 /**
- * ext4_mext_double_down_write - Acquire two inodes' write semaphore
+ * mext_double_down_write - Acquire two inodes' write semaphore
  *
  * @orig_inode:		original inode structure
  * @donor_inode:	donor inode structure
  * Acquire write semaphore of the two inodes (orig and donor) by i_ino order.
  */
 static void
-ext4_mext_double_down_write(struct inode *orig_inode,
-			    struct inode *donor_inode)
+mext_double_down_write(struct inode *orig_inode, struct inode *donor_inode)
 {
 	struct inode *first = orig_inode, *second = donor_inode;

@@ -171,14 +169,14 @@ ext4_mext_double_down_write(struct inode
 }

 /**
- * ext4_mext_double_up_read - Release two inodes' read semaphore
+ * mext_double_up_read - Release two inodes' read semaphore
  *
  * @orig_inode:		original inode structure to be released its lock first
  * @donor_inode:	donor inode structure to be released its lock second
  * Release read semaphore of two inodes (orig and donor).
  */
 static void
-ext4_mext_double_up_read(struct inode *orig_inode, struct inode *donor_inode)
+mext_double_up_read(struct inode *orig_inode, struct inode *donor_inode)
 {
 	BUG_ON(orig_inode == NULL || donor_inode == NULL);

@@ -187,14 +185,14 @@ ext4_mext_double_up_read(struct inode *o
 }

 /**
- * ext4_mext_double_up_write - Release two inodes' write semaphore
+ * mext_double_up_write - Release two inodes' write semaphore
  *
  * @orig_inode:		original inode structure to be released its lock first
  * @donor_inode:	donor inode structure to be released its lock second
  * Release write semaphore of two inodes (orig and donor).
  */
 static void
-ext4_mext_double_up_write(struct inode *orig_inode, struct inode *donor_inode)
+mext_double_up_write(struct inode *orig_inode, struct inode *donor_inode)
 {
 	BUG_ON(orig_inode == NULL || donor_inode == NULL);

@@ -203,7 +201,7 @@ ext4_mext_double_up_write(struct inode *
 }

 /**
- * ext4_mext_insert_across_blocks - Insert extents across leaf block
+ * mext_insert_across_blocks - Insert extents across leaf block
  *
  * @handle:		journal handle
  * @orig_inode:		original inode
@@ -217,7 +215,7 @@ ext4_mext_double_up_write(struct inode *
  * or a negative error value on failure.
  */
 static int
-ext4_mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
+mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
 		struct ext4_extent *o_start, struct ext4_extent *o_end,
 		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
 		struct ext4_extent *end_ext)
@@ -285,7 +283,7 @@ ext4_mext_insert_across_blocks(handle_t
 	}

 	if (new_flag) {
-		ext4_mext_get_extpath(orig_path, orig_inode, eblock, err);
+		get_ext_path(orig_path, orig_inode, eblock, err);
 		if (orig_path == NULL)
 			goto out;

@@ -295,7 +293,7 @@ ext4_mext_insert_across_blocks(handle_t
 	}

 	if (end_flag) {
-		ext4_mext_get_extpath(orig_path, orig_inode,
+		get_ext_path(orig_path, orig_inode,
 				      le32_to_cpu(end_ext->ee_block) - 1, err);
 		if (orig_path == NULL)
 			goto out;
@@ -315,7 +313,7 @@ out:
 }

 /**
- * ext4_mext_insert_inside_block - Insert new extent to the extent block
+ * mext_insert_inside_block - Insert new extent to the extent block
  *
  * @o_start:		first original extent to be moved
  * @o_end:		last original extent to be moved
@@ -329,7 +327,7 @@ out:
  * by inserted extents.
  */
 static void
-ext4_mext_insert_inside_block(struct ext4_extent *o_start,
+mext_insert_inside_block(struct ext4_extent *o_start,
 			      struct ext4_extent *o_end,
 			      struct ext4_extent *start_ext,
 			      struct ext4_extent *new_ext,
@@ -366,7 +364,7 @@ ext4_mext_insert_inside_block(struct ext
 }

 /**
- * ext4_mext_insert_extents - Insert new extent
+ * mext_insert_extents - Insert new extent
  *
  * @handle:	journal handle
  * @orig_inode:	original inode
@@ -378,12 +376,12 @@ ext4_mext_insert_inside_block(struct ext
  * @end_ext:	last new extent to be inserted
  *
  * Call the function to insert extents. If we cannot add more extents into
- * the leaf block, we call ext4_mext_insert_across_blocks() to create a
- * new leaf block. Otherwise call ext4_mext_insert_inside_block(). Return 0
+ * the leaf block, we call mext_insert_across_blocks() to create a
+ * new leaf block. Otherwise call mext_insert_inside_block(). Return 0
  * on success, or a negative error value on failure.
  */
 static int
-ext4_mext_insert_extents(handle_t *handle, struct inode *orig_inode,
+mext_insert_extents(handle_t *handle, struct inode *orig_inode,
 			 struct ext4_ext_path *orig_path,
 			 struct ext4_extent *o_start,
 			 struct ext4_extent *o_end,
@@ -424,15 +422,13 @@ ext4_mext_insert_extents(handle_t *handl
 		(range_to_move > le16_to_cpu(eh->eh_max)
 			- le16_to_cpu(eh->eh_entries))) {

-		ret = ext4_mext_insert_across_blocks(handle, orig_inode,
-						     o_start, o_end, start_ext,
-						     new_ext, end_ext);
+		ret = mext_insert_across_blocks(handle, orig_inode, o_start,
+					o_end, start_ext, new_ext, end_ext);
 		if (ret < 0)
 			return ret;
 	} else
-		ext4_mext_insert_inside_block(o_start, o_end, start_ext,
-					      new_ext, end_ext, eh,
-					      range_to_move);
+		mext_insert_inside_block(o_start, o_end, start_ext, new_ext,
+						end_ext, eh, range_to_move);

 	if (depth) {
 		ret = ext4_handle_dirty_metadata(handle, orig_inode,
@@ -449,7 +445,7 @@ ext4_mext_insert_extents(handle_t *handl
 }

 /**
- * ext4_mext_leaf_block - Move one leaf extent block into the inode.
+ * mext_leaf_block - Move one leaf extent block into the inode.
  *
  * @handle:		journal handle
  * @orig_inode:		original inode
@@ -462,11 +458,11 @@ ext4_mext_insert_extents(handle_t *handl
  * extents, and the others are located around it.
  *
  * Therefore, this function creates structures to save extents of the leaf
- * block, and inserts extents by calling ext4_mext_insert_extents() with
+ * block, and inserts extents by calling mext_insert_extents() with
  * created extents. Return 0 on success, or a negative error value on failure.
  */
 static int
-ext4_mext_leaf_block(handle_t *handle, struct inode *orig_inode,
+mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 		     struct ext4_ext_path *orig_path, struct ext4_extent *dext,
 		     ext4_lblk_t *from)
 {
@@ -500,7 +496,7 @@ ext4_mext_leaf_block(handle_t *handle, s
 		le32_to_cpu(oext->ee_block) + oext_alen) {
 		start_ext.ee_len = cpu_to_le16(le32_to_cpu(new_ext.ee_block) -
 					       le32_to_cpu(oext->ee_block));
-		ext4_mext_copy_extent_status(oext, &start_ext);
+		copy_extent_status(oext, &start_ext);
 	} else if (oext > EXT_FIRST_EXTENT(orig_path[depth].p_hdr)) {
 		prev_ext = oext - 1;
 		/*
@@ -513,7 +509,7 @@ ext4_mext_leaf_block(handle_t *handle, s
 			start_ext.ee_len = cpu_to_le16(
 				ext4_ext_get_actual_len(prev_ext) +
 				new_ext_alen);
-			ext4_mext_copy_extent_status(prev_ext, &start_ext);
+			copy_extent_status(prev_ext, &start_ext);
 			new_ext.ee_len = 0;
 		}
 	}
@@ -536,7 +532,7 @@ ext4_mext_leaf_block(handle_t *handle, s
 		end_ext.ee_len =
 			cpu_to_le16(le32_to_cpu(oext->ee_block) +
 			oext_alen - 1 - new_ext_end);
-		ext4_mext_copy_extent_status(oext, &end_ext);
+		copy_extent_status(oext, &end_ext);
 		end_ext_alen = ext4_ext_get_actual_len(&end_ext);
 		ext4_ext_store_pblock(&end_ext,
 			(ext_pblock(o_end) + oext_alen - end_ext_alen));
@@ -545,14 +541,13 @@ ext4_mext_leaf_block(handle_t *handle, s
 			oext_alen - end_ext_alen);
 	}

-	ret = ext4_mext_insert_extents(handle, orig_inode,
-				       orig_path, o_start, o_end, &start_ext,
-				       &new_ext, &end_ext);
+	ret = mext_insert_extents(handle, orig_inode, orig_path, o_start,
+				o_end, &start_ext, &new_ext, &end_ext);
 	return ret;
 }

 /**
- * ext4_mext_get_replaced_extent - Compute extents for extent swapping.
+ * mext_calc_swap_extents - Calculate extents for extent swapping.
  *
  * @tmp_dext:		the extent that will belong to the original inode
  * @tmp_oext:		the extent that will belong to the donor inode
@@ -561,7 +556,7 @@ ext4_mext_leaf_block(handle_t *handle, s
  * @max_count:		the maximun length of extents
  */
 static void
-ext4_mext_get_replaced_extent(struct ext4_extent *tmp_dext,
+mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 			      struct ext4_extent *tmp_oext,
 			      ext4_lblk_t orig_off, ext4_lblk_t donor_off,
 			      ext4_lblk_t max_count)
@@ -594,12 +589,12 @@ ext4_mext_get_replaced_extent(struct ext

 	tmp_oext->ee_len = cpu_to_le16(ext4_ext_get_actual_len(tmp_dext));

-	ext4_mext_copy_extent_status(&oext_old, tmp_dext);
-	ext4_mext_copy_extent_status(&dext_old, tmp_oext);
+	copy_extent_status(&oext_old, tmp_dext);
+	copy_extent_status(&dext_old, tmp_oext);
 }

 /**
- * ext4_mext_replace_branches - Replace original extents with new extents
+ * mext_replace_branches - Replace original extents with new extents
  *
  * @handle:		journal handle
  * @orig_inode:		original inode
@@ -619,7 +614,7 @@ ext4_mext_get_replaced_extent(struct ext
  * Return 0 on success, or a negative error value on failure.
  */
 static int
-ext4_mext_replace_branches(handle_t *handle, struct inode *orig_inode,
+mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 			   struct inode *donor_inode, ext4_lblk_t from,
 			   ext4_lblk_t count)
 {
@@ -633,15 +628,15 @@ ext4_mext_replace_branches(handle_t *han
 	int replaced_count = 0;
 	int dext_alen;

-	ext4_mext_double_down_write(orig_inode, donor_inode);
+	mext_double_down_write(orig_inode, donor_inode);

 	/* Get the original extent for the block "orig_off" */
-	ext4_mext_get_extpath(orig_path, orig_inode, orig_off, err);
+	get_ext_path(orig_path, orig_inode, orig_off, err);
 	if (orig_path == NULL)
 		goto out;

 	/* Get the donor extent for the head */
-	ext4_mext_get_extpath(donor_path, donor_inode, donor_off, err);
+	get_ext_path(donor_path, donor_inode, donor_off, err);
 	if (donor_path == NULL)
 		goto out;
 	depth = ext_depth(orig_inode);
@@ -652,22 +647,22 @@ ext4_mext_replace_branches(handle_t *han
 	dext = donor_path[depth].p_ext;
 	tmp_dext = *dext;

-	ext4_mext_get_replaced_extent(&tmp_dext, &tmp_oext, orig_off,
+	mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
 				      donor_off, count);

 	/* Loop for the donor extents */
 	while (1) {
 		/* The extent for donor must be found. */
-		BUG_ON(!dext || donor_off != le32_to_cpu(dext->ee_block));
+		BUG_ON(!dext || donor_off != le32_to_cpu(tmp_dext.ee_block));

 		/* Set donor extent to orig extent */
-		err = ext4_mext_leaf_block(handle, orig_inode,
+		err = mext_leaf_block(handle, orig_inode,
 					   orig_path, &tmp_dext, &orig_off);
 		if (err < 0)
 			goto out;

 		/* Set orig extent to donor extent */
-		err = ext4_mext_leaf_block(handle, donor_inode,
+		err = mext_leaf_block(handle, donor_inode,
 					   donor_path, &tmp_oext, &donor_off);
 		if (err < 0)
 			goto out;
@@ -683,7 +678,7 @@ ext4_mext_replace_branches(handle_t *han

 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
-		ext4_mext_get_extpath(orig_path, orig_inode, orig_off, err);
+		get_ext_path(orig_path, orig_inode, orig_off, err);
 		if (orig_path == NULL)
 			goto out;
 		depth = ext_depth(orig_inode);
@@ -697,7 +692,7 @@ ext4_mext_replace_branches(handle_t *han

 		if (donor_path)
 			ext4_ext_drop_refs(donor_path);
-		ext4_mext_get_extpath(donor_path, donor_inode,
+		get_ext_path(donor_path, donor_inode,
 				      donor_off, err);
 		if (donor_path == NULL)
 			goto out;
@@ -710,7 +705,7 @@ ext4_mext_replace_branches(handle_t *han
 		}
 		tmp_dext = *dext;

-		ext4_mext_get_replaced_extent(&tmp_dext, &tmp_oext, orig_off,
+		mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
 					      donor_off,
 					      count - replaced_count);
 	}
@@ -725,12 +720,12 @@ out:
 		kfree(donor_path);
 	}

-	ext4_mext_double_up_write(orig_inode, donor_inode);
+	mext_double_up_write(orig_inode, donor_inode);
 	return err;
 }

 /**
- * ext4_mext_partial - Move extent data per page
+ * move_extent_per_page - Move extent data per page
  *
  * @o_filp:			file structure of original file
  * @donor_inode:		donor inode
@@ -740,12 +735,12 @@ out:
  * @uninit:			orig extent is uninitialized or not
  *
  * Save the data in original inode blocks and replace original inode extents
- * with donor inode extents by calling ext4_mext_replace_branches().
+ * with donor inode extents by calling mext_replace_branches().
  * Finally, write out the saved data in new original inode blocks. Return 0
  * on success, or a negative error value on failure.
  */
 static int
-ext4_mext_partial(struct file *o_filp, struct inode *donor_inode,
+move_extent_par_page(struct file *o_filp, struct inode *donor_inode,
 		  pgoff_t orig_page_offset, int data_offset_in_page,
 		  int block_len_in_page, int uninit)
 {
@@ -788,7 +783,7 @@ ext4_mext_partial(struct file *o_filp, s
 	 * Just swap data blocks between orig and donor.
 	 */
 	if (uninit) {
-		ret = ext4_mext_replace_branches(handle, orig_inode,
+		ret = mext_replace_branches(handle, orig_inode,
 						 donor_inode, orig_blk_offset,
 						 block_len_in_page);

@@ -841,7 +836,7 @@ ext4_mext_partial(struct file *o_filp, s
 	/* Release old bh and drop refs */
 	try_to_release_page(page, 0);

-	ret = ext4_mext_replace_branches(handle, orig_inode, donor_inode,
+	ret = mext_replace_branches(handle, orig_inode, donor_inode,
 					 orig_blk_offset, block_len_in_page);
 	if (ret < 0)
 		goto out;
@@ -884,7 +879,7 @@ out2:
 }

 /**
- * ext4_mext_check_argumants - Check whether move extent can be done
+ * mext_check_argumants - Check whether move extent can be done
  *
  * @orig_inode:		original inode
  * @donor_inode:	donor inode
@@ -898,9 +893,9 @@ out2:
  * Return 0 on success, or a negative error value on failure.
  */
 static int
-ext4_mext_check_arguments(struct inode *orig_inode,
+mext_check_arguments(struct inode *orig_inode,
 			  struct inode *donor_inode, __u64 orig_start,
-			  __u64 donor_start, __u64 len, __u64 moved_len)
+			  __u64 donor_start, __u64 *len, __u64 moved_len)
 {
 	/* Regular file check */
 	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
@@ -945,6 +940,11 @@ ext4_mext_check_arguments(struct inode *
 		return -EOPNOTSUPP;
 	}

+	if ((!orig_inode->i_size) || (!donor_inode->i_size)) {
+		ext4_debug("ext4 move extent: File size is 0 byte\n");
+		return -EINVAL;
+	}
+
 	/* Start offset should be same */
 	if (orig_start != donor_start) {
 		ext4_debug("ext4 move extent: orig and donor's start "
@@ -962,8 +962,8 @@ ext4_mext_check_arguments(struct inode *

 	if ((orig_start > MAX_DEFRAG_SIZE) ||
 	    (donor_start > MAX_DEFRAG_SIZE) ||
-	    (len > MAX_DEFRAG_SIZE) ||
-	    (orig_start + len > MAX_DEFRAG_SIZE))  {
+	    (*len > MAX_DEFRAG_SIZE) ||
+	    (orig_start + *len > MAX_DEFRAG_SIZE))  {
 		ext4_debug("ext4 move extent: Can't handle over [%lu] blocks "
 			"[ino:orig %lu, donor %lu]\n", MAX_DEFRAG_SIZE,
 			orig_inode->i_ino, donor_inode->i_ino);
@@ -980,15 +980,15 @@ ext4_mext_check_arguments(struct inode *
 			return -EINVAL;
 		}

-		if (orig_start + len > donor_inode->i_size) {
+		if (orig_start + *len > donor_inode->i_size) {
 			ext4_debug("ext4 move extent: End offset [%llu] should "
 				"be less than donor file size [%lld]."
 				"So adjust length from %llu to %lld "
 				"[ino:orig %lu, donor %lu]\n",
-				orig_start + len, donor_inode->i_size,
-				len, donor_inode->i_size - orig_start,
+				orig_start + *len, donor_inode->i_size,
+				*len, donor_inode->i_size - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			len = donor_inode->i_size - orig_start;
+			*len = donor_inode->i_size - orig_start;
 		}
 	} else {
 		if (orig_start >= orig_inode->i_size) {
@@ -1000,22 +1000,29 @@ ext4_mext_check_arguments(struct inode *
 			return -EINVAL;
 		}

-		if (orig_start + len > orig_inode->i_size) {
+		if (orig_start + *len > orig_inode->i_size) {
 			ext4_debug("ext4 move extent: Adjust length "
 				"from %llu to %lld. Because it should be "
 				"less than original file size "
 				"[ino:orig %lu, donor %lu]\n",
-				len, orig_inode->i_size - orig_start,
+				*len, orig_inode->i_size - orig_start,
 				orig_inode->i_ino, donor_inode->i_ino);
-			len = orig_inode->i_size - orig_start;
+			*len = orig_inode->i_size - orig_start;
 		}
 	}

+	if (!*len) {
+		ext4_debug("ext4 move extent: len shoudld not be 0 "
+			"[ino:orig %lu, donor %lu]\n", orig_inode->i_ino,
+			donor_inode->i_ino);
+		return -EINVAL;
+	}
+
 	return 0;
 }

 /**
- * ext4_mext_inode_double_lock - Lock i_mutex on both @inode1 and @inode2
+ * mext_inode_double_lock - Lock i_mutex on both @inode1 and @inode2
  *
  * @inode1:	the inode structure
  * @inode2:	the inode structure
@@ -1023,7 +1030,8 @@ ext4_mext_check_arguments(struct inode *
  * Lock two inodes' i_mutex by i_ino order. This function is moved from
  * fs/inode.c.
  */
-void ext4_mext_inode_double_lock(struct inode *inode1, struct inode *inode2)
+static void
+mext_inode_double_lock(struct inode *inode1, struct inode *inode2)
 {
 	if (inode1 == NULL || inode2 == NULL || inode1 == inode2) {
 		if (inode1)
@@ -1043,7 +1051,7 @@ void ext4_mext_inode_double_lock(struct
 }

 /**
- * ext4_mext_inode_double_unlock - Release i_mutex on both @inode1 and @inode2
+ * mext_inode_double_unlock - Release i_mutex on both @inode1 and @inode2
  *
  * @inode1:     the inode that is released first
  * @inode2:     the inode that is released second
@@ -1051,7 +1059,8 @@ void ext4_mext_inode_double_lock(struct
  * This function is moved from fs/inode.c.
  */

-void ext4_mext_inode_double_unlock(struct inode *inode1, struct inode *inode2)
+static void
+mext_inode_double_unlock(struct inode *inode1, struct inode *inode2)
 {
 	if (inode1)
 		mutex_unlock(&inode1->i_mutex);
@@ -1082,7 +1091,7 @@ void ext4_mext_inode_double_unlock(struc
  *   after hole behind.
  * 2:Continue step 3 to step 5, until the holecheck_path points to last_extent
  *   or the ext_cur exceeds the block_end which is last logical block number.
- * 3:To get the length of continues area, call ext4_mext_next_extent()
+ * 3:To get the length of continues area, call mext_next_extent()
  *   specified with the ext_cur (initial value is holecheck_path) re-cursive,
  *   until find un-continuous extent, the start logical block number exceeds
  *   the block_end or the extent points to the last extent.
@@ -1121,14 +1130,13 @@ ext4_move_extents(struct file *o_filp, s
 	int uninit;

 	/* protect orig and donor against a truncate */
-	ext4_mext_inode_double_lock(orig_inode, donor_inode);
+	mext_inode_double_lock(orig_inode, donor_inode);

-	ext4_mext_double_down_read(orig_inode, donor_inode);
+	mext_double_down_read(orig_inode, donor_inode);
 	/* Check the filesystem environment whether move_extent can be done */
-	ret = ext4_mext_check_arguments(orig_inode, donor_inode,
-					orig_start, donor_start, len,
-					*moved_len);
-	ext4_mext_double_up_read(orig_inode, donor_inode);
+	ret = mext_check_arguments(orig_inode, donor_inode, orig_start,
+					donor_start, &len, *moved_len);
+	mext_double_up_read(orig_inode, donor_inode);
 	if (ret)
 		goto out2;

@@ -1137,19 +1145,21 @@ ext4_move_extents(struct file *o_filp, s
 	if (file_end < block_end)
 		len -= block_end - file_end;

-	ext4_mext_get_extpath(orig_path, orig_inode, block_start, ret);
+	get_ext_path(orig_path, orig_inode, block_start, ret);
 	if (orig_path == NULL)
 		goto out2;

 	/* Get path structure to check the hole */
-	ext4_mext_get_extpath(holecheck_path, orig_inode, block_start, ret);
+	get_ext_path(holecheck_path, orig_inode, block_start, ret);
 	if (holecheck_path == NULL)
 		goto out;

 	depth = ext_depth(orig_inode);
 	ext_cur = holecheck_path[depth].p_ext;
-	if (ext_cur == NULL)
+	if (ext_cur == NULL) {
+		ret = -EINVAL;
 		goto out;
+	}

 	/*
 	 * Get proper extent whose ee_block is beyond block_start
@@ -1157,13 +1167,13 @@ ext4_move_extents(struct file *o_filp, s
 	 */
 	if (le32_to_cpu(ext_cur->ee_block) +
 		ext4_ext_get_actual_len(ext_cur) - 1 < block_start) {
-		last_extent = ext4_mext_next_extent(orig_inode,
+		last_extent = mext_next_extent(orig_inode,
 					holecheck_path, &ext_cur);
 		if (last_extent < 0) {
 			ret = last_extent;
 			goto out;
 		}
-		last_extent = ext4_mext_next_extent(orig_inode, orig_path,
+		last_extent = mext_next_extent(orig_inode, orig_path,
 							&ext_dummy);
 		if (last_extent < 0) {
 			ret = last_extent;
@@ -1176,6 +1186,7 @@ ext4_move_extents(struct file *o_filp, s
 	if (le32_to_cpu(ext_cur->ee_block) > block_end) {
 		ext4_debug("ext4 move extent: The specified range of file "
 							"may be the hole\n");
+		ret = -EINVAL;
 		goto out;
 	}

@@ -1192,8 +1203,8 @@ ext4_move_extents(struct file *o_filp, s
 			seq_blocks = block_end - seq_start + 1;

 		ext_prev = ext_cur;
-		last_extent = ext4_mext_next_extent(orig_inode,
-						    holecheck_path, &ext_cur);
+		last_extent = mext_next_extent(orig_inode, holecheck_path,
+						&ext_cur);
 		if (last_extent < 0) {
 			ret = last_extent;
 			break;
@@ -1247,13 +1258,16 @@ ext4_move_extents(struct file *o_filp, s
 		while (orig_page_offset <= seq_end_page) {

 			/* Swap original branches with new branches */
-			ret = ext4_mext_partial(o_filp, donor_inode,
+			ret = move_extent_par_page(o_filp, donor_inode,
 						orig_page_offset,
 						data_offset_in_page,
 						block_len_in_page, uninit);
 			if (ret < 0)
 				goto out;
 			orig_page_offset++;
+			/* Count how many blocks we have exchanged */
+			*moved_len += block_len_in_page;
+			BUG_ON(*moved_len > len);

 			data_offset_in_page = 0;
 			rest_blocks -= block_len_in_page;
@@ -1266,7 +1280,7 @@ ext4_move_extents(struct file *o_filp, s
 		/* Decrease buffer counter */
 		if (holecheck_path)
 			ext4_ext_drop_refs(holecheck_path);
-		ext4_mext_get_extpath(holecheck_path, orig_inode,
+		get_ext_path(holecheck_path, orig_inode,
 				      seq_start, ret);
 		if (holecheck_path == NULL)
 			break;
@@ -1275,7 +1289,7 @@ ext4_move_extents(struct file *o_filp, s
 		/* Decrease buffer counter */
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
-		ext4_mext_get_extpath(orig_path, orig_inode, seq_start, ret);
+		get_ext_path(orig_path, orig_inode, seq_start, ret);
 		if (orig_path == NULL)
 			break;

@@ -1294,15 +1308,13 @@ out:
 		kfree(holecheck_path);
 	}
 out2:
-	ext4_mext_inode_double_unlock(orig_inode, donor_inode);
+	mext_inode_double_unlock(orig_inode, donor_inode);

-	if (ret) {
-		*moved_len = orig_page_offset * blocks_per_page;
+	if (ret)
 		return ret;
-	}

-	/* Set moved block length */
-	*moved_len = len;
+	/* All of the specified blocks must be exchanged in succeed */
+	BUG_ON(*moved_len != len);

 	return 0;
 }
