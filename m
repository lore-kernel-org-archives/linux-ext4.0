From: Jan Kara <jack@suse.com>
Subject: [PATCH 05/21] ext2fs: Implement block moving in libext2fs
Date: Wed, 26 Aug 2015 18:22:20 +0200
Message-ID: <1440606156-5754-6-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbbHZQWz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:55 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/Makefile.in  |   6 +-
 lib/ext2fs/ext2fs.h     |   4 +
 lib/ext2fs/extent_map.c | 233 ++++++++++++
 lib/ext2fs/move.c       | 950 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/move.h       |  19 +
 5 files changed, 1211 insertions(+), 1 deletion(-)
 create mode 100644 lib/ext2fs/extent_map.c
 create mode 100644 lib/ext2fs/move.c
 create mode 100644 lib/ext2fs/move.h

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 26aaf6fb1a15..02ede7bbf856 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -125,7 +125,9 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	unlink.o \
 	valid_blk.o \
 	version.o \
-	rbtree.o
+	rbtree.o \
+	extent_map.o \
+	move.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -215,6 +217,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/write_bb_file.c \
 	$(srcdir)/rbtree.c \
 	$(srcdir)/tst_libext2fs.c \
+	$(srcdir)/extent_map.c \
+	$(srcdir)/move.c \
 	$(DEBUG_SRCS)
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0b8d1f6f22b1..2e07bddf6e39 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1523,6 +1523,10 @@ extern errcode_t ext2fs_add_journal_inode2(ext2_filsys fs, blk_t num_blocks,
 extern int ext2fs_default_journal_size(__u64 num_blocks);
 extern int ext2fs_journal_sb_start(int blocksize);
 
+/* move.c */
+errcode_t ext2fs_move_blocks(ext2_filsys fs, ext2fs_block_bitmap move_map,
+			     ext2fs_block_bitmap reuse_map);
+
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
 			     unsigned int block_size, io_manager manager,
diff --git a/lib/ext2fs/extent_map.c b/lib/ext2fs/extent_map.c
new file mode 100644
index 000000000000..a4e1df404dca
--- /dev/null
+++ b/lib/ext2fs/extent_map.c
@@ -0,0 +1,233 @@
+/*
+ * extent.c --- ext2 extent mapping abstraction
+ *
+ * This abstraction is used to provide a compact way of representing a
+ * translation table, for moving multiple contiguous ranges (extents)
+ * of blocks or inodes.
+ *
+ * Copyright (C) 1997, 1998 by Theodore Ts'o and
+ * 	PowerQuest, Inc.
+ *
+ * Copyright (C) 1999, 2000 by Theodore Ts'o
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <string.h>
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+#include "ext2_fs.h"
+#include "com_err.h"
+#include "move.h"
+
+struct ext2_map_extent_entry {
+	__u64	old_loc, new_loc;
+	__u64	size;
+};
+
+struct _ext2_map_extent {
+	struct ext2_map_extent_entry *list;
+	__u64	cursor;
+	__u64	size;
+	__u64	num;
+	__u64	sorted;
+};
+
+int ext2fs_extent_table_empty(ext2_map_extent extent)
+{
+	return !extent->num;
+}
+
+/*
+ * Create an extent table
+ */
+errcode_t ext2fs_create_extent_table(ext2_map_extent *ret_extent, __u64 size)
+{
+	ext2_map_extent	extent;
+	errcode_t	retval;
+
+	retval = ext2fs_get_mem(sizeof(struct _ext2_map_extent), &extent);
+	if (retval)
+		return retval;
+	memset(extent, 0, sizeof(struct _ext2_map_extent));
+
+	extent->size = size ? size : 50;
+	extent->cursor = 0;
+	extent->num = 0;
+	extent->sorted = 1;
+
+	retval = ext2fs_get_array(sizeof(struct ext2_map_extent_entry),
+				extent->size, &extent->list);
+	if (retval) {
+		ext2fs_free_mem(&extent);
+		return retval;
+	}
+	memset(extent->list, 0,
+	       sizeof(struct ext2_map_extent_entry) * extent->size);
+	*ret_extent = extent;
+	return 0;
+}
+
+/*
+ * Free an extent table
+ */
+void ext2fs_free_extent_table(ext2_map_extent extent)
+{
+	if (extent->list)
+		ext2fs_free_mem(&extent->list);
+	extent->list = 0;
+	extent->size = 0;
+	extent->num = 0;
+	ext2fs_free_mem(&extent);
+}
+
+/*
+ * Add an entry to the extent table
+ */
+errcode_t ext2fs_add_extent_entry(ext2_map_extent extent, __u64 old_loc,
+				  __u64 new_loc)
+{
+	struct	ext2_map_extent_entry	*ent;
+	errcode_t			retval;
+	__u64				newsize;
+	__u64				curr;
+
+	if (extent->num >= extent->size) {
+		newsize = extent->size + 100;
+		retval = ext2fs_resize_mem(
+			sizeof(struct ext2_map_extent_entry) * extent->size,
+			sizeof(struct ext2_map_extent_entry) * newsize,
+			&extent->list);
+		if (retval)
+			return retval;
+		extent->size = newsize;
+	}
+	curr = extent->num;
+	ent = extent->list + curr;
+	if (curr) {
+		/*
+		 * Check to see if this can be coalesced with the last
+		 * extent
+		 */
+		ent--;
+		if ((ent->old_loc + ent->size == old_loc) &&
+		    (ent->new_loc + ent->size == new_loc)) {
+			ent->size++;
+			return 0;
+		}
+		/*
+		 * Now see if we're going to ruin the sorting
+		 */
+		if (ent->old_loc + ent->size > old_loc)
+			extent->sorted = 0;
+		ent++;
+	}
+	ent->old_loc = old_loc;
+	ent->new_loc = new_loc;
+	ent->size = 1;
+	extent->num++;
+	return 0;
+}
+
+/*
+ * Helper function for qsort
+ */
+static EXT2_QSORT_TYPE extent_cmp(const void *a, const void *b)
+{
+	const struct ext2_map_extent_entry *db_a;
+	const struct ext2_map_extent_entry *db_b;
+
+	db_a = (const struct ext2_map_extent_entry *) a;
+	db_b = (const struct ext2_map_extent_entry *) b;
+
+	return (db_a->old_loc - db_b->old_loc);
+}
+
+/*
+ * Given an inode map and inode number, look up the old inode number
+ * and return the new inode number.
+ */
+__u64 ext2fs_extent_translate(ext2_map_extent extent, __u64 old_loc)
+{
+	__s64	low, high, mid;
+	__u64	lowval, highval;
+	float	range;
+
+	if (!extent->sorted) {
+		qsort(extent->list, extent->num,
+		      sizeof(struct ext2_map_extent_entry), extent_cmp);
+		extent->sorted = 1;
+	}
+	low = 0;
+	high = extent->num-1;
+	while (low <= high) {
+#if 0
+		mid = (low+high)/2;
+#else
+		if (low == high)
+			mid = low;
+		else {
+			/* Interpolate for efficiency */
+			lowval = extent->list[low].old_loc;
+			highval = extent->list[high].old_loc;
+
+			if (old_loc < lowval)
+				range = 0;
+			else if (old_loc > highval)
+				range = 1;
+			else {
+				range = ((float) (old_loc - lowval)) /
+					(highval - lowval);
+				if (range > 0.9)
+					range = 0.9;
+				if (range < 0.1)
+					range = 0.1;
+			}
+			mid = low + ((__u64) (range * (high-low)));
+		}
+#endif
+		if ((old_loc >= extent->list[mid].old_loc) &&
+		    (old_loc < extent->list[mid].old_loc + extent->list[mid].size))
+			return (extent->list[mid].new_loc +
+				(old_loc - extent->list[mid].old_loc));
+		if (old_loc < extent->list[mid].old_loc)
+			high = mid-1;
+		else
+			low = mid+1;
+	}
+	return 0;
+}
+
+/*
+ * Iterate over the contents of the extent table
+ */
+errcode_t ext2fs_iterate_extent(ext2_map_extent extent, __u64 *old_loc,
+				__u64 *new_loc, __u64 *size)
+{
+	struct ext2_map_extent_entry *ent;
+
+	if (!old_loc) {
+		extent->cursor = 0;
+		return 0;
+	}
+
+	if (extent->cursor >= extent->num) {
+		*old_loc = 0;
+		*new_loc = 0;
+		*size = 0;
+		return 0;
+	}
+
+	ent = extent->list + extent->cursor++;
+
+	*old_loc = ent->old_loc;
+	*new_loc = ent->new_loc;
+	*size = ent->size;
+	return 0;
+}
diff --git a/lib/ext2fs/move.c b/lib/ext2fs/move.c
new file mode 100644
index 000000000000..691b6d78acca
--- /dev/null
+++ b/lib/ext2fs/move.c
@@ -0,0 +1,950 @@
+#include "ext2fs.h"
+#include "ext2fsP.h"
+#include "move.h"
+
+#define min(x, y) ((x) < (y) ? (x) : (y))
+
+/*
+ * Functions to move blocks around
+ */
+enum mover_alloc_state {
+	AVOID_REUSE,
+	DESPERATION,
+};
+
+struct mover_alloc_data {
+	ext2_filsys fs;
+	enum mover_alloc_state alloc_state;
+	blk64_t new_blk;
+	ext2fs_block_bitmap reuse_map;
+	ext2fs_block_bitmap move_map;
+};
+
+static blk64_t get_new_block(struct mover_alloc_data *data)
+{
+	ext2_filsys fs = data->fs;
+
+	while (1) {
+		if (data->new_blk >= ext2fs_blocks_count(fs->super)) {
+			if (data->alloc_state == DESPERATION)
+				return 0;
+			data->alloc_state = DESPERATION;
+			data->new_blk = fs->super->s_first_data_block;
+			continue;
+		}
+		if (ext2fs_test_block_bitmap2(fs->block_map, data->new_blk) ||
+		    ext2fs_test_block_bitmap2(data->move_map, data->new_blk) ||
+		    (data->alloc_state == AVOID_REUSE &&
+		     ext2fs_test_block_bitmap2(data->reuse_map,
+					       data->new_blk))) {
+			data->new_blk++;
+			continue;
+		}
+		return data->new_blk;
+	}
+}
+
+static errcode_t move_get_new_block(ext2_filsys fs, blk64_t goal,
+				    blk64_t *ret)
+{
+	struct mover_alloc_data *data =
+				(struct mover_alloc_data *)fs->alloc_data;
+	blk64_t blk;
+
+	blk = get_new_block(data);
+	if (!blk)
+		return ENOSPC;
+	*ret = blk;
+	return 0;
+}
+
+static errcode_t block_mover(ext2_filsys fs, ext2fs_block_bitmap move_map,
+			     ext2fs_block_bitmap reuse_map,
+			     ext2_map_extent bmap)
+{
+	blk64_t			blk, old_blk, new_blk;
+	errcode_t		retval;
+	__u64			size;
+	int			c;
+	int			to_move, moved;
+	ext2_badblocks_list	badblock_list = 0;
+	int			bb_modified = 0;
+	char			*buf;
+	int			buf_blocks = fs->inode_blocks_per_group;
+	struct mover_alloc_data data;
+	struct ext2fs_numeric_progress_struct progress;
+
+	retval = ext2fs_read_bb_inode(fs, &badblock_list);
+	if (retval)
+		return retval;
+
+	new_blk = fs->super->s_first_data_block;
+	retval = ext2fs_get_array(fs->blocksize, buf_blocks, &buf);
+	if (retval)
+		return retval;
+
+	data.fs = fs;
+	data.new_blk = fs->super->s_first_data_block;
+	data.alloc_state = AVOID_REUSE;
+	data.reuse_map = reuse_map;
+	data.move_map = move_map;
+	fs->alloc_data = &data;
+	ext2fs_set_alloc_block_callback(fs, move_get_new_block, NULL);
+
+	/*
+	 * The first step is to figure out where all of the blocks
+	 * will go.
+	 */
+	to_move = moved = 0;
+	for (blk = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	     blk < ext2fs_blocks_count(fs->super);
+	     blk += EXT2FS_CLUSTER_RATIO(fs)) {
+		if (!ext2fs_test_block_bitmap2(fs->block_map, blk))
+			continue;
+		if (!ext2fs_test_block_bitmap2(move_map, blk))
+			continue;
+		if (ext2fs_badblocks_list_test(badblock_list, blk)) {
+			ext2fs_badblocks_list_del(badblock_list, blk);
+			bb_modified++;
+			continue;
+		}
+
+		new_blk = get_new_block(&data);
+		if (!new_blk) {
+			retval = ENOSPC;
+			goto errout;
+		}
+		ext2fs_block_alloc_stats2(fs, new_blk, +1);
+		ext2fs_block_alloc_stats2(fs, blk, -1);
+		ext2fs_add_extent_entry(bmap, EXT2FS_B2C(fs, blk),
+					EXT2FS_B2C(fs, new_blk));
+		to_move++;
+	}
+
+	if (to_move == 0) {
+		retval = -1;
+		goto errout;
+	}
+
+	/*
+	 * Step two is to actually move the blocks
+	 */
+	retval = ext2fs_iterate_extent(bmap, 0, 0, 0);
+	if (retval)
+		goto errout;
+
+	if (fs->progress_ops && fs->progress_ops->init) {
+		(fs->progress_ops->init)(fs, &progress, "Relocating blocks",
+					 to_move);
+	}
+	while (1) {
+		retval = ext2fs_iterate_extent(bmap, &old_blk, &new_blk, &size);
+		if (retval)
+			goto errout_progress;
+		if (!size)
+			break;
+		old_blk = EXT2FS_C2B(fs, old_blk);
+		new_blk = EXT2FS_C2B(fs, new_blk);
+		size = EXT2FS_C2B(fs, size);
+		do {
+			c = min(size, buf_blocks);
+			retval = io_channel_read_blk64(fs->io, old_blk, c, buf);
+			if (retval)
+				goto errout_progress;
+			retval = io_channel_write_blk64(fs->io, new_blk, c,
+							buf);
+			if (retval)
+				goto errout_progress;
+			size -= c;
+			new_blk += c;
+			old_blk += c;
+			moved += c;
+			if (fs->progress_ops && fs->progress_ops->update) {
+				io_channel_flush(fs->io);
+				fs->progress_ops->update(fs, &progress, moved);
+			}
+		} while (size > 0);
+		io_channel_flush(fs->io);
+	}
+errout_progress:
+	if (fs->progress_ops && fs->progress_ops->close) {
+		fs->progress_ops->close(fs, &progress, NULL);
+	}
+errout:
+	ext2fs_set_alloc_block_callback(fs, NULL, NULL);
+	fs->alloc_data = NULL;
+
+	if (badblock_list) {
+		if (!retval && bb_modified)
+			retval = ext2fs_update_bb_inode(fs, badblock_list);
+		ext2fs_badblocks_list_free(badblock_list);
+	}
+	ext2fs_free_mem(&buf);
+
+	return retval;
+}
+
+/*
+ * Functions to update block references from inode
+ */
+
+/*
+ * The extent translation table is stored in clusters so we need to
+ * take special care when mapping a source block number to its
+ * destination block number.
+ */
+static __u64 extent_translate(ext2_filsys fs, ext2_map_extent extent,
+			      __u64 old_loc)
+{
+	__u64 new_block = EXT2FS_C2B(fs,
+		ext2fs_extent_translate(extent, EXT2FS_B2C(fs, old_loc)));
+
+	if (new_block != 0)
+		new_block += old_loc & (EXT2FS_CLUSTER_RATIO(fs) - 1);
+	return new_block;
+}
+
+static errcode_t migrate_ea_block(ext2_filsys fs, ext2_ino_t ino,
+				  struct ext2_inode *inode,
+				  ext2_map_extent bmap)
+{
+	char *buf = NULL;
+	blk64_t new_block;
+	errcode_t err = 0;
+
+	/* No EA block?  Quit early. */
+	if (ext2fs_file_acl_block(fs, inode) == 0)
+		return 0;
+	new_block = extent_translate(fs, bmap,
+				     ext2fs_file_acl_block(fs, inode));
+	if (new_block == 0)
+		return 0;
+
+	/* Set the new ACL block */
+	ext2fs_file_acl_block_set(fs, inode, new_block);
+
+	/* Update checksum */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		err = ext2fs_get_mem(fs->blocksize, &buf);
+		if (err)
+			return err;
+		fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		err = ext2fs_read_ext_attr3(fs, new_block, buf, ino);
+		fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		if (err)
+			goto out;
+		err = ext2fs_write_ext_attr3(fs, new_block, buf, ino);
+		if (err)
+			goto out;
+	}
+	err = ext2fs_write_inode_full(fs, ino, inode,
+				      EXT2_INODE_SIZE(fs->super));
+out:
+	ext2fs_free_mem(&buf);
+	return err;
+}
+
+struct update_ref_process_block_struct {
+	ext2_ino_t		ino;
+	struct ext2_inode *	inode;
+	ext2_map_extent		bmap;
+	errcode_t		error;
+};
+
+static int update_ref_process_block(ext2_filsys fs, blk64_t *block_nr,
+				    e2_blkcnt_t blockcnt,
+				    blk64_t ref_block EXT2FS_ATTR((unused)),
+				    int ref_offset EXT2FS_ATTR((unused)),
+				    void *priv_data)
+{
+	struct update_ref_process_block_struct *pb;
+	blk64_t		block, new_block;
+	int		ret = 0;
+
+	pb = (struct update_ref_process_block_struct *) priv_data;
+	block = *block_nr;
+	new_block = extent_translate(fs, pb->bmap, block);
+	if (new_block) {
+		*block_nr = new_block;
+		ret |= BLOCK_CHANGED;
+	} else
+		new_block = block;
+
+	/* Add dir block to dblist */
+	if (LINUX_S_ISDIR(pb->inode->i_mode)) {
+		errcode_t	retval;
+
+		retval = ext2fs_add_dir_block2(fs->dblist, pb->ino, new_block,
+					       blockcnt);
+		if (retval) {
+			pb->error = retval;
+			ret |= BLOCK_ABORT;
+		}
+	}
+	return ret;
+}
+
+static errcode_t progress_callback(ext2_filsys fs,
+				   ext2_inode_scan scan EXT2FS_ATTR((unused)),
+				   dgrp_t group, void * priv_data)
+{
+	struct ext2fs_numeric_progress_struct *progress = priv_data;
+
+	io_channel_flush(fs->io);
+	if (fs->progress_ops->update)
+		(fs->progress_ops->update)(fs, progress, group + 1);
+
+	return 0;
+}
+
+/*
+ * Scan all inodes and update block references to new blocks. Also build new
+ * fs->dblist.
+ */
+static errcode_t fix_block_refs(ext2_filsys fs, ext2_map_extent bmap)
+{
+	struct update_ref_process_block_struct	pb;
+	ext2_ino_t		ino;
+	struct ext2_inode	*inode = NULL;
+	ext2_inode_scan		scan = NULL;
+	errcode_t		retval;
+	char			*block_buf = 0;
+	int			inode_size;
+	struct ext2fs_numeric_progress_struct progress;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		goto errout;
+
+	retval = ext2fs_get_array(fs->blocksize, 3, &block_buf);
+	if (retval)
+		goto errout;
+
+	/* Free old dblist, it needn't be valid after we moved blocks anyway */
+	if (fs->dblist) {
+		ext2fs_free_dblist(fs->dblist);
+		fs->dblist = NULL;
+	}
+	retval = ext2fs_init_dblist(fs, NULL);
+	if (retval)
+		goto errout;
+
+	if (fs->progress_ops) {
+		if (fs->progress_ops->init)
+			fs->progress_ops->init(fs, &progress,
+					       "Updating block references",
+					       fs->group_desc_count);
+		ext2fs_set_inode_callback(scan, progress_callback, &progress);
+	}
+
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	inode = malloc(inode_size);
+	if (!inode) {
+		retval = ENOMEM;
+		goto errout_progress;
+	}
+
+	pb.inode = inode;
+	pb.error = 0;
+	pb.bmap = bmap;
+
+	while (1) {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, inode_size);
+		if (retval)
+			goto errout_progress;
+		if (!ino)
+			break;
+
+		if (inode->i_links_count == 0 && ino != EXT2_RESIZE_INO)
+			continue; /* inode not in use */
+
+		/* Remap EA block */
+		retval = migrate_ea_block(fs, ino, inode, bmap);
+		if (retval)
+			goto errout_progress;
+
+		/*
+		 * Update inodes to point to new blocks; schedule directory
+		 * blocks for inode remapping.  Need to write out dir blocks
+		 * with new inode numbers if we have metadata_csum enabled.
+		 */
+		if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
+			pb.ino = ino;
+			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			retval = ext2fs_block_iterate3(fs, ino, 0, block_buf,
+						       update_ref_process_block,
+						       &pb);
+			fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			if (retval)
+				goto errout_progress;
+			if (pb.error) {
+				retval = pb.error;
+				goto errout_progress;
+			}
+		} else if (inode->i_flags & EXT4_INLINE_DATA_FL &&
+			   LINUX_S_ISDIR(inode->i_mode)) {
+			/* Add inline directory inodes to the list */
+			retval = ext2fs_add_dir_block2(fs->dblist, ino, 0, 0);
+			if (retval)
+				goto errout_progress;
+		}
+	}
+	io_channel_flush(fs->io);
+errout_progress:
+	if (fs->progress_ops && fs->progress_ops->close)
+		fs->progress_ops->close(fs, &progress, NULL);
+errout:
+	if (scan)
+		ext2fs_close_inode_scan(scan);
+	if (block_buf)
+		ext2fs_free_mem(&block_buf);
+	free(inode);
+
+	return retval;
+}
+
+/*
+ * Move block group metadata (bitmaps, inode table)
+ */
+static errcode_t move_inode_table(ext2_filsys fs, dgrp_t group,
+				  blk64_t orig_loc, char *buf)
+{
+	blk64_t new_loc, n;
+	errcode_t retval;
+	long *c;
+	size_t size;
+	unsigned long long diff;
+
+	new_loc = ext2fs_inode_table_loc(fs, group);
+	retval = io_channel_read_blk64(fs->io, orig_loc,
+				       fs->inode_blocks_per_group, buf);
+	if (retval)
+		return retval;
+
+	diff = llabs(new_loc - orig_loc);
+	if (diff >= fs->inode_blocks_per_group) {
+		n = fs->inode_blocks_per_group;
+		goto skip_zero;
+	}
+	/*
+	 * The end of the inode table segment often contains
+	 * all zeros, and we're often only moving the inode
+	 * table down a block or two.  If so, we can optimize
+	 * things by not rewriting blocks that we know to be zero
+	 * already.
+	 */
+	size = fs->inode_blocks_per_group * fs->blocksize;
+	for (c = (long *)(buf + size - sizeof(long)), n = 0; n < size;
+	     n += sizeof(long), c--)
+		if (*c)
+			break;
+	n = fs->inode_blocks_per_group - (n >> EXT2_BLOCK_SIZE_BITS(fs->super));
+	/* If we don't save anything with skipping zeros, don't do it... */
+	if (n + diff >= fs->inode_blocks_per_group)
+		n = fs->inode_blocks_per_group;
+skip_zero:
+	retval = io_channel_write_blk64(fs->io, new_loc, n, buf);
+	if (retval) {
+		io_channel_write_blk64(fs->io, orig_loc, n, buf);
+		return retval;
+	}
+	if (n == fs->inode_blocks_per_group)
+		return 0;
+	/*
+	 * Write zeros to overwrite non-zero values in original table. We
+	 * distinguish two cases:
+	 * new_loc < orig_loc   orig_loc + n   orig_loc + itb
+	 *    |          |XXXXXXXXXX|00000000000000|
+	 *
+	 * orig_loc   new_loc   orig_loc + n   orig_loc + itb
+	 *     |XXXXXXXXX|XXXXXXXXXX|00000000000000|
+	 */
+	if (new_loc < orig_loc) {
+		ext2fs_zero_blocks2(fs, new_loc + n, diff, NULL, NULL);
+	} else {
+		ext2fs_zero_blocks2(fs,
+				new_loc + fs->inode_blocks_per_group - diff,
+				diff, NULL, NULL);
+	}
+	return 0;
+}
+
+/*
+ * This helper function creates a block bitmap with all of the
+ * filesystem meta-data blocks.
+ */
+static errcode_t mark_table_blocks(ext2_filsys fs,
+				   ext2fs_block_bitmap bmap)
+{
+	dgrp_t			i;
+	blk64_t			blk;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		ext2fs_reserve_super_and_bgd(fs, i, bmap);
+
+		/*
+		 * Mark the blocks used for the inode table
+		 */
+		blk = ext2fs_inode_table_loc(fs, i);
+		if (blk)
+			ext2fs_mark_block_bitmap_range2(bmap, blk,
+						fs->inode_blocks_per_group);
+
+		/*
+		 * Mark block used for the block bitmap
+		 */
+		blk = ext2fs_block_bitmap_loc(fs, i);
+		if (blk)
+			ext2fs_mark_block_bitmap2(bmap, blk);
+
+		/*
+		 * Mark block used for the inode bitmap
+		 */
+		blk = ext2fs_inode_bitmap_loc(fs, i);
+		if (blk)
+			ext2fs_mark_block_bitmap2(bmap, blk);
+	}
+	return 0;
+}
+
+static errcode_t relocate_inode_table(ext2_filsys fs, dgrp_t grp,
+				      blk64_t old_itable_loc,
+				      blk64_t new_itable_loc, char *buf)
+{
+	errcode_t retval;
+
+	ext2fs_inode_table_loc_set(fs, grp, new_itable_loc);
+	retval = move_inode_table(fs, grp, old_itable_loc, buf);
+	if (retval) {
+		/*
+		 * Back out setting of inode table location to avoid loosing
+		 * inodes
+		 */
+		ext2fs_inode_table_loc_set(fs, grp, old_itable_loc);
+		return retval;
+	}
+	if (EXT2FS_CLUSTER_RATIO(fs) <= 1) {
+		/* Now mark blocks under old table as free */
+		ext2fs_block_alloc_stats_range(fs, old_itable_loc,
+					       fs->inode_blocks_per_group, -1);
+		/* Mark blocks under new table as used */
+		ext2fs_block_alloc_stats_range(fs, new_itable_loc,
+					       fs->inode_blocks_per_group, +1);
+	}
+	return 0;
+}
+
+static void relocate_bitmap(ext2_filsys fs, dgrp_t grp, blk64_t old_loc,
+			    blk64_t new_loc, int block)
+{
+	if (block) {
+		ext2fs_block_bitmap_loc_set(fs, grp, new_loc);
+		ext2fs_mark_bb_dirty(fs);
+	} else {
+		ext2fs_inode_bitmap_loc_set(fs, grp, new_loc);
+		ext2fs_mark_ib_dirty(fs);
+	}
+	if (EXT2FS_CLUSTER_RATIO(fs) <= 1)
+		ext2fs_block_alloc_stats2(fs, old_loc, -1);
+	ext2fs_block_alloc_stats2(fs, new_loc, +1);
+}
+
+/* Structure for tracking new locations of group metadata */
+struct group_metadata_loc {
+	blk64_t bb;
+	blk64_t ib;
+	blk64_t itable;
+};
+
+/*
+ * Moves group metadata whose blocks are marked in move_map. We also mark bits
+ * in move_map for data or directory blocks that need moving to make space for
+ * relocated group metadata (bitmaps, inode tables).
+ */
+static errcode_t ext2fs_move_group_metadata(ext2_filsys fs,
+					    ext2fs_block_bitmap move_map,
+					    struct group_metadata_loc *new_loc)
+{
+	dgrp_t i;
+	blk64_t b, table_loc, new_table_loc, bb_blk, ib_blk;
+	int relocate, move_itable;
+	char *buf;
+	errcode_t retval;
+	struct ext2fs_numeric_progress_struct progress;
+	ext2fs_block_bitmap g_meta_map = NULL;
+
+	retval = ext2fs_get_array(fs->blocksize, fs->inode_blocks_per_group,
+				  &buf);
+	if (retval)
+		return retval;
+
+	/*
+	 * We create a bitmap with blocks to move and group metadata. These are
+	 * the blocks we cannot use as a new location of group metadata.
+	 */
+	retval = ext2fs_copy_bitmap(move_map, &g_meta_map);
+	if (retval)
+		goto out;
+
+	retval = mark_table_blocks(fs, g_meta_map);
+	if (retval)
+		goto out;
+
+	if (fs->progress_ops && fs->progress_ops->init)
+		fs->progress_ops->init(fs, &progress, "Moving group metadata",
+				       fs->group_desc_count);
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		relocate = 0;
+		move_itable = 0;
+
+		bb_blk = ext2fs_block_bitmap_loc(fs, i);
+		if (ext2fs_test_block_bitmap2(move_map, bb_blk)) {
+			ext2fs_block_bitmap_loc_set(fs, i, 0);
+			relocate = 1;
+		}
+
+		ib_blk = ext2fs_inode_bitmap_loc(fs, i);
+		if (ext2fs_test_block_bitmap2(move_map, ib_blk)) {
+			ext2fs_inode_bitmap_loc_set(fs, i, 0);
+			relocate = 1;
+		}
+
+		table_loc = ext2fs_inode_table_loc(fs, i);
+		for (b = 0; b < fs->inode_blocks_per_group; b++) {
+			if (ext2fs_test_block_bitmap2(move_map,
+						      table_loc + b)) {
+				ext2fs_inode_table_loc_set(fs, i, 0);
+				move_itable = 1;
+				relocate = 1;
+				break;
+			}
+		}
+
+		if (relocate) {
+			if (EXT2FS_CLUSTER_RATIO(fs) <= 1 && move_itable) {
+				/*
+				 * Mark blocks under old table as
+				 * available for allocation of group
+				 * metadata (unless they are marked in
+				 * move_map) since we'd like to reuse
+				 * them as much as possible.
+				 */
+				for (b = 0; b < fs->inode_blocks_per_group;
+				     b++) {
+					if (!ext2fs_test_block_bitmap2(move_map,
+							table_loc + b)) {
+						ext2fs_unmark_block_bitmap2(
+							g_meta_map,
+							table_loc + b);
+					}
+				}
+			}
+
+			retval = ext2fs_allocate_group_table2(fs, i, g_meta_map,
+					0);
+			if (retval)
+				goto out_progress;
+			/*
+			 * If blocks under bitmaps are used for something else,
+			 * mark the blocks to be moved away and undo changes
+			 * for now. We also clear corresponding bit in move_map
+			 * so that it doesn't confuse block_mover().
+			 */
+			b = ext2fs_block_bitmap_loc(fs, i);
+			if (b != bb_blk) {
+				ext2fs_mark_block_bitmap2(move_map, b);
+				ext2fs_block_bitmap_loc_set(fs, i, bb_blk);
+				new_loc[i].bb = b;
+				ext2fs_unmark_block_bitmap2(move_map, bb_blk);
+			}
+
+			b = ext2fs_inode_bitmap_loc(fs, i);
+			if (b != ib_blk) {
+				ext2fs_mark_block_bitmap2(move_map, b);
+				ext2fs_inode_bitmap_loc_set(fs, i, ib_blk);
+				new_loc[i].ib = b;
+				ext2fs_unmark_block_bitmap2(move_map, ib_blk);
+			}
+
+			new_table_loc = ext2fs_inode_table_loc(fs, i);
+			if (new_table_loc != table_loc) {
+				/*
+				 * Restore original inode table location. We
+				 * will move inode table after we make sure all
+				 * blocks are moved out of the way.
+				 */
+				ext2fs_inode_table_loc_set(fs, i, table_loc);
+				ext2fs_mark_block_bitmap_range2(g_meta_map,
+						table_loc,
+						fs->inode_blocks_per_group);
+				/*
+				 * Mark blocks that are used by the new inode
+				 * table and not by the old inode table as
+				 * needing to be moved.  Note that we clear all
+				 * blocks under the original inode table so
+				 * that block_mover() doesn't think it has to
+				 * move them. Blocks won't get used for
+				 * anything else since they are still marked as
+				 * used by the inode table.
+				 */
+				ext2fs_mark_block_bitmap_range2(move_map,
+						new_table_loc,
+						fs->inode_blocks_per_group);
+				ext2fs_unmark_block_bitmap_range2(move_map,
+						table_loc,
+						fs->inode_blocks_per_group);
+				new_loc[i].itable = new_table_loc;
+			}
+			ext2fs_group_desc_csum_set(fs, i);
+			ext2fs_mark_super_dirty(fs);
+		}
+
+		if (fs->progress_ops && fs->progress_ops->update)
+			fs->progress_ops->update(fs, &progress, i);
+	}
+	retval = 0;
+out_progress:
+	if (fs->progress_ops && fs->progress_ops->close)
+		fs->progress_ops->close(fs, &progress, NULL);
+out:
+	if (g_meta_map)
+		ext2fs_free_block_bitmap(g_meta_map);
+	ext2fs_free_mem(&buf);
+	return retval;
+}
+
+/*
+ * Move bitmaps and inode tables to new location described in new_loc. All
+ * blocks underlying new bitmap locations must be free, all blocks underlying
+ * new inode table location must be free or used by the inode table itself.
+ */
+static errcode_t finish_group_metadata_move(ext2_filsys fs,
+					    struct group_metadata_loc *new_loc)
+{
+	dgrp_t i;
+	errcode_t retval;
+	char *buf;
+
+	retval = ext2fs_get_array(fs->blocksize, fs->inode_blocks_per_group,
+				  &buf);
+	if (retval)
+		return retval;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		if (new_loc[i].itable) {
+			retval = relocate_inode_table(fs, i,
+					      ext2fs_inode_table_loc(fs, i),
+					      new_loc[i].itable, buf);
+			if (retval)
+				goto out;
+		}
+		if (new_loc[i].bb) {
+			relocate_bitmap(fs, i, ext2fs_block_bitmap_loc(fs, i),
+					new_loc[i].bb, 1);
+		}
+		if (new_loc[i].ib) {
+			relocate_bitmap(fs, i, ext2fs_inode_bitmap_loc(fs, i),
+					new_loc[i].ib, 0);
+		}
+		if (new_loc[i].itable || new_loc[i].bb || new_loc[i].ib) {
+			ext2fs_group_desc_csum_set(fs, i);
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+out:
+	/*
+	 * Flush everything so that changes to group descriptors get written
+	 * out and bitmaps get written to new locations.
+	 */
+	ext2fs_flush(fs);
+	ext2fs_free_mem(&buf);
+	return retval;
+}
+
+/*
+ *  Journal may have been relocated; update the backup journal blocks
+ *  in the superblock.
+ */
+static errcode_t fix_sb_journal_backup(ext2_filsys fs)
+{
+	errcode_t	  retval;
+	struct ext2_inode inode;
+
+	if (!(fs->super->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+		return 0;
+
+	/* External journal? Nothing to do. */
+	if (fs->super->s_journal_dev && !fs->super->s_journal_inum)
+		return 0;
+
+	retval = ext2fs_read_inode(fs, fs->super->s_journal_inum, &inode);
+	if (retval)
+		return retval;
+	memcpy(fs->super->s_jnl_blocks, inode.i_block, EXT2_N_BLOCKS*4);
+	fs->super->s_jnl_blocks[15] = inode.i_size_high;
+	fs->super->s_jnl_blocks[16] = inode.i_size;
+	fs->super->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
+	ext2fs_mark_super_dirty(fs);
+	return 0;
+}
+
+/*
+ * Generic block moving function. It moves blocks specified in move_map so that
+ * they become unused (it marks these blocks as free in the block bitmap). It
+ * takes care of moving block bitmaps, inode bitmaps, inode tables, xattr
+ * blocks, indirect blocks, data blocks, ... It also takes care of updating
+ * backup of journal blocks in the superblock. Blocks specified in reuse_map
+ * will be used only if there are no other blocks free.
+ *
+ * Subtle trap: resize2fs / tune2fs uses this function make space for group
+ * descriptor blocks. In memory structures are already updated however there
+ * isn't space on disk for new descriptor blocks yet. So we must be careful not
+ * to write descriptor blocks before we are done moving!
+ */
+errcode_t ext2fs_move_blocks(ext2_filsys fs, ext2fs_block_bitmap move_map,
+			     ext2fs_block_bitmap reuse_map)
+{
+	errcode_t retval;
+	ext2_map_extent bmap = NULL;
+	blk64_t blk;
+	blk64_t blks_to_move = 0, blks_free = 0;
+	struct group_metadata_loc *new_loc = NULL;
+	ext2fs_block_bitmap my_move_map = NULL;
+	ext2fs_block_bitmap cluster_bmap = NULL, new_cluster_bmap = NULL;
+
+	retval = ext2fs_read_bitmaps(fs);
+	if (retval)
+		goto out;
+
+	/* Cannot proceed without our allocation callback */
+	if (fs->get_alloc_block) {
+		retval = EINVAL;
+		goto out;
+	}
+
+	for (blk = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	     blk < ext2fs_blocks_count(fs->super);
+	     blk += EXT2FS_CLUSTER_RATIO(fs)) {
+		int used, move;
+
+		used = ext2fs_fast_test_block_bitmap2(fs->block_map, blk);
+		move = ext2fs_fast_test_block_bitmap2(move_map, blk);
+
+		if (!used && !move)
+			blks_free++;
+		else if (used && move)
+			blks_to_move++;
+	}
+
+	if (blks_free < blks_to_move) {
+		retval = ENOSPC;
+		goto out;
+	}
+
+	retval = ext2fs_get_arrayzero(fs->group_desc_count,
+				      sizeof(struct group_metadata_loc),
+				      &new_loc);
+	if (retval)
+		goto out;
+
+	/*
+	 * Create own copy of move_map so that we don't clobber the user
+	 * provided one
+	 */
+	retval = ext2fs_copy_bitmap(move_map, &my_move_map);
+	if (retval)
+		goto out;
+
+	if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		/*
+		 * For clustered allocation we cannot immediately tell which
+		 * clusters remain used and which become free since clusters
+		 * can be shared by different group metadata. We thus update
+		 * bitmaps only after all the metadata is relocated.
+		 */
+		retval = ext2fs_allocate_block_bitmap(fs, "cluster meta blocks",
+						      &cluster_bmap);
+		if (retval)
+			goto out;
+
+		retval = mark_table_blocks(fs, cluster_bmap);
+		if (retval)
+			goto out;
+	}
+
+	retval = ext2fs_move_group_metadata(fs, my_move_map, new_loc);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_create_extent_table(&bmap, 0);
+	if (retval)
+		goto out;
+
+	retval = block_mover(fs, my_move_map, reuse_map, bmap);
+	if (retval) {
+		/* block_mover() returns -1 if there's nothing to move */
+		if (retval != -1)
+			goto out;
+		retval = 0;
+	}
+
+	/*
+	 * Free our table now, it's not needed anymore and it frees some memory
+	 * for further processing
+	 */
+	if (my_move_map) {
+		ext2fs_free_block_bitmap(my_move_map);
+		my_move_map = NULL;
+	}
+
+	retval = fix_block_refs(fs, bmap);
+	if (retval)
+		goto out;
+
+	retval = fix_sb_journal_backup(fs);
+	if (retval)
+		goto out;
+
+	retval = finish_group_metadata_move(fs, new_loc);
+	if (retval)
+		goto out;
+
+	/*
+	 * For clustered allocation we now have to walk bitmaps and mark
+	 * clusters that got freed by group metadata relocation.
+	 */
+	if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		retval = ext2fs_allocate_block_bitmap(fs,
+						      "new cluster meta blocks",
+						      &new_cluster_bmap);
+		if (retval)
+			goto out;
+
+		retval = mark_table_blocks(fs, new_cluster_bmap);
+		if (retval)
+			goto out;
+
+		for (blk = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+		     blk < ext2fs_blocks_count(fs->super);
+		     blk += EXT2FS_CLUSTER_RATIO(fs)) {
+			if (ext2fs_test_block_bitmap2(cluster_bmap, blk) &&
+			    !ext2fs_test_block_bitmap2(new_cluster_bmap, blk))
+				ext2fs_block_alloc_stats2(fs, blk, -1);
+		}
+	}
+out:
+	if (bmap)
+		ext2fs_free_extent_table(bmap);
+	if (new_loc)
+		ext2fs_free_mem(&new_loc);
+	if (my_move_map)
+		ext2fs_free_block_bitmap(my_move_map);
+	if (new_cluster_bmap)
+		ext2fs_free_block_bitmap(new_cluster_bmap);
+	if (cluster_bmap)
+		ext2fs_free_block_bitmap(cluster_bmap);
+
+	return retval;
+}
diff --git a/lib/ext2fs/move.h b/lib/ext2fs/move.h
new file mode 100644
index 000000000000..730e6745eccf
--- /dev/null
+++ b/lib/ext2fs/move.h
@@ -0,0 +1,19 @@
+#ifndef _EXT2FS_MOVE_H
+#define _EXT2FS_MOVE_H
+
+#include "ext2fs.h"
+
+typedef struct _ext2_map_extent *ext2_map_extent;
+
+/* extent_map.c */
+extern int ext2fs_extent_table_empty(ext2_map_extent extent);
+extern errcode_t ext2fs_create_extent_table(ext2_map_extent *ret_extent,
+					    __u64 size);
+extern void ext2fs_free_extent_table(ext2_map_extent extent);
+extern errcode_t ext2fs_add_extent_entry(ext2_map_extent extent,
+					 __u64 old_loc, __u64 new_loc);
+extern __u64 ext2fs_extent_translate(ext2_map_extent extent, __u64 old_loc);
+extern errcode_t ext2fs_iterate_extent(ext2_map_extent extent, __u64 *old_loc,
+				       __u64 *new_loc, __u64 *size);
+
+#endif
-- 
2.1.4

