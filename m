From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 5/8] ext4: Count metadata request of write operations in buffered io
Date: Thu, 10 Nov 2011 18:34:51 +0800
Message-ID: <1320921294-30321-6-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52220 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1KJKd6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 05:33:58 -0500
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

'Issue' flag in buffer_head doesn't be used because filesystem should know
whether or not write request can hit cache.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/extents.c     |    4 ++++
 fs/ext4/ialloc.c      |    8 ++++++++
 fs/ext4/indirect.c    |   12 ++++++++++--
 fs/ext4/inode.c       |    4 ++++
 fs/ext4/mballoc.c     |    7 +++++++
 fs/ext4/move_extent.c |    2 ++
 fs/ext4/namei.c       |   13 +++++++++++++
 fs/ext4/super.c       |    2 ++
 fs/ext4/xattr.c       |   10 +++++++++-
 9 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 289994f..572d44a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -106,6 +106,7 @@ static int __ext4_ext_dirty(const char *where, unsigned int line,
 		/* path points to block */
 		err = __ext4_handle_dirty_metadata(where, line, handle,
 						   inode, path->p_bh);
+		ext4_ios_write_one(handle, path->p_bh, EXT4_IOS_EXTENT_BLOCK);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);
@@ -902,6 +903,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
+	ext4_ios_write_one(handle, bh, EXT4_IOS_EXTENT_BLOCK);
 	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto cleanup;
@@ -980,6 +982,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
+		ext4_ios_write_one(handle, bh, EXT4_IOS_EXTENT_BLOCK);
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto cleanup;
@@ -1077,6 +1080,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
+	ext4_ios_write_one(handle, bh, EXT4_IOS_EXTENT_BLOCK);
 	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto out;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a86daff..e3d51f4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -278,10 +278,12 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
 	}
 	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+	ext4_ios_write_one(handle, bh2, EXT4_IOS_GROUP_DESC);
 	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
 out:
 	if (cleared) {
 		BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
+		ext4_ios_write_one(handle, bitmap_bh, EXT4_IOS_INODE_BITMAP);
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!fatal)
 			fatal = err;
@@ -777,6 +779,8 @@ repeat_in_this_group:
 				/* we won it */
 				BUFFER_TRACE(inode_bitmap_bh,
 					"call ext4_handle_dirty_metadata");
+				ext4_ios_write_one(handle, inode_bitmap_bh,
+						   EXT4_IOS_INODE_BITMAP);
 				err = ext4_handle_dirty_metadata(handle,
 								 NULL,
 							inode_bitmap_bh);
@@ -822,6 +826,8 @@ got:
 		}
 
 		BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
+		ext4_ios_write_one(handle, block_bitmap_bh,
+				   EXT4_IOS_BLOCK_BITMAP);
 		err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
 		brelse(block_bitmap_bh);
 
@@ -840,6 +846,7 @@ got:
 			goto fail;
 	}
 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
+	ext4_ios_write_one(handle, group_desc_bh, EXT4_IOS_GROUP_DESC);
 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
 	if (err)
 		goto fail;
@@ -1188,6 +1195,7 @@ skip_zeroout:
 
 	BUFFER_TRACE(group_desc_bh,
 		     "call ext4_handle_dirty_metadata");
+	ext4_ios_write_one(handle, group_desc_bh, EXT4_IOS_GROUP_DESC);
 	ret = ext4_handle_dirty_metadata(handle, NULL,
 					 group_desc_bh);
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 7ba97e3..0d7174e 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -506,6 +506,7 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 		unlock_buffer(bh);
 
 		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		ext4_ios_write_one(handle, bh, EXT4_IOS_INDIRECT_BLOCK);
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto failed;
@@ -593,6 +594,7 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 		 */
 		jbd_debug(5, "splicing indirect only\n");
 		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
+		ext4_ios_write_one(handle, where->bh, EXT4_IOS_INDIRECT_BLOCK);
 		err = ext4_handle_dirty_metadata(handle, inode, where->bh);
 		if (err)
 			goto err_out;
@@ -1093,6 +1095,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_ios_write_one(handle, bh,
+					   EXT4_IOS_INDIRECT_BLOCK);
 			err = ext4_handle_dirty_metadata(handle, inode, bh);
 			if (unlikely(err))
 				goto out_err;
@@ -1203,9 +1207,11 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 		 * block pointed to itself, it would have been detached when
 		 * the block was cleared. Check for this instead of OOPSing.
 		 */
