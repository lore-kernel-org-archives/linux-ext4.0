From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 1/12] new ext4 group desc struct in e2fsprogs
Date: Mon, 11 Jun 2007 18:42:08 +0200
Message-ID: <466D7B60.3050108@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030603060001020105000108"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48126 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXFKQkq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:40:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030603060001020105000108
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

A different groups descriptor structure was introduced for ext4 filesystems.
This patch handles that.

  debugfs/debugfs.c    |    9 +++++++++
  debugfs/set_fields.c |    4 ++++
  e2fsck/super.c       |    4 ++++
  lib/ext2fs/closefs.c |    5 +++++
  lib/ext2fs/ext2fs.h  |    8 ++++++++
  lib/ext2fs/openfs.c  |    7 ++++++-
  lib/ext2fs/swapfs.c  |    4 ++++
  misc/mke2fs.c        |    4 ++++
  resize/resize2fs.c   |    2 +-
  9 files changed, 45 insertions(+), 2 deletions(-)



--------------030603060001020105000108
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="01-handle-new-ext4-group-desc-struct"
Content-Disposition: inline;
 filename="01-handle-new-ext4-group-desc-struct"

Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext2fs.h	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2fs.h	2007-06-08 12:40:21.000000000 +0200
@@ -213,7 +213,11 @@ struct struct_ext2_filsys {
 	int				fragsize;
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
+#ifdef _EXT4FS_
+	struct ext4_group_desc *	group_desc;
+#else
 	struct ext2_group_desc *	group_desc;
+#endif
 	int				inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
@@ -1003,7 +1007,11 @@ extern errcode_t ext2fs_copy_bitmap(ext2
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, 
 				 int has_header);
 extern void ext2fs_swap_super(struct ext2_super_block * super);
+#ifdef _EXT4FS_
+extern void ext2fs_swap_group_desc(struct ext4_group_desc *gdp);
+#else
 extern void ext2fs_swap_group_desc(struct ext2_group_desc *gdp);
+#endif
 extern void ext2fs_swap_extent_header(struct ext3_extent_header *eh);
 extern void ext2fs_swap_extent_index(struct ext3_extent_idx *ix);
 extern void ext2fs_swap_extent(struct ext3_extent *ex);
Index: e2fsprogs-1.39-tyt3-v6/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/debugfs/set_fields.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/debugfs/set_fields.c	2007-06-08 12:40:21.000000000 +0200
@@ -31,7 +31,11 @@
 
 static struct ext2_super_block set_sb;
 static struct ext2_inode set_inode;
+#ifdef _EXT4FS_
+static struct ext4_group_desc set_gd;
+#else
 static struct ext2_group_desc set_gd;
+#endif
 static ext2_ino_t set_ino;
 static int array_idx;
 
Index: e2fsprogs-1.39-tyt3-v6/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/resize/resize2fs.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/resize/resize2fs.c	2007-06-08 12:40:21.000000000 +0200
@@ -365,7 +365,7 @@ retry:
 	for (i = old_fs->group_desc_count;
 	     i < fs->group_desc_count; i++) {
 		memset(&fs->group_desc[i], 0,
-		       sizeof(struct ext2_group_desc));
+		       sizeof(fs->group_desc[0]));
 		adjblocks = 0;
 
 		if (i == fs->group_desc_count-1) {
Index: e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/misc/mke2fs.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c	2007-06-08 12:40:21.000000000 +0200
@@ -449,7 +449,11 @@ static void setup_lazy_bg(ext2_filsys fs
 	dgrp_t i;
 	int blks;
 	struct ext2_super_block *sb = fs->super;
+#ifdef _EXT4FS_
+	struct ext4_group_desc *bg = fs->group_desc;
+#else
 	struct ext2_group_desc *bg = fs->group_desc;
+#endif
 
 	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
 				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
Index: e2fsprogs-1.39-tyt3-v6/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/debugfs/debugfs.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/debugfs/debugfs.c	2007-06-08 12:40:21.000000000 +0200
@@ -267,8 +267,13 @@ static void print_features(struct ext2_s
 	fputs("\n", f);
 }
 
+#ifdef _EXT4FS_
+static void print_bg_opts(struct ext4_group_desc *gdp, int mask,
+			  const char *str, int *first, FILE *f)
+#else
 static void print_bg_opts(struct ext2_group_desc *gdp, int mask,
 			  const char *str, int *first, FILE *f)
+#endif
 {
 	if (gdp->bg_flags & mask) {
 		if (*first) {
@@ -284,7 +289,11 @@ void do_show_super_stats(int argc, char 
 {
 	dgrp_t	i;
 	FILE 	*out;
+#ifdef _EXT4FS_
+	struct ext4_group_desc *gdp;
+#else
 	struct ext2_group_desc *gdp;
+#endif
 	int	c, header_only = 0;
 	int	numdirs = 0, first;
 
Index: e2fsprogs-1.39-tyt3-v6/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/e2fsck/super.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/e2fsck/super.c	2007-06-08 12:40:21.000000000 +0200
@@ -470,7 +470,11 @@ void check_super_block(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	blk_t	first_block, last_block;
 	struct ext2_super_block *sb = fs->super;
+#ifdef _EXT4FS_
+	struct ext4_group_desc *gd;
+#else
 	struct ext2_group_desc *gd;
+#endif
 	blk_t	blocks_per_group = fs->super->s_blocks_per_group;
 	blk_t	bpg_max;
 	int	inodes_per_block;
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/swapfs.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/swapfs.c	2007-06-08 12:40:21.000000000 +0200
@@ -77,7 +77,11 @@ void ext2fs_swap_super(struct ext2_super
 
 }
 
+#ifdef _EXT4FS_
+void ext2fs_swap_group_desc(struct ext4_group_desc *gdp)
+#else
 void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
+#endif
 {
 	gdp->bg_block_bitmap = ext2fs_swab32(gdp->bg_block_bitmap);
 	gdp->bg_inode_bitmap = ext2fs_swab32(gdp->bg_inode_bitmap);
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/openfs.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/openfs.c	2007-06-08 12:40:21.000000000 +0200
@@ -90,7 +90,6 @@ errcode_t ext2fs_open2(const char *name,
 	int		j, groups_per_block, blocks_per_group, io_flags;
 	blk_t		group_block, blk;
 	char		*dest, *cp;
-	struct ext2_group_desc *gdp;
 	
 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
 
@@ -289,7 +288,13 @@ errcode_t ext2fs_open2(const char *name,
 			goto cleanup;
 #ifdef EXT2FS_ENABLE_SWAPFS
 		if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
+#ifdef _EXT4FS_
+			struct ext4_group_desc *gdp;
+			gdp = (struct ext4_group_desc *) dest;
+#else
+			struct ext2_group_desc *gdp;
 			gdp = (struct ext2_group_desc *) dest;
+#endif
 			for (j=0; j < groups_per_block; j++)
 				ext2fs_swap_group_desc(gdp++);
 		}
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/closefs.c	2007-06-08 12:40:04.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/closefs.c	2007-06-08 12:40:21.000000000 +0200
@@ -209,8 +209,13 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 	errcode_t	retval;
 	unsigned long	fs_state;
 	struct ext2_super_block *super_shadow = 0;
+#ifdef _EXT4FS_
+	struct ext4_group_desc *group_shadow = 0;
+	struct ext4_group_desc *s, *t;
+#else
 	struct ext2_group_desc *group_shadow = 0;
 	struct ext2_group_desc *s, *t;
+#endif
 	char	*group_ptr;
 	int	old_desc_blocks;
 	

--------------030603060001020105000108--
