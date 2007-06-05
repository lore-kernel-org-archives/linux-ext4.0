From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Tue, 5 Jun 2007 15:20:05 -0600
Message-ID: <20070605212005.GM5181@schatzie.adilger.int>
References: <1181065733.5219.8.camel@mathur-dsktp> <4665AFEF.3060602@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="KR/qxknboQ7+Tpez"
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54810 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbXFEVUL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 17:20:11 -0400
Content-Disposition: inline
In-Reply-To: <4665AFEF.3060602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--KR/qxknboQ7+Tpez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Jun 05, 2007  13:48 -0500, Eric Sandeen wrote:
> Avantika Mathur wrote:
> >I have ported your uninitialized block group kernel patch to mainline
> >2.6.22-rc3, included below.
> >I will also be posting the ported e2fsprogs patches. I had trouble
> >testing the patches because of inconsistency in the block_group
> >structure in e2fsprogs - which is only using ext2_block_group, and not
> >ext4_block_group.
> 
> >+#if !defined(CONFIG_CRC16) && !defined(CONFIG_CRC16_MODULE)
> >+/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
> >+__u16 const crc16_table[256] = {
> >+	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
> >+	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
> 
> 
> Apologies if this has already been discussed & I missed it, but why 
> replicate all this?  why not just require CONFIG_CRC16?

For CFS we need this in our patches because crc16() is not available in
older kernels.  For 2.6.2x it is available, so there is not really any
need to included it unless you are building ext4 against an existing
kernel which does not have crc16() configured (it is not on by default).
I don't think it is harmful, but I don't care whether it is kept or not.



FYI, the other thing I noticed about the e2fsprogs part of this feature is
that PPC seems to break crc16(__u16 crc) and treat crc as a signed int.
This causes e.g. crc16(~0, buf, len) to calculate "crc >> 8" to be 0xffffff
and the resulting checksum is wrong.

I ended up working around the problem by passing unsigned int instead
of __u16 as a parameter, and masking the intermediate results in a
WORDS_BIGENDIAN environment, though I'm not sure if it is big-endian
that is at fault or only the PPC code.  Attached is an updated e2fsprogs
patch for this, which includes crc16() regression tests that pass on PPC,
in addition to the ext2fs_group_desc_csum() tests which previously failed.

Thanks to Oregon State University (and IBM) for having public-access PPC
machines to test this on (http://powerdev.osuosl.org/).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


--KR/qxknboQ7+Tpez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-uninit.patch"

Index: e2fsprogs-1.39/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/debugfs.c
+++ e2fsprogs-1.39/debugfs/debugfs.c
@@ -286,7 +286,10 @@ void do_show_super_stats(int argc, char 
 	FILE 	*out;
 	struct ext2_group_desc *gdp;
 	int	c, header_only = 0;
-	int	numdirs = 0, first;
+	int	numdirs = 0, first, gdt_csum;
+
+	gdt_csum = EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
+					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
 	reset_getopt();
 	while ((c = getopt (argc, argv, "h")) != EOF) {
@@ -322,7 +325,7 @@ void do_show_super_stats(int argc, char 
 		        "inode table at %u\n"
 		        "           %d free %s, "
 		        "%d free %s, "
-		        "%d used %s\n",
+		        "%d used %s%s",
 		        i, gdp->bg_block_bitmap,
 		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
 		        gdp->bg_free_blocks_count,
@@ -331,12 +334,21 @@ void do_show_super_stats(int argc, char 
 		        gdp->bg_free_inodes_count != 1 ? "inodes" : "inode",
 		        gdp->bg_used_dirs_count,
 		        gdp->bg_used_dirs_count != 1 ? "directories"
-				: "directory");
+				: "directory", gdt_csum ? ", " : "\n");
+		if (gdt_csum)
+			fprintf(out, "%d unused %s\n",
+				gdp->bg_itable_unused,
+				gdp->bg_itable_unused != 1 ? "inodes":"inode");
 		first = 1;
 		print_bg_opts(gdp, EXT2_BG_INODE_UNINIT, "Inode not init",
 			      &first, out);
 		print_bg_opts(gdp, EXT2_BG_BLOCK_UNINIT, "Block not init",
 			      &first, out);
+		if (gdt_csum) {
+			fprintf(out, "%sChecksum 0x%04x",
+				first ? "           [":", ", gdp->bg_checksum);
+			first = 0;
+		}
 		if (!first)
 			fputs("]\n", out);
 	}
Index: e2fsprogs-1.39/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/set_fields.c
+++ e2fsprogs-1.39/debugfs/set_fields.c
@@ -35,6 +35,7 @@
 static struct ext2_super_block set_sb;
 static struct ext2_inode set_inode;
 static struct ext2_group_desc set_gd;
+static dgrp_t set_bg;
 static ext2_ino_t set_ino;
 static int array_idx;
 
@@ -56,6 +57,7 @@ static errcode_t parse_uuid(struct field
 static errcode_t parse_hashalg(struct field_set_info *info, char *arg);
 static errcode_t parse_time(struct field_set_info *info, char *arg);
 static errcode_t parse_bmap(struct field_set_info *info, char *arg);
+static errcode_t parse_gd_csum(struct field_set_info *info, char *arg);
 
 static struct field_set_info super_fields[] = {
 	{ "inodes_count", &set_sb.s_inodes_count, 4, parse_uint },
@@ -161,7 +163,7 @@ static struct field_set_info ext2_bg_fie
 	{ "flags", &set_gd.bg_flags, 2, parse_uint },
 	{ "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARRAY, 2 },
 	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
-	{ "checksum", &set_gd.bg_checksum, 2, parse_uint },
+	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
 	{ 0, 0, 0, 0 }
 };
 
@@ -374,6 +376,17 @@ static errcode_t parse_bmap(struct field
 	return retval;
 }
 
+static errcode_t parse_gd_csum(struct field_set_info *info, char *arg)
+{
+	__u16 *val = info->ptr;
+
+	if (strcmp(arg, "calc") == 0) {
+		*val = ext2fs_group_desc_csum(&set_sb, set_bg, &set_gd);
+		return 0;
+	}
+
+	return parse_uint(info, arg);
+}
 
 static void print_possible_fields(struct field_set_info *fields)
 {
@@ -493,7 +506,6 @@ void do_set_block_group_descriptor(int a
 		"\t\"set_block_group_descriptor -l\" will list the names of "
 		"the fields in a block group descriptor\n\twhich can be set.";
 	struct field_set_info	*ss;
-	dgrp_t			set_bg;
 	char			*end;
 
 	if ((argc == 2) && !strcmp(argv[1], "-l")) {
@@ -523,6 +535,7 @@ void do_set_block_group_descriptor(int a
 	}
 
 	set_gd = current_fs->group_desc[set_bg];
+	set_sb = *current_fs->super;
 
 	if (ss->func(ss, argv[3]) == 0) {
 		current_fs->group_desc[set_bg] = set_gd;
Index: e2fsprogs-1.39/e2fsck/journal.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/journal.c
+++ e2fsprogs-1.39/e2fsck/journal.c
@@ -975,6 +975,8 @@ void e2fsck_move_ext3_journal(e2fsck_t c
 	ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
 	ext2fs_mark_ib_dirty(fs);
 	fs->group_desc[group].bg_free_inodes_count++;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
 	fs->super->s_free_inodes_count++;
 	return;
 
Index: e2fsprogs-1.39/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass5.c
+++ e2fsprogs-1.39/e2fsck/pass5.c
@@ -121,7 +121,7 @@ static void check_block_bitmaps(e2fsck_t
 	struct problem_context	pctx;
 	int	problem, save_problem, fixit, had_problem;
 	errcode_t	retval;
-	int		lazy_bg = 0;
+	int		lazy_flag, csum_flag;
 	int		skip_group = 0;
 
 	clear_problem_context(&pctx);
@@ -158,15 +158,16 @@ static void check_block_bitmaps(e2fsck_t
 		goto errout;
 	}
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, EXT2_FEATURE_COMPAT_LAZY_BG))
-		lazy_bg++;
-
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT2_FEATURE_COMPAT_LAZY_BG);
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.blk = pctx.blk2 = NO_BLK;
-	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_BLOCK_UNINIT))
+	if ((lazy_flag || csum_flag) &&
+	    (fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT))
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
@@ -206,6 +207,17 @@ redo_counts:
 			 * Block used, but not marked in use in the bitmap.
 			 */
 			problem = PR_5_BLOCK_USED;
+
+			if (skip_group) {
+				struct problem_context pctx2;
+				pctx2.blk = i;
+				pctx2.group = group;
+				if (fix_problem(ctx, PR_5_BLOCK_UNINIT,&pctx2)){
+					fs->group_desc[group].bg_flags &=
+						~EXT2_BG_BLOCK_UNINIT;
+					skip_group = 0;
+				}
+			}
 		}
 		if (pctx.blk == NO_BLK) {
 			pctx.blk = pctx.blk2 = i;
@@ -224,7 +236,7 @@ redo_counts:
 		had_problem++;
 
 	do_counts:
-		if (!bitmap && !skip_group) {
+		if (!bitmap && (!skip_group || csum_flag)) {
 			group_free++;
 			free_blocks++;
 		}
@@ -241,7 +253,7 @@ redo_counts:
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
 					goto errout;
-			if (lazy_bg &&
+			if ((lazy_flag || csum_flag) &&
 			    (i != fs->super->s_blocks_count-1) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_BLOCK_UNINIT))
@@ -321,7 +333,7 @@ static void check_inode_bitmaps(e2fsck_t
 	errcode_t	retval;
 	struct problem_context	pctx;
 	int		problem, save_problem, fixit, had_problem;
-	int		lazy_bg = 0;
+	int		lazy_flag, csum_flag;
 	int		skip_group = 0;
 
 	clear_problem_context(&pctx);
@@ -358,16 +370,16 @@ static void check_inode_bitmaps(e2fsck_t
 		goto errout;
 	}
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
-				    EXT2_FEATURE_COMPAT_LAZY_BG))
-		lazy_bg++;
-
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT2_FEATURE_COMPAT_LAZY_BG);
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
 	pctx.ino = pctx.ino2 = 0;
-	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_INODE_UNINIT))
+	if ((lazy_flag || csum_flag) &&
+	    (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT))
 		skip_group++;
 
 	/* Protect loop from wrap-around if inodes_count is maxed */
@@ -390,6 +402,21 @@ redo_counts:
 			 * Inode used, but not in bitmap
 			 */
 			problem = PR_5_INODE_USED;
+
+			/* We should never hit this, because it means that
+			 * inodes were marked in use that weren't noticed
+			 * in pass1 or pass 2. It is easier to fix the problem
+			 * than to kill e2fsck and leave the user stuck. */
+			if (skip_group) {
+				struct problem_context pctx2;
+				pctx2.blk = i;
+				pctx2.group = group;
+				if (fix_problem(ctx, PR_5_INODE_UNINIT,&pctx2)){
+					fs->group_desc[group].bg_flags &=
+						~EXT2_BG_INODE_UNINIT;
+					skip_group = 0;
+				}
+			}
 		}
 		if (pctx.ino == 0) {
 			pctx.ino = pctx.ino2 = i;
@@ -411,7 +438,7 @@ do_counts:
 		if (bitmap) {
 			if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, i))
 				dirs_count++;
-		} else if (!skip_group) {
+		} else if (!skip_group || csum_flag) {
 			group_free++;
 			free_inodes++;
 		}
@@ -430,7 +457,7 @@ do_counts:
 					    group + fs->group_desc_count,
 					    fs->group_desc_count*2))
 					goto errout;
