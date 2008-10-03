From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC,PATCH] 64-bit bitmaps for e2fsprogs
Date: Thu, 2 Oct 2008 20:02:37 -0400
Message-ID: <20081003000237.GF28293@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, "Jose R. Santos" <jrs@us.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYJCACu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Oct 2008 20:02:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've been working on 64-bit bitmaps for e2fsprogs, which will allow us
to create an ext4 file system with more than 2^32 blocks.  Below is a
snapshot of my development tree as-is (doesn't even compile); I'd
appreciate comments on the direction, especially from Ted and Jose.

Some background: Ted's goal is to preserve the ABI for programs
dynamically linked against libext2.  This is implemented by preserving
the existing 32-bit bitmap interfaces as-is and implementing a new set
of 64-bit interfaces which detect whether the application has been
recompiled since the new 64-bit support went in.  If so, it uses the
new functions, otherwise it passes the arguments back to the old
functions.

The diff includes three patches: implementation of 64-bit bmap ops,
warning squashing (so I can concentrate on my warnings), and a partial
port to the new 64-bit interfaces.  I can split them out if necessary.
Diff is against commit 6db77ec039ff241dab0f1e267fabcfa814fbaf4c in the
pu branch.

-VAL

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 8b0965e..d1c6460 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1850,7 +1850,7 @@ static int find_supp_feature(__u32 *supp, int feature_type, char *name)
 
 void do_supported_features(int argc, char *argv[])
 {
-        int	i, j, ret;
+        int	ret;
 	__u32	supp[3] = { EXT2_LIB_FEATURE_COMPAT_SUPP,
 			    EXT2_LIB_FEATURE_INCOMPAT_SUPP,
 			    EXT2_LIB_FEATURE_RO_COMPAT_SUPP };
diff --git a/debugfs/htree.c b/debugfs/htree.c
index 983dc9a..f9332ab 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -48,11 +48,11 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 		return;
 	}
 
-	printf("Reading directory block %lu, phys %lu\n", blk, pblk);
+	printf("Reading directory block %u, phys %u\n", blk, pblk);
 	errcode = ext2fs_read_dir_block2(current_fs, pblk, buf, 0);
 	if (errcode) {
 		com_err("htree_dump_leaf_node", errcode,
-			"while reading block %lu (%lu)\n", blk, pblk);
+			"while reading block %u (%u)\n", blk, pblk);
 		return;
 	}
 	hash_alg = rootnode->hash_version;
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 10ac803..4bdc62a 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1099,7 +1099,8 @@ static int probe_hfs(struct blkid_probe *probe __BLKID_ATTR((unused)),
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
 	}
-	blkid_set_tag(probe->dev, "LABEL", hfs->label, hfs->label_len);
+	blkid_set_tag(probe->dev, "LABEL", (char *) hfs->label,
+		      hfs->label_len);
 	return 0;
 }
 
@@ -1220,7 +1221,7 @@ static int probe_hfsplus(struct blkid_probe *probe,
 		return 0;
 
 	label_len = blkid_be16(key->unicode_len) * 2;
-	unicode_16be_to_utf8(label, sizeof(label), key->unicode, label_len);
+	unicode_16be_to_utf8((unsigned char *) label, sizeof(label), key->unicode, label_len);
 	blkid_set_tag(probe->dev, "LABEL", label, 0);
 	return 0;
 }
diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 98c97db..d5d10a5 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -38,6 +38,8 @@ int setversion (int fd, unsigned long version);
 
 const char *e2p_feature2string(int compat, unsigned int mask);
 int e2p_string2feature(char *string, int *compat, unsigned int *mask);
+const char *e2p_jrnl_feature2string(int compat, unsigned int mask);
+int e2p_jrnl_string2feature(char *string, int *compat_type, unsigned int *mask);
 int e2p_edit_feature(const char *str, __u32 *compat_array, __u32 *ok_array);
 int e2p_edit_feature2(const char *str, __u32 *compat_array, __u32 *ok_array,
 		      __u32 *clear_ok_array, int *type_err,
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 696f27e..fe4fdb4 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -29,8 +29,8 @@
 /*
  * Check for uninit block bitmaps and deal with them appropriately
  */
-static check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
-			  dgrp_t group)
+static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
+			       dgrp_t group)
 {
 	int		i;
 	blk_t		blk, super_blk, old_desc_blk, new_desc_blk;
@@ -75,7 +75,7 @@ static check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 /*
  * Check for uninit inode bitmaps and deal with them appropriately
  */
-static check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
+static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 			  dgrp_t group)
 {
 	int		i;
diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index ea08b3e..47cf9eb 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -26,108 +26,145 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap bitmap)
 {
-	ext2fs_free_generic_bitmap(bitmap);
+	ext2fs_free_generic_bmap(bitmap);
 }
 
 void ext2fs_free_block_bitmap(ext2fs_block_bitmap bitmap)
 {
-	ext2fs_free_generic_bitmap(bitmap);
+	ext2fs_free_generic_bmap(bitmap);
 }
 
-errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
-			     ext2fs_generic_bitmap *dest)
+errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap64 src,
+			     ext2fs_generic_bitmap64 *dest)
 {
-	return (ext2fs_copy_generic_bitmap(src, dest));
+	return (ext2fs_copy_generic_bmap((ext2fs_generic_bitmap64) src,
+					 (ext2fs_generic_bitmap64 *) dest));
 }
-
 void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
 {
-	ext2fs_set_generic_bitmap_padding(map);
+	ext2fs_set_generic_bmap_padding((ext2fs_generic_bitmap64) map);
+}
+
+void ext2fs_set_bmap_padding(ext2fs_generic_bitmap64 map)
+{
+	ext2fs_set_generic_bmap_padding(map);
 }
 
 errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 				       const char *descr,
 				       ext2fs_inode_bitmap *ret)
 {
-	__u32		start, end, real_end;
+	__u64		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = 1;
-	end = fs->super->s_inodes_count;
+	end = ext2fs_blocks_count(fs->super)-1;
 	real_end = (EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count);
 
+	/* Are we permitted to use new-style bitmaps? */
+	if (fs->flags & EXT2_FLAG_NEW_BITMAPS)
+		return (ext2fs_alloc_generic_bmap(fs,
+				  EXT2_ET_MAGIC_INODE_BITMAP64,
+				  EXT2FS_BMAP64_BITARRAY,
+				  start, end, real_end, descr, ret));
+
+	/* Otherwise, check to see if the file system is small enough
+	 * to use old-style 32-bit bitmaps */
+	if ((end > ~0U) || (real_end > ~0U))
+		return EXT2_ET_FILE_TOO_BIG; /* XXX better error code */
+
 	return (ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_INODE_BITMAP, fs,
 					   start, end, real_end,
-					   descr, 0, ret));
+					   descr, 0,
+					   (ext2fs_generic_bitmap *) ret));
 }
 
 errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 				       const char *descr,
 				       ext2fs_block_bitmap *ret)
 {
-	__u32		start, end, real_end;
+	__u64		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = fs->super->s_first_data_block;
-	end = fs->super->s_blocks_count-1;
+	end = ext2fs_blocks_count(fs->super)-1;
 	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)
 		    * fs->group_desc_count)-1 + start;
 
