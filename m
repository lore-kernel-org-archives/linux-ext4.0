From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 35/47] resize2fs: convert fs to and from 64bit mode
Date: Fri, 07 Nov 2014 13:54:33 -0800
Message-ID: <20141107215433.883.51160.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46435 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaKGVyj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:54:39 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

resize2fs does its magic by loading a filesystem, duplicating the
in-memory image of that fs, moving relevant blocks out of the way of
whatever new metadata get created, and finally writing everything back
out to disk.  Enabling 64bit mode enlarges the group descriptors,
which makes resize2fs a reasonable vehicle for taking care of the rest
of the bookkeeping requirements, so add to resize2fs the ability to
convert a filesystem to 64bit mode and back.

v2: Fix a couple of minor resource leaks; make it more explicit to the
user what we're doing to the fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/tune2fs.c                   |    7 +
 resize/main.c                    |   60 ++++++
 resize/resize2fs.8.in            |   18 ++
 resize/resize2fs.c               |  362 ++++++++++++++++++++++++++++++++++++--
 resize/resize2fs.h               |    3 
 tests/t_enable_mcsum_ext3/expect |    1 
 6 files changed, 428 insertions(+), 23 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 1c83d09..da5030b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1121,6 +1121,13 @@ mmp_error:
 				 "cannot.  Not enabling extents reduces the "
 				 "coverage of metadata checksumming.  "
 				 "Re-run with -O extent to rectify.\n"));
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_INCOMPAT_64BIT))
+			printf("%s",
+			       _("64-bit filesystem support is not enabled.  "
+				 "The larger fields afforded by this feature "
+				 "enable full-strength checksumming.  "
+				 "Run resize2fs -b to rectify.\n"));
 		rewrite_checksums = 1;
 		/* metadata_csum supersedes uninit_bg */
 		fs->super->s_feature_ro_compat &=
diff --git a/resize/main.c b/resize/main.c
index e017792..f5cdab9 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -42,7 +42,7 @@ static char *device_name, *io_options;
 static void usage (char *prog)
 {
 	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
-			   "[-p] device [new_size]\n\n"), prog);
+			   "[-p] device [-b|-s|new_size]\n\n"), prog);
 
 	exit (1);
 }
@@ -203,7 +203,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
+	while ((c = getopt(argc, argv, "d:fFhMPpS:bs")) != EOF) {
 		switch (c) {
 		case 'h':
 			usage(program_name);
@@ -229,6 +229,12 @@ int main (int argc, char ** argv)
 		case 'S':
 			use_stride = atoi(optarg);
 			break;
+		case 'b':
+			flags |= RESIZE_ENABLE_64BIT;
+			break;
+		case 's':
+			flags |= RESIZE_DISABLE_64BIT;
+			break;
 		default:
 			usage(program_name);
 		}
@@ -393,6 +399,10 @@ int main (int argc, char ** argv)
 		if (sys_page_size > blocksize)
 			new_size &= ~((sys_page_size / blocksize)-1);
 	}
+	/* If changing 64bit, don't change the filesystem size. */
+	if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
+		new_size = ext2fs_blocks_count(fs->super);
+	}
 	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_INCOMPAT_64BIT)) {
 		/* Take 16T down to 2^32-1 blocks */
@@ -444,20 +454,58 @@ int main (int argc, char ** argv)
 			blocksize / 1024, new_size);
 		exit(1);
 	}
-	if (new_size == ext2fs_blocks_count(fs->super)) {
+	if ((flags & RESIZE_DISABLE_64BIT) && (flags & RESIZE_ENABLE_64BIT)) {
+		fprintf(stderr, _("Cannot set and unset 64bit feature.\n"));
+		exit(1);
+	} else if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
+		if (new_size >= (1ULL << 32)) {
+			fprintf(stderr, _("Cannot change the 64bit feature "
+				"on a filesystem that is larger than "
+				"2^32 blocks.\n"));
+			exit(1);
+		}
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fprintf(stderr, _("Cannot change the 64bit feature "
+				"while the filesystem is mounted.\n"));
+			exit(1);
+		}
+		if (flags & RESIZE_ENABLE_64BIT &&
+		    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+			fprintf(stderr, _("Please enable the extents feature "
+				"with tune2fs before enabling the 64bit "
+				"feature.\n"));
+			exit(1);
+		}
+	} else if (new_size == ext2fs_blocks_count(fs->super)) {
 		fprintf(stderr, _("The filesystem is already %llu (%dk) "
 			"blocks long.  Nothing to do!\n\n"), new_size,
 			blocksize / 1024);
 		exit(0);
 	}