-		if ((EXT4_JOURNAL(inode) == NULL) || bh2jh(this_bh))
+		if ((EXT4_JOURNAL(inode) == NULL) || bh2jh(this_bh)) {
+			ext4_ios_write_one(handle, this_bh,
+					   EXT4_IOS_INDIRECT_BLOCK);
 			ext4_handle_dirty_metadata(handle, inode, this_bh);
-		else
+		} else
 			EXT4_ERROR_INODE(inode,
 					 "circular indirect block detected at "
 					 "block %llu",
@@ -1327,6 +1333,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 					*p = 0;
 					BUFFER_TRACE(parent_bh,
 					"call ext4_handle_dirty_metadata");
+					ext4_ios_write_one(handle, parent_bh,
+						EXT4_IOS_INDIRECT_BLOCK);
 					ext4_handle_dirty_metadata(handle,
 								   inode,
 								   parent_bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5a1fca0..c584f89 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -675,6 +675,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 		}
 		unlock_buffer(bh);
 		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		ext4_ios_write_one(handle, bh, EXT4_IOS_DIR_ENTRY);
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (!fatal)
 			fatal = err;
@@ -4086,6 +4087,8 @@ static int ext4_do_update_inode(handle_t *handle,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
+			ext4_ios_write_one(handle, EXT4_SB(sb)->s_sbh,
+					   EXT4_IOS_SUPER_BLOCK);
 			err = ext4_handle_dirty_metadata(handle, NULL,
 					EXT4_SB(sb)->s_sbh);
 		}
@@ -4115,6 +4118,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	}
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	ext4_ios_write_one(handle, bh, EXT4_IOS_INODE_TABLE);
 	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (!err)
 		err = rc;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e5ca591..3ea1bed 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2825,6 +2825,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
 			      ac->ac_b_ex.fe_len);
 		ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+		ext4_ios_write_one(handle, bitmap_bh, EXT4_IOS_BLOCK_BITMAP);
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
 			err = -EAGAIN;
@@ -2870,9 +2871,11 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 			   &sbi->s_flex_groups[flex_group].free_clusters);
 	}
 
+	ext4_ios_write_one(handle, bitmap_bh, EXT4_IOS_BLOCK_BITMAP);
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (err)
 		goto out_err;
+	ext4_ios_write_one(handle, gdp_bh, EXT4_IOS_GROUP_DESC);
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
@@ -4736,10 +4739,12 @@ do_more:
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	ext4_ios_write_one(handle, bitmap_bh, EXT4_IOS_BLOCK_BITMAP);
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
+	ext4_ios_write_one(handle, gd_bh, EXT4_IOS_GROUP_DESC);
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
@@ -4876,10 +4881,12 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
+	ext4_ios_write_one(handle, bitmap_bh, EXT4_IOS_BLOCK_BITMAP);
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
+	ext4_ios_write_one(handle, gd_bh, EXT4_IOS_GROUP_DESC);
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 200ae0f..c5fa87a 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -443,6 +443,8 @@ mext_insert_extents(handle_t *handle, struct inode *orig_inode,
 						end_ext, eh, range_to_move);
 
 	if (depth) {
+		ext4_ios_write_one(handle, orig_path->p_bh,
+				   EXT4_IOS_EXTENT_BLOCK);
 		ret = ext4_handle_dirty_metadata(handle, orig_inode,
 						 orig_path->p_bh);
 		if (ret)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2bd167f..4c768f4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1224,9 +1224,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		de = de2;
 	}
 	dx_insert_block(frame, hash2 + continued, newblock);
+	ext4_ios_write_one(handle, bh2, EXT4_IOS_DIR_ENTRY);
 	err = ext4_handle_dirty_metadata(handle, dir, bh2);
 	if (err)
 		goto journal_error;
+	ext4_ios_write_one(handle, frame->bh, EXT4_IOS_DIR_ENTRY);
 	err = ext4_handle_dirty_metadata(handle, dir, frame->bh);
 	if (err)
 		goto journal_error;
@@ -1324,6 +1326,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 	dir->i_version++;
 	ext4_mark_inode_dirty(handle, dir);
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	ext4_ios_write_one(handle, bh, EXT4_IOS_DIR_ENTRY);
 	err = ext4_handle_dirty_metadata(handle, dir, bh);
 	if (err)
 		ext4_std_error(dir->i_sb, err);
@@ -1414,7 +1417,9 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->bh = bh;
 	bh = bh2;
 
