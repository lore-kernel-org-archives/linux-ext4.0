From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/5] ext4: io stat write related entrance
Date: Mon, 31 Oct 2011 17:43:03 +0800
Message-ID: <1320054184-14329-5-git-send-email-wenqing.lz@taobao.com>
References: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Cc: Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Add write related statistic code at these write functions

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/extents.c  |    8 ++++++++
 fs/ext4/ialloc.c   |   14 ++++++++++++++
 fs/ext4/indirect.c |   15 +++++++++++++--
 fs/ext4/inode.c    |   14 ++++++++++++++
 fs/ext4/mballoc.c  |   14 ++++++++++++++
 fs/ext4/namei.c    |   26 ++++++++++++++++++++++++++
 fs/ext4/super.c    |    2 ++
 fs/ext4/xattr.c    |   13 ++++++++++++-
 8 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 81f5b3f..6258bb2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -102,6 +102,8 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
 	int err;
 	if (path->p_bh) {
 		/* path points to block */
+		ext4_io_stat_write(handle, path->p_bh, __func__, __LINE__,
+				   EXT4_IOS_EXTENT_BLOCK, 1);
 		err = ext4_handle_dirty_metadata(handle, inode, path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
@@ -912,6 +914,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
+	ext4_io_stat_write(handle, bh, __func__, __LINE__,
+			   EXT4_IOS_EXTENT_BLOCK, 1);
 	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto cleanup;
@@ -990,6 +994,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
+		ext4_io_stat_write(handle, bh, __func__, __LINE__,
+				   EXT4_IOS_EXTENT_BLOCK, 1);
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto cleanup;
@@ -1088,6 +1094,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
+	ext4_io_stat_write(handle, bh, __func__, __LINE__,
+			   EXT4_IOS_EXTENT_BLOCK, 1);
 	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto out;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 68b3295..3dd7c09 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -280,10 +280,14 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
 	}
 	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+	ext4_io_stat_write(handle, bh2, __func__, __LINE__,
+			   EXT4_IOS_GROUP_DESC, 1);
 	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
 out:
 	if (cleared) {
 		BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
+		ext4_io_stat_write(handle, bitmap_bh, __func__, __LINE__,
+				   EXT4_IOS_INODE_BITMAP, 1);
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!fatal)
 			fatal = err;
@@ -909,6 +913,9 @@ repeat_in_this_group:
 				/* we won it */
 				BUFFER_TRACE(inode_bitmap_bh,
 					"call ext4_handle_dirty_metadata");
+				ext4_io_stat_write(handle, inode_bitmap_bh,
+						   __func__, __LINE__,
+						   EXT4_IOS_INODE_BITMAP, 1);
 				err = ext4_handle_dirty_metadata(handle,
 								 NULL,
 							inode_bitmap_bh);
@@ -968,6 +975,9 @@ got:
 		/* Don't need to dirty bitmap block if we didn't change it */
 		if (free) {
 			BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
+			ext4_io_stat_write(handle, block_bitmap_bh,
+					   __func__, __LINE__,
+					   EXT4_IOS_BLOCK_BITMAP, 1);
 			err = ext4_handle_dirty_metadata(handle,
 							NULL, block_bitmap_bh);
 		}
@@ -977,6 +987,8 @@ got:
 			goto fail;
 	}
 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
+	ext4_io_stat_write(handle, group_desc_bh, __func__, __LINE__,
+			   EXT4_IOS_GROUP_DESC, 1);
 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
 	if (err)
 		goto fail;
@@ -1326,6 +1338,8 @@ skip_zeroout:
 
 	BUFFER_TRACE(group_desc_bh,
 		     "call ext4_handle_dirty_metadata");