-			if (lazy_bg &&
+			if ((lazy_flag || csum_flag) &&
 			    (i != fs->super->s_inodes_count) &&
 			    (fs->group_desc[group].bg_flags &
 			     EXT2_BG_INODE_UNINIT))
Index: e2fsprogs-1.39/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/problem.c
+++ e2fsprogs-1.39/e2fsck/problem.c
@@ -351,8 +351,33 @@ static struct e2fsck_problem problem_tab
 	  N_("Adding dirhash hint to @f.\n\n"),
 	  PROMPT_NONE, 0 },
 
+	/* Group descriptor N checksum is invalid. */
+	{ PR_0_GDT_CSUM,
+	  N_("@g descriptor %g checksum is invalid.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* Group descriptor N marked uninitialized without feature set. */
+	{ PR_0_GDT_UNINIT,
+	  N_("@g descriptor %g marked uninitialized without feature set.\n"),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* Group N block bitmap uninitialized but inode bitmap in use. */
+	{ PR_0_BB_UNINIT_IB_INIT,
+	  N_("@g %g @b @B uninitialized but @i @B in use.\n"),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* Group descriptor N has invalid unused inodes count. */
+	{ PR_0_GDT_ITABLE_UNUSED,
+	  N_("@g descriptor %g has invalid unused inodes count %b.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
+	/* Last group block bitmap uninitialized. */
+	{ PR_0_BB_UNINIT_LAST,
+	  N_("last @g @b @B uninitialized.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1 errors */
-	
+
 	/* Pass 1: Checking inodes, blocks, and sizes */
 	{ PR_1_PASS_HEADER,
 	  N_("Pass 1: Checking @is, @bs, and sizes\n"),
@@ -1236,6 +1261,16 @@ static struct e2fsck_problem problem_tab
 	  N_("i_blocks_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Inode found in group where _INODE_UNINIT is set */
+	{ PR_2_INOREF_BG_INO_UNINIT,
+	  N_("@i %i found in @g %g where _INODE_UNINIT is set.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* Inode found in group unused inodes area */
+	{ PR_2_INOREF_IN_UNUSED,
+	  N_("@i %i found in @g %g unused inodes area.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
@@ -1536,12 +1571,22 @@ static struct e2fsck_problem problem_tab
 	{ PR_5_INODE_RANGE_UNUSED,
 	  " -(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
-		  
+
 	/* Inode range used, but not marked used in bitmap */
 	{ PR_5_INODE_RANGE_USED,
 	  " +(%i--%j)",
 	  PROMPT_NONE, PR_LATCH_IBITMAP | PR_PREEN_OK | PR_PREEN_NOMSG },
 
+	/* Group N block(s) in use but group is marked BLOCK_UNINIT */
+	{ PR_5_BLOCK_UNINIT,
+	  N_("@g %g @b(s) in use but @g is marked BLOCK_UNINIT\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* Group N inode(s) in use but group is marked INODE_UNINIT */
+	{ PR_5_INODE_UNINIT,
+	  N_("@g %g @i(s) in use but @g is marked INODE_UNINIT\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
+
         /* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
         { PR_6_RECREATE_JOURNAL,
           N_("Recreate journal to make the filesystem ext3 again?\n"),
Index: e2fsprogs-1.39/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/problem.h
+++ e2fsprogs-1.39/e2fsck/problem.h
@@ -197,6 +197,21 @@ struct problem_context {
 /* Superblock hint for external journal incorrect */
 #define PR_0_DIRHASH_HINT			0x000034
 
+/* Group descriptor N checksum is invalid */
+#define PR_0_GDT_CSUM				0x000035
+
+/* Group descriptor N marked uninitialized without feature set. */
+#define PR_0_GDT_UNINIT				0x000036
+
+/* Block bitmap is uninitialised but Inode bitmap in use. */
+#define PR_0_BB_UNINIT_IB_INIT			0x000037
+
+/* Group descriptor N has invalid unused inodes count. */
+#define PR_0_GDT_ITABLE_UNUSED			0x000038
+
+/* Last group block bitmap is uninitialized. */
+#define PR_0_BB_UNINIT_LAST			0x000039
+
 /*
  * Pass 1 errors
  */
@@ -742,6 +757,12 @@ struct problem_context {
 /* i_blocks_hi should be zero */
 #define PR_2_BLOCKS_HI_ZERO	0x020044
 
+/* Inode found in group where _INODE_UNINIT is set */
+#define PR_2_INOREF_BG_INO_UNINIT	0x020045
+
+/* Inode found in group unused inodes area */
+#define PR_2_INOREF_IN_UNUSED		0x020046
+
 /*
  * Pass 3 errors
  */
@@ -930,10 +951,16 @@ struct problem_context {
 
 /* Inode range not used, but marked in bitmap */
 #define PR_5_INODE_RANGE_UNUSED		0x050016
-	  
+
 /* Inode rangeused, but not marked used in bitmap */
 #define PR_5_INODE_RANGE_USED		0x050017
 
+/* Block in use but group is marked BLOCK_UNINIT */
+#define PR_5_BLOCK_UNINIT		0x050018
+
+/* Inode in use but group is marked INODE_UNINIT */
+#define PR_5_INODE_UNINIT		0x050019
+
 /*
  * Post-Pass 5 errors
  */
Index: e2fsprogs-1.39/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/super.c
+++ e2fsprogs-1.39/e2fsck/super.c
@@ -480,6 +480,7 @@ void check_super_block(e2fsck_t ctx)
 	blk_t	should_be;
 	struct problem_context	pctx;
 	__u32	free_blocks = 0, free_inodes = 0;
+	int     lazy_flag, csum_flag;
 
 	inodes_per_block = EXT2_INODES_PER_BLOCK(fs->super);
 	ipg_max = inodes_per_block * (blocks_per_group - 4);
@@ -596,6 +597,10 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	first_block =  sb->s_first_data_block;
 
+	lazy_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+					    EXT2_FEATURE_COMPAT_LAZY_BG);
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
 		pctx.group = i;
 
@@ -641,6 +646,50 @@ void check_super_block(e2fsck_t ctx)
 		    (gd->bg_used_dirs_count > sb->s_inodes_per_group))
 			ext2fs_unmark_valid(fs);
 
+		if (!ext2fs_group_desc_csum_verify(sb, i, gd)) {
+			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
+				gd->bg_flags &=	~(EXT2_BG_BLOCK_UNINIT |
+				                  EXT2_BG_INODE_UNINIT);
+				gd->bg_itable_unused = 0;
+			}
+			ext2fs_unmark_valid(fs);
+		}
+
+		if (!lazy_flag && !csum_flag &&
+		    (gd->bg_flags &(EXT2_BG_BLOCK_UNINIT|EXT2_BG_INODE_UNINIT)||
+		     gd->bg_itable_unused != 0)){
+			if (fix_problem(ctx, PR_0_GDT_UNINIT, &pctx)) {
+				gd->bg_flags &= ~(EXT2_BG_BLOCK_UNINIT |
+						  EXT2_BG_INODE_UNINIT);
+				gd->bg_itable_unused = 0;
+			}
+			ext2fs_unmark_valid(fs);
+		}
+
+		if (i == fs->group_desc_count - 1 &&
+		    gd->bg_flags & EXT2_BG_BLOCK_UNINIT) {
+			if (fix_problem(ctx, PR_0_BB_UNINIT_LAST, &pctx))
+				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+			ext2fs_unmark_valid(fs);
+		}
+
+		if (gd->bg_flags & EXT2_BG_BLOCK_UNINIT &&
+		    !(gd->bg_flags & EXT2_BG_INODE_UNINIT)) {
+			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx))
+				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+			ext2fs_unmark_valid(fs);
+		}
+
+		if (csum_flag &&
+		    (gd->bg_itable_unused > gd->bg_free_inodes_count ||
+		     gd->bg_itable_unused > sb->s_inodes_per_group)) {
+			pctx.blk = gd->bg_itable_unused;
+			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx))
+				gd->bg_itable_unused = 0;
+			ext2fs_unmark_valid(fs);
+		}
+
+		gd->bg_checksum = ext2fs_group_desc_csum(fs->super, i, gd);
 	}
 
 	/*
Index: e2fsprogs-1.39/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-1.39/lib/ext2fs/Makefile.in
@@ -67,7 +67,9 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_O
 	unix_io.o \
 	unlink.o \
 	valid_blk.o \
-	version.o
+	version.o \
+	crc16.o \
+	csum.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -137,7 +139,10 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_byteswap.c \
 	$(srcdir)/tst_getsize.c \
 	$(srcdir)/tst_types.c \
-	$(srcdir)/tst_iscan.c
+	$(srcdir)/tst_iscan.c \
+	$(srcdir)/tst_csum.c \
+	$(srcdir)/crc16.c \
+	$(srcdir)/csum.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
 	tdb.h
@@ -227,6 +232,11 @@ tst_bitops: tst_bitops.o inline.o $(STAT
 	@$(CC) -o tst_bitops tst_bitops.o inline.o $(ALL_CFLAGS) \
 		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
 
+tst_csum: tst_csum.o csum.o crc16.o $(STATIC_LIBEXT2FS) $(STATIC_LIBUUID)
+	@echo "	LD $@"
+	@$(CC) -o tst_csum csum.o tst_csum.o crc16.o $(STATIC_LIBEXT2FS) \
+		$(STATIC_LIBUUID) $(LIBCOM_ERR)
+
 tst_getsectsize: tst_getsectsize.o getsectsize.o $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o tst_sectgetsize tst_getsectsize.o getsectsize.o \
@@ -244,13 +254,14 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2F
 	@echo "	LD $@"
 	@$(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
 
-check:: tst_bitops tst_badblocks tst_iscan @SWAPFS_CMT@ tst_byteswap \
-	tst_types tst_icount
+check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_csum \
+	@SWAPFS_CMT@ tst_byteswap
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
 @SWAPFS_CMT@	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_byteswap
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_types
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_icount
 
 installdirs::
@@ -359,6 +370,10 @@ cmp_bitmaps.o: $(srcdir)/cmp_bitmaps.c $
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+crc16.o: $(srcdir)/crc16.c $(srcdir)/ext2_fs.h $(srcdir)/crc16.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
+csum.o: $(srcdir)/csum.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
 dblist.o: $(srcdir)/dblist.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h \
@@ -571,3 +586,5 @@ tst_iscan.o: $(srcdir)/tst_iscan.c $(src
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+tst_csum.o: $(srcdir)/tst_csum.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h
Index: e2fsprogs-1.39/lib/ext2fs/alloc_stats.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/alloc_stats.c
+++ e2fsprogs-1.39/lib/ext2fs/alloc_stats.c
@@ -27,6 +27,27 @@ void ext2fs_inode_alloc_stats2(ext2_fils
 	fs->group_desc[group].bg_free_inodes_count -= inuse;
 	if (isdir)
 		fs->group_desc[group].bg_used_dirs_count += inuse;
+
+	/* We don't strictly need to be clearing these if inuse < 0
+	 * (i.e. freeing inodes) but it also means something is bad. */
+	fs->group_desc[group].bg_flags &= ~(EXT2_BG_INODE_UNINIT |
+					    EXT2_BG_BLOCK_UNINIT);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		ext2_ino_t first_unused_inode =	fs->super->s_inodes_per_group -
+			fs->group_desc[group].bg_itable_unused +
+			group * fs->super->s_inodes_per_group + 1;
+
+		if (ino >= first_unused_inode)
+			fs->group_desc[group].bg_itable_unused =
+				group * fs->super->s_inodes_per_group +
+				fs->super->s_inodes_per_group - ino;
+
+		fs->group_desc[group].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, group,
+					       &fs->group_desc[group]);
+	}
+
 	fs->super->s_free_inodes_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -46,6 +67,10 @@ void ext2fs_block_alloc_stats(ext2_filsy
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
+	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
+
 	fs->super->s_free_blocks_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
Index: e2fsprogs-1.39/lib/ext2fs/alloc_tables.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/alloc_tables.c
+++ e2fsprogs-1.39/lib/ext2fs/alloc_tables.c
@@ -95,13 +95,12 @@ errcode_t ext2fs_allocate_group_table(ex
 			ext2fs_mark_block_bitmap(bmap, blk);
 		fs->group_desc[group].bg_inode_table = new_blk;
 	}
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
 
-	
 	return 0;
 }
 
-	
-
 errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 {
 	errcode_t	retval;
Index: e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.39/lib/ext2fs/ext2_fs.h
@@ -173,6 +173,7 @@ struct ext4_group_desc
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
+#define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
 
 /*
  * Data structures used by the directory indexing feature
Index: e2fsprogs-1.39/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.39/lib/ext2fs/ext2fs.h
@@ -343,6 +343,7 @@ typedef struct ext2_struct_inode_scan *e
 #define EXT2_SF_BAD_EXTRA_BYTES	0x0004
 #define EXT2_SF_SKIP_MISSING_ITABLE	0x0008
 #define EXT2_SF_DO_LAZY		0x0010
+#define EXT2_SF_DO_CSUM		0x0020
 
 /*
  * ext2fs_check_if_mounted flags
@@ -465,7 +466,8 @@ typedef struct ext2_icount *ext2_icount_
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
-					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
@@ -473,7 +475,6 @@ typedef struct ext2_icount *ext2_icount_
  */
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT3_FEATURE_INCOMPAT_EXTENTS)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
 
 /*
@@ -637,6 +638,13 @@ extern errcode_t ext2fs_compare_block_bi
 extern errcode_t ext2fs_compare_inode_bitmap(ext2fs_inode_bitmap bm1,
 					     ext2fs_inode_bitmap bm2);
 
+/* csum.c */
+extern __u16 ext2fs_group_desc_csum(struct ext2_super_block *sb, __u32 group,
+				    struct ext2_group_desc *desc);
+extern int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb,
+				     __u32 group, struct ext2_group_desc *desc);
+extern void ext2fs_set_gdt_csum(ext2_filsys fs);
+
 /* dblist.c */
 
 extern errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs);
Index: e2fsprogs-1.39/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/inode.c
+++ e2fsprogs-1.39/lib/ext2fs/inode.c
@@ -167,6 +167,9 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
 	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
 				    EXT2_FEATURE_COMPAT_LAZY_BG))
 		scan->scan_flags |= EXT2_SF_DO_LAZY;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		scan->scan_flags |= EXT2_SF_DO_LAZY | EXT2_SF_DO_CSUM;
 	*ret_scan = scan;
 	return 0;
 }
@@ -218,18 +221,30 @@ int ext2fs_inode_scan_flags(ext2_inode_s
  */
 static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 {
+	ext2_filsys fs = scan->fs;
+
 	scan->current_group++;
 	scan->groups_left--;
-			
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+
+	scan->current_block =fs->group_desc[scan->current_group].bg_inode_table;
 
 	scan->current_inode = scan->current_group *
-		EXT2_INODES_PER_GROUP(scan->fs->super);
+		EXT2_INODES_PER_GROUP(fs->super);
 
 	scan->bytes_left = 0;
-	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
-	scan->blocks_left = scan->fs->inode_blocks_per_group;
+	scan->inodes_left = EXT2_INODES_PER_GROUP(fs->super);
+	scan->blocks_left = fs->inode_blocks_per_group;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		scan->inodes_left -=
+			fs->group_desc[scan->current_group].bg_itable_unused;
+		scan->blocks_left =
+			(EXT2_INODES_PER_GROUP(fs->super) -
+			 fs->group_desc[scan->current_group].bg_itable_unused +
+			 fs->blocksize / scan->inode_size - 1) *
+			scan->inode_size / fs->blocksize;
+	}
+
 	return 0;
 }
 
@@ -417,6 +432,8 @@ errcode_t ext2fs_get_next_inode_full(ext
 	    (scan->fs->group_desc[scan->current_group].bg_flags &
 	     EXT2_BG_INODE_UNINIT))
 		goto force_new_group;
+	if (scan->inodes_left == 0)
+		goto force_new_group;
 	if (scan->current_block == 0) {
 		if (scan->scan_flags & EXT2_SF_SKIP_MISSING_ITABLE) {
 			goto force_new_group;
Index: e2fsprogs-1.39/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/rw_bitmaps.c
+++ e2fsprogs-1.39/lib/ext2fs/rw_bitmaps.c
@@ -176,8 +176,10 @@ static errcode_t read_bitmaps(ext2_filsy
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
-				    EXT2_FEATURE_COMPAT_LAZY_BG))
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_LAZY_BG) ||
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		lazy_flag = 1;
 
 	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
@@ -229,7 +231,9 @@ static errcode_t read_bitmaps(ext2_filsy
 		if (block_bitmap) {
 			blk = fs->group_desc[i].bg_block_bitmap;
 			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_BLOCK_UNINIT)
+			    EXT2_BG_BLOCK_UNINIT &&
+			    ext2fs_group_desc_csum_verify(fs->super, i,
+							  &fs->group_desc[i]))
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
@@ -250,7 +254,9 @@ static errcode_t read_bitmaps(ext2_filsy
 		if (inode_bitmap) {
 			blk = fs->group_desc[i].bg_inode_bitmap;
 			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_INODE_UNINIT)
+			    EXT2_BG_INODE_UNINIT &&
+			    ext2fs_group_desc_csum_verify(fs->super, i,
+							  &fs->group_desc[i]))
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
Index: e2fsprogs-1.39/misc/dumpe2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/dumpe2fs.c
+++ e2fsprogs-1.39/misc/dumpe2fs.c
@@ -112,7 +112,8 @@ static void print_bg_opts(ext2_filsys fs
 {
 	int first = 1, bg_flags;
 
-	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG)
+	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG ||
+	    fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 		bg_flags = fs->group_desc[i].bg_flags;
 	else
 		bg_flags = 0;
@@ -204,11 +205,15 @@ static void list_desc (ext2_filsys fs)
 		diff = fs->group_desc[i].bg_inode_table - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
-		printf (_("\n  %d free blocks, %d free inodes, "
-			  "%d directories\n"),
+		printf (_("\n  %u free blocks, %u free inodes, "
+			  "%u directories%s"),
 			fs->group_desc[i].bg_free_blocks_count,
 			fs->group_desc[i].bg_free_inodes_count,
-			fs->group_desc[i].bg_used_dirs_count);
+			fs->group_desc[i].bg_used_dirs_count,
+			fs->group_desc[i].bg_itable_unused ? "" : "\n");
+		if (fs->group_desc[i].bg_itable_unused)
+			printf (_(", %u unused inodes\n"),
+				fs->group_desc[i].bg_itable_unused);
 		if (block_bitmap) {
 			fputs(_("  Free blocks: "), stdout);
 			print_free (i, block_bitmap,
Index: e2fsprogs-1.39/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/mke2fs.c
+++ e2fsprogs-1.39/misc/mke2fs.c
@@ -432,6 +432,8 @@ static void write_inode_tables(ext2_fils
 					num, blk, error_message(retval));
 				exit(1);
 			}
+			/* The kernel doesn't need to zero the itable blocks */
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
 		}
 		if (sync_kludge) {
 			if (sync_kludge == 1)
@@ -447,34 +449,49 @@ static void write_inode_tables(ext2_fils
 static void setup_lazy_bg(ext2_filsys fs)
 {
 	dgrp_t i;
-	int blks;
+	int blks, csum_flag;
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *bg = fs->group_desc;
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
-				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super, EXT2_FEATURE_COMPAT_LAZY_BG) ||
+	    csum_flag) {
 		for (i = 0; i < fs->group_desc_count; i++, bg++) {
 			if ((i == 0) ||
-			    (i == fs->group_desc_count-1))
+			    (i == fs->group_desc_count - 1 && !csum_flag))
 				continue;
 			if (bg->bg_free_inodes_count ==
 			    sb->s_inodes_per_group) {
-				bg->bg_free_inodes_count = 0;
 				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
-				sb->s_free_inodes_count -= 
-					sb->s_inodes_per_group;
+				if (!csum_flag) {
+					bg->bg_free_inodes_count = 0;
+					sb->s_free_inodes_count -=
+						sb->s_inodes_per_group;
+				}
 			}
+
+			/* Skip groups with GDT backups because the resize
+			 * inode has blocks allocated in them, and the last
+			 * group because it may need block bitmap padding. */
+			if ((ext2fs_bg_has_super(fs, i) &&
+			     sb->s_reserved_gdt_blocks) ||
+			    i == fs->group_desc_count - 1)
+				continue;
+
 			blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
-			if (bg->bg_free_blocks_count == blks) {
-				bg->bg_free_blocks_count = 0;
+			if (bg->bg_free_blocks_count == blks &&
+			    bg->bg_flags & EXT2_BG_INODE_UNINIT) {
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
-				sb->s_free_blocks_count -= blks;
+				if (!csum_flag) {
+					bg->bg_free_blocks_count = 0;
+					sb->s_free_blocks_count -= blks;
+				}
 			}
 		}
 	}
 }
 
-
 static void create_root_dir(ext2_filsys fs)
 {
 	errcode_t	retval;
@@ -869,7 +886,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG,
-	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
+	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|	/* R/O compat */
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 
@@ -1724,6 +1742,8 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
+	if (!super_only)
+		ext2fs_set_gdt_csum(fs);
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
Index: e2fsprogs-1.39/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/tune2fs.c
+++ e2fsprogs-1.39/misc/tune2fs.c
@@ -98,7 +98,8 @@ static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
-	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
+	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |	/* R/O compat */
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 /*
@@ -213,6 +214,8 @@ static int release_blocks_proc(ext2_fils
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
 	fs->group_desc[group].bg_free_blocks_count++;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
 	fs->super->s_free_blocks_count++;
 	return 0;
 }
@@ -282,7 +285,7 @@ static void update_mntopts(ext2_filsys f
 static void update_feature_set(ext2_filsys fs, char *features)
 {
 	int sparse, old_sparse, filetype, old_filetype;
-	int journal, old_journal, dxdir, old_dxdir;
+	int journal, old_journal, dxdir, old_dxdir, uninit, old_uninit;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
 
@@ -298,6 +301,8 @@ static void update_feature_set(ext2_fils
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	old_dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	old_uninit = sb->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	if (e2p_edit_feature(features, &sb->s_feature_compat,
 			     ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"),
@@ -312,6 +317,8 @@ static void update_feature_set(ext2_fils
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	uninit = sb->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	if (old_journal && !journal) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
 		    !(mount_flags & EXT2_MF_READONLY)) {
@@ -358,6 +365,7 @@ static void update_feature_set(ext2_fils
 	     sb->s_feature_incompat))
 		ext2fs_update_dynamic_rev(fs);
 	if ((sparse != old_sparse) ||
+	    (uninit != old_uninit) ||
 	    (filetype != old_filetype)) {
 		sb->s_state &= ~EXT2_VALID_FS;
 		printf("\n%s\n", _(please_fsck));
Index: e2fsprogs-1.39/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-1.39.orig/misc/tune2fs.8.in
+++ e2fsprogs-1.39/misc/tune2fs.8.in
@@ -384,10 +384,16 @@ option.
 .TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
+.TP
+.B uninit_groups
+Allow the kernel to initialize bitmaps and inode tables and keep a high
+watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.
 .RE
 .IP
 After setting or clearing 
-.B sparse_super
+.BR sparse_super , " uninit_groups" ,
 and 
 .B filetype 
 filesystem features,
@@ -406,7 +412,9 @@ can be run to convert existing directori
 Linux kernels before 2.0.39 and many 2.1 series kernels do not support
 the filesystems that use any of these features.
 Enabling certain filesystem features may prevent the filesystem from
-being mounted by kernels which do not support those features.
+being mounted by kernels which do not support those features.  The
+.B uninit_groups
+feature is not yet supported by any released kernel.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
Index: e2fsprogs-1.39/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39.orig/resize/resize2fs.c
+++ e2fsprogs-1.39/resize/resize2fs.c
@@ -338,7 +338,9 @@ retry:
 		numblocks = fs->super->s_blocks_per_group;
 	i = old_fs->group_desc_count - 1;
 	fs->group_desc[i].bg_free_blocks_count += (numblocks-old_numblocks);
-		
+	fs->group_desc[i].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, i, &fs->group_desc[i]);
+
 	/*
 	 * If the number of block groups is staying the same, we're
 	 * done and can exit now.  (If the number block groups is
@@ -414,6 +416,8 @@ retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
+		fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, i,&fs->group_desc[i]);
 
 		retval = ext2fs_allocate_group_table(fs, i, 0);
 		if (retval) goto errout;
@@ -1223,9 +1227,13 @@ static errcode_t inode_scan_and_fix(ext2
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode.i_mode))
+		if (LINUX_S_ISDIR(inode.i_mode)) {
 			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
-		
+			rfs->new_fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(rfs->new_fs->super,group,
+					       &rfs->new_fs->group_desc[group]);
+		}
+
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_INODEMAP)
 			printf("Inode moved %u->%u\n", ino, new_inode);
@@ -1478,6 +1486,9 @@ static errcode_t move_itables(ext2_resiz
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
 		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
+		rfs->old_fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(rfs->old_fs->super, i,
+					       &rfs->old_fs->group_desc[i]);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
@@ -1575,8 +1586,12 @@ static errcode_t ext2fs_calculate_summar
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == fs->super->s_blocks_count-1)) {
-			fs->group_desc[group++].bg_free_blocks_count =
+			fs->group_desc[group].bg_free_blocks_count =
 				group_free;
+			fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(fs->super, group,
+						       &fs->group_desc[group]);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
@@ -1600,8 +1615,12 @@ static errcode_t ext2fs_calculate_summar
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group++].bg_free_inodes_count =
+			fs->group_desc[group].bg_free_inodes_count =
 				group_free;
+			fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(fs->super, group,
+						       &fs->group_desc[group]);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
Index: e2fsprogs-1.39/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/initialize.c
+++ e2fsprogs-1.39/lib/ext2fs/initialize.c
@@ -372,6 +372,8 @@ ipg_retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
+		fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, i,&fs->group_desc[i]);
 	}
 	
 	c = (char) 255;
Index: e2fsprogs-1.39/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass2.c
+++ e2fsprogs-1.39/e2fsck/pass2.c
@@ -151,7 +151,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	
 	cd.pctx.errcode = ext2fs_dblist_iterate(fs->dblist, check_dir_block,
 						&cd);
-	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return;
 	if (cd.pctx.errcode) {
 		fix_problem(ctx, PR_2_DBLIST_ITERATE, &cd.pctx);
@@ -742,7 +742,7 @@ static int check_dir_block(ext2_filsys f
 	buf = cd->buf;
 	ctx = cd->ctx;
 
-	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return DIRENT_ABORT;
 	
 	if (ctx->progress && (ctx->progress)(ctx, 2, cd->count++, cd->max))
@@ -839,6 +839,9 @@ static int check_dir_block(ext2_filsys f
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
 	prev = 0;
 	do {
+		int group;
+		ext2_ino_t first_unused_inode;
+
 		problem = 0;
 		dirent = (struct ext2_dir_entry *) (buf + offset);
 		cd->pctx.dirent = dirent;
@@ -888,12 +891,6 @@ static int check_dir_block(ext2_filsys f
 		     (dirent->inode < EXT2_FIRST_INODE(fs->super))) ||
 		    (dirent->inode > fs->super->s_inodes_count)) {
 			problem = PR_2_BAD_INO;
-		} else if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map,
-					       dirent->inode))) {
-			/*
-			 * If the inode is unused, offer to clear it.
-			 */
-			problem = PR_2_UNUSED_INODE;
 		} else if (ctx->inode_bb_map &&
 			   (ext2fs_test_inode_bitmap(ctx->inode_bb_map,
 						     dirent->inode))) {
@@ -970,6 +967,67 @@ static int check_dir_block(ext2_filsys f
 				return DIRENT_ABORT;
 		}
 
+		group = ext2fs_group_of_ino(fs, dirent->inode);
+		first_unused_inode = group * fs->super->s_inodes_per_group +
+					1 + fs->super->s_inodes_per_group -
+					fs->group_desc[group].bg_itable_unused;
+		cd->pctx.group = group;
+
+		/*
+		 * Check if the inode was missed out because _INODE_UNINIT
+		 * flag was set or bg_itable_unused was incorrect.
+		 * If that is the case restart e2fsck.
+		 * XXX Optimisations TODO:
+		 * 1. only restart e2fsck once
+		 * 2. only exposed inodes are checked again.
+		 */
+		if (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT) {
+			if (fix_problem(ctx, PR_2_INOREF_BG_INO_UNINIT,
+					&cd->pctx)){
+				fs->group_desc[group].bg_flags &=
+					~EXT2_BG_INODE_UNINIT;
+				ctx->flags |= E2F_FLAG_RESTART |
+					E2F_FLAG_SIGNAL_MASK;
+			} else {
+				ext2fs_unmark_valid(fs);
+				if (problem == PR_2_BAD_INO)
+					goto next;
+			}
+		} else if (dirent->inode >= first_unused_inode) {
+			if (fix_problem(ctx, PR_2_INOREF_IN_UNUSED, &cd->pctx)){
+				fs->group_desc[group].bg_itable_unused = 0;
+				fs->group_desc[group].bg_flags &=
+					~EXT2_BG_INODE_UNINIT;
+				ext2fs_mark_super_dirty(fs);
+				ctx->flags |= E2F_FLAG_RESTART;
+				goto restart_fsck;
+			} else {
+				ext2fs_unmark_valid(fs);
+				if (problem == PR_2_BAD_INO)
+					goto next;
+			}
+		}
+
+		if (!(ext2fs_test_inode_bitmap(ctx->inode_used_map,
+					       dirent->inode))) {
+			/*
+			 * If the inode is unused, offer to clear it.
+			 */
+			problem = PR_2_UNUSED_INODE;
+		}
+
+		if (problem) {
+			if (fix_problem(ctx, problem, &cd->pctx)) {
+				dirent->inode = 0;
+				dir_modified++;
+				goto next;
+			} else {
+				ext2fs_unmark_valid(fs);
+				if (problem == PR_2_BAD_INO)
+					goto next;
+			}
+		}
+
 		if (check_name(ctx, dirent, ino, &cd->pctx))
 			dir_modified++;
 
@@ -1081,8 +1139,9 @@ static int check_dir_block(ext2_filsys f
 	dict_free_nodes(&de_dict);
 	return 0;
 abort_free_dict:
-	dict_free_nodes(&de_dict);
 	ctx->flags |= E2F_FLAG_ABORT;
+restart_fsck:
+	dict_free_nodes(&de_dict);
 	return DIRENT_ABORT;
 }
 
Index: e2fsprogs-1.39/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/openfs.c
+++ e2fsprogs-1.39/lib/ext2fs/openfs.c
@@ -299,6 +299,22 @@ errcode_t ext2fs_open2(const char *name,
 		dest += fs->blocksize;
 	}
 
+	/*
+	 * If recovery is from backup superblock, Clear _UNININT flags &
+	 * reset bg_itable_unused to zero
+	 */
+	if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		struct ext2_group_desc *gd;
+		for (i = 0, gd = fs->group_desc; i < fs->group_desc_count;
+		     i++, gd++) {
+			gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+			gd->bg_flags &= ~EXT2_BG_INODE_UNINIT;
+			gd->bg_itable_unused = 0;
+		}
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	*ret_fs = fs;
 	return 0;
 cleanup:
Index: e2fsprogs-1.39/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/unix.c
+++ e2fsprogs-1.39/e2fsck/unix.c
@@ -1324,6 +1324,10 @@ no_journal:
 		}
 	}
 
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
+	    !(ctx->options & E2F_OPT_READONLY))
+		ext2fs_set_gdt_csum(ctx->fs);
+
 	e2fsck_write_bitmaps(ctx);
 #ifdef RESOURCE_TRACK
 	io_channel_flush(ctx->fs->io);
Index: e2fsprogs-1.39/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.39/e2fsck/e2fsck.h
@@ -482,6 +482,8 @@ extern void e2fsck_read_bitmaps(e2fsck_t
 extern void e2fsck_write_bitmaps(e2fsck_t ctx);
 extern void preenhalt(e2fsck_t ctx);
 extern char *string_copy(e2fsck_t ctx, const char *str, int len);
+extern errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
+				    blk_t *ret_blk, int *ret_count);
 #ifdef RESOURCE_TRACK
 extern void print_resource_track(const char *desc,
 				 struct resource_track *track,
Index: e2fsprogs-1.39/lib/ext2fs/csum.c
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/lib/ext2fs/csum.c
@@ -0,0 +1,150 @@
+/*
+ * csum.c --- checksumming of ext3 structures
+ *
+ * Copyright (C) 2006 Cluster File Systems, Inc.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include "crc16.h"
+#include <assert.h>
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+__u16 ext2fs_group_desc_csum(struct ext2_super_block *sb, __u32 group,
+			     struct ext2_group_desc *desc)
+{
+	crc16_t crc = 0;
+
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		int offset = offsetof(struct ext2_group_desc, bg_checksum);
+
+#ifdef WORDS_BIGENDIAN
+		struct ext2_group_desc swabdesc = *desc;
+
+		/* Have to swab back to little-endian to do the checksum */
+		ext2fs_swap_group_desc(&swabdesc);
+		desc = &swabdesc;
+
+		group = ext2fs_swab32(group);
+#endif
+		crc = crc16(~0U, sb->s_uuid, sizeof(sb->s_uuid));
+		crc = crc16(crc, &group, sizeof(group));
+		crc = crc16(crc, desc, offset);
+		offset += sizeof(desc->bg_checksum); /* skip checksum */
+		if (sb->s_feature_ro_compat & EXT4_FEATURE_INCOMPAT_64BIT &&
+		    sb->s_desc_size && offset < sb->s_desc_size)
+			crc = crc16(crc, (char *)desc + offset,
+				    sb->s_desc_size - offset);
+	}
+
+	return crc;
+}
+
+int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb, __u32 group,
+				  struct ext2_group_desc *desc)
+{
+	if (desc->bg_checksum != ext2fs_group_desc_csum(sb, group, desc))
+		return 0;
+
+	return 1;
+}
+
+static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
+				   __u32 inodes_per_grp, dgrp_t grp_no)
+{
+	ext2_ino_t i, start_ino, end_ino;
+
+	start_ino = grp_no * inodes_per_grp + 1;
+	end_ino = start_ino + inodes_per_grp - 1;
+
+	for (i = end_ino; i >= start_ino; i--) {
+		if (ext2fs_fast_test_inode_bitmap(bitmap, i))
+			return i - start_ino + 1;
+	}
+	return inodes_per_grp;
+}
+
+/* update the bitmap flags, set the itable high watermark, and calculate
+ * checksums for the group descriptors */
+void ext2fs_set_gdt_csum(ext2_filsys fs)
+{
+	struct ext2_super_block *sb = fs->super;
+	struct ext2_group_desc *bg = fs->group_desc;
+	int blks, csum_flag, dirty = 0;
+	int inodes_per_group = sb->s_inodes_per_group;
+	dgrp_t i;
+
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				     EXT2_FEATURE_COMPAT_LAZY_BG) && !csum_flag)
+		return;
+
+	for (i = 0; i < fs->group_desc_count; i++, bg++) {
+		int old_csum = bg->bg_checksum;
+		int old_unused = bg->bg_itable_unused;
+		int old_flags = bg->bg_flags;
+
+		/* Even if it wasn't zeroed, by the time this function is
+		 * called by e2fsck we have already scanned and corrected
+		 * the whole inode table so we may as well not overwrite it.
+		 * This is just a hint to the kernel that it could do lazy
+		 * zeroing of the inode table if mke2fs didn't do it, to help
+		 * out if we need to do a full itable scan sometime later. */
+		if (!(bg->bg_flags & (EXT2_BG_INODE_UNINIT |
+				      EXT2_BG_INODE_ZEROED))) {
+			bg->bg_flags |= EXT2_BG_INODE_ZEROED;
+			dirty = 1;
+		}
+
+		if (bg->bg_free_inodes_count == inodes_per_group &&
+		    i > 0 && (i < fs->group_desc_count - 1 || csum_flag)) {
+			if (!(bg->bg_flags & EXT2_BG_INODE_UNINIT))
+				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
+
+			if (csum_flag)
+				bg->bg_itable_unused = inodes_per_group;
+
+		} else if (csum_flag) {
+			if (fs->inode_map)
+				bg->bg_itable_unused = inodes_per_group -
+					find_last_inode_ingrp(fs->inode_map,
+							      inodes_per_group,
+							      i);
+			else if (bg->bg_flags & EXT2_BG_INODE_UNINIT)
+				bg->bg_itable_unused = 0;
+
+			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
+		}
+
+		/* skip first and last groups, or groups with GDT backups
+		 * because the resize inode has blocks allocated in them. */
+		if (i == 0 || i == fs->group_desc_count - 1 ||
+		    (ext2fs_bg_has_super(fs, i) && sb->s_reserved_gdt_blocks))
+			goto checksum;
+
+		blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
+		if (bg->bg_free_blocks_count == blks &&
+		    bg->bg_flags & EXT2_BG_INODE_UNINIT &&
+		    !(bg->bg_flags & EXT2_BG_BLOCK_UNINIT))
+			bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
+checksum:
+		bg->bg_checksum = ext2fs_group_desc_csum(fs->super, i, bg);
+		if (old_flags != bg->bg_flags)
+			dirty = 1;
+		if (old_unused != bg->bg_itable_unused)
+			dirty = 1;
+		if (old_csum != bg->bg_checksum)
+			dirty = 1;
+	}
+	if (dirty)
+		ext2fs_mark_super_dirty(fs);
+}
Index: e2fsprogs-1.39/lib/ext2fs/crc16.c
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/lib/ext2fs/crc16.c
@@ -0,0 +1,61 @@
+/*
+ *      crc16.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/types.h>
+#include "crc16.h"
+
+/** CRC table for the CRC-16. The poly is 0x8005 (x^16 + x^15 + x^2 + 1) */
+static __u16 const crc16_table[256] = {
+	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
+	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
+	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
+	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
+	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
+	0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
+	0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
+	0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
+	0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
+	0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
+	0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
+	0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
+	0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
+	0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
+	0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
+	0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
+	0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
+	0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
+	0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
+	0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
+	0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
+	0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
+	0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
+	0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
+	0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
+	0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
+	0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
+	0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
+	0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
+	0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
+	0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
+	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
+};
+
+/**
+ * Compute the CRC-16 for the data buffer
+ *
+ * @param crc     previous CRC value
+ * @param buffer  data pointer
+ * @param len     number of bytes in the buffer
+ * @return        the updated CRC value
+ */
+crc16_t crc16(crc16_t crc, void const *buffer, size_t len)
+{
+	const unsigned char *ptr = buffer;
+	while (len--)
+		crc = crc16_byte(crc, *ptr++);
+	return crc;
+}
Index: e2fsprogs-1.39/lib/ext2fs/crc16.h
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/lib/ext2fs/crc16.h
@@ -0,0 +1,47 @@
+/*
+ *	crc16.h - CRC-16 routine
+ *
+ * Implements the standard CRC-16:
+ *   Width 16
+ *   Poly  0x8005 (x^16 + x^15 + x^2 + 1)
+ *   Init  0
+ *
+ * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#ifndef __CRC16_H
+#define __CRC16_H
+
+#include <linux/types.h>
+
+extern __u16 const crc16_table[256];
+
+
+#ifdef WORDS_BIGENDIAN
+/* for an unknown reason, PPC treats __u16 as signed and keeps doing sign
+ * extension on the value.  Instead, use only the low 16 bits of an
+ * unsigned int for holding the CRC value to avoid this.
+ */
+typedef unsigned crc16_t;
+
+static inline crc16_t crc16_byte(crc16_t crc, const unsigned char data)
+{
+	return (((crc >> 8) & 0xffU) ^ crc16_table[(crc ^ data) & 0xffU]) &
+		0x0000ffffU;
+}
+#else
+typedef __u16 crc16_t;
+
+static inline crc16_t crc16_byte(crc16_t crc, const unsigned char data)
+{
+	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
+}
+#endif
+
+extern crc16_t crc16(crc16_t crc, void const *buffer, size_t len);
+
+
+#endif /* __CRC16_H */
Index: e2fsprogs-1.39/lib/ext2fs/tst_csum.c
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/lib/ext2fs/tst_csum.c
@@ -0,0 +1,139 @@
+/*
+ * This testing program verifies checksumming operations
+ *
+ * Copyright (C) 2006, 2007 by Andreas Dilger <adilger@clusterfs.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "uuid/uuid.h"
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+void print_csum(const char *msg, struct ext2_super_block *sb,
+		__u32 group, struct ext2_group_desc *desc)
+{
+	__u16 crc1, crc2, crc3;
+	__u32 swabgroup;
+	char uuid[40];
+
+#ifdef WORDS_BIGENDIAN
+	struct ext2_group_desc swabdesc = *desc;
+
+	/* Have to swab back to little-endian to do the checksum */
+	ext2fs_swap_group_desc(&swabdesc);
+	desc = &swabdesc;
+
+	swabgroup = ext2fs_swab32(group);
+#else
+	swabgroup = group;
+#endif
+
+	crc1 = crc16(~0, sb->s_uuid, sizeof(sb->s_uuid));
+	crc2 = crc16(crc1, &swabgroup, sizeof(swabgroup));
+	crc3 = crc16(crc2, desc, offsetof(struct ext2_group_desc, bg_checksum));
+	uuid_unparse(sb->s_uuid, uuid);
+	printf("%s: UUID %s=%04x, grp %u=%04x: %04x=%04x\n",
+	       msg, uuid, crc1, group, crc2, crc3,
+	       ext2fs_group_desc_csum(sb, group,desc));
+}
+
+main(int argc, char **argv)
+{
+	struct ext2_group_desc desc = { .bg_block_bitmap = 124,
+					.bg_inode_bitmap = 125,
+					.bg_inode_table = 126,
+					.bg_free_blocks_count = 31119,
+					.bg_free_inodes_count = 15701,
+					.bg_used_dirs_count = 2,
+					.bg_flags = 0,
+					};
+	struct ext2_super_block sb = {  .s_feature_ro_compat =
+					EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
+					.s_uuid = { 0x4f, 0x25, 0xe8, 0xcf,
+						    0xe7, 0x97, 0x48, 0x23,
+						    0xbe, 0xfa, 0xa7, 0x88,
+						    0x4b, 0xae, 0xec, 0xdb } };
+	__u16 csum1, csum2, csum_known = 0xd3a4;
+	char data[8] = { 0x10, 0x20, 0x30, 0x40, 0xf1, 0xb2, 0xc3, 0xd4 };
+	__u16 data_crc[8] =   { 0xcc01, 0x180c, 0x1118, 0xfa10,
+				0x483a, 0x6648, 0x6726, 0x85e6 };
+	__u16 data_crc0[8] =  { 0x8cbe, 0xa80d, 0xd169, 0xde10,
+				0x481e, 0x7d48, 0x673d, 0x8ea6 };
+	int i;
+
+	for (i = 0; i < sizeof(data); i++) {
+		csum1 = crc16(0, data, i + 1);
+		printf("crc16(0): data[%d]: %04x=%04x\n", i, csum1,data_crc[i]);
+		if (csum1 != data_crc[i]) {
+			printf("error: crc16(0) for data[%d] should be %04x\n",
+			       i, data_crc[i]);
+			exit(1);
+		}
+	}
+
+	for (i = 0; i < sizeof(data); i++) {
+		csum1 = crc16(~0, data, i + 1);
+		printf("crc16(~0): data[%d]: %04x=%04x\n",i,csum1,data_crc0[i]);
+		if (csum1 != data_crc0[i]) {
+			printf("error: crc16(~0) for data[%d] should be %04x\n",
+			       i, data_crc0[i]);
+			exit(1);
+		}
+	}
+
+	csum1 = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum0000", &sb, 0, &desc);
+
+	if (csum1 != csum_known) {
+		printf("checksum for group 0 should be %04x\n", csum_known);
+		exit(1);
+	}
+	csum2 = ext2fs_group_desc_csum(&sb, 1, &desc);
+	print_csum("csum0001", &sb, 1, &desc);
+	if (csum1 == csum2) {
+		printf("checksums for different groups shouldn't match\n");
+		exit(1);
+	}
+	csum2 = ext2fs_group_desc_csum(&sb, 0xffff, &desc);
+	print_csum("csumffff", &sb, 0xffff, &desc);
+	if (csum1 == csum2) {
+		printf("checksums for different groups shouldn't match\n");
+		exit(1);
+	}
+	desc.bg_checksum = csum1;
+	csum2 = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum_set", &sb, 0, &desc);
+	if (csum1 != csum2) {
+		printf("checksums should not depend on checksum field\n");
+		exit(1);
+	}
+	if (!ext2fs_group_desc_csum_verify(&sb, 0, &desc)) {
+		printf("checksums should verify against gd_checksum\n");
+		exit(1);
+	}
+	memset(sb.s_uuid, 0x30, sizeof(sb.s_uuid));
+	print_csum("new_uuid", &sb, 0, &desc);
+	if (ext2fs_group_desc_csum_verify(&sb, 0, &desc) != 0) {
+		printf("checksums for different filesystems shouldn't match\n");
+		exit(1);
+	}
+	csum1 = desc.bg_checksum = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum_new", &sb, 0, &desc);
+	desc.bg_free_blocks_count = 1;
+	csum2 = ext2fs_group_desc_csum(&sb, 0, &desc);
+	print_csum("csum_blk", &sb, 0, &desc);
+	if (csum1 == csum2) {
+		printf("checksums for different data shouldn't match\n");
+		exit(1);
+	}
+
+	return 0;
+}
Index: e2fsprogs-1.39/lib/e2p/feature.c
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/feature.c
+++ e2fsprogs-1.39/lib/e2p/feature.c
@@ -45,7 +45,7 @@ static struct feature feature_list[] = {
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HUGE_FILE,
 			"huge_file" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
-			"gdt_checksum" },
+			"uninit_groups" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_DIR_NLINK,
 			"dir_nlink" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE,
