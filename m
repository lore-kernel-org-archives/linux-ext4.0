From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix the length returned by fiemap for an unallocated extent
Date: Sat,  2 May 2009 19:10:46 -0400
Message-ID: <1241305846-12972-1-git-send-email-tytso@mit.edu>
References: <20090502230813.GC22191@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>,
	Carl Henrik Lunde <chlunde@ping.uio.no>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbZEBXKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 19:10:49 -0400
In-Reply-To: <20090502230813.GC22191@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file's blocks have not yet been allocated because of delayed
allocation, the length of the extent returned by fiemap is incorrect.
This commit fixes this bug.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 86c64ea..e963870 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3234,8 +3234,15 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
 	 */
 	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
-	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK)
+	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK) {
+		loff_t size = i_size_read(inode);
+		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
+
 		flags |= FIEMAP_EXTENT_LAST;
+		if ((flags & FIEMAP_EXTENT_DELALLOC) &&
+		    logical+length > size)
+			length = (size - logical + bs - 1) & ~(bs-1);
+	}
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
 					length, flags);
-- 
1.6.0.4