+	if ((flags & RESIZE_ENABLE_64BIT) &&
+	    EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)) {
+		fprintf(stderr, _("The filesystem is already 64-bit.\n"));
+		exit(0);
+	}
+	if ((flags & RESIZE_DISABLE_64BIT) &&
+	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)) {
+		fprintf(stderr, _("The filesystem is already 32-bit.\n"));
+		exit(0);
+	}
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		bigalloc_check(fs, force);
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
 		bigalloc_check(fs, force);
-		printf(_("Resizing the filesystem on "
-			 "%s to %llu (%dk) blocks.\n"),
-		       device_name, new_size, blocksize / 1024);
+		if (flags & RESIZE_ENABLE_64BIT)
+			printf(_("Converting the filesystem to 64-bit.\n"));
+		else if (flags & RESIZE_DISABLE_64BIT)
+			printf(_("Converting the filesystem to 32-bit.\n"));
+		else
+			printf(_("Resizing the filesystem on "
+				 "%s to %llu (%dk) blocks.\n"),
+			       device_name, new_size, blocksize / 1024);
 		retval = resize_fs(fs, &new_size, flags,
 				   ((flags & RESIZE_PERCENT_COMPLETE) ?
 				    resize_progress_func : 0));
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 86495c6..0129bfc 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -8,7 +8,7 @@ resize2fs \- ext2/ext3/ext4 file system resizer
 .SH SYNOPSIS
 .B resize2fs
 [
-.B \-fFpPM
+.B \-fFpPMbs
 ]
 [
 .B \-d
@@ -86,8 +86,21 @@ to shrink the size of filesystem.  Then you may use
 to shrink the size of the partition.  When shrinking the size of
 the partition, make sure you do not make it smaller than the new size
 of the ext2 filesystem!
+.PP
+The
+.B \-b
+and
+.B \-s
+options enable and disable the 64bit feature, respectively.  The resize2fs
+program will, of course, take care of resizing the block group descriptors
+and moving other data blocks out of the way, as needed.  It is not possible
+to resize the filesystem concurrent with changing the 64bit status.
 .SH OPTIONS
 .TP
+.B \-b
+Turns on the 64bit feature, resizes the group descriptors as necessary, and
+moves other metadata out of the way.
+.TP
 .B \-d \fIdebug-flags
 Turns on various resize2fs debugging features, if they have been compiled
 into the binary.
@@ -127,6 +140,9 @@ of what the program is doing.
 .B \-P
 Print the minimum size of the filesystem and exit.
 .TP
+.B \-s
+Turns off the 64bit feature and frees blocks that are no longer in use.
+.TP
 .B \-S \fIRAID-stride
 The
 .B resize2fs
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0d1f7fa..0787c8a 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -56,6 +56,9 @@ static errcode_t mark_table_blocks(ext2_filsys fs,
 static errcode_t clear_sparse_super2_last_group(ext2_resize_t rfs);
 static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 						 ext2fs_block_bitmap meta_bmap);
+static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size);
+static errcode_t move_bg_metadata(ext2_resize_t rfs);
+static errcode_t zero_high_bits_in_inodes(ext2_resize_t rfs);
 
 /*
  * Some helper CPP macros
@@ -122,13 +125,30 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
+	init_resource_track(&rtrack, "resize_group_descriptors", fs->io);
+	retval = resize_group_descriptors(rfs, *new_size);
+	if (retval)
+		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
+
+	init_resource_track(&rtrack, "move_bg_metadata", fs->io);
+	retval = move_bg_metadata(rfs);
+	if (retval)
+		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
+
+	init_resource_track(&rtrack, "zero_high_bits_in_metadata", fs->io);
+	retval = zero_high_bits_in_inodes(rfs);
+	if (retval)
+		goto errout;
+	print_resource_track(rfs, &rtrack, fs->io);
+
 	init_resource_track(&rtrack, "adjust_superblock", fs->io);
 	retval = adjust_superblock(rfs, *new_size);
 	if (retval)
 		goto errout;
 	print_resource_track(rfs, &rtrack, fs->io);
 
-
 	init_resource_track(&rtrack, "fix_uninit_block_bitmaps 2", fs->io);
 	fix_uninit_block_bitmaps(rfs->new_fs);
 	print_resource_track(rfs, &rtrack, fs->io);
@@ -235,6 +255,322 @@ errout:
 	return retval;
 }
 
+/* Keep the size of the group descriptor region constant */
+static void adjust_reserved_gdt_blocks(ext2_filsys old_fs, ext2_filsys fs)
+{
+	if ((fs->super->s_feature_compat &
+	     EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+	    (old_fs->desc_blocks != fs->desc_blocks)) {
+		int new;
+
+		new = ((int) fs->super->s_reserved_gdt_blocks) +
+			(old_fs->desc_blocks - fs->desc_blocks);
+		if (new < 0)
+			new = 0;
+		if (new > (int) fs->blocksize/4)
+			new = fs->blocksize/4;
+		fs->super->s_reserved_gdt_blocks = new;
+	}
+}
+
+/* Toggle 64bit mode */
+static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
+{
+	void *o, *n, *new_group_desc;
+	dgrp_t i;
+	int copy_size;
+	errcode_t retval;
+
+	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
+		return 0;
+
+	if (new_size != ext2fs_blocks_count(rfs->new_fs->super) ||
+	    ext2fs_blocks_count(rfs->new_fs->super) >= (1ULL << 32) ||
+	    (rfs->flags & RESIZE_DISABLE_64BIT &&
+	     rfs->flags & RESIZE_ENABLE_64BIT))
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	if (rfs->flags & RESIZE_DISABLE_64BIT) {
+		rfs->new_fs->super->s_feature_incompat &=
+				~EXT4_FEATURE_INCOMPAT_64BIT;
+		rfs->new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE;
+	} else if (rfs->flags & RESIZE_ENABLE_64BIT) {
+		rfs->new_fs->super->s_feature_incompat |=
+				EXT4_FEATURE_INCOMPAT_64BIT;
+		rfs->new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
+	}
+
+	if (EXT2_DESC_SIZE(rfs->old_fs->super) ==
+	    EXT2_DESC_SIZE(rfs->new_fs->super))
+		return 0;
+
+	o = rfs->new_fs->group_desc;
+	rfs->new_fs->desc_blocks = ext2fs_div_ceil(
+			rfs->old_fs->group_desc_count,
+			EXT2_DESC_PER_BLOCK(rfs->new_fs->super));
+	retval = ext2fs_get_arrayzero(rfs->new_fs->desc_blocks,
+				      rfs->old_fs->blocksize, &new_group_desc);
+	if (retval)
+		return retval;
+
+	n = new_group_desc;
+
+	if (EXT2_DESC_SIZE(rfs->old_fs->super) <=
+	    EXT2_DESC_SIZE(rfs->new_fs->super))
+		copy_size = EXT2_DESC_SIZE(rfs->old_fs->super);
+	else
+		copy_size = EXT2_DESC_SIZE(rfs->new_fs->super);
+	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
+		memcpy(n, o, copy_size);
+		n += EXT2_DESC_SIZE(rfs->new_fs->super);
+		o += EXT2_DESC_SIZE(rfs->old_fs->super);
+	}
+
+	ext2fs_free_mem(&rfs->new_fs->group_desc);
+	rfs->new_fs->group_desc = new_group_desc;
+
+	for (i = 0; i < rfs->old_fs->group_desc_count; i++)
+		ext2fs_group_desc_csum_set(rfs->new_fs, i);
+
+	adjust_reserved_gdt_blocks(rfs->old_fs, rfs->new_fs);
+
+	return 0;
+}
+
+/* Move bitmaps/inode tables out of the way. */
+static errcode_t move_bg_metadata(ext2_resize_t rfs)
+{
+	dgrp_t i;
+	blk64_t b, c, d, old_desc_blocks, new_desc_blocks, j;
+	ext2fs_block_bitmap old_map, new_map;
+	int old, new;
+	errcode_t retval;
+	int cluster_ratio;
+
+	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
+		return 0;
+
+	retval = ext2fs_allocate_block_bitmap(rfs->old_fs, "oldfs", &old_map);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_allocate_block_bitmap(rfs->new_fs, "newfs", &new_map);
+	if (retval)
+		goto out;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(rfs->old_fs->super,
+				      EXT2_FEATURE_INCOMPAT_META_BG)) {
+		old_desc_blocks = rfs->old_fs->super->s_first_meta_bg;
+		new_desc_blocks = rfs->new_fs->super->s_first_meta_bg;
+	} else {
+		old_desc_blocks = rfs->old_fs->desc_blocks +
+				rfs->old_fs->super->s_reserved_gdt_blocks;
+		new_desc_blocks = rfs->new_fs->desc_blocks +
+				rfs->new_fs->super->s_reserved_gdt_blocks;
+	}
+
+	/* Construct bitmaps of super/descriptor blocks in old and new fs */
+	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
+		retval = ext2fs_super_and_bgd_loc2(rfs->old_fs, i, &b, &c, &d,
+						   NULL);
+		if (retval)
+			goto out;
+		if (b)
+			ext2fs_mark_block_bitmap2(old_map, b);
+		for (j = 0; c != 0 && j < old_desc_blocks; j++)
+			ext2fs_mark_block_bitmap2(old_map, c + j);
+		if (d)
+			ext2fs_mark_block_bitmap2(old_map, d);
+
+		retval = ext2fs_super_and_bgd_loc2(rfs->new_fs, i, &b, &c, &d,
+						   NULL);
+		if (retval)
+			goto out;
+		if (b)
+			ext2fs_mark_block_bitmap2(new_map, b);
+		for (j = 0; c != 0 && j < new_desc_blocks; j++)
+			ext2fs_mark_block_bitmap2(new_map, c + j);
+		if (d)
+			ext2fs_mark_block_bitmap2(new_map, d);
+	}
+
+	cluster_ratio = EXT2FS_CLUSTER_RATIO(rfs->new_fs);
+
+	/* Find changes in block allocations for bg metadata */
+	for (b = EXT2FS_B2C(rfs->old_fs,
+			    rfs->old_fs->super->s_first_data_block);
+	     b < ext2fs_blocks_count(rfs->new_fs->super);
+	     b += cluster_ratio) {
+		old = ext2fs_test_block_bitmap2(old_map, b);
+		new = ext2fs_test_block_bitmap2(new_map, b);
+
+		if (old && !new) {
+			/* mark old_map, unmark new_map */
+			if (cluster_ratio == 1)
+				ext2fs_unmark_block_bitmap2(
+						rfs->new_fs->block_map, b);
+		} else if (!old && new)
+			; /* unmark old_map, mark new_map */
+		else {
+			ext2fs_unmark_block_bitmap2(old_map, b);
+			ext2fs_unmark_block_bitmap2(new_map, b);
+		}
+	}
+
+	/*
+	 * new_map now shows blocks that have been newly allocated.
+	 * old_map now shows blocks that have been newly freed.
+	 */
+
+	/*
+	 * Move any conflicting bitmaps and inode tables.  Ensure that we
+	 * don't try to free clusters associated with bitmaps or tables.
+	 */
+	for (i = 0; i < rfs->old_fs->group_desc_count; i++) {
+		b = ext2fs_block_bitmap_loc(rfs->new_fs, i);
+		if (ext2fs_test_block_bitmap2(new_map, b))
+			ext2fs_block_bitmap_loc_set(rfs->new_fs, i, 0);
+		else if (ext2fs_test_block_bitmap2(old_map, b))
+			ext2fs_unmark_block_bitmap2(old_map, b);
+
+		b = ext2fs_inode_bitmap_loc(rfs->new_fs, i);
+		if (ext2fs_test_block_bitmap2(new_map, b))
+			ext2fs_inode_bitmap_loc_set(rfs->new_fs, i, 0);
+		else if (ext2fs_test_block_bitmap2(old_map, b))
+			ext2fs_unmark_block_bitmap2(old_map, b);
+
+		c = ext2fs_inode_table_loc(rfs->new_fs, i);
+		for (b = 0;
+		     b < rfs->new_fs->inode_blocks_per_group;
+		     b++) {
+			if (ext2fs_test_block_bitmap2(new_map, b + c))
+				ext2fs_inode_table_loc_set(rfs->new_fs, i, 0);
+			else if (ext2fs_test_block_bitmap2(old_map, b + c))
+				ext2fs_unmark_block_bitmap2(old_map, b + c);
+		}
+	}
+
+	/* Free unused clusters */
+	for (b = 0;
+	     cluster_ratio > 1 && b < ext2fs_blocks_count(rfs->new_fs->super);
+	     b += cluster_ratio)
+		if (ext2fs_test_block_bitmap2(old_map, b))
+			ext2fs_unmark_block_bitmap2(rfs->new_fs->block_map, b);
+out:
+	if (old_map)
+		ext2fs_free_block_bitmap(old_map);
+	if (new_map)
+		ext2fs_free_block_bitmap(new_map);
+	return retval;
+}
+
+/* Zero out the high bits of extent fields */
+static errcode_t zero_high_bits_in_extents(ext2_filsys fs, ext2_ino_t ino,
+				 struct ext2_inode *inode)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	int			op = EXT2_EXTENT_ROOT;
+	errcode_t		errcode;
+
+	if (!(inode->i_flags & EXT4_EXTENTS_FL))
+		return 0;
+
+	errcode = ext2fs_extent_open(fs, ino, &handle);
+	if (errcode)
+		return errcode;
+
+	while (1) {
+		errcode = ext2fs_extent_get(handle, op, &extent);
+		if (errcode)
+			break;
+
+		op = EXT2_EXTENT_NEXT_SIB;
+
+		if (extent.e_pblk > (1ULL << 32)) {
+			extent.e_pblk &= (1ULL << 32) - 1;
+			errcode = ext2fs_extent_replace(handle, 0, &extent);
+			if (errcode)
+				break;
+		}
+	}
+
+	/* Ok if we run off the end */
+	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
+		errcode = 0;
+	ext2fs_extent_free(handle);
+	return errcode;
+}
+
+/* Zero out the high bits of inodes. */
+static errcode_t zero_high_bits_in_inodes(ext2_resize_t rfs)
+{
+	ext2_filsys	fs = rfs->old_fs;
+	int length = EXT2_INODE_SIZE(fs->super);
+	struct ext2_inode *inode = NULL;
+	ext2_inode_scan	scan = NULL;
+	errcode_t	retval;
+	ext2_ino_t	ino;
+
+	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
+		return 0;
+
+	if (fs->super->s_creator_os != EXT2_OS_LINUX)
+		return 0;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_get_mem(length, &inode);
+	if (retval)
+		goto out;
+
+	do {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
+		if (retval)
+			goto out;
+		if (!ino)
+			break;
+		if (!ext2fs_test_inode_bitmap2(fs->inode_map, ino))
+			continue;
+
+		/*
+		 * Here's how we deal with high block number fields:
+		 *
+		 *  - i_size_high has been been written out with i_size_lo
+		 *    since the ext2 days, so no conversion is needed.
+		 *
+		 *  - i_blocks_hi is guarded by both the huge_file feature and
+		 *    inode flags and has always been written out with
+		 *    i_blocks_lo if the feature is set.  The field is only
+		 *    ever read if both feature and inode flag are set, so
+		 *    we don't need to zero it now.
+		 *
+		 *  - i_file_acl_high can be uninitialized, so zero it if
+		 *    it isn't already.
+		 */
+		if (inode->osd2.linux2.l_i_file_acl_high) {
+			inode->osd2.linux2.l_i_file_acl_high = 0;
+			retval = ext2fs_write_inode_full(fs, ino, inode,
+							 length);
+			if (retval)
+				goto out;
+		}
+
+		retval = zero_high_bits_in_extents(fs, ino, inode);
+		if (retval)
+			goto out;
+	} while (ino);
+
+out:
+	if (inode)
+		ext2fs_free_mem(&inode);
+	if (scan)
+		ext2fs_close_inode_scan(scan);
+	return retval;
+}
+
 /*
  * Clean up the bitmaps for unitialized bitmaps
  */
