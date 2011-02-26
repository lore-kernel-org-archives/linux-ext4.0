From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Add basic BIGALLOC support for cluster-based allocation
Date: Fri, 25 Feb 2011 21:50:24 -0500
Message-ID: <1298688625-19820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54484 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab1BZCu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 21:50:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds the superblock fields needed so that dumpe2fs works and the
code points and renames the superblock fields from describing
fragments to clusters.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/set_fields.c        |    4 ++--
 e2fsck/super.c              |   23 ++++++++---------------
 lib/e2p/feature.c           |    2 ++
 lib/e2p/ls.c                |   14 ++++++++++++--
 lib/ext2fs/ext2_fs.h        |   25 +++++++++++--------------
 lib/ext2fs/ext2fs.h         |    4 ++--
 lib/ext2fs/initialize.c     |   11 ++++-------
 lib/ext2fs/openfs.c         |    2 +-
 lib/ext2fs/swapfs.c         |    4 ++--
 lib/ext2fs/tst_super_size.c |    4 ++--
 misc/mke2fs.c               |   24 ++++++++++++++++--------
 11 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 3b40117..9d7099b 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -74,9 +74,9 @@ static struct field_set_info super_fields[] = {
 	{ "free_inodes_count", &set_sb.s_free_inodes_count, 4, parse_uint },
 	{ "first_data_block", &set_sb.s_first_data_block, 4, parse_uint },
 	{ "log_block_size", &set_sb.s_log_block_size, 4, parse_uint },
-	{ "log_frag_size", &set_sb.s_log_frag_size, 4, parse_int },
+	{ "log_cluster_size", &set_sb.s_log_cluster_size, 4, parse_int },
 	{ "blocks_per_group", &set_sb.s_blocks_per_group, 4, parse_uint },
-	{ "frags_per_group", &set_sb.s_frags_per_group, 4, parse_uint },
+	{ "clusters_per_group", &set_sb.s_clusters_per_group, 4, parse_uint },
 	{ "inodes_per_group", &set_sb.s_inodes_per_group, 4, parse_uint },
 	{ "mtime", &set_sb.s_mtime, 4, parse_time },
 	{ "wtime", &set_sb.s_wtime, 4, parse_time },
diff --git a/e2fsck/super.c b/e2fsck/super.c
index accc2f1..82c07b2 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -501,9 +501,12 @@ void check_super_block(e2fsck_t ctx)
 	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
 			  MIN_CHECK | MAX_CHECK, 0,
 			  EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
-	check_super_value(ctx, "log_frag_size", sb->s_log_frag_size,
-			  MIN_CHECK | MAX_CHECK, 0, sb->s_log_block_size);
-	check_super_value(ctx, "frags_per_group", sb->s_frags_per_group,
+	check_super_value(ctx, "log_cluster_size",
+			  sb->s_log_cluster_size,
+			  MIN_CHECK | MAX_CHECK, sb->s_log_block_size,
+			  (EXT2_MAX_CLUSTER_LOG_SIZE -
+			   EXT2_MIN_CLUSTER_LOG_SIZE));
+	check_super_value(ctx, "clusters_per_group", sb->s_clusters_per_group,
 			  MIN_CHECK | MAX_CHECK, sb->s_blocks_per_group,
 			  bpg_max);
 	check_super_value(ctx, "blocks_per_group", sb->s_blocks_per_group,
@@ -541,24 +544,14 @@ void check_super_block(e2fsck_t ctx)
 		}
 	}
 
-	if (sb->s_log_block_size != (__u32) sb->s_log_frag_size) {
+	if (sb->s_log_block_size != (__u32) sb->s_log_cluster_size) {
 		pctx.blk = EXT2_BLOCK_SIZE(sb);
-		pctx.blk2 = EXT2_FRAG_SIZE(sb);
+		pctx.blk2 = EXT2_CLUSTER_SIZE(sb);
 		fix_problem(ctx, PR_0_NO_FRAGMENTS, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
 
-	should_be = sb->s_frags_per_group >>
-		(sb->s_log_block_size - sb->s_log_frag_size);
-	if (sb->s_blocks_per_group != should_be) {
-		pctx.blk = sb->s_blocks_per_group;
-		pctx.blk2 = should_be;
-		fix_problem(ctx, PR_0_BLOCKS_PER_GROUP, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-
 	should_be = (sb->s_log_block_size == 0) ? 1 : 0;
 	if (sb->s_first_data_block != should_be) {
 		pctx.blk = sb->s_first_data_block;
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 9324199..16fba53 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -57,6 +57,8 @@ static struct feature feature_list[] = {
 			"extra_isize" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_QUOTA,
 			"quota" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_BIGALLOC,
+			"bigalloc"},
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 8b8360a..04a2c71 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -229,12 +229,22 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
 	fprintf(f, "First block:              %u\n", sb->s_first_data_block);
 	fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
-	fprintf(f, "Fragment size:            %u\n", EXT2_FRAG_SIZE(sb));
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+		fprintf(f, "Cluster size:             %u\n",
+			EXT2_CLUSTER_SIZE(sb));
+	else
+		fprintf(f, "Fragment size:            %u\n",
+			EXT2_CLUSTER_SIZE(sb));
 	if (sb->s_reserved_gdt_blocks)
 		fprintf(f, "Reserved GDT blocks:      %u\n",
 			sb->s_reserved_gdt_blocks);
 	fprintf(f, "Blocks per group:         %u\n", sb->s_blocks_per_group);
-	fprintf(f, "Fragments per group:      %u\n", sb->s_frags_per_group);
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+		fprintf(f, "Clusters per group:       %u\n",
+			sb->s_clusters_per_group);
+	else
+		fprintf(f, "Fragments per group:      %u\n",
+			sb->s_clusters_per_group);
 	fprintf(f, "Inodes per group:         %u\n", sb->s_inodes_per_group);
 	fprintf(f, "Inode blocks per group:   %u\n", inode_blocks_per_group);
 	if (sb->s_raid_stride)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f396a10..b4fc6d9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -98,18 +98,15 @@
 #define EXT2_ADDR_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s) / sizeof(__u32))
 
 /*
- * Macro-instructions used to manage fragments
+ * Macro-instructions used to manage allocation clusters
  */
-#define EXT2_MIN_FRAG_SIZE		EXT2_MIN_BLOCK_SIZE
-#define EXT2_MAX_FRAG_SIZE		EXT2_MAX_BLOCK_SIZE
-#define EXT2_MIN_FRAG_LOG_SIZE		EXT2_MIN_BLOCK_LOG_SIZE
-#ifdef __KERNEL__
-# define EXT2_FRAG_SIZE(s)		(EXT2_SB(s)->s_frag_size)
-# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_SB(s)->s_frags_per_block)
-#else
-# define EXT2_FRAG_SIZE(s)		(EXT2_MIN_FRAG_SIZE << (s)->s_log_frag_size)
-# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s) / EXT2_FRAG_SIZE(s))
-#endif
+#define EXT2_MIN_CLUSTER_LOG_SIZE	EXT2_MIN_BLOCK_LOG_SIZE
+#define EXT2_MAX_CLUSTER_LOG_SIZE	29	/* 512MB  */
+#define EXT2_MIN_CLUSTER_SIZE		EXT2_MIN_BLOCK_SIZE
+#define EXT2_MAX_CLUSTER_SIZE		(1 << EXT2_MAX_CLUSTER_LOG_SIZE)
+#define EXT2_CLUSTER_SIZE(s)		(EXT2_MIN_BLOCK_SIZE << \
+						(s)->s_log_cluster_size)
+#define EXT2_CLUSTER_SIZE_BITS(s)	((s)->s_log_cluster_size + 10)
 
 /*
  * ACL structures
@@ -518,9 +515,9 @@ struct ext2_super_block {
 	__u32	s_free_inodes_count;	/* Free inodes count */
 	__u32	s_first_data_block;	/* First Data Block */
 	__u32	s_log_block_size;	/* Block size */
-	__s32	s_log_frag_size;	/* Fragment size */
+	__s32	s_log_cluster_size;	/* Allocation cluster size */
 	__u32	s_blocks_per_group;	/* # Blocks per group */
-	__u32	s_frags_per_group;	/* # Fragments per group */
+	__u32	s_clusters_per_group;	/* # Fragments per group */
 	__u32	s_inodes_per_group;	/* # Inodes per group */
 	__u32	s_mtime;		/* Mount time */
 	__u32	s_wtime;		/* Write time */
@@ -675,6 +672,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
+#define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -688,7 +686,6 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 
-
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index cf76562..516eb1a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -195,7 +195,7 @@ struct struct_ext2_filsys {
 	char *				device_name;
 	struct ext2_super_block	* 	super;
 	unsigned int			blocksize;
-	int				fragsize;
+	int				clustersize;
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
 	struct ext2_group_desc *	group_desc;
@@ -545,7 +545,7 @@ typedef struct ext2_icount *ext2_icount_t;
  * to ext2fs_openfs()
  */
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
-#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(0)
+#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_BIGALLOC)
 
 /*
  * function prototypes
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index cba2453..c109d08 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -83,7 +83,6 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	ext2_filsys	fs;
 	errcode_t	retval;
 	struct ext2_super_block *super;
-	int		frags_per_block;
 	unsigned int	rem;
 	unsigned int	overhead = 0;
 	unsigned int	ipg;
@@ -136,7 +135,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	super->s_state = EXT2_VALID_FS;
 
 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
-	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
+	set_field(s_log_cluster_size, 0);
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, 0);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
@@ -179,14 +178,13 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	super->s_creator_os = CREATOR_OS;
 
 	fs->blocksize = EXT2_BLOCK_SIZE(super);
-	fs->fragsize = EXT2_FRAG_SIZE(super);
-	frags_per_block = fs->blocksize / fs->fragsize;
+	fs->clustersize = EXT2_CLUSTER_SIZE(super);
 
 	/* default: (fs->blocksize*8) blocks/group, up to 2^16 (GDT limit) */
 	set_field(s_blocks_per_group, fs->blocksize * 8);
 	if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
 		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
-	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
+	super->s_clusters_per_group = super->s_blocks_per_group;
 
 	super->s_blocks_count = param->s_blocks_count;
 	super->s_r_blocks_count = param->s_r_blocks_count;
@@ -239,8 +237,7 @@ retry:
 			/* Try again with slightly different parameters */
 			super->s_blocks_per_group -= 8;
 			super->s_blocks_count = param->s_blocks_count;
-			super->s_frags_per_group = super->s_blocks_per_group *
-				frags_per_block;
+			super->s_clusters_per_group = super->s_blocks_per_group;
 			goto retry;
 		} else {
 			retval = EXT2_ET_TOO_MANY_INODES;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index d638da0..a20b923 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -244,7 +244,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-	fs->fragsize = EXT2_FRAG_SIZE(fs->super);
+	fs->clustersize = EXT2_CLUSTER_SIZE(fs->super);
 	fs->inode_blocks_per_group = ((EXT2_INODES_PER_GROUP(fs->super) *
 				       EXT2_INODE_SIZE(fs->super) +
 				       EXT2_BLOCK_SIZE(fs->super) - 1) /
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 15ff6fc..52b0fa9 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -31,9 +31,9 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_free_inodes_count = ext2fs_swab32(sb->s_free_inodes_count);
 	sb->s_first_data_block = ext2fs_swab32(sb->s_first_data_block);
 	sb->s_log_block_size = ext2fs_swab32(sb->s_log_block_size);
-	sb->s_log_frag_size = ext2fs_swab32(sb->s_log_frag_size);
+	sb->s_log_cluster_size = ext2fs_swab32(sb->s_log_cluster_size);
 	sb->s_blocks_per_group = ext2fs_swab32(sb->s_blocks_per_group);
-	sb->s_frags_per_group = ext2fs_swab32(sb->s_frags_per_group);
+	sb->s_clusters_per_group = ext2fs_swab32(sb->s_clusters_per_group);
 	sb->s_inodes_per_group = ext2fs_swab32(sb->s_inodes_per_group);
 	sb->s_mtime = ext2fs_swab32(sb->s_mtime);
 	sb->s_wtime = ext2fs_swab32(sb->s_wtime);
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index a3a5b44..6fffcfd 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -50,9 +50,9 @@ void check_superblock_fields()
 	check_field(s_free_inodes_count);
 	check_field(s_first_data_block);
 	check_field(s_log_block_size);
-	check_field(s_log_frag_size);
+	check_field(s_log_cluster_size);
 	check_field(s_blocks_per_group);
-	check_field(s_frags_per_group);
+	check_field(s_clusters_per_group);
 	check_field(s_inodes_per_group);
 	check_field(s_mtime);
 	check_field(s_wtime);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a5cf16b..eace0d3 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -616,8 +616,13 @@ static void show_stats(ext2_filsys fs)
 	printf("\n");
 	printf(_("Block size=%u (log=%u)\n"), fs->blocksize,
 		s->s_log_block_size);
-	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
-		s->s_log_frag_size);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		printf(_("Cluster size=%u (log=%u)\n"),
+		       fs->clustersize, s->s_log_cluster_size);
+	else
+		printf(_("Fragment size=%u (log=%u)\n"), fs->clustersize,
+		       s->s_log_cluster_size);
 	printf(_("Stride=%u blocks, Stripe width=%u blocks\n"),
 	       s->s_raid_stride, s->s_raid_stripe_width);
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
@@ -634,8 +639,13 @@ static void show_stats(ext2_filsys fs)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
 		printf(_("%u block group\n"), fs->group_desc_count);
-	printf(_("%u blocks per group, %u fragments per group\n"),
-	       s->s_blocks_per_group, s->s_frags_per_group);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		printf(_("%u blocks per group, %u clusters per group\n"),
+		       s->s_blocks_per_group, s->s_clusters_per_group);
+	else
+		printf(_("%u blocks per group, %u fragments per group\n"),
+		       s->s_blocks_per_group, s->s_clusters_per_group);
 	printf(_("%u inodes per group\n"), s->s_inodes_per_group);
 
 	if (fs->group_desc_count == 1) {
@@ -1309,8 +1319,6 @@ static void PRS(int argc, char *argv[])
 					optarg);
 				exit(1);
 			}
-			fs_param.s_log_frag_size =
-				int_log2(size >> EXT2_MIN_BLOCK_LOG_SIZE);
 			fprintf(stderr, _("Warning: fragments not supported.  "
 			       "Ignoring -f option\n"));
 			break;
@@ -1542,7 +1550,7 @@ static void PRS(int argc, char *argv[])
 		check_plausibility(device_name);
 	check_mount(device_name, force, _("filesystem"));
 
-	fs_param.s_log_frag_size = fs_param.s_log_block_size;
+	fs_param.s_log_cluster_size = fs_param.s_log_block_size;
 
 	if (noaction && fs_param.s_blocks_count) {
 		dev_size = fs_param.s_blocks_count;
@@ -1780,7 +1788,7 @@ got_size:
 			inode_ratio = blocksize;
 	}
 
-	fs_param.s_log_frag_size = fs_param.s_log_block_size =
+	fs_param.s_log_cluster_size = fs_param.s_log_block_size =
 		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
 
 #ifdef HAVE_BLKID_PROBE_GET_TOPOLOGY
-- 
1.7.3.1

