From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] libext2fs: fix gcc -Wall warnings
Date: Mon, 20 May 2013 09:58:57 -0400
Message-ID: <1369058339-1925-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49953 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab3ETN7C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 09:59:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Primarily signed vs unsigned and const warnings.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debian/e2fslibs.symbols   |  1 -
 lib/ext2fs/bitops.c       |  2 +-
 lib/ext2fs/bitops.h       | 19 ++++++++-----------
 lib/ext2fs/blkmap64_rb.c  | 48 ++++++++++++++++++++++++++++-------------------
 lib/ext2fs/block.c        |  4 ++--
 lib/ext2fs/crc32c.c       |  8 ++++----
 lib/ext2fs/gen_bitmap64.c |  2 +-
 lib/ext2fs/mmp.c          |  3 ++-
 lib/ext2fs/rbtree.c       |  4 ++--
 lib/ext2fs/rbtree.h       |  4 ++--
 lib/ext2fs/rw_bitmaps.c   |  3 ++-
 lib/ext2fs/symlink.c      |  2 +-
 12 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/debian/e2fslibs.symbols b/debian/e2fslibs.symbols
index b8eea52..5784a25 100644
--- a/debian/e2fslibs.symbols
+++ b/debian/e2fslibs.symbols
@@ -352,7 +352,6 @@ libext2fs.so.2 e2fslibs #MINVER#
  ext2fs_open_file@Base 1.42
  ext2fs_open_inode_scan@Base 1.37
  ext2fs_parse_version_string@Base 1.37
- ext2fs_print_bmap_statistics@Base 1.42.1
  ext2fs_process_dir_block@Base 1.37
  ext2fs_punch@Base 1.42
  ext2fs_r_blocks_count@Base 1.42
diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
index 7c3f215..8e4c05c 100644
--- a/lib/ext2fs/bitops.c
+++ b/lib/ext2fs/bitops.c
@@ -142,7 +142,7 @@ unsigned int ext2fs_bitcount(const void *addr, unsigned int nbytes)
 		res += popcount8(*cp++);
 		nbytes--;
 	}