@@ -459,7 +795,8 @@ retry:
 	/*
 	 * Reallocate the group descriptors as necessary.
 	 */
-	if (old_fs->desc_blocks != fs->desc_blocks) {
+	if (EXT2_DESC_SIZE(old_fs->super) == EXT2_DESC_SIZE(fs->super) &&
+	    old_fs->desc_blocks != fs->desc_blocks) {
 		retval = ext2fs_resize_mem(old_fs->desc_blocks *
 					   fs->blocksize,
 					   fs->desc_blocks * fs->blocksize,
@@ -478,20 +815,11 @@ retry:
 	 * number of descriptor blocks, then adjust
 	 * s_reserved_gdt_blocks if possible to avoid needing to move
 	 * the inode table either now or in the future.
+	 *
+	 * Note: If we're converting to 64bit mode, we did this earlier.
 	 */
-	if ((fs->super->s_feature_compat &
-	     EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
-	    (old_fs->desc_blocks != fs->desc_blocks)) {
-		int new;
-
-		new = ((int) fs->super->s_reserved_gdt_blocks) +
-			(old_fs->desc_blocks - fs->desc_blocks);
-		if (new < 0)
-			new = 0;
-		if (new > (int) fs->blocksize/4)
-			new = fs->blocksize/4;
-		fs->super->s_reserved_gdt_blocks = new;
-	}
+	if (EXT2_DESC_SIZE(old_fs->super) == EXT2_DESC_SIZE(fs->super))
+		adjust_reserved_gdt_blocks(old_fs, fs);
 
 	if ((fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
 	    (fs->super->s_first_meta_bg > fs->desc_blocks)) {
@@ -1019,7 +1347,9 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	if (retval)
 		goto errout;
 
-	if (old_blocks == new_blocks) {
+	if (EXT2_DESC_SIZE(rfs->old_fs->super) ==
+	    EXT2_DESC_SIZE(rfs->new_fs->super) &&
+	    old_blocks == new_blocks) {
 		retval = 0;
 		goto errout;
 	}
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 7aeab91..829fcd8 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -82,6 +82,9 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
 
+#define RESIZE_ENABLE_64BIT		0x0400
+#define RESIZE_DISABLE_64BIT		0x0800
+
 /*
  * This structure is used for keeping track of how much resources have
  * been used for a particular resize2fs pass.
diff --git a/tests/t_enable_mcsum_ext3/expect b/tests/t_enable_mcsum_ext3/expect
index 1e005bd..5460482 100644
--- a/tests/t_enable_mcsum_ext3/expect
+++ b/tests/t_enable_mcsum_ext3/expect
@@ -18,6 +18,7 @@ Pass 5: Checking group summary information
 Exit status is 0
 tune2fs -O metadata_csum test.img
 Extents are not enabled.  The file extent tree can be checksummed, whereas block maps cannot.  Not enabling extents reduces the coverage of metadata checksumming.  Re-run with -O extent to rectify.
+64-bit filesystem support is not enabled.  The larger fields afforded by this feature enable full-strength checksumming.  Run resize2fs -b to rectify.
 Exit status is 0
 
 Change in FS metadata:

