From: Theodore Tso <tytso@mit.edu>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Sat, 15 Nov 2008 00:50:17 -0500
Message-ID: <20081115055017.GO25117@mit.edu>
References: <200811141349.39160.aschultz@warp10.net> <20081114210612.GZ16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Schultz <aschultz@warp10.net>, linux-ext4@vger.kernel.org,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36492 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbYKOFuY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Nov 2008 00:50:24 -0500
Content-Disposition: inline
In-Reply-To: <20081114210612.GZ16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2008 at 02:06:12PM -0700, Andreas Dilger wrote:
> 
> Ah, it is trying to find free blocks, but the e2fsprogs allocator is very
> inefficient, IIRC, doing a linear scan of the filesystem.  We probably
> would be far better off to generate an RB tree of the block maps so that
> it is easier to work with lists of blocks that need to be moved or marked
> in use for the resized inode table.

We eventually could use a more sophisticated block allocator in the
ext2fs userspace library, but there's a quick fix should do the job
without having to do something more complicated.  The problem is that
the goal block is always reset to blk, which makes this an O(n**2)
operation in the number of in-use blocks in the filesystem.  This
following patch makes it be O(n), which should make it be a marked
improvement.

Running a profile analysis on tune2fs, there's another O(n*m)
operation in transalate_block() (yes, the function name is mispelled),
where n is the number of blocks that needs to be moved, and m is the
number of in-use blocks in the filesystems.

Fixing both of these should remove most of the user-space time that's
being burned by tune2fs -I 256.  There is still some CPU burned by the
undo file, and indeed we can probably speed this up some more by
omitting creating an undo entry when we're copying a data block to a
previously unused block.  But hopefully this should be enough to speed
up "tune2fs -I 256" for most people.

							- Ted

commit 27c6de45a4187a348ec0960472d4a113ee6ea425
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Nov 15 00:32:39 2008 -0500

    tune2fs: Fix inefficient O(n**2) algorithms when expanding the inode size
    
    When running "tune2fs -I 256" on moderate to large filesystems, the
    time required to run tune2fs can take many hours (20+ before some
    users gave up in disgust).  This was due to some O(n**2) and O(n*m)
    algorithms in move_block() and inode_scan_and_fix(), respectively.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b29b344..e72518a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1011,13 +1011,13 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 	if (retval)
 		return retval;
 
-	for (blk = fs->super->s_first_data_block;
-			blk < fs->super->s_blocks_count; blk++) {
+	for (new_blk = blk = fs->super->s_first_data_block;
+	     blk < fs->super->s_blocks_count; blk++) {
 
 		if (!ext2fs_test_block_bitmap(bmap, blk))
 			continue;
 
-		retval = ext2fs_new_block(fs, blk, NULL, &new_blk);
+		retval = ext2fs_new_block(fs, new_blk, NULL, &new_blk);
 		if (retval)
 			goto err_out;
 
@@ -1068,12 +1068,14 @@ static int process_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 			 e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
 			 blk_t ref_block EXT2FS_ATTR((unused)),
 			 int ref_offset EXT2FS_ATTR((unused)),
-			 void *priv_data EXT2FS_ATTR((unused)))
+			 void *priv_data)
 {
 	int ret = 0;
 	blk_t new_blk;
+	ext2fs_block_bitmap bmap = (ext2fs_block_bitmap) priv_data;
 
-
+	if (!ext2fs_test_block_bitmap(bmap, *block_nr))
+		return 0;
 	new_blk = transalate_block(*block_nr);
 	if (new_blk) {
 		*block_nr = new_blk;
@@ -1086,7 +1088,7 @@ static int process_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	return ret;
 }
 
-static int inode_scan_and_fix(ext2_filsys fs)
+static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 {
 	errcode_t retval = 0;
 	ext2_ino_t ino;
@@ -1122,8 +1124,8 @@ static int inode_scan_and_fix(ext2_filsys fs)
 		 * Do we need to fix this ??
 		 */
 
-		if (inode.i_file_acl) {
-
+		if (inode.i_file_acl &&
+		    ext2fs_test_block_bitmap(bmap, inode.i_file_acl)) {
 			blk = transalate_block(inode.i_file_acl);
 			if (!blk)
 				continue;
@@ -1142,9 +1144,8 @@ static int inode_scan_and_fix(ext2_filsys fs)
 		if (!ext2fs_inode_has_valid_blocks(&inode))
 			continue;
 
-		retval = ext2fs_block_iterate2(fs, ino, 0,
-						block_buf, process_block,
-						0);
+		retval = ext2fs_block_iterate2(fs, ino, 0, block_buf,
+					       process_block, bmap);
 		if (retval)
 			goto err_out;
 
@@ -1344,7 +1345,7 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 	if (retval)
 		goto err_out;
 
-	retval = inode_scan_and_fix(fs);
+	retval = inode_scan_and_fix(fs, bmap);
 	if (retval)
 		goto err_out;
 

