From: Avantika Mathur <mathur@us.ibm.com>
Subject: [PATCH 1/3] if expression format
Date: Mon, 27 Nov 2006 16:09:02 -0800
Message-ID: <1164672542.10750.18.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:65474 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S933585AbWK1AK1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Nov 2006 19:10:27 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAS0ApwU002062
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:51 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAS0ARga305868
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:27 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAS0AQQA001303
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:26 -0500
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Avantika Mathur <mathur@us.ibm.com>

changes instances of
	if ((lhs = expression)) {

to the preferred coding style

	lhs=expression;
	if (lhs) {

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
 fs/ext4/extents.c |   65 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 22 deletions(-)

Index: linux-2.6.19-rc6-mm1/fs/ext4/extents.c
===================================================================
--- linux-2.6.19-rc6-mm1.orig/fs/ext4/extents.c
+++ linux-2.6.19-rc6-mm1/fs/ext4/extents.c
@@ -186,7 +186,8 @@ static ext4_fsblk_t ext4_ext_find_goal(s
 		depth = path->p_depth;
 
 		/* try to predict block placement */
-		if ((ex = path[depth].p_ext))
+		ex = path[depth].p_ext;
+		if (ex)
 			return ext_pblock(ex)+(block-le32_to_cpu(ex->ee_block));
 
 		/* it looks like index is empty;
@@ -542,8 +543,9 @@ static int ext4_ext_insert_index(handle_
 {
 	struct ext4_extent_idx *ix;
 	int len, err;
-
-	if ((err = ext4_ext_get_access(handle, inode, curp)))
+	
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