+	if (fs->flags & EXT2_FLAG_NEW_BITMAPS)
+		return (ext2fs_alloc_generic_bmap(fs,
+				  EXT2_ET_MAGIC_BLOCK_BITMAP64,
+				  EXT2FS_BMAP64_BITARRAY,
+				  start, end, real_end, descr, ret));
+
+	if ((end > ~0U) || (real_end > ~0U))
+		return EXT2_ET_FILE_TOO_BIG; /* XXX better error code */
+
 	return (ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_BLOCK_BITMAP, fs,
 					   start, end, real_end,
-					   descr, 0, ret));
+					   descr, 0,
+					   (ext2fs_generic_bitmap *) ret));
 }
 
 errcode_t ext2fs_fudge_inode_bitmap_end(ext2fs_inode_bitmap bitmap,
 					ext2_ino_t end, ext2_ino_t *oend)
 {
 
-	return (ext2fs_fudge_generic_bitmap_end(bitmap,
-						EXT2_ET_MAGIC_INODE_BITMAP,
-						EXT2_ET_FUDGE_INODE_BITMAP_END,
-						end, oend));
+	return (ext2fs_fudge_generic_bmap_end(bitmap,
+					      EXT2_ET_FUDGE_INODE_BITMAP_END,
+					      end, oend));
 }
 
 errcode_t ext2fs_fudge_block_bitmap_end(ext2fs_block_bitmap bitmap,
 					blk_t end, blk_t *oend)
 {
-	return (ext2fs_fudge_generic_bitmap_end(bitmap,
-						EXT2_ET_MAGIC_BLOCK_BITMAP,
-						EXT2_ET_FUDGE_BLOCK_BITMAP_END,
-						end, oend));
+	return (ext2fs_fudge_generic_bmap_end(bitmap,
+					      EXT2_ET_FUDGE_BLOCK_BITMAP_END,
+					      end, oend));
 }
 
 void ext2fs_clear_inode_bitmap(ext2fs_inode_bitmap bitmap)
 {
-	ext2fs_clear_generic_bitmap(bitmap);
+	ext2fs_clear_generic_bmap(bitmap);
 }
 
 void ext2fs_clear_block_bitmap(ext2fs_block_bitmap bitmap)
 {
-	ext2fs_clear_generic_bitmap(bitmap);
+	ext2fs_clear_generic_bmap(bitmap);
 }
 
 errcode_t ext2fs_resize_inode_bitmap(__u32 new_end, __u32 new_real_end,
 				     ext2fs_inode_bitmap bmap)
 {
-	return (ext2fs_resize_generic_bitmap(EXT2_ET_MAGIC_INODE_BITMAP,
-					     new_end, new_real_end, bmap));
+	return (ext2fs_resize_generic_bmap(new_end, new_real_end, bmap));
 }
 
 errcode_t ext2fs_resize_block_bitmap(__u32 new_end, __u32 new_real_end,
 				     ext2fs_block_bitmap bmap)
 {
-	return (ext2fs_resize_generic_bitmap(EXT2_ET_MAGIC_BLOCK_BITMAP,
-					     new_end, new_real_end, bmap));
+	return (ext2fs_resize_generic_bmap(new_end, new_real_end, bmap));
+}
+
+errcode_t ext2fs_resize_inode_bitmap2(__u64 new_end, __u64 new_real_end,
+				      ext2fs_inode_bitmap bmap)
+{
+	return (ext2fs_resize_generic_bmap(new_end, new_real_end, bmap));
+}
+
+errcode_t ext2fs_resize_block_bitmap2(__u64 new_end, __u64 new_real_end,
+				     ext2fs_block_bitmap bmap)
+{
+	return (ext2fs_resize_generic_bmap(new_end, new_real_end, bmap));
 }
 
 errcode_t ext2fs_compare_block_bitmap(ext2fs_block_bitmap bm1,
@@ -150,34 +187,26 @@ errcode_t ext2fs_set_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 					ext2_ino_t start, unsigned int num,
 					void *in)
 {
-	return (ext2fs_set_generic_bitmap_range(bmap,
-						EXT2_ET_MAGIC_INODE_BITMAP,
-						start, num, in));
+	return (ext2fs_set_generic_bmap_range(bmap, start, num, in));
 }
 
 errcode_t ext2fs_get_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 					ext2_ino_t start, unsigned int num,
 					void *out)
 {
-	return (ext2fs_get_generic_bitmap_range(bmap,
-						EXT2_ET_MAGIC_INODE_BITMAP,
-						start, num, out));
+	return (ext2fs_get_generic_bmap_range(bmap, start, num, out));
 }
 
 errcode_t ext2fs_set_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *in)
 {
-	return (ext2fs_set_generic_bitmap_range(bmap,
-						EXT2_ET_MAGIC_BLOCK_BITMAP,
-						start, num, in));
+	return (ext2fs_set_generic_bmap_range(bmap, start, num, in));
 }
 
 errcode_t ext2fs_get_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *out)
 {
-	return (ext2fs_get_generic_bitmap_range(bmap,
-						EXT2_ET_MAGIC_BLOCK_BITMAP,
-						start, num, out));
+	return (ext2fs_get_generic_bmap_range(bmap, start, num, out));
 }
diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
index 485e997..a1cc78f 100644
--- a/lib/ext2fs/bitops.c
+++ b/lib/ext2fs/bitops.c
@@ -76,3 +76,43 @@ void ext2fs_warn_bitmap(errcode_t errcode, unsigned long arg,
 		com_err(0, errcode, "#%lu", arg);
 #endif
 }
