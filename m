From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/47] libext2fs: find inode goal when allocating blocks
Date: Sat, 13 Dec 2014 20:13:27 -0500
Message-ID: <20141214011327.GA29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215159.883.90273.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54768 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaLNBNb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 20:13:31 -0500
Content-Disposition: inline
In-Reply-To: <20141107215159.883.90273.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:59PM -0800, Darrick J. Wong wrote:
> +	if (inode->i_flags & EXT4_EXTENTS_FL) {
> +		err = ext2fs_extent_open2(fs, ino, inode, &handle);
> +		if (err)
> +			goto no_blocks;
> +		err = ext2fs_extent_goto2(handle, 0, lblk);
> +		if (err)
> +			goto extent_err;
> +		err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
> +		if (err)
> +			goto extent_err;
> +		return extent.e_pblk + (lblk - extent.e_lblk);

There's a memory leak here; the extent handle never gets freed.  I've
checked this in with the attached fix up patched.

BTW, a really useful way of checking for memory leaks and which
allowed me to confirm the problem after noticing the problem from
reviewing the patch (and showing that with the attached patch below
the leak went away):

cd tests; ./test_script --valgrind-leakcheck f_extents f_extents2
more /tmp/valgrind-*

Cheers,

					- Ted

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 57bf5f0..62b36fe 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -296,7 +296,7 @@ blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino,
 	dgrp_t			group;
 	__u8			log_flex;
 	struct ext2fs_extent	extent;
-	ext2_extent_handle_t	handle;
+	ext2_extent_handle_t	handle = NULL;
 	errcode_t		err;
 
 	if (inode == NULL || ext2fs_inode_data_blocks2(fs, inode) == 0)
@@ -311,14 +311,12 @@ blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino,
 			goto no_blocks;
 		err = ext2fs_extent_goto2(handle, 0, lblk);
 		if (err)
-			goto extent_err;
+			goto no_blocks;
 		err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
 		if (err)
-			goto extent_err;
-		return extent.e_pblk + (lblk - extent.e_lblk);
-extent_err:
+			goto no_blocks;
 		ext2fs_extent_free(handle);
-		goto no_blocks;
+		return extent.e_pblk + (lblk - extent.e_lblk);
 	}
 
 	/* block mapped file; see if block zero is mapped? */
@@ -326,6 +324,7 @@ extent_err:
 		return inode->i_block[0];
 
 no_blocks:
+	ext2fs_extent_free(handle);
 	log_flex = fs->super->s_log_groups_per_flex;
 	group = ext2fs_group_of_ino(fs, ino);
 	if (log_flex)
