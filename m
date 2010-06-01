From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 27/40] ext4: Do not zero out uninitialized extents beyond i_size
Date: Tue,  1 Jun 2010 08:03:14 -0400
Message-ID: <1275393807-14369-27-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47329 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061Ab0FAMDi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:38 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 21ca087a3891efab4d45488db8febee474d26c68 upstream (as of v2.6.34-git13)

The extents code will sometimes zero out blocks and mark them as
initialized instead of splitting an extent into several smaller ones.
This optimization however, causes problems if the extent is beyond
i_size because fsck will complain if there are uninitialized blocks
after i_size as this can not be distinguished from an inode that has
an incorrect i_size field.

https://bugzilla.kernel.org/show_bug.cgi?id=15742

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |   67 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 032c95b..39aab5c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2527,11 +2527,21 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	struct ext4_extent *ex2 = NULL;
 	struct ext4_extent *ex3 = NULL;
 	struct ext4_extent_header *eh;
-	ext4_lblk_t ee_block;
+	ext4_lblk_t ee_block, eof_block;
 	unsigned int allocated, ee_len, depth;
 	ext4_fsblk_t newblock;
 	int err = 0;
 	int ret = 0;
+	int may_zeroout;
+
+	ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
+		"block %llu, max_blocks %u\n", inode->i_ino,
+		(unsigned long long)iblock, max_blocks);
+
+	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+		inode->i_sb->s_blocksize_bits;
+	if (eof_block < iblock + max_blocks)
+		eof_block = iblock + max_blocks;
 
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
@@ -2540,16 +2550,23 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	ee_len = ext4_ext_get_actual_len(ex);
 	allocated = ee_len - (iblock - ee_block);
 	newblock = iblock - ee_block + ext_pblock(ex);
+
 	ex2 = ex;
 	orig_ex.ee_block = ex->ee_block;
 	orig_ex.ee_len   = cpu_to_le16(ee_len);
 	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
 
+	/*
+	 * It is safe to convert extent to initialized via explicit
+	 * zeroout only if extent is fully insde i_size or new_size.
+	 */
+	may_zeroout = ee_block + ee_len <= eof_block;
+
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
 		goto out;
 	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
-	if (ee_len <= 2*EXT4_EXT_ZERO_LEN) {
+	if (ee_len <= 2*EXT4_EXT_ZERO_LEN && may_zeroout) {
 		err =  ext4_ext_zeroout(inode, &orig_ex);
 		if (err)
 			goto fix_extent_len;
@@ -2580,7 +2597,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	if (allocated > max_blocks) {
 		unsigned int newdepth;
 		/* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
-		if (allocated <= EXT4_EXT_ZERO_LEN) {
+		if (allocated <= EXT4_EXT_ZERO_LEN && may_zeroout) {
 			/*
 			 * iblock == ee_block is handled by the zerouout
 			 * at the beginning.
@@ -2656,7 +2673,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
 		err = ext4_ext_insert_extent(handle, inode, path, ex3, 0);
-		if (err == -ENOSPC) {
+		if (err == -ENOSPC && may_zeroout) {
 			err =  ext4_ext_zeroout(inode, &orig_ex);
 			if (err)
 				goto fix_extent_len;
@@ -2680,8 +2697,10 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		 * update the extent length after successful insert of the
 		 * split extent
 		 */
-		orig_ex.ee_len = cpu_to_le16(ee_len -
-						ext4_ext_get_actual_len(ex3));
+		ee_len -= ext4_ext_get_actual_len(ex3);
+		orig_ex.ee_len = cpu_to_le16(ee_len);
+		may_zeroout = ee_block + ee_len <= eof_block;
+
 		depth = newdepth;
 		ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode, iblock, path);
@@ -2705,7 +2724,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		 * otherwise give the extent a chance to merge to left
 		 */
 		if (le16_to_cpu(orig_ex.ee_len) <= EXT4_EXT_ZERO_LEN &&
-							iblock != ee_block) {
+			iblock != ee_block && may_zeroout) {
 			err =  ext4_ext_zeroout(inode, &orig_ex);
 			if (err)
 				goto fix_extent_len;
@@ -2774,7 +2793,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	goto out;
 insert:
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
-	if (err == -ENOSPC) {
+	if (err == -ENOSPC && may_zeroout) {
 		err =  ext4_ext_zeroout(inode, &orig_ex);
 		if (err)
 			goto fix_extent_len;
@@ -2834,14 +2853,21 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	struct ext4_extent *ex2 = NULL;
 	struct ext4_extent *ex3 = NULL;
 	struct ext4_extent_header *eh;
-	ext4_lblk_t ee_block;
+	ext4_lblk_t ee_block, eof_block;
 	unsigned int allocated, ee_len, depth;
 	ext4_fsblk_t newblock;
 	int err = 0;
+	int may_zeroout;
+
+	ext_debug("ext4_split_unwritten_extents: inode %lu, logical"
+		"block %llu, max_blocks %u\n", inode->i_ino,
+		(unsigned long long)iblock, max_blocks);
+
+	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
+		inode->i_sb->s_blocksize_bits;
+	if (eof_block < iblock + max_blocks)
+		eof_block = iblock + max_blocks;
 
-	ext_debug("ext4_split_unwritten_extents: inode %lu,"
-		  "iblock %llu, max_blocks %u\n", inode->i_ino,
-		  (unsigned long long)iblock, max_blocks);
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
 	ex = path[depth].p_ext;
@@ -2849,12 +2875,19 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	ee_len = ext4_ext_get_actual_len(ex);
 	allocated = ee_len - (iblock - ee_block);
 	newblock = iblock - ee_block + ext_pblock(ex);
+
 	ex2 = ex;
 	orig_ex.ee_block = ex->ee_block;
 	orig_ex.ee_len   = cpu_to_le16(ee_len);
 	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
 
 	/*
+	 * It is safe to convert extent to initialized via explicit
+	 * zeroout only if extent is fully insde i_size or new_size.
+	 */
+	may_zeroout = ee_block + ee_len <= eof_block;
+
+	/*
  	 * If the uninitialized extent begins at the same logical
  	 * block where the write begins, and the write completely
  	 * covers the extent, then we don't need to split it.
@@ -2888,7 +2921,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
 		err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
-		if (err == -ENOSPC) {
+		if (err == -ENOSPC && may_zeroout) {
 			err =  ext4_ext_zeroout(inode, &orig_ex);
 			if (err)
 				goto fix_extent_len;
@@ -2912,8 +2945,10 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 		 * update the extent length after successful insert of the
 		 * split extent
 		 */
-		orig_ex.ee_len = cpu_to_le16(ee_len -
-						ext4_ext_get_actual_len(ex3));
+		ee_len -= ext4_ext_get_actual_len(ex3);
+		orig_ex.ee_len = cpu_to_le16(ee_len);
+		may_zeroout = ee_block + ee_len <= eof_block;
+
 		depth = newdepth;
 		ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode, iblock, path);
@@ -2959,7 +2994,7 @@ static int ext4_split_unwritten_extents(handle_t *handle,
 	goto out;
 insert:
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
-	if (err == -ENOSPC) {
+	if (err == -ENOSPC && may_zeroout) {
 		err =  ext4_ext_zeroout(inode, &orig_ex);
 		if (err)
 			goto fix_extent_len;
-- 
1.6.6.1.1.g974db.dirty

