From: akpm@linux-foundation.org
Subject: - ext3-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:59 -0700
Message-ID: <200804282200.m3SM0xva018797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: harvey.harrison@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     ext3-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c   |   12 +++----
 fs/ext3/ext3_jbd.c |   12 +++----
 fs/ext3/ialloc.c   |    6 +--
 fs/ext3/inode.c    |    6 +--
 fs/ext3/namei.c    |   26 +++++++--------
 fs/ext3/resize.c   |   70 +++++++++++++++++++++----------------------
 fs/ext3/super.c    |   14 ++++----
 fs/ext3/xattr.c    |   14 ++++----
 8 files changed, 80 insertions(+), 80 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-replace-remaining-__function__-occurrences fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/balloc.c
@@ -117,7 +117,7 @@ static int ext3_valid_block_bitmap(struc
 		return 1;
 
 err_out:
-	ext3_error(sb, __FUNCTION__,
+	ext3_error(sb, __func__,
 			"Invalid block bitmap - "
 			"block_group = %d, block = %lu",
 			block_group, bitmap_blk);
@@ -147,7 +147,7 @@ read_block_bitmap(struct super_block *sb
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext3_error(sb, __FUNCTION__,
+		ext3_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -158,7 +158,7 @@ read_block_bitmap(struct super_block *sb
 
 	if (bh_submit_read(bh) < 0) {
 		brelse(bh);
-		ext3_error(sb, __FUNCTION__,
+		ext3_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -236,7 +236,7 @@ restart:
 	BUG_ON(bad);
 }
 #define rsv_window_dump(root, verbose) \
-	__rsv_window_dump((root), (verbose), __FUNCTION__)
+	__rsv_window_dump((root), (verbose), __func__)
 #else
 #define rsv_window_dump(root, verbose) do {} while (0)
 #endif
@@ -618,7 +618,7 @@ do_more:
 		if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
 						bit + i, bitmap_bh->b_data)) {
 			jbd_unlock_bh_state(bitmap_bh);
-			ext3_error(sb, __FUNCTION__,
+			ext3_error(sb, __func__,
 				"bit already cleared for block "E3FSBLK,
 				 block + i);
 			jbd_lock_bh_state(bitmap_bh);
@@ -1672,7 +1672,7 @@ allocated:
 			if (ext3_test_bit(grp_alloc_blk+i,
 					bh2jh(bitmap_bh)->b_committed_data)) {
 				printk("%s: block was unexpectedly set in "
-					"b_committed_data\n", __FUNCTION__);
+					"b_committed_data\n", __func__);
 			}
 		}
 	}
diff -puN fs/ext3/ext3_jbd.c~ext3-replace-remaining-__function__-occurrences fs/ext3/ext3_jbd.c
--- a/fs/ext3/ext3_jbd.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/ext3_jbd.c
@@ -9,7 +9,7 @@ int __ext3_journal_get_undo_access(const
 {
 	int err = journal_get_undo_access(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -18,7 +18,7 @@ int __ext3_journal_get_write_access(cons
 {
 	int err = journal_get_write_access(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -27,7 +27,7 @@ int __ext3_journal_forget(const char *wh
 {
 	int err = journal_forget(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -36,7 +36,7 @@ int __ext3_journal_revoke(const char *wh
 {
 	int err = journal_revoke(handle, blocknr, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -45,7 +45,7 @@ int __ext3_journal_get_create_access(con
 {
 	int err = journal_get_create_access(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
 
@@ -54,6 +54,6 @@ int __ext3_journal_dirty_metadata(const 
 {
 	int err = journal_dirty_metadata(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
diff -puN fs/ext3/ialloc.c~ext3-replace-remaining-__function__-occurrences fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/ialloc.c
@@ -644,7 +644,7 @@ struct inode *ext3_orphan_get(struct sup
 
 	/* Error cases - e2fsck has already cleaned up for us */
 	if (ino > max_ino) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "bad orphan ino %lu!  e2fsck was run?", ino);
 		goto error;
 	}
@@ -653,7 +653,7 @@ struct inode *ext3_orphan_get(struct sup
 	bit = (ino - 1) % EXT3_INODES_PER_GROUP(sb);
 	bitmap_bh = read_inode_bitmap(sb, block_group);
 	if (!bitmap_bh) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "inode bitmap error for orphan %lu", ino);
 		goto error;
 	}
@@ -678,7 +678,7 @@ iget_failed:
 	err = PTR_ERR(inode);
 	inode = NULL;
 bad_orphan:
-	ext3_warning(sb, __FUNCTION__,
+	ext3_warning(sb, __func__,
 		     "bad orphan inode %lu!  e2fsck was run?", ino);
 	printk(KERN_NOTICE "ext3_test_bit(bit=%d, block=%llu) = %d\n",
 	       bit, (unsigned long long)bitmap_bh->b_blocknr,
diff -puN fs/ext3/inode.c~ext3-replace-remaining-__function__-occurrences fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/inode.c
@@ -95,7 +95,7 @@ int ext3_forget(handle_t *handle, int is
 	BUFFER_TRACE(bh, "call ext3_journal_revoke");
 	err = ext3_journal_revoke(handle, blocknr, bh);
 	if (err)
-		ext3_abort(inode->i_sb, __FUNCTION__,
+		ext3_abort(inode->i_sb, __func__,
 			   "error %d when attempting revoke", err);
 	BUFFER_TRACE(bh, "exit");
 	return err;
@@ -1190,7 +1190,7 @@ int ext3_journal_dirty_data(handle_t *ha
 {
 	int err = journal_dirty_data(handle, bh);
 	if (err)
-		ext3_journal_abort_handle(__FUNCTION__, __FUNCTION__,
+		ext3_journal_abort_handle(__func__, __func__,
 						bh, handle, err);
 	return err;
 }
@@ -3201,7 +3201,7 @@ void ext3_dirty_inode(struct inode *inod
 		current_handle->h_transaction != handle->h_transaction) {
 		/* This task has a transaction open against a different fs */
 		printk(KERN_EMERG "%s: transactions do not match!\n",
-		       __FUNCTION__);
+		       __func__);
 	} else {
 		jbd_debug(5, "marking dirty.  outer handle=%p\n",
 				current_handle);
diff -puN fs/ext3/namei.c~ext3-replace-remaining-__function__-occurrences fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/namei.c
@@ -361,7 +361,7 @@ dx_probe(struct dentry *dentry, struct i
 	if (root->info.hash_version != DX_HASH_TEA &&
 	    root->info.hash_version != DX_HASH_HALF_MD4 &&
 	    root->info.hash_version != DX_HASH_LEGACY) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Unrecognised inode hash code %d",
 			     root->info.hash_version);
 		brelse(bh);
@@ -375,7 +375,7 @@ dx_probe(struct dentry *dentry, struct i
 	hash = hinfo->hash;
 
 	if (root->info.unused_flags & 1) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Unimplemented inode hash flags: %#06x",
 			     root->info.unused_flags);
 		brelse(bh);
@@ -384,7 +384,7 @@ dx_probe(struct dentry *dentry, struct i
 	}
 
 	if ((indirect = root->info.indirect_levels) > 1) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Unimplemented inode hash depth: %#06x",
 			     root->info.indirect_levels);
 		brelse(bh);
@@ -397,7 +397,7 @@ dx_probe(struct dentry *dentry, struct i
 
 	if (dx_get_limit(entries) != dx_root_limit(dir,
 						   root->info.info_length)) {
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "dx entry: limit != root limit");
 		brelse(bh);
 		*err = ERR_BAD_DX_DIR;
@@ -409,7 +409,7 @@ dx_probe(struct dentry *dentry, struct i
 	{
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
-			ext3_warning(dir->i_sb, __FUNCTION__,
+			ext3_warning(dir->i_sb, __func__,
 				     "dx entry: no count or count > limit");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
@@ -454,7 +454,7 @@ dx_probe(struct dentry *dentry, struct i
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		if (dx_get_limit(entries) != dx_node_limit (dir)) {
-			ext3_warning(dir->i_sb, __FUNCTION__,
+			ext3_warning(dir->i_sb, __func__,
 				     "dx entry: limit != node limit");
 			brelse(bh);
 			*err = ERR_BAD_DX_DIR;
@@ -470,7 +470,7 @@ fail2:
 	}
 fail:
 	if (*err == ERR_BAD_DX_DIR)
-		ext3_warning(dir->i_sb, __FUNCTION__,
+		ext3_warning(dir->i_sb, __func__,
 			     "Corrupt dir inode %ld, running e2fsck is "
 			     "recommended.", dir->i_ino);
 	return NULL;
@@ -918,7 +918,7 @@ restart:
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			/* read error, skip block & hope for the best */
-			ext3_error(sb, __FUNCTION__, "reading directory #%lu "
+			ext3_error(sb, __func__, "reading directory #%lu "
 				   "offset %lu", dir->i_ino, block);
 			brelse(bh);
 			goto next;
@@ -1010,7 +1010,7 @@ static struct buffer_head * ext3_dx_find
 		retval = ext3_htree_next_block(dir, hash, frame,
 					       frames, NULL);
 		if (retval < 0) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 			     "error reading index page in directory #%lu",
 			     dir->i_ino);
 			*err = retval;
@@ -1535,7 +1535,7 @@ static int ext3_dx_add_entry(handle_t *h
 
 		if (levels && (dx_get_count(frames->entries) ==
 			       dx_get_limit(frames->entries))) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "Directory index full!");
 			err = -ENOSPC;
 			goto cleanup;
@@ -1837,11 +1837,11 @@ static int empty_dir (struct inode * ino
 	if (inode->i_size < EXT3_DIR_REC_LEN(1) + EXT3_DIR_REC_LEN(2) ||
 	    !(bh = ext3_bread (NULL, inode, 0, 0, &err))) {
 		if (err)
-			ext3_error(inode->i_sb, __FUNCTION__,
+			ext3_error(inode->i_sb, __func__,
 				   "error %d reading directory #%lu offset 0",
 				   err, inode->i_ino);
 		else
-			ext3_warning(inode->i_sb, __FUNCTION__,
+			ext3_warning(inode->i_sb, __func__,
 				     "bad directory (dir #%lu) - no data block",
 				     inode->i_ino);
 		return 1;
@@ -1870,7 +1870,7 @@ static int empty_dir (struct inode * ino
 				offset >> EXT3_BLOCK_SIZE_BITS(sb), 0, &err);
 			if (!bh) {
 				if (err)
-					ext3_error(sb, __FUNCTION__,
+					ext3_error(sb, __func__,
 						   "error %d reading directory"
 						   " #%lu offset %lu",
 						   err, inode->i_ino, offset);
diff -puN fs/ext3/resize.c~ext3-replace-remaining-__function__-occurrences fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/resize.c
@@ -48,60 +48,60 @@ static int verify_group_input(struct sup
 		       free_blocks_count, input->reserved_blocks);
 
 	if (group != sbi->s_groups_count)
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Cannot add at group %u (only %lu groups)",
 			     input->group, sbi->s_groups_count);
 	else if ((start - le32_to_cpu(es->s_first_data_block)) %
 		 EXT3_BLOCKS_PER_GROUP(sb))
-		ext3_warning(sb, __FUNCTION__, "Last group not full");
+		ext3_warning(sb, __func__, "Last group not full");
 	else if (input->reserved_blocks > input->blocks_count / 5)
-		ext3_warning(sb, __FUNCTION__, "Reserved blocks too high (%u)",
+		ext3_warning(sb, __func__, "Reserved blocks too high (%u)",
 			     input->reserved_blocks);
 	else if (free_blocks_count < 0)
-		ext3_warning(sb, __FUNCTION__, "Bad blocks count %u",
+		ext3_warning(sb, __func__, "Bad blocks count %u",
 			     input->blocks_count);
 	else if (!(bh = sb_bread(sb, end - 1)))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Cannot read last block ("E3FSBLK")",
 			     end - 1);
 	else if (outside(input->block_bitmap, start, end))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap not in group (block %u)",
 			     input->block_bitmap);
 	else if (outside(input->inode_bitmap, start, end))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode bitmap not in group (block %u)",
 			     input->inode_bitmap);
 	else if (outside(input->inode_table, start, end) ||
 	         outside(itend - 1, start, end))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode table not in group (blocks %u-"E3FSBLK")",
 			     input->inode_table, itend - 1);
 	else if (input->inode_bitmap == input->block_bitmap)
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap same as inode bitmap (%u)",
 			     input->block_bitmap);
 	else if (inside(input->block_bitmap, input->inode_table, itend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap (%u) in inode table (%u-"E3FSBLK")",
 			     input->block_bitmap, input->inode_table, itend-1);
 	else if (inside(input->inode_bitmap, input->inode_table, itend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode bitmap (%u) in inode table (%u-"E3FSBLK")",
 			     input->inode_bitmap, input->inode_table, itend-1);
 	else if (inside(input->block_bitmap, start, metaend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Block bitmap (%u) in GDT table"
 			     " ("E3FSBLK"-"E3FSBLK")",
 			     input->block_bitmap, start, metaend - 1);
 	else if (inside(input->inode_bitmap, start, metaend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode bitmap (%u) in GDT table"
 			     " ("E3FSBLK"-"E3FSBLK")",
 			     input->inode_bitmap, start, metaend - 1);
 	else if (inside(input->inode_table, start, metaend) ||
 	         inside(itend - 1, start, metaend))
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Inode table (%u-"E3FSBLK") overlaps"
 			     "GDT table ("E3FSBLK"-"E3FSBLK")",
 			     input->inode_table, itend - 1, start, metaend - 1);
@@ -386,7 +386,7 @@ static int verify_reserved_gdb(struct su
 
 	while ((grp = ext3_list_backups(sb, &three, &five, &seven)) < end) {
 		if (le32_to_cpu(*p++) != grp * EXT3_BLOCKS_PER_GROUP(sb) + blk){
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "reserved GDT "E3FSBLK
 				     " missing grp %d ("E3FSBLK")",
 				     blk, grp,
@@ -440,7 +440,7 @@ static int add_new_gdb(handle_t *handle,
 	 */
 	if (EXT3_SB(sb)->s_sbh->b_blocknr !=
 	    le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block)) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			"won't resize using backup superblock at %llu",
 			(unsigned long long)EXT3_SB(sb)->s_sbh->b_blocknr);
 		return -EPERM;
@@ -464,7 +464,7 @@ static int add_new_gdb(handle_t *handle,
 
 	data = (__le32 *)dind->b_data;
 	if (le32_to_cpu(data[gdb_num % EXT3_ADDR_PER_BLOCK(sb)]) != gdblock) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "new group %u GDT block "E3FSBLK" not reserved",
 			     input->group, gdblock);
 		err = -EINVAL;
@@ -488,7 +488,7 @@ static int add_new_gdb(handle_t *handle,
 			GFP_NOFS);
 	if (!n_group_desc) {
 		err = -ENOMEM;
-		ext3_warning (sb, __FUNCTION__,
+		ext3_warning (sb, __func__,
 			      "not enough memory for %lu groups", gdb_num + 1);
 		goto exit_inode;
 	}
@@ -586,7 +586,7 @@ static int reserve_backup_gdb(handle_t *
 	/* Get each reserved primary GDT block and verify it holds backups */
 	for (res = 0; res < reserved_gdb; res++, blk++) {
 		if (le32_to_cpu(*data) != blk) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "reserved block "E3FSBLK
 				     " not at offset %ld",
 				     blk,
@@ -730,7 +730,7 @@ static void update_backups(struct super_
 	 */
 exit_err:
 	if (err) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "can't update backup for group %d (err %d), "
 			     "forcing fsck on next reboot", group, err);
 		sbi->s_mount_state &= ~EXT3_VALID_FS;
@@ -770,33 +770,33 @@ int ext3_group_add(struct super_block *s
 
 	if (gdb_off == 0 && !EXT3_HAS_RO_COMPAT_FEATURE(sb,
 					EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "Can't resize non-sparse filesystem further");
 		return -EPERM;
 	}
 
 	if (le32_to_cpu(es->s_blocks_count) + input->blocks_count <
 	    le32_to_cpu(es->s_blocks_count)) {
-		ext3_warning(sb, __FUNCTION__, "blocks_count overflow\n");
+		ext3_warning(sb, __func__, "blocks_count overflow\n");
 		return -EINVAL;
 	}
 
 	if (le32_to_cpu(es->s_inodes_count) + EXT3_INODES_PER_GROUP(sb) <
 	    le32_to_cpu(es->s_inodes_count)) {
-		ext3_warning(sb, __FUNCTION__, "inodes_count overflow\n");
+		ext3_warning(sb, __func__, "inodes_count overflow\n");
 		return -EINVAL;
 	}
 
 	if (reserved_gdb || gdb_off == 0) {
 		if (!EXT3_HAS_COMPAT_FEATURE(sb,
 					     EXT3_FEATURE_COMPAT_RESIZE_INODE)){
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
 		inode = ext3_iget(sb, EXT3_RESIZE_INO);
 		if (IS_ERR(inode)) {
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 				     "Error opening resize inode");
 			return PTR_ERR(inode);
 		}
@@ -825,7 +825,7 @@ int ext3_group_add(struct super_block *s
 
 	lock_super(sb);
 	if (input->group != sbi->s_groups_count) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
 		err = -EBUSY;
 		goto exit_journal;
@@ -988,13 +988,13 @@ int ext3_group_extend(struct super_block
 			" too large to resize to %lu blocks safely\n",
 			sb->s_id, n_blocks_count);
 		if (sizeof(sector_t) < 8)
-			ext3_warning(sb, __FUNCTION__,
+			ext3_warning(sb, __func__,
 			"CONFIG_LBD not enabled\n");
 		return -EINVAL;
 	}
 
 	if (n_blocks_count < o_blocks_count) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "can't shrink FS - resize aborted");
 		return -EBUSY;
 	}
@@ -1004,7 +1004,7 @@ int ext3_group_extend(struct super_block
 		EXT3_BLOCKS_PER_GROUP(sb);
 
 	if (last == 0) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "need to use ext2online to resize further");
 		return -EPERM;
 	}
@@ -1012,7 +1012,7 @@ int ext3_group_extend(struct super_block
 	add = EXT3_BLOCKS_PER_GROUP(sb) - last;
 
 	if (o_blocks_count + add < o_blocks_count) {
-		ext3_warning(sb, __FUNCTION__, "blocks_count overflow");
+		ext3_warning(sb, __func__, "blocks_count overflow");
 		return -EINVAL;
 	}
 
@@ -1020,7 +1020,7 @@ int ext3_group_extend(struct super_block
 		add = n_blocks_count - o_blocks_count;
 
 	if (o_blocks_count + add < n_blocks_count)
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "will only finish group ("E3FSBLK
 			     " blocks, %u new)",
 			     o_blocks_count + add, add);
@@ -1028,7 +1028,7 @@ int ext3_group_extend(struct super_block
 	/* See if the device is actually as big as what was requested */
 	bh = sb_bread(sb, o_blocks_count + add -1);
 	if (!bh) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "can't read last block, resize aborted");
 		return -ENOSPC;
 	}
@@ -1040,13 +1040,13 @@ int ext3_group_extend(struct super_block
 	handle = ext3_journal_start_sb(sb, 3);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
-		ext3_warning(sb, __FUNCTION__, "error %d on journal start",err);
+		ext3_warning(sb, __func__, "error %d on journal start",err);
 		goto exit_put;
 	}
 
 	lock_super(sb);
 	if (o_blocks_count != le32_to_cpu(es->s_blocks_count)) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
 		ext3_journal_stop(handle);
@@ -1056,7 +1056,7 @@ int ext3_group_extend(struct super_block
 
 	if ((err = ext3_journal_get_write_access(handle,
 						 EXT3_SB(sb)->s_sbh))) {
-		ext3_warning(sb, __FUNCTION__,
+		ext3_warning(sb, __func__,
 			     "error %d on journal write access", err);
 		unlock_super(sb);
 		ext3_journal_stop(handle);
diff -puN fs/ext3/super.c~ext3-replace-remaining-__function__-occurrences fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/super.c
@@ -84,7 +84,7 @@ handle_t *ext3_journal_start_sb(struct s
 	 * take the FS itself readonly cleanly. */
 	journal = EXT3_SB(sb)->s_journal;
 	if (is_journal_aborted(journal)) {
-		ext3_abort(sb, __FUNCTION__,
+		ext3_abort(sb, __func__,
 			   "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
@@ -304,7 +304,7 @@ void ext3_update_dynamic_rev(struct supe
 	if (le32_to_cpu(es->s_rev_level) > EXT3_GOOD_OLD_REV)
 		return;
 
-	ext3_warning(sb, __FUNCTION__,
+	ext3_warning(sb, __func__,
 		     "updating to rev %d because of new feature flag, "
 		     "running e2fsck is recommended",
 		     EXT3_DYNAMIC_REV);
@@ -1390,7 +1390,7 @@ static void ext3_orphan_cleanup (struct 
 		if (inode->i_nlink) {
 			printk(KERN_DEBUG
 				"%s: truncating inode %lu to %Ld bytes\n",
-				__FUNCTION__, inode->i_ino, inode->i_size);
+				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %Ld bytes\n",
 				  inode->i_ino, inode->i_size);
 			ext3_truncate(inode);
@@ -1398,7 +1398,7 @@ static void ext3_orphan_cleanup (struct 
 		} else {
 			printk(KERN_DEBUG
 				"%s: deleting unreferenced inode %lu\n",
-				__FUNCTION__, inode->i_ino);
+				__func__, inode->i_ino);
 			jbd_debug(2, "deleting unreferenced inode %lu\n",
 				  inode->i_ino);
 			nr_orphans++;
@@ -2301,9 +2301,9 @@ static void ext3_clear_journal_err(struc
 		char nbuf[16];
 
 		errstr = ext3_decode_error(sb, j_errno, nbuf);
-		ext3_warning(sb, __FUNCTION__, "Filesystem error recorded "
+		ext3_warning(sb, __func__, "Filesystem error recorded "
 			     "from previous mount: %s", errstr);
-		ext3_warning(sb, __FUNCTION__, "Marking fs in need of "
+		ext3_warning(sb, __func__, "Marking fs in need of "
 			     "filesystem check.");
 
 		EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
@@ -2430,7 +2430,7 @@ static int ext3_remount (struct super_bl
 	}
 
 	if (sbi->s_mount_opt & EXT3_MOUNT_ABORT)
-		ext3_abort(sb, __FUNCTION__, "Abort forced by user");
+		ext3_abort(sb, __func__, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT3_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
diff -puN fs/ext3/xattr.c~ext3-replace-remaining-__function__-occurrences fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-replace-remaining-__function__-occurrences
+++ a/fs/ext3/xattr.c
@@ -234,7 +234,7 @@ ext3_xattr_block_get(struct inode *inode
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext3_xattr_check_block(bh)) {
-bad_block:	ext3_error(inode->i_sb, __FUNCTION__,
+bad_block:	ext3_error(inode->i_sb, __func__,
 			   "inode %lu: bad block "E3FSBLK, inode->i_ino,
 			   EXT3_I(inode)->i_file_acl);
 		error = -EIO;
@@ -376,7 +376,7 @@ ext3_xattr_block_list(struct inode *inod
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext3_xattr_check_block(bh)) {
-		ext3_error(inode->i_sb, __FUNCTION__,
+		ext3_error(inode->i_sb, __func__,
 			   "inode %lu: bad block "E3FSBLK, inode->i_ino,
 			   EXT3_I(inode)->i_file_acl);
 		error = -EIO;
@@ -651,7 +651,7 @@ ext3_xattr_block_find(struct inode *inod
 			atomic_read(&(bs->bh->b_count)),
 			le32_to_cpu(BHDR(bs->bh)->h_refcount));
 		if (ext3_xattr_check_block(bs->bh)) {
-			ext3_error(sb, __FUNCTION__,
+			ext3_error(sb, __func__,
 				"inode %lu: bad block "E3FSBLK, inode->i_ino,
 				EXT3_I(inode)->i_file_acl);
 			error = -EIO;
@@ -852,7 +852,7 @@ cleanup_dquot:
 	goto cleanup;
 
 bad_block:
-	ext3_error(inode->i_sb, __FUNCTION__,
+	ext3_error(inode->i_sb, __func__,
 		   "inode %lu: bad block "E3FSBLK, inode->i_ino,
 		   EXT3_I(inode)->i_file_acl);
 	goto cleanup;
@@ -1081,14 +1081,14 @@ ext3_xattr_delete_inode(handle_t *handle
 		goto cleanup;
 	bh = sb_bread(inode->i_sb, EXT3_I(inode)->i_file_acl);
 	if (!bh) {
-		ext3_error(inode->i_sb, __FUNCTION__,
+		ext3_error(inode->i_sb, __func__,
 			"inode %lu: block "E3FSBLK" read error", inode->i_ino,
 			EXT3_I(inode)->i_file_acl);
 		goto cleanup;
 	}
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT3_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1)) {
-		ext3_error(inode->i_sb, __FUNCTION__,
+		ext3_error(inode->i_sb, __func__,
 			"inode %lu: bad block "E3FSBLK, inode->i_ino,
 			EXT3_I(inode)->i_file_acl);
 		goto cleanup;
@@ -1215,7 +1215,7 @@ again:
 		}
 		bh = sb_bread(inode->i_sb, ce->e_block);
 		if (!bh) {
-			ext3_error(inode->i_sb, __FUNCTION__,
+			ext3_error(inode->i_sb, __func__,
 				"inode %lu: block %lu read error",
 				inode->i_ino, (unsigned long) ce->e_block);
 		} else if (le32_to_cpu(BHDR(bh)->h_refcount) >=
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