+	ext4_io_stat_write(handle, group_desc_bh, __func__, __LINE__,
+			   EXT4_IOS_GROUP_DESC, 1);
 	ret = ext4_handle_dirty_metadata(handle, NULL,
 					 group_desc_bh);
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 0f61f2f..53bcf69 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -508,6 +508,8 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 		unlock_buffer(bh);
 
 		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		ext4_io_stat_write(handle, bh, __func__, __LINE__,
+				   EXT4_IOS_INDIRECT_BLOCK, 1);
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto failed;
@@ -595,6 +597,8 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 		 */
 		jbd_debug(5, "splicing indirect only\n");
 		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
+		ext4_io_stat_write(handle, where->bh, __func__, __LINE__,
+				   EXT4_IOS_INDIRECT_BLOCK, 1);
 		err = ext4_handle_dirty_metadata(handle, inode, where->bh);
 		if (err)
 			goto err_out;
@@ -1088,6 +1092,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_io_stat_write(handle, bh, __func__, __LINE__,
+					   EXT4_IOS_INDIRECT_BLOCK, 1);
 			err = ext4_handle_dirty_metadata(handle, inode, bh);
 			if (unlikely(err))
 				goto out_err;
@@ -1198,9 +1204,11 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 		 * block pointed to itself, it would have been detached when
 		 * the block was cleared. Check for this instead of OOPSing.
 		 */
-		if ((EXT4_JOURNAL(inode) == NULL) || bh2jh(this_bh))
+		if ((EXT4_JOURNAL(inode) == NULL) || bh2jh(this_bh)) {
+			ext4_io_stat_write(handle, this_bh, __func__, __LINE__,
+					   EXT4_IOS_INDIRECT_BLOCK, 1);
 			ext4_handle_dirty_metadata(handle, inode, this_bh);
-		else
+		} else
 			EXT4_ERROR_INODE(inode,
 					 "circular indirect block detected at "
 					 "block %llu",
@@ -1324,6 +1332,9 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					*p = 0;
 					BUFFER_TRACE(parent_bh,
 					"call ext4_handle_dirty_metadata");
+					ext4_io_stat_write(handle, parent_bh,
+						__func__, __LINE__,
+						EXT4_IOS_INDIRECT_BLOCK, 1);
 					ext4_handle_dirty_metadata(handle,
 								   inode,
 								   parent_bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3179252..50017dc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -623,6 +623,8 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 		}
 		unlock_buffer(bh);
 		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		ext4_io_stat_write(handle, bh, __func__, __LINE__,
+				   EXT4_IOS_DIR_ENTRY, 1);
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (!fatal)
 			fatal = err;
@@ -1786,6 +1788,8 @@ static int ext4_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	trace_ext4_writepage(page);
+	ext4_io_stat_write(NULL, NULL, __func__, __LINE__,
+			   EXT4_IOS_REGULAR_DATA, ext4_blocks_per_page(inode));
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -1956,6 +1960,9 @@ static int write_cache_pages_da(struct address_space *mapping,
 			logical = (sector_t) page->index <<
 				(PAGE_CACHE_SHIFT - inode->i_blkbits);
 
+			ext4_io_stat_write(NULL, NULL, __func__, __LINE__,
+					   EXT4_IOS_REGULAR_DATA,
+					   ext4_blocks_per_page(inode));
 			if (!page_has_buffers(page)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       PAGE_CACHE_SIZE,
@@ -3083,6 +3090,8 @@ int ext4_block_zero_page_range(handle_t *handle,
 	} else {
 		if (ext4_should_order_data(inode) && EXT4_I(inode)->jinode)
 			err = ext4_jbd2_file_inode(handle, inode);
+		ext4_io_stat_write(handle, bh, __func__, __LINE__,
+				   EXT4_IOS_REGULAR_DATA, 1);
 		mark_buffer_dirty(bh);
 	}
 
@@ -3717,6 +3726,9 @@ static int ext4_do_update_inode(handle_t *handle,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
+			ext4_io_stat_write(handle, EXT4_SB(sb)->s_sbh,
+					   __func__, __LINE__,
+					   EXT4_IOS_SUPER_BLOCK, 1);
 			err = ext4_handle_dirty_metadata(handle, NULL,
 					EXT4_SB(sb)->s_sbh);
 		}
@@ -3746,6 +3758,8 @@ static int ext4_do_update_inode(handle_t *handle,
 	}
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	ext4_io_stat_write(handle, bh, __func__, __LINE__,
+			   EXT4_IOS_INODE_TABLE, 1);
 	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (!err)
 		err = rc;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d961d17..1e872e1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2805,6 +2805,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
 			      ac->ac_b_ex.fe_len);
 		ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+		ext4_io_stat_write(handle, bitmap_bh, __func__, __LINE__,
+				   EXT4_IOS_BLOCK_BITMAP, 1);
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
 			err = -EAGAIN;
@@ -2849,9 +2851,13 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 			   &sbi->s_flex_groups[flex_group].free_blocks);
 	}
 
