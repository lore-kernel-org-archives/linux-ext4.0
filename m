From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: move bitmaps if shrinking would orphan them
Date: Thu, 20 Jun 2013 22:47:07 -0400
Message-ID: <20130621024707.GC10730@thunk.org>
References: <51C0FA44.3030600@redhat.com>
 <51C10B41.9020103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Leonardo Menezes Vaz <lvaz@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59965 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965231Ab3FUCrM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 22:47:12 -0400
Content-Disposition: inline
In-Reply-To: <51C10B41.9020103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 18, 2013 at 08:37:05PM -0500, Eric Sandeen wrote:
> It is possible to have a flex_bg filesystem with block groups
> which have inode & block bitmaps at some point well past the
> start of the group.
> 
> If an offline shrink puts the new size somewhere between
> the start of the block group and the (old) location of
> the bitmaps, they can be left beyond the end of the filesystem,
> i.e. result in fs corruption.
> 
> Check each remaining block group for whether its bitmaps
> are beyond the end of the new filesystem, and reallocate
> them in a new location if needed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good, thanks for the patch.  I made a few minor changes to fix
up some extra whitespace and a minor optimization.

   	      		       	     - Ted

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 28131c2..204b10a 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -889,7 +889,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	 * bitmaps which are beyond the end of the new filesystem.
 	 */
 	new_size = ext2fs_blocks_count(fs->super);
-	if (ext2fs_blocks_count(fs->super) < ext2fs_blocks_count(old_fs->super)) {
+	if (new_size < ext2fs_blocks_count(old_fs->super)) {
 		for (g = 0; g < fs->group_desc_count; g++) {
 			/*
 			 * ext2fs_allocate_group_table re-allocates bitmaps
@@ -900,13 +900,13 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 				retval = ext2fs_allocate_group_table(fs, g, 0);
 				if (retval)
 					return retval;
-			} 
+			}
 			if (ext2fs_inode_bitmap_loc(fs, g) >= new_size) {
 				ext2fs_inode_bitmap_loc_set(fs, g, 0);
 				retval = ext2fs_allocate_group_table(fs, g, 0);
 				if (retval)
 					return retval;
-			} 
+			}
 		}
 	}
 
