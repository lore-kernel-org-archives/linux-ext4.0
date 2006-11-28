From: akpm@osdl.org
Subject: + ext4-if-expression-format.patch added to -mm tree
Date: Mon, 27 Nov 2006 17:29:39 -0800
Message-ID: <200611280129.kAS1TdTn022519@shell0.pdx.osdl.net>
Cc: mathur@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59031 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S933465AbWK1B3s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Nov 2006 20:29:48 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: if expression format
has been added to the -mm tree.  Its filename is
     ext4-if-expression-format.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: if expression format
From: Avantika Mathur <mathur@us.ibm.com>

changes instances of
	if ((lhs = expression)) {

to the preferred coding style

	lhs=expression;
	if (lhs) {

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/extents.c |   63 +++++++++++++++++++++++++++++---------------
 1 files changed, 42 insertions(+), 21 deletions(-)

diff -puN fs/ext4/extents.c~ext4-if-expression-format fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-if-expression-format
+++ a/fs/ext4/extents.c
@@ -186,7 +186,8 @@ static ext4_fsblk_t ext4_ext_find_goal(s
 		depth = path->p_depth;
 
 		/* try to predict block placement */
-		if ((ex = path[depth].p_ext))
+		ex = path[depth].p_ext;
+		if (ex)
 			return ext_pblock(ex)+(block-le32_to_cpu(ex->ee_block));
 
 		/* it looks like index is empty;
@@ -543,7 +544,8 @@ static int ext4_ext_insert_index(handle_
 	struct ext4_extent_idx *ix;
 	int len, err;
 
-	if ((err = ext4_ext_get_access(handle, inode, curp)))
+	err = ext4_ext_get_access(handle, inode, curp);
+	if (err)
 		return err;
 
 	BUG_ON(logical == le32_to_cpu(curp->p_idx->ei_block));
@@ -665,7 +667,8 @@ static int ext4_ext_split(handle_t *hand
 	}
 	lock_buffer(bh);
 
-	if ((err = ext4_journal_get_create_access(handle, bh)))
+	err = ext4_journal_get_create_access(handle, bh);
+	if (err)
 		goto cleanup;
 
 	neh = ext_block_hdr(bh);
@@ -702,18 +705,21 @@ static int ext4_ext_split(handle_t *hand
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
-	if ((err = ext4_journal_dirty_metadata(handle, bh)))
+	err = ext4_journal_dirty_metadata(handle, bh);
+	if (err)
 		goto cleanup;
 	brelse(bh);
 	bh = NULL;
 
 	/* correct old leaf */
 	if (m) {
-		if ((err = ext4_ext_get_access(handle, inode, path + depth)))
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (err)
 			goto cleanup;
 		path[depth].p_hdr->eh_entries =
 		     cpu_to_le16(le16_to_cpu(path[depth].p_hdr->eh_entries)-m);
-		if ((err = ext4_ext_dirty(handle, inode, path + depth)))
+		err = ext4_ext_dirty(handle, inode, path + depth);
+		if (err)
 			goto cleanup;
 
 	}
@@ -736,7 +742,8 @@ static int ext4_ext_split(handle_t *hand
 		}
 		lock_buffer(bh);
 
-		if ((err = ext4_journal_get_create_access(handle, bh)))
+		err = ext4_journal_get_create_access(handle, bh);
+		if (err)
 			goto cleanup;
 
 		neh = ext_block_hdr(bh);
@@ -780,7 +787,8 @@ static int ext4_ext_split(handle_t *hand
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
-		if ((err = ext4_journal_dirty_metadata(handle, bh)))
+		err = ext4_journal_dirty_metadata(handle, bh);
+		if (err)
 			goto cleanup;
 		brelse(bh);
 		bh = NULL;
@@ -854,7 +862,8 @@ static int ext4_ext_grow_indepth(handle_
 	}
 	lock_buffer(bh);
 
-	if ((err = ext4_journal_get_create_access(handle, bh))) {
+	err = ext4_journal_get_create_access(handle, bh);
+	if (err) {
 		unlock_buffer(bh);
 		goto out;
 	}
@@ -874,11 +883,13 @@ static int ext4_ext_grow_indepth(handle_
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
-	if ((err = ext4_journal_dirty_metadata(handle, bh)))
+	err = ext4_journal_dirty_metadata(handle, bh);
+	if (err)
 		goto out;
 
 	/* create index in new top-level index: num,max,pointer */
-	if ((err = ext4_ext_get_access(handle, inode, curp)))
+	err = ext4_ext_get_access(handle, inode, curp);
+	if (err)
 		goto out;
 
 	curp->p_hdr->eh_magic = EXT4_EXT_MAGIC;
@@ -1070,20 +1081,24 @@ int ext4_ext_correct_indexes(handle_t *h
 	 */
 	k = depth - 1;
 	border = path[depth].p_ext->ee_block;
-	if ((err = ext4_ext_get_access(handle, inode, path + k)))
+	err = ext4_ext_get_access(handle, inode, path + k);
+	if (err)
 		return err;
 	path[k].p_idx->ei_block = border;
-	if ((err = ext4_ext_dirty(handle, inode, path + k)))
+	err = ext4_ext_dirty(handle, inode, path + k);
+	if (err)
 		return err;
 
 	while (k--) {
 		/* change all left-side indexes */
 		if (path[k+1].p_idx != EXT_FIRST_INDEX(path[k+1].p_hdr))
 			break;
-		if ((err = ext4_ext_get_access(handle, inode, path + k)))
+		err = ext4_ext_get_access(handle, inode, path + k);
+		if (err)
 			break;
 		path[k].p_idx->ei_block = border;
-		if ((err = ext4_ext_dirty(handle, inode, path + k)))
+		err = ext4_ext_dirty(handle, inode, path + k);
+		if (err)
 			break;
 	}
 
@@ -1142,7 +1157,8 @@ int ext4_ext_insert_extent(handle_t *han
 				le16_to_cpu(newext->ee_len),
 				le32_to_cpu(ex->ee_block),
 				le16_to_cpu(ex->ee_len), ext_pblock(ex));
-		if ((err = ext4_ext_get_access(handle, inode, path + depth)))
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (err)
 			return err;
 		ex->ee_len = cpu_to_le16(le16_to_cpu(ex->ee_len)
 					 + le16_to_cpu(newext->ee_len));
@@ -1192,7 +1208,8 @@ repeat:
 has_space:
 	nearex = path[depth].p_ext;
 
-	if ((err = ext4_ext_get_access(handle, inode, path + depth)))
+	err = ext4_ext_get_access(handle, inode, path + depth);
+	if (err)
 		goto cleanup;
 
 	if (!nearex) {
@@ -1486,10 +1503,12 @@ int ext4_ext_rm_idx(handle_t *handle, st
 	path--;
 	leaf = idx_pblock(path->p_idx);
 	BUG_ON(path->p_hdr->eh_entries == 0);
-	if ((err = ext4_ext_get_access(handle, inode, path)))
+	err = ext4_ext_get_access(handle, inode, path);
+	if (err)
 		return err;
 	path->p_hdr->eh_entries = cpu_to_le16(le16_to_cpu(path->p_hdr->eh_entries)-1);
-	if ((err = ext4_ext_dirty(handle, inode, path)))
+	err = ext4_ext_dirty(handle, inode, path);
+	if (err)
 		return err;
 	ext_debug("index is empty, remove it, free block %llu\n", leaf);
 	bh = sb_find_get_block(inode->i_sb, leaf);
@@ -1929,7 +1948,8 @@ int ext4_ext_get_blocks(handle_t *handle
 	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 
 	/* check in cache */
-	if ((goal = ext4_ext_in_cache(inode, iblock, &newex))) {
+	goal = ext4_ext_in_cache(inode, iblock, &newex);
+	if (goal) {
 		if (goal == EXT4_EXT_CACHE_GAP) {
 			if (!create) {
 				/* block isn't allocated yet and
@@ -1968,7 +1988,8 @@ int ext4_ext_get_blocks(handle_t *handle
 	 */
 	BUG_ON(path[depth].p_ext == NULL && depth != 0);
 
-	if ((ex = path[depth].p_ext)) {
+	ex = path[depth].p_ext;
+	if (ex) {
 	        unsigned long ee_block = le32_to_cpu(ex->ee_block);
 		ext4_fsblk_t ee_start = ext_pblock(ex);
 		unsigned short ee_len  = le16_to_cpu(ex->ee_len);
_

Patches currently in -mm which might be from mathur@us.ibm.com are

ext4-if-expression-format.patch
ext4-kmalloc-to-kzalloc.patch
ext4-eliminate-inline-functions.patch