+
+/*
+ * C-only 64 bit ops.  These are compiled and partially tested for
+ * 32-bit binaries, but will not work for bit numbers > 32 bits.
+ */
+
+int ext2fs_set_bit64(__u64 nr, void * addr)
+{
+	int		mask, retval;
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	retval = mask & *ADDR;
+	*ADDR |= mask;
+	return retval;
+}
+
+int ext2fs_clear_bit64(__u64 nr, void * addr)
+{
+	int		mask, retval;
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	retval = mask & *ADDR;
+	*ADDR &= ~mask;
+	return retval;
+}
+
+int ext2fs_test_bit64(__u64 nr, const void * addr)
+{
+	int			mask;
+	const unsigned char	*ADDR = (const unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	mask = 1 << (nr & 0x07);
+	return (mask & *ADDR);
+}
+
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 82ca138..920ab92 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -19,6 +19,11 @@ extern int ext2fs_clear_bit(unsigned int nr, void * addr);
 extern int ext2fs_test_bit(unsigned int nr, const void * addr);
 extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
 extern void ext2fs_fast_clear_bit(unsigned int nr, void * addr);
+extern int ext2fs_set_bit64(__u64 nr,void * addr);
+extern int ext2fs_clear_bit64(__u64 nr, void * addr);
+extern int ext2fs_test_bit64(__u64 nr, const void * addr);
+extern void ext2fs_fast_set_bit64(__u64 nr,void * addr);
+extern void ext2fs_fast_clear_bit64(__u64 nr, void * addr);
 extern __u16 ext2fs_swab16(__u16 val);
 extern __u32 ext2fs_swab32(__u32 val);
 extern __u64 ext2fs_swab64(__u64 val);
@@ -62,22 +67,24 @@ extern void ext2fs_warn_bitmap(errcode_t errcode, unsigned long arg,
 extern void ext2fs_warn_bitmap2(ext2fs_generic_bitmap bitmap,
 				int code, unsigned long arg);
 
-extern int ext2fs_mark_block_bitmap(ext2fs_block_bitmap bitmap, blk_t block);
+extern int ext2fs_mark_block_bitmap(ext2fs_block_bitmap bitmap, blk64_t block);
 extern int ext2fs_unmark_block_bitmap(ext2fs_block_bitmap bitmap,
-				       blk_t block);
-extern int ext2fs_test_block_bitmap(ext2fs_block_bitmap bitmap, blk_t block);
+				      blk64_t block);
+extern int ext2fs_test_block_bitmap(ext2fs_block_bitmap bitmap, blk64_t block);
 
-extern int ext2fs_mark_inode_bitmap(ext2fs_inode_bitmap bitmap, ext2_ino_t inode);
+extern int ext2fs_mark_inode_bitmap(ext2fs_inode_bitmap bitmap,
+				    ext2_ino_t inode);
 extern int ext2fs_unmark_inode_bitmap(ext2fs_inode_bitmap bitmap,
-				       ext2_ino_t inode);
-extern int ext2fs_test_inode_bitmap(ext2fs_inode_bitmap bitmap, ext2_ino_t inode);
+				      ext2_ino_t inode);
+extern int ext2fs_test_inode_bitmap(ext2fs_inode_bitmap bitmap,
+				    ext2_ino_t inode);
 
 extern void ext2fs_fast_mark_block_bitmap(ext2fs_block_bitmap bitmap,
-					  blk_t block);
+					  blk64_t block);
 extern void ext2fs_fast_unmark_block_bitmap(ext2fs_block_bitmap bitmap,
-					    blk_t block);
+					    blk64_t block);
 extern int ext2fs_fast_test_block_bitmap(ext2fs_block_bitmap bitmap,
-					 blk_t block);
+					 blk64_t block);
 
 extern void ext2fs_fast_mark_inode_bitmap(ext2fs_inode_bitmap bitmap,
 					  ext2_ino_t inode);
@@ -85,36 +92,37 @@ extern void ext2fs_fast_unmark_inode_bitmap(ext2fs_inode_bitmap bitmap,
 					    ext2_ino_t inode);
 extern int ext2fs_fast_test_inode_bitmap(ext2fs_inode_bitmap bitmap,
 					 ext2_ino_t inode);
-extern blk_t ext2fs_get_block_bitmap_start(ext2fs_block_bitmap bitmap);
+extern blk64_t ext2fs_get_block_bitmap_start(ext2fs_block_bitmap bitmap);
 extern ext2_ino_t ext2fs_get_inode_bitmap_start(ext2fs_inode_bitmap bitmap);
-extern blk_t ext2fs_get_block_bitmap_end(ext2fs_block_bitmap bitmap);
+extern blk64_t ext2fs_get_block_bitmap_end(ext2fs_block_bitmap bitmap);
 extern ext2_ino_t ext2fs_get_inode_bitmap_end(ext2fs_inode_bitmap bitmap);
 
 extern void ext2fs_mark_block_bitmap_range(ext2fs_block_bitmap bitmap,
-					   blk_t block, int num);
+					   blk64_t block, int num);
 extern void ext2fs_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
-					     blk_t block, int num);
+					     blk64_t block, int num);
 extern int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
-					  blk_t block, int num);
+					  blk64_t block, int num);
 extern void ext2fs_fast_mark_block_bitmap_range(ext2fs_block_bitmap bitmap,
-						blk_t block, int num);
+						blk64_t block, int num);
 extern void ext2fs_fast_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
-						  blk_t block, int num);
+						  blk64_t block, int num);
 extern int ext2fs_fast_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
-					       blk_t block, int num);
+					       blk64_t block, int num);
 extern void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map);
-
-/* These routines moved to gen_bitmap.c */
-extern int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
-					 __u32 bitno);
-extern int ext2fs_unmark_generic_bitmap(ext2fs_generic_bitmap bitmap,
-					   blk_t bitno);
-extern int ext2fs_test_generic_bitmap(ext2fs_generic_bitmap bitmap,
-				      blk_t bitno);
+extern void ext2fs_set_bmap_padding(ext2fs_generic_bitmap64 map);
+
+/* These routines moved to gen_bitmap64.c */
+extern int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
+				    __u64 bitno);
+extern int ext2fs_unmark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
+				      blk64_t bitno);
+extern int ext2fs_test_generic_bmap(ext2fs_generic_bitmap64 bitmap,
+				    blk64_t bitno);
 extern int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
