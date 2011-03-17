From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/4 v2] e2fsprogs: Add rbtree backend for bitmaps, use it instead of bitarrays
Date: Thu, 17 Mar 2011 19:50:19 +0100
Message-ID: <1300387821-21705-3-git-send-email-lczerner@redhat.com>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab1CQSun (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Mar 2011 14:50:43 -0400
In-Reply-To: <1300387821-21705-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For a long time we had a bitarray backend for storing filesystem
metadata bitmaps, however today this approach might hit its limits with
todays huge data storage devices, because of its memory utilization.

Bitarrays stores bitmaps as ..well, as bitmaps. But this is in most
cases highly unefficient because we need to allocate memory even for the
big parts of bitmaps we will never use, resulting in high memory
utilization especially for huge filesystem, when bitmaps might occupy
gigabytes of space.

This commit adds another backend to store bitmaps. It is based on
rbtrees and it stores just used extents of bitmaps. It means that it can
be more memory efficient in most cases.

I have done some limited benchmarking and it shows that rbtree backend
consumes approx 65% less memory that bitarray on 312GB filesystem aged
with Impression (default config). This number may grow significantly
with the filesystem size, but also it may be a lot lower (even negative)
with a lot bigger number of inodes (need more benchmarking).

This commit itself does not enable the use of rbtree backend.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/Makefile.in    |    2 +
 lib/ext2fs/blkmap64_rb.c  |  751 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/bmap64.h       |    1 +
 lib/ext2fs/ext2fsP.h      |    1 +
 lib/ext2fs/gen_bitmap64.c |    4 +
 5 files changed, 759 insertions(+), 0 deletions(-)
 create mode 100644 lib/ext2fs/blkmap64_rb.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index b24a53a..29d1994 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -27,6 +27,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	bitmaps.o \
 	bitops.o \
 	blkmap64_ba.o \
+	blkmap64_rb.o \
 	blknum.o \
 	block.o \
 	bmap.o \
@@ -94,6 +95,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/bitmaps.c \
 	$(srcdir)/bitops.c \
 	$(srcdir)/blkmap64_ba.o \
+	$(srcdir)/blkmap64_rb.c \
 	$(srcdir)/block.c \
 	$(srcdir)/bmap.c \
 	$(srcdir)/check_desc.c \
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
new file mode 100644
index 0000000..8f121b3
--- /dev/null
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -0,0 +1,751 @@
+/*
+ * blkmap64_rb.c --- Simple rb-tree implementation for bitmaps
+ *
+ * (C)2010 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <fcntl.h>
+#include <time.h>
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+
+#include "ext2_fs.h"
+#include "ext2fsP.h"
+#include "bmap64.h"
+#include "rbtree.h"
+
+#include <limits.h>
+
+struct bmap_rb_extent {
+	struct rb_node node;
+	__u64 start;
+	__u32 count;
+};
+
+struct ext2fs_rb_private {
+	struct rb_root root;
+	struct bmap_rb_extent **wcursor;
+	struct bmap_rb_extent **rcursor;
+};
+
+static int rb_insert_extent(__u64 start, __u64 count,
+			    struct ext2fs_rb_private *);
+static void rb_get_new_extent(struct bmap_rb_extent **, __u64, __u64);
+
+/*#define DEBUG_RB*/
+
+#ifdef DEBUG_RB
+static void print_tree(struct rb_root *root)
+{
+	struct rb_node *node = NULL;
+	struct bmap_rb_extent *ext;
+
+	printf("\t\t\t=================================\n");
+	node = rb_first(root);
+	for (node = rb_first(root); node != NULL; node=rb_next(node)) {
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+		printf("\t\t\t--> (%llu -> %llu)\n",
+			ext->start, ext->start + ext->count);
+	}
+	printf("\t\t\t=================================\n");
+}
+
+static int check_tree(struct rb_root *root, const char *msg)
+{
+	struct rb_node *new_node, *node, *next;
+	struct bmap_rb_extent *ext, *old = NULL;
+
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+		if (ext->count <= 0) {
+			printf("Tree Error: count is crazy\n");
+			printf("extent: %llu -> %llu (%llu)\n", ext->start,
+				ext->start + ext->count, ext->count);
+			goto err_out;
+		}
+		if (ext->start < 0) {
+			printf("Tree Error: start is crazy\n");
+			printf("extent: %llu -> %llu (%llu)\n", ext->start,
+				ext->start + ext->count, ext->count);
+			goto err_out;
+		}
+
+		if (old) {
+			if (old->start > ext->start) {
+				printf("Tree Error: start is crazy\n");
+				printf("extent: %llu -> %llu (%llu)\n",
+					old->start, old->start + old->count,
+					old->count);
+				printf("extent next: %llu -> %llu (%llu)\n",
+					ext->start, ext->start + ext->count,
+					ext->count);
+				goto err_out;
+			}
+			if ((old->start + old->count) >= ext->start) {
+				printf("Tree Error: extent is crazy\n");
+				printf("extent: %llu -> %llu (%llu)\n",
+					old->start, old->start + old->count,
+					old->count);
+				printf("extent next: %llu -> %llu (%llu)\n",
+					ext->start, ext->start + ext->count,
+					ext->count);
+				goto err_out;
+			}
+		}
+		old = ext;
+	}
+	return 0;
+
+err_out:
+	printf("%s\n", msg);
+	print_tree(root);
+	exit(1);
+}
+#else
+#define check_tree(root, msg) 0
+#define print_tree(root, msg) 0
+#endif
+
+static void rb_get_new_extent(struct bmap_rb_extent **ext, __u64 start,
+			     __u64 count)
+{
+	struct bmap_rb_extent *new_ext;
+	int retval;
+
+	retval = ext2fs_get_mem(sizeof (struct bmap_rb_extent),
+				&new_ext);
+	if (retval) {
+		perror("ext2fs_get_mem");
+		exit(1);
+	}
+
+	new_ext->start = start;
+	new_ext->count = count;
+	*ext = new_ext;
+}
+
+inline
+static void rb_free_extent(struct ext2fs_rb_private *bp,
+			   struct bmap_rb_extent *ext)
+{
+	if (*bp->wcursor == ext)
+		*bp->wcursor = NULL;
+	if (*bp->rcursor == ext)
+		*bp->rcursor = NULL;
+	ext2fs_free_mem(&ext);
+}
+
+static errcode_t rb_alloc_private_data (ext2fs_generic_bitmap bitmap)
+{
+	struct ext2fs_rb_private *bp;
+	errcode_t	retval;
+
+	retval = ext2fs_get_mem(sizeof (struct ext2fs_rb_private), &bp);
+	if (retval)
+		return retval;
+
+	bp->root = RB_ROOT;
+	retval = ext2fs_get_mem(sizeof(struct bmap_rb_extent *), &bp->rcursor);
+	if (retval)
+		return retval;
+	retval = ext2fs_get_mem(sizeof(struct bmap_rb_extent *), &bp->wcursor);
+	if (retval)
+		return retval;
+	*bp->rcursor = NULL;
+	*bp->wcursor = NULL;
+
+	bitmap->private = (void *) bp;
+	return 0;
+}
+
+static errcode_t rb_new_bmap(ext2_filsys fs EXT2FS_ATTR((unused)),
+			     ext2fs_generic_bitmap bitmap)
+{
+	errcode_t	retval;
+
+	retval = rb_alloc_private_data (bitmap);
+	if (retval)
+		return retval;
+
+	return 0;
+}
+
+static void rb_free_tree(struct rb_root *root)
+{
+	struct bmap_rb_extent *ext;
+	struct rb_node *node, *next;
+
+	for (node = rb_first(root); node; node = next) {
+		next = rb_next(node);
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+		rb_erase(node, root);
+		ext2fs_free_mem(&ext);
+	}
+}
+
+static void rb_free_bmap(ext2fs_generic_bitmap bitmap)
+{
+	struct ext2fs_rb_private *bp;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+
+	rb_free_tree(&bp->root);
+	ext2fs_free_mem(&bp->rcursor);
+	ext2fs_free_mem(&bp->wcursor);
+	ext2fs_free_mem(&bp);
+	bp = 0;
+}
+
+static errcode_t rb_copy_bmap(ext2fs_generic_bitmap src,
+			      ext2fs_generic_bitmap dest)
+{
+	struct ext2fs_rb_private *src_bp, *dest_bp;
+	struct bmap_rb_extent *src_ext, *dest_ext;
+	struct rb_node *dest_node, *src_node, *dest_last, **n;
+	errcode_t retval = 0;
+
+	retval = rb_alloc_private_data (dest);
+	if (retval)
+		return retval;
+
+	src_bp = (struct ext2fs_rb_private *) src->private;
+	dest_bp = (struct ext2fs_rb_private *) dest->private;
+	*src_bp->rcursor = NULL;
+	*dest_bp->rcursor = NULL;
+
+	src_node = rb_first(&src_bp->root);
+	while (src_node) {
+		src_ext = rb_entry(src_node, struct bmap_rb_extent, node);
+		retval = ext2fs_get_mem(sizeof (struct bmap_rb_extent),
+					&dest_ext);
+		if (retval)
+			break;
+
+		memcpy(dest_ext, src_ext, sizeof(struct bmap_rb_extent));
+
+		dest_node = &dest_ext->node;
+		n = &dest_bp->root.rb_node;
+
+		dest_last = NULL;
+		if (*n) {
+			dest_last = rb_last(&dest_bp->root);
+			n = &(dest_last)->rb_right;
+		}
+
+		rb_link_node(dest_node, dest_last, n);
+		rb_insert_color(dest_node, &dest_bp->root);
+
+		src_node = rb_next(src_node);
+	}
+
+	return retval;
+}
+
+static void rb_truncate(__u64 new_max, struct rb_root *root)
+{
+	struct bmap_rb_extent *ext;
+	struct rb_node *node;
+
+	node = rb_last(root);
+	while (node) {
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+
+		if ((ext->start + ext->count - 1) <= new_max)
+			break;
+		else if (ext->start > new_max) {
+			rb_erase(node, root);
+			ext2fs_free_mem(&ext);
+			node = rb_last(root);
+			continue;
+		} else
+			ext->count = new_max - ext->start + 1;
+	}
+}
+
+static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
+				__u64 new_end, __u64 new_real_end)
+{
+	struct ext2fs_rb_private *bp;
+
+	if (new_real_end >= bmap->real_end) {
+		bmap->end = new_end;
+		bmap->real_end = new_real_end;
+		return 0;
+	}
+
+	bp = (struct ext2fs_rb_private *) bmap->private;
+	*bp->rcursor = NULL;
+	*bp->wcursor = NULL;
+
+	/* truncate tree to new_real_end size */
+	rb_truncate(new_real_end, &bp->root);
+
+	bmap->end = new_end;
+	bmap->real_end = new_real_end;
+	return 0;
+
+}
+
+inline static int
+rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
+{
+	struct bmap_rb_extent *rcursor;
+	struct rb_node *parent = NULL;
+	struct rb_node **n = &bp->root.rb_node;
+	struct bmap_rb_extent *ext;
+	int i=0;
+
+	rcursor = *bp->rcursor;
+	if (!rcursor)
+		goto search_tree;
+
+	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
+		return 1;
+
+	rcursor = *bp->wcursor;
+	if (!rcursor)
+		goto search_tree;
+
+	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
+		return 1;
+
+search_tree:
+
+	while (*n) {
+		parent = *n;
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+		if (bit < ext->start)
+			n = &(*n)->rb_left;
+		else if (bit >= (ext->start + ext->count))
+			n = &(*n)->rb_right;
+		else {
+			*bp->rcursor = ext;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int rb_insert_extent(__u64 start, __u64 count,
+			    struct ext2fs_rb_private *bp)
+{
+	struct rb_root *root = &bp->root;
+	struct rb_node *parent = NULL, **n = &root->rb_node;
+	struct rb_node *new_node, *node, *next;
+	struct bmap_rb_extent *new_ext;
+	struct bmap_rb_extent *ext;
+	int retval = 0;
+
+	ext = *bp->wcursor;
+	if (ext) {
+		if (start >= ext->start &&
+		    start <= (ext->start + ext->count))
+			goto got_extent;
+	}
+
+	while (*n) {
+		parent = *n;
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start > (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else {
+got_extent:
+			if ((start + count) <= (ext->start + ext->count))
+				return 1;
+
+			if ((ext->start + ext->count) == start)
+				retval = 0;
+			else
+				retval = 1;
+
+			count += (start - ext->start);
+			start = ext->start;
+			new_ext = ext;
+			new_node = &ext->node;
+
+			goto skip_insert;
+		}
+	}
+
+	rb_get_new_extent(&new_ext, start, count);
+
+	new_node = &new_ext->node;
+	rb_link_node(new_node, parent, n);
+	rb_insert_color(new_node, root);
+	*bp->wcursor = new_ext;
+
+	node = rb_prev(new_node);
+	if (node) {
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+		if ((ext->start + ext->count) == start) {
+			start = ext->start;
+			count += ext->count;
+			rb_erase(node, root);
+			rb_free_extent(bp, ext);
+		}
+	}
+
+skip_insert:
+	/* See if we can merge extent to the right */
+	for (node = rb_next(new_node); node != NULL; node = next) {
+		next = rb_next(node);
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+
+		if ((ext->start + ext->count) <= start)
+			continue;
+
+		/* No more merging */
+		if ((start + count) < ext->start)
+			break;
+
+		/* ext is embedded in new_ext interval */
+		if ((start + count) >= (ext->start + ext->count)) {
+			rb_erase(node, root);
+			rb_free_extent(bp, ext);
+			continue;
+		} else {
+		/* merge ext with new_ext */
+			count += ((ext->start + ext->count) -
+				  (start + count));
+			rb_erase(node, root);
+			rb_free_extent(bp, ext);
+			break;
+		}
+	}
+
+	new_ext->start = start;
+	new_ext->count = count;
+
+	return retval;
+}
+
+static int rb_remove_extent(struct bmap_rb_extent *del_ext,
+			    struct ext2fs_rb_private *bp)
+{
+	struct rb_root *root = &bp->root;
+	struct rb_node *parent = NULL, **n = &root->rb_node;
+	struct rb_node *node;
+	struct bmap_rb_extent *ext;
+	__u64 start, count;
+	int retval = 0;
+
+	if (RB_EMPTY_ROOT(root))
+		return 0;
+
+	start = del_ext->start;
+	count = del_ext->count;
+
+	while (*n) {
+		parent = *n;
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+			continue;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+			continue;
+		}
+
+		if ((start > ext->start) &&
+		    (start + count) < (ext->start + ext->count)) {
+			/* We have to split extent into two */
+			del_ext->start = start + count;
+			del_ext->count = (ext->start + ext->count) -
+					 del_ext->start;
+
+			ext->count = start - ext->start;
+
+			rb_insert_extent(del_ext->start, del_ext->count, bp);
+			ext2fs_free_mem(&del_ext);
+			return 1;
+		}
+
+		if ((start + count) >= (ext->start + ext->count))
+			ext->count = start - ext->start;
+
+		if (0 == ext->count) {
+			parent = rb_next(&ext->node);
+			rb_erase(&ext->node, root);
+			rb_free_extent(bp, ext);
+			break;
+		}
+
+		if (start == ext->start) {
+			ext->start += count;
+			ext->count -= count;
+			return retval;
+		}
+	}
+
+	/* See if we should delete or truncate extent on the right */
+	for (; parent != NULL; parent = node) {
+		node = rb_next(parent);
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+		if ((ext->start + ext->count) <= start)
+			continue;
+
+		/* No more merging */
+		if ((start + count) < ext->start)
+			break;
+
+		/* ext is embedded in new_ext interval */
+		if ((start + count) >= (ext->start + ext->count)) {
+			rb_erase(parent, root);
+			rb_free_extent(bp, ext);
+			continue;
+		} else {
+		/* merge ext with new_ext */
+			ext->count -= ((start + count) - ext->start);
+			ext->start = start + count;
+			break;
+		}
+	}
+
+	return retval;
+}
+
+static int rb_mark_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
+{
+	struct ext2fs_rb_private *bp;
+	int i;
+
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	arg -= bitmap->start;
+
+	return rb_insert_extent(arg, 1, bp);
+}
+
+static int rb_unmark_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
+{
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *del_ext;
+	int retval;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	arg -= bitmap->start;
+
+	rb_get_new_extent(&del_ext, arg, 1);
+
+	retval = rb_remove_extent(del_ext, bp);
+	if (!retval)
+		ext2fs_free_mem(&del_ext);
+	check_tree(&bp->root, __func__);
+
+	return retval;
+}
+
+inline
+static int rb_test_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
+{
+	struct ext2fs_rb_private *bp;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	arg -= bitmap->start;
+
+	return rb_test_bit(bp, arg);
+}
+
+static void rb_mark_bmap_extent(ext2fs_generic_bitmap bitmap, __u64 arg,
+				unsigned int num)
+{
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *new_ext;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	arg -= bitmap->start;
+
+	rb_insert_extent(arg, num, bp);
+}
+
+static void rb_unmark_bmap_extent(ext2fs_generic_bitmap bitmap, __u64 arg,
+				  unsigned int num)
+{
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *del_ext;
+	int ret;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	arg -= bitmap->start;
+
+	rb_get_new_extent(&del_ext, arg, num);
+	rb_remove_extent(del_ext, bp);
+	check_tree(&bp->root, __func__);
+}
+
+static int rb_test_clear_bmap_extent(ext2fs_generic_bitmap bitmap,
+				     __u64 start, unsigned int len)
+{
+	struct rb_node *parent = NULL, **n;
+	struct rb_node *node, *next;
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *ext;
+	int retval = 1;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	n = &bp->root.rb_node;
+	start -= bitmap->start;
+
+	if ((len == 0) ||
+	    RB_EMPTY_ROOT(&bp->root))
+		return 1;
+
+	/*
+	 * If we find nothing, we should examine whole extent, but
+	 * when we find match, the extent is not clean, thus be return
+	 * false.
+	 */
+	while (*n) {
+		parent = *n;
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else {
+			/*
+			 * We found extent int the tree -> extent is not
+			 * clean
+			 */
+			return 0;
+		}
+	}
+
+	node = parent;
+	while (node) {
+		next = rb_next(node);
+		ext = rb_entry(node, struct bmap_rb_extent, node);
+		node = next;
+
+		if ((ext->start + ext->count) <= start)
+			continue;
+
+		/* No more merging */
+		if ((start + len) <= ext->start)
+			break;
+
+		retval = 0;
+		break;
+	}
+	return retval;
+}
+
+static errcode_t rb_set_bmap_range(ext2fs_generic_bitmap bitmap,
+				     __u64 start, size_t num, void *in)
+{
+	struct ext2fs_rb_private *bp;
+	size_t i;
+	int ret;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+
+	for (i = 0; i < num; i++) {
+		ret = ext2fs_test_bit(i, in);
+		if (ret)
+			rb_insert_extent(start + i - bitmap->start, 1, bp);
+	}
+
+	return 0;
+}
+
+static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
+				     __u64 start, size_t num, void *out)
+{
+
+	struct rb_node *parent = NULL, *next, **n;
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *ext;
+	__u64 pos;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	n = &bp->root.rb_node;
+	start -= bitmap->start;
+
+	if (RB_EMPTY_ROOT(&bp->root)) {
+		return 0;
+	}
+
+	while (*n) {
+		parent = *n;
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else
+			break;
+	}
+
+	pos = start;
+	for (; parent != NULL; parent = next) {
+		next = rb_next(parent);
+		ext = rb_entry(parent, struct bmap_rb_extent, node);
+
+		while (((pos - start) < num) &&
+			(pos < ext->start)) {
+			ext2fs_fast_clear_bit64((pos - start), out);
+			pos++;
+		}
+
+		if ((pos - start) >= num)
+			return 0;
+
+		while (((pos - start) < num) &&
+			(pos < (ext->start + ext->count))) {
+			ext2fs_fast_set_bit64((pos - start), out);
+			pos++;
+		}
+	}
+
+	while ((pos - start) < num) {
+		ext2fs_fast_clear_bit64((pos - start), out);
+		pos++;
+	}
+
+	return 0;
+}
+
+static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
+{
+	struct ext2fs_rb_private *bp;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+
+	rb_free_tree(&bp->root);
+	*bp->rcursor = NULL;
+	*bp->wcursor = NULL;
+}
+
+struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
+	.type = EXT2FS_BMAP64_RBTREE,
+	.new_bmap = rb_new_bmap,
+	.free_bmap = rb_free_bmap,
+	.copy_bmap = rb_copy_bmap,
+	.resize_bmap = rb_resize_bmap,
+	.mark_bmap = rb_mark_bmap,
+	.unmark_bmap = rb_unmark_bmap,
+	.test_bmap = rb_test_bmap,
+	.test_clear_bmap_extent = rb_test_clear_bmap_extent,
+	.mark_bmap_extent = rb_mark_bmap_extent,
+	.unmark_bmap_extent = rb_unmark_bmap_extent,
+	.set_bmap_range = rb_set_bmap_range,
+	.get_bmap_range = rb_get_bmap_range,
+	.clear_bmap = rb_clear_bmap,
+};
diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
index b0aa84c..31021b9 100644
--- a/lib/ext2fs/bmap64.h
+++ b/lib/ext2fs/bmap64.h
@@ -59,3 +59,4 @@ struct ext2_bitmap_ops {
 };
 
 extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
+extern struct ext2_bitmap_ops ext2fs_blkmap64_rbtree;
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index ab9ee76..aa45c43 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -108,6 +108,7 @@ extern void ext2fs_numeric_progress_close(ext2_filsys fs,
  */
 
 #define EXT2FS_BMAP64_BITARRAY	1
+#define EXT2FS_BMAP64_RBTREE	2
 
 extern errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 					   int type, __u64 start, __u64 end,
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index df095ac..84065ea 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -91,6 +91,9 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	case EXT2FS_BMAP64_BITARRAY:
 		ops = &ext2fs_blkmap64_bitarray;
 		break;
+	case EXT2FS_BMAP64_RBTREE:
+		ops = &ext2fs_blkmap64_rbtree;
+		break;
 	default:
 		return EINVAL;
 	}
@@ -158,6 +161,7 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
 		bmap->description = 0;
 	}
 	bmap->magic = 0;
+	ext2fs_free_mem(&bmap);
 }
 
 errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
-- 
1.7.4

