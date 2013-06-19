From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: move bitmaps if shrinking would orphan them
Date: Tue, 18 Jun 2013 20:37:05 -0500
Message-ID: <51C10B41.9020103@redhat.com>
References: <51C0FA44.3030600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Leonardo Menezes Vaz <lvaz@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687Ab3FSBhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 21:37:08 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5J1b7HO005499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 18 Jun 2013 21:37:07 -0400
In-Reply-To: <51C0FA44.3030600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is possible to have a flex_bg filesystem with block groups
which have inode & block bitmaps at some point well past the
start of the group.

If an offline shrink puts the new size somewhere between
the start of the block group and the (old) location of
the bitmaps, they can be left beyond the end of the filesystem,
i.e. result in fs corruption.

Check each remaining block group for whether its bitmaps
are beyond the end of the new filesystem, and reallocate
them in a new location if needed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I have no idea if this is the right approach or not ;)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index aa2364c..263dea1 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -854,6 +854,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	dgrp_t		i, max_groups, g;
 	blk64_t		blk, group_blk;
 	blk64_t		old_blocks, new_blocks;
+	blk64_t		new_size;
 	unsigned int	meta_bg, meta_bg_size;
 	errcode_t	retval;
 	ext2_filsys 	fs, old_fs;
@@ -882,6 +883,32 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	fs = rfs->new_fs;
 
 	/*
+	 * If we're shrinking the filesystem, we need to move any group's
+	 * bitmaps which are beyond the end of the new filesystem.
+	 */
+	new_size = ext2fs_blocks_count(fs->super);
+	if (ext2fs_blocks_count(fs->super) < ext2fs_blocks_count(old_fs->super)) {
+		for (g = 0; g < fs->group_desc_count; g++) {
+			/*
+			 * ext2fs_allocate_group_table re-allocates bitmaps
+			 * which are set to block 0.
+			 */
+			if (ext2fs_block_bitmap_loc(fs, g) >= new_size) {
+				ext2fs_block_bitmap_loc_set(fs, g, 0);
+				retval = ext2fs_allocate_group_table(fs, g, 0);
+				if (retval)
+					return retval;
+			} 
+			if (ext2fs_inode_bitmap_loc(fs, g) >= new_size) {
+				ext2fs_inode_bitmap_loc_set(fs, g, 0);
+				retval = ext2fs_allocate_group_table(fs, g, 0);
+				if (retval)
+					return retval;
+			} 
+		}
+	}
+
+	/*
 	 * If we're shrinking the filesystem, we need to move all of
 	 * the blocks that don't fit any more
 	 */


