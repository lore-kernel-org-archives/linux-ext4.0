From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] resize2fs: fix -M size calculations to avoid cutting off the inode table
Date: Mon, 30 Sep 2013 23:59:32 -0400
Message-ID: <1380599974-2886-2-git-send-email-tytso@mit.edu>
References: <20131001015746.GF5845@thunk.org>
 <1380599974-2886-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40494 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab3JAD7m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 23:59:42 -0400
In-Reply-To: <1380599974-2886-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system's inode table blocks in the last block group are
located in the middle or the end of the block group, it's possible for
resize2fs -M to use a size which will require relocating the inode
table blocks in the last block group.  This can lead to all sorts of
problems, so solve it by simply guaranteeing that we will never do
that.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 51b85b8..1e4ac19 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2224,6 +2224,15 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	blks_needed = (groups-1) * EXT2_BLOCKS_PER_GROUP(fs->super);
 	blks_needed += overhead;
 
+	/*
+	 * Make sure blks_needed covers the end of the inode table in
+	 * the last block group.
+	 */
+	overhead = ext2fs_inode_table_loc(fs, groups-1) +
+		fs->inode_blocks_per_group;
+	if (blks_needed < overhead)
+		blks_needed = overhead;
+
 #ifdef RESIZE2FS_DEBUG
 	if (flags & RESIZE_DEBUG_MIN_CALC)
 		printf("Estimated blocks needed: %llu\n", blks_needed);
-- 
1.7.12.rc0.22.gcdd159b