+	ext4_io_stat_write(handle, bitmap_bh, __func__, __LINE__,
+			   EXT4_IOS_BLOCK_BITMAP, 1);
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (err)
 		goto out_err;
+	ext4_io_stat_write(handle, gdp_bh, __func__, __LINE__,
+			   EXT4_IOS_GROUP_DESC, 1);
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
@@ -4655,10 +4661,14 @@ do_more:
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	ext4_io_stat_write(handle, bitmap_bh, __func__, __LINE__,
+			   EXT4_IOS_BLOCK_BITMAP, 1);
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
+	ext4_io_stat_write(handle, gd_bh, __func__, __LINE__,
+			   EXT4_IOS_GROUP_DESC, 1);
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
@@ -4796,10 +4806,14 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	ext4_io_stat_write(handle, bitmap_bh, __func__, __LINE__,
+			   EXT4_IOS_BLOCK_BITMAP, 1);
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
+	ext4_io_stat_write(handle, gd_bh, __func__, __LINE__,
+			   EXT4_IOS_GROUP_DESC, 1);
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ba3f5b8..3ef6e32 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1227,9 +1227,13 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		de = de2;
 	}
 	dx_insert_block(frame, hash2 + continued, newblock);
+	ext4_io_stat_write(handle, bh2, __func__, __LINE__,
+			   EXT4_IOS_DIR_ENTRY, 1);
 	err = ext4_handle_dirty_metadata(handle, dir, bh2);
 	if (err)
 		goto journal_error;
+	ext4_io_stat_write(handle, frame->bh, __func__, __LINE__,
+			   EXT4_IOS_DIR_ENTRY, 1);
 	err = ext4_handle_dirty_metadata(handle, dir, frame->bh);
 	if (err)
 		goto journal_error;
@@ -1327,6 +1331,8 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	dir->i_version++;
 	ext4_mark_inode_dirty(handle, dir);
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	ext4_io_stat_write(handle, bh, __func__, __LINE__,
+			   EXT4_IOS_DIR_ENTRY, 1);
 	err = ext4_handle_dirty_metadata(handle, dir, bh);
 	if (err)
 		ext4_std_error(dir->i_sb, err);
@@ -1417,7 +1423,11 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->bh = bh;
 	bh = bh2;
 
+	ext4_io_stat_write(handle, frame->bh, __func__, __LINE__,
+			   EXT4_IOS_DIR_ENTRY, 1);
 	ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	ext4_io_stat_write(handle, bh, __func__, __LINE__,
+			   EXT4_IOS_DIR_ENTRY, 1);
 	ext4_handle_dirty_metadata(handle, dir, bh);
 
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
@@ -1592,6 +1602,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
+			ext4_io_stat_write(handle, bh2, __func__, __LINE__,
+					   EXT4_IOS_DIR_ENTRY, 1);
 			err = ext4_handle_dirty_metadata(handle, inode, bh2);
 			if (err)
 				goto journal_error;
@@ -1618,6 +1630,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
+		ext4_io_stat_write(handle, frames[0].bh, __func__, __LINE__,
+				   EXT4_IOS_DIR_ENTRY, 1);
 		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
