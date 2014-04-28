From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] resize2fs: refine minimum required blocks for flex_bg file systems
Date: Mon, 28 Apr 2014 07:26:36 -0400
Message-ID: <1398684396-32689-3-git-send-email-tytso@mit.edu>
References: <1398684396-32689-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36911 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbaD1L0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 07:26:43 -0400
In-Reply-To: <1398684396-32689-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The previous commit exposed bugs in the calculation for flex_bg file
systems.  The problem is that since (by default) we keep the metadata
blocks for the flex_bg in the first block group of the flex_bg, and
because we don't want to overwrite metadata blocks used by the
original file system with data blocks make life easier in case the
resize is aborted for some reason, we need to treat all of the
metadata blocks in the existing flex_bg has in use for the purposes of
calculate_minimum_resize_size().

Even though this means we need to reserve more data blocks to avoid
running out of space, the net result of these two commits is a net
savings in how much we can shrink a file system.

Using the following test sequence:

	mke2fs -F -t ext4 /tmp/foo.img 2T
	resize2fs -M /tmp/foo.img
	resize2fs -M /tmp/foo.img
	resize2fs -M /tmp/foo.img

Here is the comparison in the resulting file systems between the old
and new resize2fs (units are in 4k blocks):

                resize #1  resize #2   resize #3