+	ext4_ios_write_one(handle, frame->bh, EXT4_IOS_DIR_ENTRY);
 	ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	ext4_ios_write_one(handle, bh, EXT4_IOS_DIR_ENTRY);
 	ext4_handle_dirty_metadata(handle, dir, bh);
 
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
@@ -1589,6 +1594,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
+			ext4_ios_write_one(handle, bh2, EXT4_IOS_DIR_ENTRY);
 			err = ext4_handle_dirty_metadata(handle, dir, bh2);
 			if (err)
 				goto journal_error;
@@ -1615,6 +1621,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			if (err)
 				goto journal_error;
 		}
+		ext4_ios_write_one(handle, frames[0].bh, EXT4_IOS_DIR_ENTRY);
 		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
 		if (err) {
 			ext4_std_error(inode->i_sb, err);
@@ -1673,6 +1680,7 @@ static int ext4_delete_entry(handle_t *handle,
 				de->inode = 0;
 			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_ios_write_one(handle, bh, EXT4_IOS_DIR_ENTRY);
 			err = ext4_handle_dirty_metadata(handle, dir, bh);
 			if (unlikely(err)) {
 				ext4_std_error(dir->i_sb, err);
@@ -1865,6 +1873,7 @@ retry:
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	set_nlink(inode, 2);
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	ext4_ios_write_one(handle, dir_block, EXT4_IOS_DIR_ENTRY);
 	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
 	if (err)
 		goto out_clear_inode;
@@ -2016,6 +2025,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
+	ext4_ios_write_one(handle, EXT4_SB(sb)->s_sbh, EXT4_IOS_SUPER_BLOCK);
 	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
@@ -2089,6 +2099,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
+		ext4_ios_write_one(handle, sbi->s_sbh, EXT4_IOS_SUPER_BLOCK);
 		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
 	} else {
 		struct ext4_iloc iloc2;
@@ -2478,6 +2489,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 					ext4_current_time(new_dir);
 		ext4_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext4_handle_dirty_metadata");
+		ext4_ios_write_one(handle, new_bh, EXT4_IOS_DIR_ENTRY);
 		retval = ext4_handle_dirty_metadata(handle, new_dir, new_bh);
 		if (unlikely(retval)) {
 			ext4_std_error(new_dir->i_sb, retval);
@@ -2532,6 +2544,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
+		ext4_ios_write_one(handle, dir_bh, EXT4_IOS_DIR_ENTRY);
 		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 08aa193..8e27b9c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4188,6 +4188,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 				&EXT4_SB(sb)->s_freeinodes_counter));
 	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
+	ext4_ios_write_one(NULL, sbh, EXT4_IOS_SUPER_BLOCK);
 	mark_buffer_dirty(sbh);
 	if (sync) {
 		error = sync_dirty_buffer(sbh);
@@ -4925,6 +4926,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	memcpy(bh->b_data+offset, data, len);
 	flush_dcache_page(bh->b_page);
 	unlock_buffer(bh);
+	ext4_ios_write_one(handle, bh, EXT4_IOS_SUPER_BLOCK);
 	err = ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
 out:
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 9869805..8df9076 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -491,6 +491,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				 EXT4_FREE_BLOCKS_FORGET);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		ext4_ios_write_one(handle, bh, EXT4_IOS_EXTENDED_ATTR);
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
@@ -727,10 +728,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			unlock_buffer(bs->bh);
 			if (error == -EIO)
 				goto bad_block;
-			if (!error)
+			if (!error) {
+				ext4_ios_write_one(handle, bs->bh,
+						   EXT4_IOS_EXTENDED_ATTR);
 				error = ext4_handle_dirty_metadata(handle,
 								   inode,
 								   bs->bh);
+			}
 			if (error)
 				goto cleanup;
 			goto inserted;
@@ -799,6 +803,8 @@ inserted:
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
+				ext4_ios_write_one(handle, new_bh,
+						   EXT4_IOS_EXTENDED_ATTR);
 				error = ext4_handle_dirty_metadata(handle,
 								   inode,
 								   new_bh);
@@ -857,6 +863,8 @@ getblk_failed:
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
 			ext4_xattr_cache_insert(new_bh);
+			ext4_ios_write_one(handle, new_bh,
+					   EXT4_IOS_EXTENDED_ATTR);
 			error = ext4_handle_dirty_metadata(handle,
 							   inode, new_bh);
 			if (error)
-- 
1.7.4.1

