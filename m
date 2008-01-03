From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] e2fsprogs: add minimal resize size option
Date: Thu, 3 Jan 2008 15:03:06 -0500
Message-ID: <20080103200306.GA19584@dhcp243-37.rdu.redhat.com>
References: <20080102201659.GI31745@dhcp243-37.rdu.redhat.com> <20080103172101.GE30771@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYACUOk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2008 15:14:40 -0500
Content-Disposition: inline
In-Reply-To: <20080103172101.GE30771@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 03, 2008 at 12:21:01PM -0500, Theodore Tso wrote:
> On Wed, Jan 02, 2008 at 03:16:59PM -0500, Josef Bacik wrote:
> > Hello,
> > 
> > People wishing to make live usb disks and such are looking for a way
> > to get the minimum resize size for an ext fs in blocks so that they
> > can just resize their image to that size and do with it what they
> > will.  This patch adds that functionality, just pass -m option and
> > it calculates the minimum number of blocks the fs can be resized to.
> 
> Three comments.  Instead of using a new option, why not simply let
> resize2fs check to see if the optional parameter is something like
> "min" or "0"?
> 
> Secondly, I'd suggest factoring out the calculation of the minimal
> size into a separate function.
> 
> Finally, please don't fix whitespace issues, as it makes it harder for me
> to merge between the "maint" and "master" development lines.  What I
> plan to do is to do a massive fixup of trailing whitespace before the
> next major (1.41) release of e2fsprogs.  Any new lines added by
> patches should not introduce any new trailing whitespace, of course.
>

Hmm sorry about the whitespace things, I thought I had cleaned all those up.
Thanks much for the suggestions, here is the updated patch with your suggestions
implemented, if you pass a size of 0 it will just spit out the minimum resize
size.  Thanks much,

Josef

 
diff --git a/resize/main.c b/resize/main.c
index 7c1d0c1..44d05b0 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -342,11 +342,8 @@ int main (int argc, char ** argv)
 	if (new_size_str) {
 		new_size = parse_num_blocks(new_size_str, 
 					    fs->super->s_log_block_size);
-		if (!new_size) {
-			com_err(program_name, 0, _("bad filesystem size - %s"),
-				new_size_str);
-			exit(1);
-		}
+		if (!new_size)
+			flags |= RESIZE_BLOCKS_NEEDED_ONLY;
 	} else {
 		new_size = max_size;
 		/* Round down to an even multiple of a pagesize */
@@ -392,7 +389,8 @@ int main (int argc, char ** argv)
 			"long.  Nothing to do!\n\n"), new_size);
 		exit(0);
 	}
-	if (mount_flags & EXT2_MF_MOUNTED) {
+	if ((mount_flags & EXT2_MF_MOUNTED) &&
+	    !(flags & RESIZE_BLOCKS_NEEDED_ONLY)) {
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
 		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
@@ -403,8 +401,10 @@ int main (int argc, char ** argv)
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
@@ -415,11 +415,13 @@ int main (int argc, char ** argv)
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
index 9959671..ad50c30 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -48,7 +48,7 @@ static errcode_t inode_ref_fix(ext2_resize_t rfs);
 static errcode_t move_itables(ext2_resize_t rfs);
 static errcode_t fix_resize_inode(ext2_filsys fs);
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
-
+static errcode_t ext2fs_calculate_minimum_resize_size(ext2_filsys fs);
 /*
  * Some helper CPP macros
  */
@@ -63,7 +63,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
 				 ((blk) < (FS_INODE_TB((fs), (i)) + \
 					   (fs)->inode_blocks_per_group)))
 
-
+#define META_OVERHEAD(fs) (2 + (fs)->inode_blocks_per_group)
+#define SUPER_OVERHEAD(fs) (1 + (fs)->desc_blocks +\
+			    (fs)->super->s_reserved_gdt_blocks)
 
 /*
  * This is the top-level routine which does the dirty deed....
@@ -80,6 +82,9 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 	if (retval)
 		return retval;
 	
+	if (flags & RESIZE_BLOCKS_NEEDED_ONLY)
+		return ext2fs_calculate_minimum_resize_size(fs);
+
 	/*
 	 * Create the data structure
 	 */
@@ -1628,3 +1633,141 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
+
+/*
+ * calcluate the minimum number of blocks the given fs can be resized to
+ */
+static errcode_t ext2fs_calculate_minimum_resize_size(ext2_filsys fs)
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
+	printf("Minimum resize size in blocks is %d\n", blks_needed);
+
+	return 0;
+}
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index f87d04e..14a2c3f 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -79,6 +79,7 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
+#define RESIZE_BLOCKS_NEEDED_ONLY	0x0400
 
 /*
  * The core state structure for the ext2 resizer
