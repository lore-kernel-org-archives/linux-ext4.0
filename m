From: Jan Kara <jack@suse.com>
Subject: [PATCH 09/19] ext2fs: Implement inode moving in libext2fs
Date: Fri,  7 Aug 2015 12:51:19 +0200
Message-ID: <1438944689-24562-10-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbbHGKvr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:47 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/move.c | 422 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/move.h |   1 +
 2 files changed, 423 insertions(+)

diff --git a/lib/ext2fs/move.c b/lib/ext2fs/move.c
index 5fc7a5fd53b6..6e286f118465 100644
--- a/lib/ext2fs/move.c
+++ b/lib/ext2fs/move.c
@@ -795,3 +795,425 @@ out:
 
 	return retval;
 }
+
+static int add_dir_block(ext2_filsys fs, blk64_t *block_nr,
+			 e2_blkcnt_t blockcnt,
+			 blk64_t ref_block EXT2FS_ATTR((unused)),
+			 int ref_offset EXT2FS_ATTR((unused)),
+			 void *priv_data)
+{
+	struct update_ref_process_block_struct *pb;
+	errcode_t retval;
+
+	pb = (struct update_ref_process_block_struct *) priv_data;
+	retval = ext2fs_add_dir_block2(fs->dblist, pb->ino, *block_nr,
+				       blockcnt);
+	if (retval) {
+		pb->error = retval;
+		return BLOCK_ABORT;
+	}
+	return 0;
+}
+static errcode_t build_dblist(ext2_filsys fs)
+{
+	errcode_t		retval;
+	ext2_inode_scan 	scan = NULL;
+	ext2_ino_t		ino;
+	struct ext2_inode 	*inode = NULL;
+	int			inode_size;
+	char			*block_buf = NULL;
+	struct ext2fs_numeric_progress_struct progress;
+	struct update_ref_process_block_struct pb;
+
+	retval = ext2fs_init_dblist(fs, NULL);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_get_array(fs->blocksize, 3, &block_buf);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		goto out;
+
+	if (fs->progress_ops) {
+		if (fs->progress_ops->init)
+			fs->progress_ops->init(fs, &progress,
+				       "Building list of directory blocks",
+				       fs->group_desc_count);
+		ext2fs_set_inode_callback(scan, progress_callback, &progress);
+	}
+
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	inode = malloc(inode_size);
+	if (!inode) {
+		retval = ENOMEM;
+		goto out;
+	}
+	pb.inode = inode;
+	pb.error = 0;
+	pb.bmap = NULL;
+
+	while (1) {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, inode_size);
+		if (retval)
+			goto out_progress;
+		if (!ino)
+			break;
+
+		if (inode->i_links_count == 0 && ino != EXT2_RESIZE_INO)
+			continue; /* inode not in use */
+
+		if (!LINUX_S_ISDIR(inode->i_mode))
+			continue;
+
+		if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
+			pb.ino = ino;
+			retval = ext2fs_block_iterate3(fs, ino, 0, block_buf,
+						       add_dir_block,
+						       &pb);
+			if (retval)
+				goto out_progress;
+			if (pb.error) {
+				retval = pb.error;
+				goto out_progress;
+			}
+		} else if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+			/* Add inline directory inodes to the list */
+			retval = ext2fs_add_dir_block2(fs->dblist, ino, 0, 0);
+			if (retval)
+				goto out_progress;
+		}
+	}
+out_progress:
+	if (fs->progress_ops && fs->progress_ops->close)
+		fs->progress_ops->close(fs, &progress, NULL);
+out:
+	if (scan)
+		ext2fs_close_inode_scan(scan);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	if (inode)
+		free(inode);
+	if (retval && fs->dblist) {
+		ext2fs_free_dblist(fs->dblist);
+		fs->dblist = NULL;
+	}
+	return retval;
+}
+
+/* Allocate space for inodes that need moving and move them there */
+static errcode_t alloc_copy_inodes(ext2_filsys fs, ext2fs_inode_bitmap move_map,
+				   ext2_map_extent imap)
+{
+	errcode_t		retval;
+	__u64			ino;
+	ext2_ino_t		new_ino;
+	dgrp_t			group;
+	int			inode_size;
+	struct ext2_inode	*inode = NULL;
+	ext2fs_inode_bitmap	merged_map = NULL;
+	struct ext2fs_numeric_progress_struct progress;
+
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	inode = malloc(inode_size);
+	if (!inode) {
+		retval = ENOMEM;
+		goto out;
+	}
+
+	retval = ext2fs_copy_bitmap(fs->inode_map, &merged_map);
+	if (retval)
+		goto out;
+
+	for (ino = 1; ino <= fs->super->s_inodes_count; ino++) {
+		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino) &&
+		    ext2fs_test_inode_bitmap2(move_map, ino))
+			ext2fs_mark_inode_bitmap2(merged_map, ino);
+	}
+
+	if (fs->progress_ops && fs->progress_ops->init)
+		fs->progress_ops->init(fs, &progress, "Moving inodes",
+				       fs->group_desc_count);
+	for (group = 0; group < fs->group_desc_count; group++) {
+		if (fs->progress_ops && fs->progress_ops->update) {
+			io_channel_flush(fs->io);
+			fs->progress_ops->update(fs, &progress, group);
+		}
+		if (ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT))
+			continue;
+
+		for (ino = fs->super->s_inodes_per_group * group + 1;
+		     ino <= fs->super->s_inodes_count &&
+		     ino <= fs->super->s_inodes_per_group * (group + 1);
+		     ino++) {
+			if (!ext2fs_fast_test_inode_bitmap2(move_map, ino))
+				continue;
+
+			retval = ext2fs_read_inode_full(fs, ino, inode,
+							inode_size);
+			if (retval)
+				goto out_progress;
+
+			if (inode->i_links_count == 0 &&
+			    ino != EXT2_RESIZE_INO)
+				continue; /* inode not in use */
+
+			retval = ext2fs_new_inode(fs, 0, 0, merged_map,
+						  &new_ino);
+			if (retval)
+				goto out_progress;
+			ext2fs_inode_alloc_stats2(fs, new_ino, +1,
+						  LINUX_S_ISDIR(inode->i_mode));
+			ext2fs_inode_alloc_stats2(fs, ino, -1,
+						  LINUX_S_ISDIR(inode->i_mode));
+			ext2fs_mark_inode_bitmap2(merged_map, new_ino);
+			inode->i_ctime = time(0);
+			retval = ext2fs_write_inode_full(fs, new_ino, inode,
+							 inode_size);
+			if (retval)
+				goto out_progress;
+
+			retval = ext2fs_add_extent_entry(imap, ino, new_ino);
+			if (retval)
+				goto out_progress;
+		}
+	}
+	io_channel_flush(fs->io);
+out_progress:
+	if (fs->progress_ops && fs->progress_ops->close)
+		fs->progress_ops->close(fs, &progress, NULL);
+out:
+	if (inode)
+		free(inode);
+	if (merged_map)
+		ext2fs_free_inode_bitmap(merged_map);
+	return retval;
+}
+
+struct dblist_scan_data {
+	ext2_filsys fs;
+	blk_t cur_block;
+	blk_t blocks;
+	ext2_ino_t last_dir_ino;
+	int dir_moved;
+	int times_updated;
+	errcode_t error;
+	ext2_map_extent imap;
+	struct ext2fs_numeric_progress_struct progress;
+};
+
+static int remap_db_entry(ext2_filsys fs, struct ext2_db_entry2 *db_info,
+                          void *priv_data)
+{
+	struct dblist_scan_data *data = priv_data;
+	__u64 new_ino;
+
+	new_ino = ext2fs_extent_translate(data->imap, db_info->ino);
+	if (new_ino)
+		db_info->ino = new_ino;
+	if (fs->progress_ops && fs->progress_ops->update)
+		fs->progress_ops->update(fs, &data->progress, 
+					 data->cur_block++);
+	return 0;
+}
+
+/* Update inode numbers in fs->dblist */
+static errcode_t rewrite_dblist_refs(ext2_filsys fs, ext2_map_extent imap)
+{
+	errcode_t		retval;
+	struct dblist_scan_data	data;
+
+	data.fs = fs;
+	data.cur_block = 0;
+	data.blocks = ext2fs_dblist_count2(fs->dblist);
+	data.last_dir_ino = 0;
+	data.error = 0;
+	data.imap = imap;
+
+	if (fs->progress_ops && fs->progress_ops->init)
+		fs->progress_ops->init(fs, &data.progress,
+				       "Remapping list of directory blocks",
+				       data.blocks);
+
+	retval = ext2fs_dblist_iterate2(fs->dblist, remap_db_entry, &data);
+	if (retval)
+		return retval;
+	if (data.error)
+		return data.error;
+
+	if (fs->progress_ops && fs->progress_ops->close)
+		fs->progress_ops->close(fs, &data.progress, NULL);
+	return 0;
+}
+
+static int check_and_change_inodes(ext2_ino_t dir,
+				   int entry EXT2FS_ATTR((unused)),
+				   struct ext2_dir_entry *dirent, int offset,
+				   int  blocksize EXT2FS_ATTR((unused)),
+				   char *buf EXT2FS_ATTR((unused)),
+				   void *priv_data)
+{
+	struct dblist_scan_data *data = priv_data;
+	struct ext2_inode	inode;
+	ext2_ino_t		new_ino;
+	errcode_t		retval;
+	int			ret = 0;
+
+	if (data->last_dir_ino != dir) {
+		data->last_dir_ino = dir;
+		data->times_updated = 0;
+		data->dir_moved = 0;
+		/*
+		 * If we have checksums enabled and the has moved, then we must
+		 * rewrite all dir blocks with new checksums.
+		 */
+		if (EXT2_HAS_RO_COMPAT_FEATURE(data->fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		    ext2fs_extent_translate(data->imap, dir))
+			data->dir_moved = 1;
+	}
+
+	if (data->dir_moved)
+		ret |= DIRENT_CHANGED;
+
+	if (!dirent->inode)
+		return ret;
+
+	new_ino = ext2fs_extent_translate(data->imap, dirent->inode);
+	if (!new_ino)
+		return ret;
+	dirent->inode = new_ino;
+	ret |= DIRENT_CHANGED;
+
+	/* Update directory mtime and ctime for each dir */
+	if (!data->times_updated) {
+		retval = ext2fs_read_inode(data->fs, dir, &inode);
+		if (retval == 0) {
+			inode.i_mtime = inode.i_ctime = time(0);
+			retval = ext2fs_write_inode(data->fs, dir, &inode);
+			if (retval) {
+				data->error = retval;
+				ret |= DIRENT_ABORT;
+			}
+		}
+		data->times_updated = 1;
+	}
+
+	if (data->fs->progress_ops && data->fs->progress_ops->update &&
+	    !offset) {
+		io_channel_flush(data->fs->io);
+		data->fs->progress_ops->update(data->fs, &data->progress,
+					       data->cur_block++);
+	}
+	return ret;
+}
+
+/* Scan all directory blocks and update inode references */
+static errcode_t fix_inode_refs(ext2_filsys fs, ext2_map_extent imap)
+{
+	errcode_t		retval;
+	struct dblist_scan_data	data;
+
+	data.fs = fs;
+	data.cur_block = 0;
+	data.blocks = ext2fs_dblist_count2(fs->dblist);
+	data.last_dir_ino = 0;
+	data.error = 0;
+	data.imap = imap;
+
+	if (fs->progress_ops && fs->progress_ops->init)
+		fs->progress_ops->init(fs, &data.progress,
+				       "Updating inode references",
+				       data.blocks);
+
+	/*
+	 * dblist still has old inode numbers so iteration will use inodes
+	 * at old positions. That is fine though because we didn't clobber
+	 * that space yet.
+	 */
+	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	retval = ext2fs_dblist_dir_iterate(fs->dblist,
+					   DIRENT_FLAG_INCLUDE_EMPTY, 0,
+					   check_and_change_inodes, &data);
+	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	if (fs->progress_ops && fs->progress_ops->close)
+		fs->progress_ops->close(fs, &data.progress, NULL);
+	if (retval)
+		return retval;
+	if (data.error)
+		return data.error;
+
+	return 0;
+}
+
+/*
+ * Generic inode moving function. It moves inodes specified in move_map so that
+ * they become unused (it marks these inodes as  free in the inode bitmap). It
+ * takes care of rewriting references from directory entries as well.
+ *
+ * The function uses fs->dblist for rewriting if present (the caller is
+ * responsible for it to be correct and complete in that case) and updates
+ * inode numbers there. Otherwise we build our own fs->dblist.
+ */
+errcode_t ext2fs_move_inodes(ext2_filsys fs, ext2fs_inode_bitmap move_map)
+{
+	errcode_t		retval;
+	ext2_map_extent		imap = NULL;
+	ext2_ino_t		ino;
+	unsigned int		inodes_to_move = 0, inodes_free = 0;
+
+	retval = ext2fs_read_bitmaps(fs);
+	if (retval)
+		return retval;
+
+	for (ino = 1; ino <= fs->super->s_inodes_count; ino++) {
+		int used, move;
+
+		used = ext2fs_fast_test_inode_bitmap2(fs->inode_map, ino);
+		move = ext2fs_fast_test_inode_bitmap2(move_map, ino);
+		if (!used && !move)
+			inodes_free++;
+		else if (used && move)
+			inodes_to_move++;
+	}
+
+	if (inodes_free < inodes_to_move) {
+		retval = ENOSPC;
+		goto out;
+	}
+
+	retval = ext2fs_create_extent_table(&imap, 0);
+	if (retval)
+		goto out;
+
+	if (!fs->dblist) {
+		retval = build_dblist(fs);
+		if (retval)
+			goto out;
+	}
+
+	retval = alloc_copy_inodes(fs, move_map, imap);
+	if (retval)
+		goto out;
+
+	/* Nothing to map? */
+	if (ext2fs_extent_table_empty(imap))
+		goto out;
+
+	retval = fix_inode_refs(fs, imap);
+	if (retval)
+		goto out;
+
+	retval = rewrite_dblist_refs(fs, imap);
+out:
+	if (retval && fs->dblist) {
+		/* dblist is likely invalid, free it */
+		ext2fs_free_dblist(fs->dblist);
+		fs->dblist = NULL;
+	}
+	if (imap)
+		ext2fs_free_extent_table(imap);
+	return retval;
+}
diff --git a/lib/ext2fs/move.h b/lib/ext2fs/move.h
index 8d66aa039ec0..9218d374c1eb 100644
--- a/lib/ext2fs/move.h
+++ b/lib/ext2fs/move.h
@@ -19,5 +19,6 @@ extern errcode_t ext2fs_iterate_extent(ext2_map_extent extent, __u64 *old_loc,
 /* move.c */
 errcode_t ext2fs_move_blocks(ext2_filsys fs, ext2fs_block_bitmap move_map,
 			     ext2fs_block_bitmap reuse_map);
+errcode_t ext2fs_move_inodes(ext2_filsys fs, ext2fs_inode_bitmap move_map);
 
 #endif
-- 
2.1.4

