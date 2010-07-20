From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 03/12] e2fsprogs: Create/check exclude inode for Next3
Date: Tue, 20 Jul 2010 18:16:04 +0300
Message-ID: <1279638973-14561-4-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab0GTPRZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:25 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:24 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The exclude inode owns all the exclude bitmap blocks.
It is pre-allocated by 'mke2fs/tune2fs -O exclude_inode'.
It is extended by resize2fs when block groups are added.
Fsck checks that all exclude inode blocks are allocated.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/e2fsck.h      |    2 +
 e2fsck/pass1.c       |   21 +++++-
 e2fsck/problem.c     |   15 ++++
 e2fsck/problem.h     |    9 ++
 e2fsck/super.c       |   84 ++++++++++++++++++++
 e2fsck/unix.c        |    1 +
 lib/ext2fs/ext2fs.h  |    8 ++
 lib/ext2fs/res_gdt.c |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/dumpe2fs.c      |    7 ++
 misc/mke2fs.c        |   16 ++++
 misc/tune2fs.c       |  135 +++++++++++++++++++++++++++-----
 resize/resize2fs.c   |   24 ++++++
 12 files changed, 512 insertions(+), 20 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d4df5f3..0f23751 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -177,6 +177,7 @@ struct resource_track {
 #define E2F_FLAG_GOT_DEVSIZE	0x0800 /* Device size has been fetched */
 #define E2F_FLAG_EXITING	0x1000 /* E2fsck exiting due to errors */
 #define E2F_FLAG_TIME_INSANE	0x2000 /* Time is insane */
+#define E2F_FLAG_EXCLUDE_INODE	0x4000 /* Request to recreate exclude inode */
 
 #define E2F_RESET_FLAGS (E2F_FLAG_TIME_INSANE)
 
@@ -475,6 +476,7 @@ void e2fsck_rehash_directories(e2fsck_t ctx);
 void check_super_block(e2fsck_t ctx);
 int check_backup_super_block(e2fsck_t ctx);
 void check_resize_inode(e2fsck_t ctx);
+void check_exclude_inode(e2fsck_t ctx);
 
 /* util.c */
 extern void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 93763cd..5793467 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -890,7 +890,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if (ino == EXT2_BOOT_LOADER_INO) {
 				if (LINUX_S_ISDIR(inode->i_mode))
 					problem = PR_1_RESERVED_BAD_MODE;
-			} else if (ino == EXT2_RESIZE_INO) {
+			} else if (ino == EXT2_RESIZE_INO || ino == EXT2_EXCLUDE_INO) {
 				if (inode->i_mode &&
 				    !LINUX_S_ISREG(inode->i_mode))
 					problem = PR_1_RESERVED_BAD_MODE;
@@ -1143,6 +1143,25 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ctx->flags &= ~E2F_FLAG_RESIZE_INODE;
 	}
 
+	if (ctx->flags & E2F_FLAG_EXCLUDE_INODE) {
+		ext2fs_block_bitmap save_bmap;
+
+		save_bmap = fs->block_map;
+		fs->block_map = ctx->block_found_map;
+		clear_problem_context(&pctx);
+		pctx.errcode = ext2fs_create_exclude_inode(fs, EXCLUDE_CREATE);
+		if (pctx.errcode &&
+			fix_problem(ctx, PR_1_EXCLUDE_INODE_CREATE, &pctx)) {
+			memset(&inode, 0, sizeof(inode));
+			e2fsck_write_inode(ctx, EXT2_EXCLUDE_INO, inode,
+					   "clear_exclude");
+			fs->super->s_feature_compat &= ~EXT2_FEATURE_COMPAT_EXCLUDE_INODE;
+			ctx->flags |= E2F_FLAG_RESTART;
+		}
+		fs->block_map = save_bmap;
+		ctx->flags &= ~E2F_FLAG_EXCLUDE_INODE;
+	}
+
 	if (ctx->flags & E2F_FLAG_RESTART) {
 		/*
 		 * Only the master copy of the superblock and block
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 8032fda..199fe5e 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -332,6 +332,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Resize @i not valid.  "),
 	  PROMPT_RECREATE, 0 },
 
+	/* Exclude not enabled, but exclude inode is non-zero */
+	{ PR_0_CLEAR_EXCLUDE_INODE,
+	  N_("Exclude_@i not enabled, but the exclude @i is non-zero.  "),
+	  PROMPT_CLEAR, 0 },
+
+	/* Exclude inode invalid */
+	{ PR_0_EXCLUDE_INODE_INVALID,
+	  N_("Exclude @i not valid.  "),
+	  PROMPT_RECREATE, 0 },
+
 	/* Last mount time is in the future */
 	{ PR_0_FUTURE_SB_LAST_MOUNT,
 	  N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
@@ -800,6 +810,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Resize @i (re)creation failed: %m."),
 	  PROMPT_CONTINUE, 0 },
 
+	/* Exclude inode failed */
+	{ PR_1_EXCLUDE_INODE_CREATE,
+	  N_("Exclude @i (re)creation failed: %m."),
+	  PROMPT_CLEAR, 0 },
+
 	/* invalid inode->i_extra_isize */
 	{ PR_1_EXTRA_ISIZE,
 	  N_("@i %i has a extra size (%IS) which is @n\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 7c4c156..dba3a23 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -227,6 +227,12 @@ struct problem_context {
 /* Block group checksum (latch question) */
 #define PR_0_GDT_CSUM_LATCH			0x00003E
 
+/* Exclude_inode not enabled, but exclude inode is non-zero */
+#define PR_0_CLEAR_EXCLUDE_INODE		0x000100
+
+/* Exclude inode invalid */
+#define PR_0_EXCLUDE_INODE_INVALID		0x000101
+
 
 /*
  * Pass 1 errors
@@ -520,6 +526,9 @@ struct problem_context {
 /* EOFBLOCKS flag set when not necessary */
 #define PR_1_EOFBLOCKS_FL_SET		0x010060
 
+/* Exclude inode failed */
+#define PR_1_EXCLUDE_INODE_CREATE	0x010100
+
 /*
  * Pass 1b errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index b6923c6..c155949 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -426,6 +426,90 @@ cleanup:
  }
 
 /*
+ * Check the exclude inode to make sure it is sane.  We check both for
+ * the case where exclude bitmap is not enabled (in which case the
+ * exclude inode should be cleared) as well as the case where exclude
+ * bitmap is enabled.
+ */
+void check_exclude_inode(e2fsck_t ctx)
+{
+	ext2_filsys fs = ctx->fs;
+	struct ext2_inode inode;
+	struct problem_context	pctx;
+	int		i, flags = 0;
+	blk_t		blk;
+	errcode_t	retval;
+
+	clear_problem_context(&pctx);
+
+	/* Read the exclude inode */
+	pctx.ino = EXT2_EXCLUDE_INO;
+	retval = ext2fs_read_inode(fs, EXT2_EXCLUDE_INO, &inode);
+	if (retval) {
+		if (fs->super->s_feature_compat &
+		    EXT2_FEATURE_COMPAT_EXCLUDE_INODE)
+			ctx->flags |= E2F_FLAG_EXCLUDE_INODE;
+		return;
+	}
+
+	/*
+	 * If the exclude inode feature isn't set, check to make sure
+	 * the exclude inode is cleared; then we're done.
+	 */
+	if (!(fs->super->s_feature_compat &
+	      EXT2_FEATURE_COMPAT_EXCLUDE_INODE)) {
+		for (i=0; i < EXT2_N_BLOCKS; i++) {
+			if (inode.i_block[i])
+				break;
+		}
+		if ((i < EXT2_N_BLOCKS) &&
+		    fix_problem(ctx, PR_0_CLEAR_EXCLUDE_INODE, &pctx)) {
+			memset(&inode, 0, sizeof(inode));
+			e2fsck_write_inode(ctx, EXT2_EXCLUDE_INO, &inode,
+					   "clear_exclude");
+		}
+		return;
+	}
+
+	/*
+	 * The exclude inode feature is enabled; check to make sure the
+	 * only block in use is the double indirect block
+	 */
+	blk = inode.i_block[EXT2_DIND_BLOCK];
+	for (i=0; i < EXT2_N_BLOCKS; i++) {
+		if (i != EXT2_DIND_BLOCK && inode.i_block[i])
+			break;
+	}
+	if ((i < EXT2_N_BLOCKS) || !blk || !inode.i_links_count ||
+	    !(inode.i_mode & LINUX_S_IFREG) ||
+	    (blk < fs->super->s_first_data_block ||
+	     blk >= fs->super->s_blocks_count)) {
+		if (fix_problem(ctx, PR_0_EXCLUDE_INODE_INVALID, &pctx)) {
+			memset(&inode, 0, sizeof(inode));
+			e2fsck_write_inode(ctx, EXT2_EXCLUDE_INO, &inode,
+					   "clear_exclude");
+			ctx->flags |= E2F_FLAG_EXCLUDE_INODE;
+		}
+		return;
+	}
+
+	if (!(ctx->options & E2F_OPT_READONLY))
+		flags = EXCLUDE_ALLOC;
+	/*
+	 * create exclude inode and/or allocate missing exclude bitmap blocks.
+	 */
+	clear_problem_context(&pctx);
+	pctx.errcode = ext2fs_create_exclude_inode(fs, flags);
+	if (pctx.errcode &&
+			fix_problem(ctx, PR_1_EXCLUDE_INODE_CREATE, &pctx)) {
+		memset(&inode, 0, sizeof(inode));
+		e2fsck_write_inode(ctx, EXT2_EXCLUDE_INO, &inode,
+				"clear_exclude");
+		ctx->flags |= E2F_FLAG_EXCLUDE_INODE;
+	}
+}
+
+/*
  * This function checks the dirhash signed/unsigned hint if necessary.
  */
 static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6cb2214..71e563d 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1319,6 +1319,7 @@ print_unsupp_features:
 		fatal_error(ctx, 0);
 	check_if_skip(ctx);
 	check_resize_inode(ctx);
+	check_exclude_inode(ctx);
 	if (bad_blocks_file)
 		read_bad_blocks_file(ctx, bad_blocks_file, replace_bad_blocks);
 	else if (cflag)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0c2587f..c8a8dbc 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -209,6 +209,7 @@ struct struct_ext2_filsys {
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
 	struct opaque_ext2_group_desc *	group_desc;
+	__u32 *				exclude_blks;
 	int				inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
@@ -1293,6 +1294,13 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
 
 /* res_gdt.c */
 extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
+extern errcode_t ext2fs_create_exclude_inode(ext2_filsys fs, int flags);
+
+/* exclude inode creation flags */
+#define EXCLUDE_READONLY 0 /* only read exclude bitmap blocks */
+#define EXCLUDE_ALLOC	 1 /* allocate missing exclude bitmap blocks */
+#define EXCLUDE_RESET	 2 /* reset exclude bitmap blocks to zero */
+#define EXCLUDE_CREATE	 3 /* alloc and/or reset exclude bitmap blocks */
 
 /* swapfs.c */
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize,
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index bf10995..bfc51fa 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -218,3 +218,213 @@ out_free:
 	return retval;
 }
 
+/*
+ * ext2fs_create_exclude_inode():
+ * the exclude inode owns all the exclude bitmap blocks (one per block group)
+ * the exclude bitmap blocks are double indirectly linked to the exclude inode
+ * the exclude bitmap allocation goal is the first block of the block group
+ * exclude inode creation @flags:
+ * EXCLUDE_ALLOC (1) - allocate missing exclude bitmap blocks
+ * EXCLUDE_RESET (2) - reset exclude bitmap to zero
+ */
+errcode_t ext2fs_create_exclude_inode(ext2_filsys fs, int flags)
+{
+	errcode_t		retval, retval2;
+	struct ext2_super_block	*sb;
+	struct ext2_inode	inode;
+	__u32			*dindir_buf, *indir_buf, *data_buf;
+	unsigned long long	apb, inode_size;
+	blk_t		dindir_blk, indir_blk, data_blk;
+	int			gdt_dirty = 0, dindir_dirty = 0, inode_dirty = 0;
+	int			indir_dirty = 0, data_dirty = 0;
+	int 		dindir_off, indir_off, grp, i, max_groups;
+	int create = flags & EXCLUDE_ALLOC;
+	int reset = flags & EXCLUDE_RESET;
+
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	sb = fs->super;
+
+	retval = ext2fs_get_array(3, fs->blocksize, &dindir_buf);
+	if (retval)
+		goto out_free;
+	indir_buf = (__u32 *)((char *)dindir_buf + 1*fs->blocksize);
+	data_buf = (__u32 *)((char *)dindir_buf + 2*fs->blocksize);
+
+	retval = ext2fs_read_inode(fs, EXT2_EXCLUDE_INO, &inode);
+	if (retval)
+		goto out_free;
+
+	if (fs->exclude_blks)
+		ext2fs_free_mem(&fs->exclude_blks);
+	retval = ext2fs_get_array(fs->group_desc_count, fs->blocksize,
+			&fs->exclude_blks);
+	if (retval)
+		goto out_free;
+	memset(fs->exclude_blks, 0, fs->group_desc_count*fs->blocksize);
+
+#ifdef EXCLUDE_INO_PROGRESS
+	printf("Reserving exclude bitmap blocks:            ");
+#endif
+
+	apb = EXT2_ADDR_PER_BLOCK(sb);
+	if ((dindir_blk = inode.i_block[EXT2_DIND_BLOCK])) {
+#ifdef EXCLUDE_INO_DEBUG
+		printf("reading exclude inode dindir %u\n", dindir_blk);
+#endif
+		retval = ext2fs_read_ind_block(fs, dindir_blk, dindir_buf);
+		if (retval)
+			goto out_free;
+	} else if (create) {
+		blk_t goal = sb->s_first_data_block + fs->desc_blocks +
+			sb->s_reserved_gdt_blocks + 2 +
+			fs->inode_blocks_per_group;
+
+		retval = ext2fs_alloc_block(fs, goal, (char *)dindir_buf, &dindir_blk);
+		if (retval)
+			goto out_free;
+		inode.i_mode = LINUX_S_IFREG | 0600;
+		inode.i_links_count = 1;
+		inode.i_block[EXT2_DIND_BLOCK] = dindir_blk;
+		ext2fs_iblk_set(fs, &inode, 1);
+#ifdef EXCLUDE_INO_DEBUG
+		printf("allocated exclude inode dindir %u\n", dindir_blk);
+#endif
+		dindir_dirty = inode_dirty = 1;
+		inode.i_ctime = fs->now ? fs->now : time(0);
+	}
+
+	/*
+	 * init exclude_blks array for all existing block groups
+	 * and allocate indirect blocks for all reserved block groups
+	 */
+	max_groups = fs->desc_blocks + sb->s_reserved_gdt_blocks;
+	max_groups *= EXT2_DESC_PER_BLOCK(sb);
+	for (grp = 0; grp < max_groups; grp++) {
+		struct ext2_group_desc *gd =
+			ext2fs_group_desc(fs, fs->group_desc, grp);
+
+		dindir_off = grp/apb;
+		indir_off = grp%apb;
+		if (indir_off == 0) {
+			/* flush current indirect block */
+			if (indir_dirty) {
+				retval = ext2fs_write_ind_block(fs, indir_blk, indir_buf);
+				if (retval)
+					goto out_dindir;
+				indir_dirty = 0;
+			}
+			/* read/alloc next indirect block */
+			if ((indir_blk = dindir_buf[dindir_off])) {
+#ifdef EXCLUDE_INO_DEBUG
+				printf("reading exclude inode indir %u\n", indir_blk);
+#endif
+				retval = ext2fs_read_ind_block(fs, indir_blk, indir_buf);
+				if (retval)
+					goto out_dindir;
+			} else if (create) {
+				retval = ext2fs_alloc_block(fs, dindir_blk, (char *)indir_buf, &indir_blk);
+				if (retval)
+					goto out_dindir;
+				dindir_buf[dindir_off] = indir_blk;
+				ext2fs_iblk_add_blocks(fs, &inode, 1);
+#ifdef EXCLUDE_INO_DEBUG
+				printf("allocated exclude inode indir %u\n", indir_blk);
+#endif
+				dindir_dirty = inode_dirty = 1;
+			}
+		}
+
+		if (grp >= fs->group_desc_count)
+			continue;
+		/* read/alloc exclude bitmap block */
+		data_blk = indir_buf[indir_off];
+		if (!data_blk && create) {
+			/* allocate exclude bitmap block */
+			retval = ext2fs_alloc_block(fs, gd->bg_block_bitmap,
+					(char *)data_buf, &data_blk);
+			if (retval)
+				goto out_dindir;
+			indir_buf[indir_off] = data_blk;
+			ext2fs_iblk_add_blocks(fs, &inode, 1);
+#ifdef EXCLUDE_INO_DEBUG
+			printf("allocated exclude bitmap block %u\n", data_blk);
+#endif
+			indir_dirty = inode_dirty = 1;
+		} else if (data_blk && reset) {
+			/* reset exclude bitmap block */
+#ifdef EXCLUDE_INO_DEBUG
+			printf("reading exclude bitmap block %u\n", data_blk);
+#endif
+			retval = io_channel_read_blk(fs->io, data_blk, 1,
+					data_buf);
+			if (retval)
+				goto out_dindir;
+			/* zero data block */
+			for (i = 0; i < apb; i++) {
+				if (!data_buf[i])
+					continue;
+				data_buf[i] = 0;
+				data_dirty = 1;
+			}
+			if (data_dirty) {
+				retval = io_channel_write_blk(fs->io, data_blk,
+						1, data_buf);
+				if (retval)
+					goto out_dindir;
+				data_dirty = 0;
+			}
+		}
+		fs->exclude_blks[grp] = data_blk;
+#ifdef EXCLUDE_INO_PROGRESS
+		printf("\b\b\b\b\b\b\b\b\b\b\b%5d/%5d", grp,
+				fs->group_desc_count);
+#endif
+	}
+#ifdef EXCLUDE_INO_PROGRESS
+	printf("\b\b\b\b\b\b\b\b\b\b\bdone       \n");
+#endif
+
+	/* exclude bitmap was reset to zero - clear fix_exclude flag */
+	if (sb->s_flags & EXT2_FLAGS_FIX_EXCLUDE) {
+		sb->s_flags &= ~EXT2_FLAGS_FIX_EXCLUDE;
+		ext2fs_mark_super_dirty(fs);
+	}
+
+out_dindir:
+	if (indir_dirty) {
+		retval2 = ext2fs_write_ind_block(fs, indir_blk, indir_buf);
+		if (!retval)
+			retval = retval2;
+	}
+	if (dindir_dirty) {
+		retval2 = ext2fs_write_ind_block(fs, dindir_blk, dindir_buf);
+		if (!retval)
+			retval = retval2;
+	}
+out_inode:
+	if (inode_dirty) {
+		inode_size = fs->group_desc_count + apb + EXT2_NDIR_BLOCKS;
+		inode_size *= fs->blocksize;
+		inode.i_size = inode_size & 0xFFFFFFFF;
+		inode.i_atime = inode.i_mtime = fs->now ? fs->now : time(0);
+		retval2 = ext2fs_write_new_inode(fs, EXT2_EXCLUDE_INO, &inode);
+		if (!retval)
+			retval = retval2;
+		/* need to write out block bitmaps and group descriptors */
+		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	}
+	if (gdt_dirty) {
+		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+		ext2fs_mark_super_dirty(fs);
+	}
+#ifdef EXCLUDE_INO_DEBUG
+	printf("inode.i_blocks = %u, i_size = %u\n",
+			inode.i_blocks, inode.i_size);
+#endif
+out_free:
+	ext2fs_free_mem(&dindir_buf);
+	return retval;
+}
+
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 6ec0858..76d5065 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -207,6 +207,13 @@ static void list_desc (ext2_filsys fs)
 		diff = ext2fs_inode_bitmap_loc(fs, i) - first_block;
 		if (diff >= 0)
 			printf(" (+%ld)", diff);
+		if (fs->exclude_blks && fs->exclude_blks[i]) {
+			fputs(_(", Exclude bitmap at "), stdout);
+			print_number(fs->exclude_blks[i]);
+			diff = fs->exclude_blks[i] - first_block;
+			if (diff >= 0 && diff <= fs->super->s_blocks_per_group)
+				printf(" (+%ld)", diff);
+		}
 		fputs(_("\n  Inode table at "), stdout);
 		print_range(ext2fs_inode_table_loc(fs, i),
 			    ext2fs_inode_table_loc(fs, i) +
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 88f4230..6894945 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -329,6 +329,10 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 			/* The kernel doesn't need to zero the itable blocks */
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
 			ext2fs_group_desc_csum_set(fs, i);
+			if (fs->super->s_feature_compat &
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE)
+				/* zero the designated exclude bitmap block */
+				num++;
 		}
 		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
 		if (retval) {
@@ -784,6 +788,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		EXT2_FEATURE_COMPAT_EXCLUDE_INODE |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
 		EXT2_FEATURE_COMPAT_EXT_ATTR,
@@ -1175,6 +1180,8 @@ static void PRS(int argc, char *argv[])
 			journal_size = -NEXT3_MAX_COW_CREDITS;
 			/* 2. use system page size as block size */
 			blocksize = sys_page_size;
+			/* 3. create exclude inode */
+			edit_feature("exclude_inode", &fs_param.s_feature_compat);
 		}
 	}
 
@@ -2173,6 +2180,15 @@ int main (int argc, char *argv[])
 				exit(1);
 			}
 		}
+		if (fs->super->s_feature_compat &
+		    EXT2_FEATURE_COMPAT_EXCLUDE_INODE) {
+			retval = ext2fs_create_exclude_inode(fs, EXCLUDE_CREATE);
+			if (retval) {
+				com_err("ext2fs_create_exclude_inode", retval,
+				_("while reserving blocks for exclude bitmap"));
+				exit(1);
+			}
+		}
 	}
 
 	if (journal_device) {
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4734331..596b384 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -119,6 +119,7 @@ static void usage(void)
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		EXT2_FEATURE_COMPAT_EXCLUDE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
@@ -136,6 +137,7 @@ static __u32 ok_features[3] = {
 static __u32 clear_ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		EXT2_FEATURE_COMPAT_EXCLUDE_INODE |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
@@ -270,6 +272,74 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 }
 
 /*
+ * Remove a special inode from the filesystem:
+ * - resize inode, @nlink = 0
+ * - exclude inode, @nlink = 0
+ * - snapshot inodes, @nlink = 1 (snapshots directory)
+ */
+static void remove_special_inode(ext2_filsys fs, ext2_ino_t ino,
+		struct ext2_inode *inode, int nlink)
+{
+	int retval = ext2fs_read_bitmaps(fs);
+	if (retval) {
+		com_err(program_name, retval,
+				_("while reading bitmaps"));
+		exit(1);
+	}
+	retval = ext2fs_block_iterate3(fs, ino,
+			BLOCK_FLAG_READ_ONLY, NULL,
+			release_blocks_proc, NULL);
+	if (retval) {
+		com_err(program_name, retval,
+				_("while clearing inode"));
+		exit(1);
+	}
+	if (nlink) {
+		/* reset truncated inode */
+		inode->i_size = 0;
+		inode->i_size_high = 0;
+		inode->i_blocks = 0;
+		memset(inode->i_block, 0, sizeof(inode->i_block));
+	} else {
+		/* clear unlinked inode */
+		memset(inode, 0, sizeof(*inode));
+	}
+	ext2fs_mark_bb_dirty(fs);
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+}
+
+/*
+ * Remove the exclude inode from the filesystem
+ */
+static void remove_exclude_inode(ext2_filsys fs)
+{
+	struct ext2_inode	inode;
+	ino_t			ino = EXT2_EXCLUDE_INO;
+	errcode_t		retval;
+
+	/* clear fix_exclude flag */
+	fs->super->s_flags &= ~EXT2_FLAGS_FIX_EXCLUDE;
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_super_dirty(fs);
+
+	retval = ext2fs_read_inode(fs, ino,  &inode);
+	if (retval) {
+		com_err(program_name, retval,
+			_("while reading exclude inode"));
+		exit(1);
+	}
+
+	remove_special_inode(fs, ino, &inode, 0);
+
+	retval = ext2fs_write_inode(fs, ino, &inode);
+	if (retval) {
+		com_err(program_name, retval,
+			_("while writing exclude inode"));
+		exit(1);
+	}
+}
+
+/*
  * Remove the journal inode from the filesystem
  */
 static void remove_journal_inode(ext2_filsys fs)
@@ -284,25 +354,9 @@ static void remove_journal_inode(ext2_filsys fs)
 			_("while reading journal inode"));
 		exit(1);
 	}
