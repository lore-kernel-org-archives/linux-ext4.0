From: "Faccini, Bruno" <bruno.faccini@intel.com>
Subject: [PATCH] ext4: always pre-allocate max depth for path
Date: Thu, 16 Jun 2016 16:53:38 +0000
Message-ID: <C214BF91-E916-4790-93AD-0849767A9F8E@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27225 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbcFPQxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2016 12:53:48 -0400
Content-Language: en-US
Content-ID: <349A9AA911060440A3BECEC14F87E608@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bruno Faccini <bruno.faccini@intel.com>

I have first found this way to fix holes in previous ext4 layers versions
where an array of struct ext4_ext_path had been allocated with an arbitrary
evaluated size and finally could overrun upon ext_depth() growth outside
i_data_sem protection. But it seems it can still help with recent ext4
version, to avoid re-allocation need and overhead when it can be allocated
to max possible extent depth (ie, 5 presently) at first time and for a low
cost regarding its memory foot-print, it should also avoid further invalid
dereference by underlying callers sharing same ppath (with present
inter-routines path re-use scheme), and also upon re-allocation error.

Signed-off-by: Bruno Faccini <bruno.faccini@intel.com>
---
 fs/ext4/ext4.h        |    3 +
 fs/ext4/extents.c     |  113 ++++++++++++++++++++++++++--------------
 fs/ext4/move_extent.c |   10 +--
 fs/ext4/super.c       |    3 -
 4 files changed, 85 insertions(+), 44 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e20fa9..73d5866 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1340,6 +1340,9 @@ struct ext4_sb_info {
 	unsigned long s_ext_extents;
 #endif
 
+	/* maximum possible extents tree depth, to be computed at mount time */
+	unsigned int s_max_ext_tree_depth;
+
 	/* for buddy allocator */
 	struct ext4_group_info ***s_group_info;
 	struct inode *s_buddy_cache;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b52fea3..aee676d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -871,19 +871,18 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 
 	if (path) {
 		ext4_ext_drop_refs(path);
-		if (depth > path[0].p_maxdepth) {
-			kfree(path);
-			*orig_path = path = NULL;
-		}
-	}
-	if (!path) {
+		/* path has been allocated for the max possible depth
+		 * so we can simply reuse it */
+		/* XXX need to clear/zero old path content? */
+	} else {
 		/* account possible depth increase */
-		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 2),
+		path = kzalloc(sizeof(struct ext4_ext_path) *
+				EXT4_SB(inode->i_sb)->s_max_ext_tree_depth,
 				GFP_NOFS);
 		if (unlikely(!path))
 			return ERR_PTR(-ENOMEM);
-		path[0].p_maxdepth = depth + 1;
 	}
+	path[0].p_maxdepth = depth + 1;
 	path[0].p_hdr = eh;
 	path[0].p_bh = NULL;
 
@@ -934,9 +933,11 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 
 err:
 	ext4_ext_drop_refs(path);
-	kfree(path);
-	if (orig_path)
-		*orig_path = NULL;
+
+	/* do not free *orig_path, it is likely to be referenced by callers */
+	if (!orig_path)
+		kfree(path);
+
 	return ERR_PTR(ret);
 }
 
@@ -2147,7 +2148,8 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 				    ext4_lblk_t block, ext4_lblk_t num,
 				    struct fiemap_extent_info *fieinfo)
 {
-	struct ext4_ext_path *path = NULL;
+	struct ext4_ext_path *path = NULL, *orig_path = NULL;
+	struct ext4_ext_path **orig_ppath = &orig_path;
 	struct ext4_extent *ex;
 	struct extent_status es;
 	ext4_lblk_t next, next_del, start = 0, end = 0;
@@ -2161,13 +2163,16 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
 
-		path = ext4_find_extent(inode, block, &path, 0);
+		path = ext4_find_extent(inode, block, orig_ppath, 0);
 		if (IS_ERR(path)) {
 			up_read(&EXT4_I(inode)->i_data_sem);
 			err = PTR_ERR(path);
 			path = NULL;
 			break;
 		}
+		if (!orig_path)
+			orig_path = path;
+		/* XXX else BUG_ON(path != orig_path); */
 
 		depth = ext_depth(inode);
 		if (unlikely(path[depth].p_hdr == NULL)) {
@@ -2287,8 +2292,8 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 		block = es.es_lblk + es.es_len;
 	}
 
-	ext4_ext_drop_refs(path);
-	kfree(path);
+	ext4_ext_drop_refs(orig_path);
+	kfree(orig_path);
 	return err;
 }
 
