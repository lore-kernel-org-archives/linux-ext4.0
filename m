From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] e2freefrag: Clarify e2freefrag's messages
Date: Sun,  9 Aug 2009 23:31:53 -0400
Message-ID: <1249875118-26291-2-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46044 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZHJDcB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:01 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Free chunks" is confusing since it has nothing to do with the
chunksize; use "free extents" instead.

Also add a missing newline in an error message.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2freefrag.8.in |   10 +++++-----
 misc/e2freefrag.c    |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/misc/e2freefrag.8.in b/misc/e2freefrag.8.in
index 9c47e97..77fadd7 100644
--- a/misc/e2freefrag.8.in
+++ b/misc/e2freefrag.8.in
@@ -54,16 +54,16 @@ Total chunks: 5876
 Free chunks: 463 (7.9%)
 .br
 
-Min free chunk: 4 KB
+Min. free extent: 4 KB
 .br
-Max free chunk: 24008 KB
+Max. free extent: 24008 KB
 .br
-Avg free chunk: 252 KB
+Avg. free extent: 252 KB
 .br
 
-HISTOGRAM OF FREE CHUNK SIZES:
+HISTOGRAM OF FREE EXTENT SIZES:
 .br
-Chunk Size Range :   Free chunks   Free Blocks  Percent
+Extent Size Range :   Free extents   Free Blocks  Percent
 .br
     4K...    8K- :           704           704     0.2%
 .br
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index df41853..9e7b617 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -156,16 +156,16 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 		info->min = 0;
 	}
 
-	printf("\nMin free chunk: %lu KB \nMax free chunk: %lu KB\n"
-	       "Avg free chunk: %lu KB\n", info->min, info->max, info->avg);
+	printf("\nMin. free extent: %lu KB \nMax. free extent: %lu KB\n"
+	       "Avg. free extent: %lu KB\n", info->min, info->max, info->avg);
 
-	printf("\nHISTOGRAM OF FREE CHUNK SIZES:\n");
-	printf("%s :  %12s  %12s  %7s\n", "Chunk Size Range", "Free chunks",
+	printf("\nHISTOGRAM OF FREE EXTENT SIZES:\n");
+	printf("%s :  %12s  %12s  %7s\n", "Extent Size Range", "Free extents",
 	       "Free Blocks", "Percent");
 	for (i = 0; i < MAX_HIST; i++) {
 		end = 1 << (i + info->blocksize_bits - units);
 		if (info->histogram.fc_chunks[i] != 0)
-			printf("%5lu%c...%5lu%c- :  %12lu  %12lu  %6.2f%%\n",
+			printf("%5lu%c...%5lu%c-  :  %12lu  %12lu  %6.2f%%\n",
 			       start, *unitp, end, *unitp,
 			       info->histogram.fc_chunks[i],
 			       info->histogram.fc_blocks[i],
@@ -250,7 +250,7 @@ int main(int argc, char *argv[])
 			if (chunk_info.chunkbytes &
 			    (chunk_info.chunkbytes - 1)) {
 				fprintf(stderr, "%s: chunk size must be a "
-					"power of 2.", argv[0]);
+					"power of 2.\n", argv[0]);
 				usage(progname);
 			}
 			chunk_info.chunkbytes *= 1024;
-- 
1.6.3.2.1.gb9f7d.dirty

