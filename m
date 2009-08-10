From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6] e2freefrag: Do not print chunk-related information by default
Date: Sun,  9 Aug 2009 23:31:54 -0400
Message-ID: <1249875118-26291-3-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46041 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZHJDcB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:01 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Only print information related to chunk sizes if a chunksize is
printed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2freefrag.8.in |   13 +++++--------
 misc/e2freefrag.c    |   30 +++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/misc/e2freefrag.8.in b/misc/e2freefrag.8.in
index 77fadd7..56fdbff 100644
--- a/misc/e2freefrag.8.in
+++ b/misc/e2freefrag.8.in
@@ -30,9 +30,12 @@ can be used to gauge the level of free space fragmentation in the filesystem.
 .SH OPTIONS
 .TP
 .BI \-c " chunk_kb"
-Desired size of chunk. It is specified in units of kilobytes (KB). If no
+If a chunk size is specified, then
+.B e2freefrag
+will print how many free chunks of size
 .I chunk_kb
-is specified on the command line, then the default value is 1024KB.
+are available in units of kilobytes (Kb).  The chunk size must be a
+power of two and be larger than filesystem block size.
 .TP
 .BI \-h
 Print the usage of the program.
@@ -47,12 +50,6 @@ Total blocks: 1504085
 .br
 Free blocks: 292995 (19.5%)
 .br
-Chunk size: 1048576 bytes (256 blocks)
-.br
-Total chunks: 5876
-.br
-Free chunks: 463 (7.9%)
-.br
 
 Min. free extent: 4 KB
 .br
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index 9e7b617..274bf55 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -52,9 +52,14 @@ void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
 {
 	int i;
 
-	info->chunkbits = ul_log2(info->chunkbytes);
 	info->blocksize_bits = ul_log2((unsigned long)fs->blocksize);
-	info->blks_in_chunk = info->chunkbytes >> info->blocksize_bits;
+	if (info->chunkbytes) {
+		info->chunkbits = ul_log2(info->chunkbytes);
+		info->blks_in_chunk = info->chunkbytes >> info->blocksize_bits;
+	} else {
+		info->chunkbits = ul_log2(DEFAULT_CHUNKSIZE);
+		info->blks_in_chunk = DEFAULT_CHUNKSIZE >> info->blocksize_bits;
+	}
 
 	info->min = ~0UL;
 	info->max = info->avg = 0;
@@ -138,13 +143,16 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	       (double)fs->super->s_free_blocks_count * 100 /
 						fs->super->s_blocks_count);
 
-	printf("\nChunksize: %lu bytes (%u blocks)\n",
-	       info->chunkbytes, info->blks_in_chunk);
-	total_chunks = (fs->super->s_blocks_count + info->blks_in_chunk) >>
-				(info->chunkbits - info->blocksize_bits);
-	printf("Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
-	       total_chunks, info->free_chunks,
-	       (double)info->free_chunks * 100 / total_chunks);
+	if (info->chunkbytes) {
+		printf("\nChunksize: %lu bytes (%u blocks)\n",
+		       info->chunkbytes, info->blks_in_chunk);
+		total_chunks = (fs->super->s_blocks_count +
+				info->blks_in_chunk) >>
+			(info->chunkbits - info->blocksize_bits);
+		printf("Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
+		       total_chunks, info->free_chunks,
+		       (double)info->free_chunks * 100 / total_chunks);
+	}
 
 	/* Display chunk information in KB */
 	if (info->real_free_chunks) {
@@ -228,7 +236,7 @@ void open_device(char *device_name, ext2_filsys *fs)
 
 int main(int argc, char *argv[])
 {
-	struct chunk_info chunk_info = { .chunkbytes = DEFAULT_CHUNKSIZE };
+	struct chunk_info chunk_info = { };
 	errcode_t retval = 0;
 	ext2_filsys fs = NULL;
 	char *device_name;
@@ -273,7 +281,7 @@ int main(int argc, char *argv[])
 
 	open_device(device_name, &fs);
 
-	if (chunk_info.chunkbytes < fs->blocksize) {
+	if (chunk_info.chunkbytes && (chunk_info.chunkbytes < fs->blocksize)) {
 		fprintf(stderr, "%s: chunksize must be greater than or equal "
 			"to filesystem blocksize.\n", progname);
 		exit(1);
-- 
1.6.3.2.1.gb9f7d.dirty