Index: e2fsprogs-1.39/misc/mke2fs.8.in
===================================================================
--- e2fsprogs-1.39.orig/misc/mke2fs.8.in
+++ e2fsprogs-1.39/misc/mke2fs.8.in
@@ -210,7 +210,7 @@ for the filesystem.  (For administrators
 filesystems on RAID arrays, it is preferable to use the
 .I stride
 RAID parameter as part of the
-.B \-R
+.B \-E
 option rather than manipulating the number of blocks per group.)  
 This option is generally used by developers who
 are developing test cases.  
@@ -406,6 +406,13 @@ Store file type information in directory
 .TP
 .B has_journal
 Create an ext3 journal (as if using the
+.TP
+.B uninit_groups
+Create a filesystem without initializing all of the groups.  This speeds
+up filesystem creation time noticably, and can also reduce
+.BR e2fsck time
+dramatically.  This feature causes the filesystem to be read-only in
+older kernels is not supported in most Linux kernels, use with caution.
 .B \-j
 option).
 @JDEV@.TP
Index: e2fsprogs-1.39/e2fsck/util.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/util.c
+++ e2fsprogs-1.39/e2fsck/util.c
@@ -29,6 +29,10 @@
 #include <malloc.h>
 #endif
 
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
+
 #include "e2fsck.h"
 
 extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