-					  blk_t block, int num);
-extern __u32 ext2fs_get_generic_bitmap_start(ext2fs_generic_bitmap bitmap);
-extern __u32 ext2fs_get_generic_bitmap_end(ext2fs_generic_bitmap bitmap);
+					  blk64_t block, int num);
+extern __u32 ext2fs_get_generic_bmap_start(ext2fs_generic_bitmap64 bitmap);
+extern __u32 ext2fs_get_generic_bmap_end(ext2fs_generic_bitmap64 bitmap);
 
 /*
  * The inline routines themselves...
@@ -165,6 +173,23 @@ _INLINE_ void ext2fs_fast_clear_bit(unsigned int nr, void * addr)
 }
 
 
+_INLINE_ void ext2fs_fast_set_bit64(__u64 nr, void * addr)
+{
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	*ADDR |= (1 << (nr & 0x07));
+}
+
+_INLINE_ void ext2fs_fast_clear_bit64(__u64 nr, void * addr)
+{
+	unsigned char	*ADDR = (unsigned char *) addr;
+
+	ADDR += nr >> 3;
+	*ADDR &= ~(1 << (nr & 0x07));
+}
+
+
 #if ((defined __GNUC__) && !defined(_EXT2_USE_C_VERSIONS_) && \
      (defined(__i386__) || defined(__i486__) || defined(__i586__)))
 
@@ -408,119 +433,119 @@ _INLINE_ int ext2fs_find_next_bit_set (void * addr, int size, int offset)
 #endif
 
 _INLINE_ int ext2fs_mark_block_bitmap(ext2fs_block_bitmap bitmap,
-				       blk_t block)
+				      blk64_t block)
 {
-	return ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
-					  block);
+	return ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					block);
 }
 
 _INLINE_ int ext2fs_unmark_block_bitmap(ext2fs_block_bitmap bitmap,
-					 blk_t block)
+					blk64_t block)
 {
-	return ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
-					    block);
+	return ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					  block);
 }
 
 _INLINE_ int ext2fs_test_block_bitmap(ext2fs_block_bitmap bitmap,
-				       blk_t block)
+				      blk64_t block)
 {
-	return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap) bitmap,
-					  block);
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					block);
 }
 
 _INLINE_ int ext2fs_mark_inode_bitmap(ext2fs_inode_bitmap bitmap,
-				       ext2_ino_t inode)
+				      ext2_ino_t inode)
 {
-	return ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
-					  inode);
+	return ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					inode);
 }
 
 _INLINE_ int ext2fs_unmark_inode_bitmap(ext2fs_inode_bitmap bitmap,
-					 ext2_ino_t inode)
+					ext2_ino_t inode)
 {
-	return ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap) bitmap,
-				     inode);
+	return ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					  inode);
 }
 
 _INLINE_ int ext2fs_test_inode_bitmap(ext2fs_inode_bitmap bitmap,
-				       ext2_ino_t inode)
+				      ext2_ino_t inode)
 {
-	return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap) bitmap,
-					  inode);
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
+					inode);
 }
 
 _INLINE_ void ext2fs_fast_mark_block_bitmap(ext2fs_block_bitmap bitmap,
-					    blk_t block)
+					    blk64_t block)
 {
-	ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap) bitmap, block);
+	ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap, block);
 }
 
 _INLINE_ void ext2fs_fast_unmark_block_bitmap(ext2fs_block_bitmap bitmap,
-					      blk_t block)
+					      blk64_t block)
 {
-	ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap) bitmap, block);
+	ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap, block);
 }
 
 _INLINE_ int ext2fs_fast_test_block_bitmap(ext2fs_block_bitmap bitmap,
-					    blk_t block)
+					   blk64_t block)
 {
-	return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
 					  block);
 }
 
 _INLINE_ void ext2fs_fast_mark_inode_bitmap(ext2fs_inode_bitmap bitmap,
 					    ext2_ino_t inode)
 {
-	ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap) bitmap, inode);
+	ext2fs_mark_generic_bmap((ext2fs_generic_bitmap64) bitmap, inode);
 }
 
 _INLINE_ void ext2fs_fast_unmark_inode_bitmap(ext2fs_inode_bitmap bitmap,
 					      ext2_ino_t inode)
 {
-	ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap) bitmap, inode);
+	ext2fs_unmark_generic_bmap((ext2fs_generic_bitmap64) bitmap, inode);
 }
 
 _INLINE_ int ext2fs_fast_test_inode_bitmap(ext2fs_inode_bitmap bitmap,
 					   ext2_ino_t inode)
 {
-	return ext2fs_test_generic_bitmap((ext2fs_generic_bitmap) bitmap,
+	return ext2fs_test_generic_bmap((ext2fs_generic_bitmap64) bitmap,
 					  inode);
 }
 
-_INLINE_ blk_t ext2fs_get_block_bitmap_start(ext2fs_block_bitmap bitmap)
+_INLINE_ blk64_t ext2fs_get_block_bitmap_start(ext2fs_block_bitmap bitmap)
 {
-	return ext2fs_get_generic_bitmap_start((ext2fs_generic_bitmap) bitmap);
+	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap64) bitmap);
 }
 
 _INLINE_ ext2_ino_t ext2fs_get_inode_bitmap_start(ext2fs_inode_bitmap bitmap)
 {
-	return ext2fs_get_generic_bitmap_start((ext2fs_generic_bitmap) bitmap);
+	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap64) bitmap);
 }
 
-_INLINE_ blk_t ext2fs_get_block_bitmap_end(ext2fs_block_bitmap bitmap)
+_INLINE_ blk64_t ext2fs_get_block_bitmap_end(ext2fs_block_bitmap bitmap)
 {
-	return ext2fs_get_generic_bitmap_end((ext2fs_generic_bitmap) bitmap);
+	return ext2fs_get_generic_bmap_end((ext2fs_generic_bitmap64) bitmap);
 }
 
 _INLINE_ ext2_ino_t ext2fs_get_inode_bitmap_end(ext2fs_inode_bitmap bitmap)
 {
-	return ext2fs_get_generic_bitmap_end((ext2fs_generic_bitmap) bitmap);
+	return ext2fs_get_generic_bmap_end((ext2fs_generic_bitmap64) bitmap);
 }
 
 _INLINE_ int ext2fs_fast_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
-						 blk_t block, int num)
+						 blk64_t block, int num)
 {
 	return ext2fs_test_block_bitmap_range(bitmap, block, num);
 }
 
 _INLINE_ void ext2fs_fast_mark_block_bitmap_range(ext2fs_block_bitmap bitmap,
-						  blk_t block, int num)
+						  blk64_t block, int num)
 {
 	ext2fs_mark_block_bitmap_range(bitmap, block, num);
 }
 
 _INLINE_ void ext2fs_fast_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
-						    blk_t block, int num)
+						    blk64_t block, int num)
 {
 	ext2fs_unmark_block_bitmap_range(bitmap, block, num);
 }
diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 855a160..2e28a83 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -26,54 +26,203 @@
 #include "ext2_fs.h"
 #include "ext2fsP.h"
 
-static errcode_t ba_new_bmap(ext2_filsys fs, ext2fs_generic_bitmap64 *bmap)
+/*
+ * Private data for bit array implementation of bitmap ops.
+ * Currently, this is just a pointer to our big flat hunk of memory,
+ * exactly equivalent to the old-skool char * bitmap member.
+ */
+
+struct ext2fs_ba_private_struct {
+	char *bitarray;
+};
+
+typedef struct ext2fs_ba_private_struct *ext2fs_ba_private;
+
+static errcode_t ba_alloc_private_data (ext2fs_generic_bitmap64 bitmap)
 {
+	ext2fs_ba_private bp;
+	errcode_t	retval;
+	size_t		size;
+
+	/*
+	 * Since we only have the one pointer, we could just shove our
+	 * private data in the void *private field itself, but then
+	 * we'd have to do a fair bit of rewriting if we ever added a
+	 * field.  I'm agnostic.
+	 */
+	retval = ext2fs_get_mem(sizeof (ext2fs_ba_private), &bp);
+	if (retval)
+		return retval;
+
+	size = (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1);
+
+	retval = ext2fs_get_mem(size, &bp->bitarray);
+	if (retval) {
+		ext2fs_free_mem(&bp);
+		bp = 0;
+		return retval;
+	}
+	bitmap->private = (void *) bp;
+	return 0;
+}
+
+static errcode_t ba_new_bmap(ext2_filsys fs, ext2fs_generic_bitmap64 bitmap)
+{
+	ext2fs_ba_private bp;
+	errcode_t	retval;
+	size_t		size;
+
+	retval = ba_alloc_private_data (bitmap);
+	if (retval)
+		return retval;
+
+	bp = (ext2fs_ba_private) bitmap->private;
+	size = (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1);
+	memset(bp->bitarray, 0, size);
+
+	return 0;
 }
 
 static void ba_free_bmap(ext2fs_generic_bitmap64 bitmap)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	if (!bp)
