From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 3/3] filefrag: print out physical extent length if set
Date: Wed, 30 Jul 2014 14:25:51 -0600
Message-ID: <1406751951-23059-3-git-send-email-adilger@dilger.ca>
References: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, David Sterba <dsterba@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-03.shaw.ca ([64.59.136.139]:1796 "EHLO
	smtp-out-03.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaG3UZz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 16:25:55 -0400
In-Reply-To: <1406751951-23059-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rename fe_length to be fe_logi_length to distinguish it from the
fe_phys_length field.

If FIEMAP_EXTENT_PHYS_LENGTH is set, then get the extent's physical
length from fe_phys_length instead of fe_logi_length, since it may
be different (if FIEMAP_EXTENT_DATA_COMPRESSED is also set).

If FIEMAP_EXTENT_PHYS_LENGTH is unset, then use fe_logi_length for
the extent length, but set fe_phys_length = fe_logi_length to simplify
the rest of the code.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/fiemap.h |    2 +-
 misc/filefrag.c     |   56 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index 30103e2..703f164 100644
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
index 7bd100c..b4913dd 100644
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
 	__u32 fe_flags, mask;
 	char flags[256] = "";
 
@@ -144,13 +148,19 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
 		blk_shift = 0;
 
-	ext_len = fm_extent->fe_length >> blk_shift;
-	ext_blks = (fm_extent->fe_length - 1) >> blk_shift;
 	logical_blk = fm_extent->fe_logical >> blk_shift;
+	logical_len = fm_extent->fe_logi_length >> blk_shift;
+	logical_unit = (fm_extent->fe_logi_length - 1) >> blk_shift;
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_UNKNOWN) {
 		physical_blk = 0;
+		physical_len = 0;
+		physical_unit = 0;
 	} else {
+		/* FIEMAP_EXTENT_PHYS_LENGTH was checked by caller
+		 * and fixed up fe_phys_length if unset. */
 		physical_blk = fm_extent->fe_physical >> blk_shift;
+		physical_len = fm_extent->fe_phys_length >> blk_shift;
+		physical_unit = (fm_extent->fe_phys_length - 1) >> blk_shift;
 	}
 
 	if (expected)
@@ -164,6 +174,7 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	print_flag(&fe_flags, FIEMAP_EXTENT_UNKNOWN, flags, "unknown_loc,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_DELALLOC, flags, "delalloc,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_ENCODED, flags, "encoded,");
+	print_flag(&fe_flags, FIEMAP_EXTENT_PHYS_LENGTH, flags, "phys_length,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_COMPRESSED, flags,
 								"compressed,");
 	print_flag(&fe_flags, FIEMAP_EXTENT_DATA_ENCRYPTED, flags,"encrypted,");
@@ -186,7 +197,7 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		print_flag(&fe_flags, mask, flags, hex);
 	}
 
-	if (fm_extent->fe_logical + fm_extent->fe_length >= st->st_size)
+	if (fm_extent->fe_logical + fm_extent->fe_logi_length >= st->st_size)
 		strcat(flags, "eof,");
 
 	/* Remove trailing comma, if any */
@@ -194,10 +205,10 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		flags[strnlen(flags, sizeof(flags)) - 1] = '\0';
 
 	printf(ext_fmt, cur_ex, logical_width, logical_blk,
-	       logical_width, logical_blk + ext_blks,
+	       logical_width, logical_blk + logical_unit,
 	       physical_width, physical_blk,
-	       physical_width, physical_blk + ext_blks,
-	       ext_len, flags);
+	       physical_width, physical_blk + physical_unit,
+	       logical_len, flags);
 }
 
 static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
@@ -260,18 +271,29 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 				if (!tot_extents)
 					tot_extents = 1;
 			}
+
+			/* If PHYS_LENGTH is set, then the logical and
+			 * physical extent lengths may be different (if
+			 * DATA_COMPRESSED flag is set) and fe_phys_length
+			 * is known to be valid.
+			 * Kernels older than 3.14 did not set fe_phys_length,
+			 * so do that here to simplify the rest of the code. */
+			if (!(fm_ext[i].fe_flags & FIEMAP_EXTENT_PHYS_LENGTH))
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
@@ -330,13 +352,14 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
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
 		} else if (last_block && (block != last_block + 1)) {
 			if (verbose)
@@ -344,7 +367,8 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 				       "%lu)\n", i, block, last_block + 1);
 			(*num_extents)++;
 		}
-		fm_ext.fe_length += st->st_blksize;
+		fm_ext.fe_logi_length += st->st_blksize;
+		fm_ext.fe_phys_length += st->st_blksize;
 		last_block = block;
 	}
 
-- 
1.7.3.4

