From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] e2freefrag: Take into account the last free extent in the file system
Date: Sun,  9 Aug 2009 23:31:56 -0400
Message-ID: <1249875118-26291-5-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46048 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbZHJDcC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:02 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a bug in e2freefrag where if the last free extent is at the very
end of the filesystem, it would be disregarded.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2freefrag.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index 10a48ad..a4ab994 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -71,6 +71,24 @@ void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	}
 }
 
+void update_chunk_stats(struct chunk_info *info, unsigned long chunk_size)
+{
+	unsigned long index;
+
+	index = ul_log2(chunk_size) + 1;
+	if (index >= MAX_HIST)
+		index = MAX_HIST-1;
+	info->histogram.fc_chunks[index]++;
+	info->histogram.fc_blocks[index] += chunk_size;
+
+	if (chunk_size > info->max)
+		info->max = chunk_size;
+	if (chunk_size < info->min)
+		info->min = chunk_size;
+	info->avg += chunk_size;
+	info->real_free_chunks++;
+}
+
 void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 {
 	unsigned long long blocks_count = fs->super->s_blocks_count;
@@ -109,20 +127,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 			}
 
 			if (used && last_chunk_size != 0) {
-				unsigned long index;
-
-				index = ul_log2(last_chunk_size) + 1;
-				info->histogram.fc_chunks[index]++;
-				info->histogram.fc_blocks[index] +=
-							last_chunk_size;
-
-				if (last_chunk_size > info->max)
-					info->max = last_chunk_size;
-				if (last_chunk_size < info->min)
-					info->min = last_chunk_size;
-				info->avg += last_chunk_size;
-
-				info->real_free_chunks++;
+				update_chunk_stats(info, last_chunk_size);
 				last_chunk_size = 0;
 			}
 		}
@@ -130,6 +135,8 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 		if (chunk_free == info->blks_in_chunk)
 			info->free_chunks++;
 	}
+	if (last_chunk_size != 0)
+		update_chunk_stats(info, last_chunk_size);
 }
 
 errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
@@ -176,13 +183,19 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	       "Free Blocks", "Percent");
 	for (i = 0; i < MAX_HIST; i++) {
 		end = 1 << (i + info->blocksize_bits - units);
-		if (info->histogram.fc_chunks[i] != 0)
-			printf("%5lu%c...%5lu%c-  :  %12lu  %12lu  %6.2f%%\n",
-			       start, *unitp, end, *unitp,
+		if (info->histogram.fc_chunks[i] != 0) {
+			char end_str[32];
+
+			sprintf(end_str, "%5lu%c-", end, *unitp);
+			if (i == MAX_HIST-1)
+				strcpy(end_str, "max ");
+			printf("%5lu%c...%7s  :  %12lu  %12lu  %6.2f%%\n",
+			       start, *unitp, end_str,
 			       info->histogram.fc_chunks[i],
 			       info->histogram.fc_blocks[i],
 			       (double)info->histogram.fc_blocks[i] * 100 /
 			       fs->super->s_free_blocks_count);
+		}
 		start = end;
 		if (start == 1<<10) {
 			start = 1;
-- 
1.6.3.2.1.gb9f7d.dirty