@@ -534,3 +538,60 @@ int ext2_file_type(unsigned int mode)
 	
 	return 0;
 }
+
+#define STRIDE_LENGTH 8
+/*
+ * Helper function which zeros out _num_ blocks starting at _blk_.  In
+ * case of an error, the details of the error is returned via _ret_blk_
+ * and _ret_count_ if they are non-NULL pointers.  Returns 0 on
+ * success, and an error code on an error.
+ *
+ * As a special case, if the first argument is NULL, then it will
+ * attempt to free the static zeroizing buffer.  (This is to keep
+ * programs that check for memory leaks happy.)
+ */
+errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
+			     blk_t *ret_blk, int *ret_count)
+{
+	int		j, count, next_update, next_update_incr;
+	static char	*buf;
+	errcode_t	retval;
+
+	/* If fs is null, clean up the static buffer and return */
+	if (!fs) {
+		if (buf) {
+			free(buf);
+			buf = 0;
+		}
+		return 0;
+	}
+	/* Allocate the zeroizing buffer if necessary */
+	if (!buf) {
+		buf = malloc(fs->blocksize * STRIDE_LENGTH);
+		if (!buf) {
+			com_err("malloc", ENOMEM,
+				_("while allocating zeroizing buffer"));
+			exit(1);
+		}
+		memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
+	}
+	/* OK, do the write loop */
+	next_update = 0;
+	next_update_incr = num / 100;
+	if (next_update_incr < 1)
+		next_update_incr = 1;
+	for (j = 0; j < num; j += STRIDE_LENGTH, blk += STRIDE_LENGTH) {
+		count = num - j;
+		if (count > STRIDE_LENGTH)
+			count = STRIDE_LENGTH;
+		retval = io_channel_write_blk(fs->io, blk, count, buf);
+		if (retval) {
+			if (ret_count)
+				*ret_count = count;
+			if (ret_blk)
+				*ret_blk = blk;
+			return retval;
+		}
+	}
+	return 0;
+}
Index: e2fsprogs-1.39/resize/main.c
===================================================================
--- e2fsprogs-1.39.orig/resize/main.c
+++ e2fsprogs-1.39/resize/main.c
@@ -293,6 +293,13 @@ int main (int argc, char ** argv)
 		printf (_("Couldn't find valid filesystem superblock.\n"));
 		exit (1);
 	}
