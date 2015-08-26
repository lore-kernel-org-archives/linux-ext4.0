From: Jan Kara <jack@suse.com>
Subject: [PATCH 19/21] resize2fs: Remove extent mapping code
Date: Wed, 26 Aug 2015 18:22:34 +0200
Message-ID: <1440606156-5754-20-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbbHZQW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:59 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Extent mapping code is now in libext2fs. Remove a special version from
resize2fs.

Signed-off-by: Jan Kara <jack@suse.com>
---
 resize/Makefile.in |   8 +-
 resize/extent.c    | 241 -----------------------------------------------------
 resize/resize2fs.h |  11 ---
 3 files changed, 3 insertions(+), 257 deletions(-)
 delete mode 100644 resize/extent.c

diff --git a/resize/Makefile.in b/resize/Makefile.in
index ecd8619e55a5..82ae57adc4c5 100644
--- a/resize/Makefile.in
+++ b/resize/Makefile.in
@@ -16,13 +16,11 @@ PROGS=		resize2fs
 TEST_PROGS=	test_extent
 MANPAGES=	resize2fs.8
 
-RESIZE_OBJS= extent.o resize2fs.o main.o online.o resource_track.o \
-		sim_progress.o
+RESIZE_OBJS= resize2fs.o main.o online.o resource_track.o sim_progress.o
 
-TEST_EXTENT_OBJS= extent.o test_extent.o
+TEST_EXTENT_OBJS= test_extent.o
 
-SRCS= $(srcdir)/extent.c \
-	$(srcdir)/resize2fs.c \
+SRCS= $(srcdir)/resize2fs.c \
 	$(srcdir)/main.c \
 	$(srcdir)/online.c \
 	$(srcdir)/resource_track.c \