-	if (ino == EXT2_JOURNAL_INO) {
-		retval = ext2fs_read_bitmaps(fs);
-		if (retval) {
-			com_err(program_name, retval,
-				_("while reading bitmaps"));
-			exit(1);
-		}
-		retval = ext2fs_block_iterate3(fs, ino,
-					       BLOCK_FLAG_READ_ONLY, NULL,
-					       release_blocks_proc, NULL);
-		if (retval) {
-			com_err(program_name, retval,
-				_("while clearing journal inode"));
-			exit(1);
-		}
-		memset(&inode, 0, sizeof(inode));
-		ext2fs_mark_bb_dirty(fs);
-		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-	} else
+	if (ino == EXT2_JOURNAL_INO)
+		remove_special_inode(fs, ino, &inode, 0);
+	else
 		inode.i_flags &= ~EXT2_IMMUTABLE_FL;
 	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval) {
@@ -341,6 +395,32 @@ static void request_fsck_afterwards(ext2_filsys fs)
 		printf(_("(and reboot afterwards!)\n"));
 }
 
+static int verify_clean_fs(ext2_filsys fs, int compat, unsigned int mask,
+		int on)
+{
+	struct ext2_super_block *sb= fs->super;
+
+	if ((mount_flags & EXT2_MF_MOUNTED) &&
+		!(mount_flags & EXT2_MF_READONLY)) {
+		fprintf(stderr, _("The '%s' feature may only be "
+					"%s when the filesystem is\n"
+					"unmounted or mounted read-only.\n"),
+				e2p_feature2string(compat, mask),
+				on ? "set" : "cleared");
+		exit(1);
+	}
+	if (sb->s_feature_incompat &
+		EXT3_FEATURE_INCOMPAT_RECOVER) {
+		fprintf(stderr, _("The needs_recovery flag is set.  "
+					"Please run e2fsck before %s\n"
+					"the '%s' flag.\n"),
+				on ? "setting" : "clearing",
+				e2p_feature2string(compat, mask));
+		exit(1);
+	}
+	return 1;
+}
+
 /*
  * Update the feature set as provided by the user.
  */