+
+	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		com_err(program_name, EXT2_ET_RO_UNSUPP_FEATURE,
+			":- uninit_groups");
+		exit(1);
+	}
+
 	/*
 	 * Check for compatibility with the feature sets.  We need to
 	 * be more stringent than ext2fs_open().
Index: e2fsprogs-1.39/tests/f_dupfsblks/expect.1
===================================================================
--- e2fsprogs-1.39.orig/tests/f_dupfsblks/expect.1
+++ e2fsprogs-1.39/tests/f_dupfsblks/expect.1
@@ -44,7 +44,8 @@ Salvage? yes
 Directory inode 12, block 3, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (12) has deleted/unused inode 32.  Clear? yes
+Entry '' in ??? (12) has a zero-length name.
+Clear? yes
 
 Directory inode 12, block 4, offset 100: directory corrupted
 Salvage? yes
Index: e2fsprogs-1.39/tests/f_uninit_last_uninit/expect.1
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/f_uninit_last_uninit/expect.1
@@ -0,0 +1,9 @@
+last group block bitmap uninitialized.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (9.1% non-contiguous), 105/10000 blocks
+Exit status is 0
Index: e2fsprogs-1.39/tests/f_uninit_last_uninit/expect.2
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/f_uninit_last_uninit/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (9.1% non-contiguous), 105/10000 blocks
+Exit status is 0
Index: e2fsprogs-1.39/tests/f_uninit_last_uninit/name
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/f_uninit_last_uninit/name
@@ -0,0 +1,2 @@
+last group has BLOCK_UNINIT set
+
Index: e2fsprogs-1.39/tests/f_uninit_last_uninit/script
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/f_uninit_last_uninit/script
@@ -0,0 +1,20 @@
+SKIP_GUNZIP="true"
+
+touch $TMPFILE
+$MKE2FS -N 32 -F -o Linux -O uninit_groups -b 1024 $TMPFILE 10000 > /dev/null 2>&1 
+$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+set_current_time 200704102100
+set_super_value lastcheck 0
+set_super_value hash_seed null
+set_super_value mkfs_time 0
+set_bg 1 flags 0x7
+set_bg 1 checksum calc
+q
+EOF
+
+E2FSCK_TIME=200704102100
+export E2FSCK_TIME
+
+. $cmd_dir/run_e2fsck
+
+unset E2FSCK_TIME
Index: e2fsprogs-1.39/tests/m_lazy/expect.1
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/m_lazy/expect.1
@@ -0,0 +1,158 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+32768 inodes, 131072 blocks
+6553 blocks (5.00%) reserved for the super user
+First data block=1
+16 block groups
+8192 blocks per group, 8192 fragments per group
+2048 inodes per group
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Writing inode tables: done                            
+Writing superblocks and filesystem accounting information: done
+
+Filesystem features: dir_index lazy_bg filetype sparse_super
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 28683/32768 files (0.0% non-contiguous), 115220/131072 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      dir_index lazy_bg filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              15852
+Free inodes:              4085
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:		  128
+Default directory hash:   tea
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Block bitmap at 3 (+2), Inode bitmap at 4 (+3)
+  Inode table at 5-260 (+4)
+  7919 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 274-8192
+  Free inodes: 12-2048
+Group 1: (Blocks 8193-16384) [Inode not init, Block not init]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Block bitmap at 8195 (+2), Inode bitmap at 8196 (+3)
+  Inode table at 8197-8452 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
+  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
+  Inode table at 16387-16642 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 3: (Blocks 24577-32768) [Inode not init, Block not init]
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Block bitmap at 24579 (+2), Inode bitmap at 24580 (+3)
+  Inode table at 24581-24836 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
+  Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
+  Inode table at 32771-33026 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 5: (Blocks 40961-49152) [Inode not init, Block not init]
+  Backup superblock at 40961, Group descriptors at 40962-40962
+  Block bitmap at 40963 (+2), Inode bitmap at 40964 (+3)
+  Inode table at 40965-41220 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
+  Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
+  Inode table at 49155-49410 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 7: (Blocks 57345-65536) [Inode not init, Block not init]
+  Backup superblock at 57345, Group descriptors at 57346-57346
+  Block bitmap at 57347 (+2), Inode bitmap at 57348 (+3)
+  Inode table at 57349-57604 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
+  Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
+  Inode table at 65539-65794 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 9: (Blocks 73729-81920) [Inode not init, Block not init]
+  Backup superblock at 73729, Group descriptors at 73730-73730
+  Block bitmap at 73731 (+2), Inode bitmap at 73732 (+3)
+  Inode table at 73733-73988 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
+  Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
+  Inode table at 81923-82178 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 11: (Blocks 90113-98304) [Inode not init, Block not init]
+  Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
+  Inode table at 90115-90370 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 12: (Blocks 98305-106496) [Inode not init, Block not init]
+  Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
+  Inode table at 98307-98562 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 13: (Blocks 106497-114688) [Inode not init, Block not init]
+  Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
+  Inode table at 106499-106754 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
+  Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
+  Inode table at 114691-114946 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 15: (Blocks 122881-131071)
+  Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
+  Inode table at 122883-123138 (+2)
+  7933 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 123139-131071
+  Free inodes: 30721-32768
Index: e2fsprogs-1.39/tests/m_lazy/script
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/m_lazy/script
@@ -0,0 +1,4 @@
+DESCRIPTION="lazy group feature"
+FS_SIZE=131072
+MKE2FS_OPTS="-O ^resize_inode,lazy_bg"
+. $cmd_dir/run_mke2fs
Index: e2fsprogs-1.39/tests/m_lazy_resize/expect.1
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/m_lazy_resize/expect.1
@@ -0,0 +1,166 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+32768 inodes, 131072 blocks
+6553 blocks (5.00%) reserved for the super user
+First data block=1
+Maximum filesystem blocks=67371008
+16 block groups
+8192 blocks per group, 8192 fragments per group
+2048 inodes per group
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Writing inode tables: done                            
+Writing superblocks and filesystem accounting information: done
+
+Filesystem features: resize_inode dir_index lazy_bg filetype sparse_super
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 28683/32768 files (0.0% non-contiguous), 77097/131072 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      resize_inode dir_index lazy_bg filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              53975
+Free inodes:              4085
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:		  128
+Default directory hash:   tea
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-516 (+260)
+  7662 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 531-8192
+  Free inodes: 12-2048
+Group 1: (Blocks 8193-16384) [Inode not init]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Reserved GDT blocks at 8195-8450
+  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
+  Inode table at 8453-8708 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 8709-16384
+  Free inodes: 
+Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
+  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
+  Inode table at 16387-16642 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 3: (Blocks 24577-32768) [Inode not init]
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24834
+  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
+  Inode table at 24837-25092 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 25093-32768
+  Free inodes: 
+Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
+  Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
+  Inode table at 32771-33026 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 5: (Blocks 40961-49152) [Inode not init]
+  Backup superblock at 40961, Group descriptors at 40962-40962
+  Reserved GDT blocks at 40963-41218
+  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
+  Inode table at 41221-41476 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 41477-49152
+  Free inodes: 
+Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
+  Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
+  Inode table at 49155-49410 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 7: (Blocks 57345-65536) [Inode not init]
+  Backup superblock at 57345, Group descriptors at 57346-57346
+  Reserved GDT blocks at 57347-57602
+  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
+  Inode table at 57605-57860 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 57861-65536
+  Free inodes: 
+Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
+  Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
+  Inode table at 65539-65794 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 9: (Blocks 73729-81920) [Inode not init]
+  Backup superblock at 73729, Group descriptors at 73730-73730
+  Reserved GDT blocks at 73731-73986
+  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
+  Inode table at 73989-74244 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 74245-81920
+  Free inodes: 
+Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
+  Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
+  Inode table at 81923-82178 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 11: (Blocks 90113-98304) [Inode not init, Block not init]
+  Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
+  Inode table at 90115-90370 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 12: (Blocks 98305-106496) [Inode not init, Block not init]
+  Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
+  Inode table at 98307-98562 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 13: (Blocks 106497-114688) [Inode not init, Block not init]
+  Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
+  Inode table at 106499-106754 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
+  Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
+  Inode table at 114691-114946 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 15: (Blocks 122881-131071)
+  Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
+  Inode table at 122883-123138 (+2)
+  7933 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 123139-131071
+  Free inodes: 30721-32768
Index: e2fsprogs-1.39/tests/m_lazy_resize/script
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/m_lazy_resize/script
@@ -0,0 +1,4 @@
+DESCRIPTION="lazy group feature with resize_inode"
+FS_SIZE=131072
+MKE2FS_OPTS="-O resize_inode,lazy_bg"
+. $cmd_dir/run_mke2fs
Index: e2fsprogs-1.39/tests/m_raid_opt/expect.1
===================================================================
--- e2fsprogs-1.39.orig/tests/m_raid_opt/expect.1
+++ e2fsprogs-1.39/tests/m_raid_opt/expect.1
@@ -46,57 +46,68 @@ Setting filetype for entry '..' in ??? (
 Directory inode 11, block 1, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1063.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 2, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1064.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 3, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1065.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 4, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1066.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 5, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1067.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 6, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1068.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 7, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1069.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 8, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1070.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 9, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1071.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 10, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1072.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Directory inode 11, block 11, offset 0: directory corrupted
 Salvage? yes
 
-Entry '' in ??? (11) has deleted/unused inode 1073.  Clear? yes
+Entry '' in ??? (11) has a zero-length name.
+Clear? yes
 
 Pass 3: Checking directory connectivity
 '..' in / (2) is <The NULL inode> (0), should be / (2).
Index: e2fsprogs-1.39/tests/m_uninit/expect.1
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/m_uninit/expect.1
@@ -0,0 +1,166 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+32768 inodes, 131072 blocks
+6553 blocks (5.00%) reserved for the super user
+First data block=1
+Maximum filesystem blocks=67371008
+16 block groups
+8192 blocks per group, 8192 fragments per group
+2048 inodes per group
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Writing inode tables: done                            
+Writing superblocks and filesystem accounting information: done
+
+Filesystem features: resize_inode dir_index filetype sparse_super uninit_groups
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32768 files (9.1% non-contiguous), 5691/131072 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      resize_inode dir_index filetype sparse_super uninit_groups
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              125381
+Free inodes:              32757
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:		  128
+Default directory hash:   tea
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-516 (+260)
+  7662 free blocks, 2037 free inodes, 2 directories, 2037 unused inodes
+  Free blocks: 531-8192
+  Free inodes: 12-2048
+Group 1: (Blocks 8193-16384) [Inode not init]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Reserved GDT blocks at 8195-8450
+  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
+  Inode table at 8453-8708 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 8709-16384
+  Free inodes: 
+Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
+  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
+  Inode table at 16387-16642 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 3: (Blocks 24577-32768) [Inode not init]
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24834
+  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
+  Inode table at 24837-25092 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 25093-32768
+  Free inodes: 
+Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
+  Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
+  Inode table at 32771-33026 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 5: (Blocks 40961-49152) [Inode not init]
+  Backup superblock at 40961, Group descriptors at 40962-40962
+  Reserved GDT blocks at 40963-41218
+  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
+  Inode table at 41221-41476 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 41477-49152
+  Free inodes: 
+Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
+  Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
+  Inode table at 49155-49410 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 7: (Blocks 57345-65536) [Inode not init]
+  Backup superblock at 57345, Group descriptors at 57346-57346
+  Reserved GDT blocks at 57347-57602
+  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
+  Inode table at 57605-57860 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 57861-65536
+  Free inodes: 
+Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
+  Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
+  Inode table at 65539-65794 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 9: (Blocks 73729-81920) [Inode not init]
+  Backup superblock at 73729, Group descriptors at 73730-73730
+  Reserved GDT blocks at 73731-73986
+  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
+  Inode table at 73989-74244 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 74245-81920
+  Free inodes: 
+Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
+  Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
+  Inode table at 81923-82178 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 11: (Blocks 90113-98304) [Inode not init, Block not init]
+  Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
+  Inode table at 90115-90370 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 12: (Blocks 98305-106496) [Inode not init, Block not init]
+  Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
+  Inode table at 98307-98562 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 13: (Blocks 106497-114688) [Inode not init, Block not init]
+  Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
+  Inode table at 106499-106754 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
+  Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
+  Inode table at 114691-114946 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 
+  Free inodes: 
+Group 15: (Blocks 122881-131071) [Inode not init]
+  Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
+  Inode table at 122883-123138 (+2)
+  7933 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
+  Free blocks: 123139-131071
+  Free inodes: 
Index: e2fsprogs-1.39/tests/m_uninit/script
===================================================================
--- /dev/null
+++ e2fsprogs-1.39/tests/m_uninit/script
@@ -0,0 +1,4 @@
+DESCRIPTION="uninitialized group feature"
+FS_SIZE=131072
+MKE2FS_OPTS="-O uninit_groups"
+. $cmd_dir/run_mke2fs

--KR/qxknboQ7+Tpez--
