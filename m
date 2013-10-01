From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/31] e2fsprogs: Fix blk_t <- blk64_t assignment mismatches
Date: Mon, 30 Sep 2013 18:27:59 -0700
Message-ID: <20131001012759.28415.27498.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22523 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB2D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:28:03 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix all the places where we should be using a blk64_t instead of a blk_t.
These fixes are more severe because 64bit values could be truncated silently.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/logdump.c      |    8 ++++----
 debugfs/set_fields.c   |   10 ++++------
 e2fsck/e2fsck.h        |    6 +++---
 e2fsck/journal.c       |    6 +++++-
 e2fsck/message.c       |    2 +-
 e2fsck/pass1.c         |    2 +-
 e2fsck/pass3.c         |    5 ++++-
 e2fsck/rehash.c        |    2 +-
 e2fsck/unix.c          |    2 +-
 e2fsck/util.c          |    6 +++---
 lib/ext2fs/closefs.c   |    2 +-
 lib/ext2fs/ext2fsP.h   |    2 +-
 lib/ext2fs/fileio.c    |    2 +-
 lib/ext2fs/inode.c     |    6 +++---
 lib/ext2fs/punch.c     |    2 +-
 lib/ext2fs/tst_iscan.c |    2 +-
 misc/dumpe2fs.c        |    2 +-
 misc/tune2fs.c         |   14 +++++++-------
 18 files changed, 43 insertions(+), 38 deletions(-)


diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 4a09bdb..db085cb 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -37,10 +37,10 @@ extern char *optarg;
 
 enum journal_location {JOURNAL_IS_INTERNAL, JOURNAL_IS_EXTERNAL};
 
-#define ANY_BLOCK ((blk_t) -1)
+#define ANY_BLOCK ((blk64_t) -1)
 
 int		dump_all, dump_contents, dump_descriptors;
-blk_t		block_to_dump, bitmap_to_dump, inode_block_to_dump;
+blk64_t		block_to_dump, bitmap_to_dump, inode_block_to_dump;
 unsigned int	group_to_dump, inode_offset_to_dump;
 ext2_ino_t	inode_to_dump;
 
@@ -162,7 +162,7 @@ void do_logdump(int argc, char **argv)
 			(group_offset / inodes_per_block);
 		inode_offset_to_dump = ((group_offset % inodes_per_block)
 					* sizeof(struct ext2_inode));
-		printf("Inode %u is at group %u, block %u, offset %u\n",
+		printf("Inode %u is at group %u, block %llu, offset %u\n",
 		       inode_to_dump, inode_group,
 		       inode_block_to_dump, inode_offset_to_dump);
 	}