+		return;
+
+	if (bp->bitarray) {
+		ext2fs_free_mem (&bp->bitarray);
+		bp->bitarray = 0;
+	}
+	ext2fs_free_mem (&bp);
+	bp = 0;
 }
 
 static errcode_t ba_copy_bmap(ext2fs_generic_bitmap64 src,
-			      ext2fs_generic_bitmap64 *dest)
+			      ext2fs_generic_bitmap64 dest)
 {
+	ext2fs_ba_private src_bp = (ext2fs_ba_private) src->private;
+	ext2fs_ba_private dest_bp;
+	errcode_t retval;
+	size_t size;
+
+	retval = ba_alloc_private_data (dest);
+	if (retval)
+		return retval;
+
+	dest_bp = (ext2fs_ba_private) dest->private;
+
+	size = (size_t) (((src->real_end - src->start) / 8) + 1);
+	memcpy (dest_bp->bitarray, src_bp->bitarray, size);
+
+	return 0;
 }
 
-static errcode_t ba_resize_bmap(ext2fs_generic_bitmap64 bitmap,
+static errcode_t ba_resize_bmap(ext2fs_generic_bitmap64 bmap,
 				__u64 new_end, __u64 new_real_end)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bmap->private;
+	errcode_t	retval;
+	size_t		size, new_size;
+	__u32		bitno;
+
+	/*
+	 * If we're expanding the bitmap, make sure all of the new
+	 * parts of the bitmap are zero.
+	 */
+	if (new_end > bmap->end) {
+		bitno = bmap->real_end;
+		if (bitno > new_end)
+			bitno = new_end;
+		for (; bitno > bmap->end; bitno--)
+			ext2fs_clear_bit64(bitno - bmap->start, bp->bitarray);
+	}
+	if (new_real_end == bmap->real_end) {
+		bmap->end = new_end;
+		return 0;
+	}
+	
+	size = ((bmap->real_end - bmap->start) / 8) + 1;
+	new_size = ((new_real_end - bmap->start) / 8) + 1;
+
+	if (size != new_size) {
+		retval = ext2fs_resize_mem(size, new_size, &bp->bitarray);
+		if (retval)
+			return retval;
+	}
+	if (new_size > size)
+		memset(bp->bitarray + size, 0, new_size - size);
+
+	bmap->end = new_end;
+	bmap->real_end = new_real_end;
+	return 0;
+
 }
 
 static int ba_mark_bmap(ext2fs_generic_bitmap64 bitmap, __u64 arg)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+
+	return ext2fs_set_bit64(bitno - bitmap->start, bp->bitarray);
 }
 
 static int ba_unmark_bmap(ext2fs_generic_bitmap64 bitmap, __u64 arg)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+
+	return ext2fs_clear_bit64(bitno - bitmap->start, bp->bitarray);
 }
 
 static int ba_test_bmap(ext2fs_generic_bitmap64 bitmap, __u64 arg)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+
+	return ext2fs_test_bit64(bitno - bitmap->start, bp->bitarray);
 }
 
 static void ba_mark_bmap_extent(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				 int num)
+				size_t num)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+	size_t i;
+
+	for (i = 0; i < num; i++)
+		ext2fs_fast_set_bit64(bitno + i - bitmap->start, bp->bitarray);
 }
 
 static void ba_unmark_bmap_extent(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				  int num)
+				  size_t num)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+	blk64_t bitno = (blk64_t) arg;
+	size_t i;
+
+	for (i = 0; i < num; i++)
+		ext2fs_fast_clear_bit64(bitno + i - bitmap->start, bp->bitarray);
 }
 
 static errcode_t ba_set_bmap_range(ext2fs_generic_bitmap64 bitmap,
-				     __u64 start, unsigned int num, void *in)
+				     __u64 start, size_t num, void *in)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	memcpy (bp->bitarray + (start >> 3), in, (num + 7) >> 3);
+
+	return 0;
 }
 
 static errcode_t ba_get_bmap_range(ext2fs_generic_bitmap64 bitmap,
-				     __u64 start, unsigned int num, void *out)
+				     __u64 start, size_t num, void *out)
 {
+	ext2fs_ba_private bp = (ext2fs_ba_private) bitmap->private;
+
+	memcpy (out, bp->bitarray + (start >> 3), (num + 7) >> 3);
+
+	return 0;
 }
 
 struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ad21fd7..faa44be 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -99,9 +99,15 @@ typedef struct struct_ext2_filsys *ext2_filsys;
 #define EXT2FS_UNMARK_ERROR 	1
 #define EXT2FS_TEST_ERROR	2
 
+/*
+ * We keep around ext2fs_generic_bitmap for backwards compatability in
+ * the underlying generic bitmap ops, but otherwise everything else
+ * becomes an ext2fs_generic_bitmap64.
+ */
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_generic_bitmap;
-typedef struct ext2fs_struct_generic_bitmap *ext2fs_inode_bitmap;
-typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;
+typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_generic_bitmap64;
+typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_inode_bitmap;
+typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_block_bitmap;
 
 #define EXT2_FIRST_INODE(s)	EXT2_FIRST_INO(s)
 
@@ -653,8 +659,8 @@ extern errcode_t ext2fs_update_bb_inode(ext2_filsys fs,
 /* bitmaps.c */
 extern void ext2fs_free_block_bitmap(ext2fs_block_bitmap bitmap);
 extern void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap bitmap);
-extern errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
-				    ext2fs_generic_bitmap *dest);
+extern errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap64 src,
+				    ext2fs_generic_bitmap64 *dest);
 extern errcode_t ext2fs_write_inode_bitmap(ext2_filsys fs);
 extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
@@ -949,7 +955,7 @@ extern void ext2fs_badblocks_list_free(ext2_badblocks_list bb);
 extern void ext2fs_u32_list_free(ext2_u32_list bb);
 
 /* gen_bitmap.c */