@@ -1676,6 +1690,8 @@ static int ext4_delete_entry(handle_t *handle,
 				de->inode = 0;
 			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_io_stat_write(handle, bh, __func__, __LINE__,
+					   EXT4_IOS_DIR_ENTRY, 1);
 			err = ext4_handle_dirty_metadata(handle, dir, bh);
 			if (unlikely(err)) {
 				ext4_std_error(dir->i_sb, err);
@@ -1869,6 +1885,8 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	ext4_io_stat_write(handle, dir_block, __func__, __LINE__,
+			   EXT4_IOS_DIR_ENTRY, 1);
 	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
 	if (err)
 		goto out_clear_inode;
@@ -2020,6 +2038,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
+	ext4_io_stat_write(handle, EXT4_SB(sb)->s_sbh, __func__, __LINE__,
+			   EXT4_IOS_SUPER_BLOCK, 1);
 	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
@@ -2093,6 +2113,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
+		ext4_io_stat_write(handle, sbi->s_sbh, __func__, __LINE__,
+				   EXT4_IOS_SUPER_BLOCK, 1);
 		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
 	} else {
 		struct ext4_iloc iloc2;
@@ -2482,6 +2504,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 					ext4_current_time(new_dir);
 		ext4_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext4_handle_dirty_metadata");
+		ext4_io_stat_write(handle, new_bh, __func__, __LINE__,
+				   EXT4_IOS_DIR_ENTRY, 1);
 		retval = ext4_handle_dirty_metadata(handle, new_dir, new_bh);
 		if (unlikely(retval)) {
 			ext4_std_error(new_dir->i_sb, retval);
@@ -2536,6 +2560,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
+		ext4_io_stat_write(handle, dir_bh, __func__, __LINE__,
+				   EXT4_IOS_DIR_ENTRY, 1);
 		retval = ext4_handle_dirty_metadata(handle, old_dir, dir_bh);
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 49a5952..93ec9a7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4113,6 +4113,8 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 				&EXT4_SB(sb)->s_freeinodes_counter));
 	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
+	ext4_io_stat_write(NULL, sbh, __func__, __LINE__,
+			   EXT4_IOS_SUPER_BLOCK, 1);
 	mark_buffer_dirty(sbh);
 	if (sync) {
 		error = sync_dirty_buffer(sbh);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cb7a9bb..640b549 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -495,6 +495,8 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				 EXT4_FREE_BLOCKS_FORGET);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		ext4_io_stat_write(handle, bh, __func__, __LINE__,
+				   EXT4_IOS_EXTENDED_ATTR, 1);
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
@@ -733,10 +735,14 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			unlock_buffer(bs->bh);
 			if (error == -EIO)
 				goto bad_block;
-			if (!error)
+			if (!error) {
+				ext4_io_stat_write(handle, bs->bh,
+						   __func__, __LINE__,
+						   EXT4_IOS_EXTENDED_ATTR, 1);
 				error = ext4_handle_dirty_metadata(handle,
 								   inode,
 								   bs->bh);
+			}
 			if (error)
 				goto cleanup;
 			goto inserted;
@@ -805,6 +811,9 @@ inserted:
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
+				ext4_io_stat_write(handle, new_bh,
+						   __func__, __LINE__,
+						   EXT4_IOS_EXTENDED_ATTR, 1);
 				error = ext4_handle_dirty_metadata(handle,
 								   inode,
 								   new_bh);
@@ -857,6 +866,8 @@ getblk_failed:
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
 			ext4_xattr_cache_insert(new_bh);
+			ext4_io_stat_write(handle, new_bh, __func__, __LINE__,
+					   EXT4_IOS_EXTENDED_ATTR, 1);
 			error = ext4_handle_dirty_metadata(handle,
 							   inode, new_bh);
 			if (error)
-- 
1.7.4.1

