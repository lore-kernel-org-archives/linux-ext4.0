From: Alex Tomas <alex@clusterfs.com>
Subject: [PATCH] sanity checks for on-disk data in extents code
Date: Sat, 17 Feb 2007 00:57:35 +0300
Message-ID: <m364a1wys5.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.245.246] ([80.71.245.246]:54525 "EHLO nsold.rialcom.ru"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946248AbXBPW16 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 17:27:58 -0500
Received: from nsold.rialcom.ru (localhost.rialcom.ru [127.0.0.1])
	by nsold.rialcom.ru (Postfix) with ESMTP id 206D6BC890
	for <linux-ext4@vger.kernel.org>; Sat, 17 Feb 2007 00:58:00 +0300 (MSK)
Received: from gw.home.net (unknown [80.71.248.82])
	by nsold.rialcom.ru (Postfix) with ESMTP id C43DFBC881
	for <linux-ext4@vger.kernel.org>; Sat, 17 Feb 2007 00:57:59 +0300 (MSK)
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id l1GMtoTN022559
	for <linux-ext4@vger.kernel.org>; Sat, 17 Feb 2007 01:55:51 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Good day,

with the patch all headers are checked. the code should become
more resistant to on-disk corruptions. needless BUG_ON() have
been removed. please, review for inclusion.

thanks, Alex


Signed-off-by: Alex Tomas <alex@clusterfs.com>

Index: linux-2.6.20/fs/ext4/extents.c
===================================================================
--- linux-2.6.20.orig/fs/ext4/extents.c	2007-02-17 00:34:32.000000000 +0300
+++ linux-2.6.20/fs/ext4/extents.c	2007-02-17 00:50:24.000000000 +0300
@@ -92,36 +92,6 @@
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
@@ -270,6 +240,70 @@
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
 #ifdef EXT_DEBUG
 static void ext4_ext_show_path(struct inode *inode, struct ext4_ext_path *path)
 {
@@ -330,6 +364,7 @@
 /*
  * ext4_ext_binsearch_idx:
  * binary search for the closest index of the given block
+ * the header must be checked before calling this
  */
 static void
 ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int block)
@@ -337,9 +372,6 @@
 	struct ext4_extent_header *eh = path->p_hdr;
 	struct ext4_extent_idx *r, *l, *m;
 
-	BUG_ON(eh->eh_magic != EXT4_EXT_MAGIC);
-	BUG_ON(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max));
-	BUG_ON(le16_to_cpu(eh->eh_entries) <= 0);
 
 	ext_debug("binsearch for %d(idx):  ", block);
 
@@ -389,6 +421,7 @@
 /*
  * ext4_ext_binsearch:
  * binary search for closest extent of the given block
+ * the header must be checked before calling this
  */
 static void
 ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
@@ -396,9 +429,6 @@
 	struct ext4_extent_header *eh = path->p_hdr;
 	struct ext4_extent *r, *l, *m;
 
-	BUG_ON(eh->eh_magic != EXT4_EXT_MAGIC);
-	BUG_ON(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max));
-
 	if (eh->eh_entries == 0) {
 		/*
 		 * this leaf is empty:
@@ -469,11 +499,10 @@
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
@@ -489,6 +518,7 @@
 	while (i) {
 		ext_debug("depth %d: num %d, max %d\n",
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
+
 		ext4_ext_binsearch_idx(inode, path + ppos, block);
 		path[ppos].p_block = idx_pblock(path[ppos].p_idx);
 		path[ppos].p_depth = i;
@@ -505,7 +535,7 @@
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (ext4_ext_check_header(__FUNCTION__, inode, eh))
+		if (ext4_ext_check_header(inode, eh, i))
 			goto err;
 	}
 
@@ -514,9 +544,6 @@
 	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
-	if (ext4_ext_check_header(__FUNCTION__, inode, eh))
-		goto err;
-
 	/* find extent */
 	ext4_ext_binsearch(inode, path + ppos, block);
 
@@ -1625,13 +1652,12 @@
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
@@ -1777,7 +1803,7 @@
 		return -ENOMEM;
 	}
 	path[0].p_hdr = ext_inode_hdr(inode);
-	if (ext4_ext_check_header(__FUNCTION__, inode, path[0].p_hdr)) {
+	if (ext4_ext_check_header(inode, path[0].p_hdr, depth)) {
 		err = -EIO;
 		goto out;
 	}
@@ -1798,17 +1824,8 @@
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
@@ -1825,17 +1842,24 @@
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