-extern void ext2fs_free_generic_bitmap(ext2fs_inode_bitmap bitmap);
+extern void ext2fs_free_generic_bitmap(ext2fs_generic_bitmap bitmap);
 extern errcode_t ext2fs_make_generic_bitmap(errcode_t magic, ext2_filsys fs,
 					    __u32 start, __u32 end,
 					    __u32 real_end,
@@ -963,11 +969,9 @@ extern errcode_t ext2fs_allocate_generic_bitmap(__u32 start,
 extern errcode_t ext2fs_copy_generic_bitmap(ext2fs_generic_bitmap src,
 					    ext2fs_generic_bitmap *dest);
 extern void ext2fs_clear_generic_bitmap(ext2fs_generic_bitmap bitmap);
-extern errcode_t ext2fs_fudge_generic_bitmap_end(ext2fs_inode_bitmap bitmap,
-						 errcode_t magic,
-						 errcode_t neq,
-						 ext2_ino_t end,
-						 ext2_ino_t *oend);
+errcode_t ext2fs_fudge_generic_bmap_end(ext2fs_generic_bitmap64 bmap,
+					errcode_t neq,
+					ext2_ino_t end, ext2_ino_t *oend);
 extern void ext2fs_set_generic_bitmap_padding(ext2fs_generic_bitmap map);
 extern errcode_t ext2fs_resize_generic_bitmap(errcode_t magic,
 					      __u32 new_end,
@@ -985,6 +989,24 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 						 __u32 start, __u32 num,
 						 void *in);
 
+/* gen_bitmap64.c */
+void ext2fs_free_generic_bmap(ext2fs_generic_bitmap64 bmap);
+errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
+				    int type, __u64 start, __u64 end,
+				    __u64 real_end,
+				    const char *descr,
+				    ext2fs_generic_bitmap64 *ret);
+errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
+				   ext2fs_generic_bitmap64 *dest);
+errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
+					__u64 start, unsigned int num,
+					void *out);
+errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
+					__u64 start, unsigned int num,
+					void *in);
+void ext2fs_set_generic_bmap_padding(ext2fs_generic_bitmap64 map);
+
+
 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 					blk_t *retblocks);
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 6f8a4e1..2e4ad74 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -113,15 +113,13 @@ struct ext2fs_struct_generic_bitmap64 {
 
 #define EXT2FS_BMAP64_BITARRAY	1
 
-typedef struct ext2fs_struct_generic_bitmap64 *ext2fs_generic_bitmap64;
-
 struct ext2_bitmap_ops {
 	int	type;
 	/* Generic bmap operators */
-	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 *bmap);
+	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 bmap);
 	void	(*free_bmap)(ext2fs_generic_bitmap64 bitmap);
 	errcode_t (*copy_bmap)(ext2fs_generic_bitmap64 src,
-			     ext2fs_generic_bitmap64 *dest);
+			     ext2fs_generic_bitmap64 dest);
 	errcode_t (*resize_bmap)(ext2fs_generic_bitmap64 bitmap,
 			       __u64 new_end,
 			       __u64 new_real_end);
@@ -130,13 +128,13 @@ struct ext2_bitmap_ops {
 	int	(*unmark_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
 	int	(*test_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
 	void	(*mark_bmap_extent)(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				  int num);
+				    size_t num);
 	void	(*unmark_bmap_extent)(ext2fs_generic_bitmap64 bitmap, __u64 arg,
-				    int num);
+				    size_t num);
 	errcode_t (*set_bmap_range)(ext2fs_generic_bitmap64 bitmap,
-				    __u64 start, unsigned int num, void *in);
+				    __u64 start, size_t num, void *in);
 	errcode_t (*get_bmap_range)(ext2fs_generic_bitmap64 bitmap,
-				    __u64 start, unsigned int num, void *out);
+				    __u64 start, size_t num, void *out);
 };
 
 extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index a1b1d8f..5aa6675 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -138,7 +138,7 @@ errcode_t ext2fs_copy_generic_bitmap(ext2fs_generic_bitmap src,
 					   dest));
 }
 
-void ext2fs_free_generic_bitmap(ext2fs_inode_bitmap bitmap)
+void ext2fs_free_generic_bitmap(ext2fs_generic_bitmap bitmap)
 {
 	if (check_magic(bitmap))
 		return;
@@ -204,7 +204,7 @@ void ext2fs_clear_generic_bitmap(ext2fs_generic_bitmap bitmap)
 	       (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1));
 }
 
-errcode_t ext2fs_fudge_generic_bitmap_end(ext2fs_inode_bitmap bitmap,
+errcode_t ext2fs_fudge_generic_bitmap_end(ext2fs_generic_bitmap bitmap,
 					  errcode_t magic, errcode_t neq,
 					  ext2_ino_t end, ext2_ino_t *oend)
 {
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 75af6de..df688b6 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -99,6 +99,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	if (retval)
 		return retval;
 
+	/* XXX factor out, repeated in copy_bmap */
 	bitmap->magic = magic;
 	bitmap->fs = fs;
 	bitmap->start = start;
@@ -125,7 +126,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	} else
 		bitmap->description = 0;
 
-	retval = bitmap->bitmap_ops->new_bmap(fs, &bitmap);
+	retval = bitmap->bitmap_ops->new_bmap(fs, bitmap);
 	if (retval) {
 		ext2fs_free_mem(&bitmap);
 		ext2fs_free_mem(&bitmap->description);
@@ -159,40 +160,58 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap64 bmap)
 }
 
 errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
-					  ext2fs_generic_bitmap64 *dest)
+				   ext2fs_generic_bitmap64 *dest)
 {
 	char *descr, *new_descr;
+	ext2fs_generic_bitmap64	new_bmap;
 	errcode_t retval;
 
 	if (!src)
-		return;
+		return EINVAL;
 
 	if (EXT2FS_IS_32_BITMAP(src)) {
 		ext2fs_copy_generic_bitmap((ext2fs_generic_bitmap) src,
 					   (ext2fs_generic_bitmap *) dest);
-		return;
+		return EINVAL;
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(src))
-		return;
+		return EINVAL;
+
+	/* Allocate a new bitmap struct */
+	retval = ext2fs_get_mem(sizeof(struct ext2fs_struct_generic_bitmap64),
+				&new_bmap);
+	if (retval)
+		return retval;
+
+	/* Copy all the high-level parts over */
+	new_bmap->magic = src->magic;
+	new_bmap->fs = src->fs;
+	new_bmap->start = src->start;
+	new_bmap->end = src->end;
+	new_bmap->real_end = src->real_end;
+	new_bmap->bitmap_ops = src->bitmap_ops;
+	new_bmap->base_error_code = src->base_error_code;
 
 	descr = src->description;
 	if (descr) {
 		retval = ext2fs_get_mem(strlen(descr)+1, &new_descr);
 		if (retval) {
-			new_descr = 0;
+			ext2fs_free_mem(&new_bmap);
 			return retval;
 		}
 		strcpy(new_descr, descr);
+		new_bmap->description = new_descr;
 	}
 
-	retval = src->bitmap_ops->copy_bmap(src, dest);
+	retval = src->bitmap_ops->copy_bmap(src, new_bmap);
 	if (retval) {
-		ext2fs_free_mem(&new_descr);
+		ext2fs_free_mem(&new_bmap->description);
+		ext2fs_free_mem(&new_bmap);
 		return retval;
 	}
 
-	(*dest)->description = new_descr;
+	*dest = new_bmap;
 
 	return 0;
 }
@@ -201,24 +220,47 @@ errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap64 bmap,
 				     __u64 new_end,
 				     __u64 new_real_end)
 {
-	errcode_t retval;
-
 	if (!bmap)
-		return;
+		return EINVAL;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
 		ext2fs_resize_generic_bitmap(bmap->magic,
 					     new_end, new_real_end,
 					     (ext2fs_generic_bitmap) bmap);
-		return;
+		return EINVAL;
 	}
 
 	if (!EXT2FS_IS_64_BITMAP(bmap))
-		return;
+		return EINVAL;
 
 	return bmap->bitmap_ops->resize_bmap(bmap, new_end, new_real_end);
 }
 