@@ -2910,7 +2915,8 @@ again:
 			path[k].p_block =
 				le16_to_cpu(path[k].p_hdr->eh_entries)+1;
 	} else {
-		path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1),
+		path = kzalloc(sizeof(struct ext4_ext_path) *
+			       EXT4_SB(inode->i_sb)->s_max_ext_tree_depth,
 			       GFP_NOFS);
 		if (path == NULL) {
 			ext4_journal_stop(handle);
@@ -3051,13 +3057,14 @@ out:
  */
 void ext4_ext_init(struct super_block *sb)
 {
+	ext4_fsblk_t maxblocks;
+
 	/*
 	 * possible initialization would be here
 	 */
 
 	if (ext4_has_feature_extents(sb)) {
-#if defined(AGGRESSIVE_TEST) || defined(CHECK_BINSEARCH) || defined(EXTENTS_STATS)
-		printk(KERN_INFO "EXT4-fs: file extents enabled"
+		printk(KERN_INFO "EXT4-fs (%s): file extents enabled"
 #ifdef AGGRESSIVE_TEST
 		       ", aggressive tests"
 #endif
@@ -3067,8 +3074,36 @@ void ext4_ext_init(struct super_block *sb)
 #ifdef EXTENTS_STATS
 		       ", stats"
 #endif
-		       "\n");
+		       , sb->s_id);
+
+
+		EXT4_SB(sb)->s_max_ext_tree_depth = 1;
+
+		maxblocks = sb->s_maxbytes / sb->s_blocksize;
+
+		/* 1st/root level/node of extents tree stands in i_data and
+		 * entries stored in tree nodes can be of type ext4_extent
+		 * (leaf node) or ext4_extent_idx (internal node) */
+		maxblocks /= (sizeof(((struct ext4_inode_info *)0x0)->i_data) -
+			      sizeof(struct ext4_extent_header)) /
+			     max(sizeof(struct ext4_extent),
+				 sizeof(struct ext4_extent_idx));
+
+		/* compute maximum extents tree depth for a fully populated
+		 * file of max size made of only minimal/1-block extents */
+		while (maxblocks > 0) {
+			maxblocks /= (sb->s_blocksize -
+				      sizeof(struct ext4_extent_header)) /
+				     max(sizeof(struct ext4_extent),
+					 sizeof(struct ext4_extent_idx));
+			EXT4_SB(sb)->s_max_ext_tree_depth++;
+		}
+
+#ifdef EXT_DEBUG
+		printk(", maximum tree depth=%u",
+		       EXT4_SB(sb)->s_max_ext_tree_depth);
 #endif
+		printk("\n");
 #ifdef EXTENTS_STATS
 		spin_lock_init(&EXT4_SB(sb)->s_ext_stats_lock);
 		EXT4_SB(sb)->s_ext_min = 1 << 30;
@@ -5348,18 +5383,18 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 		       ext4_lblk_t start, ext4_lblk_t shift,
 		       enum SHIFT_DIRECTION SHIFT)
 {
-	struct ext4_ext_path *path;
+	struct ext4_ext_path *path, *orig_path;
 	int ret = 0, depth;
 	struct ext4_extent *extent;
 	ext4_lblk_t stop, *iterator, ex_start, ex_end;
 
 	/* Let path point to the last extent */
-	path = ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
-	if (IS_ERR(path))
-		return PTR_ERR(path);
+	orig_path = ext4_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
+	if (IS_ERR(orig_path))
+		return PTR_ERR(orig_path);
 
-	depth = path->p_depth;
-	extent = path[depth].p_ext;
+	depth = orig_path->p_depth;
+	extent = orig_path[depth].p_ext;
 	if (!extent)
 		goto out;
 
@@ -5371,9 +5406,11 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * sure the hole is big enough to accommodate the shift.
 	*/
 	if (SHIFT == SHIFT_LEFT) {
-		path = ext4_find_extent(inode, start - 1, &path, 0);
-		if (IS_ERR(path))
-			return PTR_ERR(path);
+		path = ext4_find_extent(inode, start - 1, &orig_path, 0);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
+			goto out;
+		}
 		depth = path->p_depth;
 		extent =  path[depth].p_ext;
 		if (extent) {
@@ -5387,9 +5424,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 
 		if ((start == ex_start && shift > ex_start) ||
 		    (shift > start - ex_end)) {
-			ext4_ext_drop_refs(path);
-			kfree(path);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -5405,15 +5441,18 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 
 	/* Its safe to start updating extents */
 	while (start < stop) {
-		path = ext4_find_extent(inode, *iterator, &path, 0);
-		if (IS_ERR(path))
-			return PTR_ERR(path);
+		path = ext4_find_extent(inode, *iterator, &orig_path, 0);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
+			goto out;
+		}
 		depth = path->p_depth;
 		extent = path[depth].p_ext;
 		if (!extent) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
 					 (unsigned long) *iterator);
-			return -EFSCORRUPTED;
+			ret =  -EFSCORRUPTED;
+			goto out;
 		}
 		if (SHIFT == SHIFT_LEFT && *iterator >
 		    le32_to_cpu(extent->ee_block)) {
@@ -5445,8 +5484,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 			break;
 	}
 out:
-	ext4_ext_drop_refs(path);
-	kfree(path);
+	ext4_ext_drop_refs(orig_path);
+	kfree(orig_path);
 	return ret;
 }
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index fb6f117..7c319c5 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -39,13 +39,11 @@ get_ext_path(struct inode *inode, ext4_lblk_t lblock,
 	path = ext4_find_extent(inode, lblock, ppath, EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
-	if (path[ext_depth(inode)].p_ext == NULL) {
-		ext4_ext_drop_refs(path);
-		kfree(path);
-		*ppath = NULL;
+	if (path[ext_depth(inode)].p_ext == NULL)
 		return -ENODATA;
-	}
-	*ppath = path;
+	if (*ppath == NULL)
+		*ppath = path;
+	/* XXX else BUG_ON(path != *ppath); */
 	return 0;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 486e869..199157a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3701,6 +3701,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		if (ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block)))
 			goto failed_mount3a;
 
+	ext4_ext_init(sb); /* needed before using extent-mapped journal */
+
 	/*
 	 * The first inode we look at is the journal inode.  Don't try
 	 * root first: it may be modified in the journal!
@@ -3894,7 +3896,6 @@ no_journal:
 		goto failed_mount4a;
 	}
 
-	ext4_ext_init(sb);
 	err = ext4_mb_init(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
--

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

