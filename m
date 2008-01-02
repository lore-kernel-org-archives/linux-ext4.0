From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] e2fsprogs: add minimal resize size option
Date: Wed, 2 Jan 2008 15:16:59 -0500
Message-ID: <20080102201659.GI31745@dhcp243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYABU16 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2008 15:27:58 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m02KRv4h010001
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jan 2008 15:27:57 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m02KRvSv018702
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jan 2008 15:27:57 -0500
Received: from dhcp243-37.rdu.redhat.com (dhcp243-37.rdu.redhat.com [10.11.243.37])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m02KRvgG001196
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jan 2008 15:27:57 -0500
Received: from dhcp243-37.rdu.redhat.com (localhost.localdomain [127.0.0.1])
	by dhcp243-37.rdu.redhat.com (8.14.1/8.14.1) with ESMTP id m02KGxSn001850
	for <linux-ext4@vger.kernel.org>; Wed, 2 Jan 2008 15:16:59 -0500
Received: (from jwhiter@localhost)
	by dhcp243-37.rdu.redhat.com (8.14.1/8.14.1/Submit) id m02KGxxx001849
	for linux-ext4@vger.kernel.org; Wed, 2 Jan 2008 15:16:59 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

People wishing to make live usb disks and such are looking for a way to get the
minimum resize size for an ext fs in blocks so that they can just resize their
image to that size and do with it what they will.  This patch adds that
functionality, just pass -m option and it calculates the minimum number of
blocks the fs can be resized to.  Comments welcome, I was learning the ext disk
layout while writing this so if I've done something stupid/overly complicated
please point it out :), I've commented abundantly so hopefully my madness will
make sense.  Thank you,

Josef


diff --git a/resize/main.c b/resize/main.c
index 7c1d0c1..2f2887a 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -36,7 +36,7 @@ char *program_name, *device_name, *io_options;
 
 static void usage (char *prog)
 {
-	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-p] "
+	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-m] [-p] "
 			   "device [new_size]\n\n"), prog);
 
 	exit (1);
@@ -183,7 +183,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt (argc, argv, "d:fFhpS:")) != EOF) {
+	while ((c = getopt (argc, argv, "d:fFhmpS:")) != EOF) {
 		switch (c) {
 		case 'h':
 			usage(program_name);
@@ -197,6 +197,9 @@ int main (int argc, char ** argv)
 		case 'd':
 			flags |= atoi(optarg);
 			break;
+		case 'm':
+			flags |= RESIZE_BLOCKS_NEEDED_ONLY;
+			break;
 		case 'p':
 			flags |= RESIZE_PERCENT_COMPLETE;
 			break;
@@ -340,6 +343,13 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 	if (new_size_str) {
+		if (flags & RESIZE_BLOCKS_NEEDED_ONLY) {
+			com_err(program_name, 0,
+				"specifying a new size when asking for "
+				"minimal size");
+			exit(1);
+		}
+
 		new_size = parse_num_blocks(new_size_str, 
 					    fs->super->s_log_block_size);
 		if (!new_size) {
@@ -347,7 +357,7 @@ int main (int argc, char ** argv)
 				new_size_str);
 			exit(1);
 		}
-	} else {
+	} else if (!(flags & RESIZE_BLOCKS_NEEDED_ONLY)) {
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
 		if (sys_page_size > fs->blocksize)
@@ -392,7 +402,8 @@ int main (int argc, char ** argv)
 			"long.  Nothing to do!\n\n"), new_size);
 		exit(0);
 	}
-	if (mount_flags & EXT2_MF_MOUNTED) {
+	if ((mount_flags & EXT2_MF_MOUNTED) &&
+	    !(flags & RESIZE_BLOCKS_NEEDED_ONLY)) {
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
 		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
@@ -403,23 +414,28 @@ int main (int argc, char ** argv)
 				device_name);
 			exit(1);
 		}