+errcode_t ext2fs_fudge_generic_bmap_end(ext2fs_generic_bitmap64 bmap,
+					errcode_t neq,
+					ext2_ino_t end, ext2_ino_t *oend)
+{
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		ext2fs_resize_generic_bitmap((ext2fs_generic_bitmap) bmap,
+					     bmap->magic, neq,
+					     new_end, new_real_end);
+		return EINVAL;
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	if (end > bitmap->real_end)
+		return neq;
+	if (oend)
+		*oend = bitmap->end;
+	bitmap->end = end;
+	return 0;
+}
+
 int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 			     __u64 arg)
 {
@@ -303,9 +345,7 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap64 bitmap,
 void ext2fs_mark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 				     __u64 arg, int num)
 {
-	errcode_t retval;
-	__u32 i;
-	int c;
+	int i;
 
 	if (!bmap)
 		return;
@@ -316,9 +356,9 @@ void ext2fs_mark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 					    EXT2FS_MARK_ERROR, 0xffffffff);
 			return;
 		}
-		for (i = arg, c = num; c > 0; c--)
+		for (i = 0; i < num; i++)
 			ext2fs_mark_generic_bitmap((ext2fs_generic_bitmap)
-						   bmap, i);
+						   bmap, arg + i);
 		return;
 	}
 
@@ -331,9 +371,7 @@ void ext2fs_mark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 void ext2fs_unmark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 				      __u64 arg, int num)
 {
-	errcode_t retval;
 	__u32 i;
-	int c;
 
 	if (!bmap)
 		return;
@@ -344,9 +382,9 @@ void ext2fs_unmark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return;
 		}
-		for (i = arg, c = num; c > 0; c--)
+		for (i = 0; i < num; i++)
 			ext2fs_unmark_generic_bitmap((ext2fs_generic_bitmap)
-						     bmap, i);
+						     bmap, arg + i);
 		return;
 	}
 
@@ -356,14 +394,73 @@ void ext2fs_unmark_generic_bmap_extent(ext2fs_generic_bitmap64 bmap,
 	bmap->bitmap_ops->unmark_bmap_extent(bmap, arg, num);
 }
 
-errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bitmap,
+errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
 					__u64 start, unsigned int num,
 					void *in)
 {
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((start+num) & ~0xffffffff) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return EINVAL;
+		}
+		return ext2fs_set_generic_bitmap_range((ext2fs_generic_bitmap) bmap,
+						       bmap->magic, start, num,
+						       in);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	return bmap->bitmap_ops->set_bmap_range(bmap, start, num, in);
 }
 
-errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap64 bitmap,
+errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap64 bmap,
 					__u64 start, unsigned int num,
 					void *out)
 {
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		if ((start+num) & ~0xffffffff) {
+			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
+					    EXT2FS_UNMARK_ERROR, 0xffffffff);
+			return EINVAL;
+		}
+		return ext2fs_get_generic_bitmap_range((ext2fs_generic_bitmap) bmap,
+						       bmap->magic, start, num,
+						       out);
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	return bmap->bitmap_ops->get_bmap_range(bmap, start, num, out);
+}
+
+void ext2fs_set_generic_bmap_padding(ext2fs_generic_bitmap64 map)
+{
+	__u64	i, j;
+
+	if (!bmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_32_BITMAP(bmap)) {
+		ext2fs_set_generic_bitmap_padding((ext2fs_generic_bitmap) bmap);
+		return EINVAL;
+	}
+
+	if (!EXT2FS_IS_64_BITMAP(bmap))
+		return EINVAL;
+
+	/* Protect loop from wrap-around if map->real_end is maxed */
+	for (i=map->end+1, j = i - map->start; 
+	     i <= map->real_end && i > map->end; 
+	     i++, j++)
+		ext2fs_set_bit64(j, map->bitmap);
 }
