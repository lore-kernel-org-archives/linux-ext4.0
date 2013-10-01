From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] resize2fs: add debugging support for resize2fs -M calcuations
Date: Mon, 30 Sep 2013 23:59:31 -0400
Message-ID: <1380599974-2886-1-git-send-email-tytso@mit.edu>
References: <20131001015746.GF5845@thunk.org>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40496 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab3JAD7m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 23:59:42 -0400
In-Reply-To: <20131001015746.GF5845@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c         |  2 +-
 resize/resize2fs.8.in |  4 +++-
 resize/resize2fs.c    | 59 +++++++++++++++++++++++++++++++++++++++++++++------
 resize/resize2fs.h    |  3 ++-
 4 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index b648a15..1394ae1 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -328,7 +328,7 @@ int main (int argc, char ** argv)
 		exit(1);
 	}
 
-	min_size = calculate_minimum_resize_size(fs);
+	min_size = calculate_minimum_resize_size(fs, flags);
 
 	if (print_min_size) {
 		if (!force && ((fs->super->s_state & EXT2_ERROR_FS) ||
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 735fc91..a1f3099 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -101,7 +101,9 @@ from the following list:
 	8	\-\ Debug moving the inode table
 .br
 	16	\-\ Print timing information
-.TP 
+.br
+	32	\-\ Debug minimum filesystem size (\-M) calculation
+.TP
 .B \-f
 Forces resize2fs to proceed with the filesystem resize operation, overriding
 some safety checks which resize2fs normally enforces.
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 3b48206..51b85b8 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2034,10 +2034,11 @@ static int calc_group_overhead(ext2_filsys fs, blk64_t grp,
 /*
  * calcluate the minimum number of blocks the given fs can be resized to
  */
-blk64_t calculate_minimum_resize_size(ext2_filsys fs)
+blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 {
 	ext2_ino_t inode_count;
-	blk64_t blks_needed, groups, data_blocks;
+	dgrp_t groups;
+	blk64_t blks_needed, data_blocks;
 	blk64_t grp, data_needed, last_start;
 	blk64_t overhead = 0;
 	int old_desc_blocks;
@@ -2055,6 +2056,11 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 		EXT2_BLOCKS_PER_GROUP(fs->super);
 	groups = ext2fs_div64_ceil(blks_needed,
 				   EXT2_BLOCKS_PER_GROUP(fs->super));
+#ifdef RESIZE2FS_DEBUG
+	if (flags & RESIZE_DEBUG_MIN_CALC)
+		printf("fs has %d inodes, %d groups required.\n",
+		       inode_count, groups);
+#endif
 
 	/*
 	 * number of old-style block group descriptor blocks
@@ -2071,6 +2077,10 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 
 	for (grp = 0; grp < fs->group_desc_count; grp++)
 		data_needed -= calc_group_overhead(fs, grp, old_desc_blocks);
+#ifdef RESIZE2FS_DEBUG
+	if (flags & RESIZE_DEBUG_MIN_CALC)
+		printf("fs requires %llu data blocks.\n", data_needed);
+#endif
 
 	/*
 	 * For ext4 we need to allow for up to a flex_bg worth of
@@ -2103,6 +2113,11 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 
 		data_blocks -= overhead;
 	}
+#ifdef RESIZE2FS_DEBUG
+	if (flags & RESIZE_DEBUG_MIN_CALC)
+		printf("With %d group(s), we have %llu blocks available.\n",
+		       groups, data_blocks);
+#endif
 
 	/*
 	 * if we need more group descriptors in order to accomodate our data
@@ -2110,7 +2125,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	 */
 	while (data_needed > data_blocks) {
 		blk64_t remainder = data_needed - data_blocks;
-		blk64_t extra_grps;
+		dgrp_t extra_grps;
 
 		/* figure out how many more groups we need for the data */
 		extra_grps = ext2fs_div64_ceil(remainder,
@@ -2153,10 +2168,22 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 					extra_groups);
 			extra_groups = groups % flexbg_size;
 		}
+#ifdef RESIZE2FS_DEBUG
+		if (flags & RESIZE_DEBUG_MIN_CALC)
+			printf("Added %d extra group(s), "
+			       "data_needed %llu, data_blocks %llu, "
+			       "last_start %llu\n",
+			       extra_grps, data_needed, data_blocks,
+			       last_start);
+#endif
 	}
 
 	/* now for the fun voodoo */
 	overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);
+#ifdef RESIZE2FS_DEBUG
+	if (flags & RESIZE_DEBUG_MIN_CALC)
+		printf("Last group's overhead is %llu\n", overhead);
+#endif
 
 	/*
 	 * if this is the case then the last group is going to have data in it
@@ -2165,6 +2192,11 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	if (last_start < data_needed) {
 		blk64_t remainder = data_needed - last_start;
 
+#ifdef RESIZE2FS_DEBUG
+		if (flags & RESIZE_DEBUG_MIN_CALC)
+			printf("Need %llu data blocks in last group\n",
+			       remainder);
+#endif
 		/*
 		 * 50 is a magic number that mkfs/resize uses to see if its
 		 * even worth making/resizing the fs.  basically you need to
@@ -2179,6 +2211,10 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 		overhead += 50;
 
 	overhead += fs->super->s_first_data_block;
+#ifdef RESIZE2FS_DEBUG
+	if (flags & RESIZE_DEBUG_MIN_CALC)
+		printf("Final size of last group is %lld\n", overhead);
+#endif
 
 	/*
 	 * since our last group doesn't have to be BLOCKS_PER_GROUP large, we
@@ -2188,6 +2224,11 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
 	blks_needed += overhead;
 
+#ifdef RESIZE2FS_DEBUG
+	if (flags & RESIZE_DEBUG_MIN_CALC)
+		printf("Estimated blocks needed: %llu\n", blks_needed);
+#endif
+
 	/*
 	 * If at this point we've already added up more "needed" than
 	 * the current size, just return current size as minimum.
@@ -2199,9 +2240,15 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	 * enabled, in case we need to grow the extent tree.  The more
 	 * we shrink the file system, the more space we need.
 	 */
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
-		blks_needed += (ext2fs_blocks_count(fs->super) - 
-				blks_needed)/500;
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
+				       blks_needed)/500;
+#ifdef RESIZE2FS_DEBUG
+		if (flags & RESIZE_DEBUG_MIN_CALC)
+			printf("Extents safety margin: %llu\n", safe_margin);
+#endif
+		blks_needed += safe_margin;
+	}
 
 	return blks_needed;
 }
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index d425491..52319b5 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -77,6 +77,7 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_DEBUG_INODEMAP		0x0004
 #define RESIZE_DEBUG_ITABLEMOVE		0x0008
 #define RESIZE_DEBUG_RTRACK		0x0010
+#define RESIZE_DEBUG_MIN_CALC		0x0020
 
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
@@ -145,7 +146,7 @@ extern errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 				ext2fs_block_bitmap reserve_blocks,
 				blk64_t new_size);
-extern blk64_t calculate_minimum_resize_size(ext2_filsys fs);
+extern blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags);
 
 
 /* extent.c */
-- 
1.7.12.rc0.22.gcdd159b