old resize2fs    1117186     45679       43536
new resize2fs      48784     37413       37392

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c        | 76 ++++++++++++++++++++++++++++-------------------
 tests/scripts/resize_test | 22 +++++++++-----
 2 files changed, 59 insertions(+), 39 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 99669a8..0d968fa 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2301,12 +2301,11 @@ static int calc_group_overhead(ext2_filsys fs, blk64_t grp,
 blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 {
 	ext2_ino_t inode_count;
-	dgrp_t groups;
+	dgrp_t groups, flex_groups;
 	blk64_t blks_needed, data_blocks;
 	blk64_t grp, data_needed, last_start;
 	blk64_t overhead = 0;
 	int old_desc_blocks;
-	int extra_groups = 0;
 	int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
 
 	/*
@@ -2351,11 +2350,13 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * inode tables of slack space so the resize operation can be
 	 * guaranteed to finish.
 	 */
-	blks_needed = data_needed;
+	flex_groups = groups;
 	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
-		extra_groups = flexbg_size - (groups & (flexbg_size - 1));
-		blks_needed += fs->inode_blocks_per_group * extra_groups;
-		extra_groups = groups % flexbg_size;
+		dgrp_t remainder = groups & (flexbg_size - 1);
+
+		flex_groups += flexbg_size - remainder;
+		if (flex_groups > fs->group_desc_count)
+			flex_groups = fs->group_desc_count;
 	}
 
 	/*
@@ -2364,7 +2365,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 */
 	data_blocks = groups * EXT2_BLOCKS_PER_GROUP(fs->super);
 	last_start = 0;
-	for (grp = 0; grp < groups; grp++) {
+	for (grp = 0; grp < flex_groups; grp++) {
 		overhead = calc_group_overhead(fs, grp, old_desc_blocks);
 
 		/*
@@ -2372,11 +2373,14 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 		 * the groups leading up to the last group so we can determine
 		 * how big the last group needs to be
 		 */
-		if (grp != (groups - 1))
+		if (grp < (groups - 1))
 			last_start += EXT2_BLOCKS_PER_GROUP(fs->super) -
 				overhead;
 
-		data_blocks -= overhead;
+		if (data_blocks > overhead)
+			data_blocks -= overhead;
+		else
+			data_blocks = 0;
 	}
 #ifdef RESIZE2FS_DEBUG
 	if (flags & RESIZE_DEBUG_MIN_CALC)
@@ -2388,6 +2392,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * if we need more group descriptors in order to accomodate our data
 	 * then we need to add them here
 	 */
+	blks_needed = data_needed;
 	while (blks_needed > data_blocks) {
 		blk64_t remainder = blks_needed - data_blocks;
 		dgrp_t extra_grps;
@@ -2402,7 +2407,20 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 		overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);
 		last_start += EXT2_BLOCKS_PER_GROUP(fs->super) - overhead;
 
-		for (grp = groups; grp < groups+extra_grps; grp++) {
+		grp = flex_groups;
+		groups += extra_grps;
+		if (!(fs->super->s_feature_incompat &
+		      EXT4_FEATURE_INCOMPAT_FLEX_BG))
+			flex_groups = groups;
+		else if (groups > flex_groups) {
+			dgrp_t r = groups & (flexbg_size - 1);
+
+			flex_groups = groups + flexbg_size - r;
+			if (flex_groups > fs->group_desc_count)
+				flex_groups = fs->group_desc_count;
+		}
+
+		for (; grp < flex_groups; grp++) {
 			overhead = calc_group_overhead(fs, grp,
 						       old_desc_blocks);
 
@@ -2410,29 +2428,13 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 			 * again, we need to see how much data we cram into
 			 * all of the groups leading up to the last group
 			 */
-			if (grp != (groups + extra_grps - 1))
+			if (grp < groups - 1)
 				last_start += EXT2_BLOCKS_PER_GROUP(fs->super)
 					- overhead;
 
 			data_blocks -= overhead;
 		}
 
-		groups += extra_grps;
-		extra_groups += extra_grps;
-		if (fs->super->s_feature_incompat
-			& EXT4_FEATURE_INCOMPAT_FLEX_BG
-		    && extra_groups > flexbg_size) {
-			/*
-			 * For ext4 we need to allow for up to a flex_bg worth
-			 * of inode tables of slack space so the resize
-			 * operation can be guaranteed to finish.
-			 */
-			extra_groups = flexbg_size -
-						(groups & (flexbg_size - 1));
-			blks_needed += (fs->inode_blocks_per_group *
-					extra_groups);
-			extra_groups = groups % flexbg_size;
-		}
 #ifdef RESIZE2FS_DEBUG
 		if (flags & RESIZE_DEBUG_MIN_CALC)
 			printf("Added %d extra group(s), "
@@ -2443,7 +2445,14 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	}
 
 	/* now for the fun voodoo */
-	overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);
+	grp = groups - 1;
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    (grp & ~(flexbg_size - 1)) == 0)
+		grp = grp & ~(flexbg_size - 1);
+	overhead = 0;
+	for (; grp < flex_groups; grp++)
+		overhead += calc_group_overhead(fs, grp, old_desc_blocks);
+
 #ifdef RESIZE2FS_DEBUG
 	if (flags & RESIZE_DEBUG_MIN_CALC)
 		printf("Last group's overhead is %llu\n", overhead);
@@ -2480,10 +2489,15 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 		printf("Final size of last group is %lld\n", overhead);
 #endif
 
+	/* Add extra slack for bigalloc file systems */
+	if (EXT2FS_CLUSTER_RATIO(fs) > 1)
+		overhead += EXT2FS_CLUSTER_RATIO(fs) * 2;
+
 	/*
-	 * since our last group doesn't have to be BLOCKS_PER_GROUP large, we
-	 * only do groups-1, and then add the number of blocks needed to
-	 * handle the group descriptor metadata+data that we need
+	 * since our last group doesn't have to be BLOCKS_PER_GROUP
+	 * large, we only do groups-1, and then add the number of
+	 * blocks needed to handle the group descriptor metadata+data
+	 * that we need
 	 */
 	blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
 	blks_needed += overhead;
diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
index b09731c..c9a7a1c 100755
--- a/tests/scripts/resize_test
+++ b/tests/scripts/resize_test
@@ -9,6 +9,7 @@ truncate()
 }
 
 resize_test () {
+DBG_FLAGS=63
 
 echo $test_description starting > $LOG
 rm -f $TMPFILE
@@ -57,8 +58,8 @@ rm -f $OUT_TMP
 echo $FSCK -fy $TMPFILE >> $LOG 2>&1 
 $FSCK -fy $TMPFILE >> $LOG 2>&1 
 
-echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 $TMPFILE $SIZE_2 >> $LOG 2>&1
-if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 $TMPFILE $SIZE_2 >> $LOG 2>&1
+echo $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS $TMPFILE $SIZE_2 >> $LOG 2>&1
 then
 	return 1
 fi
@@ -82,8 +83,13 @@ then
 	return 1
 fi
 
-echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
-if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+# Uncomment to grab extra debugging image
+#
+#mv $TMPFILE /tmp/foo.img
+#return 0
+
+echo $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS -M $TMPFILE $SIZE_2 >> $LOG 2>&1
 then
 	return 1
 fi
@@ -107,8 +113,8 @@ then
 	return 1
 fi
 
-echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
-if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+echo $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS -M $TMPFILE $SIZE_2 >> $LOG 2>&1
 then
 	return 1
 fi
@@ -132,8 +138,8 @@ then
 	return 1
 fi
 
-echo $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
-if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+echo $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS -M $TMPFILE $SIZE_2 >> $LOG 2>&1
+if ! $RESIZE2FS $RESIZE2FS_OPTS -d $DBG_FLAGS -M $TMPFILE $SIZE_2 >> $LOG 2>&1
 then
 	return 1
 fi
-- 
1.9.0