-	printf("Resizing the filesystem on %s to %u (%dk) blocks.\n",
-		       device_name, new_size, fs->blocksize / 1024);
+		if (!(flags & RESIZE_BLOCKS_NEEDED_ONLY))
+			printf("Resizing the filesystem on %s to %u (%dk) "
+			       "blocks.\n", device_name, new_size,
+			       fs->blocksize / 1024);
 		retval = resize_fs(fs, &new_size, flags,
 				   ((flags & RESIZE_PERCENT_COMPLETE) ?
 				    resize_progress_func : 0));
 	}
+
 	if (retval) {
 		com_err(program_name, retval, _("while trying to resize %s"),
 			device_name);
 		ext2fs_close (fs);
 		exit(1);
 	}
-	printf(_("The filesystem on %s is now %u blocks long.\n\n"),
-	       device_name, new_size);
 
-	if ((st_buf.st_size > new_file_size) &&
-	    (fd > 0)) {
+	if (!(flags & RESIZE_BLOCKS_NEEDED_ONLY))
+		printf(_("The filesystem on %s is now %u blocks long.\n\n"),
+		       device_name, new_size);
+
+	if ((st_buf.st_size > new_file_size) && (fd > 0) &&
+	    !(flags & RESIZE_BLOCKS_NEEDED_ONLY)) {
 #ifdef HAVE_FSTAT64
 		ftruncate64(fd, new_file_size);
 #else
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 9959671..ae0cb8d 100644
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
@@ -79,7 +81,156 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 	retval = ext2fs_read_bitmaps(fs);
 	if (retval)
 		return retval;
-	
+
+	/*
+	 * since we only want to figure out the minimum number of blocks this
+	 * fs can be resized to, figure out the minimum number of blocks needed
+	 * to handle the metadata and reset new_size to that
+	 */
+	if (flags & RESIZE_BLOCKS_NEEDED_ONLY) {
+		blk_t inode_count, blks_needed, groups, blk, data_blocks;
+		blk_t grp, data_needed, last_start, tmp = 0;
+		int overhead = 0, old_group = -1, num_of_superblocks = 0;
+
+		/*
+		 * first figure out how many group descriptors we need to
+		 * handle the number of inodes we have
+		 */
+		inode_count = fs->super->s_inodes_count -
+			fs->super->s_free_inodes_count;
+		blks_needed = ext2fs_div_ceil(inode_count,
+						fs->super->s_inodes_per_group)
+			* EXT2_BLOCKS_PER_GROUP(fs->super);
+		groups = ext2fs_div_ceil(blks_needed,
+					 EXT2_BLOCKS_PER_GROUP(fs->super));
+
+		/*
+		 * we need to figure out how many backup superblocks we have
+		 * so we can account for that in the metadata
+		 */
+		for (grp = 0; grp < fs->group_desc_count; grp++) {
+			if (ext2fs_bg_has_super(fs, grp))
+				num_of_superblocks++;
+		}
+
+		/* calculate how many blocks are needed for data */
+		data_needed = fs->super->s_blocks_count -
+			fs->super->s_free_blocks_count;
+		data_needed -= SUPER_OVERHEAD(fs) * num_of_superblocks;
+		data_needed -= META_OVERHEAD(fs) * fs->group_desc_count;
+
+
+		/*
+		 * figure out how many data blocks we have given the number
+		 * of groups we need for our inodes
+		 */
+		data_blocks = groups * EXT2_BLOCKS_PER_GROUP(fs->super);
+		last_start = 0;
+		for (grp = 0; grp < groups; grp++) {
+			overhead = META_OVERHEAD(fs);
+
+			if (ext2fs_bg_has_super(fs, grp))
+				overhead += SUPER_OVERHEAD(fs);
+
+			/*
+			 * we want to keep track of how much data we can store
+			 * in the groups leading up to the last group so we
+			 * can determine how big the last group needs to be
+			 */
+			if (grp != (groups - 1))
+				last_start += EXT2_BLOCKS_PER_GROUP(fs->super)
+					- overhead;
+
+			data_blocks -= overhead;
+		}
+
+		/*
+		 * if we need more group descriptors in order to accomodate
+		 * our data then we need to add them here
+		 */
+		while (data_needed > data_blocks) {
+			blk_t remainder = data_needed - data_blocks;
+			blk_t extra_grps;
+
+			/*
+			 * figure out how many more groups we need for the data
+			 */
+			extra_grps = ext2fs_div_ceil(remainder,
+				EXT2_BLOCKS_PER_GROUP(fs->super));
+
+			data_blocks += extra_grps *
+				EXT2_BLOCKS_PER_GROUP(fs->super);
+
+			/* ok we have to account for the last group */
+			overhead = META_OVERHEAD(fs);
+			if (ext2fs_bg_has_super(fs, groups-1))
+				overhead += SUPER_OVERHEAD(fs);
+			last_start += EXT2_BLOCKS_PER_GROUP(fs->super) -
+				overhead;
+
+			for (grp = groups; grp < groups+extra_grps; grp++) {
+				overhead = META_OVERHEAD(fs);
+				if (ext2fs_bg_has_super(fs, grp))
+					overhead += SUPER_OVERHEAD(fs);
+
+				/*
+				 * again, we need to see how much data we cram
+				 * into all the groups leading up to the last
+				 * group
+				 */
+				if (grp != (groups + extra_grps - 1)) {
+					last_start +=
+						EXT2_BLOCKS_PER_GROUP(fs->super)
+						- overhead;
+				}
+
+				data_blocks -= overhead;
+			}
+
+			groups += extra_grps;
+		}
+
+		/* now for the fun voodoo */
+		overhead = META_OVERHEAD(fs);
+
+		/*
+		 * if this is the case then the last group is going to have
+		 * data in it so we need to adjust the size of the last group
+		 * accordingly
+		 */
+		if (last_start < data_needed) {
+			blk_t remainder = data_needed - last_start;
+
+			/*
+			 * 50 is a magic number that mkfs/resize uses to
+			 * see if its even worth making/resizing the fs.
+			 * basically you need to have at least 50 blocks in
+			 * addition to the blocks needed for the metadata in
+			 * the last group
+			 */
+			if (remainder > 50)
+				overhead += remainder;
+			else
+				overhead += 50;
+		} else
+			overhead += 50;
+
+		if (ext2fs_bg_has_super(fs, groups-1))
+			overhead += SUPER_OVERHEAD(fs);
+
+		/*
+		 * since our last group doesn't have to be BLOCKS_PER_GROUP
+		 * larg, we only do groups-1, and then add the number of blocks
+		 * needed to handle the group descriptor metadata+data that we
+		 * need
+		 */
+		blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
+		blks_needed += overhead;
+
+		printf("Minimum resize size in blocks is %d\n", blks_needed);
+		return 0;
+	}
+
 	/*
 	 * Create the data structure
 	 */
@@ -90,7 +241,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 
 	rfs->old_fs = fs;
 	rfs->flags = flags;
-	rfs->itable_buf	 = 0;
+	rfs->itable_buf = 0;
 	rfs->progress = progress;
 	retval = ext2fs_dup_handle(fs, &rfs->new_fs);
 	if (retval)
@@ -113,7 +264,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 		       rfs->new_fs->super->s_free_blocks_count,
 		       rfs->needed_blocks);
 #endif
-	
+
 	retval = block_mover(rfs);
 	if (retval)
 		goto errout;
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index f87d04e..cf42a62 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -79,6 +79,7 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
+#define RESIZE_BLOCKS_NEEDED_ONLY	0x0400
 
 /*
  * The core state structure for the ext2 resizer
@@ -127,7 +128,7 @@ extern errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 					    int pass, unsigned long cur,
 					    unsigned long max));
 
-extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs, 
+extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 				blk_t new_size);
 
 
