From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] resize2fs: Add options to print (and resizing to) the minimum filesystem size
Date: Sat, 15 Mar 2008 01:15:33 -0400
Message-ID: <1205558133-27714-1-git-send-email-tytso@mit.edu>
References: <20080315030840.GG13733@mit.edu>
Cc: linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54626 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750730AbYCOFPk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 01:15:40 -0400
In-Reply-To: <20080315030840.GG13733@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

Add the -P option to print the minimum filesystem size and exit.

Add the -M option to force resizing the filesystem to the minimum
filesystem size.

Signed-off-by: Josef Back <jbacik@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c         |   29 +++++++---
 resize/resize2fs.8.in |   47 +++++++++--------
 resize/resize2fs.c    |  140 ++++++++++++++++++++++++++++++++++++++++++++++++-
 resize/resize2fs.h    |    1 +
 4 files changed, 185 insertions(+), 32 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index f283e41..0cdda32 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -36,8 +36,8 @@ char *program_name, *device_name, *io_options;
 
 static void usage (char *prog)
 {
-	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-p] "
-			   "device [new_size]\n\n"), prog);
+	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
+			   "[-p] device [new_size]\n\n"), prog);
 
 	exit (1);
 }
@@ -152,6 +152,8 @@ int main (int argc, char ** argv)
 	int		flush = 0;
 	int		force = 0;
 	int		io_flags = 0;
+	int		force_min_size = 0;
+	int		print_min_size = 0;
 	int		fd, ret;
 	blk_t		new_size = 0;
 	blk_t		max_size = 0;
@@ -183,7 +185,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt (argc, argv, "d:fFhpS:")) != EOF) {
+	while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
 		switch (c) {
 		case 'h':
 			usage(program_name);
@@ -194,6 +196,12 @@ int main (int argc, char ** argv)
 		case 'F':
 			flush = 1;
 			break;
+		case 'M':
+			force_min_size = 1;
+			break;
+		case 'P':
+			print_min_size = 1;
+			break;
 		case 'd':
 			flags |= atoi(optarg);
 			break;
@@ -308,6 +316,12 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 	
+	if (print_min_size) {
+		printf("Estimated minimum size of the filesystem: %lu\n",
+		       calculate_minimum_resize_size(fs));
+		exit(0);
+	}
+
 	/* Determine the system page size if possible */
 #ifdef HAVE_SYSCONF
 #if (!defined(_SC_PAGESIZE) && defined(_SC_PAGE_SIZE))
@@ -332,14 +346,11 @@ int main (int argc, char ** argv)
 			_("while trying to determine filesystem size"));
 		exit(1);
 	}
-	if (new_size_str) {
+	if (force_min_size)
+		new_size = calculate_minimum_resize_size(fs);
+	else if (new_size_str) {
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
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index d43adad..7be4f04 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -8,6 +8,9 @@ resize2fs \- ext2/ext3 file system resizer
 .SH SYNOPSIS
 .B resize2fs
 [
+.B \-fFpPM
+]
+[
 .B \-d 
 .I debug-flags
 ]
@@ -15,15 +18,6 @@ resize2fs \- ext2/ext3 file system resizer
 .B \-S
 .I RAID-stride
 ]
-[
-.B \-f
-]
-[
-.B \-F
-]
-[
-.B \-p
-]
 .I device
 [
 .I size
@@ -99,19 +93,6 @@ from the following list:
 \	8\	\-\ Debug inode relocations
 .br
 \	16\	\-\ Debug moving the inode table
-.TP
-.B \-S \fIRAID-stride
-The 
-.B resize2fs
-program will heuristically determine the RAID stride that was specified 
-when the filesystem was created.  This option allows the user to 
-explicitly specify a RAID stride setting to be used by resize2fs instead.
-.TP
-.B \-p
-Prints out a percentage completion bars for each 
-.B resize2fs
-operation, so that the user can keep track of what
-the program is doing.
 .TP 
 .B \-f
 Forces resize2fs to proceed with the filesystem resize operation, overriding 
@@ -122,6 +103,28 @@ Flush the filesystem device's buffer caches before beginning.  Only
 really useful for doing 
 .B resize2fs
 time trials.
+.TP
+.B \-M
+Shrink the filesystem to the minimum size.
+.TP
+.B \-p
+Prints out a percentage completion bars for each 
+.B resize2fs
+operation, so that the user can keep track of what
+the program is doing.
+.TP
+.B \-P
+Print the minimum size of the filesystem and exit.
+.TP
+.B \-S \fIRAID-stride
+The 
+.B resize2fs
+program will heuristically determine the RAID stride that was specified 
+when the filesystem was created.  This option allows the user to 
+explicitly specify a RAID stride setting to be used by resize2fs instead.
+.SH KNOWN BUGS
+The minimum size of the filesystem as estimated by resize2fs may be
+incorrect, especially for filesystems with 1k and 2k blocksizes.
 .SH AUTHOR
 .B resize2fs
 was written by Theodore Ts'o <tytso@mit.edu>.
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index da86ece..08dd413 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -63,7 +63,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
 				 ((blk) < (FS_INODE_TB((fs), (i)) + \
 					   (fs)->inode_blocks_per_group)))
 
-
+#define META_OVERHEAD(fs) (2 + (fs)->inode_blocks_per_group)
+#define SUPER_OVERHEAD(fs) (1 + (fs)->desc_blocks +\
+			    (fs)->super->s_reserved_gdt_blocks)
 
 /*
  * This is the top-level routine which does the dirty deed....
@@ -1620,3 +1622,139 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
+
+/*
+ * calcluate the minimum number of blocks the given fs can be resized to
+ */
+blk_t calculate_minimum_resize_size(ext2_filsys fs)
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
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index f87d04e..49b77d8 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -129,6 +129,7 @@ extern errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 
 extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs, 
 				blk_t new_size);
+extern blk_t calculate_minimum_resize_size(ext2_filsys fs);
 
 
 /* extent.c */
-- 
1.5.4.1.144.gdfee-dirty