@@ -624,7 +624,7 @@ static void dump_metadata_block(FILE *out_file, struct journal_source *source,
 		offset = ((block_to_dump - super->s_first_data_block) %
 			  super->s_blocks_per_group);
 
-		fprintf(out_file, "    (block bitmap for block %u: "
+		fprintf(out_file, "    (block bitmap for block %llu: "
 			"block is %s)\n",
 			block_to_dump,
 			ext2fs_test_bit(offset, buf) ? "SET" : "CLEAR");
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 3925f24..aad1cd8 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -531,22 +531,20 @@ static errcode_t parse_hashalg(struct field_set_info *info,
 static errcode_t parse_bmap(struct field_set_info *info,
 			    char *field EXT2FS_ATTR((unused)), char *arg)
 {
-	unsigned long	num;
-	blk_t		blk;
+	blk64_t		blk;
 	errcode_t	retval;
 	char		*tmp;
 
-	num = strtoul(arg, &tmp, 0);
+	blk = strtoull(arg, &tmp, 0);
 	if (*tmp) {
 		fprintf(stderr, "Couldn't parse '%s' for field %s.\n",
 			arg, info->name);
 		return EINVAL;
 	}
-	blk = num;
 
-	retval = ext2fs_bmap(current_fs, set_ino,
+	retval = ext2fs_bmap2(current_fs, set_ino,
 			     (struct ext2_inode *) &set_inode,
-			     0, BMAP_SET, array_idx, &blk);
+			     NULL, BMAP_SET, array_idx, NULL, &blk);
 	if (retval) {
 		com_err("set_inode", retval, "while setting block map");
 	}
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 09a9d08..13d70f1 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -119,9 +119,9 @@ struct dx_dir_info {
 
 struct dx_dirblock_info {
 	int		type;
-	blk_t		phys;
+	blk64_t		phys;
 	int		flags;
-	blk_t		parent;
+	blk64_t		parent;
 	ext2_dirhash_t	min_hash;
 	ext2_dirhash_t	max_hash;
 	ext2_dirhash_t	node_min_hash;
@@ -547,7 +547,7 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 #ifdef MTRACE
 extern void mtrace_print(char *mesg);
 #endif
-extern blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
+extern blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
 			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
 extern int write_all(int fd, char *buf, size_t count);
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 45d9462..2509303 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -291,6 +291,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 	unsigned long long	start = 0;
 	int			ext_journal = 0;
 	int			tried_backup_jnl = 0;
+	blk64_t			maxlen;
 
 	clear_problem_context(&pctx);
 
@@ -474,7 +475,10 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			goto errout;
 		}
 
-		journal->j_maxlen = ext2fs_blocks_count(&jsuper);
+		maxlen = ext2fs_blocks_count(&jsuper);
+		if (maxlen > 1ULL << 32)
+			maxlen = (1ULL << 32) - 1;
+		journal->j_maxlen = maxlen;
 		start++;
 	}
 
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 72a56ca..8ddfd12 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -489,7 +489,7 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 #endif
 		break;
 	case 'S':
-		fprintf(f, "%u", get_backup_sb(NULL, fs, NULL, NULL));
+		fprintf(f, "%llu", get_backup_sb(NULL, fs, NULL, NULL));
 		break;
 	case 's':
 		fprintf(f, "%*s", width, ctx->str ? ctx->str : "NULL");
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 24b2e16..ab23e42 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2685,7 +2685,7 @@ static int process_bad_block(ext2_filsys fs,
 	return 0;
 }
 
-static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
+static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
 			    const char *name, int num, blk64_t *new_block)
 {
 	ext2_filsys fs = ctx->fs;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 193ec1c..2dd414b 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -764,6 +764,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	errcode_t	retval;
 	struct expand_dir_struct es;
 	struct ext2_inode	inode;
+	blk64_t		sz;
 
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
@@ -799,7 +800,9 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	if (retval)
 		return retval;
 
-	inode.i_size = (es.last_block + 1) * fs->blocksize;
+	sz = (es.last_block + 1) * fs->blocksize;
+	inode.i_size = sz;
+	inode.i_size_high = sz >> 32;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	quota_data_add(ctx->qctx, &inode, dir, es.newblocks * fs->blocksize);
 
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index c1c74c8..6ef3568 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -684,7 +684,7 @@ struct write_dir_struct {
 	struct out_dir *outdir;
 	errcode_t	err;
 	e2fsck_t	ctx;
-	int		cleared;
+	blk64_t		cleared;
 	ext2_ino_t	dir;
 };
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5b705ed..0546653 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1168,7 +1168,7 @@ int main (int argc, char *argv[])
 	const char	*lib_ver_date;
 	int		my_ver, lib_ver;
 	e2fsck_t	ctx;
-	blk_t		orig_superblock;
+	blk64_t		orig_superblock;
 	struct problem_context pctx;
 	int flags, run_result;
 	int journal_size;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 18005f4..44d7ef6 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -503,14 +503,14 @@ void mtrace_print(char *mesg)
 }
 #endif
 
-blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
-		   io_manager manager)
+blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
+		      io_manager manager)
 {
 	struct ext2_super_block *sb;
 	io_channel		io = NULL;
 	void			*buf = NULL;
 	int			blocksize;
-	blk_t			superblock, ret_sb = 8193;
+	blk64_t			superblock, ret_sb = 8193;
 
 	if (fs && fs->super) {
 		ret_sb = (fs->super->s_blocks_per_group +
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 157cbbe..db05637 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -244,7 +244,7 @@ void ext2fs_update_dynamic_rev(ext2_filsys fs)
 }
 
 static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
-				    blk_t group_block,
+				    blk64_t group_block,
 				    struct ext2_super_block *super_shadow)
 {
 	errcode_t retval;
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 3de9278..80d2d0a 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -66,7 +66,7 @@ struct dir_context {
  */
 struct ext2_inode_cache {
 	void *				buffer;
-	blk_t				buffer_blk;
+	blk64_t				buffer_blk;
 	int				cache_last;
 	int				cache_size;
 	int				refcount;
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index d875630..3100ee9 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -158,7 +158,7 @@ errcode_t ext2fs_file_flush(ext2_file_t file)
  */
 static errcode_t sync_buffer_position(ext2_file_t file)
 {
-	blk_t	b;
+	blk64_t	b;
 	errcode_t	retval;
 
 	b = file->pos / file->fs->blocksize;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index d154d7e..46c1c58 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -295,9 +295,9 @@ errcode_t ext2fs_inode_scan_goto_blockgroup(ext2_inode_scan scan,
  * increasing order.
  */
 static errcode_t check_for_inode_bad_blocks(ext2_inode_scan scan,
-					    blk_t *num_blocks)
+					    blk64_t *num_blocks)
 {
-	blk_t	blk = scan->current_block;
+	blk64_t	blk = scan->current_block;
 	badblocks_list	bb = scan->fs->badblocks;
 
 	/*
@@ -354,7 +354,7 @@ static errcode_t check_for_inode_bad_blocks(ext2_inode_scan scan,
  */
 static errcode_t get_next_blocks(ext2_inode_scan scan)
 {
-	blk_t		num_blocks;
+	blk64_t		num_blocks;
 	errcode_t	retval;
 
 	/*
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 0929400..4471f46 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -281,7 +281,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 		dbg_printf("Free start %llu, free count = %u\n",
 		       free_start, free_count);
 		while (free_count-- > 0) {
-			ext2fs_block_alloc_stats(fs, free_start++, -1);
+			ext2fs_block_alloc_stats2(fs, free_start++, -1);
 			freed++;
 		}
 	next_extent:
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index 6f783c3..a95296c 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -26,7 +26,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-blk_t test_vec[] = { 8, 12, 24, 34, 43, 44, 100, 0 };
+blk64_t test_vec[] = { 8, 12, 24, 34, 43, 44, 100, 0 };
 
 ext2_filsys	test_fs;
 ext2fs_block_bitmap bad_block_map, touched_map;
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 5369ffb..ae70f70 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -144,7 +144,7 @@ static void print_bg_rel_offset(ext2_filsys fs, blk64_t block, int itable,
 		printf(" (+%u)", (unsigned)(block - first_block));
 	} else if (fs->super->s_feature_incompat &
 		   EXT4_FEATURE_INCOMPAT_FLEX_BG) {
-		dgrp_t flex_grp = ext2fs_group_of_blk(fs, block);
+		dgrp_t flex_grp = ext2fs_group_of_blk2(fs, block);
 		printf(" (bg #%u + %u)", flex_grp,
 		       (unsigned)(block-ext2fs_group_first_block(fs,flex_grp)));
 	}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 52247e0..60d1378 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -972,7 +972,7 @@ static int update_feature_set(ext2_filsys fs, char *features)
 
 		/* We need to force out the group descriptors as well */
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-		ext2fs_block_alloc_stats(fs, sb->s_mmp_block, -1);
+		ext2fs_block_alloc_stats2(fs, sb->s_mmp_block, -1);
 mmp_error:
 		sb->s_mmp_block = 0;
 		sb->s_mmp_update_interval = 0;
@@ -1836,10 +1836,10 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 	return 0;
 }
 
-static int ext2fs_is_meta_block(ext2_filsys fs, blk_t blk)
+static int ext2fs_is_meta_block(ext2_filsys fs, blk64_t blk)
 {
 	dgrp_t group;
-	group = ext2fs_group_of_blk(fs, blk);
+	group = ext2fs_group_of_blk2(fs, blk);
 	if (ext2fs_block_bitmap_loc(fs, group) == blk)
 		return 1;
 	if (ext2fs_inode_bitmap_loc(fs, group) == blk)
@@ -1847,9 +1847,9 @@ static int ext2fs_is_meta_block(ext2_filsys fs, blk_t blk)
 	return 0;
 }
 
-static int ext2fs_is_block_in_group(ext2_filsys fs, dgrp_t group, blk_t blk)
+static int ext2fs_is_block_in_group(ext2_filsys fs, dgrp_t group, blk64_t blk)
 {
-	blk_t start_blk, end_blk;
+	blk64_t start_blk, end_blk;
 	start_blk = fs->super->s_first_data_block +
 			EXT2_BLOCKS_PER_GROUP(fs->super) * group;
 	/*
@@ -1889,7 +1889,7 @@ static int move_block(ext2_filsys fs, ext2fs_block_bitmap bmap)
 			 * the respective fs metadata pointers. Otherwise
 			 * fail
 			 */
-			group = ext2fs_group_of_blk(fs, blk);
+			group = ext2fs_group_of_blk2(fs, blk);
 			goal = ext2fs_group_first_block2(fs, group);
 			meta_data = 1;
 
@@ -2050,7 +2050,7 @@ err_out:
 static int group_desc_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 {
 	dgrp_t i;
-	blk_t blk, new_blk;
+	blk64_t blk, new_blk;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		blk = ext2fs_block_bitmap_loc(fs, i);

