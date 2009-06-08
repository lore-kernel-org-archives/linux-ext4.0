From: Theodore Tso <tytso@mit.edu>
Subject: Update on the 64-bit e2fsprogs patches
Date: Mon, 8 Jun 2009 00:55:39 -0400
Message-ID: <20090608045539.GE23883@mit.edu>
References: <E1MB7oF-0007Ot-TB@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55597 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZFHEzl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2009 00:55:41 -0400
Content-Disposition: inline
In-Reply-To: <E1MB7oF-0007Ot-TB@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 01, 2009 at 09:44:15AM -0400, Theodore Ts'o wrote:
> The patch series for the work that I've done can be found here:
> 
>  	 git://github.com/tytso/e2fsprogs-64bit.git
> 
> ... and if Nick or Val or any other ext4 developer anyone would like to
> have commit access to the e2fsprogs 64-bit patch queue, just let me know.
> 
> I've also made the 64-bit e2fsprogs patches available on the "pu"
> (proposed updates) branch of e2fsprogs.  As before, the "pu" branch may
> be rewound and rebased without warning, so it's primarily useful for
> people to easily get an update to the latest 64-bit patches.  For
> collaborative development, it's best to use the e2fsprogs-64bit patch
> queue.

So I thought I'd give people an update on what's been happening on the
e2fsprogs 64-bit patch queue.  I've done a lot of work to make the
patches easier to understand, including fixing bugs in the patches in
relevant patch in the patch queue, instead of as follow on patches.
So a number of Nick's patches have been folded into the patch which
introduced the bug in the first place.  This makes it easier to clean
up the patches, and it also makes it easier to find problems by code
inspection.  For example, a number of missing blk64_t conversions were
found by taking Nick's patches, applying them to patch #15,
0015-Convert-to-inode-block-bitmap-table-loc-loc_set.patch, and then
seeing if there were any similar omissions mades in that patch.

So the git log on the e2fsprogs 64-bit patch queue shows a fair amount
of church, including shrinking the e2fsprogs patch queue by 9 patches:

commit 350533b17a5be5171baaced07fb3570e562cd4f2
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jun 6 11:52:27 2009 -0400

    Collapse bug fixes from patch #58 and #62 into the changes made patch

commit 230792b81a5dbd91bea5b7377a4467fca4783dff
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jun 6 12:29:33 2009 -0400

    Collapse bug fix from patch #63 into commit #4.

commit 2968c5767d4ac69e9a72fc75466fa7760adff65d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jun 6 13:43:14 2009 -0400

    Fold patch #57 into patch add_new_blk64_t_handling_functions

commit 25dc9ddc82d1101bce00b9045c59db7b7e0d5ee8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jun 6 15:31:02 2009 -0400

    Consolidate new functions added to blknum.c into a single commit.

commit 7e0bf59b9d07d75df0ce69fcaf128b1f733d3cc5
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jun 6 23:51:35 2009 -0400

    Move contents of patch #60 into patch #20 and to the
    64_bit_mke2fs_cleanup patch.

commit 16d36830fd911a0f699c76747522be0a962db925
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jun 7 07:56:26 2009 -0400

    Collapse bug fixes in patch #52 into patch #24.

commit 3ce7d0501e71f1ef3ed027b2908fddbefe08de8f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jun 7 21:17:56 2009 -0400

    Fold patches #56, #59, and #63 into patches #5 and #15.

commit 86c89423834fff00b0e176a36a47cfc8e4714651
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jun 8 00:02:46 2009 -0400

    Add missing conversion of check_block_uninit in the patch:
    use_new_ext2fs_super_and_bgd_loc2_call_in_libext2fs

commit 64e4b87fdd947d0921b55360d91d58bf547c801b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jun 8 00:27:57 2009 -0400

    Fix ext2fs_open_inode_scan() to work correct on 64-bit platforms in
    patch #15.

commit 5292f786a9a0026833d8ed416abf34ef27d93db6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jun 8 00:29:04 2009 -0400

    Add .gitignore file.

However, the actual changes between the previous pu branch and the
latest one is *much* smaller.  (The patch does include some pretty
significant patch fixes, including one that would cause e2fsck blow up
if used on a > 32-bit filesystem where any of the inodes located in
the part of the filesystem where the block number is > 2**32.)

The bottom line is the patches still need a fair amount of auditing,
cleanup, and testing, but progress is being made, slowly....

	     	      	  	      	    	  - Ted


diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index a7c8860..c0777a6 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -33,7 +33,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap64 map,
 			       dgrp_t group)
 {
 	blk_t		i;
-	blk_t		blk, super_blk, old_desc_blk, new_desc_blk;
+	blk64_t		blk, super_blk, old_desc_blk, new_desc_blk;
 	int		old_desc_blocks;
 
 	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
@@ -44,8 +44,8 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap64 map,
 	blk = (group * fs->super->s_blocks_per_group) +
 		fs->super->s_first_data_block;
 
-	ext2fs_super_and_bgd_loc(fs, group, &super_blk,
-				 &old_desc_blk, &new_desc_blk, 0);
+	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
+				  &old_desc_blk, &new_desc_blk, 0);
 
 	if (fs->super->s_feature_incompat &
 	    EXT2_FEATURE_INCOMPAT_META_BG)
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 68a8888..f99bea0 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -34,7 +34,7 @@ struct ext2_struct_inode_scan {
 	errcode_t		magic;
 	ext2_filsys		fs;
 	ext2_ino_t		current_inode;
-	blk_t			current_block;
+	blk64_t			current_block;
 	dgrp_t			current_group;
 	ext2_ino_t		inodes_left;
 	blk_t			blocks_left;
diff --git a/lib/ext2fs/progress.c b/lib/ext2fs/progress.c
index 1299ec7..65d027b 100644
--- a/lib/ext2fs/progress.c
+++ b/lib/ext2fs/progress.c
@@ -13,7 +13,7 @@
 #include "ext2fs.h"
 #include "ext2fsP.h"
 
-static int int_log10(unsigned long long int arg)
+static int int_log10(__u64 arg)
 {
 	int	l;
 

