From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] resize2fs: Fix corruption bug impacting ext4 filesystems with uninit_bg
Date: Sat, 18 Apr 2009 23:03:48 -0400
Message-ID: <1240110228-22781-4-git-send-email-tytso@mit.edu>
References: <1240110228-22781-1-git-send-email-tytso@mit.edu>
 <1240110228-22781-2-git-send-email-tytso@mit.edu>
 <1240110228-22781-3-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51489 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbZDSDDz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 23:03:55 -0400
In-Reply-To: <1240110228-22781-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Due to a fencepost bug, when skipping a block group whose block bitmap
was uninitialized (and hence could not contain any blocks eligible for
relaocation), the block immediately following the block group wasn't
checked as well.  If it was in use and required relocation, it
wouldn't get properly relocated, with the result that an inode using
such a block would end up, post resize, with a pointer to a block now
outside the bounds of the filesystem.

This commit fixes this fencepost error.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index ac926ce..f3e7fd0 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -804,7 +804,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 			 * to the next block group.
 			 */
 			blk = ((g+1) * fs->super->s_blocks_per_group) +
-				fs->super->s_first_data_block;
+				fs->super->s_first_data_block - 1;
 			continue;
 		}
 		if (ext2fs_test_block_bitmap(old_fs->block_map, blk) &&
-- 
1.5.6.3

