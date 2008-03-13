From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH RESEND] e2fsprogs: reprot minimal resize size when given
	size is too small
Date: Thu, 13 Mar 2008 13:46:10 -0400
Message-ID: <20080313174610.GF21187@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYCMRsS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 13:48:18 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This is a resend of a patch I sent a few months ago that hasn't gotten picked up
yet.  This will spit out the correctly calculated minimal number of blocks the
given fs can be resized to if the given resize size is too small.  This is
useful for creating images, you can do the install and then resize the image to
the smallest possible size.  Thank you,

Josef


diff --git a/resize/main.c b/resize/main.c
index 7c1d0c1..a9653ee 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -342,11 +342,6 @@ int main (int argc, char ** argv)
 	if (new_size_str) {
 		new_size = parse_num_blocks(new_size_str, 
 					    fs->super->s_log_block_size);
-		if (!new_size) {
-			com_err(program_name, 0, _("bad filesystem size - %s"),
-				new_size_str);
-			exit(1);
-		}
 	} else {
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 9959671..e2a8fcc 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -48,6 +48,7 @@ static errcode_t inode_ref_fix(ext2_resize_t rfs);
 static errcode_t move_itables(ext2_resize_t rfs);
 static errcode_t fix_resize_inode(ext2_filsys fs);
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
+static blk_t ext2fs_calculate_minimum_resize_size(ext2_filsys fs);
 
 /*
  * Some helper CPP macros
@@ -63,7 +64,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
 				 ((blk) < (FS_INODE_TB((fs), (i)) + \
 					   (fs)->inode_blocks_per_group)))
 
-
+#define META_OVERHEAD(fs) (2 + (fs)->inode_blocks_per_group)
+#define SUPER_OVERHEAD(fs) (1 + (fs)->desc_blocks +\
+			    (fs)->super->s_reserved_gdt_blocks)
 
 /*
  * This is the top-level routine which does the dirty deed....
@@ -75,11 +78,19 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 {
 	ext2_resize_t	rfs;
 	errcode_t	retval;
+	blk_t		min_size = 0;
 
 	retval = ext2fs_read_bitmaps(fs);
 	if (retval)
 		return retval;
 	
+	min_size = ext2fs_calculate_minimum_resize_size(fs);
+	if (min_size > *new_size) {
+		printf("%u blocks is too small, minimum size is %u blocks\n",
+		       *new_size, min_size);
+		return EXT2_ET_TOOSMALL;
+	}
+
 	/*
 	 * Create the data structure
 	 */
@@ -1628,3 +1639,139 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
+
+/*
+ * calcluate the minimum number of blocks the given fs can be resized to
+ */
+static blk_t ext2fs_calculate_minimum_resize_size(ext2_filsys fs)
+{
+	blk_t inode_count, blks_needed, groups, blk, data_blocks;
+	blk_t grp, data_needed, last_start;
+	int overhead = 0, old_group = -1, num_of_superblocks = 0;
+
+	/*
+	 * first figure out how many group descriptors we need to
+	 * handle the number of inodes we have
+	 */
+	inode_count = fs->super->s_inodes_count -
+		fs->super->s_free_inodes_count;
+	blks_needed = ext2fs_div_ceil(inode_count,
+				      fs->super->s_inodes_per_group) *
+		EXT2_BLOCKS_PER_GROUP(fs->super);
+	groups = ext2fs_div_ceil(blks_needed,
+				 EXT2_BLOCKS_PER_GROUP(fs->super));
+
+	/*
+	 * we need to figure out how many backup superblocks we have so we can
+	 * account for that in the metadata
+	 */
+	for (grp = 0; grp < fs->group_desc_count; grp++) {
+		if (ext2fs_bg_has_super(fs, grp))
+			num_of_superblocks++;
+	}
+
+	/* calculate how many blocks are needed for data */
+	data_needed = fs->super->s_blocks_count -
+		fs->super->s_free_blocks_count;
+	data_needed -= SUPER_OVERHEAD(fs) * num_of_superblocks;
+	data_needed -= META_OVERHEAD(fs) * fs->group_desc_count;
+
+	/*
+	 * figure out how many data blocks we have given the number of groups
+	 * we need for our inodes
+	 */
+	data_blocks = groups * EXT2_BLOCKS_PER_GROUP(fs->super);
+	last_start = 0;
+	for (grp = 0; grp < groups; grp++) {
+		overhead = META_OVERHEAD(fs);
+
+		if (ext2fs_bg_has_super(fs, grp))
+			overhead += SUPER_OVERHEAD(fs);
+
+		/*
+		 * we want to keep track of how much data we can store in
+		 * the groups leading up to the last group so we can determine
+		 * how big the last group needs to be
+		 */
+		if (grp != (groups - 1))
+			last_start += EXT2_BLOCKS_PER_GROUP(fs->super) -
+				overhead;
+
+		data_blocks -= overhead;
+	}
+
+	/*
+	 * if we need more group descriptors in order to accomodate our data
+	 * then we need to add them here
+	 */
+	while (data_needed > data_blocks) {
+		blk_t remainder = data_needed - data_blocks;
+		blk_t extra_grps;
+
+		/* figure out how many more groups we need for the data */
+		extra_grps = ext2fs_div_ceil(remainder,
+					     EXT2_BLOCKS_PER_GROUP(fs->super));
+
+		data_blocks += extra_grps * EXT2_BLOCKS_PER_GROUP(fs->super);
+
+		/* ok we have to account for the last group */
+		overhead = META_OVERHEAD(fs);
+		if (ext2fs_bg_has_super(fs, groups-1))
+			overhead += SUPER_OVERHEAD(fs);
+		last_start += EXT2_BLOCKS_PER_GROUP(fs->super) - overhead;
+
+		for (grp = groups; grp < groups+extra_grps; grp++) {
+			overhead = META_OVERHEAD(fs);
+			if (ext2fs_bg_has_super(fs, grp))
+				overhead += SUPER_OVERHEAD(fs);
+
+			/*
+			 * again, we need to see how much data we cram into
+			 * all of the groups leading up to the last group
+			 */
+			if (grp != (groups + extra_grps - 1))
+				last_start += EXT2_BLOCKS_PER_GROUP(fs->super)
+					- overhead;
+
+			data_blocks -= overhead;
+		}
+
+		groups += extra_grps;
+	}
+
+	/* now for the fun voodoo */
+	overhead = META_OVERHEAD(fs);
+
+	/*
+	 * if this is the case then the last group is going to have data in it
+	 * so we need to adjust the size of the last group accordingly
+	 */
+	if (last_start < data_needed) {
+		blk_t remainder = data_needed - last_start;
+
+		/*
+		 * 50 is a magic number that mkfs/resize uses to see if its
+		 * even worth making/resizing the fs.  basically you need to
+		 * have at least 50 blocks in addition to the blocks needed
+		 * for the metadata in the last group
+		 */
+		if (remainder > 50)
+			overhead += remainder;
+		else
+			overhead += 50;
+	} else
+		overhead += 50;
+
+	if (ext2fs_bg_has_super(fs, groups-1))
+		overhead += SUPER_OVERHEAD(fs);
+
+	/*
+	 * since our last group doesn't have to be BLOCKS_PER_GROUP large, we
+	 * only do groups-1, and then add the number of blocks needed to
+	 * handle the group descriptor metadata+data that we need
+	 */
+	blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
+	blks_needed += overhead;
+
+	return blks_needed;
+}
