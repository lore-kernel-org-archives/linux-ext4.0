From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/4] filefrag: improve extent flags printing
Date: Mon, 16 Dec 2013 18:05:29 -0700
Message-ID: <1387242331-29227-2-git-send-email-adilger@dilger.ca>
References: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:25965 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3LQBPK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 20:15:10 -0500
In-Reply-To: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Improve the handling of printing extent flags in verbose mode.
For unknown flags, print out the flag value in hexadecimal.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/filefrag.c |   60 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 18dc1e5..6289899 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -120,6 +120,15 @@ static void print_extent_header(void)
 	       "expected:");
 }
 
+static void print_flag(__u32 *flags, __u32 mask, char *buf, const char *name)
+{
+	if ((*flags & mask) == 0)
+		return;
+
+	strcat(buf, name);
+	*flags &= ~mask;
+}
+
 static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 			      unsigned long long expected, int blk_shift,
 			      ext2fs_struct_stat *st)
@@ -128,10 +137,12 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	unsigned long long logical_blk;
 	unsigned long long ext_len;
 	unsigned long long ext_blks;
-	char flags[256] = "";
+	__u32 flags, mask;
+	char buf[256] = "";
 
+	flags = fm_extent->fe_flags;
 	/* For inline data all offsets should be in bytes, not blocks */
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
+	if (flags & FIEMAP_EXTENT_DATA_INLINE)
 		blk_shift = 0;
 
 	ext_len = fm_extent->fe_length >> blk_shift;
@@ -140,34 +151,35 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	physical_blk = fm_extent->fe_physical >> blk_shift;
 
 	if (expected)
-		sprintf(flags, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
+		sprintf(buf, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
 			physical_width, expected >> blk_shift);
 	else
-		sprintf(flags, "%.*s  ", physical_width, "                   ");
-
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN)
-		strcat(flags, "unknown,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DELALLOC)
-		strcat(flags, "delalloc,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_ENCRYPTED)
-		strcat(flags, "encrypted,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_NOT_ALIGNED)
-		strcat(flags, "not_aligned,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
-		strcat(flags, "inline,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_TAIL)
-		strcat(flags, "tail_packed,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
-		strcat(flags, "unwritten,");
-	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
-		strcat(flags, "merged,");
+		sprintf(buf, "%.*s  ", physical_width, "                   ");
+
+	print_flag(&flags, FIEMAP_EXTENT_UNKNOWN, buf, "unknown,");
+	print_flag(&flags, FIEMAP_EXTENT_DELALLOC, buf, "delalloc,");
+	print_flag(&flags, FIEMAP_EXTENT_DATA_ENCRYPTED, buf, "encrypted,");
+	print_flag(&flags, FIEMAP_EXTENT_NOT_ALIGNED, buf, "not_aligned,");
+	print_flag(&flags, FIEMAP_EXTENT_DATA_INLINE, buf, "inline,");
+	print_flag(&flags, FIEMAP_EXTENT_DATA_TAIL, buf, "tail_packed,");
+	print_flag(&flags, FIEMAP_EXTENT_UNWRITTEN, buf, "unwritten,");
+	print_flag(&flags, FIEMAP_EXTENT_MERGED, buf, "merged,");
+	print_flag(&flags, FIEMAP_EXTENT_LAST, buf, "last,");
+	/* Print unknown flags in hex format.  Known flags are already printed
+	 * above and will have their bit cleared from "flags". */
+	for (mask = 1; flags != 0 && mask != 0; mask <<= 1) {
+		char hex[6];
+
+		sprintf(hex, "%04x,", mask);
+		print_flag(&flags, mask, buf, hex);
+	}
 
 	if (fm_extent->fe_logical + fm_extent->fe_length >= (__u64) st->st_size)
-		strcat(flags, "eof,");
+		strcat(buf, "eof,");
 
 	/* Remove trailing comma, if any */
-	if (flags[0])
-		flags[strlen(flags) - 1] = '\0';
+	if (buf[0])
+		buf[strlen(buf) - 1] = '\0';
 
 	printf(ext_fmt, cur_ex, logical_width, logical_blk,
 	       logical_width, logical_blk + ext_blks,
-- 
1.7.3.4

