From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 4/8][e2fsprogs] add new macro to get descriptor number
Date: Thu, 30 Aug 2007 17:38:13 +0200
Message-ID: <1188488293.15770.49.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43766 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291AbXH3N0m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:42 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

This patch introduces a new macro EXT2_DESC_PER_BLOCK to calculate the number
of group descriptors per block as two different structures are now defined,
ext4_group_desc structure for ext4 filesystems and ext2_group_desc structure
for older filesystems.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 lib/ext2fs/closefs.c    |    2 +-
 lib/ext2fs/ext2_fs.h    |    2 +-
 lib/ext2fs/initialize.c |    2 +-
 lib/ext2fs/openfs.c     |    4 ++--
 misc/mke2fs.c           |    5 ++---
 resize/resize2fs.c      |    7 +++----
 6 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index efbb727..da95b54 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -80,7 +80,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 		super_blk = group_block;
 		numblocks--;
 	}
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	meta_bg = group / meta_bg_size;
 
 	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f6e8b36..3941c38 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -234,7 +234,7 @@ struct ext2_dx_countlimit {
 #define EXT2_DESC_PER_BLOCK(s)		(EXT2_SB(s)->s_desc_per_block)
 #define EXT2_DESC_PER_BLOCK_BITS(s)	(EXT2_SB(s)->s_desc_per_block_bits)
 #else
-#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (struct ext2_group_desc))
+#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))
 #endif
 
 /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index ee7af93..f5bff1e 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -67,7 +67,7 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 {
 	struct ext2_super_block *sb = fs->super;
 	unsigned long bpg = sb->s_blocks_per_group;
-	unsigned int gdpb = fs->blocksize / sizeof(struct ext2_group_desc);
+	unsigned int gdpb = EXT2_DESC_PER_BLOCK(sb);
 	unsigned long max_blocks = 0xffffffff;
 	unsigned long rsv_groups;
 	unsigned int rsv_gdb;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 8a369c3..73ab088 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -39,7 +39,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
 	    (i < fs->super->s_first_meta_bg))
 		return (group_block + i + 1);
 
-	bg = (fs->blocksize / sizeof (struct ext2_group_desc)) * i;
+	bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
 	if (ext2fs_bg_has_super(fs, bg))
 		has_super = 1;
 	ret_blk = ext2fs_group_first_block(fs, bg) + has_super;
@@ -282,7 +282,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	if (!group_block)
 		group_block = fs->super->s_first_data_block;
 	dest = (char *) fs->group_desc;
-	groups_per_block = fs->blocksize / sizeof(struct ext2_group_desc);
+	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
 	for (i=0 ; i < fs->desc_blocks; i++) {
 		blk = ext2fs_descriptor_block_loc(fs, group_block, i);
 		retval = io_channel_read_blk(fs->io, blk, 1, dest);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 115eef9..3dc5e18 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -693,8 +693,7 @@ static void show_stats(ext2_filsys fs)
 	if (s->s_reserved_gdt_blocks)
 		printf(_("Maximum filesystem blocks=%lu\n"),
 		       (s->s_reserved_gdt_blocks + fs->desc_blocks) *
-		       (fs->blocksize / sizeof(struct ext2_group_desc)) *
-		       s->s_blocks_per_group);
+		       EXT2_DESC_PER_BLOCK(s) * s->s_blocks_per_group);
 	if (fs->group_desc_count > 1)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
@@ -826,7 +825,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			bpg = param->s_blocks_per_group;
 			if (!bpg)
 				bpg = blocksize * 8;
-			gdpb = blocksize / sizeof(struct ext2_group_desc);
+			gdpb = EXT2_DESC_PER_BLOCK(param);
 			group_desc_count = 
 				ext2fs_div_ceil(param->s_blocks_count, bpg);
 			desc_blocks = (group_desc_count +
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0d6a082..12bdd89 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -383,8 +383,7 @@ retry:
 			ext2fs_mark_block_bitmap(fs->block_map, group_block);
 			adjblocks++;
 		}
-		meta_bg_size = (fs->blocksize /
-				sizeof (struct ext2_group_desc));
+		meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 		meta_bg = i / meta_bg_size;
 		if (!(fs->super->s_feature_incompat &
 		      EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -550,7 +549,7 @@ static errcode_t mark_table_blocks(ext2_filsys fs,
 	unsigned long		meta_bg_size;
 	unsigned int		old_desc_blocks;
 
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
@@ -717,7 +716,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	 * If we're increasing the number of descriptor blocks, life
 	 * gets interesting....  
 	 */
-	meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	for (i = 0; i < max_groups; i++) {
 		has_super = ext2fs_bg_has_super(fs, i);
 		if (has_super)