-	p = (__u32 *) cp;
+	p = (const __u32 *) cp;
 
 	while (nbytes > 4) {
 		res += popcount32(*p++);
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 1559539..edf82f2 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -54,6 +54,14 @@ extern void ext2fs_warn_bitmap2(ext2fs_generic_bitmap bitmap,
 				int code, unsigned long arg);
 
 #ifdef NO_INLINE_FUNCS
+extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
+extern void ext2fs_fast_clear_bit(unsigned int nr, void * addr);
+extern void ext2fs_fast_set_bit64(__u64 nr,void * addr);
+extern void ext2fs_fast_clear_bit64(__u64 nr, void * addr);
+extern __u16 ext2fs_swab16(__u16 val);
+extern __u32 ext2fs_swab32(__u32 val);
+extern __u64 ext2fs_swab64(__u64 val);
+
 extern int ext2fs_mark_block_bitmap(ext2fs_block_bitmap bitmap, blk_t block);
 extern int ext2fs_unmark_block_bitmap(ext2fs_block_bitmap bitmap,
 				       blk_t block);
@@ -650,14 +658,3 @@ extern int ext2fs_set_bit64(__u64 nr,void * addr);
 extern int ext2fs_clear_bit64(__u64 nr, void * addr);
 extern int ext2fs_test_bit64(__u64 nr, const void * addr);
 extern unsigned int ext2fs_bitcount(const void *addr, unsigned int nbytes);
-
-#ifdef NO_INLINE_FUNCS
-extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
-extern void ext2fs_fast_clear_bit(unsigned int nr, void * addr);
-extern void ext2fs_fast_set_bit64(__u64 nr,void * addr);
-extern void ext2fs_fast_clear_bit64(__u64 nr, void * addr);
-extern __u16 ext2fs_swab16(__u16 val);
-extern __u32 ext2fs_swab32(__u32 val);
-extern __u64 ext2fs_swab64(__u64 val);
-#endif
-
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 9a8938a..a22682e 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -47,6 +47,17 @@ struct ext2fs_rb_private {
 #endif
 };
 
+inline static struct bmap_rb_extent *node_to_extent(struct rb_node *node)
+{
+	/*
+	 * This depends on the fact the struct rb_node is at the
+	 * beginning of the bmap_rb_extent structure.  We use this
+	 * instead of the ext2fs_rb_entry macro because it causes gcc
+	 * -Wall to generate a huge amount of noise.
+	 */
+	return (struct bmap_rb_extent *) node;
+}
+
 static int rb_insert_extent(__u64 start, __u64 count,
 			    struct ext2fs_rb_private *);
 static void rb_get_new_extent(struct bmap_rb_extent **, __u64, __u64);
@@ -63,7 +74,7 @@ static void print_tree(struct rb_root *root)
 	node = ext2fs_rb_first(root);
 	for (node = ext2fs_rb_first(root); node != NULL; 
 	     node = ext2fs_rb_next(node)) {
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 		printf("\t\t\t--> (%llu -> %llu)\n",
 			ext->start, ext->start + ext->count);
 	}
@@ -77,7 +88,7 @@ static void check_tree(struct rb_root *root, const char *msg)
 
 	for (node = ext2fs_rb_first(root); node;
 	     node = ext2fs_rb_next(node)) {
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 		if (ext->count <= 0) {
 			printf("Tree Error: count is crazy\n");
 			printf("extent: %llu -> %llu (%u)\n", ext->start,
@@ -200,7 +211,7 @@ static void rb_free_tree(struct rb_root *root)
 
 	for (node = ext2fs_rb_first(root); node; node = next) {
 		next = ext2fs_rb_next(node);
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 		ext2fs_rb_erase(node, root);
 		ext2fs_free_mem(&ext);
 	}
@@ -236,7 +247,7 @@ static errcode_t rb_copy_bmap(ext2fs_generic_bitmap src,
 
 	src_node = ext2fs_rb_first(&src_bp->root);
 	while (src_node) {
-		src_ext = ext2fs_rb_entry(src_node, struct bmap_rb_extent, node);
+		src_ext = node_to_extent(src_node);
 		retval = ext2fs_get_mem(sizeof (struct bmap_rb_extent),
 					&dest_ext);
 		if (retval)
@@ -269,7 +280,7 @@ static void rb_truncate(__u64 new_max, struct rb_root *root)
 
 	node = ext2fs_rb_last(root);
 	while (node) {
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 
 		if ((ext->start + ext->count - 1) <= new_max)
 			break;
@@ -330,8 +341,7 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 	if (!next_ext) {
 		next = ext2fs_rb_next(&rcursor->node);
 		if (next)
-			next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent,
-						   node);
+			next_ext = node_to_extent(next);
 		bp->rcursor_next = next_ext;
 	}
 	if (next_ext) {
@@ -357,7 +367,7 @@ search_tree:
 
 	while (*n) {
 		parent = *n;
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 		if (bit < ext->start)
 			n = &(*n)->rb_left;
 		else if (bit >= (ext->start + ext->count))
@@ -395,7 +405,7 @@ static int rb_insert_extent(__u64 start, __u64 count,
 
 	while (*n) {
 		parent = *n;
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 
 		if (start < ext->start) {
 			n = &(*n)->rb_left;
@@ -429,7 +439,7 @@ got_extent:
 
 	node = ext2fs_rb_prev(new_node);
 	if (node) {
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 		if ((ext->start + ext->count) == start) {
 			start = ext->start;
 			count += ext->count;
@@ -442,7 +452,7 @@ skip_insert:
 	/* See if we can merge extent to the right */
 	for (node = ext2fs_rb_next(new_node); node != NULL; node = next) {
 		next = ext2fs_rb_next(node);
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 
 		if ((ext->start + ext->count) <= start)
 			continue;
@@ -487,7 +497,7 @@ static int rb_remove_extent(__u64 start, __u64 count,
 
 	while (*n) {
 		parent = *n;
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 		if (start < ext->start) {
 			n = &(*n)->rb_left;
 			continue;
@@ -530,7 +540,7 @@ static int rb_remove_extent(__u64 start, __u64 count,
 	/* See if we should delete or truncate extent on the right */
 	for (; parent != NULL; parent = node) {
 		node = ext2fs_rb_next(parent);
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 		if ((ext->start + ext->count) <= start)
 			continue;
 
@@ -637,7 +647,7 @@ static int rb_test_clear_bmap_extent(ext2fs_generic_bitmap bitmap,
 	 */
 	while (*n) {
 		parent = *n;
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 		if (start < ext->start) {
 			n = &(*n)->rb_left;
 		} else if (start >= (ext->start + ext->count)) {
@@ -654,7 +664,7 @@ static int rb_test_clear_bmap_extent(ext2fs_generic_bitmap bitmap,
 	node = parent;
 	while (node) {
 		next = ext2fs_rb_next(node);
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 		node = next;
 
 		if ((ext->start + ext->count) <= start)
@@ -732,7 +742,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 
 	while (*n) {
 		parent = *n;
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 		if (start < ext->start) {
 			n = &(*n)->rb_left;
 		} else if (start >= (ext->start + ext->count)) {
@@ -745,7 +755,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 
 	for (; parent != NULL; parent = next) {
 		next = ext2fs_rb_next(parent);
-		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+		ext = node_to_extent(parent);
 
 		pos = ext->start;
 		count = ext->count;
@@ -766,7 +776,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
 				int nbytes = count >> 3;
 				int offset = (pos - start) >> 3;
 
-				memset(out + offset, 0xFF, nbytes);
+				memset(((char *) out) + offset, 0xFF, nbytes);
 				pos += nbytes << 3;
 				count -= nbytes << 3;
 				continue;
@@ -812,7 +822,7 @@ static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 	node = ext2fs_rb_first(&bp->root);
 	for (node = ext2fs_rb_first(&bp->root); node != NULL;
 	     node = ext2fs_rb_next(node)) {
-		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
+		ext = node_to_extent(node);
 		count++;
 		if (ext->count > max_size)
 			max_size = ext->count;
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 68dcb03..b8c6879 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -472,9 +472,9 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 			       extent.e_lblk, extent.e_pblk,
 			       extent.e_len, blockcnt);
 #endif
-			if (extent.e_lblk + extent.e_len <= blockcnt)
+			if (extent.e_lblk + extent.e_len <= (blk64_t) blockcnt)
 				continue;
-			if (extent.e_lblk > blockcnt)
+			if (extent.e_lblk > (blk64_t) blockcnt)
 				blockcnt = extent.e_lblk;
 			j = blockcnt - extent.e_lblk;
 			blk += j;
diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
index b54fc27..2512528 100644
--- a/lib/ext2fs/crc32c.c
+++ b/lib/ext2fs/crc32c.c
@@ -224,7 +224,7 @@ static uint32_t crc32c_le_body(uint32_t crc, uint8_t const *buf, size_t len)
 	crc = (__force uint32_t) __cpu_to_le32(crc);
 
 	p8 = buf;
-	p32 = (uint32_t *)PTR_ALIGN(p8, 8);
+	p32 = (const uint32_t *)PTR_ALIGN(p8, 8);
 	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
 	words = (len - init_bytes) >> 3;
 	end_bytes = (len - init_bytes) & 7;
@@ -273,7 +273,7 @@ static uint32_t crc32c_le_body(uint32_t crc, uint8_t const *buf, size_t len)
 #endif
 	}
 
-	p8 = (uint8_t *)(++p32);
+	p8 = (const uint8_t *)(++p32);
 
 	for (i = 0; i < end_bytes; i++) {
 #ifndef WORDS_BIGENDIAN
@@ -304,7 +304,7 @@ static uint32_t crc32c_be_body(uint32_t crc, uint8_t const *buf, size_t len)
 	crc = (__force uint32_t) __cpu_to_be32(crc);
 
 	p8 = buf;
-	p32 = (uint32_t *)PTR_ALIGN(p8, 8);
+	p32 = (const uint32_t *)PTR_ALIGN(p8, 8);
 	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
 	words = (len - init_bytes) >> 3;
 	end_bytes = (len - init_bytes) & 7;
@@ -353,7 +353,7 @@ static uint32_t crc32c_be_body(uint32_t crc, uint8_t const *buf, size_t len)
 #endif
 	}
 
-	p8 = (uint8_t *)(++p32);
+	p8 = (const uint8_t *)(++p32);
 
 	for (i = 0; i < end_bytes; i++) {
 #ifndef WORDS_BIGENDIAN
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 7265f94..d02488c 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -174,7 +174,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 }
 
 #ifdef BMAP_STATS
-void ext2fs_print_bmap_statistics(ext2fs_generic_bitmap bitmap)
+static void ext2fs_print_bmap_statistics(ext2fs_generic_bitmap bitmap)
 {
 	struct ext2_bmap_statistics *stats = &bitmap->stats;
 #ifdef BMAP_STATS_OPS
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 435c5f4..98562e7 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -62,7 +62,8 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 			return retval;
 	}
 
-	if (ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize, SEEK_SET) !=
+	if ((blk64_t) ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize,
+				    SEEK_SET) !=
 	    mmp_blk * fs->blocksize) {
 		retval = EXT2_ET_LLSEEK_FAILED;
 		goto out;
diff --git a/lib/ext2fs/rbtree.c b/lib/ext2fs/rbtree.c
index 7467e10..9439303 100644
--- a/lib/ext2fs/rbtree.c
+++ b/lib/ext2fs/rbtree.c
@@ -375,7 +375,7 @@ struct rb_node *ext2fs_rb_last(const struct rb_root *root)
 	return n;
 }
 
-struct rb_node *ext2fs_rb_next(const struct rb_node *node)
+struct rb_node *ext2fs_rb_next(struct rb_node *node)
 {
 	struct rb_node *parent;
 
@@ -403,7 +403,7 @@ struct rb_node *ext2fs_rb_next(const struct rb_node *node)
 	return parent;
 }
 
-struct rb_node *ext2fs_rb_prev(const struct rb_node *node)
+struct rb_node *ext2fs_rb_prev(struct rb_node *node)
 {
 	struct rb_node *parent;
 
diff --git a/lib/ext2fs/rbtree.h b/lib/ext2fs/rbtree.h
index 16defb5..3b0b078 100644
--- a/lib/ext2fs/rbtree.h
+++ b/lib/ext2fs/rbtree.h
@@ -158,8 +158,8 @@ extern void ext2fs_rb_augment_erase_end(struct rb_node *node,
 				 rb_augment_f func, void *data);
 
 /* Find logical next and previous nodes in a tree */
-extern struct rb_node *ext2fs_rb_next(const struct rb_node *);
-extern struct rb_node *ext2fs_rb_prev(const struct rb_node *);
+extern struct rb_node *ext2fs_rb_next(struct rb_node *);
+extern struct rb_node *ext2fs_rb_prev(struct rb_node *);
 extern struct rb_node *ext2fs_rb_first(const struct rb_root *);
 extern struct rb_node *ext2fs_rb_last(const struct rb_root *);
 
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 3f3ed65..b7d65a9 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -163,7 +163,8 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
-	if ((block_nbytes > fs->blocksize) || (inode_nbytes > fs->blocksize))
+	if ((block_nbytes > (int) fs->blocksize) ||
+	    (inode_nbytes > (int) fs->blocksize))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index da6e3a8..e943412 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -37,7 +37,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	int			fastlink;
-	int			target_len;
+	unsigned int		target_len;
 	char			*block_buf = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
-- 
1.7.12.rc0.22.gcdd159b