@@ -359,6 +439,10 @@ static void update_feature_set(ext2_filsys fs, char *features)
 				 !((&sb->s_feature_compat)[(type)] & (mask)))
 #define FEATURE_CHANGED(type, mask) ((mask) & \
 		     (old_features[(type)] ^ (&sb->s_feature_compat)[(type)]))
+#define FEATURE_ON_SAFE(compat, mask) \
+	(FEATURE_ON(compat, mask) && verify_clean_fs(fs, compat, mask, 1))
+#define FEATURE_OFF_SAFE(compat, mask) \
+	(FEATURE_OFF(compat, mask) && verify_clean_fs(fs, compat, mask, 0))
 
 	old_features[E2P_FEATURE_COMPAT] = sb->s_feature_compat;
 	old_features[E2P_FEATURE_INCOMPAT] = sb->s_feature_incompat;
@@ -419,6 +503,19 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	}
 
+	if (FEATURE_OFF_SAFE(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_INODE)) {
+		remove_exclude_inode(fs);
+	}
+
+	if (FEATURE_ON_SAFE(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_INODE)) {
+		retval = ext2fs_create_exclude_inode(fs, EXCLUDE_CREATE);
+		if (retval) {
+			com_err(program_name, retval,
+					_("while creating exclude inode"));
+			exit(1);
+		}
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_DIR_INDEX)) {
 		if (!sb->s_def_hash_version)
 			sb->s_def_hash_version = EXT2_HASH_HALF_MD4;
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 064c4c4..b0e9f34 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -48,6 +48,7 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs);
 static errcode_t inode_ref_fix(ext2_resize_t rfs);
 static errcode_t move_itables(ext2_resize_t rfs);
 static errcode_t fix_resize_inode(ext2_filsys fs);