+
diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
index 0154333..ba72e46 100644
--- a/lib/ext2fs/imager.c
+++ b/lib/ext2fs/imager.c
@@ -277,7 +277,7 @@ errout:
  */
 errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 {
-	ext2fs_generic_bitmap	bmap;
+	ext2fs_generic_bitmap64	bmap;
 	errcode_t		err, retval;
 	ssize_t			actual;
 	__u32			itr, cnt, size;
@@ -314,8 +314,8 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
 		if (size > (cnt >> 3))
 			size = (cnt >> 3);
 
-		retval = ext2fs_get_generic_bitmap_range(bmap,
-				 err, itr, size << 3, buf);
+		retval = ext2fs_get_generic_bmap_range(bmap,
+				 itr, size << 3, buf);
 		if (retval)
 			return retval;
 
@@ -354,7 +354,7 @@ errcode_t ext2fs_image_bitmap_write(ext2_filsys fs, int fd, int flags)
  */
 errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 {
-	ext2fs_generic_bitmap	bmap;
+	ext2fs_generic_bitmap64	bmap;
 	errcode_t		err, retval;
 	__u32			itr, cnt;
 	char			buf[1024];
@@ -396,8 +396,8 @@ errcode_t ext2fs_image_bitmap_read(ext2_filsys fs, int fd, int flags)
 		if (actual != (int) size)
 			return EXT2_ET_SHORT_READ;
 
-		retval = ext2fs_set_generic_bitmap_range(bmap,
-				 err, itr, size << 3, buf);
+		retval = ext2fs_set_generic_bmap_range(bmap,
+				 itr, size << 3, buf);
 		if (retval)
 			return retval;
 
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index b75cb77..667f3c6 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -11,6 +11,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <time.h>
 #if HAVE_UNISTD_H
 #include <unistd.h>
 #endif
diff --git a/lib/ext2fs/tst_bitops.c b/lib/ext2fs/tst_bitops.c
index 6febe68..f05a54a 100644
--- a/lib/ext2fs/tst_bitops.c
+++ b/lib/ext2fs/tst_bitops.c
@@ -169,5 +169,127 @@ int main(int argc, char **argv)
 
 	printf("ext2fs_fast_set_bit big_test successful\n");
 
+	/* Repeat foregoing tests for 64-bit bitops */
+
+	/* Test test_bit */
+	for (i=0,j=0; i < size; i++) {
+		if (ext2fs_test_bit64(i, bitarray)) {
+			if (bits_list[j] == i) {
+				j++;
+			} else {
+				printf("64-bit: Bit %d set, not expected\n",
+				       i);
+				exit(1);
+			}
+		} else {
+			if (bits_list[j] == i) {
+				printf("64-bit: "
+				       "Expected bit %d to be clear.\n", i);
+				exit(1);
+			}
+		}
+	}
+	printf("64-bit: ext2fs_test_bit appears to be correct\n");
+
+	/* Test ext2fs_set_bit */
+	memset(testarray, 0, sizeof(testarray));
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_set_bit64(bits_list[i], testarray);
+	}
+	if (memcmp(testarray, bitarray, sizeof(testarray)) == 0) {
+		printf("64-bit: ext2fs_set_bit test succeeded.\n");
+	} else {
+		printf("64-bit: ext2fs_set_bit test failed.\n");
+		for (i=0; i < sizeof(testarray); i++) {
+			printf("%02x ", testarray[i]);
+		}
+		printf("\n");
+		exit(1);
+	}
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_clear_bit64(bits_list[i], testarray);
+	}
+	for (i=0; i < sizeof(testarray); i++) {
+		if (testarray[i]) {
+			printf("64-bit: ext2fs_clear_bit failed, "
+			       "testarray[%d] is %d\n", i, testarray[i]);
+			exit(1);
+		}
+	}
+	printf("64-bit: ext2fs_clear_bit test succeed.\n");
+		
+
+	/* Do bigarray test */
+	bigarray = malloc(1 << 29);
+	if (!bigarray) {
+		fprintf(stderr, "Failed to allocate scratch memory!\n");
+		exit(1);
+	}
+
+        bigarray[BIG_TEST_BIT >> 3] = 0;
+
+	ext2fs_set_bit64(BIG_TEST_BIT, bigarray);
+	printf("64-bit: big bit number (%u) test: %d, expected %d\n",
+	       BIG_TEST_BIT, bigarray[BIG_TEST_BIT >> 3],
+	       (1 << (BIG_TEST_BIT & 7)));
+	if (bigarray[BIG_TEST_BIT >> 3] != (1 << (BIG_TEST_BIT & 7)))
+		exit(1);
+
+	ext2fs_clear_bit64(BIG_TEST_BIT, bigarray);
+
+	printf("64-bit: big bit number (%u) test: %d, expected 0\n",
+	       BIG_TEST_BIT,
+	       bigarray[BIG_TEST_BIT >> 3]);
+	if (bigarray[BIG_TEST_BIT >> 3] != 0)
+		exit(1);
+
+	printf("64-bit: ext2fs_set_bit big_test successful\n");
+
+	/* Now test ext2fs_fast_set_bit */
+	memset(testarray, 0, sizeof(testarray));
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_fast_set_bit64(bits_list[i], testarray);
+	}
+	if (memcmp(testarray, bitarray, sizeof(testarray)) == 0) {
+		printf("64-bit: ext2fs_fast_set_bit test succeeded.\n");
+	} else {
+		printf("64-bit: ext2fs_fast_set_bit test failed.\n");
+		for (i=0; i < sizeof(testarray); i++) {
+			printf("%02x ", testarray[i]);
+		}
+		printf("\n");
+		exit(1);
+	}
+	for (i=0; bits_list[i] > 0; i++) {
+		ext2fs_clear_bit64(bits_list[i], testarray);
+	}
+	for (i=0; i < sizeof(testarray); i++) {
+		if (testarray[i]) {
+			printf("64-bit: ext2fs_clear_bit failed, "
+			       "testarray[%d] is %d\n", i, testarray[i]);
+			exit(1);
+		}
+	}
+	printf("64-bit: ext2fs_clear_bit test succeed.\n");
+		
+
+        bigarray[BIG_TEST_BIT >> 3] = 0;
+
+	ext2fs_fast_set_bit64(BIG_TEST_BIT, bigarray);
+	printf("64-bit: big bit number (%u) test: %d, expected %d\n",
+	       BIG_TEST_BIT, bigarray[BIG_TEST_BIT >> 3],
+	       (1 << (BIG_TEST_BIT & 7)));
+	if (bigarray[BIG_TEST_BIT >> 3] != (1 << (BIG_TEST_BIT & 7)))
+		exit(1);
+
+	ext2fs_fast_clear_bit64(BIG_TEST_BIT, bigarray);
+
+	printf("64-bit: big bit number (%u) test: %d, expected 0\n",
+	       BIG_TEST_BIT, bigarray[BIG_TEST_BIT >> 3]);
+	if (bigarray[BIG_TEST_BIT >> 3] != 0)
+		exit(1);
+
+	printf("64-bit: ext2fs_fast_set_bit big_test successful\n");
+
 	exit(0);
 }
diff --git a/lib/uuid/gen_uuid.c b/lib/uuid/gen_uuid.c
index a3052d4..76c989c 100644
--- a/lib/uuid/gen_uuid.c
+++ b/lib/uuid/gen_uuid.c
@@ -35,8 +35,10 @@
 /*
  * Force inclusion of SVID stuff since we need it if we're compiling in
  * gcc-wall wall mode
+ *
+ * XXX - below somehow hides ftruncate() definition and _creates_ warnings
  */
-#define _SVID_SOURCE
+/* #define _SVID_SOURCE */
 
 #ifdef _WIN32
 #define _WIN32_WINNT 0x0500
diff --git a/misc/blkid.c b/misc/blkid.c
index 4bbf9fb..e5c8088 100644
--- a/misc/blkid.c
+++ b/misc/blkid.c
@@ -170,7 +170,6 @@ static void pretty_print_dev(blkid_dev dev)
 	blkid_tag_iterate	iter;
 	const char		*type, *value, *devname;
 	const char		*uuid = "", *fs_type = "", *label = "";
-	char			*cp;
 	int			len, mount_flags;
 	char			mtpt[80];
 	errcode_t		retval;
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 9ef5476..1c70c24 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -214,7 +214,7 @@ static void list_desc (ext2_filsys fs)
 		diff = fs->group_desc[i].bg_inode_table - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
-		printf (_("\n  %u free blocks, %u free inodes, "
+		printf (_("\n  %d free blocks, %u free inodes, "
 			  "%u directories%s"),
 			fs->group_desc[i].bg_free_blocks_count,
 			fs->group_desc[i].bg_free_inodes_count,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 77f1bc0..be9f4e6 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -48,6 +48,7 @@ extern int optind;
 #include <sys/types.h>
 #include <libgen.h>
 #include <limits.h>
+#include <strings.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "et/com_err.h"
@@ -380,7 +381,7 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
 		if (retval) {
 			fprintf(stderr, _("\nCould not write %d "
-				  "blocks in inode table starting at %ull: %s\n"),
+				  "blocks in inode table starting at %llu: %s\n"),
 				num, blk, error_message(retval));
 			exit(1);
 		}
@@ -597,7 +598,7 @@ static void show_stats(ext2_filsys fs)
 	int			need, col_left;
 
 	if (ext2fs_blocks_count(&fs_param) != ext2fs_blocks_count(s))
-		fprintf(stderr, _("warning: %u blocks unused.\n\n"),
+		fprintf(stderr, _("warning: %llu blocks unused.\n\n"),
 		       ext2fs_blocks_count(&fs_param) - ext2fs_blocks_count(s));
 
 	memset(buf, 0, sizeof(buf));
@@ -1995,7 +1996,7 @@ int main (int argc, char *argv[])
 
 		if (retval) {
 			com_err(program_name, retval,
-				_("while zeroing block %u at end of filesystem"),
+				_("while zeroing block %llu at end of filesystem"),
 				ret_blk);
 		}
 		write_inode_tables(fs, lazy_itable_init);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a1fa57b..04e2b9f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1440,7 +1440,7 @@ retry_open:
 		 * file.
 		 */
 		if (new_inode_size == EXT2_INODE_SIZE(fs->super)) {
-			fprintf(stderr, _("The inode size is already %d\n"),
+			fprintf(stderr, _("The inode size is already %lu\n"),
 				new_inode_size);
 			exit(1);
 		}