diff --git a/resize/extent.c b/resize/extent.c
deleted file mode 100644
index ec81b944e94a..000000000000
--- a/resize/extent.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/*
- * extent.c --- ext2 extent abstraction
- *
- * This abstraction is used to provide a compact way of representing a
- * translation table, for moving multiple contiguous ranges (extents)
- * of blocks or inodes.
- *
- * Copyright (C) 1997, 1998 by Theodore Ts'o and
- * 	PowerQuest, Inc.
- *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
- *
- * %Begin-Header%
- * This file may be redistributed under the terms of the GNU Public
- * License.
- * %End-Header%
- */
-
-#include "config.h"
-#include "resize2fs.h"
-
-struct ext2_extent_entry {
-	__u64	old_loc, new_loc;
-	__u64	size;
-};
-
-struct _ext2_extent {
-	struct ext2_extent_entry *list;
-	__u64	cursor;
-	__u64	size;
-	__u64	num;
-	__u64	sorted;
-};
-
-/*
- * Create an extent table
- */
-errcode_t ext2fs_create_extent_table(ext2_extent *ret_extent, __u64 size)
-{
-	ext2_extent	extent;
-	errcode_t	retval;
-
-	retval = ext2fs_get_mem(sizeof(struct _ext2_extent), &extent);
-	if (retval)
-		return retval;
-	memset(extent, 0, sizeof(struct _ext2_extent));
-
-	extent->size = size ? size : 50;
-	extent->cursor = 0;
-	extent->num = 0;
-	extent->sorted = 1;
-
-	retval = ext2fs_get_array(sizeof(struct ext2_extent_entry),
-				extent->size, &extent->list);
-	if (retval) {
-		ext2fs_free_mem(&extent);
-		return retval;
-	}
-	memset(extent->list, 0,
-	       sizeof(struct ext2_extent_entry) * extent->size);
-	*ret_extent = extent;
-	return 0;
-}
-
-/*
- * Free an extent table
- */
-void ext2fs_free_extent_table(ext2_extent extent)
-{
-	if (extent->list)
-		ext2fs_free_mem(&extent->list);
-	extent->list = 0;
-	extent->size = 0;
-	extent->num = 0;
-	ext2fs_free_mem(&extent);
-}
-
-/*
- * Add an entry to the extent table
- */
-errcode_t ext2fs_add_extent_entry(ext2_extent extent, __u64 old_loc, __u64 new_loc)
-{
-	struct	ext2_extent_entry	*ent;
-	errcode_t			retval;
-	__u64				newsize;
-	__u64				curr;
-
-	if (extent->num >= extent->size) {
-		newsize = extent->size + 100;
-		retval = ext2fs_resize_mem(sizeof(struct ext2_extent_entry) *
-					   extent->size,
-					   sizeof(struct ext2_extent_entry) *
-					   newsize, &extent->list);
-		if (retval)
-			return retval;
-		extent->size = newsize;
-	}
-	curr = extent->num;
-	ent = extent->list + curr;
-	if (curr) {
-		/*
-		 * Check to see if this can be coalesced with the last
-		 * extent
-		 */
-		ent--;
-		if ((ent->old_loc + ent->size == old_loc) &&
-		    (ent->new_loc + ent->size == new_loc)) {
-			ent->size++;
-			return 0;
-		}
-		/*
-		 * Now see if we're going to ruin the sorting
-		 */
-		if (ent->old_loc + ent->size > old_loc)
-			extent->sorted = 0;
-		ent++;
-	}
-	ent->old_loc = old_loc;
-	ent->new_loc = new_loc;
-	ent->size = 1;
-	extent->num++;
-	return 0;
-}
-
-/*
- * Helper function for qsort
- */
-static EXT2_QSORT_TYPE extent_cmp(const void *a, const void *b)
-{
-	const struct ext2_extent_entry *db_a;
-	const struct ext2_extent_entry *db_b;
-
-	db_a = (const struct ext2_extent_entry *) a;
-	db_b = (const struct ext2_extent_entry *) b;
-
-	return (db_a->old_loc - db_b->old_loc);
-}
-
-/*
- * Given an inode map and inode number, look up the old inode number
- * and return the new inode number.
- */
-__u64 ext2fs_extent_translate(ext2_extent extent, __u64 old_loc)
-{
-	__s64	low, high, mid;
-	__u64	lowval, highval;
-	float	range;
-
-	if (!extent->sorted) {
-		qsort(extent->list, extent->num,
-		      sizeof(struct ext2_extent_entry), extent_cmp);
-		extent->sorted = 1;
-	}
-	low = 0;
-	high = extent->num-1;
-	while (low <= high) {
-#if 0
-		mid = (low+high)/2;
-#else
-		if (low == high)
-			mid = low;
-		else {
-			/* Interpolate for efficiency */
-			lowval = extent->list[low].old_loc;
-			highval = extent->list[high].old_loc;
-
-			if (old_loc < lowval)
-				range = 0;
-			else if (old_loc > highval)
-				range = 1;
-			else {
-				range = ((float) (old_loc - lowval)) /
-					(highval - lowval);
-				if (range > 0.9)
-					range = 0.9;
-				if (range < 0.1)
-					range = 0.1;
-			}
-			mid = low + ((__u64) (range * (high-low)));
-		}
-#endif
-		if ((old_loc >= extent->list[mid].old_loc) &&
-		    (old_loc < extent->list[mid].old_loc + extent->list[mid].size))
-			return (extent->list[mid].new_loc +
-				(old_loc - extent->list[mid].old_loc));
-		if (old_loc < extent->list[mid].old_loc)
-			high = mid-1;
-		else
-			low = mid+1;
-	}
-	return 0;
-}
-
-/*
- * For debugging only
- */
-void ext2fs_extent_dump(ext2_extent extent, FILE *out)
-{
-	__u64	i;
-	struct ext2_extent_entry *ent;
-
-	fputs(_("# Extent dump:\n"), out);
-	fprintf(out, _("#\tNum=%llu, Size=%llu, Cursor=%llu, Sorted=%llu\n"),
-	       extent->num, extent->size, extent->cursor, extent->sorted);
-	for (i=0, ent=extent->list; i < extent->num; i++, ent++) {
-		fprintf(out, "#\t\t %llu -> %llu (%llu)\n", ent->old_loc,
-			ent->new_loc, ent->size);
-	}
-}
-
-/*
- * Iterate over the contents of the extent table
- */
-errcode_t ext2fs_iterate_extent(ext2_extent extent, __u64 *old_loc,
-				__u64 *new_loc, __u64 *size)
-{
-	struct ext2_extent_entry *ent;
-
-	if (!old_loc) {
-		extent->cursor = 0;
-		return 0;
-	}
-
-	if (extent->cursor >= extent->num) {
-		*old_loc = 0;
-		*new_loc = 0;
-		*size = 0;
-		return 0;
-	}
-
-	ent = extent->list + extent->cursor++;
-
-	*old_loc = ent->old_loc;
-	*new_loc = ent->new_loc;
-	*size = ent->size;
-	return 0;
-}
-
-
-
-
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 829fcd8ea8e1..c53b3bee8c8d 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -152,17 +152,6 @@ extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 extern blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags);
 
 
-/* extent.c */
-extern errcode_t ext2fs_create_extent_table(ext2_extent *ret_extent,
-					    __u64 size);
-extern void ext2fs_free_extent_table(ext2_extent extent);
-extern errcode_t ext2fs_add_extent_entry(ext2_extent extent,
-					 __u64 old_loc, __u64 new_loc);
-extern __u64 ext2fs_extent_translate(ext2_extent extent, __u64 old_loc);
-extern void ext2fs_extent_dump(ext2_extent extent, FILE *out);
-extern errcode_t ext2fs_iterate_extent(ext2_extent extent, __u64 *old_loc,
-				       __u64 *new_loc, __u64 *size);
