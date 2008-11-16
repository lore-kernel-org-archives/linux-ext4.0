From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 -
	2^32 blocks
Date: Sun, 16 Nov 2008 10:06:51 -0500
Message-ID: <20081116150651.GC9987@mit.edu>
References: <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <20081113195742.GV16005@webber.adilger.int> <20081114023812.GD20637@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36941 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952AbYKPQdn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:33:43 -0500
Content-Disposition: inline
In-Reply-To: <20081114023812.GD20637@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've just checked the following into e2fsprogs git tree.

     	  	      		     	       - Ted

commit a057b2332f5780b71018630f18f2619480118c5d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Nov 16 10:03:00 2008 -0500

    Fix various signed/unsigned gcc warnings
    
    Some of these could affect filesystems between 2^31 and 2^32-1 blocks.
    
    Thanks to Valerie Aurora Henson for pointing out the problems in
    lib/ext2fs/alloc_tables.c, which led me to do a "make gcc-wall"
    scan over the source tree.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8ad0871..3e1a94d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -404,7 +404,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	const char		*old_op;
 	errcode_t		retval;
 	blk_t			blk;
-	int			i, rec_len, not_device = 0;
+	unsigned int		i, rec_len, not_device = 0;
 
 	if (LINUX_S_ISDIR(inode->i_mode) || LINUX_S_ISREG(inode->i_mode) ||
 	    LINUX_S_ISLNK(inode->i_mode) || inode->i_block[0] == 0)
@@ -1935,7 +1935,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			bad_size = 4;
 		else if ((extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
 			 size >
-			 ((1LL << (32 + EXT2_BLOCK_SIZE_BITS(fs->super))) - 1))
+			 ((1ULL << (32 + EXT2_BLOCK_SIZE_BITS(fs->super))) - 1))
 			/* too big for an extent-based file - 32bit ee_block */
 			bad_size = 6;
 	}
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index c36bfcf..f479df6 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -717,7 +717,7 @@ static int check_dir_block(ext2_filsys fs,
 	const char *		old_op;
 	int			dir_modified = 0;
 	int			dot_state;
-	int			rec_len;
+	unsigned int		rec_len;
 	blk_t			block_nr = db->blk;
 	ext2_ino_t 		ino = db->ino;
 	ext2_ino_t 		subdir_parent;
@@ -855,7 +855,7 @@ out_htree:
 		if (((offset + rec_len) > fs->blocksize) ||
 		    (rec_len < 12) ||
 		    ((rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > rec_len)) {
+		    (((dirent->name_len & (unsigned) 0xFF)+8) > rec_len)) {
 			if (fix_problem(ctx, PR_2_DIR_CORRUPTED, &cd->pctx)) {
 				salvage_directory(fs, dirent, prev, &offset);
 				dir_modified++;
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 230bec9..be2b56b 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -29,10 +29,10 @@
 /*
  * Check for uninit block bitmaps and deal with them appropriately
  */
-static check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
+static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 			  dgrp_t group)
 {
-	int		i;
+	blk_t		i;
 	blk_t		blk, super_blk, old_desc_blk, new_desc_blk;
 	int		old_desc_blocks;
 
@@ -75,11 +75,10 @@ static check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 /*
  * Check for uninit inode bitmaps and deal with them appropriately
  */
-static check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
+static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 			  dgrp_t group)
 {
-	int		i;
-	ext2_ino_t	ino;
+	ext2_ino_t	i, ino;
 
 	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) ||
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4d2535e..9b4c057 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -119,7 +119,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		start_blk = group_blk;
 
 	if (flexbg_size) {
-		int prev_block = 0;
+		blk_t prev_block = 0;
 		if (group && fs->group_desc[group-1].bg_block_bitmap)
 			prev_block = fs->group_desc[group-1].bg_block_bitmap;
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
@@ -147,7 +147,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	}
 
 	if (flexbg_size) {
-		int prev_block = 0;
+		blk_t prev_block = 0;
 		if (group && fs->group_desc[group-1].bg_inode_bitmap)
 			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index b75cb77..b3ac9f2 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -17,6 +17,7 @@
 #if HAVE_ERRNO_H
 #include <errno.h>
 #endif
+#include <time.h>
 #if HAVE_SYS_STAT_H
 #include <sys/stat.h>
 #endif
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index f392867..abe05f5 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -176,8 +176,7 @@ errout:
  */
 static void fix_uninit_block_bitmaps(ext2_filsys fs)
 {
-	int		i;
-	blk_t		blk, super_blk, old_desc_blk, new_desc_blk;
+	blk_t		i, blk, super_blk, old_desc_blk, new_desc_blk;
 	int		old_desc_blocks;
 	dgrp_t		g;
 
@@ -1375,8 +1374,8 @@ errout:
 struct istruct {
 	ext2_resize_t rfs;
 	errcode_t	err;
-	unsigned long	max_dirs;
-	int		num;
+	unsigned int	max_dirs;
+	unsigned int	num;
 };
 
 static int check_and_change_inodes(ext2_ino_t dir,
