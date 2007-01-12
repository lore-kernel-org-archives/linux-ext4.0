From: Alex Tomas <alex@clusterfs.com>
Subject: [PATCH] more sanity check in extents
Date: Fri, 12 Jan 2007 03:18:49 +0300
Message-ID: <m364bd85cm.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:58995 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbXALASy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jan 2007 19:18:54 -0500
Received: from [85.141.215.181] (HELO gw.home.net)
  by fe02-umail.umail.ru (CommuniGate Pro SMTP 5.0.12)
  with ESMTPS id 76663056 for linux-ext4@vger.kernel.org; Fri, 12 Jan 2007 03:18:50 +0300
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id l0C1GMbD018323
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2007 04:16:23 +0300
To: <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Good day,

please consider the patch for inclusion. with the patch,
extents will catch more corruptions in headers (eh_max,
eh_depth) and inconsistency when key in the index isn't
in sync with the first key in the block the index points to.

thanks, Alex


additional sanity checks in extents

Signed-off-by: Alex Tomas <alex@clusterfs.com>

Index: linux-2.6.20-rc1/fs/ext4/extents.c
===================================================================
--- linux-2.6.20-rc1.orig/fs/ext4/extents.c	2006-12-14 04:14:23.000000000 +0300
+++ linux-2.6.20-rc1/fs/ext4/extents.c	2007-01-12 02:34:04.000000000 +0300
@@ -92,36 +92,6 @@ static void ext4_idx_store_pblock(struct
 	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
-static int ext4_ext_check_header(const char *function, struct inode *inode,
-				struct ext4_extent_header *eh)
-{
-	const char *error_msg = NULL;
-
-	if (unlikely(eh->eh_magic != EXT4_EXT_MAGIC)) {
-		error_msg = "invalid magic";
-		goto corrupted;
-	}
-	if (unlikely(eh->eh_max == 0)) {
-		error_msg = "invalid eh_max";
-		goto corrupted;
-	}
-	if (unlikely(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max))) {
-		error_msg = "invalid eh_entries";
-		goto corrupted;
-	}
-	return 0;
-
-corrupted:
-	ext4_error(inode->i_sb, function,
-			"bad header in inode #%lu: %s - magic %x, "
-			"entries %u, max %u, depth %u",
-			inode->i_ino, error_msg, le16_to_cpu(eh->eh_magic),
-			le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
-			le16_to_cpu(eh->eh_depth));
-
-	return -EIO;
-}
-
 static handle_t *ext4_ext_journal_restart(handle_t *handle, int needed)
 {
 	int err;
@@ -270,6 +241,111 @@ static int ext4_ext_space_root_idx(struc
 	return size;
 }
 
+static inline int
+ext4_ext_max_entries(struct inode *inode, int depth)
+{
+	int max;
+
+	if (depth == ext_depth(inode)) {
+		if (depth == 0)
+			max = ext4_ext_space_root(inode);
+		else
+			max = ext4_ext_space_root_idx(inode);
+	} else {
+		if (depth == 0)
+			max = ext4_ext_space_block(inode);
+		else
+			max = ext4_ext_space_block_idx(inode);
+	}
+
+	return max;
+}
+
+static int __ext4_ext_check_header(const char *function, struct inode *inode,
+					struct ext4_extent_header *eh,
+					int depth)
+{
+	const char *error_msg = NULL;
+	int max = 0;
+
+	if (unlikely(eh->eh_magic != EXT4_EXT_MAGIC)) {
+		error_msg = "invalid magic";
+		goto corrupted;
+	}
+	if (unlikely(le16_to_cpu(eh->eh_depth) != depth)) {
+		error_msg = "unexpected eh_depth";
+		goto corrupted;
+	}
+	if (unlikely(eh->eh_max == 0)) {
+		error_msg = "invalid eh_max";
+		goto corrupted;
+	}
+	max = ext4_ext_max_entries(inode, depth);
+	if (unlikely(le16_to_cpu(eh->eh_max) > max)) {
+		error_msg = "too large eh_max";
+		goto corrupted;
+	}
+	if (unlikely(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max))) {
+		error_msg = "invalid eh_entries";
+		goto corrupted;
+	}
+	return 0;
+
+corrupted:
+	ext4_error(inode->i_sb, function,
+			"bad header in inode #%lu: %s - magic %x, "
+			"entries %u, max %u(%u), depth %u(%u)",
+			inode->i_ino, error_msg, le16_to_cpu(eh->eh_magic),
+			le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
+			max, le16_to_cpu(eh->eh_depth), depth);
+
+	return -EIO;
+}
+
+#define ext4_ext_check_header(inode,eh,depth)	\
+	__ext4_ext_check_header(__FUNCTION__,inode,eh,depth)
+
+/*
+ * the routine checks that every block start with key value specified
+ * in the pointed at the upper layer
+ */
+static int __ext4_ext_check_interlevel(const char *function, struct inode *inode,
+					struct ext4_ext_path *path, int depth)
+{
+	unsigned long key, first;
+
+	if (ext_depth(inode) == 0)
+		return 0;
+
+	/* nothing to check at the top */
+	if (depth == ext_depth(inode))
+		return 0;
+
+	/* after split, a leaf can get zero entries
+	 * thus there is nothing to check */
+	if (le16_to_cpu(path->p_hdr->eh_entries) == 0)
+		return 0;
+
+	if (depth == 0)
+		first = le32_to_cpu(EXT_FIRST_EXTENT(path->p_hdr)->ee_block);
+	else
+		first = le32_to_cpu(EXT_FIRST_INDEX(path->p_hdr)->ei_block);
+	path--;
+	key = le32_to_cpu(path->p_idx->ei_block);
+	
+	if (likely(first == key))
+		return 0;
+
+	ext4_error(inode->i_sb, function,
+			"interlevel inconsistency in inode #%lu: "
+			"%lu at current level %d/%d, %lu expected",
+			inode->i_ino, first, depth, ext_depth(inode), key);
+	return -EIO;
+}
+
+#define ext4_ext_check_interlevel(inode,path,depth)	\
+		__ext4_ext_check_interlevel(__FUNCTION__,inode,path,depth)
+
 #ifdef EXT_DEBUG
 static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 {
@@ -330,6 +406,7 @@ static void ext4_ext_drop_refs(struct ex
 /*
  * ext4_ext_binsearch_idx:
  * binary search for the closest index of the given block
+ * the header must be checked before calling this
  */
 static void
 ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int block)
@@ -337,9 +414,6 @@ ext4_ext_binsearch_idx(struct inode *ino
 	struct ext4_extent_header *eh = path->p_hdr;
 	struct ext4_extent_idx *r, *l, *m;
 
-	BUG_ON(eh->eh_magic != EXT4_EXT_MAGIC);
-	BUG_ON(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max));
-	BUG_ON(le16_to_cpu(eh->eh_entries) <= 0);
 
 	ext_debug("binsearch for %d(idx):  ", block);
 
@@ -389,6 +463,7 @@ ext4_ext_binsearch_idx(struct inode *ino
 /*
  * ext4_ext_binsearch:
  * binary search for closest extent of the given block
+ * the header must be checked before calling this
  */
 static void
 ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
@@ -396,9 +471,6 @@ ext4_ext_binsearch(struct inode *inode, 
 	struct ext4_extent_header *eh = path->p_hdr;
 	struct ext4_extent *r, *l, *m;
 
-	BUG_ON(eh->eh_magic != EXT4_EXT_MAGIC);
-	BUG_ON(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max));
-
 	if (eh->eh_entries == 0) {
 		/*
 		 * this leaf is empty:
@@ -469,11 +541,10 @@ ext4_ext_find_extent(struct inode *inode
 	short int depth, i, ppos = 0, alloc = 0;
 
 	eh = ext_inode_hdr(inode);
-	BUG_ON(eh == NULL);
-	if (ext4_ext_check_header(__FUNCTION__, inode, eh))
+	i = depth = ext_depth(inode);
+	if (ext4_ext_check_header(inode, eh, depth))
 		return ERR_PTR(-EIO);
 
-	i = depth = ext_depth(inode);
 
 	/* account possible depth increase */
 	if (!path) {
@@ -489,6 +560,10 @@ ext4_ext_find_extent(struct inode *inode
 	while (i) {
 		ext_debug("depth %d: num %d, max %d\n",
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
+
+		if (ext4_ext_check_interlevel(inode, path + ppos, i))
+			goto err;
+
 		ext4_ext_binsearch_idx(inode, path + ppos, block);
 		path[ppos].p_block = idx_pblock(path[ppos].p_idx);
 		path[ppos].p_depth = i;
@@ -505,7 +580,7 @@ ext4_ext_find_extent(struct inode *inode
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (ext4_ext_check_header(__FUNCTION__, inode, eh))
+		if (ext4_ext_check_header(inode, eh, i))
 			goto err;
 	}
 
@@ -514,10 +589,9 @@ ext4_ext_find_extent(struct inode *inode
 	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
-	if (ext4_ext_check_header(__FUNCTION__, inode, eh))
-		goto err;
-
 	/* find extent */
+	if (ext4_ext_check_interlevel(inode, path + ppos, i))
+		goto err;
 	ext4_ext_binsearch(inode, path + ppos, block);
 
 	ext4_ext_show_path(inode, path);
@@ -1625,13 +1699,12 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 	unsigned short ex_ee_len;
 	struct ext4_extent *ex;
 
+	/* the header must be checked already in ext4_ext_remove_space() */
 	ext_debug("truncate since %lu in leaf\n", start);
 	if (!path[depth].p_hdr)
 		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
 	eh = path[depth].p_hdr;
 	BUG_ON(eh == NULL);
-	BUG_ON(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max));
-	BUG_ON(eh->eh_magic != EXT4_EXT_MAGIC);
 
 	/* find where to start removing */
 	ex = EXT_LAST_EXTENT(eh);
@@ -1777,7 +1850,7 @@ int ext4_ext_remove_space(struct inode *
 		return -ENOMEM;
 	}
 	path[0].p_hdr = ext_inode_hdr(inode);
-	if (ext4_ext_check_header(__FUNCTION__, inode, path[0].p_hdr)) {
+	if (ext4_ext_check_header(inode, path[0].p_hdr, depth)) {
 		err = -EIO;
 		goto out;
 	}
@@ -1798,17 +1871,8 @@ int ext4_ext_remove_space(struct inode *
 		if (!path[i].p_hdr) {
 			ext_debug("initialize header\n");
 			path[i].p_hdr = ext_block_hdr(path[i].p_bh);
-			if (ext4_ext_check_header(__FUNCTION__, inode,
-							path[i].p_hdr)) {
-				err = -EIO;
-				goto out;
-			}
 		}
 
-		BUG_ON(le16_to_cpu(path[i].p_hdr->eh_entries)
-			   > le16_to_cpu(path[i].p_hdr->eh_max));
-		BUG_ON(path[i].p_hdr->eh_magic != EXT4_EXT_MAGIC);
-
 		if (!path[i].p_idx) {
 			/* this level hasn't been touched yet */
 			path[i].p_idx = EXT_LAST_INDEX(path[i].p_hdr);
@@ -1825,17 +1889,24 @@ int ext4_ext_remove_space(struct inode *
 				i, EXT_FIRST_INDEX(path[i].p_hdr),
 				path[i].p_idx);
 		if (ext4_ext_more_to_rm(path + i)) {
+			struct buffer_head *bh;
 			/* go to the next level */
 			ext_debug("move to level %d (block %llu)\n",
 				  i + 1, idx_pblock(path[i].p_idx));
 			memset(path + i + 1, 0, sizeof(*path));
-			path[i+1].p_bh =
-				sb_bread(sb, idx_pblock(path[i].p_idx));
-			if (!path[i+1].p_bh) {
+			bh = sb_bread(sb, idx_pblock(path[i].p_idx));
+			if (!bh) {
 				/* should we reset i_size? */
 				err = -EIO;
 				break;
 			}
+			BUG_ON(i + 1 > depth);
+			if (ext4_ext_check_header(inode, ext_block_hdr(bh),
+							depth - i - 1)) {
+				err = -EIO;
+				break;
+			}
+			path[i+1].p_bh = bh;
 
 			/* save actual number of indexes since this
 			 * number is changed at the next iteration */
