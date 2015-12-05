From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/8] filefrag: accommodate holes when calculating expected
 values
Date: Fri, 04 Dec 2015 18:44:55 -0800
Message-ID: <20151205024455.31087.21058.stgit@birch.djwong.org>
References: <20151205024416.31087.14808.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42761 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbbLECo7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 21:44:59 -0500
In-Reply-To: <20151205024416.31087.14808.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, filefrag's "expected physical block" column expects extent
records to be physically adjacent regardless of the amount of logical
block space between the two records.  This means that if we punch a
hole in a file, we get reports like this:

ext:   logical_offset:   physical_offset: length:  expected: flags:
4:     4096..    8343:   57376..  61623:   4248:
5:     8345..   10313:   61625..  63593:   1969:   61624:

Notice how it expects 8345 to map to 61624, and scores this against
the fragmentation of the file.  Flagging this as "unexpected" is
incorrect because the gap in the logical mapping is exactly the same
size as the gap in the physical extents.

Furthermore, this particular mapping leaves the door open to the
optimal mapping -- if a write to block 8344 causes it to be mapped to
61624, the entire range 4096-10313 can be mapped with a single extent.
Until that happens, there's no way to combine extents 4 and 5 because
of the gap in the logical mapping at block 8344.

Therefore, tweak the extent report to account for holes.

v2: Make it work for extents crossing FIEMAP calls, and clean up the
FIBMAP version to report correct expected values.

v3: Don't count physically but not logically contiguous extents
in the fragmentation summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/filefrag.c |   79 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 30 deletions(-)


diff --git a/misc/filefrag.c b/misc/filefrag.c
index 5bcde91..d89d3c9 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -208,9 +208,11 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 	__u64 buf[2048];	/* __u64 for proper field alignment */
 	struct fiemap *fiemap = (struct fiemap *)buf;
 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
+	struct fiemap_extent fm_last = {0};
 	int count = (sizeof(buf) - sizeof(*fiemap)) /
 			sizeof(struct fiemap_extent);
 	unsigned long long expected = 0;
+	unsigned long long expected_dense = 0;
 	unsigned long flags = 0;
 	unsigned int i;
 	int fiemap_header_printed = 0;
@@ -254,8 +256,13 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 		}
 
 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
+			expected_dense = fm_last.fe_physical +
+					 fm_last.fe_length;
+			expected = fm_last.fe_physical +
+				   fm_ext[i].fe_logical - fm_last.fe_logical;
 			if (fm_ext[i].fe_logical != 0 &&
-			    fm_ext[i].fe_physical != expected) {
+			    fm_ext[i].fe_physical != expected &&
+			    fm_ext[i].fe_physical != expected_dense) {
 				tot_extents++;
 			} else {
 				expected = 0;
@@ -265,10 +272,9 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
 			if (verbose)
 				print_extent_info(&fm_ext[i], n, expected,
 						  blk_shift, st);
-
-			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
 			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
 				last = 1;
+			fm_last = fm_ext[i];
 			n++;
 		}
 
@@ -287,14 +293,15 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 			   ext2fs_struct_stat *st,
 			   unsigned long numblocks, int is_ext2)
 {
-	struct fiemap_extent	fm_ext;
+	struct fiemap_extent	fm_ext, fm_last;
 	unsigned long		i, last_block;
-	unsigned long long	logical;
+	unsigned long long	logical, expected = 0;
 				/* Blocks per indirect block */
 	const long		bpib = st->st_blksize / 4;
 	int			count;
 
 	memset(&fm_ext, 0, sizeof(fm_ext));
+	memset(&fm_last, 0, sizeof(fm_last));
 	if (force_extent) {
 		fm_ext.fe_flags = FIEMAP_EXTENT_MERGED;
 	}
@@ -322,40 +329,52 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 			return rc;
 		if (block == 0)
 			continue;
-		if (*num_extents == 0) {
-			(*num_extents)++;
-			if (force_extent) {
+
+		if (*num_extents == 0 || block != last_block + 1 ||
+		    fm_ext.fe_logical + fm_ext.fe_length != logical) {
+			/*
+			 * This is the start of a new extent; figure out where
+			 * we expected it to be and report the extent.
+			 */
+			if (*num_extents != 0 && fm_last.fe_length) {
+				expected = fm_last.fe_physical +
+					(fm_ext.fe_logical - fm_last.fe_logical);
+				if (expected == fm_ext.fe_physical)
+					expected = 0;
+			}
+			if (force_extent && *num_extents == 0)
 				print_extent_header();
-				fm_ext.fe_physical = block * st->st_blksize;
+			if (force_extent && *num_extents != 0) {
+				print_extent_info(&fm_ext, *num_extents - 1,
+						  expected, blk_shift, st);
 			}
-		}
-		count++;
-		if (force_extent && last_block != 0 &&
-		    (block != last_block + 1 ||
-		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
-			print_extent_info(&fm_ext, *num_extents - 1,
-					  (last_block + 1) * st->st_blksize,
-					  blk_shift, st);
-			fm_ext.fe_length = 0;
+			if (verbose && expected != 0) {
+				printf("Discontinuity: Block %llu is at %llu "
+				       "(was %llu)\n",
+					fm_ext.fe_logical / st->st_blksize,
+					fm_ext.fe_physical / st->st_blksize,
+					expected / st->st_blksize);
+			}
+			/* create the new extent */
+			fm_last = fm_ext;
 			(*num_extents)++;
-			fm_ext.fe_logical = logical;
 			fm_ext.fe_physical = block * st->st_blksize;
-		} else if (last_block && (block != last_block + 1)) {
-			if (verbose)
-				printf("Discontinuity: Block %ld is at %lu (was "
-				       "%lu)\n", i, block, last_block + 1);
-			fm_ext.fe_length = 0;
-			(*num_extents)++;
 			fm_ext.fe_logical = logical;
-			fm_ext.fe_physical = block * st->st_blksize;
+			fm_ext.fe_length = 0;
 		}
 		fm_ext.fe_length += st->st_blksize;
 		last_block = block;
 	}
