From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/6] e2freefrag: Fix to work correctly for file systems with 1kb block sizes
Date: Sun,  9 Aug 2009 23:31:55 -0400
Message-ID: <1249875118-26291-4-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46051 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbZHJDcC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:02 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system has a non-zero s_first_data_block, as is the case
when the block size is 1kb, e2freefrag would incorrectly try to
reference invalid data blocks in the block allocation bitmap.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2freefrag.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index 274bf55..10a48ad 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -79,6 +79,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 	unsigned long long chunk_num;
 	unsigned long last_chunk_size = 0;
 	unsigned long long chunk_start_blk = 0;
+	int used;
 
 	for (chunk_num = 0; chunk_num < chunks; chunk_num++) {
 		unsigned long long blk, num_blks;
@@ -95,10 +96,13 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 		/* Initialize starting block for first chunk correctly else
 		 * there is a segfault when blocksize = 1024 in which case
 		 * block_map->start = 1 */
-		for (blk = (chunk_num == 0 ? fs->super->s_first_data_block : 0);
-		     blk < num_blks; blk++, chunk_start_blk++) {
-			int used = ext2fs_fast_test_block_bitmap(fs->block_map,
-							       chunk_start_blk);
+		for (blk = 0; blk < num_blks; blk++, chunk_start_blk++) {
+			if (chunk_num == 0 && blk == 0) {
+				blk = fs->super->s_first_data_block;
+				chunk_start_blk = blk;
+			}
+			used = ext2fs_fast_test_block_bitmap(fs->block_map,
+							     chunk_start_blk);
 			if (!used) {
 				last_chunk_size++;
 				chunk_free++;
-- 
1.6.3.2.1.gb9f7d.dirty

