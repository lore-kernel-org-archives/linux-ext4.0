From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/15] libext2fs: fix error path in
 ext2fs_update_bb_inode()
Date: Mon, 20 Dec 2010 11:01:16 -0500
Message-ID: <20101220160116.GN23626@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-8-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35728 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab0LTQBS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Dec 2010 11:01:18 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-8-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:09PM +0900, Namhyung Kim wrote:
> If ext2fs_get_mem() on rec.block_buf fails we should not call
> ext2fs_free_mem() on it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks for pointing this out.  I fixed this in a slightly simpler way.

       	   	    	       	       	    - Ted

commit 2150278fa25f3fe8b8f29835ccd3079b608bb825
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 20 10:57:29 2010 -0500

    libext2fs: fix potential free() of garbage in ext2fs_update_bb_inode()
    
    There was a potential of freeing an uninitialized pointer in
    rec.block_buf, which was pointed out by Namhyung Kim <namhyung@gmail.com>
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 0b79b16..0b6c3dd 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -65,8 +65,7 @@ errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 	if (!fs->block_map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
 
-	rec.bad_block_count = 0;
-	rec.ind_blocks_size = rec.ind_blocks_ptr = 0;
+	memset(&rec, 0, sizeof(rec));
 	rec.max_ind_blocks = 10;
 	retval = ext2fs_get_array(rec.max_ind_blocks, sizeof(blk_t),
 				&rec.ind_blocks);
