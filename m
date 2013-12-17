From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 4/4] filefrag: print out physical extent length if set
Date: Mon, 16 Dec 2013 18:05:31 -0700
Message-ID: <1387242331-29227-4-git-send-email-adilger@dilger.ca>
References: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:25965 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3LQBPN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 20:15:13 -0500
In-Reply-To: <1387242331-29227-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rename fe_length to be fe_logi_length to distinguish it from the
fe_phys_length field.

If the extent's physical length is different from its logical length
(if FIEMAP_EXTENT_DATA_COMPRESSED is set) then use the fe_phys_length
for the physical length.  If FIEMAP_EXTENT_DATA_COMPRESSED is unset,
then continue to use fe_logi_length for the extent length, but set
fe_phys_length = fe_logi_length to simplify the rest of the code.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/fiemap.h |    2 +-
 misc/filefrag.c     |   62 +++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index df973da..3cf32f7 100644
--- a/lib/ext2fs/fiemap.h
+++ b/lib/ext2fs/fiemap.h
@@ -16,7 +16,7 @@ struct fiemap_extent {
 			    * the extent from the beginning of the file */
 	__u64 fe_physical; /* physical offset in bytes for the start
 			    * of the extent from the beginning of the disk */
-	__u64 fe_length;   /* length in bytes for this extent */
+	__u64 fe_logi_length; /* logical length in bytes for this extent */
 	__u64 fe_phys_length; /* physical length in bytes for this extent,
 			       * undefined if DATA_COMPRESSED not set */
 	__u64 fe_reserved64;
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 7096abb..6cefaf4 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -133,10 +133,14 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 			      unsigned long long expected, int blk_shift,
 			      ext2fs_struct_stat *st)
 {
-	unsigned long long physical_blk;
-	unsigned long long logical_blk;
-	unsigned long long ext_len;
-	unsigned long long ext_blks;
+	unsigned long long logical_blk;	/* logical starting block of file */
+	unsigned long long logical_len;	/* logical length of extent in blocks */
+	unsigned long long logical_unit;/* logical length to end of extent, may
+					 * not be logical_len-1 if extent isn't
+					 * aligned to requested block size */
+	unsigned long long physical_blk;/* physical starting block in LUN */
+	unsigned long long physical_len;/* physical length of extent in blocks*/
+	unsigned long long physical_unit;/* physical length to end of extent */
 	__u32 flags, mask;
 	char buf[256] = "";
 
@@ -145,10 +149,20 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	if (flags & FIEMAP_EXTENT_DATA_INLINE)
 		blk_shift = 0;
 
-	ext_len = fm_extent->fe_length >> blk_shift;
-	ext_blks = (fm_extent->fe_length - 1) >> blk_shift;
 	logical_blk = fm_extent->fe_logical >> blk_shift;
-	physical_blk = fm_extent->fe_physical >> blk_shift;
+	logical_len = fm_extent->fe_logi_length >> blk_shift;
+	logical_unit = (fm_extent->fe_logi_length - 1) >> blk_shift;
+	if (flags & FIEMAP_EXTENT_UNKNOWN) {
+		physical_blk = 0;
+		physical_len = 0;
+		physical_unit = 0;
+	} else {
+		/* FIEMAP_EXTENT_DATA_COMPRESSED was checked by caller
+		 * and fixed up fe_phys_length if unset. */
+		physical_blk = fm_extent->fe_physical >> blk_shift;
+		physical_len = fm_extent->fe_phys_length >> blk_shift;
+		physical_unit = (fm_extent->fe_phys_length - 1) >> blk_shift;
+	}
 
 	if (expected)
 		sprintf(buf, ext_fmt == hex_fmt ? "%*llx: " : "%*llu: ",
@@ -176,7 +190,8 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		print_flag(&flags, mask, buf, hex);
 	}
 
-	if (fm_extent->fe_logical + fm_extent->fe_length >= (__u64) st->st_size)
+	if (fm_extent->fe_logical + fm_extent->fe_logi_length >=
+	    (__u64)st->st_size)
 		strcat(buf, "eof,");
 
 	/* Remove trailing comma, if any */
@@ -184,10 +199,10 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		buf[strlen(buf) - 1] = '\0';
 
 	printf(ext_fmt, cur_ex, logical_width, logical_blk,
-	       logical_width, logical_blk + ext_blks,
+	       logical_width, logical_blk + logical_unit,
 	       physical_width, physical_blk,
-	       physical_width, physical_blk + ext_blks,
-	       ext_len, flags);
+	       physical_width, physical_blk + physical_unit,
+	       logical_len, buf);
 }
 
 static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
@@ -250,18 +265,29 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 				if (!tot_extents)
 					tot_extents = 1;
 			}
+
+			/* If DATA_COMPRESSED is set, then the logical and
+			 * physical extent lengths are different and the
+			 * fe_phys_length field is known to be valid.
+			 * Kernels older than 3.14 did not set fe_phys_length,
+			 * so do that here to simplify the rest of the code. */
+			if (!(fm_ext[i].fe_flags &
+			      FIEMAP_EXTENT_DATA_COMPRESSED))
+				fm_ext[i].fe_phys_length =
+					fm_ext[i].fe_logi_length;
+
 			if (verbose)
 				print_extent_info(&fm_ext[i], n, expected,
 						  blk_shift, st);
-
-			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
+			expected = fm_ext[i].fe_physical +
+				   fm_ext[i].fe_phys_length;
 			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
 				last = 1;
 			n++;
 		}
 
 		fiemap->fm_start = (fm_ext[i - 1].fe_logical +
-				    fm_ext[i - 1].fe_length);
+				    fm_ext[i - 1].fe_logi_length);
 	} while (last == 0);
 
 	*num_extents = tot_extents;
@@ -335,20 +361,22 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 		count++;
 		if (force_extent && last_block != 0 &&
 		    (block != last_block + 1 ||
-		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
+		     fm_ext.fe_logical + fm_ext.fe_logi_length != logical)) {
 			print_extent_info(&fm_ext, *num_extents - 1,
 					  (last_block + 1) * st->st_blksize,
 					  blk_shift, st);
 			fm_ext.fe_logical = logical;
 			fm_ext.fe_physical = block * st->st_blksize;
-			fm_ext.fe_length = 0;
+			fm_ext.fe_logi_length = 0;
+			fm_ext.fe_phys_length = 0;
 			(*num_extents)++;
 		} else if (verbose && last_block && (block != last_block + 1)) {
 			printf("Discontinuity: Block %ld is at %lu (was %lu)\n",
 			       i, block, last_block + 1);
 			(*num_extents)++;
 		}
-		fm_ext.fe_length += st->st_blksize;
+		fm_ext.fe_logi_length += st->st_blksize;
+		fm_ext.fe_phys_length += st->st_blksize;
 		last_block = block;
 	}
 
-- 
1.7.3.4

