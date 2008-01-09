From: Jan Kara <jack@suse.cz>
Subject: [PATCH resend] Fix reading of bitmaps from filesystem image
Date: Wed, 9 Jan 2008 20:54:35 +0100
Message-ID: <20080109195435.GD2215@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54383 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184AbYAITyg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 14:54:36 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

  I've sent you the attached fix some time ago but it didn't seem to get
merged yet...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Subject: Fix reading of bitmaps from filesystem image

Reading of bitmaps from image file could never work with more than one
group in a filesystem... Fix the loops so that we read appropriate number
of blocks.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1897ec3..abbe5e8 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -190,7 +190,7 @@ static errcode_t read_bitmaps(ext2_filsy
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE) {
 		blk = (fs->image_header->offset_inodemap / fs->blocksize);
 		ino_cnt = fs->super->s_inodes_count;
-		while (inode_nbytes > 0) {
+		while (do_inode && ino_cnt > 0) {
 			retval = io_channel_read_blk(fs->image_io, blk++,
 						     1, inode_bitmap);
 			if (retval)
@@ -202,15 +202,14 @@ static errcode_t read_bitmaps(ext2_filsy
 					       ino_itr, cnt, inode_bitmap);
 			if (retval)
 				goto cleanup;
-			ino_itr += fs->blocksize << 3;
-			ino_cnt -= fs->blocksize << 3;
-			inode_nbytes -= fs->blocksize;
+			ino_itr += cnt;
+			ino_cnt -= cnt;
 		}
 		blk = (fs->image_header->offset_blockmap /
 		       fs->blocksize);
 		blk_cnt = EXT2_BLOCKS_PER_GROUP(fs->super) * 
 			fs->group_desc_count;
-		while (block_nbytes > 0) {
+		while (do_block && blk_cnt > 0) {
 			retval = io_channel_read_blk(fs->image_io, blk++,
 						     1, block_bitmap);
 			if (retval)
@@ -222,9 +221,8 @@ static errcode_t read_bitmaps(ext2_filsy
 				       blk_itr, cnt, block_bitmap);
 			if (retval)
 				goto cleanup;
-			blk_itr += fs->blocksize << 3;
-			blk_cnt -= fs->blocksize << 3;
-			block_nbytes -= fs->blocksize;
+			blk_itr += cnt;
+			blk_cnt -= cnt;
 		}
 		goto success_cleanup;
 	}
