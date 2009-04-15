From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [PATCH] Add some missing ext2_div64_ceil() calls
Date: Wed, 15 Apr 2009 16:55:20 -0400
Message-ID: <20090415205520.GI1668@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, kylerlaird0@users.sourceforge.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZDOU4g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 16:56:36 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 350f9efc9cd06209b03e920711ee00fd1b512835
Author: Valerie Aurora (Henson) <vaurora@redhat.com>
Date:   Wed Apr 15 13:41:45 2009 -0700

    Add some missing ext2_div64_ceil() calls
    
    Original bug report:
    
    http://sourceforge.net/tracker/?func=detail&aid=2710927&group_id=2406&atid=102406

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index c8bdbe6..2b280ad 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -77,6 +77,10 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 	 */
 	if (ext2fs_blocks_count(sb) < max_blocks / 1024)
 		max_blocks = ext2fs_blocks_count(sb) * 1024;
+	/*
+	 * ext2fs_div64_ceil() is unnecessary because max_blocks is
+	 * max _GDT_ blocks, which is limited to 32 bits.
+	 */
 	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
 	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
 	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 44e7e66..9c3f736 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -689,7 +689,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				continue;
 			}
 		} else if (!strcmp(token, "resize")) {
-			unsigned long resize, bpg, rsv_groups;
+			blk64_t resize;
+			unsigned long bpg, rsv_groups;
 			unsigned long group_desc_count, desc_blocks;
 			unsigned int gdpb, blocksize;
 			int rsv_gdb;
@@ -727,7 +728,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				ext2fs_blocks_count(param), bpg);
 			desc_blocks = (group_desc_count +
 				       gdpb - 1) / gdpb;
-			rsv_groups = ext2fs_div_ceil(resize, bpg);
+			rsv_groups = ext2fs_div64_ceil(resize, bpg);
 			rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) -
 				desc_blocks;
 			if (rsv_gdb > (int) EXT2_ADDR_PER_BLOCK(param))
diff --git a/resize/online.c b/resize/online.c
index 704e4bb..57ed2c2 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -48,9 +48,9 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	 * the on-line resizing inode must be present.
 	 */
 	new_desc_blocks = ext2fs_div_ceil(
-		ext2fs_div_ceil(*new_size -
-				fs->super->s_first_data_block,
-				EXT2_BLOCKS_PER_GROUP(fs->super)),
+		ext2fs_div64_ceil(*new_size -
+				  fs->super->s_first_data_block,
+				  EXT2_BLOCKS_PER_GROUP(fs->super)),
 		EXT2_DESC_PER_BLOCK(fs->super));
 	printf("old desc_blocks = %lu, new_desc_blocks = %lu\n",
 	       fs->desc_blocks, new_desc_blocks);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index c27df86..6a17de0 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1850,8 +1850,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 	blks_needed = ext2fs_div_ceil(inode_count,
 				      fs->super->s_inodes_per_group) *
 		EXT2_BLOCKS_PER_GROUP(fs->super);
-	groups = ext2fs_div_ceil(blks_needed,
-				 EXT2_BLOCKS_PER_GROUP(fs->super));
+	groups = ext2fs_div64_ceil(blks_needed,
+				   EXT2_BLOCKS_PER_GROUP(fs->super));
 
 	/*
 	 * we need to figure out how many backup superblocks we have so we can
@@ -1901,8 +1901,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs)
 		blk64_t extra_grps;
 
 		/* figure out how many more groups we need for the data */
-		extra_grps = ext2fs_div_ceil(remainder,
-					     EXT2_BLOCKS_PER_GROUP(fs->super));
+		extra_grps = ext2fs_div64_ceil(remainder,
+					       EXT2_BLOCKS_PER_GROUP(fs->super));
 
 		data_blocks += extra_grps * EXT2_BLOCKS_PER_GROUP(fs->super);
 