+static errcode_t fix_exclude_inode(ext2_filsys fs);
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs);
 static errcode_t fix_sb_journal_backup(ext2_filsys fs);
 
@@ -149,6 +150,10 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
+	retval = fix_exclude_inode(rfs->new_fs);
+	if (retval)
+		goto errout;
+
 	retval = fix_sb_journal_backup(rfs->new_fs);
 	if (retval)
 		goto errout;
@@ -1774,6 +1779,25 @@ errout:
 }
 
 /*
+ * Fix the exclude inode
+ */
+static errcode_t fix_exclude_inode(ext2_filsys fs)
+{
+	if (!(fs->super->s_feature_compat &
+	      EXT2_FEATURE_COMPAT_EXCLUDE_INODE))
+		return 0;
+	/*
+	 * create_exclude_inode():
+	 * - updates exclude_blks for existing block groups
+	 * - allocates exclude bitmap blocks for new block groups
+	 * - doesn't free exclude bitmap blocks of deleted block group,
+	 *   so when resizing from large to small filesystem,
+	 *   it would be wise to remove the exclude inode beforehand.
+	 */
+	return ext2fs_create_exclude_inode(fs, EXCLUDE_CREATE);
+}
+
+/*
  * Finally, recalculate the summary information
  */
 static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
-- 
1.6.6

